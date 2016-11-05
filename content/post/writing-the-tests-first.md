+++
tags = [
  "programming",
]
categories = [
  "Programming",
]
date = "2016-11-05T20:41:02Z"
title = "Writing the Tests First"
+++

Since I've started programming, I've always known that I should write tests. And
in almost all situations, the benefits of testing, namely greater confidence in
the current and future code correctness, caused me to take the time at the end
of a pull request to tests related to any new features or changes. However,
writing these tests felt like eating my programming vegetables. I had finished
the fun work, writing the feature, and now I had to do these extra steps of
writing tests when I felt like I had already solved the conceptual problem.
Additionally, while the tests would certainly serve a helpful purpose in the
future, by nature of me considering the feature finished, I already felt
like it was working. While I still wrote the tests, I felt like I was performing
some repetitive work because I was supposed to, not because it was making my job
as a developer easier.

However, my opinion towards writing tests has changed over time, as the
situations I'm seeking to solve become more and more complex. Specifically, I've
taken to writing the tests first (as is recommended in true test driven
development). In switching the order of testing and active development, I found
benefits to writing test which convert testing from something I do because I
feel like I should do, to something I do because it makes my job actively
easier.

Writing the tests first has been helpful for a number of reasons. First,
clarifying the feature to a point where it can be tested requires clarifying the
problem into a distinct set of behaviors. This process must occur either way,
but beginning by writing tests forces it to happen at the start. Additionally,
writing robust tests is about identifying edge cases. Again, the edge cases of a
feature will come out at some point, either during development, or testing, or
as an active bug in production. When we start with tests, we recognize edge
cases throughout the entire development cycle. This upfront investment prevents
spending time on solutions that do not address important edge cases. Finally,
writing tests from the start allows us to claim the benefits of testing while we
undertake for development. Most unit tests focus on the specific part of the
code base which we are actively changing. This specificity allows a quicker
development cycle because we can verify our feature is working just by running a
single command. Contrast this single command with manually clicking through
pages on a web app, which requires a lot more time for each change we make. And
of course, not having to take the time after the feature is done to write a unit
test is always a little nice.

I continue to try to remind myself, particularly when faced with a challenging
or amorphous problem, the benefits of starting by writing tests.
