+++
title = "A Closer Look at Rsync"
date = "2017-12-29"
categories = ["Essays"]
thumbnail = "img/rsync.png"
+++

It's not often that academia analyzes the unix tools we use everyday.
But `rsync` is one fortunate exception as [Andrew
Tridgell](https://en.wikipedia.org/wiki/Andrew_Tridgell) not only wrote `rsync`
while pursuing his PhD, but also published a short and accessible
[paper](https://www.andrew.cmu.edu/course/15-749/READINGS/required/cas/tridgell96.pdf)
outlining its inner workings. While I'd highly encourage reading the entire paper, I took away
one major tl:dr; from the `rsync` algorithm: **be lazy**.
This lesson will be applicable anytime I write performance conscious code.

## Algorithm Overview

Before diving into the benefits of being lazy, we must understand rsync's goals and
implementation. `rsync` is an algorithm for updating a file on machine A to be
identical to a file on machine B. Tridgell optimizes for when the connection
between machine A and machine B is high-latency and when the two files are
similar.

To copy file `a` from machine `A` to file `b` on machine `B`, the `rsync`
algorithm conducts the following high-level steps.

1. Machine `B` splits file `b` into non-overlapping blocks of size `S` bytes.
2. For each block, `B` calculates a weak checksum and a strong checksum.
3. Machine `B` sends the checksums to machine `A`.
4. Machine `A` searches through all possible blocks of size `S` in file `a` to
   find blocks which have weak and strong checksums equal to one of the blocks
   on `B`.
5. Machine `A` uses the knowledge of equivalent blocks to send machine `B` a
   sequence of instructions for constructing a copy of `A`. It only sends `B`
   data which it does not have, so if a block in `a` is a match for a block on
   `b`, machine `A` will not transmit the block to machine `B`.

If you're interested in greater detail, the
[paper](https://www.andrew.cmu.edu/course/15-749/READINGS/required/cas/tridgell96.pdf)
further explains the algorithm, as well as detailing the underlying math and
providing empirical analysis.

## Be Lazy

<iframe src="https://giphy.com/embed/3o6MbedpC11J84sQ4o" width="480" height="362" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a href="https://giphy.com/gifs/season-16-the-simpsons-16x9-3o6MbedpC11J84sQ4o">via GIPHY</a></p>

In order for the `rsync` algorithm to operate efficiently, it must quickly
compare all possible blocks of size `S` in file `a` to the set of
non-overlapping blocks of size `S` in file `b`. To visualize, imagine file `a`
contains `1234567890`, file `b` contains `2345678901` and `S` is two characters.
From step 1 of the algorithm, the blocks from file `b` are `23`, `45`, `67`,
`89`, and `01`. To accurately compare file `a` to file `b`, we not only need to
compare `12` on file `a` to `23` on file `b`, but also `23`, `34`, `45`... on
file `a` to `23` on file `b`. However, we don't want to do an expensive calculation for each
possible block on `a`. Rather, we want to a perform a calculation which allows
us to take our checksum for block `i,j` and with a small amount of work, find
the checksum of block `i+1,j+1`.

Tridgell accomplishes this through the weak checksum calculated in steps 2 and 4
of the algorithm. As he discusses in the paper, given `weak-checksum(i,j)` and values
`i,j+1`, we need to do little additional work to find `weak-checksum(i+1,j+1)`.
Because of this efficiency, the algorithm can very quickly find the weak checksum for
all possible blocks in `a`.

However, the weak checksum is not perfect. In certain scenarios, it will give
false positives and say two unequal blocks are equal.
To be absolutely certain two blocks are equal, we need
to calculate and compare the strong checksum. However, the strong checksum is
more expensive to calculate, and the value of `strong-checksum(i,j)` gives us no
insight into the value of `strong-checksum(i+1,j+1)`.

Tridgell cleverly works around this by **being lazy**, as `rsync` does the hard
work of calculating and comparing the strong checksums only if the weak
checksums are equal. The algorithm carefully avoids doing expensive operations
until they are absolutely necessary by utilizing a cheap approximation, with the
potential for false positives. This technique is applicable to almost any situation involving expensive
computation.
