# 🚀 TaskFlow — Production-Ready MERN on Google Cloud

[![GCP](https://img.shields.io/badge/Cloud-Google%20Cloud-blue)]()
[![Kubernetes](https://img.shields.io/badge/Orchestration-Kubernetes-326CE5)]()
[![Terraform](https://img.shields.io/badge/IaC-Terraform-7B42BC)]()
[![Helm](https://img.shields.io/badge/Package%20Manager-Helm-0F1689)]()
[![CI/CD](https://img.shields.io/badge/CI/CD-GitHub%20Actions-black)]()
[![Cloudflare](https://img.shields.io/badge/DNS-Cloudflare-orange)]()
[![License](https://img.shields.io/badge/License-MIT-green)]()

> A full-stack MERN application deployed using production-grade DevOps practices on Google Cloud Platform.

This project demonstrates real-world cloud architecture including:

- Infrastructure as Code (Terraform)
- Kubernetes (GKE)
- Helm deployments
- GitHub Actions CI/CD (OIDC authentication)
- Cloud CDN & Global HTTPS Load Balancer
- Cert-Manager + Let’s Encrypt TLS automation
- Cloudflare DNS + WAF
- Horizontal Pod Autoscaling
- Private networking + Cloud NAT

---

# 🌍 Live Demo

| Layer | URL |
|-------|------|
| Frontend | https://taskflow.fblouison.com |
| Backend API | https://api.taskflow.fblouison.com/api/health |

---

# 🧠 Architecture Overview

## High-Level Infrastructure

```
                        Cloudflare
                   (DNS + Proxy + WAF)
                               │
               ┌───────────────┴───────────────┐
               │                               │
               ▼                               ▼
   Cloud Load Balancer                 NGINX Ingress (GKE)
   (Frontend HTTPS)                    TLS via Cert-Manager
               │                               │
               ▼                               ▼
           Cloud CDN                     Express Pods (HPA)
               │                               │
               ▼                               ▼
         GCS Bucket                        MongoDB Atlas
          (React SPA)
```

Detailed architecture diagrams will be available in `/docs/architecture/`.

---

# 🏗 Tech Stack

## Frontend
- React + Vite
- Axios
- Hosted on Google Cloud Storage
- Cloud CDN enabled
- Global HTTPS Load Balancer
- Cloudflare proxy & caching rules

## Backend
- Node.js + Express
- MongoDB Atlas
- Deployed on GKE
- Managed with Helm
- Horizontal Pod Autoscaler enabled

## Infrastructure
- Terraform (modular architecture)
- Custom VPC
- Private GKE cluster
- Cloud NAT
- Artifact Registry
- Google Managed SSL (frontend)

## DevOps
- GitHub Actions
- Workload Identity Federation (OIDC)
- Docker multi-stage builds
- Helm upgrade --install deployments
- Automated health check validation
- Automatic TLS provisioning

---

# 📦 Project Structure

```
taskflow/
├── backend/                 # Express API
├── frontend/                # React SPA
├── helm/
│   ├── backend/             # Backend Helm chart
│   └── cert-manager/        # ClusterIssuer chart
├── infra/
│   ├── environments/dev/
│   └── modules/
├── .github/workflows/       # CI/CD pipelines
└── docs/                    # Architecture diagrams
```

---

# ☁️ Infrastructure as Code (Terraform)

Infrastructure is modularized:

```
modules/
├── network/               # VPC, Subnet, NAT, Firewall
├── gke/                   # Cluster + Node Pool
├── artifact-registry/
└── frontend-storage/      # GCS + CDN + LB + SSL
```

## Deploy Infrastructure

```bash
cd infra/environments/dev

terraform init
terraform plan
terraform apply
```

Provisioned resources include:

- GKE Cluster
- Artifact Registry
- Global Static IP
- CDN-enabled Load Balancer
- GCS frontend bucket

---

# 🚀 Kubernetes Deployment

## Install NGINX Ingress

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx

helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set controller.service.type=LoadBalancer
```

## Install Cert-Manager (One-Time Setup)

```bash
helm repo add jetstack https://charts.jetstack.io

helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set installCRDs=true
```

Deploy the ClusterIssuer:

```bash
helm upgrade --install cert-manager-config ./helm/cert-manager \
  --namespace cert-manager
```

---

# 🔄 CI/CD Pipeline (GitHub Actions)

Triggered on push to `main`.

### Pipeline Steps:

1. Authenticate to Google Cloud via OIDC
2. Build Docker image
3. Push image to Artifact Registry
4. Retrieve GKE credentials
5. Deploy using Helm
6. Verify:
   - Pods
   - Services
   - Ingress
   - TLS certificate
   - HPA
7. Perform API health check

```
git push → build → push → deploy → verify → success
```

No service account keys are used.  
Authentication is handled securely via Workload Identity Federation.

---

# 🔐 Security Practices

- Workload Identity (no JSON keys)
- Private GKE nodes
- Cloud NAT for outbound access
- TLS via Let’s Encrypt
- HTTPS enforced
- Cloudflare WAF enabled
- CORS restricted
- Health check endpoint
- HPA enabled

---

# 📊 Observability & Monitoring

```bash
kubectl get pods -n backend
kubectl get hpa -n backend
kubectl top pods -n backend
kubectl logs -l app=backend -n backend
```

TLS verification:

```bash
kubectl get certificate -n backend
```

---

# 🌐 CDN & Caching Strategy

### Static assets
- `/assets/*`
- Cached long-term (immutable hashed files)

### SPA entry point
- `index.html`
- No-cache policy

### API
- Cache bypassed at Cloudflare level

---

# 🛠 Local Development

## Backend

```bash
cd backend
npm install
npm run dev
```

## Frontend

```bash
cd frontend
npm install
npm run dev
```

---

# 🧪 Health Check

```bash
curl https://api.taskflow.fblouison.com/api/health
```

Expected response:

```json
{
  "status": "healthy",
  "environment": "production"
}
```

---

# 📈 Scalability

- Horizontal Pod Autoscaler (1 → 3 replicas)
- CPU-based scaling (70% threshold)
- Stateless backend design
- External managed database
- CDN edge caching

---

# 🏆 What This Project Demonstrates

- Full production cloud architecture
- Infrastructure as Code best practices
- Kubernetes deployment strategy
- CI/CD with OIDC authentication
- TLS automation
- Global CDN setup
- Secure networking
- Real-world DevOps workflow

---

# 📌 Future Improvements

- Prometheus + Grafana monitoring stack
- ArgoCD GitOps deployment
- Multi-environment setup (dev/staging/prod)
- Blue/Green deployment strategy
- Redis caching layer
- Backend unit & integration tests
- Frontend E2E testing

---

# 📄 License

MIT License

---

# 👤 Author

 FANOMEZANTSOA Bien Aimé Louison

Cloud & DevOps Engineer  
Google Cloud | Kubernetes | Terraform | CI/CD

---

# 🎯 Project Objective
This project demonstrates the design and deployment of a production-ready cloud-native application using modern DevOps practices.

The focus is on:

Infrastructure as Code
Kubernetes orchestration
Secure CI/CD pipelines
Scalability & reliability
Cloud networking design
Automated TLS management

---