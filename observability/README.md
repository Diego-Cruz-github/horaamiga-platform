# Observability

Self-hosted stack, chosen for cost and for fitting a small server:

| Tool | Role |
|---|---|
| **Prometheus** | Metrics collection (15s scrape) |
| **Grafana** | Dashboards (versioned as code, in `grafana/dashboards/`) |
| **Loki** | Log aggregation (lightweight alternative to ELK) |
| **Alertmanager** | Routes alerts to Telegram (reuses the existing bot) |

## RED metrics

The focus is on the three RED metrics, which answer "is the application healthy?":

- **Rate** - requests per second
- **Errors** - rate of 5xx responses
- **Duration** - latency (p95)

The API exposes `/metrics` via `prom-client` (Node). `node-exporter` exposes
host CPU/RAM/disk.

## Why self-hosted instead of Datadog/New Relic

Datadog and New Relic are excellent but bill per host/volume. At this project's
scale and budget, Grafana + Prometheus + Loki deliver the same essential value
with zero licensing cost, operating directly the layer that a SaaS abstracts
away. With a budget, the trade-off changes (SaaS buys back operations time).
