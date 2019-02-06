+++
title = "k8s Dev Quick Start"
date = "2019-03-07"
categories = ["Projects"]
thumbnail = "img/k8s-dev-quick-start.jpg"
+++

[Kubernetes](https://github.com/kubernetes/kubernetes) is a incredibly exciting
and fast moving project. Contributing to these types of projects, while quite
rewarding, can have a bit of a startup cost. I experienced the start up cost a
bit myself, after returning to contributing to the Kubernetes after a couple of
months of focusing on running my own Kubernetes cluster, as opposed to
contributing source code. So this post is partially for y'all and partially for
future me :)

After reading this post, you'll be set up with everything you need to start
contributing to [Kubernetes](https://github.com/kubernetes/kubernetes), with a
particular focus on getting your hands dirty with the source code as soon as
possible.

## Assumptions

We're assuming that you already have Go and Docker installed on your machine. If
you do not, many tutorials exist which should provide all the guidance you'll
need. See [k8s' development
documentation](https://github.com/kubernetes/community/blob/master/contributors/devel/development.md#go)
for a mapping of k8s versions to the Go versions they support.

## Initial Setup

<iframe src="https://giphy.com/embed/UgCrYMxLhgPSM" width="480" height="261"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/bacon-food-ron-swanson-UgCrYMxLhgPSM">via
GIPHY</a></p>

Our first step is creating a fork of the
[kubernetes](https://github.com/kubernetes/kubernetes) repo via the Github UI.
If this is your first time creating a fork, Github has [documentation](https://guides.github.com/activities/forking/).

After, creating your fork, we will want to clone your forked repo onto your
local machine, taking care to ensure its in the proper location relative to our
$GOPATH. We can ensure this with the following commands:

```
$ mkdir $GOPATH/src/k8s.io
$ cd $GOPATH/src/k8s.io
$ git clone git@github.com:YOUR_USERNAME/kubernetes
```

Additionally, we want to ensure we stay synced with upstream changes, by adding
the main kubernetes repo as a remote.

```
$ git remote add upstream https://github.com/kubernetes/kubernetes
```

Running `git remote -v` should now show both your
`git@github.com:YOUR_USERNAME/kubernetes` repo, labelled as `master` and the
`https://github.com/kubernetes/kubernetes` repo, labelled as `upstream`.

We can then use the following commands to ensure our local master branch mirrors
upstream master.

```
$ git checkout master
$ git fetch upstream
$ git rebase upstream/master
```

Kubernetes development occurs exceptionally rapidly, so we want to continuously
be rebasing our local master on the latest `upstream/master`. Kubernetes [Github
documentation](https://github.com/kubernetes/community/blob/master/contributors/guide/github-workflow.md)
has a helpful diagram of this entire flow.

## Getting our hands dirty with the k8s source

<iframe src="https://giphy.com/embed/l0G18z7GEVKT3Qqc0" width="480" height="362"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-17-the-simpsons-17x13-l0G18z7GEVKT3Qqc0">via
GIPHY</a></p>

Now that we have the Kubernetes source code, we have multiple options for
getting started. One option is building this project's final output binaries,
like kubectl. Another option is executing the project's unit tests. We'll
explore how to do both.

Kubernetes makes heavy use of [Make](http://man7.org/linux/man-pages/man1/make.1.html)
as a developer tool for executing tests, building binaries, etc. While you
certainly don't need to be an expert in Make, a familiarity with how it works can
be helpful.

### Building binaries

We'll start our exploration of building binaries from our fork of the Kubernetes
source by building and using the kubectl, which almost every Kubernetes
user has used. Running `make WHAT=cmd/kubectl` will build just the
kubectl binary. If the command succeeds, the binary will be placed in
`./_output/local/go/bin/kubectl`. If we execute `./_output/local/go/bin/kubectl
version`, we should see the `GitCommit` for the `Client version` is equal to the
output of `git rev-parse HEAD`, showing this kubectl binary was built from
the Kubernetes source code on our local machine.

We can further experiment by making modifications to the source code and seeing
them reflected in our binary. For example, let us apply the following patch to
`./pkg/kubectl/cmd/cmd.go`:

```
                Use:   "kubectl",
                Short: i18n.T("kubectl controls the Kubernetes cluster manager"),
                Long: templates.LongDesc(`
+      It's fun to mod Kubernetes.
       kubectl controls the Kubernetes cluster manager.
```

If we then rerun `make WHAT=cmd/kubectl` and execute
`./_output/local/go/bin/kubectl`, we should see the line `It's fun to mod
Kubernetes`. Obviously this change is exceptionally small scale, but it reflects
how we can create binaries from our local copy of the Kubernetes source code.

### Running unit tests

Another great way to gain familiarity with a project is executing the unit
tests. Running `make test WHAT="./pkg/controller/podautoscaler/..."`, for
example, will execute all of the unit tests for the podautoscaler controller.

It can be interesting to try and force the test suite to fail. If we open
`pkg/controller/podautoscaler/horizontal_test.go`, and add the test shown below,
then rerun `make test WHAT="./pkg/controller/podautoscaler/..."`, we should see
test failures.

```
func TestScaleUpFail(t *testing.T) {
        tc := testCase{
                minReplicas:             2,
                maxReplicas:             2, // ensures actualReplicas will be 2
                initialReplicas:         3,
                expectedDesiredReplicas: 5,
                CPUTarget:               30,
                verifyCPUCurrent:        true,
                reportedLevels:          []uint64{300, 500, 700},
                reportedCPURequests:     []resource.Quantity{resource.MustParse("1.0"), resource.MustParse("1.0"), resource.MustParse("1.0")},
                useMetricsAPI:           true,
        }
        tc.runTest(t)
}
```

See the [testing docs](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-testing/testing.md)
to better understand the options when executing tests.

## Next steps

With these initial successes under our belt, there are a variety of next steps
we can take. We can try and build all the binaries (`make quick-release`) or
execute all the unit tests (`make test`). Alternatively, we can try executing the integration
tests, as outlined in the [integration testing
documentation](https://github.com/kubernetes/community/blob/master/contributors/devel/sig-testing/integration-tests.md).
Or, we can start looking for a [good first issue to
tackle](https://github.com/kubernetes/community/blob/master/contributors/guide/help-wanted.md).
When the time comes, Kubernetes has [helpful
documentation](https://github.com/kubernetes/community/blob/master/contributors/guide/pull-requests.md)
on crafting a successful pull request.

The best of luck on the journey of contributing to Kubernetes! I've found it to
be quite a lot of fun and hope you do too :)

<iframe src="https://giphy.com/embed/xT0BKiK5sOCVdBUhiM" width="480"
height="270" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/friends-nick-at-nite-xT0BKiK5sOCVdBUhiM">via
GIPHY</a></p>
