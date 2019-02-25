+++
title = "mattjmcnaughton.com is now https"
date = "2019-02-25"
categories = ["Projects"]
thumbnail = "img/https.jpg"
+++

We're excited to announce all connections to mattjmcnaughton.com, and its
subdomains (i.e. blog.mattjmcnaughton.com, etc.), are now able, and in fact
forced, to use HTTPS. After reading this post, we hope you'll be convinced of the
merits of using HTTPS for public-internet facing services, and also have the
knowledge to easily modify your services to start supporting HTTPS connections.

## Why do we care about HTTPS?

<iframe src="https://giphy.com/embed/E9r55Y8MLkSo8" width="480" height="221"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/funny-lol-parks-and-recreation-E9r55Y8MLkSo8">via
GIPHY</a></p>

Offering, and defaulting to, HTTPS is good web hygiene. It has been a particular
focus of the EFF over the last year, as they describe in this summary of their
[Encrypt The Web](https://www.eff.org/encrypt-the-web) initiative.

Specifically, HTTPS sites, unlike HTTP sites, are safe from eavesdropping and
content hijacking. Eavesdropping is when a third-party observes the client's
connection with the website. It can be used for a number of nefarious purposes,
the most obvious of which is stealing sensitive information like passwords.
Content hijacking is when a third-party modifies the content sent by the client
or website before its intended recipient can view it. For example, it could be
used to place ads on a website or modify an asset the website serves (i.e. a
GPG public key).

Since we need our blog, and other services running on our Kubernetes cluster which
we wish to make publicly accessible, to be safe from eavesdropping and content
hijacking, we must support connecting to our services via HTTPS.

## Previous approach to HTTPS in our k8s cluster

<iframe src="https://giphy.com/embed/VZhr1FXCUI2dO" width="480" height="270"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/bernard-regional-scranton-VZhr1FXCUI2dO">via
GIPHY</a></p>

As you may remember from our initial [blog
post](/post/hosting-static-blog-on-kubernetes/) on deploying this static site
via Kubernetes, we originally only supported HTTP connections to this blog.
Prior to the changes described in this blog post, we exposed our blog to the
external web via a
[LoadBalancer](https://kubernetes.io/docs/concepts/services-networking/#loadbalancer) Service.
When we created the LoadBalancer Service, Kubernetes created a publicly
accessible AWS [Elastic Load Balancer (ELB)](https://aws.amazon.com/elasticloadbalancing/),
and then ensured traffic sent to this load balancer was delivered to the pods serving our blog.

The seemingly low risk and consequence of attack provided our justification for
not initially supporting HTTPS. There is, and remains, no sensitive
communication between the client and server for which we must be concerned
about eavesdropping. While there was the risk of content-modification, the blog
did not serve any assets for which content-modification was a significant danger.

For our non-static sites like Grafana and NextCloud for which there was an authentication layer,
and thus a true risk of eavesdropping, we avoided exposing them to the public
internet. This meant we needed to use
[Port Forwarding](https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/)
to access these applications.

The inability to use support encrypted connections constrained how we interacted
with applications running on this cluster. Thus, supporting HTTPS connections to services
running on our k8s cluster will not only promote good web hygiene for
applications which were already publicly exposed, but also support us making a
new class of applications accessible over the public internet.

## New approach to HTTPS in our k8s cluster

<iframe src="https://giphy.com/embed/xT5LMyJumn03ezhDvW" width="480"
height="362" frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/season-16-the-simpsons-16x2-xT5LMyJumn03ezhDvW">via
GIPHY</a></p>

### From LoadBalancer Services to Ingress

Our first step to utilizing HTTPS in our k8s cluster was switching from publicly
exposing services using a LoadBalancer Service to publicly exposing services via
Kubernetes' [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
resource. The Ingress resource's stated purpose is managing external access to
Services running in the cluster.

Ingress offers a number advantages compared to LoadBalancer Service types.
First, when utilizing Ingress objects, we can share on ELB for all publicly
accessible services. In contrast, each LoadBalancer Service creates its own ELB.
As a single ELB costs around $200 a year, as calculated in our [cost
saving](/reducing-the-cost-of-running-a-personal-k8s-cluster-part-2/) series,
utilizing Ingresses offers a cost advantage.

Additionally, Ingresses are very flexible in their support of [name based
virtual hosting](https://kubernetes.io/docs/concepts/services-networking/ingress/#name-based-virtual-hosting).
For example, using the Ingress resource, we can configure
`blog.mattjmcnaughton.com` to route to our blog ClusterIP Service, and
`grafana.mattjmcnaughton.com` to route to our Grafana ClusterIP Service, without needing
to directly manage any DNS subdomains.

Finally, and most importantly for this blog post, Ingresses offer first class support for configuring
[HTTPS](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls).

#### Supporting Ingress on our Cluster

We need to deploy an Ingress Controller which takes
stored Ingress resources and performs the necessary
actions. For more about
[Controllers](https://www.aquasec.com/wiki/display/containers/Kubernetes+Controllers+and+Control+Plane#perspectives-on-kubernetes-controllers-and-control-plane),
a fundamental part of k8s architecture, see some of the articles listed on the
linked page.

We decided to deploy the
[nginx-ingress](https://github.com/helm/charts/tree/master/stable/nginx-ingress)
controller. The helm chart should work pretty much out of the box without any
tweaking of defaults.

With the Ingress controller deployed, we can now start deploying Ingress
resources. Below we define an Ingress for our blog:

<script src="https://gist.github.com/mattjmcnaughton/4f0883c32699de8eb63ae6022177cf9c.js"></script>

As you can see, we've routed requests to mattjmcnaughton.com,
and blog.mattjmcnaughton.com to our blog Service.

After deploying this ingress, our final step is updating our Route53 A records
for `mattjmcnaughton.com` and `*.mattjmcnaughton.com` to the ExternalIP listed
for the `nginx-ingress-controller` Service, which should be our only Service of
type LoadBalancer. The remainder of our Services, and all future Services, will
be of type ClusterIP, and use Ingress for public exposure.

Exposing another application via Ingress is trivial. For example, to expose
Grafana, we just need to add the following Ingress definition. We do not even
need to update our Route53 DNS records, as `*.mattjmcnaughton.com` already
routes to our nginx-ingress-controller, and our nginx-ingress-controller knows
to route `grafana.mattjmcnaughton.com` traffic to our Grafana ClusterIP service.

<script src="https://gist.github.com/mattjmcnaughton/c7ef1fafe6b715664cc181b8f060ad3a.js"></script>

### Supporting HTTPS via CertManager

From day one, the abundance of community tooling has driven our interest and
belief in Kubernetes. In this instance, the talented developers at
[Jetstack](https://www.jetstack.io/) have created and shared,
[CertManager](https://docs.cert-manager.io/en/latest/).

CertManager is a Kubernetes controller which manages issuing certificates from sources like
[Let's Encrypt](https://letsencrypt.org/) and also ensures the certificates
stays valid and up to date. Amazingly, CertManager allows us to force HTTPS only
connections to a publicly exposed service with just a couple of lines of YAML in
our Ingress resource definitions.

Jetstack has written great documentation for CertManager, so to get started with
CertManager, follow this
[tutorial](https://docs.cert-manager.io/en/latest/tutorials/acme/quick-start/index.html).
The most important steps in the tutorial are [Step 5 - Deploy Cert
Manager](https://docs.cert-manager.io/en/latest/tutorials/acme/quick-start/index.html#step-5-deploy-cert-manager)
and [Step 6 - Configure Let's Encrypt
Issuer](https://docs.cert-manager.io/en/latest/tutorials/acme/quick-start/index.html#step-6-configure-let-s-encrypt-issuer).

With CertManager deployed, and the Let's Encrypt Issuer configured, we can now
force HTTPS connections via some small modifications to our Ingress resources.
The changes to the definition of the Ingress resource for our blog, now serving HTTPS, can be
seen below:

<script src="https://gist.github.com/mattjmcnaughton/991085bccb786cbb84e6661eed985f36.js"></script>

It's equally trivial to add HTTPS support for Grafana, or any other Services, we
wish to publicly expose. We just need to ensure we have completed the `tls`
section in the Ingress spec and added the
`certmanager.k8s.io/{issuer,acme-challenge-type}` annotations.

## Limitations of this method for supporting HTTPS

While CertManager is an incredibly useful tool for supporting HTTPS connections
on publicly accessible websites, it is not a complete solution for encrypted
communication on our Kubernetes cluster. Specifically, CertManager only works
for services accessible over the public internet.

As a result, it can not be used when your cluster is running locally (i.e. Minikube).
The lack of local usage isn't concerning from a security perspective, because
there should not be sensitive information in dev and because all of your
connections are remaining on the local machine which vastly reduces the attack
service. However, it can make testing changes to CertManager difficult.
Fortunately, we can use the `letsencrypt-staging` provider discussed in the tutorial for
when we want to test out changes without negatively impacting prod.

This model for supporting HTTPS
also does not work for services we do not want exposed to the public internet. In other words,
we need a different way to encrypt communication to private services whose only clients
are within the Kubernetes cluster. When we begin to consider encrypting these
connections, we may look to accomplish it via [Mutual TLS provided by a Service
Mesh](https://istio.io/docs/tasks/security/mutual-tls/).

## Conclusion

We hope you enjoy the new [https://mattjmcnaughton.com](https://mattjmcnaughton.com).
We're really excited about the new avenues opened up to us now that our cluster
supports deploying publicly accessible services which force HTTPS connections! A big thanks to the
good folks at Jetstack for creating such a useful and powerful tool like CertManager.

<iframe src="https://giphy.com/embed/ZW7GZxa37cuZi" width="480" height="360"
frameBorder="0" class="giphy-embed" allowFullScreen></iframe><p><a
href="https://giphy.com/gifs/80s-vintage-1980s-ZW7GZxa37cuZi">via GIPHY</a></p>
