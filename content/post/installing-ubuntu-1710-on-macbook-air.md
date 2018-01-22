+++
title = "Installing Ubuntu 17.10 on MacBook Air"
date = "2018-01-21"
categories = ["Tutorials"]
thumbnail = "img/linux.jpg"
+++

After a Saturday of disk partitioning, a trip to CVS for an emergency thumb
drive, and much Googling, I'm writing this blog post from a MacBook
Air running Ubuntu 17.10.

I won't write an entire tutorial on the installation, as some great ones already
exist (in particular, I benefitted greatly from [this
tutorial](http://courses.cms.caltech.edu/cs171/materials/pdfs/How_to_Dual-Boot_OSX_and_Ubuntu.pdf)
from CalTech and [this
tutorial](https://www.cberner.com/2017/12/03/installing-ubuntu-17-10-macbook-pro-retina-mid-2012/)
from Christopher Berner). Instead, I'll share why I installed Ubuntu 17.10 on my
MacBook Air, some tips I found helpful during the installation, and the
remaining shortcomings I hope to address in the coming weeks.

## Why Linux on Mac?

<iframe src="https://giphy.com/embed/1iTpx5PpzRugcrZK" width="480" height="270"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/justin-g-why-1iTpx5PpzRugcrZK">via GIPHY</a></p>

When people think about a laptop for running Linux, machines like the Lenovo's
Thinkpads, Dell XPS 13s, and the System 76 line often come to mind. Though not
the norm, the MacBook Air offered definite advantages for me. Most
importantly, I already had one. I didn't need to purchase any new hardware to
have a functional, portable laptop running Linux. Additionally, for a small
lightweight machine, it has workable specs. Its got a 4-core i5 CPU and 4GB of
RAM, which is sufficient for the coding and browsing I'll be doing. Finally,
I've enjoyed, and grown comfortable with, the MacBook's hardware. Previously I'd
installed [GalliumOS](https://galliumos.org/) on an Acer C720 Chromebook, but
found myself reluctant to use it regularly because I didn't like the feel.

Similarly, when people think about an operating system for MacBook hardware,
they don't often think of Ubuntu. I installed Linux, and most specifically
Ubuntu, for a couple of reasons. For a couple of months, I have been
running Ubuntu 17.10 on a [System 76 Wild Dog
Pro](https://system76.com/desktops/wild-dog). The more I ran Ubuntu, the more
unsatisfied I became with OSX. I missed the [i3](https://i3wm.org/) window
manager. Additionally, I grew frustrated context switching between my desktop and my servers,
missing tools like `apt` and `systemd`.  And of course, Ubuntu and
Linux offers considerable advantages in being free and open-source.

Because I already had the machine, was enjoying the Linux experience on my
Wild Dog, and could retain the option of OSX by dual booting, I had
nothing to loose installing Ubuntu.

## Tips for a smooth installation

<iframe src="https://giphy.com/embed/Rk8CZk8M7UHzG" width="480" height="266"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/the-simpsons-reaction-maggie-simpson-Rk8CZk8M7UHzG">via
GIPHY</a></p>

### Follow a good tutorial

I mentioned a couple of tutorials in the introduction. I consulted them
frequently throughout my install and found them invaluable. I've worked with
boot loading, disk partitioning and the other techniques for installing a new OS
a little bit, but have not done these types of installs enough times to have
true familiarity. Additionally, the MacBook hardware works for Linux, but does
have some rough edges. I benefited from others efforts to identify, and propose
fixes for, those tricky components. Finally, dual booting creates its own unique
challenges, as I had to install Ubuntu without adversely impacting my
previous OSX install. I wanted to be confident each operation I was running was
correct. It sounds simple, but its important to remember: find a
good tutorial(s) and stick to it.

### Automate your initial machine provisioning

I've heavily invested in automating my machine provisioning over the past six
months. I've been using [sheepdoge](https://github.com/sheepdoge/sheepdoge) to
provision my machines with packages, configuration files, etc. through ansible.
Additionally, I wrote an additional ansible playbook which I run only once on
any new machine. Its responsible for downloading ssh and gpg keys, vpn profiles,
etc. Because of this configuration investment, my work was pretty much done
after I did the initial boot into Ubuntu. I could just run my two playbooks and
I had workstation identical to the one I'd enjoyed so much on my Wild Dog Pro.

### Get the wifi working

Unfortunately, there's one big gotcha when installing Ubuntu on the MacBook: the
wifi does not work after the initial install. Unfortunately, MacBook hardware
requires non-free wifi drivers, which the base Ubuntu install does not include.
Getting these drivers is as simple as `sudo apt install
bcmwl-kernel-source`. However, there's an unfortunate catch-22, as `apt install`
requires the internet. So we cannot get the wifi working until we perform an
action which requires the internet. On a desktop, I'd recommend just connecting
via Ethernet. However, most MacBook hardware no longer contains an Ethernet
port. It is possible to get an "Ethernet to Thunderbolt" converter, but it costs
around $30. Instead, I prefer to use a USB Wifi Adapter, like this one from
[Raspberry Pi](https://www.canakit.com/raspberry-pi-wifi.html). They're less
than $10, and also can be used on Raspberry Pi's, etc.

## Potential future improvements

<iframe src="https://giphy.com/embed/3orif4alyHEpIZAr0A" width="480"
height="366" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-3-the-simpsons-3x9-3orif4alyHEpIZAr0A">via
GIPHY</a></p>

As happy as I am with Ubuntu on the MacBook Air, I still am looking to make a
couple improvements. First, I've noticed slightly worse battery life when I'm
running Ubuntu compared to OSX. I'm thinking a tool like
[powertop](https://wiki.archlinux.org/index.php/powertop) might be helpful in
improving the default configurations.  Additionally, the trackpad feel
is slightly worse when running Ubuntu,
specifically with respect to multi-touch support. From some quick online
searches, there are fixes, although I haven't explored them thoroughly.
Finally, I haven't even tried the microphone and webcam, but have read they
require some work to get running.

I'll update this post if I make any advances :)
