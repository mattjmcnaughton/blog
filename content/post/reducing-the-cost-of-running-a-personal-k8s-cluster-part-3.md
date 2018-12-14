+++
title = "(Part 3) Reducing the Cost of Running a Personal k8s Cluster: Conclusion"
date = "2018-12-15"
categories = ["Projects"]
thumbnail = "img/reducing-cost-conclusion.jpg"
+++

## Overall impact

In parts [one](/post/reducing-the-cost-of-running-a-personal-k8s-cluster-part-1/)
and [two](/post/reducing-the-cost-of-running-a-personal-k8s-cluster-part-2/)
of this series, we sought to reduce our AWS
costs by optimizing our computing, networking, and storage expenditures. Since
this post is the final one in the series, let's consider how we did in
aggregate. Before any resource optimizations, we had the following bill:

```
master ec2 (1 m3.medium): (1 * 0.067 $/hour * 24 * 30) = 48.24
nodes ec2 (2 t2.medium): (2 * 0.0464 $/hour * 24 * 30) = 66.82
master ebs (1 64GB gp2): (1 * 64 * .1 $ per GB/month) = 6.40
nodes ebs (2 128GB gp2): (2 * 128 * .1 $ per GB/month) = 25.60
elb (1 classic) (1 * .25 $/hour * 24 * 30): 18.00
total: 165.06
```

After our resource optimizations, we have the following bill:

```
master ec2 (1 reserved instance m3.medium): ($33 per month) = 33.00
nodes ec2 (2 t2.medium): (2 * 0.0139 $/hour * 24 * 30) = 20.02
master ebs (1 30GB gp2): (1 * 30 * .1 $ per GB/month) = 3.00
nodes ebs (2 64GB gp2): (2 * 64 * .1 $ per GB/month) = 12.80
elb (1 classic) (1 * .25 $/hour * 24 * 30): 18.00
total: 86.82
```

In total, we save $78 a month. Our annual cost decreases from $1,980 to $1,041
for a savings of $938, or 48%! Not too bad at all!

<iframe src="https://giphy.com/embed/xNBcChLQt7s9a" width="480" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/win-xNBcChLQt7s9a">via GIPHY</a></p>

### Comparison to not using k8s

It's interesting to compare these costs to what we would pay if we wanted to run
multiple applications without using Kubernetes (i.e. just utilizing AWS
primitives like EC2 instances, ELBs, etc.).

Our current [personal-k8s roadmap](https://github.com/mattjmcnaughton/personal-k8s/projects)
includes at least three more applications (JupyterHub, NextCloud, GitLab) we want to run in addition to the
already running blog. In addition, we will want to run ElasticSearch
and Kibana for log aggregation and visualization, in addition to the already
running Prometheus, Alertmanager, and Grafana. In total, there are
eight distinct applications we either have deployed, or intend to deploy, over
the next couple of months.

Let's compare running these applications on Kubernetes vs running these
applications on bare AWS primitives purely with respect to cost. Let's assume we
ran each application on t2.micro instances, paying $9.50 a month for each EC2
instance.<sup><a href="#fn1">1</a></sup> For simplicities sake, let's assume
each node running an application has a 10GB EBS volume attached, which costs
$1 per month for each EC2 instance. Finally, we'll assume each node is assigned
an ElasticIP, which [has no cost](https://aws.amazon.com/premiumsupport/knowledge-center/elastic-ip-charges/)
provided the ElasticIP is attached to a node.

Overall, we have the following monthly costs:

```
application nodes (8 on-demand t2.micro): ($9.50 per month * 8) = $76.00
node storage (8 10GB EBS volumes): (.1 $ per GB/month * 10 * 8) = $8.00
total: $84.00
```

Our analysis above shows that once we commit to running multiple applications,
creating a Kubernetes cluster is a cost-neutral decision compared to utilizing
bare AWS primitives. And of course, running one's own Kubernetes cluster has
many other advantages with respect to gaining valuable experience, easier
maintenance and deployment, and it just being fun :)

## Retaining, and Extending, Cost Savings Over Time

We do not want this focus on minimizing our AWS bill to be a one time activity,
and to help ensure it isn't, we've put a couple different safeguards in place
which will help us retain, and potentially even expand, our savings.

First, we've checked our Kops configuration into [source
control](https://github.com/mattjmcnaughton/personal-k8s/blob/master/bootstrap/kops.yaml).
It can be seen below as of the time of this post:

<script src="https://gist.github.com/mattjmcnaughton/97bb0e2402c6fc11067b3309501e6b9f.js"></script>

We can now track changes to our Kubernetes resources exactly the same as we
track application changes. In addition, we have all the information we would
need to recreate our Kubernetes cluster with all cost savings in place.

Additionally, we've created a [recurring
ticket](https://github.com/mattjmcnaughton/personal-k8s/issues/12) to perform
resource optimization on our Kubernetes cluster. We plan to tackle this ticket
once a quarter, and we'll share any findings in a blog post. The ticket suggests
using the monitoring already in place to check things such as whether we can
decrease the size of the master/nodes' root volumes and whether we can decrease
resource allocations for certain pods. This
[design document](https://github.com/mattjmcnaughton/personal-k8s/blob/master/design/cost-optimization.md)
describes all of our guidelines to pay as little for our Kubernetes cluster as
possible, while still retaining "production" level performance.

Finally, as we have additional capacity, we will explore additional high-impact
cost-savings tools, and blog with any interesting findings. I'm particularly
interested in further researching [Cluster
Autoscaling](https://github.com/kubernetes/autoscaler/tree/master/cluster-autoscaler).

## Conclusion

We're done with our Reducing the Cost of Running a Personal k8s Cluster series
(find the first post [here](post/reducing-the-cost-of-running-a-personal-k8s-cluster-part-3/)).
Thank you for following along with me and I hope these cost savings made running
your own k8s cluster slightly more feasible!

<iframe src="https://giphy.com/embed/xTiTng7eyNZuXl7GzC" width="480"
height="192" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/hunger-games-good-luck-may-the-odds-be-in-your-favor-xTiTng7eyNZuXl7GzC">via
GIPHY</a></p>

<hr />

<sup id="fn1">1. The t2.micro offers 1 CPU and 1 GB of memory. Currently, we
haven't allocated any of our Kubernetes applications more than .5 CPU and 500MB
of memory, so we are safe assuming we can use t2.micro instances.
