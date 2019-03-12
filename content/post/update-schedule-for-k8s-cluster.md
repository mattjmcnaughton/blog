+++
title = "Update Schedule for k8s Cluster and its Applications"
date = "2019-03-12"
categories = ["Projects"]
thumbnail = "img/update-schedule.jpg"
+++

Regularly updating our k8s cluster, and the applications running on it, is one
of the most powerful tools we have for ensuring our cluster functions securely
and reliably. Staying vigilant about applying updates is particularly important
for a fast moving project like Kubernetes, which releases new minor versions
each quarter. This blog post outlines the process we're proposing for ensuring
our cluster, and the applications running on it, remain up to date. We believe
its lightweight and manageable, requiring only a relatively small amount of work on a
monthly cadence. We also believe it applies updates in a reasonable time frame.

## Types of k8s updates

The Kubernetes project follows [semver](https://semver.org/), meaning each
version number maps to the MAJOR.MINOR.PATCH version. The semver spec dictates
increasing the major number when you make incompatible API changes, increasing
the minor number when you add functionality in a backwards compatible manner,
and increasing the patch number when you make backwards compatible bug fixes.
Patch updates are often issued to address security issues. For example, with
version [1.13.4](https://github.com/kubernetes/kubernetes/releases/tag/v1.13.4), the
patch number was updated from 3 to 4 to reflect changes to address a
[CVE](https://github.com/kubernetes/kubernetes/issues/74534).

For the purposes of this blog post,
we'll concern ourselves only with MINOR and PATCH versions. As far as we know,
Kubernetes has no concrete plans to increase the major release version anytime
soon, and if they did, it would be a large enough disruption that we'd need a
different plan for applying that update.

The Kubernetes project supports (i.e. blesses to run in production) the three most
recent minor versions. We can watch that support in action by examining
how the Kubernetes team would handle fixing a security
vulnerability for all supported versions. As of 3/21/19, the most recent Kubernetes release
is 1.13.4 and the most recent 1.12 and 1.11 releases are 1.12.6 and 1.11.8
respectively. Suppose Kubernetes discovered a security vulnerability necessitating
a patch release. It would release 1.13.5. However, it would also backport the
fixes to the previous two minor versions, necessitating a release of 1.12.7 and 1.11.9.
Note, they would not do a patch release for 1.10.x, as it is not one of the
three most recent minor versions.

If we want to receive security upgrades, which we certainly do, we need to ensure we are using
[one of the three latest minor versions of
Kubernetes](https://github.com/kubernetes/community/blob/master/contributors/design-proposals/release/versioning.md#supported-releases-and-component-skew). Our cluster is
currently running on 1.12.6, which means we are trailing one minor version
behind the most recent Kubernetes release, and will continue to receive security
updates.

## Policy for Cluster Updates

<iframe src="https://giphy.com/embed/xT5LMSXibBBVeJs6ZO" width="480"
height="362" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-16-the-simpsons-16x13-xT5LMSXibBBVeJs6ZO">via
GIPHY</a></p>

We propose the following policy for cluster updates. If there is a patch release
to address a security vulnerability, we will apply it immediately. We are
subscribed to the Kubernetes mailing list, and will rely on it for notifications.
Otherwise, we will check at the start of each month for if there is a new patch
release for our minor version, and will apply it if so. On a quarterly cadence,
we will check if there is a new minor version release, and update if
necessary to ensure we are using one of the three latest minor versions.

As a brief aside, because we use [kops](https://github.com/kubernetes/kops) to manage our cluster, Kops
[support for different minor versions](https://github.com/kubernetes/kops#kubernetes-version-support)
dictates which minor versions we can use. For example, we can not upgrade to
Kubernetes 1.13 until Kops 1.13 is released. In practice, we don't expect Kops to prevent us from
ensuring our k8s minor version is one of the three supported minor
versions.<sup><a href="#fn1">1</a></sup>

## A brief note about application updates

In addition to ensuring our cluster is up to date, we also need to ensure the
applications running on our cluster remain up to date. The release cadence and
versioning scheme is relatively application dependent, so its difficult to
dictate a specific policy. Instead, we propose a generic policy. Each quarter,
we will survey all deployed applications, and ensure that the version we are using
will be supported until at least the next quarter. If it is not, we apply the
smallest upgrade necessary for our application to be supported until the next
quarter.<sup><a href="#fn2">2</a></sup> If an application does not define "supported",
then we define it ourselves as there are no
known security issues, and if there was a security issue, we could update to
address it without having to make breaking changes.

## Conclusion

We hope these policies will help us, and you if you're following along,
regularly perform updates. By performing these updates, we're practicing good
software hygiene, and utilizing one of our most powerful tools for keeping our
cluster, and the applications running on it, secure and reliable.

<iframe src="https://giphy.com/embed/UjCXeFnYcI2R2" width="480" height="271"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/the-office-fist-bump-UjCXeFnYcI2R2">via
GIPHY</a></p>

<hr />

<sup id="fn1">1. While its not a problem if all we want to do is stay on a
supported minor version, it is true that Kops lags behind Kubernetes. For example, while
k8s is releasing 1.14, Kops is working to release 1.12. So if it is important to
you to use the latest and greatest minor version, Kops may not be the best tool
for you to manage your cluster.

<sup id="fn2">2. We may also update an application if we want new functionality
or to apply bug fixes, but will perform those updates on a more ad-hoc basis.
