+++
title = "Intro to Contributing to Kubernetes: Testing"
date = "2020-02-11"
categories = ["Tutorial"]
draft = true
thumbnail = ""
+++

TODO:
- Should I rename/rebrand my old post so that its more clear its part of a
  series?
- Should this post be multiple parts? Probably...

## tl:dr;

By the end of this blog post, you will understand how to run Kubernetes unit,
integration, and e2e tests locally.

## Background

Read previous post...

## Running tests locally  in k8s

Hopefully I've convinced you that testing is an integral part of the Kubernetes
ecosystem, and maintaining/improving test quality is a prerequisite for PRs.
Given this importance, unit, e2e, or integration testing should be one
of the earliest steps in the development cycle for any change your developing.
Diffs which consider both existing and additional unit tests from the start have
a much better chance of maintaining test quality and being accepted (add
footnote around, if possible, its best for PRs to be proposed with the test
suite already passing. Best chance of getting eyes on a PR when its created, and
if the test suite is already passing, an approver can approve without
introducing any back and forth. Mention that I'll discuss in a blog post to
follow). In addition, writing and running tests early accrues all the benefits associated
with test driven development.

Of course, for testing to enjoy a place of prominence in the initial
development, we must be able to run the test suite locally. This desire for
quick and accurate local testing during the development process leads us to the
next section of this blog post: instructions on running Kubernetes unit,
integration, and e2e test suites locally.

### Unit

The first set of tests we'll want to run locally are the unit tests. As I
mentioned previously, unit tests should have NO external dependencies. They are
the least complicated and fastest to run locally, and unit tests best contribute
to practicing test driven development.

A couple of different methods exist for running Kubernetes' unit tests locally.
Personally, I like to run Kubernetes' unit tests via Bazel. (Add footnote around
assume having Bazel installed). To do so, run `bazel test
//PATH/to/pkg/to/test`. For example, to run the `pkg/kubelet/kuberuntime` test,
I would run `bazel test //pkg/kubelet/kuberuntime`. (Add a footnote around potential
need to run `hack/update-bazel.sh`)

You can also run Kubernetes unit tests via `go test`. Kubernetes' makes doing so
particularly easy via `make test`, which calls `go test` under the hood.
Restrict to a certain pkg via the `WHAT` flag and set additional GOFLAGS via
`GOFLAGS`. For example, to run the `pkg/kubelet/kuberuntime` tests via the `-v` flag,
you would run `make test WHAT=./pkg/kubelet/kuberuntime GOFLAGS=-v`.

Both Bazel and `go test` will cache test results for you. For both Bazel and `go
test`, if you add a `...` after the package path, it will run tests both for
that package and for all child packages. I'd recommend experimenting around with
the different command line flags for both `bazel` and `go test`, as both are
powerful tools that offer great flexibility.

### Integration

The next test suite to run locally is the integration test suite. As we noted in
our description of the test suites, integration tests are allowed to depend on
external services running, or binaries being installed, on the host. Unlike the
unit tests, which live directly beside the main code in the same package,
integration tests live in the `test/integration` directory.

Kubernetes provides light tooling to help you set up your local environment for
developer testing. Specifically, almost every integration test depends on
[etcd](https://github.com/etcd-io/etcd), the reliable key-value store backing
Kubernetes. When you run integration tests via `make test-integration`,
the test scripts will handle starting/stopping etcd - however, you must have the `etcd`
and `etcdctl` binaries installed and available. You can either manage `etcd`
yourself (Add footnote... k8s is somewhat strict around the minimum etcd version)
or you can run `hack/install_etcd.sh`, which will install `etcd` for you in
`$K8S_PROJECT_ROOT/third_party`.

Some integration tests may also require a working docker installation. However,
Kubernetes' tooling does not provide any helper scripts around
installing/running Docker. Fortunately, instructions for installing Docker on
your system should be a quick Google search away.

With the third party tools available, running the integration tests is quite similar
to running the unit tests via `make`. We can issue `make test-integration` to
run all integration tests. `make test-integration` will handle starting/stopping
etcd and some other setup, before calling `make test`, which itself calls `go
test`. The additional flags you can pass for `make test-integration` are similar
to the flags for `make test`. For example, to verbosely run the `pod`
integration tests, you could run `make test-integration
WHAT=./test/integration/pods GOFLAGS=-v`.

### e2e

#### Local e2e
- Again, ensure `etcd` is installed and in path.
- Ensure `kubetest` is installed.
- Three terminals:
  - In the first, run `hack/local-up-cluster.sh`
    - Leave running the whole time.
  - In the second, run `export KUBECONFIG=/var/run/kubernetes/admin.kubeconfig`
    and then use `cluster/kubectl.sh`. We can run `kubectl get pods` in here.
    - Run `kubectl get nodes` to validate your local cluster is running
      successfully.
  - In the third, we will run our e2e tests. Run the same `KUBECONFIG` export as
    before.
    - You can also run `kubetest -ctl='CTL_COMMAND'`.
- Now, run `kubetest --build` to create a local build of the tests.
  - TODO: Determine the `make` command we can use here instead.
  - To execute all the tests, run `kubetest --provider=local --test --test_args="--minStartupPods=1"`
    - We set `minStartupPods` to equal the number of nodes in our cluster (i.e.
      1, because its a local cluster).
  - To execute specific tests, add `--ginkgo.focus=TEST_SELECTION_REGEX` to
    `--test_args`.
    - I've found the `regex` for a single test can be a little tricky to get right... I often just
      add a unique string to the test I want to run... and then use that as my
      selector (i.e. this-is-the-test-to-run => --ginkgo.focus=this-is-the-test-to-run).
      - Just need to be sure to recompile w/ `make WHAT=test/e2e/e2e.test
- Talk about rebuilding:
  - To rebuild just the tests... `make WHAT=test/e2e/e2e.test`

##### Clean up

`docker stop $(docker ps -q) && docker rm $(docker ps -aq)` or `sudo systemctl restart docker`
`sudo rm -rf /var/run/kubernetes`
`sudo iptables -F`

#### gce e2e

Warning - requires google account... but gce is the main method for testing
k8s.

- Install `google-cloud-sdk`
- Run `gcloud init`.
  - You will need to enable `ComputeEngine`.
- Run `gcloud auth application-default login`.
- Join `kubernetes-dev` group w/ Google account...
- `kubetest --build`
- `kubetest --up` (will take a while)
- `kubetest --test` (same as local)
- `kubetest --destroy`

- Examine `kubetest --stage` and `kubetest --extract` for updating build without
  rebuilding the entire cluster.

- `kubetest --check-leaked-resources` (double check not leaking any resources).
  - Need to export the gcloud project you created.

### [Bonus] e2e-node

https://github.com/kubernetes/community/blob/master/contributors/devel/sig-node/e2e-node-tests.md

#### Local

- `make test-e2e-node PARALLELISM=1 FOCUS=...  TEST_ARGS="--kubelet-flags=--fail-swap-on=false"
- Can find logs via journalctl for the kubelet... should also be able to observe
  the apiserver, etc... running in the docker container.
- Can also go to `/tmp/_artifacts/TIME/` ... and tail the log files.

TODO: Get the test filtering to work...

##### Clean up

`docker stop $(docker ps -q) && docker rm $(docker ps -aq)` or `sudo systemctl restart docker`
`sudo rm -rf /var/run/kubernetes`
`sudo iptables -F`

#### Proposed changes

- https://github.com/kubernetes/community/blob/master/contributors/devel/sig-node/e2e-node-tests.md#locally
  => upgrade Ginkgo not mandatory
- Update so posts how to find Kubelet logs via journalctl earlier... instead of
  waiting until the end.

#### Remote

`kubetest --node-tests`?

### [Bonus Bonus] Creating kubernetes cluster from master for experimentation

`hack/local-up-cluster.sh`.

### [Bonus Bonus Bonus]

Static checking
