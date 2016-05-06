+++
categories = ["Programming"]
date = "2016-05-06T00:57:53-04:00"
tags = ["programming", "ruby", "rvm", "gemset"]
title = "Ruby Gemsets"
+++

Dealing with library dependencies and versioning can be one of the biggest
headaches with programming. My solution has been to try and keep my development
environments as separate as possible. With ruby, this is easy thanks to
[rvm](https://rvm.io/). With rvm, in addition to giving great control over Ruby
versions, helps solve this problem. It accomplishes this through gemsets. A
gemset is just what it sounds like: a collection of gems to be used in a current
development environment.

My dev flow works like this: whenever I start a new project in ruby, I use

```bash
rvm gemset create PROJ_NAME
```

to create a gemset for that project. In the project
directory, I'll create a file called `.ruby-gemset`, and in it write
`GEMSET-NAME`. Then whenever I enter the directory for the project, rvm will
automatically switch me to using the gemset that I want. Running

```bash
bundle install
```

from the project directory will install those
gems into the gemset for that project. It's a great development workflow
that I'm very happy with! Thanks to the rvm team for making it happen!
