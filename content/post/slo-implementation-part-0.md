+++
title = "(Part 0) SLO Implementation: Overview"
date = "2018-10-05"
categories = ["Projects"]
thumbnail = "img/slo-implementation.jpg"
+++

My last two blog posts enumerated this blog's [SLO](/post/this-blog-has-an-slo)
and [error budget](/post/this-blog-has-an-error-budget-policy). Our next logical
step is adding the monitoring and alerting infrastructure which will transform
our SLO usage from theoretical to practical. Like creating a [Kubernetes of
One's Own](/post/a-kubernetes-of-ones-own-part-0), this project contains
multiple steps which we'll explore over multiple blog posts. While this series
focuses on achieving this goal for this blog's specific SLO, the techniques are
applicable to many scenarios.

Our goal for this project is to create the monitoring infrastructure which will
allow us to monitor metrics pertaining to our SLO, and alert me when this blog
is violating its SLO (i.e. spent its error budget).

You can find the most recent version of the SLO on our [SLO page](/slo).

## What functionality do we need to accomplish this goal?

<iframe src="https://giphy.com/embed/9c6tOa5hGeUQU" width="480" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/west-wing-toby-ziegler-9c6tOa5hGeUQU">via
GIPHY</a></p>

For us to succeed in monitoring and alerting on our SLO, we need a
couple different components (and of course some pie).

First, we must track the application level metrics pertaining to our SLO.
Remember, our SLO focuses on availability and latency. We measure availability
via the status code returned by the web server and measure latency by the web
server's response time. In order for us to have any hope of monitoring our SLO,
our application must make these metrics accessible.

Second, we need a method of aggregating, storing, and querying metrics. We need
the ability to aggregate metrics because we define an application level SLO, and
there may be multiple instances of our application, all of which are providing
application level metrics. Only when we examine all the metrics together can we
know if our service is meeting its SLO. We need the ability to store metrics
because we calculate our SLO over a four-week rolling window, and also want
the ability to compare current performance to historical performance. Finally,
we need the ability to query our metrics because the SLI's constructing our SLO are (relatively)
complex. We need to calculate latency percentiles, alert on error budget
burn down, etc. An sufficiently expressive querying language will make writing
these calculations more pleasant.

Third, we need the ability to specify and manage alerts. Alert specification
involves defining queries, and the query results for which we should alert, as
well as running these alerts at a regular cadence. Alert management transforms
alerts into notifications in an intelligent way. Essentially, its responsible
for ensuring we get paged once, not a thousand times, for the same error.

Finally, while not a strict requirement for monitoring and alerting on our SLO,
we want to create easily consumable dashboards tracking our SLIs and
the percentage of error budget that we've spent. I will use these dashboards for
snapshots of system health and comparing current performance with historical
performance. I'll also make them available on the [SLO](/slo) page, so y'all can
see the exact same metrics I do regarding SLO performance.

## What tools provide this functionality?

<iframe src="https://giphy.com/embed/uh4Aft7V88YMg" width="392" height="480"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/prometheus-uh4Aft7V88YMg">via GIPHY</a></p>

Our needs for monitoring and alerting around this application's SLO are not
unique. As a result, a number of excellent open-source technologies exist which
can fulfill my use case.

We particularly focus on [Prometheus](https://prometheus.io/), an open source,
metrics-based monitoring system developed by the good folks at
[SoundCloud](https://soundcloud.com). Prometheus was based on
[Borgmon](https://landing.google.com/sre/book/chapters/practical-alerting.html),
which was Google's internal metrics-based monitoring system. Prometheus has seen
considerable adoption in the cloud native ecosystem, and is the only project
other than Kubernetes to [graduate from the Cloud Native Computing
Foundation](https://www.cncf.io/announcement/2018/08/09/prometheus-graduates/).
Tl:dr; a ton of developers are choosing Prometheus, and they are pretty darn
happy with their decision.

Prometheus, and its related ecosystem, provide all of the desired functionality
that I enumerated earlier. From Brian Brazil's excellent [Prometheus: Up and
Running](https://www.oreilly.com/library/view/prometheus-up/9781492034131/),
"Prometheus discovers targets to scrape from service discovery. These can be
your own instrumented applications or third-party applications you scrape via an
exporter. The scraped data is stored, and you can use it in dashboards using
[PromQL](https://prometheus.io/docs/prometheus/latest/querying/basics/)
or send alerts to the [AlertManager](https://prometheus.io/docs/alerting/alertmanager/),
which will convert them into pages, emails, and other notifications."
To unpack, Prometheus meets our first need by
defining an standard interface with which applications can export metrics for
Prometheus to pull in. It meets our second need by aggregating and storing all
of the different metrics sources it scrapes, and providing a query language,
PromQL. Prometheus meets our third need via AlertManager, which can aggregate
our alerts into whatever notification form we desire. Finally, Prometheus
provides a lightweight dashboard for exploring metrics. It also has first class
support the much more powerful [Grafana](https://grafana.com/) dashboard.
In short, Prometheus provides everything we need and has a proven track record
in the Cloud Native ecosystem.

## What can we look forward to?

<iframe src="https://giphy.com/embed/xTiN0CNHgoRf1Ha7CM" width="480"
height="470" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/jerseydemic-xTiN0CNHgoRf1Ha7CM">via GIPHY</a></p>

The next couple of blog posts in this series will
walk through accomplishing our stated objectives using Prometheus and its
related tools.

The first post will explore configuring our blog to expose the metrics
Prometheus needs to scrape in order to monitor our service level indicators. The
next post will discuss deploying Prometheus on our Kubernetes cluster, and
configuring our Prometheus instance to scrape metrics from our blog. The
following post will examine using Grafana to visualize our service level
indicators and error budget. Finally, the last post will explore setting up
alerts and notifications via AlertManager.

Looking forward to exploring this together :) Happy monitoring!
