+++
title = "(Part 2) A Kubernetes of One's Own: Can We Build It? Yes We Can!"
date = "2018-09-10"
categories = ["Projects"]
thumbnail = "img/construction.jpeg"
+++

In my last [blog post](/post/a-kubernetes-of-ones-own-part-1), we outlined the
different methods of creating and maintaining a Kubernetes cluster, before
deciding on [Kops](https://github.com/kubernetes/kops). In this blog post,
we'll actually create the cluster using Kops. I'll provide source code and
instructions, so by the end of this post, you can have your own Kubernetes
cluster!

This tutorial is strongly based on Kops [AWS
tutorial](https://github.com/kubernetes/kops/blob/master/docs/aws.md), although
its even simplifier because I've written some generic terraform configurations
which simplify initial AWS configuration.

**Note, following this tutorial creates AWS resources that cost ~$100 a month.**

## Step 0: Prerequirements

This tutorial assumes that you have an AWS account in which we can launch our
Kubernetes cluster. Additionally, it assumes that you've installed
[kops](https://github.com/kubernetes/kops),
[kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/),
and [terraform](https://www.terraform.io/downloads.html).

It also assumes you've cloned my
[personal-k8s](https://github.com/mattjmcnaughton/personal-k8s) project onto
your local machine.

## Step 1: Decision Time and AWS setup

<iframe src="https://giphy.com/embed/l41YtfUCfOVUkiYcU" width="480" height="270"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/masterchef-chefs-home-cooks-masterchef-season-7-l41YtfUCfOVUkiYcU">via
GIPHY</a></p>

Before we can use Kops with AWS, we need to create the AWS resources Kops needs
to function. And before we can create the AWS resources Kops needs to function, we need to make
some decisions. Specifically, what is the domain in which we'll host all k8s
DNS, and in which s3 bucket should kops store its state.

With the answers to those questions in mind, you can follow the
[instructions](https://github.com/mattjmcnaughton/personal-k8s/tree/master/bootstrap#instructions)
section of
[personal-k8s/bootstrap](https://github.com/mattjmcnaughton/personal-k8s/tree/master/bootstrap).
The instructions indicate when you need to parameterize the existing code with
your preferred values.

Completing these instructions will create all the AWS resources that Kops needs,
meaning that we're now ready to create our Kubernetes cluster!

## Step 2: Create Your Cluster

<iframe src="https://giphy.com/embed/OMeGDxdAsMPzW" width="480" height="280"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/funny-OMeGDxdAsMPzW">via GIPHY</a></p>

We are now ready to create the Kubernetes cluster. Remember, before we undertake
any operation involving Kops, we want to run `source
/PATH/TO/personal-k8s/bootstrap/env.sh`, which will populate useful environment
variables.

Now, we can run the following command to perform the first step in creating our
Kubernetes cluster. Note, this command will create a cluster configuration, but
not yet generate any AWS resources.

```
kops create cluster --name=$NAME --state=$KOPS_STATE_STORE --zones=$AZ --ssh-public-key PATH_TO_YOUR_PUBLIC_KEY
```

This initial cluster configuration presumes a number of sensible defaults. You
can examine them all with the following command:

```
kops edit cluster --name=$NAME
```

[Kops documentation](https://github.com/kubernetes/kops/tree/master/docs)
provides instructions on modifying these default values, but for our initial use
case they should work perfectly. One important note is that by default, Kops
creates machines/DNS records that are publicly accessible. Kubernetes has additional
security mechanisms preventing unwanted access, so I'm comfortable with the
machines being initially publicly accessible. You will have to make
the decision of whether that's something with which you are comfortable. If not, Kops
does support using private DNS records and hosting machines in a private subnet. I
have not yet had the chance to experiment with them, but hope to in the future.

If you're happy with your cluster's configuration values, then we can instruct
Kops to create the physical resources.

```
kops update cluster ${NAME} --yes
```

Kops will perform a whole bunch of operations to create the Kubernetes cluster
on AWS. After these operations are complete, Kops will update your `~/.kube/config` file with
credentials for accessing the cluster. As a result, if you run `kubectl get
nodes`, you should see your cluster's nodes. Try launching a simple
[deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
to verify everything is working as expected.

```
kubectl run test-deployment --image=nginx --replicas=1
```

Running `kubectl get pods` should return a `test-deployment-SOME_UID` pod with
a status of `Running`.

## Step 3: Update Your Cluster

Kops provides easy tooling for updating your cluster. You can run `kops edit
cluster ${NAME}` to edit the cluster configuration, followed by `kops update
cluster ${NAME}` to preview the changes, and `kops update cluster ${NAME} --yes`
to apply them. See [Kops
documentation](https://github.com/kubernetes/kops/blob/master/docs/changing_configuration.md)
for more details.

Kops additionally provides the following useful command to ensure your cluster
is working as expected.

```
kops validate cluster
```

## Step Hopefully Never: Deleting Your Cluster

Hopefully you will continue to use this Kubernetes cluster forever, but should
you need to delete all of the AWS resources Kops created, Kops provides tooling
to do so.

First, run the following command to preview specifically what Kops will delete.

```
kops delete cluster --name ${NAME}
```

If you are comfortable deleting everything output in the previous command, you
can run the following command to delete your Kubernetes cluster.

```
kops delete cluster --name ${NAME} --yes
```

The [personal-k8s/bootstrap](https://github.com/mattjmcnaughton/personal-k8s/tree/master/bootstrap)
documentation provides instructions for deleting all of the AWS resources you
created to support Kops.

# Wrapping Up

<iframe src="https://giphy.com/embed/l2JJA5fbJ5o328Odi" width="480" height="258"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/cravetvcanada-funny-comedy-30-rock-l2JJA5fbJ5o328Odi">via
GIPHY</a></p>

Congrats, you did! You now have a Kubernetes cluster of your own running on AWS.
If you're looking for an application to start running on this cluster, a
static website (like a blog) is a great first choice... and coincidentally, my
next blog post will examine exactly that :)
