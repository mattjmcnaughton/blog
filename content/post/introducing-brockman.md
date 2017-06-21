+++
categories = ["Projects"]
date = "2017-06-19T22:48:33-04:00"
tags = ["programming", "bash", "automation"]
title = "Introducing Brockman"
+++

Claiming that us programmers focus most of our programming time on using encapsulation
and automation to reduce complexity is like chefs claiming most of their job
focuses on preparing food, and that heat and recipes are essential tools. Pretty
obvious.

Yet, while we relentlessly pursue encapsulation and automation when enforcing
information-hiding in classes or continuously deploying our applications, our personal
workstations can be the wild west. Essential tasks like system updates,
anti-virus scans, and file garbage collection should be automated. However,
attempts to automate quickly violate encapsulation. Each background process
writes to a different log, if we're collecting its logs at all. We either never know if
our essential background processes failed, or we must remember to inspect multiple
different logs at a regular interval. It is almost not worth it to automate
these tasks at all.

<img src="https://raw.githubusercontent.com/mattjmcnaughton/brockman/master/logo/brockman.png"
 style="height: 50%; width: 50%;" alt="Kent Brockman">

## Enter Brockman

[brockman](https://github.com/mattjmcnaughton/brockman) provides a consistent interface
for reporting on background unix processes. It aggregates all background logs in one
location and facilitates quickly checking if any background processes failed as well
deeply investigating the error output.

For example, suppose we want to run a background
antivirus scan using [clamscan](https://linux.die.net/man/1/clamscan) every five minutes.
We've installed [brockman](https://github.com/mattjmcnaughton/brockman) using the
[README.md](https://github.com/mattjmcnaughton/brockman#install) instructions.
So now, we'll add the following command, on a five minute interval, to the crontab:

```
/$PATH/$TO/brockman.sh report "clamscan -r $PATH_TO_SCAN"
```

[brockman](https://github.com/mattjmcnaughton/brockman) is now reporting on this background scan.
We need an easy way to determine if any failures occurred, and if so, investigate their cause.
[brockman](https://github.com/mattjmcnaughton/brockman) provides two commands for this analysis:
`failure` and `view`. `brockman.sh failure` returns exit code 0 (i.e. succeeds) if
[brockman](https://github.com/mattjmcnaughton/brockman) has unresolved errors, and fails otherwise.
Add the following to the shell initialization script (i.e. `~/.bashrc`).

```
if brockman.sh failure
then
	brockman.sh view alert
fi
```

The `view` command takes either `alert` or `error` as an argument. `alert` will display
which background task failed, and instruct us to run `brockman.sh view error` to
see the error log from the failure. Now, every time we open a new shell,
[brockman](https://github.com/mattjmcnaughton/brockman) will alert us to any failures needing
attention.

Finally, when we've successfully handled the error in the background process, we run
`brockman.sh resolve`. This command prevents [brockman](https://github.com/mattjmcnaughton/brockman)
from alerting us about this failure again.

With [brockman](https://github.com/mattjmcnaughton/brockman), we can automate tasks, without the complexity
of multiple log files or monitoring scripts. Because [brockman](https://github.com/mattjmcnaughton/brockman)
can report on any command executable from the terminal,
we can use it with any background process which logs errors to `stderr` and uses
exit codes to indicate success/failure.

## Wrap Up

I hope that you find [brockman](https://github.com/mattjmcnaughton/brockman) as useful as I have. If you find any
issues or have any ideas for additions, please create an [issue](https://github.com/mattjmcnaughton/brockman/issues)
or [pull request](https://github.com/mattjmcnaughton/brockman/pulls). Thanks to Arnold Robbins and Nelson Bebbe's
excellent book [Classic Shell Scripting](http://shop.oreilly.com/product/9780596005955.do) for its in-depth
information on shell scripting best practices.
