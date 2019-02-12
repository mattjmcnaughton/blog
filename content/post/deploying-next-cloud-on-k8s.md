+++
title = "Deploying Nextcloud on k8s"
date = "2019-02-12"
categories = ["Projects"]
thumbnail = "img/next-cloud.jpg"
+++

In our [last blog post](/post/saving-money-while-maintaining-performance-with-tolerations-on-k8s/),
we increased the stability of our Kubernetes cluster and also increased its
available resources. With these improvements in place, we can tackle deploying
our most complex application yet: [Nextcloud](https://nextcloud.com/). By the
end of this blog post, you'll have insight into the major architecture decisions we
made when deploying Nextcloud to Kubernetes. As always, we'll link the full
source code should you want to dive deeper.

## What is Nextcloud?

<iframe src="https://giphy.com/embed/JSueytO5O29yM" width="480" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/realitytvgifs-britney-spears-confused-funny-face-JSueytO5O29yM">via
GIPHY</a></p>

Before we investigate how we deployed Nextcloud, we need to know what it
actually is. Nextcloud has a great [website](https://nextcloud.com/#why-nextcloud)
which outlines its full capabilities and benefits, but at a high level, its an
"open source, self-hosted file share and communication platform." We will
use it to augment/replace uses of proprietary tools like Google Calendar,
Trello, etc. With respect to
[architecture](https://en.wikipedia.org/wiki/Nextcloud#Architecture), the
Nextcloud server is a web server written in PHP, and it can interact with several different
database management systems, including SQLite and PostgreSQL.

### Deploying Nextcloud to k8s from 1,000 feet

As Nextcloud is a web application, deploying Nextcloud to Kubernetes shares many
similarities with deploying this blog to Kubernetes, which is a process we
detailed quite thoroughly via this [blog post](post/hosting-static-blog-on-kubernetes/).
We need to deploy pods running a Nextcloud container and configure a service to
route traffic to these pods. Sounds simple enough, right? However, as we'll see
Nextcloud introduces some interesting wrinkles for which we need to account.

## Architecture Decisions when Deploying Nextcloud

<iframe src="https://giphy.com/embed/3oKIPlLZEbEbacWqOc" width="480"
height="360" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/reactionseditor-interesting-hmm-3oKIPlLZEbEbacWqOc">via
GIPHY</a></p>

Nextcloud presents a couple of interesting architectural challenges. First,
Nextcloud's current implementation relies on state written to the file system.
Second, our Nextcloud instance needs initialization commands executed
whenever we first deploy it. Finally, our
Nextcloud instance needs a database to which it can write persistent state.

### Deployment vs StatefulSet

As best we can tell, Nextcloud unfortunately is a stateful application.
Specifically, it relies upon a `config.php` with a username/password that it creates
during the initial installation process. Any additional Nextcloud container must have
this `config.php` file, or else Nextcloud thinks it needs to redo the
initial installation, which will fail. However, since Nextcloud itself creates this
file, we can't easily bind it as a read only volume on multiple pods.

We considered a couple different options. First, we considered creating a persistent
volume claim in the ReadWriteMany access mode, meaning we'd attach the volume containing
`config.php` to many pods. We could then use a StatefulSet resource to ensure
only one pod was initializing the `config.php`, and then all remaining pods
would see it already exists and understand they don't need to create it. Unfortunately,
this does not work because [EBS volumes cannot be bound in the ReadWriteMany
access mode](https://kubernetes.io/docs/concepts/storage/persistent-volumes/#access-modes).

Alternatively, we could generate the `config.php` file as a one-off job, store
it as a Kubernetes secret, and the attach it in read only mode to each pod.
This solution felt slightly too complex to be worth it at this time, though it
remains an option for the future.

Finally, we decided to limit our Nextcloud replicas to 1, and ensure
`config.php` was written to a persistent volume in the ReadWriteOnce access
mode. With this setup, we retain `config.php` if our Nextcloud pod is
terminated/killed, and don't have to do any complicated initialization steps.

We can revisit this decision if we discover there's a real need for multiple
Nextcloud pods.

### Manually Executing Commands on Boot

After our Nextcloud cluster is first created, we need to run some initialization
steps. Specifically, we need to create our personal user account and
enable/disable desired additional applications (i.e. Tasks, Calendar, etc).

We considered multiple options for executing this script.
First, we thought about creating a `Job` which
would be responsible for executing this script. We could then execute this `Job`
when necessary (and could gate its execution via a flag in `values.yaml`).
However, we ran into the same problem as before with the multiple replica pods
for Nextcloud. Our script needs `config.php` to execute, yet currently only one
pod can mount the volume containing `config.php`.

We also considered configuring our Nextcloud pod to run this script during its
init process. However, the commands in this script will only succeed once,
and we expect that the Nextcloud pod will be recreated multiple times through
its lifecycle. It felt like a bit of an anti-pattern to be continuously running a script we expect
to fail. Additionally, if we swallowed failures, there'd also be the risk that we'd miss an actual
legitimate failure.

For simplicities sake, we decided to just execute the script in the currently
running pod (with the `config.php`) and trust the user to remember to run it.
Considering the user cannot log in if they do not exec the script, there seems
to be a fairly small chance of them forgetting.

See the [README.md](https://github.com/mattjmcnaughton/personal-k8s/tree/master/applications/next-cloud)
for a more detailed description of how we expect the user to interact with the
script.

### Running the backing database

We also had to decide how to run the database Nextcloud needs to store all its
state.

The simplest option would have been using SQLite, which is what Nextcloud does
by default. We could have mounted a persistent volume to wherever SQLite writes
data, meaning loosing the Nextcloud pod would not cause data loss. However, we were fairly
concerned about how using SQLite would impact performance.
We felt we needed to use Postgres to get acceptable performance. Additionally, using
SQLite would've been an additional design decision which forced us to only use
one pod.

After deciding to use Postgres, we had two options: pay for a hosted Postgres
instance (i.e. [RDS](https://aws.amazon.com/rds/)) or self-host the database on
our Kubernetes cluster. We ultimately decided against RDS for multiple reasons.
First, it was non-trivially expensive, even if we utilized the smallest
database. Additionally, the support for creating a RDS database using Kubernetes
primitives wasn't as defined as we would like. Finally, we weren't sure if
introducing RDS would cause us to sacrifice dev/prod parity, as we're very
hesitant to pay for both a dev and a prod RDS database.

With these concerns in mind, we decided to at least attempt self hosting our
Postgres database on Kubernetes. We chose to deploy via the [Postgresql Helm
Chart](https://github.com/helm/charts/tree/master/stable/postgresql)
because we are already utilizing Helm as the basis for our deployments,
and Helm's dependency model allows us to specify the Postgresql chart as a
dependency of our Nextcloud chart.
Another option we considered was [kubedb](https://kubedb.com/), but we had
difficultly getting it to work with a couple hours of experimentation, and
ultimately decided to move on.

While we went with self-hosted Postgresql deployed via a Helm chart,
we imagine we'll revisit this decision in the future as both the technologies we
decided against mature.

## I can haz source code??

<iframe src="https://giphy.com/embed/JIX9t2j0ZTN9S" width="480" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/JIX9t2j0ZTN9S">via GIPHY</a></p>

All the design decisions we've discussed below are reflected in the
[source code](https://github.com/mattjmcnaughton/personal-k8s/tree/master/applications/next-cloud),
which is organized like a standard Helm chart.

## Future work and conclusion

In the interest of releasing MVPs, we deployed our Nextcloud application before
it had all of the functionality we could desire. We intend to add the
following features over the next couple of months, and have created the
following tickets to track them.

- [Monitor Nextcloud via Prometheus and track SLO](https://github.com/mattjmcnaughton/personal-k8s/issues/17)
- [Regular database backups for Nextcloud Postgres Database](https://github.com/mattjmcnaughton/personal-k8s/issues/18)
- [Expose Nextcloud on public internet, behind HTTPS](https://github.com/mattjmcnaughton/personal-k8s/issues/4)

It was exciting to deploy a more complex application like Nextcloud to our
Kubernetes cluster, and we look forward to continuing to improve our deployment
over time. We'll be sure to share updates as blog posts as we do.

<iframe src="https://giphy.com/embed/CWU5PaIvkyApi" width="480" height="360"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/happy-the-simpsons-excited-CWU5PaIvkyApi">via
GIPHY</a></p>
