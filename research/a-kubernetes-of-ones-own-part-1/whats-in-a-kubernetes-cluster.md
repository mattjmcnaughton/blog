# What is a Kubernetes cluster?

- Kubernetes cluster is an installation of the Kubernetes container management
  system software onto physical resources.
- A cluster can be local (i.e. Minikube), hosted (GKE, EKS), Turnkey Cloud (i.e.
  kops for AWS), Turnkey on-premise, or completely custom.
- A cluster contains both a master node and a set of worker nodes.
- It has six main components: API server, Scheduler, Controller manager,
  kubelet, kube-proxy, and etcd.
- The master runs the Scheduler, Controller Manager, API Server, and etcd. These
  components Schedule pods onto workers, reconcile the actual cluster state with
  the expected cluster state, provide an interface for reading/writing cluster
  state, and store state on the cluster.
  - If there is only one master, it is a single point of failure. Run multiple
    masters for a high-availability cluster.
- The workers run the kubelet, kube-proxy, and some form of containerization
  engine (i.e. Docker).
  - Kubelet watches API server for pods bound to its node, and runs them. When
    doing so, it interacts with the underlying containerization engine (i.e.
    Docker, rkt, gvisor)
  - kube-proxy manages network configuration via IP tables. Allows services...
- Additionally, most Kubernetes clusters contain a networking provider, which
  allows between pod communication in Kubernetes, and a dns provider which
  allows for internal DNS within the cluster.
