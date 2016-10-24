+++
categories = ["Programming"]
date = "2016-06-15T03:13:49Z"
tags = ["programming", "python", "open source"]
title = "Sdep Working"
+++

Just a short post to announce that
[sdep](https://github.com/mattjmcnaughton/sdep), the tool I wrote for deploying
static websites to [Amazon S3](https://aws.amazon.com/s3/), is working! Check out the
[travis.yml](https://raw.githubusercontent.com/mattjmcnaughton/blog/master/.travis.yml) for
this blog to see how it can be used to easily continuously deploy a blog.

The most exciting personal milestone for me on this project is that its the
first [pip package](https://pypi.python.org/pypi/sdep/0.1.0) I've ever
published. This publishing process has brought all kinds of interesting lessons,
including my first time managing [semver](http://semver.org/). Additionally,
*sdep* serves as the best example from my personal projects of scratching my own
itch and eating my own dog food. I built *sdep* because I wanted it to be really
easy to deploy my own static website using S3,
and I'm actively using *sdep* to do just that with this blog. Finally, I'm proud
of the [documentation](http://sdep.readthedocs.io/en/latest/), both with respect
to the code and to getting an external user up and running.

Certainly a lot of possible improvements exist, but exciting to have a working version!
