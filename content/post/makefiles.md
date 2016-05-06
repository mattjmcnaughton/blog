+++
categories = ["Programming"]
date = "2016-05-06T01:01:49-04:00"
tags = ["programming", "makefile", "unix"]
title = "Makefiles"
+++

Recently I've added a Makefile to every project I'm working on. I find adding
this file takes only a little bit of time but makes working on my projects
significantly more enjoyable and more cognitively manageable.

More concretely, I've recently been working on a project called **shoutout**.
**shoutout** is a slackbot that collects anonymous thank yous and appreciations
for other employees and sends them out weekly via an email digest. It's a
[hackMH](http://hackmh.com) project - hackMH is a community of individuals
dedicated to using tech to improve mental health.

Anyway, **shoutout** uses Docker and docker-compose. While extremely useful,
powerful tools, they can be a little complicated and require long shell commands
that are difficult to remember. Yet, with a Makefile, I can define much simpler
commands. For example, without a Makefile, running the test suite requires

```
docker-compose run devweb bundle exec rake spec
```

With a Makefile, it's as simple as

```
make test
```

Or consider migrating the database. Without a Makefile,
the bash command is

```
docker-compose run -e RAILS_ENV=development devweb rake db:create
```

With a Makefile, it is as simple as

```
make dbcreate
```

Using a Makefile grants me
all the power of Docker and docker-compose without having to memorize long,
complicated commands.

I'm looking forward to learning more about GNU Make - I know it is a very
powerful tool I'm currently using like a glorified bash alias.

Curious about hackMH or **shoutout**? Learn more and find out how to use tech to
improve mental health w/ hackMH [here](http://hackmh.com/) and contribute to
**shoutout** [here](https://github.com/hackmh/shoutout).
