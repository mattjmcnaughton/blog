+++
title = "(Part 1) Deploying Kubernetes' Applications: The Solution"
date = "2019-01-29"
categories = ["Projects"]
thumbnail = "img/deploy-solution.jpg"
+++

TODO:
- Proofread

In the first blog post in [this
series](/post/deploying-kubernetes-applications-part-0/), we examined how our
previous deployment strategy of running `kubectl apply -f` on static manifests
did not meet our increasingly complex requirements for our strategy/system for deploying
Kubernetes' applications. In the second, and final, post in this mini-series,
we'll outline the new deployment strategy and how it fulfills our requirements.

# The new system

<iframe src="https://giphy.com/embed/xT5LMyJumn03ezhDvW" width="480"
height="362" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-16-the-simpsons-16x2-xT5LMyJumn03ezhDvW">via
GIPHY</a></p>

Our new deployment strategy makes use of [Helm](https://github.com/helm/helm),
a popular tool in the Kubernetes ecosystem which describes itself as "a tool
that streamlines installing and managing Kubernetes applications."

Helm manages "Charts", which are packages of templated Kubernetes resources. For example,
a Chart might comprise of Deployment, Service, and Ingress objects. When
interacting with a Chart, we specify variables, which help fill in the template of
our preconfigured Kubernetes' resources. Returning to our previous example, our
Chart might support specifying variable indicating the number of replica Pods the Deployment should
manage.

Once we've written a Chart, we can interact with it in a number of different
ways. If we deploy another part of Helm called [Tiller](https://docs.helm.sh/glossary/#tiller)
to our Kubernetes cluster, we can use the `helm` client to directly install
Charts on our cluster. See [this
tutorial](https://docs.bitnami.com/kubernetes/how-to/create-your-first-helm-chart/)
for an example of a workflow which relies on Tiller. Alternatively, we could use
the `helm template` command to generate yaml manifest files for the Kubernetes'
resources our chart defines. `helm template` allows us to specify the variables
for the manifest templates. We can then apply the output of `helm template` via
`kubectl apply -f`.

For example, to deploy our
[blog](https://github.com/mattjmcnaughton/personal-k8s/tree/master/applications/blog)
via this strategy, we can run the following:

```
helm template -f HELM-VARIABLE_FILE.yaml | kubectl apply -f -
```

While the former method utilizes more of Helm's functionality and abilities, we
decided on the latter method for a couple of different reasons. First, in the
`helm template` method, we don't need to perform the non-trivial task of
[securely installing](https://github.com/helm/helm/blob/master/docs/securing_installation.md)
Tiller on our cluster. Additionally, the latter method is less complex in that
we don't need to worry about how Tiller operates or how Helm manages "releases"
and "installs" of Charts. Rather, we can just use the `kubectly apply -f` tool
we are familiar with. Doing so retains our Git repo as the source of
truth. Finally, the [Helm 3 Design
Proposal](https://github.com/helm/community/blob/master/helm-v3/000-helm-v3.md)
gets rid of Tiller entirely, so it seems like there may be a benefit to waiting a
couple of months to get more insight and clarity on Tiller's role going forward. Nothing about choosing the
`helm template` option prevents us from pursuing the `tiller` option later
should we decide its beneficial.

## How our new system fulfills our requirements

With a good sense of our new deployment system, we can now evaluate whether it
meets our listed requirements.

<iframe src="https://giphy.com/embed/l4EpblDY4msVtKAOk" width="480" height="270"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/thenextstep-l4EpblDY4msVtKAOk">via GIPHY</a></p>

Our first requirement was that we must be able to
**write a manifest once, and deploy it in multiple environments with minimal
effort and duplication**. Our new system easily meets this requirement, as we
can easily use Helm's variables to write a manifest once, and then deploy it
with different variables depending on the environment. In practice, we define a
[helm-environments](https://github.com/mattjmcnaughton/personal-k8s/tree/master/applications/_helm-environments)
directory, and we then include
`_helm-environments/(development|production).yaml` every time we deploy an
application. In addition to setting other variables, these files set `environment=(development|production)`, and we can
then additionally use the `environment` variable to determine whether to include
certain manifest components. For example, we only want to create AWS specific
resources in production.

Our next requirement was that, since these applications are suitably complex, we want to be
able to **define multiple, tunable parameters and share them across all the
manifests comprising an application**. A Chart's function is to group multiple
manifests into a single application, and when we pass variables to the Chart,
they are available to all of the manifests. So this requirement is met.

An additional requirement is that we want **interactions with
secrets to be secure and simple**. In our new system, each Chart containing
secrets has two files: `secret-values.yaml` and `secret-values.yaml.sample`. The
former contains all the Charts' secrets and we include it with the `-f` flag whenever we run `helm
template`. It is not checked into source control. The
`secret-values.yaml.sample` contains just a list of the secrets we need to
define, not the actual values for those secrets. It is checked into source
control, as it doesn't contain any sensitive information. After cloning the repo
for the first time, we can convert `secret-values.yaml.sample` to
`secret-values.yaml` via a simple `envsubst` command, as described in our
Grafana deployment's
[README.md](https://github.com/mattjmcnaughton/personal-k8s/blob/master/applications/grafana/README.md).
With this strategy, our secrets are in one isolated location, and restricted to
the developer's local machines.

As a penultimate requirement, our deployment strategy must support **grouping a complex application's
components together conceptually without unnecessary duplication and sharing variables between them**.
For example, if we have a web app A and web app B, each of which require a
Postgres database, we should be able to deploy web app A with its uniquely
configured database and web app B with its uniquely configured database, yet
maintain only one source of truth for how we deploy a generic database. Helm
supports this grouping of application components via [Chart
Dependencies](https://docs.helm.sh/developing_charts/#chart-dependencies).

Finally, we require the ability to **leverage already existing community investments to deploy
applications via Kubernetes**. Helm easily supports this via their massive
[community repository](https://github.com/helm/charts) of Charts. We can either
deploy these Charts directly, or we can use them as a source of reference.

# Migrating from our old system to our new system

We convinced ourselves of this new deployment system's merit. But, we still
needed to convert all of our [personal-k8s
applications](https://github.com/mattjmcnaughton/personal-k8s/tree/master/applications) to use the new deployment strategy.

<iframe src="https://giphy.com/embed/14wXMGbHjXK2k0" width="480" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/boy-adventure-14wXMGbHjXK2k0">via GIPHY</a></p>

Fortunately, the process for doing so was fairly trivial, and only requires
the following steps:

1. Create the helm chart with `helm create APP_NAME`.
2. Copy over the static manifests from the old deployment strategy into the
   `templates` directory in the Chart.
3. Extract out variables/secrets into `values.yaml` and `secret-values.yaml`
   respectively.
4. Deploy the application and ensure nothing meaningful changed.

For a more hands on example,
this [diff](https://github.com/mattjmcnaughton/personal-k8s/commit/b74a4502e294ca6caef0d6633151a5fc9a288273)
shows an example of the work required to migrate Grafana from the old deployment
system to the new deployment system.

# Guidelines for our new system

<iframe src="https://giphy.com/embed/liz1CsrJ5cF5m" width="480" height="262"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/haters-teen-titans-go-liz1CsrJ5cF5m">via
GIPHY</a></p>

We used the development of our new deployment strategy as an opportunity to add
more formal guidelines around using Helm to deploy an application to our k8s
cluster. For example, we want all of our Kubernetes objects to share common label keys for the
concepts of Name, Environment, etc. You can see
the entire list of guidelines in the [design
docs](https://github.com/mattjmcnaughton/personal-k8s/blob/master/design/helm-deploy.md).
Formally listing these guidelines helps us ensure we continue to deploy
applications in a uniform manner, which only increases in importance as we
deploy more and more applications.

# Conclusion

To summarize, in [part 0](post/deploying-kubernetes-applications-part-0/), we
outlined our requirements for deploying our increasingly complex
applications on Kubernetes and verified our previous system of deployment failed
to meet these requirements. In this blog post, we outlined our new system for
deploying applications, and verified that it met all of our requirements. We
then briefly discussed the process of migrating all of our applications from the
old system to the new system, and how we will preserve cohesion in the new
system going forward. I'm looking forward to utilizing this new deployment
system to deploy some exciting new applications. And in fact, an upcoming blog
post will discuss how we deployed [NextCloud on our Kubernetes
cluster](https://github.com/mattjmcnaughton/personal-k8s/tree/master/applications/next-cloud), which
would've been substantially more difficult with our old deployment strategy.
Looking forward to it!

P.S. My apologies for the delay since my last post. I took a little
break from Kubernetes and blogging to code
my way through [Writing An Interpreter In Go](https://interpreterbook.com/). I
just wrapped up the last chapter yesterday, so hopefully I'll return to a
more frequent cadence going forward.
