# ADR 0003 - IaC with Terraform and Ansible

**Date:** 2026-06-11
**Status:** Accepted

## Context

The infrastructure was initially configured by hand (imperatively) on the server.
That works, but has two problems: it is not reproducible (if the server is lost,
rebuilding depends on memory and manual steps) and it is not auditable (you cannot
see in code what exists and why). For a production platform, infrastructure must
be code: versioned, reviewable and recreatable.

## Decision

Split responsibility between two tools, each doing what it does best:

- **Terraform** provisions stateful cloud resources: the VM, the edge firewall,
  the SSH key and the DNS records. Terraform keeps state, so it knows what exists
  and computes the diff before applying.
- **Ansible** configures what lives inside the server: packages, Nginx, Node, PM2,
  Certbot and hardening. Ansible is idempotent and stateless - run it as many times
  as needed and it converges to the same result.

Flow: Terraform creates the VM and outputs the IP -> Ansible takes that IP and
configures the server from the inside.

## Alternatives considered

- **Everything in Ansible (VM creation included):** Ansible can create cloud
  resources, but it keeps no state - it does not know what already exists, so
  managing infrastructure lifecycle becomes fragile. Stateful provisioning is
  Terraform's job.
- **Everything in Terraform (server configuration included):** you can run scripts
  through Terraform, but repeatable, idempotent OS configuration is Ansible's
  territory. Mixing the two responsibilities muddies the code.
- **Pulumi instead of Terraform:** smaller ecosystem; Terraform has more mature
  providers and is the market standard for this kind of infrastructure.

## Consequences

- Positive: reproducible, auditable infrastructure; server recreatable from code;
  clear separation of concerns (provision vs configure).
- Trade-off: two tools to maintain instead of one. Acceptable - each solves a
  different problem, and together they cover the full lifecycle.
- Terraform state contains sensitive data (IPs, ids): it stays out of version
  control (.gitignore) and, with a team, would move to a remote backend with locking.
