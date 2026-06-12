# HoraAmiga - Social Care Platform (Architecture & Infrastructure)

Social care platform for elderly people in Portugal: daily check-in and an
emergency button, with cascading alerts to family members and volunteers.
Incubated by Human Power Hub (Portugal 2030 / European Union).

- Website: https://horaamiga.pt
- App (PWA): https://app.horaamiga.pt

## About this repository

This repository documents the **architecture and the infrastructure/DevOps layer**
of the platform: provisioning, server configuration, containerization,
observability and technical decisions (ADRs).

The **application code (backend and user data) is private**, since this is a
production platform handling personal data under GDPR. What lives here is the
platform engineering, sanitized: no secrets, no personal data.

## Stack

| Layer | Technology |
|---|---|
| Infrastructure | Hetzner (Germany, GDPR), Cloudflare (DNS/CDN/WAF) |
| Provisioning | Terraform |
| Configuration | Ansible |
| Application | Node.js (Express) API + Python operational services, PostgreSQL (Supabase) |
| Web server | Nginx (reverse proxy), Let's Encrypt SSL |
| Process manager | PM2 (cluster mode) |
| Containerization | Docker (multi-stage) |
| Orchestration | Kubernetes (k3s) |
| Observability | Prometheus, Grafana, Loki |
| Automation | Python scripts (backup, health-check) |
| Cloud portability | AWS Terraform port ([terraform/aws](terraform/aws)); GCP/Azure mapping ([multi-cloud.md](docs/architecture/multi-cloud.md)) |

## Architecture

See [`docs/architecture/overview.md`](docs/architecture/overview.md) for the
diagram, components and flows. Cloud portability is mapped in
[`docs/architecture/multi-cloud.md`](docs/architecture/multi-cloud.md).

## Technical decisions (ADRs)

Architecture decisions are recorded in [`docs/decisions/`](docs/decisions/):

- [0001 - Hetzner over a hyperscaler](docs/decisions/0001-hetzner-em-vez-de-hyperscaler.md)
- [0002 - Secrets management](docs/decisions/0002-gestao-de-segredos.md)
- [0003 - IaC with Terraform and Ansible](docs/decisions/0003-iac-terraform-e-ansible.md)
- [0004 - Containerization and Kubernetes (k3s)](docs/decisions/0004-containerizacao-e-kubernetes.md)
- [0005 - Self-hosted observability](docs/decisions/0005-observabilidade-self-hosted.md)
- [0006 - AWS as the single reference port](docs/decisions/0006-aws-como-port-de-referencia.md)

## Repository layout

```
.
├── docs/
│   ├── architecture/      # Diagrams, component description, multi-cloud portability
│   └── decisions/         # ADRs (Architecture Decision Records)
├── terraform/
│   ├── hetzner/           # Live infrastructure, codified (IaC)
│   └── aws/               # AWS port of the same stack (portability)
├── ansible/               # Server configuration (idempotent, provider-agnostic)
├── docker/                # Multi-stage Dockerfile + compose for local dev
├── k8s/                   # Kubernetes manifests (k3s): deployment, service, ingress, HPA
├── observability/         # Prometheus, Grafana dashboards, Loki, alert rules
├── scripts/               # Operational automation (backup, health-check)
├── .env.example           # Environment template (no real values)
└── .gitignore
```

## Configuration

Environment variables are loaded from a `.env` file that is **never committed**.
Use [`.env.example`](.env.example) as the reference for required keys. Real
values live only on the server.

## License

Infrastructure code under the [MIT license](LICENSE). HoraAmiga content, brand
and application code are reserved.
