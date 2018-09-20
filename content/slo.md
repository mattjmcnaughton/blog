+++
date = "2018-09-16T22:10:54-04:00"
title = "SLO"
menu = "main"
+++

For more context on why this blog has an SLO, please read my [blog post](/post/this-blog-has-an-slo).
This document follows the SLO/Error Budget Policy templates defined in
[The Site Reliability Workbook](https://www.amazon.com/Site-Reliability-Workbook-Practical-Implement/dp/1492029505/).

---

## SLO

### Service Overview

This [site](/) is a static website used for publishing my personal blog.

### SLIs and SLO

- Availability: The proportion of successful requests, as measured from nginx logs and where any status
  code other than 5XX is considered successful, is > 99%.
- Latency: The proportion of sufficiently fast requests, as measured from nginx logs and
  where sufficiently fast is defined as < 1s, is > 99%.

### Rationale

No attempt has been made to verify that these numbers correlate strongly with
user experience. As I receive more performance data and user feedback, I will
refine the SLO thresholds.

### Error Budget

Each objective has a separate error budget. We define this error budget as 100%
minus the goal for that objective. For example, if we imagine this blog has
10,000 requests in the last four weeks, the availability error budget is 1%
(100% - 99%) of 10,000: 100 errors.

We enact the [error budget policy](#error-budget-policy) when any of our
objectives exhaust their error budgets.

---

## Error Budget Policy

### Goals

The goals of this policy are to:

- Ensure this blog is sufficiently stable so as to provide value to its readers.
- Balance reliability investments with investments in new features and content.

### Non-Goals

The goal of this policy is not too punish developers (i.e. me) for missing SLOs.

### SLO Miss Policy

If this blog is performing at or above the SLO, then I'll have no restrictions
on new features, new content, or new infrastructure.

If this blog has exceeded its error budget, I'll take the following actions:

- Writing new blog posts will be halted until blog is back within SLO.
- Changes to blog infrastructure (i.e. Kubernetes configuration) will be halted
  until blog is back within SLO.
- I'll try and devote ~1 hr a week to addressing stability issues until the blog
  is back within SLO.

---

## Metrics and Dashboards

Coming soon.
