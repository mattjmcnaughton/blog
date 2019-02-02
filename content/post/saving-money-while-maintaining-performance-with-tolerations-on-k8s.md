+++
title = "Saving Money While Maintaining Performance With Tolerations on k8s"
date = "2019-02-01"
categories = ["Projects"]
thumbnail = "img/saving-money.jpg"
+++

In our [blog series](/post/reducing-the-cost-of-running-a-personal-k8s-cluster-part-0/)
on decreasing the cost of our Kubernetes cluster, we
suggested replacing [on-demand EC2 instances with spot instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/instance-purchasing-options.html)
for Kubernetes' nodes. When we first introduced this idea, we mentioned that
this strategy could have negative impacts on both our applications'
availability and our ability to monitor our applications' availability. At the
time, we still converted to spot instances because we believed the savings
benefits were worth the decrease in reliability. Excitingly, this blog post outlines
a strategy via which we can still decrease the cost we pay for our Kubernetes'
cluster, but not sacrifice important applications' availability, or our ability
to monitor our cluster or the applications running on it.

## The Problem with Spot Instances

Fundamentally, the issue with spot instances is that we can't guarantee that we
will always have them. One obtains spot instances by specifying a maximum bid.
You maintain the spot instance as long as the market price of a spot instance is
less than your maximum bid. However, if it rises above your spot instance,
Amazon will terminate your spot instance.

Unfortunately, there is no ceiling on the market price for spot instances. This
lack of ceiling is somewhat counterintuitive, as we would expect that the price
of an equivalent on-demand instance would serve as a ceiling. However, this
expectation rests on the assumption that no one will pay more for a spot
instance than they would for an equivalent on-demand instance. This assumption is
not a safe one to make. For example, imagine another spot instance market
participant is using spot instances to perform video encoding where each unit of
work takes 1hr. They seek confidence their in-progress work won't be
interrupted, so they would rather pay $5 an hour to retain their spot instance,
then $4 an hour for a new on-demand instance on which they would need to begin
their work from scratch.

In short, if we are utilizing spot instances, and cost considerations prevent
us from setting an incredibly high maximum bid, there will be times when
we cannot purchase spot instances. In practice, I've found these times to occur
approximately a couple of times a week for around 10 or so minutes. During these
windows, our Kubernetes cluster has no nodes on which to run pods.

<iframe src="https://giphy.com/embed/xTiTnGeUsWOEwsGoG4" width="480"
height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/problem-dilbert-pointy-haired-boss-xTiTnGeUsWOEwsGoG4">via
GIPHY</a></p>

## Impact on our k8s cluster

The lack of spot instances' impact on our Kubernetes cluster is direct; if we do
not have nodes, we cannot run any pods. In other words, our Kubernetes
cluster cannot perform any of its assigned functions, like hosting this blog.
To compound the issue, the nodes also run our Prometheus and Alertmanager
pods. We depend on these pods for alerts when either our Kubernetes cluster, or
the applications running on it, have issues. If they are also not executing,
because an inability to purchase spot instances caused us to have no
nodes, then there's no way to tell there's an ongoing issue. Overall, having no
nodes causes our cluster to completely stop functioning, and removes the
mechanism responsible for telling us when the cluster and its applications aren't working.

## The Solution

In certain use cases, short periods of cluster downtime, without corresponding
alerts, may be acceptable. In that case, its fine to use exclusively spot
instances for all nodes. However, downtime of this nature is not
acceptable for our personal Kubernetes cluster. Fortunately, there is a solution.

In our updated cluster, we transition from using exclusively spot instances for
our nodes, to using a combination of spot instances and on-demand
instances. More specifically, we classify all applications running on our
Kubernetes cluster as either "high availability" or "best effort". We then
purchase just enough on-demand instance computing resources to run our high
availability applications, while running all the best effort applications on our
spot instances. We know Amazon will never reclaim our on-demand instances, so
they do not have the same recurring downtime as our spot instances.

This more nuanced strategy gives us the best of both worlds. We save more money on EC2
resources than we would if we used only on-demand instances for our nodes,
and we enjoy better reliability thatn we would if we used only spot instances.

<iframe src="https://giphy.com/embed/5z0cCCGooBQUtejM4v" width="480"
height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/thedailyshow-funny-reaction-5z0cCCGooBQUtejM4v">via
GIPHY</a></p>

## The Implementation

Fortunately, Kubernetes and Kops provide primitives that make implementing the
strategy outlined above fairly trivial.

First, we need to update our Kubernetes' cluster configuration to now have three
different instance groups. We still have the `master-us-west-2a` instance group,
which is responsible for running our Kubernetes master. But now, instead of a
single instance group for the Nodes, we have two instance groups, one comprising
of on-demand instances and the other comprising of spot instances. As we can see
in the configuration file below, Kops allows us to specify how many machines we
want in each instance group. With this granular control, we can create just
enough on-demand instances to support our high availability applications, and
then utilize spot instances for the remainder of the computing resources needed
to run our best effort applications.

<script src="https://gist.github.com/mattjmcnaughton/a6d64e8a198ff1cd567571e1455b4f30.js"></script>

Our final task is determining how we ensure that high availability pods run on
our on-demand instance while best efforts run on our spot instances.
Fortunately, Kubernetes gives us control over this via the concepts of [Taints
and Tolerations](https://kubernetes.io/docs/concepts/configuration/taint-and-toleration/).

A taint is applied to a node. Once a taint is applied to a node,
the node knows not to accept any pods that do not
explicitly tolerate the taints. Whether a pod tolerates a taint or not is
controlled via the node specifying a toleration for taint in its spec.

Below, we can see an example of the taint we've applied to our spot instance
nodes.

```
taints:
  - type=spot-instance:NoSchedule
```

Pods will not be scheduled on all nodes with this taint, unless they have the
following toleration.

```
tolerations:
- key: "type"
  operator: "Equal"
  value: "spot-instance"
```

We can then apply this toleration to, for example, our best effort Grafana pod, but
not our high availability Prometheus pod. In doing so, we guarantee that all
high availability pods will run on our on-demand instances, which have better
reliability.

## Next Steps and Conclusion

Success! As the title promised, we've outlined a strategy which helps save
money while maintaining availability. After utilizing this on-demand/spot
instance split for a while, you can even decide to purchase a reserved instance
instead of an on-demand instance, unlocking even further savings.
See [our previous post](/post/reducing-the-cost-of-running-a-personal-k8s-cluster-part-1/)
for more discussion of converting on-demand instances to reserved instances.

After making the changes discussed in this post, our cluster now has the
reliability, and resources, to run our high availability NextCloud cluster, which is what we'll
be exploring in our next blog post. Thanks for reading!
