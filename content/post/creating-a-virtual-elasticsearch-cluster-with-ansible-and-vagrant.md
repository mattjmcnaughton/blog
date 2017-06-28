+++
categories = ["Tutorial"]
date = "2017-06-26T09:41:46-04:00"
tags = ["tutorial", "elasticsearch", "distributed-systems", "ansible"]
title = "Creating a Virtual ElasticSearch Cluster with Ansible and Vagrant"
+++

## Running ElasticSearch locally - its not so bad... right?

For such a powerful distributed system, running
[ElasticSearch](https://www.elastic.co/products/elasticsearch) locally is
surprisingly doable. Assuming you already installed Java on your machine - and set up
the appropriate apt repositories if you are on Debian -
a simple *[brew|apt-get] install* will do the trick.
Run *elasticsearch* with the appropriate configuration from the command
line, and
```
curl http://localhost:9200/
```
should show your local instance is up and running. If you are only performing
simple operations, this local instance will suffice - and you probably don't
need to read the rest of this post. But if you plan on delving deeper into
ElasticSearch - testing performance, experimenting with parallelization, and
fire drilling disaster recovery - you'll need more than the single node setup
from *brew install*.

<iframe src="https://giphy.com/embed/xT5LMRI5onBjAXot3y" width="480"
height="368" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-10-the-simpsons-10x2-xT5LMRI5onBjAXot3y">via
GIPHY</a></p>

## Enter virtual-elasticsearch-cluster

I found myself in said situation earlier this week, wanting to analyze the
number of host's impact on query time. Using
[Vagrant](https://vagrantup.com), a cross-platform program to manage virtual
machines, and [Ansible](https://www.ansible.com), a popular server provisioning
and automation platform, I created
[virtual-elasticsearch-cluster]
(https://github.com/mattjmcnaughton/virtual-elasticsearch-cluster). With
**virtual-elasticsearch-cluster**, setting up a multi-host, multi-node virtual
ElasticSearch cluster on your local machine is trivial. Clone the repo from
Github and run
```
./install.sh
```
and you're in business. The master nodes runs on the IP address
*http://192.168.2.4* and listens on the standard port *9200*. Running
```
curl http://192.168.2.4:9200/_cluster/health?pretty
```
will show the existence of 2 master nodes and 2 data nodes, spread across three
different virtual machines.
Stopping the cluster is equally simple - just run *vagrant halt* from the
project directory. If you are done with the cluster and no longer want the
virtual machines occupying disk space, run *vagrant destroy*.

Because of the flexibility of Vagrant and Ansible,
you can use [virtual-elasticsearch-cluster]
(https://github.com/mattjmcnaughton/virtual-elasticsearch-cluster/) as a
template for any ElasticSearch configuration. Want a different ElasticSearch
version? Modify *ansible/playbook.yml*. Want to access your master through
a different private IP address than *192.168.2.4*? Edit *Vagrantfile*. The
options go on and on. In the future, I'm considering improving *install.sh* so
you can set configuration options when you run the script, and without having to
manually edit files.

I hope you find [virtual-elasticsearch-cluster]
(https://github.com/mattjmcnaughton/virtual-elasticsearch-cluster/) as helpful
as I have. As always, please reach out through
[Github](https://github.com/mattjmcnaughton/virtual-elasticsearch-cluster/),
[Twitter](https://twitter.com/mattjmcnaughton), or email
($WEBSITE_DOMAIN_NAME@gmail.com) with any contributions, issues, or feedback.
Happy hacking.

<iframe src="https://giphy.com/embed/SwImQhtiNA7io" width="480" height="297"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/dogs-look-ridiculous-SwImQhtiNA7io">via
GIPHY</a></p>
