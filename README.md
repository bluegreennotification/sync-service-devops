# 🚀 Sync Service DevOps Assignment

## 📌 Overview
This repository presents a production-oriented CI/CD and infrastructure design for a Spring Boot service (`sync-service`) deployed on GCP.

The design focuses on:
- Safe and controlled deployments
- Environment isolation
- Scalability with cost-awareness
- Operational reliability (rollback, monitoring)


## 🔁 CI/CD Flow

feature → qa → staging → main (production)


## 📂 Contents

- CI/CD pipeline design → docs/ci-cd-design.md  
- Infrastructure design → docs/infrastructure-design.md  
- Jenkins pipeline → jenkins/Jenkinsfile  


## 💡 Key Design Principles

- **Safety first:** No direct production deployments
- **Immutable artifacts:** Docker images versioned per build
- **Environment parity:** QA → Staging → Production flow
- **Fail fast:** PR validation before merge

