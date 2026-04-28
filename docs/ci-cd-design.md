# 🔄 CI/CD Design – sync-service

## 1. 📌 Objective

Design a CI/CD pipeline that ensures:

* Fast feedback on code changes
* Safe deployments across environments
* Easy rollback in case of failure


## 2. 🔀 Branching Strategy

We follow a **GitFlow-lite model**:

| Branch    | Purpose             | Environment |
| --------- | ------------------- | ----------- |
| develop   | Integration branch  | QA          |
| staging   | Pre-production      | Staging     |
| main      | Production-ready    | Production  |
| feature/* | Feature development | -           |
| hotfix/*  | Critical fixes      | Production  |


## 3. 🛡️ Preventing Accidental Production Deployments

* `main` branch protection:

  * Mandatory PR approvals
  * Required CI checks
* Jenkins includes:

  * **Manual approval stage** before production deployment
* Separate service accounts per environment
* Deployment restricted by branch conditions


## 4. ⚙️ Pipeline Design

### Pipeline Flow

```
Checkout → Build → Test → Analyze → Package → Containerize → Push → Deploy → Verify
```


### Stages

1. Checkout source code
2. Build application (Maven/Gradle)
3. Run unit tests
4. Static code analysis
5. Package JAR
6. Build Docker image
7. Push to Artifact Registry
8. Deploy based on branch
9. Run smoke tests


## 5. 🔁 PR vs Merge Behavior

### Pull Requests

* Trigger: PR creation/update
* Actions:

  * Build
  * Unit tests
  * Code quality checks
* ❌ No deployment


### Merge Behavior

| Branch  | Action                       |
| ------- | ---------------------------- |
| develop | Auto deploy → QA             |
| staging | Auto deploy → Staging        |
| main    | Manual approval → Production |


## 6. 🔄 Rollback Strategy

### Approach: Immutable Deployments

* Each build produces a versioned Docker image:

  * `sync-service:<build-number>`
  * `sync-service:<commit-sha>`

### Rollback Options

* Re-deploy previous stable version
* Maintain `stable` tag
* Optional automated rollback on failure


## 7. 🔐 Configuration Management

### Strategy

Use Spring profiles:

```
application.yml
application-qa.yml
application-staging.yml
application-prod.yml
```

Activation:

```
SPRING_PROFILES_ACTIVE=<env>
```


## 8. 🔑 Secrets Management

### Tool: GCP Secret Manager

Secrets include:

* MongoDB URI
* API keys

### Access

* IAM-controlled access
* Separate service accounts per environment


## 9. 🚀 Deployment Strategy

### Selected: Rolling Deployment

### Justification

| Strategy   | Result      |
| ---------- | ----------- |
| Recreate   | Downtime    |
| Blue/Green | Higher cost |
| Rolling    | Balanced    |


## 10. ⚡ Zero Downtime Approach

* Readiness & liveness probes
* Gradual pod replacement
* Load balancer traffic shifting
* Graceful shutdown of old pods


## 11. ✅ Summary

This CI/CD design provides:

* Controlled deployments
* Strong safety mechanisms
* Fast feedback loops
* Reliable rollback capability

