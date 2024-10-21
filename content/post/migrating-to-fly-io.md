+++
title = "Migrating to Fly.io"
date = "2024-10-20"
categories = ["Projects"]
thumbnail = "img/fly-io.jpg"
+++

When I wrote my last post about [stepping back](/post/stepping-back), I didn't
anticipate it'd be over four years until I posted again. And yet, 1,486 days
have passed since I posted last.

Whoops.

Even more embarassing, the SSL cert expired sometime over the summer. My process
for rotating the certs required around ~15 minutes of [manual ops
work](https://github.com/mattjmcnaughton/nuage/blob/83116b3318b7711e951af4a53df4eee4f79b07a4/docs/playbooks/ssl-certs.md)
every 90 days.[^1] Honestly, I'm giving myself credit for keeping the cert fresh
for over three and a half years, but over a delightfully packed summer,
the need to manual action caught up with me.

At minimum, I wanted this site's content backlog to be accessible, and I'd like
the blog to be ready if I decide to start posting again.

I'd been letting different ideas for migrating the blog percolate. I knew my
current solution, outlined in [this post](post/back-to-basics), was too
heavy-weight. In addition to the manual cert generation/rotation, I no longer
had the appetite for managing EC2 instances (even with all the investments in
Packer, Ansible, and Terraform). And I knew I definitely didn't want to
[self-host a k8s cluster](/post/blog-running-on-k8s) just to run this blog.

I thought briefly about doing a static site on S3, but I already explored that
path in [college](https://github.com/mattjmcnaughton/sdep) and didn't feel
like I'd learn much from this path.

I also thought about using [sourcehut pages](https://srht.site/). I've used
this strategy for simple static sites before (specifically, the incredibly important
task of making a [website](https://worldsbestpug.com) for my dog). [sourcehut
pages](https://srht.site) have some
[limitations](https://srht.site/limitations), but I think my blog would've
been compliant (or it least could've been with minor tweaks).

During the time I was letting ideas marinate, I kept on seeing
[Fly.io](https://fly.io) pop-up in different places. Looking back, I can't
remember the exact sources, although they definitely included the [Changelog
podcasts](https://changelog.com/) and Xe Iaso's
[blog](https://xeiaso.net/blog/fly.io-heroku-replacement/). Ultimately, I
decided to give [Fly.io](https://fly.io) a try, and as of today, this site is served by
[Fly.io](https://fly.io).

I'm definitely still early days w/ [Fly.io](https://fly.io), but I see a lot to
like. I was impressed with the ease of launch
(it took me less than an hour to deploy this [static site]()
with [custom domain](https://fly.io/docs/networking/custom-domain/)
and [SSL](https://fly.io/docs/networking/custom-domain/#get-certified)).
At the same time, it appears Fly offers a
lot of power tools, with excellent [docs](https://fly.io/docs/), for diving
deep. So far, I'm running this simple static blog on 2 machines, each with 1 CPU
and 256mb RAM, for less than $5 per month.

If you're curious around the process of migrating to [Fly.io](https://fly.io),
it's quite simple. This [PR](https://github.com/mattjmcnaughton/blog/pull/70)
deploys the app (i.e. packages the site into a simple Docker container running nginx and runs `fly launch`
to generate `fly.toml`). With the app deployed, this [PR](https://github.com/mattjmcnaughton/nuage/pull/3)
sets up the proper DNS records. To add SSL, just run `fly certs add
$HOSTNAME` for each $HOSTNAME.

I'm excited about how simple and affordable it is to get started with [Fly.io](https://fly.io), and excited
to experiment with this platform further.

Many exciting changes in my life since I last updated this blog... but I'll save that for a
separate post (and maybe updating the [About](/about) page as well). But one
update that can't wait is that I've become a dad to the [world's best
pug](https://worldsbestpug.com).

And, that's it!  In all my leisure code and writing, I'm mostly focusing on keeping it fun and
interesting for myself, so not going to target any explicit writing schedule,
etc. But hopefully will be a little more frequent than my historical rate of once
every four years :)

[^1]: Specifically, I was generating a wildcard DNS cert via Let's Encrypt. That
    cert lasted 90 days. I hadn't made investments in automating that process.
