# ecs-threat-composer

# Objective

Build, containerise and deploy an application using Docker, Terraform, and ECS, with HTTPS and a custom domain – exactly like a real production workload.

You’ll learn to go from manual AWS setup (aka ClickOps) > infrastructure as code > automated deployments.

I would highly recommend you use one of the options below in the Skool post. Please don't use the same one as you will have the same project as everyone else. Here they are 

## 1. Application Setup

Start with the app itself. You can either:

- Use the provided Threat Composer sample, or

- Pick another lightweight app (Node.js, Go, Python, etc.) that runs on port 80. Check below for example apps

- or Bring your own (BYO) application. 

### Requirements

- Must expose a simple route like `/health` returning `{"status": "ok"}`

- Must run locally before moving to Docker or AWS.

### Verification

```bash
curl http://localhost:80/health
# {"status":"ok"}

## 2. Containerisation

Containerise your app using Docker.

### Requirements

- Multi-stage Dockerfile (builder > runtime)
- `.dockerignore` file
- Non-root user and small image footprint
- App should run locally as a container
- If you CAN use a scratch or distroless image, please use it.

### Verification

```bash
docker build -t threatmod .
docker run -p 80:80 threatmod
curl http://localhost:8080/health
```

### Deliverables

- Dockerfile, `.dockerignore`
- Screenshot showing container running successfully

---

## 3. Image Registry (ECR or Docker Hub)

Push your built image to a container registry.

### Requirements

- Prefer ECR (Amazon Elastic Container Registry)
- Image tagged with version or commit SHA

### Verification

```bash
aws ecr describe-repositories
docker push <account>.dkr.ecr.<region>.amazonaws.com/threatmod:<tag>
```

---

## 4. AWS Infrastructure (ClickOps 1st!!)

Do this part manually before using Terraform.

This step is to ensure you understand how ECS, ALB and networking work.

Manually deploy the app using the AWS Console:

- Create an ECR repository
- Create an ECS Cluster (I recommend Fargate)
- Create a Task Definition for your container
- Set up an ALB (Application Load Balancer)
- Add a Security Group (allow inbound 80/443)
- Point a Route 53 record (`tm.<your-domain>`) to the ALB
- Attach an ACM certificate for HTTPS

✅ Once your app is reachable at:

```text
https://tm.<your-domain>
```

tear it all down.

You’ll now recreate it using Terraform.

---

## 5. AWS Infrastructure (Round 2) (Iac - Terraform)

Rebuild your ClickOps setup using Terraform.

### Minimum Resources

- VPC with public subnets
- ECS cluster + Fargate service
- ECR repository
- ALB + listener + target group
- ACM certificate
- Route53 record for `tm.<your-domain>`
- IAM roles/policies for ECS tasks
- Security groups, SSM parameters if needed

### Example repo structure

```text
infra/
 ├─ main.tf
 ├─ variables.tf
 ├─ outputs.tf
 ├─ modules/
 │   ├─ vpc/
 │   ├─ ecs/
 │   ├─ alb/
 │   ├─ ecr/
 │   └─ acm/
 └─ provider.tf
app/
Dockerfile
.gitignore
...etc
...etc
```

### Bonus

- Add Parameter Store or Secrets Manager for variables & secretss.
- Use Terragrunt (if you're feeling the challenge!). Otherwise, leave this.

---

## 6. CI/CD Automation

Automate builds and deployments with GitHub Actions (or GitLab CI if preferred).

### Stages

#### Build & Push

- Build Docker image and tag with SHA
- Push to ECR

#### Terraform Deploy

- Init, plan, apply on push to main
- Use OIDC (no static AWS keys)

#### Post-Deploy Check

```bash
curl https://tm.<your-domain>/health
```

- Fail pipeline if unhealthy

### Deliverables

- `.github/workflows/deploy.yml`
- Screenshot of a successful pipeline run
- Try to separate the pipelines where possible.
- Have a trigger based pipeline and use `workflow_dispatch` if using GitHub Actions.

### Bonus

- Add job summaries or a Slack notification (not needed but nice to have)
- Include terraform fmt, validate, tflint steps

---

## 7. HTTPS and Domain Validation

- Use AWS Certificate Manager (ACM) for TLS
- Configure Route 53 record to point to your ALB
- Force HTTPS redirect if required

✅ Final URL must be:

```text
https://tm.<your-domain> OR https://tm.labs.<your-domain>
```

---

## 8. Final Deliverables

Your GitHub repository should contain:

```text
├─ app/                 # your app code
├─ Dockerfile
├─ .dockerignore
├─ infra/               # Terraform (you may call this `terraform` too
├─ .github/workflows/   # ci/cd
└─ README.md
└─ .gitignore
```

README must include:

- Overview of your setup
- Architecture diagram (Lucidchart / draw.io / Mermaid) - you may do this at the start or at the end, your choice. Regardless, make sure it's finalised and as accurate as possible to your final infrastructure.
- Screenshots of successful deployment and app running live on AWS via the domain.
- Instructions to reproduce the setup. A short demo would be nice - but it's optional.

---

## Useful links 🔗

- Terraform AWS Registry
- Terraform AWS ECS
- Terraform Docs
- ECS Docs
