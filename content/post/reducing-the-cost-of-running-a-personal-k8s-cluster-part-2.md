+++
title = "(Part 2) Reducing the Cost of Running a Personal k8s Cluster: Volumes and Load Balancers"
date = "2018-11-23"
categories = ["Projects"]
thumbnail = ""
draft = true
+++

- Add graphs/images/gifs/thumbnail
- We vs you
- Don't say master node => use nodes for workers
- Proofread

### Optimizing EBS volumes

  - EBS
    - Ensuring I actually needed the resources I allocated
    - Decrease resource requests (may try and decrease even further in the
      future).

### Optimizing ELB load balancers

- ELB
  - Restrict myself to one ELB
    - For now, will just be the service because I only have the one public
      service.
    - Going forward, it'll be a ingress point for all my personal services
      running on my Kubernetes cluster. Will only need one ELB endpoint.
