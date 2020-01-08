+++
title = "Intro to Contributing to Kubernetes: Testing - Part 1"
date = "2020-02-11"
categories = ["Tutorial", "Kubernetes"]
thumbnail = "img/k8s-ci.png"
+++

## tl:dr;

By the end of this blog post, you'll understand the tests your proposed
Kubernetes diffs must pass before being merged. You'll have all the background
information to be ready for part 2 (coming soon), in which we discuss how to actually run all
the different test suites locally.

## Background

As a brief reminder, I've been focusing the majority
of my open-source development capacity on
Kubernetes for almost a year. During that
time, and going forward, I'm writing blog posts geared towards potential new
Kubernetes' contributors. I hope these blog posts will augment existing
Kubernetes documentation,<sup><a href="fn1">1</a></sup> and
decrease the barriers for potential contributors to making meaningful commits.

For my next couple of blog posts, we'll be examining how to test potential Kubernetes
contributions. This post assumes you've read my
[k8s-dev-quick-start](https://mattjmcnaughton.com/post/k8s-dev-quick-start/)
post, which covers
forking and cloning the Kubernetes repo, ensuring the project builds, etc...

With all the development fundamentals in place, we can start thinking about
testing!

## Testing in k8s: A high level description

We'll tackle testing in Kubernetes by focusing on the following three
statements:

1. Kubernetes supports unit, integration, and end-to-end (e2e) tests.
2. All critical test suites must pass in CI before a diff is merged.
3. Being comfortable running the test suites locally makes it easier to propose
   changes with confidence and leads to quicker iteration cycles (we touch on
   this point briefly in this post, but will predominantly address it in part
   2).

## Types of testing in Kubernetes

Each type of test has a slightly different purpose and as a result, slightly
different guidelines. You can find the most up-to-date documentation via the
[sig-testing documentation](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-testing/testing.md)
but here's a high-level summary.

### Unit tests

When contributing to Kubernetes, you will most commonly interact with the unit
tests. Almost every diff you submit should either add, or modify existing, unit
tests. Unit tests should be very lightweight to work with, testing only a specific function in the code and
executing very quickly. They should be fully hermetic (i.e. depend only on their declared
inputs and depending on nothing on the local machine).
See the [Testing conventions](https://github.com/kubernetes/community/blob/master/contributors/guide/coding-conventions.md#testing-conventions)
documentation for further guidelines.

### Integration tests

In Kubernetes, integration tests build on unit tests by allowing access to other
resources on the local machine. These "other resources" are most commonly `etcd`
or a service listening on localhost (like the Docker daemon).
All significant features require integration
tests, so you will add/update integration tests either when you add a
significant new feature, or you make significantly large change to an existing
feature that the integration test needs to be updated. See the [Integration Test](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-testing/integration-tests.md)
documentation for more details.

### e2e tests

E2E tests are the highest-level class of test in the Kubernetes ecosystem. They
are designed to verify the end-to-end system behavior, and serve as a last
signal to ensure the code is working as we intend. Given the complexity of
Kubernetes as a distributed system with multiple components, this final check is
vital to Kubernetes' stability. E2E tests mirror a production k8s use-case as closely as possible.
They have no bounds on the type of resources on which they can depend. They
assume a fully functional Kubernetes cluster, and some even depend on a specific
cloud provider. In fact, you'll notice Kubernetes' CI actually runs multiple
different flavors of e2e tests, reflecting different combinations of
external resources (i.e. different container runtimes, cloud providers, etc...).

Naturally, this lack of restrictions increases the complexity of
the testing environment. Additionally, e2e tests are by far the most expensive
with respect to runtime and most flake prone of the classes of tests. In short,
they are a powerful tool for verifying correctness, but should be treated with
caution. See k8s documentation on [e2e
tests](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-testing/e2e-tests.md#end-to-end-testing-in-kubernetes)
and an enumeration of
[best practices](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-testing/e2e-tests.md#end-to-end-testing-in-kubernetes)
when writing e2e tests in k8s for more information.

## Role of testing in Kubernetes

When you create a PR, Kubernetes' CI tooling will automatically run its test
suite against it (add footnote describing /ok-to-test).

The following conditions must be met for before any pull request
is merged to Kubernetes:

1. All existing tests must continue to pass.
2. Any new functionality must be tested via the appropriate mechanisms (i.e.
   unit, integration, or e2e tests depending on the nature of the change).

As we will explore in-depth in the next post, its easier to get your k8s PRs
accepted if you create PRs which conform with the above stipulations from start.

## Conclusion

And that's it! In my next blog post, we will focus on how to actually run these
different types of test locally, helping you increase your development velocity
when working on Kubernetes.

<hr />

<sup id="fn1">1. When in doubt, https://github.com/kubernetes/community/tree/master/contributors/devel/sig-testing
is our friend.
</sup>
