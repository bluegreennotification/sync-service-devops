# ☁️ Infrastructure Design – sync-service

## 1. 📌 Objective

Design a **scalable, secure, and cost-efficient infrastructure** on GCP for running the sync-service.


## 2. 🖥️ Compute Strategy

### ✅ Selected: Google Kubernetes Engine (GKE)

### Why GKE?

* Built-in auto-scaling (HPA)
* Supports rolling deployments
* Self-healing (pod restarts)
* Industry-standard orchestration


### Alternatives Considered

| Option         | Limitation                         |
| -------------- | ---------------------------------- |
| Compute Engine | Manual scaling                     |
| Cloud Run      | Less control for complex workloads |


## 3. 🗄️ Database Design

### ✅ MongoDB Atlas (Managed)

### Benefits

* Automated backups
* Built-in replication
* Minimal operational overhead
* Easy scaling


## 4. 🌐 Networking Architecture

### Components

* VPC (isolated network)
* Private GKE cluster
* HTTP(S) Load Balancer
* Kubernetes Ingress


### Request Flow

```
Client → Load Balancer → Ingress → Service → Pods
```


### Security Design

* Private cluster (no public node exposure)
* TLS termination at load balancer
* Internal communication via VPC


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

### Tool: GCP Secret Manager

* Centralized secret storage
* IAM-controlled access
* No secrets in codebase


## 7. 📈 Auto-Scaling

### Kubernetes HPA

* Scales pods based on:

  * CPU usage
  * Memory usage

### Benefits

* Handles traffic spikes
* Reduces cost during low usage


## 8. 📊 Logging & Monitoring
[O
### Stack

* Cloud Logging
* Cloud Monitoring

### Metrics

* CPU & memory usage
* Request latency
* Error rates
* Pod health


### Optional Enhancements

* Prometheus + Grafana
* Alerting policies


## 9. 🧱 Architecture Overview

```
                ┌──────────────┐
                │   Internet   │
                └──────┬───────┘
                       │
             ┌─────────▼─────────┐
             │ GCP Load Balancer │
             └─────────┬─────────┘
                       │
                ┌──────▼──────┐
                │   Ingress   │
                └──────┬──────┘
                       │
              ┌────────▼────────┐
              │  GKE Cluster    │
              │ (Auto-scaled)   │
              └────────┬────────┘
                       │
               ┌───────▼────────┐
               │ sync-service   │
               │ (Spring Boot)  │
               └───────┬────────┘
                       │
         ┌─────────────▼─────────────┐
         │ MongoDB Atlas (Managed)   │
         └───────────────────────────┘
```


## 10. 💰 Cost Considerations

* Rolling deployments avoid duplicate infrastructure
* Managed database reduces operational overhead
* Auto-scaling prevents over-provisioning


## 11. ✅ Summary

This infrastructure design provides:

* High availability
* Scalability
* Strong security practices
* Cost-effective operation

