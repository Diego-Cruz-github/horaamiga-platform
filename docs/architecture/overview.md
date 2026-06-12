# Architecture - overview

## Diagram

```
                          Users (PT / EU)
                                |
                  +---------------------------+
                  |        CLOUDFLARE         |
                  |  DNS + CDN + protection   |
                  +---------------------------+
                                |
                  +---------------------------+
                  |    HETZNER VPS (DE/EU)    |
                  |                           |
                  |  +---------------------+  |
                  |  |       NGINX         |  |
                  |  | reverse proxy / SSL |  |
                  |  +----------+----------+  |
                  |     |       |       |     |
                  |   site     PWA     API    |
                  | (static) (static)   |     |
                  |                     |     |
                  |  +------------------v--+  |
                  |  |  Node.js (Express)  |  |
                  |  |  PM2 cluster (2x)   |  |
                  |  |  + workers (cron)   |  |
                  |  +------------------+--+  |
                  +---------------------|-----+
                                        |
            +---------------------------+---------------------------+
            |                           |                           |
   +--------v--------+        +--------v--------+        +--------v--------+
   |    SUPABASE     |        |    TELEGRAM     |        |     RESEND      |
   | PostgreSQL (EU) |        | real-time       |        | transactional   |
   | auth + realtime |        | alerts          |        | email (OTP)     |
   +-----------------+        +-----------------+        +-----------------+
```

## Components

| Component | Role | Notes |
|---|---|---|
| Cloudflare | DNS, CDN, protection layer | In front of all traffic |
| Nginx | Reverse proxy, SSL (Let's Encrypt), serves static assets | Automated certificate renewal (cron) |
| Node.js / Express | REST API: authentication, check-in, emergency | PM2 in cluster mode (2 instances) to use the cores and survive a process crash |
| Workers (cron) | Monitor missed check-ins and escalate alerts | The heart of the product: if the elderly person gives no sign, the system acts |
| Supabase (PostgreSQL) | Data, OTP authentication, realtime | EU region; RLS (row level security) enabled |
| Telegram | Real-time alert channel for family/volunteers | Two bots: alerts and services |
| Resend | Transactional email (login OTP) | Verified domain |

The platform serves two frontends from the same server: the institutional
website (`horaamiga.pt`, static, trilingual PT/EN/ES) and the application
(`app.horaamiga.pt`, PWA + API), routed by Nginx.

## Server operations

- **Processes:** PM2 in cluster mode, automatic restart on failure.
- **Backups:** daily, automated via cron, with retention; verified by script (`scripts/`).
- **Health-check:** periodic cron check with a dedicated log.
- **Host security:** firewall (UFW) with minimal ports, fail2ban against SSH
  brute-force, key-only access.
- **SSL:** Let's Encrypt with automatic renewal.

## Compliance (GDPR)

- All hosting on EU soil (Hetzner Germany, Supabase EU region).
- Data minimization: the system collects what the care service needs.
- Audit logs; privacy policy and terms published on the website (PT/EN/ES).

## Planned evolution

The current base runs on a manually managed server. The designed evolution,
in order:

1. **IaC:** provisioning in Terraform (server, firewall, DNS) and configuration in
   Ansible (idempotent), making the environment reproducible from scratch.
2. **Containerization:** package the API as a multi-stage Docker image.
3. **Orchestration:** k3s (lightweight Kubernetes, suited to this scale) with health
   probes and horizontal autoscaling.
4. **Observability:** Prometheus (metrics), Grafana (dashboards), Loki (centralized
   logs), with alerts routed to the already-integrated Telegram.
5. **Multi-cloud:** portability documentation mapping equivalent services on
   AWS/Azure/GCP (see `multi-cloud.md`).

Each step lands in this repository as it is implemented, with the decision
recorded as an ADR.
