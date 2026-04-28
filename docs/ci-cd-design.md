# CI/CD Pipeline Design

## 1. Branching Strategy

- feature/* → development
- qa → QA environment
- staging → staging environment
- main → production

### Promotion Flow
feature → qa → staging → main

This ensures progressive validation before production release.

---

## 2. Environment Mapping

| Branch   | Environment |
|----------|------------|
| qa       | QA         |
| staging  | Staging    |
| main     | Production |

---

## 3. Production Safety Controls

To prevent accidental production deployments:

- Protected `main` branch (no direct pushes)
- Mandatory pull request approvals
- Jenkins manual approval before production deployment

---

## 4. Pipeline Stages

1. Checkout
2. Build (Maven)
3. Unit Tests
4. Docker Build
5. Push to Container Registry
6. Deploy

---

## 5. PR vs Merge Behavior

### Pull Requests
- Trigger build and tests
- No deployment
- Acts as quality gate

### Merge Events
- qa → deploy to QA
- staging → deploy to staging
- main → requires manual approval before production deploy

---

## 6. Artifact Strategy

- Docker images tagged using BUILD_NUMBER
- Images are immutable
- Same artifact promoted across environments

---

## 7. Rollback Strategy

Rollback is handled using previously stable Docker images.

### Approach:
- Each deployment references a versioned image
- If health checks fail:
  - Automatically redeploy last stable version

### Additional Safeguards:
- Readiness probes prevent unhealthy pods from receiving traffic
- Manual rollback supported via Jenkins

---

## 8. Configuration & Secrets

### Configuration
- Externalized per environment
- Injected during deployment

### Secrets
- Managed via GCP Secret Manager
- Access controlled via IAM roles
- Never stored in source code

---

## 9. Deployment Strategy

### Selected: Rolling Deployment

**Why:**
- Zero downtime
- Cost-efficient (no duplicate environments)
- Native support in Kubernetes

**Alternatives Considered:**
- Blue/Green → safer rollback but high cost
- Recreate → simple but causes downtime

---

## 10. Risks & Mitigations

| Risk | Mitigation |
|------|-----------|
| Accidental prod deploy | Manual approval + branch protection |
| Faulty release | Automated rollback |
| Secret exposure | Secret Manager + IAM |
