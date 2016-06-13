+++
categories = ["Programming"]
date = "2016-06-13T03:23:41Z"
tags = ["programming", "heroku", "rails", "deploy"]
Title = "New Vs Tried And True"
+++

Going into a new project, I'm bringing in a ton of new concepts, tools, etc.
that I'm interested in exploring. Additionally, when I'm in the position to make
decisions about the design and implementation of the software, its often a hobby
project where learning is more important to me than the final result. As such,
I'll often pursue a lot of immediate learning opportunities.

I thought this front-loading of learning provided the most opportunities for
advancement. Yet, working on a couple of projects, especially
[shoutout](https://github.com/hackmh/shoutout), has shown how I am missing
out on the learning which comes from the later stages of working on a project.
Thus, with [shoutout](https://github.com/hackmh/shoutout) my current focus is
growing and managing a deployed application.

This prioritization guided me when making decisions about how to deploy this
app. Having worked on [Kubernetes](http://kubernetes.io/) pretty extensively
over the course of my [thesis](https://github.com/mattjmcnaughton/thesis), I
wanted to take the next step of hosting my own Kubernetes cluster and using it
to run a production application. However, I also knew such an effort would
undoubtedly present a number of unexpected roadblocks, particularly with respect
to managing SSL certificates, managing logs, etc. While these problems
would provide learning opportunities, they would also prevent me from the
learning obtainable from managing a deployed application. As such, I decided to
deploy the application through Heroku, taking advantage of the simplifications
Heroku offers, such as free, easy to setup
[SSL](https://ryanboland.com/blog/completely-free-easy-to-setup-ssl/).

Ultimately, determining my goals for a project, and the different types of
learning I hoped said project would engender, guided my decision making. And
don't get me wrong... I'll always be guilty of chasing the latest and greatest
in my personal projects, because, for me, the ever-changing array of programming
options available is one of the most exciting parts of programming. But for this
project particularly, I'm working to reign in that inner urge.
Interested in seeing the results? Check out shoutout on
[Github](https://github.com/hackmh/shoutout) and on the
[interwebz](https://shoutout.hackmh.com).
