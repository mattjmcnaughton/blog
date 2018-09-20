+++
title = "This Blog Has an Error Budget Policy"
date = "2018-09-20"
categories = ["Projects"]
thumbnail = "img/budget.jpg"
+++

In my [last blog post](/post/this-blog-has-an-slo/),
I publicized an [SLO](/slo/) for this blog.
I also mentioned that, in the future, I'd couple the SLO with an
[error budget and error budget policy](https://landing.google.com/sre/book/chapters/embracing-risk.html).
Well, the future is today, because this post will define
error budgets and error budget policies and their benefits, before proposing a specific
error budget and error budget policy to accompany our previously defined [SLO](/slo).

## What are Error Budget and Error Budget Policies?

<iframe src="https://giphy.com/embed/fpXxIjftmkk9y" width="449" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/fpXxIjftmkk9y">via GIPHY</a></p>

Understanding error budgets and error budget policies is a vital first step in
enumerating their pros and cons, and deciding whether we should apply these
concepts to this blog.

An error budget is the number of errors we can have, and still be within our SLO.
Its easiest to understand with an example. Suppose one component of our SLO is
that 99% of requests to our web server are successful, where we define success
as a non 5XX status code. Additionally, we are tracking our SLO
over a four week rolling window and in the previous four weeks we had 1,000 requests.
Our error budget is 10 failed requests over the upcoming four week window.

Suppose we deploy a bad container image, which leads to 5 unsuccessful requests. We
just used 50% of our error budget. If, within the same four week window, we
experience 10 more unsuccessful requests, we will exhaust our error budget by
50%. When you exhaust an error budget, its time to enact the error budget policy.

An error budget policy enumerates the activity a team takes when they've
exhausted their error budget for a particular service. It is not intended to
punish the team violating the SLO, but rather provide structural support
for investing in stability as opposed to new features.

An error budget policy can specify a number of actions, and I some
common components below:

- The team does not deploy any new versions of the service, modulo security
  fixes and fixes directly addressing the SLO failures, until the service no
  longer exhausts its error budget.
- The team devotes X amount of time to working on reliability until the service is back within SLO.
- The team caps time spend working on new features at Y until the service is
  back within SLO.

Over time, an error budget regenerates as the errors which exhausted the budget
fall outside of the rolling time window. Once the error budget has regenerated,
meaning our service its back within its SLO, we can return to development as
usual. The constraints enumerated by the error budget policy no longer apply.

## Why are Error Budgets and Error Budget Policies Useful?

<iframe src="https://giphy.com/embed/xT4uQaz24xgfsLE0kU" width="480"
height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/why-zach-galifianakis-xT4uQaz24xgfsLE0kU">via
GIPHY</a></p>

From the previous section, we understand what error budgets and error budget
policies are. But, are they something we want to apply to our SLOs in general,
and the SLO for this blog in particular?

I'd argue the answer is a resounding yes. Both error budgets and error budget
policies make an SLOs a more effective tool.

Error budgets add a much needed granularity to SLO measurements. On the surface,
an SLO is a binary concept: the service is either within the SLO or it is not.
If I'm an engineer trying to understand my application's current stability,
this binary is not sufficient. If all I know is that my SLO is passing, my
service could either have zero errors or be one error away from being out of
SLO. This lack of clarity makes it difficult to make decisions around when to
perform risky changes. An error budget solves this issue. At any time, we can
determine what percentage of the error the service has exhausted, and use this
measurement to guide the operations we undertake.

Additionally, error budgets allow us to quantify the impact of a negative event,
even if that event did not cause us to fail our SLO. For example, suppose we can
have 10 errors in a four week window and still meet our SLO. If we first have an
event that causes 9 errors and then an event that causes 2 errors, we want to
devote more attention to the first event, because it used a greater percentage
of our error budget. Yet, if we only have the SLO as a measurement device, we're
more likely to investigate the second event, because it caused our service to
move from passing to failing the SLO.

Error budget policies translate the theoretical concepts of SLOs and error
budgets into concrete allocations of developer resources. They codify the idea
that all changes to services have a concrete risk, and provide consistent
guidance around how to approach said risk.

For some, the theoretical strictness of the error budget policy is concerning.
Maybe a service just isn't that important, so they can't imagine prioritizing
stability investments once an error budget is exhausted. Or maybe clients demand
new features at a regular cadence, so stopping the deployment of new features is
a non-starter. While valid concerns, I'd argue that in those instances, the
issue is not with the concept of the error budget policy, but rather with the
definition of the SLO. If the team responsible for the service doesn't foresee
themselves wanting, or being able, to take actions to address an SLO failure,
then the SLO is false advertising. In that situation, skipping the error budget
policy is not the best option; rather, teams should define a more relaxed, and
achievable SLO. If the SLO cannot be relaxed, but also there is not support for
an error budget policy, then stressful times may be on the horizon... at least
SLOs and error budget policies surface these impossible expectations in advance,
and hopefully support a discussion of what is realistic.

I'll be an applying an error budget policy to this blog for much of the same
reason I applied an SLO. For one, I'm interested to see how this process works
in practice, and this blog seems like a safe way to test it. In addition, I know
I have a number of changes I want to make to this blog, and an error budget
policy seems like the perfect tool for balancing investing in new features and ensuring
this blog remains useful.

## Deriving an Error Budget from an SLO

<iframe src="https://giphy.com/embed/l0Iy4cdVJbfnkTbgc" width="480" height="270"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/colbertlateshow-stephen-colbert-the-late-show-l0Iy4cdVJbfnkTbgc">via
GIPHY</a></p>

As I mentioned before, this blog will track its SLO over a four week rolling
window. Unfortunately, I don't have four weeks of historic usage data, so I will
need to guess the number of requests this blog received over the last four weeks.
To make the math easy, let's assume 10,000 requests. I'll update these values on
a rolling cadence as we have actual usage data. Remember, our SLO is the
following:

- Availability: The proportion of successful requests, as measured from nginx logs and where any status
  code other than 5XX is considered successful, is > 99%.
- Latency: The proportion of sufficiently fast requests, as measured from nginx logs and
  where sufficiently fast is defined as < 1s, is > 99%.

Now, we just need to do some easy math. If we take `10,000 * (1 - .99)`, we get
the number of requests which can fail/not be sufficiently fast, and still be
within SLO.

We can define our error budget as follows:

- Availability: Our error budget for unsuccessful requests, where an
  unsuccessful request is a request which returns a status code of 5XX, is 100
  requests.
- Latency: Our error budget for not sufficiently fast requests, where not
  sufficiently fast is defined as > 1s, is 100 requests.

## Proposing an Error Budget Policy

<iframe src="https://giphy.com/embed/42BtSfGO0XqYIWxONN" width="480"
height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/abcnetwork-the-proposal-42BtSfGO0XqYIWxONN">via
GIPHY</a></p>

All stakeholders should be involved in the error budget policy's creation.
The involvement of those who approve how developers spend their time is
particularly important, as the error budget policy proscribes concrete
investments of development effort.

Since this blog is an independent project, I'm the only stakeholder, so I can
choose whatever error budget policy I want :)

My error budget policy enumerates the following actions when the error budget is
exhausted:

- Writing new blog posts will be halted until blog is back within SLO.
- Changes to blog infrastructure (i.e. Kubernetes configuration) will be halted
  until blog is back within SLO.
- I'll try and devote ~1 hr a week to addressing stability issues until the blog
  is back within SLO.

## Publicizing the Error Budget Policy

<iframe src="https://giphy.com/embed/DJ4A6uBf7mYZG" width="480" height="272"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/DJ4A6uBf7mYZG">via GIPHY</a></p>

Its important to publicize an error budget policy, especially in a collaborative
context, so that all stakeholders understand why certain actions are being taken
or not taken.

I've added this blog's error budget to the [SLO](/slo) page.

## Coming Soon: Monitoring

Thanks for reading this post and hopefully also [part 1](/post/this-blog-has-an-slo).
In the next post, we'll wrap up this SLO journey by talking about how we can
effectively monitor our SLO.
