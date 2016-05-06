+++
categories = ["Programming"]
date = "2016-05-06T05:06:18Z"
tags = ["programming", "go", "debugging"]
title = "Godebug"
+++

I'm a big fan of the pry library for Ruby, which essentially provides a debugger
for Ruby. I love having the ability to step through code and check the values of
variables at breakpoints without having to litter my code with print statements.

I was hoping to do something similar with Go, but to be honest was a little wary
of using gdb. Thankfully, there is a great project from Mailgun called
[godebug](https://github.com/mailgun/godebug), providing a really great debugger
for Go. By simply adding a

```
_ = "breakpoint"
```

expression, it is possible to set
a breakpoint. Then, run the code with

```
godebug run FILE_TO_RUN
```

You can also run your tests with

```
godebug test ...
```

Importantly, if your breakpoint is in a
package, then the package must be included with the `-instrument` flag.

Overall, a really useful tool, that was really helpful for me while writing some
Go code! Check out a more in-depth
[description](http://blog.mailgun.com/introducing-a-new-cross-platform-debugger-for-go/)
on the Mailgun blog!
