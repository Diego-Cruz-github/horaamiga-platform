# Observabilidade

Stack self-hosted, escolhida por custo e por caber em servidor pequeno:

| Ferramenta | Papel |
|---|---|
| **Prometheus** | Coleta de metricas (scrape a cada 15s) |
| **Grafana** | Dashboards (versionados como codigo, em `grafana/dashboards/`) |
| **Loki** | Agregacao de logs (alternativa leve ao ELK - Elasticsearch nao cabe) |
| **Alertmanager** | Roteia alertas pro Telegram (reusa o bot ja existente) |

## Metricas RED

O foco sao as tres metricas RED, que respondem "a aplicacao esta saudavel?":

- **Rate** - requisicoes por segundo
- **Errors** - taxa de respostas 5xx
- **Duration** - latencia (p95)

A API expoe `/metrics` via `prom-client` (Node). O `node-exporter` expoe CPU/RAM/disco do host.

## Por que self-hosted e nao Datadog/New Relic

Datadog e New Relic sao excelentes, mas cobram por host/volume. Pro porte e o orcamento
do projeto, Grafana + Prometheus + Loki entregam o mesmo valor essencial com custo zero
de licenca - e mostram dominio da camada que esta por baixo do SaaS. Em ambiente com
orcamento, a leitura mudaria (SaaS poupa tempo de operacao).

## Status

Esta pasta contem a CONFIGURACAO (infra as code da observabilidade). A stack roda no
ambiente real quando o lab e aplicado - aqui fica o blueprint versionado.
