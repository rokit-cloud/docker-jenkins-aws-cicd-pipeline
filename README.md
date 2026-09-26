# Automated CI/CD Pipeline — Docker + Jenkins on AWS

[![AWS](https://img.shields.io/badge/AWS-EC2%20Ubuntu-orange?logo=amazon-aws)](https://aws.amazon.com/)
[![Jenkins](https://img.shields.io/badge/CI%2FCD-Jenkins-red?logo=jenkins)](https://www.jenkins.io/)
[![Docker](https://img.shields.io/badge/Container-Docker-blue?logo=docker)](https://www.docker.com/)
[![DockerHub](https://img.shields.io/badge/Registry-Docker%20Hub-2496ED?logo=docker)](https://hub.docker.com/)
[![Node.js](https://img.shields.io/badge/App-Node.js%20Vite-green?logo=node.js)](https://nodejs.org/)

An automated, enterprise-grade Continuous Integration and Continuous Deployment (CI/CD) pipeline built with **Jenkins**, **Docker**, and **AWS EC2** to deploy a containerized **Kanban Task Manager** web application.

---

## 🏛️ Architecture Overview

```
[ Developer ] --(git push)--> [ GitHub Repo (kanban-dashboard) ]
                                    │
                            (webhook push trigger)
                                    ▼
┌────────────────── AWS EC2 (jenkins-docker-server) ──────────────────┐
│                                                                     │
│  [ Jenkins CI/CD Engine (:8080) ]                                   │
│    1. Checkout Source Code from GitHub                              │
│    2. Multi-Stage Docker Build + Security Hardening (Non-Root User) │
│    3. Authenticate & Push Tagged Image to Docker Hub Registry       │
│    4. Deploy & Run Container on EC2 Host Port 3000                  │
│    5. Resource Limits Enforced (256MB RAM / 0.5 CPU)                │
│    6. Automatic Health Check & Failure Rollback                     │
│                                                                     │
│  [ Docker Hub Registry ] <---(push/pull versioned images)            │
│                                                                     │
│  [ Production Container: kanban-dashboard (:3000) ]                 │
│    └─ Continuous Zero-Downtime Availability Verified                │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 🚀 Key Implementations & Highlights

1. **Multi-Stage Docker Build**: Minimized production footprint using Node 22 Alpine build and runtime separation.
2. **Container Security**: Hardened using non-root `appuser:appgroup` credentials to prevent privilege escalation.
3. **Automated Webhook CI/CD**: Pushing commits to GitHub automatically triggers Jenkins pipeline execution.
4. **Strict Resource Constraints**: Docker host-config quota applied (`--memory=256m --cpus=0.5`).
5. **Zero-Downtime Swapping**: Health-check validated replacement ensuring 100% continuous HTTP 200 OK responses.

---

## 📁 Repository Structure

```text
docker-jenkins-aws-cicd-pipeline/
├── Dockerfile              # Multi-stage hardened container build
├── .dockerignore           # Production ignore rules
├── Jenkinsfile             # Declarative pipeline script with automated stages
├── README.md               # Main project documentation
└── docs/
    ├── Docker_Jenkins_CI_CD_Documentation_Report.pdf   # Complete formatted PDF Report
    ├── Docker_Jenkins_CI_CD_Documentation_Report.docx  # Word Document Report
    └── images/             # All 22 implementation and verification screenshots
```

---

## 📊 Live Verification & Endpoints

* **GitHub Repository**: [github.com/rokit-cloud/kanban-dashboard](https://github.com/rokit-cloud/kanban-dashboard)
* **Docker Hub Image**: [hub.docker.com/r/rokit45/kanban-dashboard](https://hub.docker.com/r/rokit45/kanban-dashboard)
* **Live App Host**: AWS EC2 (`15.206.127.179:3000` / `13.201.81.29:3000`)
* **Jenkins Dashboard**: `http://15.206.127.179:8080`

**Author:** Rokit S  
**Region:** Asia Pacific (Mumbai) `ap-south-1`
