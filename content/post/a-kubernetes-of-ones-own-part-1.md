+++
title = "(Part 1) A Kubernetes of One's Own: I Can Haz Cluster?"
date = "2018-09-08"
categories = ["Projects"]
thumbnail = "img/shipping-container.jpeg"
+++

In my last [blog post](/post/a-kubernetes-of-ones-own-part-0), I hope I
convinced you why you should be creating your own Kubernetes cluster for
personal usage. Now, we can tackle the fun part of creating the cluster.

## What is a Kubernetes cluster?

<iframe src="https://giphy.com/embed/fAjPCZNOtmTLy" width="480" height="270"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/ineedthisforreactions-what-is-this-i-cant-even-gif-fAjPCZNOtmTLy">via
GIPHY</a></p>

We can start by answering the most important question: what is a Kubernetes
cluster? A Kubernetes cluster is a collection of physical resources
on which we run the Kubernetes container management software. Once we have a
Kubernetes cluster, we can use it to host applications, run batch workloads,
etc.

The methods for creating and managing a Kubernetes cluster fall into a couple of
distinct categories.

First, we have
[local-machine solutions](https://kubernetes.io/docs/setup/pick-right-solution/#local-machine-solutions).
In this model, we use our local workstations resources to run Kubernetes.
[Minikube](https://github.com/kubernetes/minikube) is the most popular example
of this pattern.

Second, we have
[hosted solutions](https://kubernetes.io/docs/setup/pick-right-solution/#hosted-solutions).
In this model, a cloud provider Google both provides the physical
resources and manages the Kubernetes software for us. Our job is purely
application specific configuration and code.

Third, we have [turnkey cloud
solutions](https://kubernetes.io/docs/setup/pick-right-solution/#turnkey-cloud-solutions),
which allow us to easily create a Kubernetes cluster on common cloud platforms
with only a couple commands. These turnkey solutions also often provide tooling
for managing the Kubernetes cluster once its running.
[kops](https://github.com/kubernetes/kops) is popular tooling supporting a
turnkey solution.

Fourth, we have [on-premises turnkey
solutions](https://kubernetes.io/docs/setup/pick-right-solution/#turnkey-cloud-solutions).
These solutions are similar to the turnkey cloud solutions, but instead of
creating a Kubernetes cluster in the public cloud (i.e. AWS, GCE), they create
it on your own internal cloud network.

Finally, for the truly bold, there are
[custom solutions](https://kubernetes.io/docs/setup/pick-right-solution/#custom-solutions),
which essentially leave all of the installation, configuration, and management
to the user.

<iframe src="https://giphy.com/embed/65os7odbIW6pa" width="480" height="296"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/finals-study-jason-bateman-65os7odbIW6pa">via
GIPHY</a></p>

Regardless of how we create the cluster, all Kubernetes clusters share foundational elements.
With respect to hardware, a cluster contains both a master node and a set of worker nodes.
With respect to software, it has six main components: API server, scheduler,
controller manager, kubelet, kube-proxy, and etcd. [Julia Evans](https://jvns.ca/about/)
has a [fantastic blog post](https://jvns.ca/blog/2017/06/04/learning-about-kubernetes/) which does a
much better job than I could explaining what these components do.

## What are our goals for our Kubernetes cluster?

<iframe src="https://giphy.com/embed/26BRQ09DUipJ63dEQ" width="480" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/cosplay-comic-con-sdcc2016-26BRQ09DUipJ63dEQ">via
GIPHY</a></p>

Because each method for creating a Kubernetes cluster has different strengths
and weaknesses, we need to think about what we value in the cluster creation and
maintenance process. At a high level, I have the following priorities in order
of importance:

1. Initial creation of the cluster should be painless. We want to start using
   Kubernetes now. We don't want to spend weeks and weeks wrestling with the
   cluster creation process.
2. The cluster creation and management process provides the right level of
   abstraction. Kubernetes clusters have many different knobs you can turn. I'd
   like access to these knobs, but I would also like them to start at sensible
   values.
3. I want to pay as little as possible.
4. Because I'm most familiar with AWS and use it professionally, I'd like to use
   a cluster creation process which supports AWS, but isn't necessarily
   restricted to AWS.

## Evaluating the options

With our valuation framework in place, we can start honing in on the perfect option
for us for creating a Kubernetes cluster.

Remember, Kubernetes offers local-machine, hosted, turnkey cloud, on-premises
turnkey, and custom solutions for creating a Kubernetes cluster. Since we want
our cluster to fulfill production use cases, local-machine solutions are not
feasible. Since we want to pay as little as possible and I don't have multiple
spare servers just lying around, on-premises turnkey solutions are out. And
since I want setting up the cluster to not be an absolute nightmare, custom
solutions are out.

After eliminating what won't work, we are left to decide between hosted and
turnkey cloud solutions. Considering our goal of using AWS as our cloud
provider, we are deciding between [Amazon EKS](https://aws.amazon.com/eks/) and
using [kops](https://github.com/kubernetes/kops) to create and manage our
Kubernetes cluster on AWS public cloud.

After some experimentation, I decided on Kops. Kops offers sensible defaults,
yet also fine grained control. Additionally, it imposes no costs beyond the AWS
resources it uses. And most importantly, from reading quick start documentation
for [EKS](https://aws.amazon.com/eks/getting-started/) and
[Kops](https://github.com/kubernetes/kops/blob/master/docs/aws.md), I felt more
confident I could successfully create a cluster and manage a cluster using
Kops than EKS.

<iframe src="https://giphy.com/embed/d2VNDNckZ1OQWbN6" width="480" height="366"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-4-the-simpsons-4x15-d2VNDNckZ1OQWbN6">via
GIPHY</a></p>

So that's it! I choose Kops for creating and managing our cluster! In the [next
blog post](/post/a-kubernetes-of-ones-own-part-2),
I'll walk you through all the steps you need to create your cluster.
Looking forward to it :)
