+++
title = "Upgrading k8s cluster to 1.13.6"
date = "2019-06-22"
categories = ["Projects"]
thumbnail = "img/1-13-6-upgrade.jpg"
+++


Since I last posted, I've been focusing almost all of my "fun coding" time on
contributing to the Kubernetes code base. You can see my contributions on my
[Github](https://github.com/mattjmcnaughton). I've been particularly focusing on
the components of the code base owned by
[sig/node](https://github.com/kubernetes/community/tree/master/sig-node). It's
been rewarding and a great learning experience... but it does mean I haven't
been focusing on adding features to my personal Kubernetes cluster. And since
that's what I mainly blogged about, it also means I've been blogging less. While
I hope to blog more about my k8s contributions in the future, I currently feel I
should be 100% focused on writing and reviewing code.

However, while I'm not actively developing on my Kubernetes cluster, I still
need to ensure I'm using a supported version without any known security issues.
In [this blog post](post/update-schedule-for-k8s-cluster/), I outlined my
schedule for upgrading my cluster and also promised to blog about the process.
So I'm back posting :)

<iframe src="https://giphy.com/embed/5mYwgGvIR2GN2g0ZZj" width="480"
height="258" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/snl-saturday-night-live-season-44-5mYwgGvIR2GN2g0ZZj">via
GIPHY</a></p>

In this blog post, I'll talk about my experience upgrading my Kubernetes cluster
from 1.12.7 to 1.13.6.

## Upgrade schedule

In the aforementioned previous blog post, we outlined our cluster upgrade policy
as the following:


> If there is a patch release to address a security vulnerability, we will apply it immediately...
> Otherwise, we will check at the start of each month for if there is a new patch
> release for our minor version, and will apply it if so. On a quarterly cadence,
> we will check if there is a new minor version release, and update if
> necessary to ensure we are using one of the three latest minor versions.


Currently, our cluster is running 1.12.7. Recently, k8s announced
[CVE-2019-11246](https://groups.google.com/forum/#!topic/kubernetes-dev/OxFMDVnqk60), which impacts
all 1.12.x clusters below 1.12.9. So we need to upgrade to at least 1.12.9.

However, with release of of k8s 1.15 this week, 1.12 is moving out of support window (i.e.
1.12.10 will be the last patch release). As a result, we decided to upgrade to 1.13.x. We
need to upgrade to 1.13.6 to get the fix for the previously mentioned CVE.

As a reminder, because we use [kops](https://github.com/kubernetes/kops) to manage our cluster, Kops
[support for different minor versions](https://github.com/kubernetes/kops#kubernetes-version-support)
dictates which minor versions we can use. Kops 1.13 is in beta, and I feel
comfortable using it to deploy our cluster. However, Kops 1.14 is still in
alpha, so I'm not yet comfortable using it, and thus we're blocked from
upgrading all the way to 1.14.x. So 1.13.6 it is!

## Upgrade experience

Overall, the upgrade experience was smooth! At this point, the 1.13.x release
has been out for a long time and is pretty stable. Furthermore, the
[new functionality added in
1.13](https://kubernetes.io/blog/2018/12/03/kubernetes-1-13-release-announcement/) does not
have a substantial impact on the applications running on our cluster nor on the
way we manage our cluster.

In the past when we ran `kops rolling-upgrade`, we've had issues with stale DNS
records causing workers to try and contact the old master instead of the new
master. To address these issues, we doubled both the timeouts we wait after
terminating a machine and the amount of time we allow kops to attempt
verification. This migration did not experience DNS staleness issues, although
we can't be positive it was because of the increased timeouts and not a kops
bugfix.

Overall, a smooth migration!

<iframe src="https://giphy.com/embed/A6aHBCFqlE0Rq" width="480" height="360"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/the-simpsons-swag-homer-simpson-A6aHBCFqlE0Rq">via
GIPHY</a></p>

## Future plans

While I don't have any concrete plans, I'm thinking about no longer using Kops
to deploy my cluster, and instead using Kubeadm and Packer/Terraform to build/deploy
machines. My work with sig/node has lead to the desire for less abstractions
between the k8s cluster and myself. Also, if I was using kubeadm, I'd be
able to use newer versions of k8s, without needing to wait for the accompanying
kops release, which typically lags a minor version or two behind. Like I said, I
have no concrete plans, but I'm thinking about it. If I do decide to make this
change, I will certainly blog about it :)
