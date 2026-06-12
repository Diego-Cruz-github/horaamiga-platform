# ADR 0005 - Observabilidade self-hosted

**Data:** 2026-06-12
**Status:** Accepted

## Contexto

A plataforma precisa de visibilidade: saber se a API esta no ar, qual a latencia, a taxa
de erro, e ter os logs centralizados para investigar incidentes. Hoje ha error tracking
(Sentry) e logs estruturados (Winston), mas falta metricas, dashboards e agregacao de log.

## Decisao

Stack self-hosted: **Prometheus** (metricas), **Grafana** (dashboards versionados como
codigo), **Loki** (agregacao de logs) e **Alertmanager** roteando alertas pro Telegram
ja existente. Foco nas metricas **RED** (Rate, Errors, Duration) da API.

## Alternativas consideradas

- **Datadog / New Relic:** excelentes e rapidos de subir, mas cobram por host/volume.
  Para o orcamento atual nao se justifica. Ficam como familiaridade (free tier) e
  comparativo; em ambiente com orcamento, a escolha poderia mudar.
- **ELK (Elasticsearch/Logstash/Kibana):** padrao consagrado, mas Elasticsearch consome
  RAM demais para o servidor atual. Loki entrega o essencial de agregacao de log com
  fracao do consumo, e integra nativo com o Grafana.

## Consequencias

- Positivo: custo zero de licenca; dominio da camada que esta por baixo do SaaS de
  observabilidade; alertas reaproveitando o Telegram ja integrado.
- Trade-off: operar a stack e responsabilidade propria (atualizacao, retencao, storage) -
  enquanto um SaaS terceiriza isso. Aceitavel pelo custo e pelo aprendizado.
- Retencao de logs curta (7 dias no Loki) para nao encher o disco do servidor pequeno.
