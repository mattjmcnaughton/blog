+++
title = "Getting Started Contributing to Popular Open-Source Projects"
date = "2017-12-27"
categories = ["Essays"]
+++

Few programming experiences are more informative or rewarding than meaningfully
contributing to open-source software. However, even programmers with strong
technical skills can experience discouragingly high barriers to entry when contributing to a new
project. This barrier to entry feels particularly high for the popular,
high-velocity projects. Unfortunately, these projects are often those which
first catch the eye, and attract us to open source. Overwhelming. Perhaps Steve Harvey shows
it best...

<iframe src="https://giphy.com/embed/Wv1LRsa2f2afm" width="480" height="441" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/sad-frustrated-steve-harvey-Wv1LRsa2f2afm">via GIPHY</a></p>

Fortunately, a couple of techniques exist which can ease your transition and
help you make meaningful contributions faster. I suggest these techniques based
on my experiences contributing to
[Kubernetes](https://github.com/kubernetes/kubernetes/), a popular container
scheduler and manager from Google. In a couple of months this fall, I went from one or two
minor documentation commits to ~15 commits. While attempting to ramp up my
involvement, I found *being a gardener*, *starting small*, and *creating
routines* exceptionally helpful. I explain more about each technique
below in the hopes that you'll find them helpful too.

## Be a gardener

<iframe src="https://giphy.com/embed/10MiARCLPnbCwM" width="480" height="251" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/puppy-shiba-inu-10MiARCLPnbCwM">via GIPHY</a></p>

If you haven't yet read illustrious open-source contributor Steve
Klabnik's [How to be an Open-Source
Gardener](http://words.steveklabnik.com/how-to-be-an-open-source-gardener) blog
post, I'd recommend doing so right now. He discusses how he got
involved with Rails development, not through making large commits, but through
helping with issue triage and documentation.

I found one idea particularly helpful as I tried to increase my Kubernete's
contributions. In his blog post, he recollects how he read every single open issue on Rails
before he began triaging, documenting, or coding. While it is undoubtedly
tempting to dive in and start making PRs, Steve's strategy ensures you have the
proper context to make informed decisions. Which sections of the code are buggy?
Which sections of the code have heavy churn? Github holds the answers to both
these questions and more in either issues, pr discussions, or commit logs.

You might say, "we can't all be Steve Klabnik reading 800 issues over the course of a
weekend. Especially with a large project, I'll be reading issues forever?"
You make a great point, which leads me to my second technique that I've found absolutely vital.

## Start small

<iframe src="https://giphy.com/embed/zQhFEBrX6plKg" width="480" height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/yoda-zQhFEBrX6plKg">via GIPHY</a></p>

My previous technique suggested pursuing depth as the way to get your foot in
the door on a new open-source project. But unless you are going to spend 16 hours a
day working on open-source, you can't have deep knowledge everywhere.
You'll need to couple your pursuit of depth with a
reduced field of focus. In other words, start small. Pick a distinct section of
the code base, and dive deep by reviewing issues, past commits and PRs. By
focusing on a smaller section of the code base, its easier to develop the
context and knowledge allowing you to make intelligent code, documentation, and
issue triage contributions.

Picking a section of the code base is a personal decision dependent on a number
of factors. Consider what type of velocity you're comfortable with - do you want
new issues to be popping every day, or do you want the ability to take a week
long break, and come back and not feel overwhelmed? Additionally, think if
there's an area of the code base in which you have a competitive advantage, or a
segment of the project which seems particularly welcoming to newcomers.

For issue triages, code review, and commits, I focus almost
exclusively on the auto-scaling components of Kubernetes.
Kubernetes. I chose the auto-scaler using the above criteria. It's not a particularly
high-velocity component of Kubernetes at this point, which is perfect for me as
I can only contribute on nights and weekends. Additionally, I worked with
auto-scaling in Kubernetes a couple of years ago for my undergraduate thesis.
While my thesis work resulted in limited open-source contributions, it did leave
me with a good knowledge of how auto-scaling, specifically in Kubernetes, works.
Plus, I'd interacted with members of the auto-scaling community and knew how
insightful and friendly they are.

## Create Routines

<iframe src="https://giphy.com/embed/xTiTnxCaP0qE2XYalO" width="480" height="360" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/spongebob-squarepants-squidward-routine-xTiTnxCaP0qE2XYalO">via GIPHY</a></p>

My final piece of advice isn't revolutionary but I think its perhaps the most
important. As much as possible, create a routine for yourself when getting
started on a new project, and stick to it. In my experience, coding is only half
the battle in making open-source contributions. Equally important was diligently
keeping up to date on my open PRs and shepherding them along to getting merged.
Similarly, keeping up to date each day means I never have to repeat the initial
deep dive into the historic PRs.

When contributing to Kubernetes, I maintain the following routine. Each morning,
before work, I check in on my outstanding PRs. Depending on their state, I'll
either address code review feedback, give the reviewer a friendly ping, or just
wait. Then I'll check if there are any new issues or PRs in the auto-scaling
portion of the code base, and address them if I have the knowledge. Only then
will I start working on code.

## Summary

In summary, getting started contributing to a new, popular open-source project
isn't easy. But there are some ways to make it easier. Hope this helps - happy
hacking :)

<iframe src="https://giphy.com/embed/3oAt230cSOP0AEVXqg" width="480"
height="480" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/3oAt230cSOP0AEVXqg">via GIPHY</a></p>
