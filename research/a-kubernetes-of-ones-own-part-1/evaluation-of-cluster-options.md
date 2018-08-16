# Evaluation of Cluster Options

- Start with options I'm definitely not going to pursue.
  - Kubernetes on bare metal. Greatest level of control, but expensive and
    onerous to set up.
  - Kubernetes "from scratch" on a cloud provider. Again, great level of control
    and cost effective, but difficult to set up. If Kelsey Hightower can't do
    it, can I?
  - Any of the Google options... my experience is with AWS.

- Options
  - kubeadm on bare metal
  - kops (either generating terraform or running directly)
  - Heptio Kubernetes CloudFormation template
  - Amazon EKS

