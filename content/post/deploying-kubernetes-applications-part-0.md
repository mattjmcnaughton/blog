+++
title = "(Part 0) Deploying Kubernetes' Applications: The Problem"
date = "2019-01-10"
categories = ["Projects"]
thumbnail = "img/deploy-problem.jpg"
+++

Over the holiday break, I spent a lot of my leisure coding time rethinking the
way we deploy applications to Kubernetes. The blog series this post kicks off will explore how we
migrated from an overly simplistic deploy strategy to one giving us the
flexibility we need to deploy more complex applications. To ensure a solid foundation,
in this first post, we'll define
our requirements for deploying Kubernetes' applications and evaluate whether our
previous systems and strategies met these requirements (spoiler alert... it didn't).

# Requirements for how we deploy Kubernetes' applications

As we considered the applications (NextCloud, Gitlab, etc.)
we're hoping to deploy to Kubernetes in 2019, we realized they necessitated certain
functionality in our strategy for deploying Kubernetes' applications.

<iframe src="https://giphy.com/embed/4KFjJmTGav0QoE5WDk" width="480"
height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/4KFjJmTGav0QoE5WDk">via GIPHY</a></p>

To start, these applications would require different configuration when deploying to
development than when deploying to production. To reflect this reality, we must be able to
**write a manifest once, and deploy it in multiple environments with minimal
effort and duplication**. A simple example of this variance
is the creation of persistent volumes. In development, we want these to be 1GB
max, while in production they will be much larger.

In a similar vein, these applications are suitably complex that we want to be
able to **define multiple, tunable parameters and share them across all the
manifests comprising an application**.

Additionally, these applications will make substantial usage of secret values
(i.e. password for the Gitlab admin account), and we want **interactions with
secrets to be secure and simple**.

These complex applications also involve several different components (i.e. a web
application and a database). Our deployment strategy must support **grouping these components
together conceptually without unnecessary duplication and sharing variables between them**.

Finally, we want the ability to **leverage already existing community investments to deploy
applications via Kubernetes**. Constantly looking to learn from the community,
and utilize its solutions, will ensure our investments in Kubernetes are in
areas where we can contribute unique value.

And with these definitions, we know the rules to which our deployment strategies
and systems must conform.

<iframe src="https://giphy.com/embed/xUNd9XxgH9yjNIXyJa" width="480"
height="360" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/heyarnold-hey-arnold-nicksplat-xUNd9XxgH9yjNIXyJa">via
GIPHY</a></p>

# Our Previous system and its shortcomings

Before exploring the new system, we must explore the previous system and
understand where it fell short.

Our previous system for deploying Kubernetes' applications was about as simple
as it gets: write our Kubernetes manifests as static `.yaml` files and
then deploy them using `kubectl apply -f`.

<iframe src="https://giphy.com/embed/xUySTD7evBn33BMq3K" width="480"
height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/filmeditor-will-ferrell-elf-xUySTD7evBn33BMq3K">via
GIPHY</a></p>

Its pretty much what every "Intro to
Kubernetes" tutorial uses for deploying applications, and undoubtedly offers
advantages as it encourages direct interaction with Kubernetes, without any
potentially confusing abstractions. It is also helpful in that the template file in
source control maps directly to what is deployed on Kubernetes.

This deployment system worked fine for a while, as evidenced by the five or so
Kubernetes' applications we deployed using it. However, it definitely does not
fulfill the requirements we listed in the preceding section.

<iframe src="https://giphy.com/embed/26ybwvTX4DTkwst6U" width="480" height="360"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/the-simpsons-bart-simpson-at-least-you-tried-26ybwvTX4DTkwst6U">via
GIPHY</a></p>

Deploying static files with `kubectl apply -f` does not support changing
variables in the manifest based on the environment in which we're deploying the
application. For example, when running Prometheus in production, we want to create a StorageClass
specifying the use of Amazon EBS volumes of the gp2 type. When we were
defining said StorageClass via a
[static manifest file](https://github.com/mattjmcnaughton/personal-k8s/commit/ca34bddc14122294195b9e4008e9aecc1f4a9a44#diff-8bc00d67b069133eddc60560686bbf54),
it was cumbersome to ensure we didn't deploy it when deploying our
application to our dev Minikube cluster.

Additionally, with static files, we had no ability to specify which parts of the manifest were
"boilerplate" and which parts of the manifest were tunable parameters.
Application version, which is likely to change frequently over the applications
lifespan, was in the exact same file as volume mount paths which will likely
never be change. Similarly, we had no ability to share variables across the different manifests
used to deploy the different application components. For example, for many of our
applications, the `service-account.yaml` manifest would hard code the
ServiceAccount's `name` field, and then we would also need to hard code that
same value in the `deployment.yaml` manifest when indicating under which service
account the pod should run.

Secrets were in a similarly difficult position. We had no way to delineate all
secrets for an application in a singular file separated from other manifests, which we could easily exclude from
source control.

We also couldn't cleanly support applications with multiple related components.
For example, suppose we have two different web applications, and for each one we want to deploy a
web server component and a postgres component. If we're using only static files,
then we're replicating the postgres manifests in two different directories.
We also continue to struggle with our manifests for related components being
unable to share variables, which only grows more problematic as our applications
have more and more components with more and more complex relationships.

Finally, leveraging 3rd party applications when deploying static manifest files
leaves much to be desired. To leverage a community solution for deploying an
application, we just copy the static manifests into our own collection of
manifest files. However, when we do so, we take on the burden for ensuring these
static manifest files stay current and working. To compound the difficulty, we
must perform this maintenance without any form of versioning.

Disappointingly, our system of deploying static manifest files via `kubectl apply -f` fails to
meet pretty much all of our listed requirements.

# Conclusion

<iframe src="https://giphy.com/embed/1gUWdf8Z8HCxpM8cUR" width="480"
height="354" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/ariana-grande-thank-u-next-you-1gUWdf8Z8HCxpM8cUR">via
GIPHY</a></p>

From our analysis above, its clear that deploying Kubernetes' applications via
static manifest files will not scale to the more complex applications we hope to
tackle in the new year. In my next post, we'll explore the new strategy
we're using for deploying applications and how it meets our stated requirements.
