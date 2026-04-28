# Infrastructure Design — sync-service

> GCP cloud infrastructure designed for scalability, security, high availability, and cost efficiency.


## 1. Objective

Design a cloud infrastructure on GCP that is:

- Scalable — handles variable traffic without manual intervention
- Secure — least-privilege access, private networking, no secrets in code
- Cost-efficient — managed services and auto-scaling prevent over-provisioning
- Highly available — self-healing workloads with automated failover


## 2. Compute Layer

**Selected: Google Kubernetes Engine (GKE)**

GKE was chosen as the compute platform for the following reasons:

| Capability | Benefit |
|-----------|---------|
| Horizontal Pod Autoscaler (HPA) | Scales replicas automatically based on load |
| Rolling deployments | Zero-downtime releases out of the box |
| Self-healing pods | Failed containers are restarted without manual intervention |
| Industry-standard orchestration | Broad tooling support and operational familiarity |

### Alternatives considered

| Option | Reason not selected |
|--------|-------------------|
| Compute Engine | Requires manual scaling and OS-level management |
| Cloud Run | Insufficient control for stateful or complex workload configurations |


## 3. Database Layer

**Selected: MongoDB Atlas**

MongoDB Atlas is used as a fully managed database service, removing the operational burden of running self-hosted MongoDB on GCP.

| Capability | Detail |
|-----------|--------|
| Managed operations | No patching, replication setup, or failover configuration required |
| Automated backups | Point-in-time recovery with configurable retention |
| Built-in replication | Multi-node replica sets for high availability |
| Scalability | Vertical and horizontal scaling via Atlas controls |


## 4. Networking Design

### Components

| Component | Role |
|-----------|------|
| VPC | Isolated private network for all GCP resources |
| Private GKE cluster | Nodes have no public IP addresses |
| HTTP(S) Load Balancer | Handles external traffic ingress and TLS termination |
| Kubernetes Ingress | Routes traffic from the load balancer to the correct service |

### Request flow

```
Client → Load Balancer → Ingress → Service → Pods
```

### Security posture

- Private cluster nodes are not reachable from the public internet
- TLS is terminated at the load balancer — all external traffic is encrypted in transit
- Pod-to-pod and service-to-service communication stays within the VPC
- No direct database exposure outside the private network


## 5. IAM & Access Control

**Principle: least-privilege access with full environment isolation.**

Each environment (QA, Staging, Production) has its own dedicated GCP service account. Service accounts are granted only the IAM roles required for that environment's workloads — no shared credentials across environments.

This ensures that a compromise or misconfiguration in QA cannot affect Staging or Production.


## 6. Secrets Management

All secrets are stored in **GCP Secret Manager** and injected at runtime. Nothing sensitive is committed to the repository or baked into Docker images.

Secrets managed externally:

- MongoDB Atlas connection URI
- API keys and third-party service credentials

Access is controlled via IAM — each environment's service account can only read the secrets assigned to it.


## 7. Auto-Scaling

**Tool: Kubernetes Horizontal Pod Autoscaler (HPA)**

The HPA monitors resource metrics and adjusts replica count automatically:

| Metric | Action |
|--------|--------|
| CPU usage exceeds threshold | Scale out — add more pods |
| Memory usage exceeds threshold | Scale out — add more pods |
| Load drops | Scale in — remove idle pods |

This approach handles traffic spikes without pre-provisioning capacity, and reduces cost during periods of low load.


## 8. Logging & Monitoring

**Tools: Cloud Logging and Cloud Monitoring**

| Metric | Purpose |
|--------|---------|
| CPU & memory usage | Capacity planning and HPA tuning |
| Request latency | Service performance and SLA tracking |
| Error rates | Alerting on application or infrastructure failures |
| Pod health | Detecting crash loops or failed readiness checks |

Logs from all pods are automatically collected by Cloud Logging. Dashboards and alerting policies are configured in Cloud Monitoring.


## 9. Architecture Diagram

See [`docs/architecture.png`](architecture.png) for the full system diagram showing how all components connect across environments.


## 10. Cost Considerations

| Decision | Cost impact |
|----------|------------|
| Rolling deployments | No duplicate infrastructure during releases — avoids the cost of Blue/Green |
| MongoDB Atlas (managed) | Eliminates the need for dedicated DB VMs and manual ops overhead |
| HPA auto-scaling | Pods scale down during off-peak hours — no idle capacity running 24/7 |
| Private GKE cluster | No additional NAT gateway cost for internal service communication |


## 11. Summary

| Goal | How it is achieved |
|------|--------------------|
| High availability | GKE self-healing, Atlas replication, load-balanced ingress |
| Scalability | HPA scales pods automatically based on CPU and memory metrics |
| Security | Private cluster, IAM least-privilege, GCP Secret Manager, TLS at edge |
| Cost efficiency | Rolling deploys, managed services, auto-scaling down during low load |

