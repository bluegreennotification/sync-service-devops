## Compute Choice: GKE (Google Kubernetes Engine)

### Why:
- Auto-scaling
- Rolling deployments
- Production-grade orchestration

B. MongoDB Hosting

## MongoDB

Option: MongoDB Atlas

### Why:
- Managed service
- Built-in scaling
- Backup & security handled

C. Networking
## Networking

- VPC for isolation
- Private subnets for services
- Load Balancer for external traffic
- Ingress controller for routing

D. Secrets & IAM
## Secrets & IAM

- GCP Secret Manager
- IAM roles with least privilege
- Service accounts per environment

E. Logging & Monitoring
## Monitoring & Logging

- GCP Cloud Logging
- GCP Cloud Monitoring
- Alerts for failures and CPU spikes

6. 🖼️ Architecture Diagram

Create using:
•	draw.io (recommended) 
•	or PowerPoint 
Include:
•	GKE cluster 
•	Load balancer 
•	MongoDB Atlas 
•	CI/CD flow (Jenkins)

############################################################

INFRASTRUCTURE DESIGN (Senior-Level)

# Infrastructure Design (GCP)

## 1. Compute Choice: GKE

Google Kubernetes Engine (GKE) is selected for running the service.

### Rationale:
- Native support for rolling deployments
- Horizontal auto-scaling
- Production-grade orchestration

---

## 2. Application Deployment

- Containerized Spring Boot service
- Deployed via Kubernetes Deployments
- Exposed using Ingress

---

## 3. MongoDB Strategy

### Selected: MongoDB Atlas

**Why:**
- Fully managed service
- Built-in scaling and backups
- Reduces operational overhead

---

## 4. Networking

- VPC for isolation
- Private nodes for GKE cluster
- Cloud Load Balancer for external access
- Ingress controller for routing

---

## 5. Security (IAM & Secrets)

- GCP Secret Manager for sensitive data
- Service accounts per environment
- Least privilege IAM roles

---

## 6. Observability

- Cloud Logging for centralized logs
- Cloud Monitoring for metrics
- Alerts configured for:
  - High CPU usage
  - Pod failures
  - Service downtime

---

## 7. Cost Optimization

- Auto-scaling nodes based on load
- Minimal resources in QA/staging
- Efficient rolling updates (no duplicate infra)

---

## 8. High Availability

- Multi-zone GKE cluster
- Load-balanced traffic
- Self-healing pods
