+++
title = "(Part 0) Reducing the Cost of Running a Personal k8s Cluster: Introduction"
date = "2018-11-23"
categories = ["Projects"]
thumbnail = "img/money.jpg"
+++

For the last couple of months, I've spent the majority of my non-work coding
time creating a [Kubernetes of my own](/post/a-kubernetes-of-ones-own-part-0/).
My central thesis for this work is that Kubernetes is
one of the best platforms for individual developers who want to self-host
multiple applications with "production" performance needs (i.e. hosting a blog,
a private Gitlab, a NextCloud, etc.). Supporting this thesis
requires multiple forms of evidence.

<iframe src="https://giphy.com/embed/BwP6oBTVT5oC4" width="480" height="366"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/neogaf-again-popgaf-BwP6oBTVT5oC4">via
GIPHY</a></p>

First, we need to show that deploying/maintaining
multiple different applications with Kubernetes is doable and enjoyable without quitting our
jobs and becoming full time sysadmins for personal projects.
Our previous blog posts on [deploying this blog via
Kubernetes](/post/hosting-static-blog-on-kubernetes/) and
[setting up monitoring and alerting](/post/slo-implementation-part-0/), as well
as much of the work outlined in [my personal k8s
roadmap](/post/personal-k8s-cluster-roadmap/) focus on deploying and maintaining
multiple different applications via Kubernetes, so I hope that we've
demonstrated, and will continue to demonstrate, Kubernetes' power and ease.

Equally importantly, but so far unexplored on this blog, we need to demonstrate we
can run a personal Kubernetes cluster without it breaking the
bank. If it cost, for example, $500 a month to run a personal Kubernetes
cluster, we're drastically reducing the segment of developers for whom
Kubernetes is an appealing tool. At minimum, we want to show choosing Kubernetes
is a cost-neutral decision, and at best, we'd like to show there economic
advantages to choosing Kubernetes instead of other comparable methods of
deploying applications.

As such, this blog series focuses on exploring Kubernetes' cost
effectiveness.<sup><a href="#fn1">1</a></sup>

## Where are we at?

<iframe src="https://giphy.com/embed/XCLBNof6ICAEM" width="480" height="363"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/seinfeld-newman-accountant-XCLBNof6ICAEM">via
GIPHY</a></p>

In [part 2](/post/a-kubernetes-of-ones-own-part-2/) of my series on creating a
Kubernetes cluster for personal usage, I outline the steps for creating a
Kubernetes cluster using [Kops](https://github.com/kubernetes/kops). The steps
outlined in that blog post do not derivate from Kops defaults, and as a result
we create a Kubernetes cluster with one m3.medium master and two t2.medium
nodes. The master has an attached 64GB gp2 EBS volume, and each node has an
attached 128GB gp2 EBS volume. Finally, the first application we hosted on
Kubernetes was our blog, which contained a LoadBalancer service, which in turn
creates an ELB.<sup><a href="#fn2">2</a></sup> Fortunately, almost
all the AWS resources created by Kubernetes/Kops have a `KubernetesCluster` tag,
which makes it relatively easy to use [AWS Cost
Explorer](https://aws.amazon.com/aws-cost-management/aws-cost-explorer/) to
examine all Kubernetes/Kops created resources.

In total, we have the following costs:

```
master ec2 (1 m3.medium): (1 * 0.067 $/hour * 24 * 30) = 48.24
nodes ec2 (2 t2.medium): (2 * 0.0464 $/hour * 24 * 30) = 66.82
master ebs (1 64GB gp2): (1 * 64 * .1 $ per GB/month) = 6.4
nodes ebs (2 128GB gp2): (2 * 128 * .1 $ per GB/month) = 25.6
elb (1 classic) (1 * .25 $/hour * 24 * 30): 18
total: 165.06
```

From this rough math, we're spending around $165 a month to run personal
Kubernetes cluster. If we run this cluster for 12 months,
we will end up spending around $2,000. That's a lot of money!

<iframe src="https://giphy.com/embed/xEp3raFQkgpgY" width="480" height="346"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/xEp3raFQkgpgY">via GIPHY</a></p>

Fortunately, we can take a number of cost optimization steps to decrease our AWS
bill. We identified three main types of AWS resources on which we're spending a
significant amount of money. In order of total cost, they are EC2 instances, EBS
volumes, and ELB load balancers. We will optimize each resource type
independently, beginning with our largest expense, EC2 instances, in the [next
blog post in the series](/post/reducing-the-cost-of-running-a-personal-k8s-cluster-part-1).
I can't wait to explore these cost-reduction solutions together,
in order to make running a personal k8s cluster accessible to as many developers as possible.

<iframe src="https://giphy.com/embed/xTiTnqUxyWbsAXq7Ju" width="400"
height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/yosub-money-donald-duck-cash-xTiTnqUxyWbsAXq7Ju">via
GIPHY</a></p>

<hr />

<sup id="fn1"> 1. As a note, some of the cost reduction ideas proposed by this series are enabled by our choice
of AWS as our cloud vendor. Its possible both that some tips we offer won't be
applicable to other vendors, and also that other vendors may have tips which
aren't applicable to AWS.</sup>

<sup id="fn2">2. I'm making the assumption that a personal Kubernetes
cluster will have at least one publicly available service.</sup>
