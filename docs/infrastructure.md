# ☁️ Infrastructure Design – sync-service

## 1. 📌 Objective

Design a cloud infrastructure on GCP that is:

* Scalable
* Secure
* Cost-efficient
* Highly available


## 2. 🖥️ Compute Layer

### ✅ Selected: Google Kubernetes Engine (GKE)

### Why GKE?

* Auto-scaling (HPA)
* Rolling deployments
* Self-healing pods
* Industry-standard orchestration


### Alternatives Considered

| Option         | Limitation                            |
| -- | - |
| Compute Engine | Manual scaling                        |
| Cloud Run      | Limited control for complex workloads |


## 3. 🗄️ Database Layer

### ✅ MongoDB Atlas

### Benefits

* Fully managed
* Automated backups
* Built-in replication
* Easy scalability


## 4. 🌐 Networking Design

### Components

* VPC (isolated network)
* Private GKE cluster
* HTTP(S) Load Balancer
* Kubernetes Ingress


### Request Flow

```
Client → Load Balancer → Ingress → Service → Pods
```


### Security

* Private cluster (no public nodes)
* TLS termination at load balancer
* Internal communication within VPC


## 5. 🔐 IAM & Security

### Principles

* Least privilege access
* Environment isolation

### Implementation

* Separate service accounts:

  * QA
  * Staging
  * Production


## 6. 🔑 Secrets Management

* Managed via GCP Secret Manager
* No secrets stored in codebase
* IAM-controlled access


## 7. 📈 Auto-Scaling

### Kubernetes HPA

* Scales based on:

  * CPU usage
  * Memory usage

### Benefits

* Handles traffic spikes
* Optimizes cost during low load


## 8. 📊 Logging & Monitoring

### Tools

* Cloud Logging
* Cloud Monitoring

### Metrics

* CPU & memory usage
* Request latency
* Error rates
* Pod health


## 9. 🧱 Architecture Diagram

Refer to:

👉 `docs/architecture.png`


## 10. 💰 Cost Considerations

* Rolling deployments avoid duplicate environments
* Managed database reduces operational overhead
* Auto-scaling prevents over-provisioning


## 11. ✅ Summary

This infrastructure design ensures:

* High availability
* Scalability
* Strong security posture
* Cost-effective operation

