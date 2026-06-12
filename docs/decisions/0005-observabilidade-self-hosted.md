# ADR 0005 - Self-hosted observability

**Date:** 2026-06-12
**Status:** Accepted

## Context

The platform needs visibility: whether the API is up, its latency, its error
rate, and centralized logs to investigate incidents. Today there is error
tracking (Sentry) and structured logging (Winston), but no metrics, dashboards
or log aggregation.

## Decision

Self-hosted stack: **Prometheus** (metrics), **Grafana** (dashboards versioned
as code), **Loki** (log aggregation) and **Alertmanager** routing alerts to the
already-integrated Telegram bot. Focus on the **RED** metrics (Rate, Errors,
Duration) of the API.

## Alternatives considered

- **Datadog / New Relic:** excellent and fast to set up, but priced per
  host/volume. Not justified at the current budget. They remain as familiarity
  (free tiers) and comparison; with a budget, the choice could change.
- **ELK (Elasticsearch/Logstash/Kibana):** the established standard, but
  Elasticsearch consumes too much RAM for the current server. Loki delivers the
  essential log aggregation at a fraction of the footprint, and integrates
  natively with Grafana.

## Consequences

- Positive: zero licensing cost; mastery of the layer underneath observability
  SaaS; alerts reusing the Telegram integration that already exists.
- Trade-off: operating the stack (upgrades, retention, storage) is our own
  responsibility - a SaaS outsources that. Acceptable for the cost and the learning.
- Short log retention (7 days in Loki) to avoid filling the small server's disk.
