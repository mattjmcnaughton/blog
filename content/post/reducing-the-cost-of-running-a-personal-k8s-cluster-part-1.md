+++
title = "(Part 0) Reducing the Cost of Running a Personal k8s Cluster: EC2 Instances"
date = "2018-11-23"
categories = ["Projects"]
thumbnail = "img/money.jpg"
draft = true
+++

- Add graphs/images/gifs/thumbnail
- We vs you
- Don't say master node => use nodes for workers
- Proofread

## Introduction

## Optimizing EC2 instances

From our calculations above, we can see EC2 costs comprise the majority of our
Kubernetes cluster's AWS bill.

From our previous calculations, we spend $48 on the single m3.medium for our
master and $66 on our two t2.medium nodes, for a total of $114. The m3.medium
has 1 CPU and 4 GB of memory, while the t2.mediums combine to give us 4 CPU and
8GB memory.

We must first ensure our cluster actually needs all of these resources, as
the most blunt and effective cost-saving measure would be reducing the size of
our EC2 instances or, even better, deleting them entirely. Proving the default
Kops configuration overprovisioned our cluster is a necessary precursor to
confidently undertaking these actions.

### A brief detour into monitoring resource usage

TODO: Should this be a two part blog post?

Previously, our cluster did not offer macro insights into overall resource usage or micro
insights into the resource usage of each application we ran. Our first duty is
aggregating these macro and micro resource usage metrics and monitoring and alerting
based on their values.

We'll start with garnering micro insights into each application's resource
usage. By default, Kubernetes runs containers without any resource constraints,
meaning that, like a non-containerized process on a typical host, the processes
in the container can attempt to claim all of the node's CPU and memory. The lack
of resource constraints is not a large problem when you are only one or two
applications on your Kubernetes cluster. If you find your Kubernetes cluster low
on resources, you only have one or two culprits to investigate, and the negative
impact's of the service's runaway resource usage are constrained to one or two
applications. However, as soon as you start running a non-trivial number of
applications on your Kubernetes cluster, and it does not really make sense to
use Kubernetes if you're only running one or two applications, it becomes much
more important to understand the minimum and maximum amount of resources
allocated to each container and have confidence Kubernetes will enforce these
limits.

Fortunately, Kubernetes provides
[first class support](https://kubernetes.io/docs/concepts/configuration/manage-compute-resources-container/#resource-requests-and-limits-of-pod-and-container)
for containers specifying the minimum and maximum amount of
resources they require. Each container
can specify a `resource.request` and a `resource.limit` for both CPU and memory. A
pod calculates its resource request and resource limit by summing the resource
requests and limits for all its pods. A resource request is the minimum amount
of resources a pod needs to function. The Kubernetes scheduler will not schedule
a pod to a certain node unless the node can fulfill its resource request. The
limit is the maximum amount of resources a pod can consume. If the pod attempts
to use more CPU that its limit, it will be CPU throttled, and if it attempts to
use more memory than its limit, it will be terminated.

TODO: Add note that for simplicity I make the limit and the request equal.

We can see an example of
how to specify these values in the embedded manifest below.

EMBED MANIFEST

After ensuring all containers have a resource request/limit (see
[this commit](https://github.com/mattjmcnaughton/personal-k8s/commit/382be789d50f60a1a323cdf8a75fa53cbe213750)
for more details), we can trivially calculate the resources our cluster needs.
The master needs resources equal to the summation of all resource
requests/limits for all pods scheduled on the master, and the nodes need
resources equal to the summation of all resource requests/limits for all pods
scheduled on the nodes.

By allocating all of our pods a definite set of resources, we've transformed our
original question of "do we have an appropriate amount of resources for our
Kubernetes cluster" into two simpler questions: "is the sum of resources
allocated to each pod appropriately proportionate to the cluster's resources"
and "are our allocations of resources to pods accurate"?

The first question is easiest to answer. We can run
`kubectl describe node NODE_NAME | grep -A 5 "Allocated"` for details around
each node's resource allocation. Below we display a sample of the output for one
of our nodes. Note, the limits are lower than the requests, because some of the
pods Kubernetes schedules by default on all nodes (i.e. `kube-dns` and
`kube-proxy-ip-...`) do not specify resource limits.

INCLUDE PICTURE

Analyze the images.

- Now have two more tractable problems
  - Are the allocated machine resources appropriate for our pod requests/limits?
    - Addition...
    - Will fail to schedule pods if violate
      - Get set up alerting or even auto-provisioning (but not necessary until
        auto-scaling in place)
  - Are the pod requests/limits correct?
    - At a glance: metrics-server and `kubectl top pods`
    - In depth: Prometheus scraping kubelet
      - Monitoring dashboards
      - Prometheus alerts

- EC2
  - Ensuring I actually needed the resources I allocated
    - Resource requests/limits for each pod
    - Installing `metrics-server` and `node-exporter` and monitoring `kubelet`
      via Prometheus.
    - Discuss graphs/alerts
    - https://blog.freshtracks.io/a-deep-dive-into-kubernetes-metrics-part-3-container-resource-metrics-361c5ee46e66
  - Optimizing the cost of the actual EC2 instances I needed.
    - https://medium.com/@dyachuk/why-do-kubernetes-clusters-in-aws-cost-more-than-they-should-fa510c1964c6
    - Spot instances for worker nodes.
    - Convertible reserved instances for master.
      - Give me the flexibility to upgrade later if need be.
