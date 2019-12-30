+++
date = "2018-09-16T22:10:54-04:00"
title = "SLO"
+++

UPDATE: As of 2019-12-19, I no longer host this blog on my personal Kubernetes
cluster. In fact, I (temporarily) no longer have a personal k8s cluster.

As a result, I'm no longer actively focusing on this blog's SLO. When I stopped
running it on Kubernetes, I lost the monitoring/alerting I'd set up, and I don't
want to set it up in a non-k8s environment.

I'll still, of course, do my best to keep this blog up and running :) The
infrastructure ([code here](https://github.com/mattjmcnaughton/nuage/tree/master/terraform/modules/blog))
utilizes auto-scaling groups and load balancers, so should hopefully be quite
self-healing.

See [the git history](https://github.com/mattjmcnaughton/blog/commit/e9a7e8cdf6ceb0c8bf0db86a3e627b346c09eba5#diff-991ae77c17f7a1230b664002ec3a9912)
for what this SLO used to look like.
