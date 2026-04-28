# sync-service — DevOps Design & Delivery

> CI/CD pipeline design and cloud infrastructure architecture for a Spring Boot application on GCP.

---

## Overview

This repository documents the **CI/CD pipeline design** and **cloud infrastructure architecture** for `sync-service` — a Spring Boot application integrated with MongoDB Atlas and deployed on Google Cloud Platform (GCP).

The system is built around four core principles:

- **Safe, controlled deployments** — branch-based promotion with manual production gates
- **Scalable, resilient infrastructure** — Kubernetes with horizontal auto-scaling
- **Secure configuration management** — secrets stored outside the codebase via GCP Secret Manager
- **Cost efficiency** — rolling deployments and managed services minimize operational overhead

---

## Repository Structure

```
sync-service/
├── README.md
├── jenkins/
│   └── Jenkinsfile              # Pipeline definition
├── docs/
│   ├── ci-cd-design.md          # Pipeline architecture & decisions
│   ├── infrastructure.md        # GCP infrastructure design
│   └── architecture.png         # System diagram
├── k8s/
│   ├── deployment.yaml          # Kubernetes Deployment spec
│   ├── service.yaml             # Kubernetes Service spec
│   └── ingress.yaml             # Ingress configuration
├── deploy.sh                    # Deployment entry point
└── scripts/
    └── rollback.sh              # Rollback utility
```

---

## Reviewer Guide

Start here and follow in order:

| Step | File | Purpose |
|------|------|---------|
| 1 | [`docs/ci-cd-design.md`](docs/ci-cd-design.md) | Pipeline architecture and design decisions |
| 2 | [`docs/infrastructure.md`](docs/infrastructure.md) | GCP infrastructure and component layout |
| 3 | [`jenkins/Jenkinsfile`](jenkins/Jenkinsfile) | Concrete pipeline implementation |
| 4 | [`docs/architecture.png`](docs/architecture.png) | Visual system diagram |

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | Spring Boot |
| CI/CD | Jenkins |
| Containerisation | Docker |
| Compute | GKE (Kubernetes) |
| Database | MongoDB Atlas |
| Secrets | GCP Secret Manager |
| Monitoring | Cloud Monitoring |

---

## Deployment Flow

```
Push to branch
      │
      ▼
┌─────────────┐     ┌─────────────┐     ┌───────────────────────┐
│   develop   │────▶│  QA (auto)  │     │                       │
└─────────────┘     └─────────────┘     │                       │
                                        │                       │
┌─────────────┐     ┌──────────────┐    │  Production           │
│   staging   │────▶│ Staging(auto)│────▶  (manual approval)   │
└─────────────┘     └──────────────┘    │                       │
                                        └───────────────────────┘
```

### Branch → Environment Mapping

| Branch | Environment | Gate |
|--------|------------|------|
| `develop` | QA | Automatic |
| `staging` | Staging | Automatic |
| `main` | Production | Manual approval required |

---

## Key Design Decisions

### Deployment Safety
- Branch-based environment promotion prevents accidental releases
- Manual approval gate on `main` protects production
- Versioned, immutable Docker artifacts — no in-place patching

### Scalability
- Kubernetes HPA (Horizontal Pod Autoscaler) handles traffic spikes
- Load-balanced ingress distributes requests across replicas

### Security
- IAM roles enforce least-privilege access across GCP services
- All secrets managed via GCP Secret Manager — nothing hardcoded or in version control

### Cost Optimisation
- Rolling deployments eliminate the need for parallel infrastructure during releases
- Fully managed services (MongoDB Atlas, GKE, Cloud Monitoring) reduce operational overhead

---

## Design Principles

| Principle | What it means in practice |
|-----------|--------------------------|
| Immutability over patching | Docker images are built once and promoted across environments unchanged |
| Automation with control gates | Everything automated except the production promotion decision |
| Environment isolation | QA, Staging, and Production are fully independent with no shared state |
| Minimal operational complexity | Prefer managed services over self-hosted infrastructure |

---

## Roadmap

- [ ] Infrastructure as Code — Terraform for GCP resource provisioning
- [ ] Helm-based Kubernetes deployments for better release management
- [ ] Distributed tracing via OpenTelemetry

---

## Contributing

This repository is a design and delivery reference. For questions about the architecture or pipeline decisions, refer to [`docs/ci-cd-design.md`](docs/ci-cd-design.md) first, then open a discussion.
