+++
title = "Concurrent Futures in Sheepdoge: How a few lines of code resulted in a 78% performance improvement"
date = "2017-12-29"
categories = ["Projects"]
thumbnail = "img/concurrent-futures.jpg"
+++

For the past couple of months, I've been working on
[Sheepdoge](https://github.com/sheepdoge/sheepdoge), a tool for managing your
personal Unix machines with Ansible. It's like
[boxen](https://github.com/boxen), but for Ansible.

One new sheepdoge feature I'm particularly excited about is the use of `concurrent.futures`
during `sheepdoge install`. `concurrent.futures` provides a high-level API for
executing code asynchronously, making adding thread/process based concurrency
trivial. It is a standard library python module as of 3.2, and is available on python 2.7 through the
[futures](https://pypi.python.org/pypi/futures) backport.

### Why concurrency for `sheepdoge install`?

The `sheepdoge install` execution path is an excellent candidate for this
concurrency. At a high level, we can think of `sheepdoge install` like the `pip
install -r requirements.txt` command. Both take a list of packages hosted at a
remote location and install them into a specified directory on the host machine.

Examining the work profile of `sheepdoge install` shows it is a good theoretical
candidate for parallelization. Both downloading packages from a remote location
and installing them into a specified directory are I/O heavy operations.

### Analysis

When we run `time sheepdoge install --no-parallel`, we get the following:

```
real 7.115s
user 0.246s
sys  0.244s
```

From this output, we know the `sheepdoge install --no-parallel` command took 7.115s to
execute. However, it was only using the CPU for ~.5s. Given I ran this test on
my laptop, with no other processes consuming a large amount of CPU, I conclude
that the ~6.5 seconds unaccounted for by the summation of user and sys was
time spent doing IO. Additionally, when run sequentially, the `install` command blocks during
IO operations, meaning the CPU does nothing related to `sheepdoge` until the next
IO operation completes. In other words, we're not maximizing our utilization of
computing resources.

However, if we run `sheepdoge install --parallel`, we can keep the CPU working
while we wait for IO operations to finish. Furthermore, we can begin multiple IO
operations at once, since the system is easily able to parallelize these
operations. These optimizations lead to big speed improvements, as we can see
from the output of `time sheepdoge install --parallel`.

```
real 1.498s
user 0.272s
sys  0.294s
```

As you can see, we've vastly decreased the time where resources sit idle,
improving overall run time by 78%!

### Using `concurrent.futures`

Adding concurrency through `concurrent.futures` is simple. Because each
process we're executing is independent, we only needed to change a couple lines of code
and do not have to worry about locking, memory sharing, etc. Note that
`pup.install()` is the I/O heavy method responsible for downloading the remote
package and installing it in the proper location.

Without `concurrent.futures`:

```
def _execute(self):
    for pup in self._pups_to_install:
        pup.install()
```

With `concurrent.futures`:

```
from concurrent.futures import ThreadPoolExecutor, wait

...

def _execute(self):
    with ThreadPoolExecutor(max_workers=self._max_workers) as executor:
        install_futures = {
            executor.submit(pup.install) for pup in self._pups_to_install
        }

        wait(install_futures)
```

You can find further documentation for all the different ways to utilize `concurrent.futures`
[here](https://docs.python.org/3/library/concurrent.futures.html).

### Wrapping up

`concurrent.futures` is a great tool for speeding up I/O heavy portions of your
code, and I hope this post will point you towards some places in your code base
where it could make a performance difference. And if you're interested in using
or contributing to [sheepdge](https://github.com/sheepdoge/sheepdoge), please
get in touch!
