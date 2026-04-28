# CI/CD Design — sync-service

> Pipeline architecture ensuring fast feedback, safe deployments, and reliable rollback across all environments.

---

## 1. Objective

Design a CI/CD pipeline that guarantees:

- Fast feedback on every code change
- Safe, controlled deployments across environments
- Straightforward rollback when failures occur

---

## 2. Branching Strategy

A **GitFlow-lite** model keeps the branch structure simple and predictable:

| Branch | Purpose | Environment |
|--------|---------|------------|
| `develop` | Integration branch | QA |
| `staging` | Pre-production validation | Staging |
| `main` | Production-ready code | Production |
| `feature/*` | Feature development | — |
| `hotfix/*` | Critical production fixes | Production |

---

## 3. Preventing Accidental Production Deployments

Protection is applied at both the repository and pipeline level.

**Branch protection on `main`:**
- Mandatory PR approvals before merge
- Required CI checks must pass

**Jenkins pipeline guards:**
- Manual approval stage before any production deployment
- Deployment steps gated by branch conditions
- Separate GCP service accounts per environment, limiting blast radius

---

## 4. Pipeline Design

### Flow

```
Checkout → Build → Test → Analyze → Package → Containerize → Push → Deploy → Verify
```

### Stages

| # | Stage | Description |
|---|-------|-------------|
| 1 | Checkout | Pull source code from repository |
| 2 | Build | Compile application via Maven/Gradle |
| 3 | Test | Run unit test suite |
| 4 | Analyse | Static code analysis |
| 5 | Package | Produce application JAR |
| 6 | Containerise | Build Docker image |
| 7 | Push | Publish image to GCP Artifact Registry |
| 8 | Deploy | Deploy to target environment based on branch |
| 9 | Verify | Run smoke tests against deployed service |

---

## 5. PR vs Merge Behaviour

### Pull requests

Triggered on PR creation and every subsequent push to that PR.

Actions performed: build, unit tests, code quality checks.

**No deployment occurs on a PR** — only validation.

### Merge behaviour

| Branch | Triggered action |
|--------|----------------|
| `develop` | Auto-deploy to QA |
| `staging` | Auto-deploy to Staging |
| `main` | Await manual approval → deploy to Production |

---

## 6. Rollback Strategy

### Immutable deployments

Every build produces two versioned Docker image tags:

```
sync-service:<build-number>
sync-service:<commit-sha>
```

This means any previous version can be redeployed at any time without rebuilding.

### Rollback options

- Re-deploy the last known stable image tag
- Maintain a `stable` floating tag pointing to the last successful production release
- Optional: automated rollback triggered on failed smoke tests post-deploy

---

## 7. Configuration Management

Spring profiles separate environment-specific configuration:

```
application.yml           # Shared defaults
application-qa.yml        # QA overrides
application-staging.yml   # Staging overrides
application-prod.yml      # Production overrides
```

The active profile is set at runtime via the environment variable:

```
SPRING_PROFILES_ACTIVE=<env>
```

---

## 8. Secrets Management

**Tool:** GCP Secret Manager

Secrets managed externally (never committed to the repository):

- MongoDB URI
- API keys and third-party credentials

**Access control:** IAM roles restrict secret access per environment. Each environment uses its own service account with only the permissions it requires.

---

## 9. Deployment Strategy

**Selected strategy: Rolling deployment**

| Strategy | Outcome |
|----------|---------|
| Recreate | Causes downtime — not acceptable |
| Blue/Green | No downtime, but doubles infrastructure cost |
| Rolling | Zero downtime with no extra infrastructure overhead |

Rolling deployment was chosen as the right balance for a startup context: it eliminates downtime without the cost overhead of maintaining a parallel environment.

---

## 10. Zero Downtime Approach

Rolling updates are safe because of the following Kubernetes configuration:

- **Readiness probes** — traffic is only routed to pods that pass health checks
- **Liveness probes** — unhealthy pods are restarted automatically
- **Gradual pod replacement** — old pods are terminated only after new pods are ready
- **Load balancer traffic shifting** — in-flight requests are drained before pod termination
- **Graceful shutdown** — pods handle `SIGTERM` and finish in-progress work before stopping

---

## 11. Summary

| Goal | Mechanism |
|------|----------|
| Controlled deployments | Branch-based promotion + manual approval on `main` |
| Safety | PR checks, branch protection, per-environment service accounts |
| Fast feedback | Automated build and test on every PR |
| Reliable rollback | Immutable versioned images, `stable` tag, optional auto-rollback |
