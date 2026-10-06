# End to End GitOps Pipeline

A production-ready GitOps pipeline demonstrating cloud-native DevOps practices. Zorin provides an end-to-end CI/CD workflow where GitHub Actions builds and pushes a Python Flask image to ECR, Terraform provisions the AWS EKS infrastructure, and ArgoCD continuously syncs Helm chart values from Git to deploy the application with MongoDB backend on AWS EKS.

---

##  Architecture Overview

```
GitHub (PR required to merge to main)
        ↓
GitHub Actions (Lint, Build, Test)
        ↓
AWS ECR
        ↓
AWS EKS (K8s Cluster)
        ├── Namespace: zorin
        ├── Flask App (Deployment)
        ├── MongoDB (Deployment + PVC)
        ├── Mongo Express (Admin UI)
        ├── Namespace: monitoring
        │   ├── Prometheus
        │   └── Grafana
        └── ALB Ingress
        ↓
ArgoCD (GitOps - sync)
```

### Technology Stack

| Component | Technology | Version |
|-----------|-----------|---------|
| **Application** | Python Flask | 3.0.0 |
| **Database** | MongoDB | 8.2 |
| **Orchestration** | Kubernetes (EKS) | 1.30 |
| **Package Manager** | Helm | 3.14.0 |
| **Infrastructure** | Terraform | 1.7.0 |
| **GitOps** | ArgoCD | 7.5.16 |
| **CI/CD** | GitHub Actions | Latest |
| **Monitoring** | Prometheus, Grafana | Latest |

---

## Quick Start

### Prerequisites

**For Docker Compose:**
- Docker & Docker Compose

**For Kubernetes:**
- Docker, kubectl, Helm, AWS CLI

### Docker Compose 

```bash
# Clone repo
git clone https://github.com/vishnuvardhan1170/test.git
cd test

# Start services
docker-compose up -d

# Verify
docker-compose ps

# Stop
docker-compose down
```

**What runs:**
- Flask App → localhost:8000
- MongoDB → localhost:27017
- Mongo Express → localhost:8081

---

### Kubernetes
**Prerequisites:** Minikube

```bash
# Clone repo

cd test

# Deploy
helm install zorin helm/ \
  --namespace zorin \
  --create-namespace

# Wait for pods
kubectl get pods -n zorin -w

# Port forward
kubectl port-forward -n zorin svc/zorin-web-web 8000:80 &
kubectl port-forward -n zorin svc/zorin-mongo-express 8081:8081 &

# Clean up
helm uninstall zorin -n zorin
kubectl delete namespace zorin
```

---


## End-to-End Pipeline

```
1. Developer pushes to feature branch
              ↓
2. Open Pull Request → main
              ↓
3. GitHub Actions runs on PR
   ├─ Python code (flake8, mypy, black)
   ├─ Helm chart validation
   └─ Terraform format check
              ↓
4. Peer review & approval
              ↓
5. Merge to main
              ↓
6. Build & Push Docker image to ECR
              ↓
7. ArgoCD detects change in Git
   ├─ Syncs Helm chart to cluster
   ├─ Deploys Flask app
   ├─ Deploys MongoDB + PVC
   └─ Configures ingress
              ↓
8. Prometheus scrapes metrics
   Grafana displays dashboards
              ↓
 Application running on Kubernetes with observability
```

---

##  Deployment Methods

### Automated (GitHub Actions)
Push to main → Auto-deploys via GitHub Actions

### Manual (Helm)
```bash
helm install zorin helm/ -n zorin --create-namespace
helm upgrade zorin helm/ -n zorin
helm uninstall zorin -n zorin
```

### Manual (Terraform + Helm)
```bash
cd tf
terraform init -backend=false
terraform apply
aws eks update-kubeconfig --name zorin --region ap-south-1
helm install zorin ../helm/ -n zorin --create-namespace
```

### GitOps (ArgoCD)
```bash
kubectl port-forward -n argocd svc/argocd-server 8080:443
#  syncs changes automatically
```

---

##  Project Structure

```
zorin/
├── .github/workflows/
│   ├── lint.yaml              # Code quality checks
│   └── cicd.yaml              # Build & deploy pipeline
│
├── helm/
│   ├── Chart.yaml
│   ├── values.yaml
│   └── templates/
│
├── tf/
│   ├── providers.tf
│   ├── variables.tf
│   ├── aws-vpc.tf
│   ├── aws-eks.tf
│   ├── aws-ecr.tf
│   ├── argocd.tf
│   └── outputs.tf
│
├── argocd/                    #GitOps
│   ├── README.md
│   └── app.yaml
│
├── k8s/                       # Kubernetes manifests
│   ├── web-deployment.yaml
│   ├── mongo-deployment.yaml
│   └── ...
│
├── app.py                     # Flask
├── requirements.txt
├── Dockerfile
├── docker-compose.yaml
└── README.md
```

---

### Helm Operations
```bash
helm list -n zorin                    # List releases
helm status zorin -n zorin            # Status
helm values zorin -n zorin            # Current values
helm upgrade zorin helm/ -n zorin     # Update
helm rollback zorin -n zorin          # Rollback
```

---

## Quick Commands Reference

```bash
# Local Development
docker-compose up -d
docker-compose down
docker-compose logs -f

# Kubernetes
helm install zorin helm/ -n zorin --create-namespace
helm list -n zorin
helm uninstall zorin -n zorin

# AWS EKS
cd tf
terraform plan
terraform apply
aws eks update-kubeconfig --name zorin --region ap-south-1
helm install zorin ../helm/ -n zorin

# Debug
kubectl get pods -n zorin
kubectl logs -n zorin deployment/zorin-web -f
kubectl port-forward -n zorin svc/zorin-web-web 8000:80
```

---
