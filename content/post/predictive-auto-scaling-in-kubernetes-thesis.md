+++
title = "Predictive Auto-scaling in Kubernetes - Thesis"
categories = ["Projects", "Deep Dives"]
date = "2016-05-28"
+++

Over the course of my final year at Williams College, I spent a lot of time
working on a distributed systems thesis with Professor Jeannie Albrecht. My
thesis is entitled "Predictive Pod Auto-scaling in the Kubernetes Container
Cluster Manager", and it is entirely open-source. The written portion,
presentation slides, and evaluation code can be found on my
[Github](https://github.com/mattjmcnaughton/thesis). Additionally, our
contributions to Google's open-source cluster container manager
[Kubernetes](http://kubernetes.io/) can be found on my
[fork](https://github.com/mattjmcnaughton/kubernetes/tree/add-predictive-autoscaling).
These changes will hopefully be merged into Kubernetes master branch soon.

In short, my thesis focused on adding predictive auto-scaling to Kubernetes.
Auto-scaling simply means allocating different amounts of resources to an
application as its external load changes. Previously, Kubernetes implemented
horizontal, reactive auto-scaling, meaning containerized applications were
replicated or destroyed based on the **current** resource utilization of the
application. The auto-scaler created and destroyed replica pods so as to ensure
each application maintained a certain desired level of resource utilization
(i.e. 60% CPU utilization). Our addition of predictive auto-scaling follows a
similar pattern, yet creates or destroys replica applications based on
**predicted** resource utilization. The interval of time required for a replica
pod to share in the computational work determines the interval into the
future for which we predict.

Working on this project was incredibly fulfilling and I'm so grateful to those
who made it possible.
