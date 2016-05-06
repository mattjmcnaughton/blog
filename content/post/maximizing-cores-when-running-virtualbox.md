+++
categories = ["Programming"]
date = "2016-05-06T05:09:25Z"
tags = ["programming", "vms", "virtualbox"]
title = "Maximizing Cores When Running VirtualBox"
+++

I'm a virtualization geek. When I first found out about Vagrant and VirtualBox,
I was over the moon, and today I'm equally excited about Docker.

I've also been digging into concurrency/parallelization recently. I've been
working in Go a lot more and investigating goroutines and channels. Currently,
goroutines use the maximum possible number of cores to execute in parallel.

Knowing this, I was curious about how many cores I was working with. Running

```
system_profiler SPHardwareDataType | grep 'Total Number of Cores'
```

showed my MacBook Pro had 4 cores. Yet, I was actually running my code on a Docker container on
the Boot2Docker VM. On the VM, I ran

```
nproc
```

which showed my VM was only using one core.

The next step was to make my VirtualBox VM have the same number of cores as my
MacBook. Doing so is really simple. First, power down your VM.
I'm using `docker-machine` so its as simple as

```
docker-machine stop MACHINE_NAME
```

Alternatively, you can do this through the VirtualBox GUI. Next, run

```
VBoxManage modifyvm MACHINE_NAME --cpus NUM_CPUS
```

You can assign however many cores you want (although not more than your physical machine
actually has). Finish by restarting your VM and that's it! You can now
enjoy the full power of multiple cores on your VirtualBox VMs!
