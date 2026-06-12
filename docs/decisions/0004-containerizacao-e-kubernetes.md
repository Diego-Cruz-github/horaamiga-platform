# ADR 0004 - Containerization and Kubernetes (k3s)

**Date:** 2026-06-12
**Status:** Accepted

## Context

The API currently runs directly on the server under PM2 (process manager), which
works well at the current scale. To standardize packaging, portability and future
scaling, the designed evolution is to containerize the API and orchestrate it
with Kubernetes.

## Decision

- **Multi-stage Docker build** for the API: small image, no build tooling in the
  runtime layer, running as a non-root user.
- **k3s** (lightweight Kubernetes by Rancher) as the orchestrator, instead of full
  Kubernetes or a managed hyperscaler offering. k3s runs comfortably on a small
  server and provides the same experience (pods, deployments, services, HPA, ingress).
- Images published to GHCR; the cluster pulls from the registry (builds happen in
  CI, not on the server - which is why the host does not even need Docker).

## Alternatives considered

- **Staying on PM2 only:** simple and sufficient today, but provides no
  orchestration, autoscaling or standardized deploys at scale. Kept as the baseline;
  Kubernetes is the evolution step.
- **EKS/GKE/AKS (managed Kubernetes):** the control plane bills a fixed fee
  (~USD 73/month on AWS) even when idle. Overkill cost for the current scale. k3s
  delivers the learning and the result at near-zero cost, and portability to managed
  offerings is documented (multi-cloud.md).
- **Docker Compose instead of Kubernetes:** great for local dev (and used here),
  but does not cover production autoscaling/self-healing.

## Consequences

- Positive: standardized, portable deploys; autoscaling (HPA) and self-healing;
  the same conceptual stack as any managed cloud.
- Honest trade-off: Kubernetes is more complex than PM2 for one low-traffic app -
  here it serves as capability building and scale preparation, not immediate need.
  A conscious, documented decision.
