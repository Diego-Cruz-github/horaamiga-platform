# ADR 0001 - Hetzner over a hyperscaler

**Date:** 2026-06-10
**Status:** Accepted

## Context

The platform must run in the European Union (GDPR), with low and predictable
cost - it is an incubated social project, not an operation with an enterprise
cloud budget. Traffic is modest and stable (initial audience: elderly people in
the Braga region), with no spikes that would justify hyperscaler auto-elasticity.

## Decision

Run on Hetzner VPS (datacenter in Germany), with Cloudflare in front
(DNS, CDN and protection). Managed database (Supabase, EU region) so we do not
operate PostgreSQL by hand at this stage.

## Alternatives considered

- **AWS/GCP/Azure:** the functional equivalent (instance + load balancer + NAT +
  managed database) costs several times more per month for the same result at this
  scale. Managed services earn their price when there is a team and scale to justify
  them; here they would be cost without return.
- **Fully self-hosted (database included):** more control, but backup, replication
  and database upgrades become a one-person operational liability. The managed
  database removes that risk.

## Consequences

- Positive: low, predictable monthly cost; data on European soil; a stack that one
  person can operate.
- Trade-off: no auto-elasticity - scaling means resizing the server or adding a
  second node (a conscious decision, documented for review when traffic justifies it).
- The architecture is portable: every component (compute, PostgreSQL, DNS/CDN,
  storage) has a direct equivalent in any hyperscaler, so a future migration is a
  provider swap, not a redesign. See `docs/architecture/multi-cloud.md`.
