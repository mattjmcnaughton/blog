+++
title = "(Part 0) A Kubernetes of One's Own: Start with Why"
date = "2018-09-07"
categories = ["Projects"]
thumbnail = "img/everyones-excited-about-kubernetes.png"
+++

From my [last blog post](/post/blog-running-on-k8s), you know Kubernetes manages the blog you are
reading right now. But I violated pretty much all the rules of good blogging
by only briefly discussing why I wanted to start running my
own production Kubernetes cluster in the first place, and how exactly I made
that happen. I think I was just excited it was working and I wanted to share...

<iframe src="https://giphy.com/embed/xT5LMWQDffrp1MZ2OA" width="480"
height="360" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-11-the-simpsons-11x14-xT5LMWQDffrp1MZ2OA">via
GIPHY</a></p>

Now, I'm writing to remedy my excited self's mistakes. This blog mini-series
makes the case for why I wanted to run my own Kubernetes cluster. It also
contains the first of what I hope will be many posts deep diving into the steps necessary to utilize
Kubernetes, and the other tools in the [Cloud Native](https://www.cncf.io/) ecosystem,
for personal, production use cases.

But before we get to implementation details, we need to start with why.
**In short, I propose Kubernetes isn't only for big corporations like Google.
It is accessible and useful for personal use cases.** These use cases include hosting anything from
simple entities like your own static blog, to common infrastructure like a
personal Gitlab instance, to complex projects like a commercial product
implemented via micro services. I'll support my claim by creating
a Kubernetes cluster for my personal use, and using it
to host a static website (this blog), a piece of common infrastructure (maybe a
GitLab or NextCloud or JupyterHub or ... SO MANY OPTIONS), and a more complex micro-services application
(tbd exactly what that application will be). I'll use these projects as "real
world" test cases for different Kubernetes/Cloud Native technologies and best practices.
Since my target audience is developers using Kubernetes for personal use,
and that's what I am, I will place a special
focus on cost and maintainability. I need to be able to pay for this cluster
without it being substantial expensive, and need to be able to manage the cluster and
its applications without being a full, or even part, time job.

**If you join with me in investing in Kubernetes for personal use, you'll see a
couple of concrete benefits.**

First, you'll have an incredibly powerful and
incredibly flexible piece of infrastructure at your disposal. Deploying new
either custom applications you've written or standard open-source applications
will take minutes and hours instead of days and weeks.
Additionally, these applications will be easier to monitor and debug after they are
launched. If you're interested in controlling your own computing experience, this ease of use is
particularly exciting.

Second, running a personal Kubernetes cluster with production applications gives
you real world experience that is becoming increasingly desirable and relevant.
A quick google search shows that Kubernetes, and the Cloud Native ecosystem in
general, have skyrocketed in popularity in recent years. Working with these
technologies in a personal capacity will better enable you to engage with them
in your professional life.

The final benefit is admittedly niche; running a personal production Kubernetes cluster
will make you a better contributor to Kubernetes and other cloud native
projects. From personal experience, my lack of production
experience with a Kubernetes cluster capped my ability to contribute at fixing
bugs or implementing small features that other developers suggested. Don't get me
wrong, those are necessary and fun contributions. But if you want to
start proposing and implementing larger changes like I would love to someday,
experience as a user is vital.

I hope I've convinced you running your own Kubernetes cluster is a worthwhile
project. In [part one](/post/a-kubernetes-of-ones-own-part-1) of this series,
we will look at the different options for
creating your cluster, and I'll explain how I decided on the setup I'm
currently using. Let's get started :)

<iframe src="https://giphy.com/embed/l2JecCAExsqUC4HDy" width="480" height="360"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-13-the-simpsons-13x7-l2JecCAExsqUC4HDy">via
GIPHY</a></p>
