+++
categories = ["Programming"]
date = "2016-05-06T00:52:55-04:00"
tags = ["programming", "git"]
title = "Rebasing Git Commits"
+++

I ran into a bit of trouble while working on some open source recently. I've
been trying to start contributing a little to the
[rubocop](https://github.com/bbatsov/rubocop/) project which I'm super excited
about. One of the requirements for making a pull request is that all the commits
made while working on the features branch are squashed into one.

This requirement makes perfect since it keeps the master branch much cleaner.
However, I'd never done this before, so at first it was pretty confusing.

Turns out it's not that bad. The first step is finding the base commit. This is
done by checking out the branch you want to merge with

```bash
git merge-base YOUR_BRANCH BRANCH_TO_MERGE_WITH
```

This command will output a hash, which we'll call BASE\_HASH. The next step is to
run:

```bash
git rebase --interactive BASE_HASH
```

A text editor will pop up. With a list of commit messages prefixed with either
*squash* or *pick*. For all except the topmost commit message, switch the prefix
from *pick* to *squash*. Save and exit the text editor. You will then be asked
to enter a commit message that you want to use for all of your squashed commits.
After this, you are done. All of the local commits you prefixed with *squash*
have been squashed into one.

There is still the matter of updating remotely. To update my branch on github,
this was as simple as running

```bash
git push -f
```

 The tutorial I read said to make sure that my git push default was simple, with
 the command:

 ```
 git config --global push.default simple
 ```

 And you're done! The awesome part is that after I squashed the commits, and
 forced my github branch to update with `git push -f`, my pull request was
 automatically updated from containing 4 commits to containing just the one
 squashed commit. Just another reminder of powerful git and github are!

 A final note of warning, my understanding of git rebasing is that if you try
 and do it with a branch that has already been merged with another branch, it
 can be very tricky and complicated, so make sure you fully understand what you
 are doing before attempting that
