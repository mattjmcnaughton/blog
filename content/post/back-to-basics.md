+++
title = "Nuage: Back to Basics"
date = "2019-12-29"
categories = ["Projects"]
thumbnail = "img/back-to-basics.jpg"
+++

In my [last post](/post/upgrading-k8s-cluster-to-1-13-6), I discussed how I was
spending the majority of my non-work programming time focusing on Kubernetes
contributions, with a particular focus on
[sig/node](https://github.com/kubernetes/community/tree/master/sig-node).
Well, that statement is still true :) Hopefully, I'll find the time in 2020 to
blog more regularly about this work, but it's not what I'm going to share today.

## Introducing Nuage

<iframe src="https://giphy.com/embed/3o6Mbm7OcftGm770Hu" width="480"
height="366" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-4-the-simpsons-4x16-3o6Mbm7OcftGm770Hu">via
GIPHY</a></p>

Rather, I'm excited to post today about [Nuage](https://github.com/mattjmcnaughton/nuage).
Nuage is the name I've given to my project to manage all aspects of my personal
computing in the cloud.

Nuage's main goal is enabling understanding, and controlling, of every aspect of my
personal cloud computing. This goal is in reaction to a tension I felt with my
old Kubernetes cluster, which I managed via [Kops](https://github.com/kubernetes/kops).
Ultimately, I didn't feel I had the level of understanding or control
to feel as if I was truly _owning_ my self-hosted cluster.
I was relying too much on "magic" from Kops and also feeling restricted by some
of the imposed limitations (specifically the version of k8s I could run).

## So what?

So what exactly does the introduction of Nuage mean?

First, I've deprecated my [personal-k8s](https://github.com/mattjmcnaughton/personal-k8s/)
project and torn down my Kubernetes cluster.

Second, and as a direct result, this blog is now deployed via
[Terraform](https://www.terraform.io/) code defined in
[Nuage](https://github.com/mattjmcnaughton/nuage/tree/master/terraform/modules/blog).
The actual host, based on an AMI baked via [Packer](https://www.packer.io/),
is a simple nginx host serving the blog as a static site.

Don't worry, I'm not done with self-hosting Kubernetes :) I just have a new plan for
how I want to deploy/manage my personal cluster. At a high level, my plan is to use
[kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm/), in
conjunction with Packer/Terraform, to manage my Kubernetes cluster with finer-grained control.
This new method is still in the very early phrases, and progress may be slow
because contributing code to the actual Kubernetes project remains my main
focus. Still, I'm very excited :)

## Conclusion

Now y'all are up to date with my plans for self-hosting :) I'm looking forward
to lots of programming in 2020 and hope I have some exciting projects to share!

<iframe src="https://giphy.com/embed/ZW7GZxa37cuZi" width="480" height="360"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/80s-vintage-1980s-ZW7GZxa37cuZi">via GIPHY</a></p>
