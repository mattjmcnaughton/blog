+++
title = "This Blog Has an SLO"
date = "2018-09-16"
categories = ["Projects"]
thumbnail = "img/slo.jpg"
+++

## Background

I recently started reading [The Site Reliability
Workbook](https://www.amazon.com/Site-Reliability-Workbook-Practical-Implement/dp/1492029505/),
which is the companion book to the excellent [Site Reliability Engineering: How
Google Runs Production Systems](https://www.amazon.com/Site-Reliability-Engineering-Production-Systems/dp/149192912X/).

<iframe src="https://giphy.com/embed/8dYmJ6Buo3lYY" width="480" height="352"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/baby-story-reading-8dYmJ6Buo3lYY">via GIPHY</a></p>

These books devote considerable attention to [Service Level
Ojectives](https://landing.google.com/sre/book/chapters/service-level-objectives.html) (SLOs),
which are a way of defining a given level of service that users can expect. More
technically, a SLO is a collection of Service Level Indicators (SLIs), metrics
that measure whether our service is providing value, and their
acceptable ranges. For example, our SLO for a web service could be that 95% of
requests are successful and 99% of requests return in less than 500ms.

Explicitly deciding on and publishing an SLO clarifies both
internal and external expectations for the service. If the service is within
SLO, then it is functioning acceptably. If the service is outside SLO, it is
not.

From SLOs, we can create [error
budgets](https://landing.google.com/sre/book/chapters/embracing-risk.html#id-na2u1S2SKi1).
Error budgets, which we'll explore in a later blog post,
translate our current ability to meet our into decisions around the allocation
of engineering resources. Essentially, our service can only experience so many
errors before it has spent all its error budget, and must prioritize stability
over innovation.

Google's SRE books predominantly focus on companies deploying at a "Google
level" scale. However, SLOs are a useful tool for any developer, regardless of
the size of their company or deployment. We define a SLO by codifying what it
means for our service to be successful. Having an explicit definition of success
is necessary for any project, and is particularly necessary when the application
has a large backlog of ambitious changes. So, despite this blog having about
one-billionth of the users of most Google products, I'm still going to define
and publicize an SLO for it.

## Creating an SLO

<iframe src="https://giphy.com/embed/ne3xrYlWtQFtC" width="480" height="205"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/funny-lol-ne3xrYlWtQFtC">via GIPHY</a></p>

Creating an SLO is a somewhat formulaic process. First, we identify the SLIs for
our service. The [Site Reliability Workbook](https://www.amazon.com/Site-Reliability-Workbook-Practical-Implement/dp/1492029505/)
proposes that the type of a service dictates its SLIs, and the most
common service types are request-driven, pipeline, and storage.
This blog is clearly a request-driven service.

Two main SLIs describe the performance of a request-driven service. The first is
availability, which we define as "the proportion of requests that resulted in a
successful response." The second is latency, which we define as "the proportion
of requests that were faster than some threshold." Intuitively, these SLIs map
closely to our heuristic models of what makes a "good" website from a technical
perspective. If the site consistently and quickly serves the content we desire,
then its fulfilling its providing value. Unfortunately, there's no SLI for the quality of my writing :)

<iframe src="https://giphy.com/embed/l2R06WPHU4ae0H4LC" width="480" height="279"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/chuber-qa-quality-assurance-l2R06WPHU4ae0H4LC">via
GIPHY</a></p>

We have our SLIs. If we match these SLIs with an acceptable threshold for their
values, then we have our SLO. Both the SRE books deep-dive into choosing
appropriate values, but the most important aspect to remember is the SLO will
require refinement over time. In other words, you don't need the perfect values
to start. In a business environment, or really any environment where it isn't
just you hosting your own blog, you should be sure that all stakeholders are
involved in deciding the thresholds. Its vital that everyone agrees that the
service is working if its in SLO, and not working if its not in SLO.

With respect to the availability metric, we set 99% success as our target. With
respect to latency, we set 99% of requests < 1s as our target. These seem like
sensible initial values, which preserve our ability to experiment and the blog's
ability to be useful to readers. Note, with
latency, its important to use percentiles like 90% or 99% instead of average.
Using averages can mask long-running requests which significantly degrade the
user experience. Additionally, note that we just define the thresholds in this
section. We don't actually specify how we're going to measure the SLIs.
We consider specifying the measurements to be implementing the SLO, and we leave
it for the next section.

Finally, we must determine the time range over which we want to measure the SLO.
The [Site Reliability Workbook](https://www.amazon.com/Site-Reliability-Workbook-Practical-Implement/dp/1492029505/)
recommends a four-week rolling window as a good general-purpose interval which
accurately captures the user's perceptions of service performance. The four-week
rolling window works perfectly for our use case.

## Implementing an SLO

The [Site Reliability Workbook](https://www.amazon.com/Site-Reliability-Workbook-Practical-Implement/dp/1492029505/)
carefully delineates between a SLI specification and a SLI implementation. The SLI specification
is the description of the service outcome influencing user satisfaction, independent
of how we will measure this outcome. The SLI implementation is the SLI
specification plus how we will measure it. Similarly, an SLO
comprised of SLI specifications is an SLO specification. An SLO comprised of SLI
implementations is an SLO implementation.

From our work in the preceding sections, we have an SLO specification. In this
section, we'll establish a specific method for measuring our SLIs, at which
point we'll have an SLO implementation.

Remember, our SLO comprises of two different SLIs. The first is around
availability. Our SLI specification was the percentage of requests that are successful.
To transform this SLI from a specification to an implementation, we'll state our
availability SLI as the following:

- The proportion of successful requests, as measured from nginx logs. Any status
  code other than 5XX is considered successful.

Our second SLI was around latency. Our SLI specification was around the
proportion of sufficiently fast requests, where sufficiently fast was outlined
as < 1s. We can state our SLO implementation as the following:

- The proportion of sufficiently fast requests, as measured from nginx logs.
  Sufficiently fast is defined as < 1s.

If we couple these SLI implementations with the SLO thresholds defined in the
previous section, we have a fully specified SLO.

- The proportion of successful requests, as measured from nginx logs and where any status
  code other than 5XX is considered successful, is > 99%.
- The proportion of sufficiently fast requests, as measured from nginx logs and
  where sufficiently fast is defined as < 1s, is > 99%.

We now have a fully implemented SLO! We'll explore aggregating the metrics which
enable us to measure our SLO and monitoring and alerting upon the fulfillment
of our SLO in a future blog post.

## Publishing our SLO

We've written our SLO, so the final step is to publish it. I've hosted it as a
[top level page](/slo/) on this site, so it should be easily discoverable. Once
I create the monitoring around whether the site meets this SLO, I'll publish it
on the SLO page as well. That way y'all can hold me accountable :)

<iframe src="https://giphy.com/embed/l3q2NboZyZSrDTM7S" width="480" height="270"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/abcnetwork-modern-family-phil-dunphy-l3q2NboZyZSrDTM7S">via
GIPHY</a></p>

## Coming Soon: Error Budgets, and Monitoring

There are two future blog posts on this topic to which you can look forward. One post will
be a technical tutorial on adding the infrastructure to Kubernetes to aggregate
and monitor the metrics I need to determine whether I'm meeting the SLO. Another
post will describe how I can use this SLO to create an [error
budget](https://landing.google.com/sre/book/chapters/embracing-risk.html),
an extremely useful tool which will help me balance between investing in
stability and new functionality.

Additionally, its important to revise SLOs over
time as we become more experienced running our service and have a greater sense
of the thresholds our service must meet to provide value to users. So we will
continue to revisit this topic.

So look forward to some posts in that realm as well. Until next time, thanks for reading
:)
