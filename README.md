# HoraAmiga - Plataforma de Cuidado Social (Arquitetura e Infraestrutura)

Plataforma de cuidado social para pessoas idosas em Portugal: check-in diario e
botao de emergencia, com alertas em cascata para familiares e voluntarios.
Incubada pela Human Power Hub (Portugal 2030 / Uniao Europeia).

- Site institucional: https://horaamiga.pt
- Aplicacao (PWA): https://app.horaamiga.pt

## Sobre este repositorio

Este repositorio documenta a **arquitetura e a camada de infraestrutura/DevOps** da
plataforma: provisionamento, configuracao de servidor, containerizacao, observabilidade
e decisoes tecnicas (ADRs).

O **codigo da aplicacao (backend e dados de utentes) e privado**, por se tratar de uma
plataforma em producao que lida com dados pessoais sob GDPR. O que esta aqui e a
engenharia de plataforma, sanitizada: sem segredos, sem dados pessoais.

## Stack

| Camada | Tecnologia |
|---|---|
| Infraestrutura | Hetzner (Alemanha, GDPR), Cloudflare (DNS/CDN/WAF) |
| Provisionamento | Terraform |
| Configuracao | Ansible |
| Aplicacao | Node.js, Express, PostgreSQL (Supabase) |
| Servidor web | Nginx (reverse proxy), SSL Let's Encrypt |
| Processos | PM2 (cluster mode) |
| Containerizacao | Docker (multi-stage) |
| Orquestracao | Kubernetes (k3s) |
| Observabilidade | Prometheus, Grafana, Loki |
| Automacao | Scripts em Python (backup, health-check) |

## Arquitetura

Ver [`docs/architecture/overview.md`](docs/architecture/overview.md) para o diagrama
e a descricao dos componentes e fluxos.

## Decisoes tecnicas (ADRs)

As decisoes de arquitetura estao registradas em [`docs/decisions/`](docs/decisions/),
no formato Architecture Decision Record:

- [0001 - Hetzner em vez de hyperscaler](docs/decisions/0001-hetzner-em-vez-de-hyperscaler.md)
- [0002 - Gestao de segredos](docs/decisions/0002-gestao-de-segredos.md)

## Estrutura do repositorio

```
.
├── docs/
│   ├── architecture/      # Diagramas e descricao da arquitetura
│   └── decisions/         # ADRs (Architecture Decision Records)
├── terraform/             # Provisionamento da infraestrutura (IaC)
├── ansible/               # Configuracao de servidor (idempotente)
├── k8s/                   # Manifests Kubernetes (k3s)
├── observability/         # Configuracao de Prometheus, Grafana, Loki
├── scripts/               # Automacao operacional (backup, health-check)
├── .env.example           # Template de variaveis (sem valores reais)
└── .gitignore
```

## Configuracao

As variaveis de ambiente sao carregadas de um arquivo `.env` que **nunca e versionado**.
Use [`.env.example`](.env.example) como referencia das chaves necessarias. Os valores
reais ficam apenas no servidor.

## Licenca

Codigo de infraestrutura sob licenca MIT. Conteudo, marca e codigo de aplicacao do
HoraAmiga sao reservados.
