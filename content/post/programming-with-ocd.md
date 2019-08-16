+++
title = "Programming with OCD"
date = "2017-11-18"
categories = ["Essays"]
+++

Like over 3 million Americans, I struggle with OCD. OCD has impacted, and probably
always will in some capacity impact, my life a lot. Unfortunately, software
engineering, both my career and one of my favorite hobbies, is no exception.

## What is OCD?

<div style="width:100%;height:0;padding-bottom:56%;position:relative;"><iframe src="https://giphy.com/embed/cMVgEhDeKzPwI" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/barkpost-pugs-pug-life-gif-cMVgEhDeKzPwI">via GIPHY</a></p>

Everyone who suffers from OCD has a different experience. For me, OCD manifests
as certain distorted thoughts sticking in my brain. These sticky thoughts are
typically catastrophic events touching on some of my deepest fears and most
cherished values. Intellectually I know these events have little chance of
happening, but OCD doesn't care.

### What's an example??

Suppose I just finished baking a
loaf of bread, and am about to head out of my apartment for work. As I lock the
door, an OCD thought arises: did I turn off the oven? Someone who didn't
suffer from OCD would have this thought pop up and think *of course I turned off
the oven - I always turn off the oven*. Then they'd walk out the door and
continue their day as normal. However, when someone with OCD has this thought,
OCD might respond with *but what if you didn't? You'll burn your apartment down,
and you'll be homeless, and your neighbors will lose everything, etc.* Before
I began treatment for OCD, I coped with these obsessive thoughts in what seemed
like the best way: I performed compulsions. I would go back and check that the
oven was off. I'd hit the off button several times just to be extra sure. I'd
take a picture of the oven dial in the off position so that if obsessive
thoughts rose throughout the day, I could ward them off with photo evidence.

### More generally...

In the immediate moment, these compulsions provide relief. However, with OCD
they also accomplish a more nefarious end, as they reinforce
that the original catastrophic event was likely to occur and that performing
the compulsive action was the only hope for stopping it. In our specific
example, my brain learns that there was a significant threat of the house
burning down. If there wasn't, why would I have spent so much time checking the
stove was turned off? Moreover, the house didn’t burn down after I checked the
stove was off in a myriad of creative ways. My brain learns
I can keep my house from burning down in the future,
and prevent all of these terrible consequences if I always
perform these rituals whenever I use the oven. It’s a dangerous cycle which
increases both the power of these obsessive thoughts to stick in the brain, and
the need to perform these compulsions when confronted with one of these
thoughts.

For people with OCD, the obsessive thoughts typically fall into recognizable
categories. Most of my obsessive thoughts can be described as
catastrophizing, emotional reasoning, and hyperresponsibility, and there are
many other categories impacting OCD sufferers. Similarly,
compulsions fall into definable categories. Checking is my most
prominent compulsion related to programming, although again there are many
options.

## How can OCD impact a programmer?

<div style="width:100%;height:0;padding-bottom:75%;position:relative;"><iframe src="https://giphy.com/embed/vzO0Vc8b2VBLi" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/vzO0Vc8b2VBLi">via GIPHY</a></p>

### More examples!

Let’s imagine that I work at Twitter (I don’t).
I’m working on changing the color of the login button. I submit my diff with
some CSS changes, it's approved in code review
and everything is working fine. But suddenly, a thought pops up in my head. What
if by changing the login button, I somehow made it so that anyone could login to
any account they wanted? Here comes the catastrophization. Think of all the
damage that could cause. A huge violation of privacy. Twitter might go out of
business. A ton of people could lose their jobs, and it would all be my fault.
Now its time for some hypersponsibility. I need to ensure that this didn’t
happen. So it’s time for the compulsive checking.
I try logging in with the wrong password and I can’t. Thank
god. I feel some temporary relief.

But then, maybe an hour later, another thought pops in my head. What if it is
only for certain passwords that my change broke logging in? Again, the same
catastrophizing, the same hypperesponsibility, and the same checking. And then
in another hour, another thought with a slight variation of the problem.
And another. Each time one of these thoughts
comes, it is accompanied by anxiety, which the compulsion only partially
relieves. Eventually, the left behind anxiety builds up, and keeps my body in
a somewhat anxious state even when not directly having the obsessive thoughts.
This buildup is particularly dangerous because it leads to emotional reasoning.
My body feels bad... that means something must be wrong. I just haven’t found it
yet. Before pursuing treatment, I would
continue this cycle unchecked, increasing my stress and anxiety with each
performance of a compulsion.

### Particular difficulties of OCD and programming

This cycle is difficult enough regardless of the content matter. Yet, there are
some aspects of my OCD that I find particularly difficult as they relate to
programming. First, there’s the difficulty in determining what is an
“appropriate” amount of checking. In either parts of my life, working with
counselors, friends, and family to establish “normal” levels of behavior has
been really helpful. As I mentioned before, pretty much everyone agrees on how
much it is appropriate to check the stove is off. Unfortunately, with programming,
it's a lot more difficult. The problem space is
complex, and often knowing if a certain precaution is healthy or compulsive
requires deep knowledge of the system. Unfortunately, this complexity means that
a typical mental health professional or family member may not be much assistance
in providing behavioral guide posts.

Additionally, compulsive checking during the software engineering process can be
extra tricky to stop because it feels so much like the right thing to do. While in the
contrived example from before, its pretty obvious that a CSS change will not
impact password security, few aspects of programming are that simple or
harmless. In those situations, much of software engineering is about
being careful and meticulous, and it can be difficult to draw the line
between responsible and obsessive.

## How Treatment Helped

<div style="width:100%;height:0;padding-bottom:56%;position:relative;"><iframe src="https://giphy.com/embed/yoJC2qNujv3gJWP504" width="100%" height="100%" style="position:absolute" frameBorder="0" class="giphy-embed" allowFullScreen></iframe></div><p><a href="https://giphy.com/gifs/dog-hello-pun-yoJC2qNujv3gJWP504">via GIPHY</a></p>

Thankfully, I write this post feeling like I've made considerable progress in
decreasing the impact of OCD on my life. In the past couple of years, I've
been fortunate to find a therapist with whom I have a great working relationship. Together,
we've found a medication plan which works for me, and undertaken a
course of exposure therapy. Exposure therapy is pretty simple: sit with the obsessive thoughts without
performing compulsions. Leave the house without checking the oven. Change the
CSS without logging in multiple times. And so on. Do this enough, and you can unwind the previously
existing cycles of obsession and compulsion.

### In Summary...

I write this post, and provide these examples, in the hopes that it will be
helpful to other programmers who have struggled, or are still struggling, with
OCD. You are not alone. I also write this post, because I know that at least for
me, I lived with OCD symptoms for a long time before I realized that
there was a name and treatment for what I was feeling. Finding a name and
treatment path for what I was struggling with was a great
source of hope, even when there was still a lot of difficult work on the
horizon.

OCD is a tricky beast. I won't pretend it no longer has any impact on my life or
my programming, but thanks to treatment and medication, that impact is
significantly less than it was a couple of years ago, and it continues to
diminish everyday. When obsessive thoughts do arise - and I think they will
continue to arise for the rest of my life - I have tools I've learned to deal
with them. Perhaps most importantly, I've worked to be comfortable talking about
this part of my life with family and friends.

I am always eager to talk with anyone who is feeling a similar way - whether I
can offer any guidance or help, or just someone to listen. Please email me at
mattjmcnaughton @ gmail.com :)

<br>

<hr>

<br>

### [Aug 2019] Update

Thank you so much to everyone who has reached out to me about reading this post
- it really means a lot :)

#### Book Recs

In a lot of my emails, I found myself recommending the same books, so I thought
I'd go ahead in post them here.

- [The Mindfulness Workbook for OCD](https://www.amazon.com/Mindfulness-Workbook-OCD-Overcoming-Compulsions/dp/1608828786/)

One particularly helpful component of this book is it does a good job describing
the different ways OCD can manifest. Early on in my OCD journey, I found it an
integral part of better understanding my own OCD. It also offers tools for
managing OCD derived from combining mindfulness practices with cognitive
behavioral therapy.

- [Freedom from Obsessive Compulsive Disorder](https://www.amazon.com/Freedom-Obsessive-Compulsive-Disorder-Personalized/dp/042527389X/)

In my experience, this book provides good background info on OCD, and also
rich concrete advice around creating a recovery plan. I think it can be helpful both
for those struggling with OCD and those who have a loved one struggling with
OCD.

- [The Man Who Couldn't Stop](https://www.amazon.com/Man-Who-Couldnt-Stop-Thought-ebook/dp/B00LDR38IU/)

David Adam's auto-biography discusses his personal experience with OCD, in
addition to providing scientific/historic background on OCD. This book can be a
helpful way of remembering that those of us who struggle with OCD are not alone.

#### In summary... (once again)

Thank you again to the people who read those post and to those who reached out.

As I said in my original post, I am always eager to talk
with anyone who is going through their own OCD journey - whether I
can offer any guidance or help, or just someone to listen. Please email me at
mattjmcnaughton @ gmail.com :)
