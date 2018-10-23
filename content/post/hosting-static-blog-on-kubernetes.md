+++
title = "Hosting Static Blog on Kubernetes"
date = "2018-09-15"
categories = ["Projects"]
thumbnail = "img/static-site.jpg"
+++

In my [last three blog posts](/post/a-kubernetes-of-ones-own),
we focused on creating a Kubernetes cluster you can
use for your own personal computing needs.
But what good is a Kubernetes cluster if we're not using it to run applications? Spoiler
alert, not much.

Let's make your Kubernetes cluster worth the cash you're paying
and get some applications running on it.
In this post, we'll walk through deploying your first application to Kubernetes:
a static blog.

A static blog makes for a perfect first application because
it is dead simple. We can focus entirely on writing Kubernetes configuration
and won't need to worry about application logic.

A static website like a blog also has commonly accessible
metrics for measuring success: request response time and uptime. In a later blog
post, we'll establish an
[SLO](https://landing.google.com/sre/book/chapters/service-level-objectives.html)
for these metrics and add monitoring to ensure
we're meeting our SLO. We'll also measure how any changes to this application's
code or Kubernetes' configuration impacts these metrics.

Finally, its easy to customize a static blog for
your own use case. While I doubt you'll want to host this specific blog on your
Kubernetes cluster (unless you want to help me out with hosting :P),
it is trivial to swap out a container image serving my blog
with a container image serving your blog (or any other static website).
The Kubernetes configuration will stay almost exactly the same.

<iframe src="https://giphy.com/embed/ukCFEU6Cg5MCCDoaVN" width="480"
height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/netflix-love-happy-ukCFEU6Cg5MCCDoaVN">via
GIPHY</a></p>

## Some Background

With our goal in place, we can start thinking about what Kubernetes components
we must define to robustly serve our static website. Our initial use case
requires only two high level Kubernetes components: a deployment and a service.
A [deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
is the recommended method for declaring a desired collection of
pods. A [pod](https://kubernetes.io/docs/concepts/workloads/pods/pod/)
is the smallest deployable unit of computing that Kubernetes creates
and manages. Its a group of one or more containers with shared storage/network.
For this application, our pods consist of a single nginx container which is
responsible for serving our static site on port 80.

A [service](https://kubernetes.io/docs/concepts/services-networking/service/)
is an abstraction by which Kubernetes provides a consistent way to access a set
of pods. A service is necessary because pods are ephemeral. You should never
communicate with a specific pod, because it could be restarted, moved, or killed
at any minute.

If your completely new to Kubernetes, see
[these](https://www.katacoda.com/courses/kubernetes/kubectl-run-containers)
[great](https://www.katacoda.com/courses/kubernetes/creating-kubernetes-yaml-definitions)
[tutorials](https://www.katacoda.com/courses/kubernetes/guestbook) from
[Katacoda](https://www.katacoda.com/) for some foundational hands on experience.

## Let's Do It!

<iframe src="https://giphy.com/embed/3aGZA6WLI9Jde" width="480" height="336"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/fox-debate-jv-3aGZA6WLI9Jde">via GIPHY</a></p>

We can now start writing your Kubernetes configuration files. There are many
fancy ways to create Kubernetes configuration, but for now, we'll keep
everything simple with vanilla yaml. Create a file called `bundle.yaml` and add the
following:

<script
src="https://gist.github.com/mattjmcnaughton/d150aa40da336ba40f2173ed1ca99de3.js"></script>

This code block tells Kubernetes there should be a deployment named `blog`,
which consists of two pods with the label `app: blog`. The deployment should
construct these pods via a template. This template specifies the pods contain
an instance of the `YOUR_IMAGE_HERE` container image and expose port 80.
Be sure to replace `YOUR_IMAGE_HERE` with the name of your container image.
For this example to work properly, a container running from your container image should
serve your static site on port 80. This blog uses the
`docker.io/mattjmcnaughton/blog` container image. Here's the
[Dockerfile](https://github.com/mattjmcnaughton/blog/blob/master/Dockerfile).
Please leave a comment if you would like a tutorial on constructing the
container image.

We've configured the deployment. Now we just need to add the following section
to configure the service:

<script
src="https://gist.github.com/mattjmcnaughton/bd0064e174180671b71e5d45e8498e36.js"></script>

This section of the code tells Kubernetes there should be a service named
`blog`. The service has the type
[LoadBalancer](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/),
which means Kubernetes allows access to the specified set of pods via an
external load balancer provided by our cloud provider. For AWS, Kubernetes will
create an [ELB](https://aws.amazon.com/elasticloadbalancing/)
and route all inbound traffic accessing the ELB to the pods matched by
our service's selector. Our service selects all pods with the tag `app: blog`.
Finally, we instruct our service to forward port 80 on the load balancer to port
80 on the pod.

Finally, run `kubectl apply -f bundle.yaml`, which instructs Kubernetes to perform
the actions necessary such that the objects defined in `bundle.yaml` exist.
Congrats, you're running an application on Kubernetes!

<iframe src="https://giphy.com/embed/3o7abIZJKIhfhvqfHq" width="480"
height="306" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/hailstate-mississippi-state-hail-3o7abIZJKIhfhvqfHq">via
GIPHY</a></p>

After waiting a minute or two, run `kubectl get deployments`. You should see a
deployment named `blog` with a `DESIRED` value of 2, and a `CURRENT` value
between 0 and 2, depending on how many pods the deployment has finished creating
from the template. To see these pods, run `kubectl get pods`. You should see two pods
named `blog-SOME_UID` with a `STATUS` of `Running`.

Next, run `kubectl get svc`.
You should see a service named `blog` with an `EXTERNAL-IP`. If you
navigate to that `EXTERNAL-IP`, you should see your website. You'll likely want
to setup some additional DNS to direct requests to `YOUR_HOSTNAME` to this
external IP address. For now, we'll manage this outside of Kubernetes, so I'll
leave it to you to do implement this configuration however works best for you. I
use an [A record and an Alias Target in Route 53](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-to-elb-load-balancer.html).

## Looking to the Future

Again, congratulations! You now have a "production" application running via
Kubernetes. Right now, its very simple and fails to take advantage of much of
what makes Kubernetes and Cloud Native interesting and special. But, that's just
for now. In future blog posts, I hope to explore a whole bunch of
extensions and enhancements to this simple project. Just off the top of my head,
I have the following ideas:

1. Create a [Helm](https://github.com/helm/helm) chart for this application, and
   use Helm for deployment. This change allows you all to reuse this work without
   having to manually edit yaml files with your personal values. It also
   supports a more robust deploy process then updating a static file and running
   `kubectl apply`.
2. Define an SLO for our static site based on our twin objectives of low
   response time and high uptime. Add application monitoring to ensure our
   static site continuously meets said SLO.
3. Properly configure
   [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) for
   this application, ensuring it has the least possible permissions necessary to
   function. Verify our success with a tool like
   [kube-hunter](https://github.com/aquasecurity/kube-hunter)
4. Add centralized logging to provide easy visibility into any potential issues.
5. Enable SSL connections to our static site via Let's Encrypt.
6. Create a CI/CD pipeline for testing (i.e. container image
   vulnerability scanning, static analysis, etc.), and deploying our
   application.

While we'll most likely use this static site as the basis for these
explorations, the majority of the learnings will be applicable to any
application you deploy on Kubernetes.

If there are any additional topics you'd like me to cover, please leave a
comment! Additionally, any feedback on my already existing Kubernetes blog posts
would be greatly appreciated, specifically around the level of specificity. Am I
explaining too much? Too little? Looking forward to hearing from you and
looking forward to continuing to experiment with Kubernetes and Cloud Native together.

<iframe src="https://giphy.com/embed/l1J3CbFgn5o7DGRuE" width="480" height="309"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/goodbye-see-ya-you-l1J3CbFgn5o7DGRuE">via
GIPHY</a></p>
