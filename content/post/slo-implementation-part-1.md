+++
title = "(Part 1) SLO Implementation: Release the Metrics"
date = "2018-10-07"
categories = ["Projects"]
thumbnail = "img/lots-of-metrics.jpg"
+++

In the [blog post](/post/slo-implementation-part-0) overviewing our SLO
implementation, I listed configuring our blog to expose the metrics
for [Prometheus](https://prometheus.io) to scrape
as the first step. To fulfill that promise, this post examines the necessary
steps for taking our static website and serving it via a production web server which
exposes the latency and success metrics our SLO needs.

## A brief examination of Prometheus metrics

Application monitoring has two fundamental components: instrumentation and
exposition. [Instrumentation](https://en.wikipedia.org/wiki/Instrumentation)
refers to measuring and recording different quantities and states. Exposition
refers to making metrics available to some consumer, which for us is Prometheus.
We'll discuss both in the context of our static website.

### Instrumentation


Prometheus supports a number of different metric types that we could use to
instrument our application. There are four core types (counter, gauge, histogram and summary), which
[Prometheus' documentation](https://prometheus.io/docs/concepts/metric_types/)
explores in considerable detail.

<iframe src="https://giphy.com/embed/5t3POlVgm29ZiERRXT" width="480"
height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/bigbrotherafterdark-5t3POlVgm29ZiERRXT">via
GIPHY</a></p>

We utilize the counter and the histogram to generate the needed metrics for our SLO.

With respect to the availability component of our SLO, we need to track both the
number of failed requests and the number of total requests. The counter type
perfectly fulfills this use case, as it tracks the number or size of events.

With respect to the latency SLO, we need to track the ever changing response
time of server requests. We could use a gauge, which provides a snapshot of
current state (i.e. the response time for the last request to the web server).
However, a histogram is an even more appropriate metric type. It also captures a
snapshot of current state, but specifically supports percentile calculations
(i.e. what is the 99% percentile response time for requests to this web server).
Since our SLO explicitly examines the 99% percentile, the histogram metric type
is the most appropriate choice.

We can generate these metrics in two different ways. In
the first way, we perform direct instrumentation on the application using
Prometheus' client side libraries. In other words, the application code has code
written to track the proper metrics in a way that conforms with Prometheus'
standards.

In the second way, our application code has no direct knowledge of
Prometheus, and instead exports metrics in some non-Prometheus specific format.
We then use an [exporter](https://prometheus.io/docs/instrumenting/exporters/)
to transform these metrics into a format which Prometheus can ingest. Exporters
exist for a number of popular open-source projects, and are necessary to use
Prometheus with projects like Nginx, which were developed years ago, and will
likely never have Prometheus conforming instrumentation implemented directly in
the source code.

### Exposition

Implementing exposition involves less decision making than implementing
instrumentation. Prometheus scrapes metrics from an application via HTTP
requests to `/metrics`. It expects the metrics in a standardized, human-readable
text format. We could produce this text-format by hand, but the Prometheus ecosystem has
tools to automatically generate the formatted metrics and serve the endpoint for almost any use-case.

## But how do we get these for our app?

We desire a static web server for which we can perform the needed instrumentation
and exposition. We have a couple of different options for creating one. First,
we could write our own web server, and in doing so, directly instrument our SLI
metrics using Prometheus' client-side libraries.  Alternatively, we could choose an already existing
open-source web server, which itself has instrumentation conforming to
Prometheus requirements. [Caddy](https://caddyserver.com/),
with the usage of the [Prometheus plugin](https://caddyserver.com/docs/http.prometheus), is
one such popular open source web server. Finally, we could use a historic web
server like [Nginx](https://www.nginx.com/) or [Apache](https://httpd.apache.org/), and then
use an exporter to generate Prometheus consumable metrics.

<iframe src="https://giphy.com/embed/EZdjrzyK1Kw2A" width="480" height="301"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/tyler-james-williams-gif-hunt-fc-EZdjrzyK1Kw2A">via
GIPHY</a></p>

While option 1, writing our own web server, would give us considerable control
over instrumentation, it is definitely overkill for hosting a static blog.
Additionally, I struggled to find an well-known exporter for Apache or Nginx which both provided
all the metrics we need for SLO monitoring and was easily configurable.
Fortunately, option 2, Caddy with the Prometheus plugin, provides everything we
need. Caddy is a well-known and respected web server and the Prometheus plugin
instruments the exact metrics we need for SLO tracking.

## Let's write some config files!

<iframe src="https://giphy.com/embed/48zjXYRwBg5IQ" width="480" height="278"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/working-daffy-duck-typing-48zjXYRwBg5IQ">via
GIPHY</a></p>

We know that we want to serve our blog via the Caddy web server, with the
Prometheus plugin. Additionally, we know we want to run the Caddy web server on
Kubernetes. Kubernetes runs Docker containers, which derive from Docker images.
So let's write a Dockerfile!

In all, the Docker image must contain a binary containing the Caddy web server,
with the Prometheus plugin, and our Caddy configuration file and static content.
It must also expose the proper ports to allow us to access the Caddy web server
from outside of the container. I've embedded the Dockerfile below. I've added
extensive comments examining both the non-trivial what and why of the
included commands.

<script
src="https://gist.github.com/mattjmcnaughton/d829a9a9dfd6c6abfcf1533351b84b6c.js"></script>

We must specify some light configuration settings for Caddy. Again, I've
embedded the Caddyfile below, which contains extensive comments on the
non-trivial what and why of the configuration specification.

<script
src="https://gist.github.com/mattjmcnaughton/d66ec52804e31ea978924cb94283c087.js"></script>

If you've cloned [the project](https://github.com/mattjmcnaughton/blog), you can
run `make build_image` from the base directory, and you should see a successful
image construction. If you run `docker run -p 8080:80 mattjmcnaughton/blog:$(git
rev-list HEAD -n 1)`, you will start running a container derived from the image
you just built. If `curl localhost:8080/metrics` dumps a whole bunch of metrics
in Prometheus format, then you're good to go!

## Let's gobble up some metrics!

<iframe src="https://giphy.com/embed/ghkKihjlHJ2W4" width="480" height="297"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/pizza-comer-ghkKihjlHJ2W4">via GIPHY</a></p>

We've successfully instrumented our blog and exposed the resulting metrics via
the `/metrics` endpoint. The final step is configuring our Prometheus instance
to scrape these metrics. We'll discuss this setup in much greater depth in the
next blog post, but if you are itching to start experimenting, the embedded
`prometheus.yml` file below configures Prometheus to scrape my blog.

<script
src="https://gist.github.com/mattjmcnaughton/e415253469fb536f47a833c539ae2738.js"></script>

You can run a Prometheus Docker container with the given configuration using the
following command.

```bash
docker run \
  -p 9090:9090 \
  -v /path/to/downloaded/prometheus.yml:/etc/prometheus/prometheus.yml \
  prom/prometheus
```

Try navigating to `localhost:9090` and querying for the
`caddy_http_request_count_total` metric. You should see counters, with a variety
of labels, tracking all the requests seen by this blog.

## Next Time

Now that our application is instrumented and exposing metrics, our next step is
hosting Prometheus on Kubernetes and configuring our Prometheus instance to
scrape our blog's metrics. Can't wait!

<iframe src="https://giphy.com/embed/6YCelxMJo0txK" width="480" height="271"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/excited-arrested-development-lucille-booth-6YCelxMJo0txK">via
GIPHY</a></p>
