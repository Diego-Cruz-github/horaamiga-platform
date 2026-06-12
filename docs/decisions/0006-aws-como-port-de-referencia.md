# ADR 0006 - AWS as the single reference port

**Date:** 2026-06-12
**Status:** Accepted

## Context

The architecture is cloud-agnostic (ADR 0001, multi-cloud.md), and the repository
should demonstrate that portability in code, not just in a mapping table. The
question was whether to implement Terraform ports for all three hyperscalers
(AWS, GCP, Azure) or for a single one.

## Decision

Implement **one deep port - AWS** (`terraform/aws`) - and document GCP/Azure as
service mappings in `docs/architecture/multi-cloud.md`.

AWS was chosen because it has the largest market share and is the most common
requirement in job and client contexts; the port mirrors the live Hetzner stack
resource-for-resource (instance, edge firewall as Security Group, SSH key, EU
region for GDPR parity), and the Ansible playbook is provider-agnostic - it
configures whichever IP Terraform outputs.

## Alternatives considered

- **Three shallow ports:** triples the maintenance surface and invites
  copy-paste filler. Three skeletons prove less than one complete, validated
  port plus a clear porting pattern.
- **No port (mapping table only):** the table explains the equivalence but does
  not prove it. Code that passes `terraform validate` does.

## Consequences

- Positive: portability proven in code with minimal surface; a clear pattern to
  follow if a GCP or Azure port is ever required ("same recipe, different
  provider").
- Trade-off: GCP/Azure remain documentation-only until a real need appears -
  a deliberate scope decision, not an omission.
