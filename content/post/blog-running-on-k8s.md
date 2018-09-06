+++
title = "This Blog is Running on Kubernetes"
date = "2018-09-06"
categories = ["Projects"]
thumbnail = "img/kubernetes.png"
+++

I've avidly followed the [Kubernetes](https://kubernetes.io/) project since it
was the basis of my [undergraduate
thesis](https://github.com/mattjmcnaughton/thesis) in 2015. But despite all my
reading and [minikube](https://kubernetes.io/docs/setup/minikube/)
experimentation, I felt I was missing out the important lessons you can only
learn from using a technology to run real applications in production. I acutely
felt this pain when contributing code to the Kubernetes ecosystem, as I was able to fix bugs, but
didn't have knowledge and empathy around the production user's experience.

As of yesterday, I'm excited to that will no longer be the case.

<iframe src="https://giphy.com/embed/JFawGLFMCJNDi" width="480" height="260"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/mic-drake-hotline-bling-t-mobile-JFawGLFMCJNDi">via
GIPHY</a></p>

Over the weekend, I launched a Kubernetes cluster in AWS using
[kops](https://github.com/kubernetes/kops). Yesterday, I switched this blog
from running on a [dedicated host provisioned via
Ansible](https://github.com/mattjmcnaughton/ansible-blog) to [running on
Kubernetes](https://github.com/mattjmcnaughton/blog-on-k8s). Both my Kubernetes
cluster and blog deployment violate best practices left and right, but they are
serving traffic successfully!

I hope to write two introductory blog posts soon
that examine how to use kops to create a Kubernetes cluster and how to deploy a
simple static website onto Kubernetes.
With those two introductory blog posts providing the foundation, we can really
start having fun. On a notebook on my desk, I have a list of at least ten
potential improvements for the current blog application. Sample ideas include encrypting
traffic to this blog via
[cert-manager](https://github.com/jetstack/cert-manager/) or setting up
[horizontal pod autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/).
I also have ideas for improvements impacting the entire cluster, like setting up
centralized logging using the [ELK
stack](https://www.elastic.co/webinars/introduction-elk-stack) or putting a
sensible [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
in place. And we haven't even gotten into all the applications besides this blog
that I want to run on k8s. Tbh, I'm at Winnie the Pooh with a pot of honey levels of excitement!

<iframe src="https://giphy.com/embed/jKaFXbKyZFja0" width="480" height="407" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/jKaFXbKyZFja0">via GIPHY</a></p>

I hope to accompany these deployment and cluster improvements with both source
code and  deep-dive blog posts, so that anyone interested can have not only the what and how, but
also the why. If there's anything specific that you'd like covered,
please leave a comment :)
