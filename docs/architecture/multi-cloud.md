# Multi-cloud architecture (portability)

The platform runs on Hetzner (see ADR 0001), but the architecture is
**cloud-agnostic**: every component has a direct equivalent on the hyperscalers.
Migrating is a provider swap, not a redesign. This document maps that portability.

## Service mapping

| Component | Hetzner (current) | AWS | GCP | Azure |
|---|---|---|---|---|
| Compute | VPS | EC2 | Compute Engine | Virtual Machine |
| Kubernetes | k3s (self-managed) | EKS | GKE | AKS |
| Relational DB | Supabase (PostgreSQL EU) | RDS PostgreSQL | Cloud SQL | Azure DB for PostgreSQL |
| Object storage | Volume / MinIO | S3 | Cloud Storage | Blob Storage |
| DNS / CDN | Cloudflare | Route 53 + CloudFront | Cloud DNS + Cloud CDN | Azure DNS + Front Door |
| Secrets | .env / K8s Secret | Secrets Manager | Secret Manager | Key Vault |
| Load balancer | Nginx / Traefik | ALB | Cloud Load Balancing | Azure Load Balancer |
| Image registry | GHCR | ECR | Artifact Registry | ACR |

## Cost comparison (order of magnitude, monthly)

| Where | Approximate cost | Notes |
|---|---|---|
| Hetzner (current) | ~EUR 5-40 | Server + free Cloudflare DNS |
| AWS equivalent | ~USD 200-300 | EKS control plane (~USD 73 fixed) + NAT + LB drain the budget before the app runs |
| GCP equivalent | ~USD 180-250 | Similar to AWS |

The difference is not the app - it is the managed services (Kubernetes control
plane, NAT Gateway, load balancer) that bill a fixed fee regardless of usage.
For a social project with modest traffic, Hetzner delivers the same result at a
fraction of the cost. See ADR 0001.

## Applying it on another cloud

The live stack is codified with the Hetzner provider (`terraform/hetzner`). The
**AWS port is implemented in [`terraform/aws`](../../terraform/aws)** - same
architecture, AWS-native resources (EC2, Security Group mirroring the edge
firewall, key pair, EU region for GDPR parity). The Ansible playbook is
provider-agnostic: it takes whichever IP Terraform outputs and configures the
server identically - only the provisioning layer changes.

GCP and Azure follow the same pattern; the AWS port is the reference
implementation. `terraform plan` shows the diff before applying; provisioning
on free credits, validating and destroying gives the evidence without permanent
cost.

> Status: architecture and portability document. Actual hyperscaler deployment is
> done on demand (provision, validate, destroy), not kept running 24/7, for cost
> reasons.
