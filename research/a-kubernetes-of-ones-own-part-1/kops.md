# kops

- Billed as the easiest way to get a production grade Kubernetes cluster up and
running.
  - Officially supports AWS.
- Automates provisioning of Kubernetes clusters in AWS.
  - Can deploy Highly Available Kubernetes Masters.
- Supports dry run mode, and also generating terraform, which the user can then
  apply.
- Clear tutorial: https://github.com/kubernetes/kops/blob/master/docs/aws.md
  - Requires some previous setup before beginning: i.e. create IAM role, S3
    bucket, and DNS records in Route 53.

- Bring up cluster using terraform/kops.

- With kops, test:
  - Creating the cluster.
  - Bringing up a new node/removing a node.
  - Upgrading the Kubernetes version.
  - Adding an add on.
  - Tearing down the cluster.
