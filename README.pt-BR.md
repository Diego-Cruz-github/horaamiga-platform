# HoraAmiga - Plataforma de Cuidado Social (Arquitetura e Infraestrutura)

> [English](README.md) | **Português (BR)**

[![ci](https://github.com/Diego-Cruz-github/horaamiga-platform/actions/workflows/ci.yml/badge.svg)](https://github.com/Diego-Cruz-github/horaamiga-platform/actions/workflows/ci.yml)

Plataforma de cuidado social para pessoas idosas em Portugal: check-in diário e
botão de emergência, com alertas em cascata para familiares e voluntários.
Incubada pela Human Power Hub (Portugal 2030 / União Europeia).

- Site: https://horaamiga.pt

## Sobre este repositório

Este repositório documenta a **arquitetura e a camada de infraestrutura/DevOps**
da plataforma: provisionamento, configuração de servidor, containerização,
observabilidade e decisões técnicas (ADRs).

O **código da aplicação (backend e dados de utentes) é privado**, por se tratar
de uma plataforma em produção que lida com dados pessoais sob GDPR. O que vive
aqui é a engenharia de plataforma, sanitizada: sem segredos, sem dados pessoais.

## Stack

| Camada | Tecnologia |
|---|---|
| Infraestrutura | Hetzner (Alemanha, GDPR), Cloudflare (DNS/CDN/WAF) |
| Provisionamento | Terraform |
| Configuração | Ansible |
| Aplicação | API Node.js (Express) + serviços operacionais em Python, PostgreSQL (Supabase) |
| Servidor web | Nginx (reverse proxy), SSL Let's Encrypt |
| Processos | PM2 (modo cluster) |
| Containerização | Docker (multi-stage) |
| Orquestração | Kubernetes (k3s) |
| Observabilidade | Prometheus, Grafana, Loki |
| Automação | Scripts Python (backup, health-check) |
| CI | GitHub Actions ([ci.yml](.github/workflows/ci.yml)): Terraform validate, Ansible check, lint do Dockerfile, schema k8s, varredura de segredos; [port Azure DevOps](azure-pipelines.yml) |
| Portabilidade cloud | Port Terraform AWS ([terraform/aws](terraform/aws)); mapeamento GCP/Azure ([multi-cloud.md](docs/architecture/multi-cloud.md)) |

## Arquitetura

Ver [`docs/architecture/overview.md`](docs/architecture/overview.md) para o
diagrama, componentes e fluxos. A portabilidade entre clouds está mapeada em
[`docs/architecture/multi-cloud.md`](docs/architecture/multi-cloud.md).

## Decisões técnicas (ADRs)

As decisões de arquitetura estão registradas em [`docs/decisions/`](docs/decisions/)
(em inglês):

- 0001 - Hetzner em vez de hyperscaler
- 0002 - Gestão de segredos
- 0003 - IaC com Terraform e Ansible
- 0004 - Containerização e Kubernetes (k3s)
- 0005 - Observabilidade self-hosted
- 0006 - AWS como port único de referência

## Estrutura do repositório

```
.
├── docs/
│   ├── architecture/      # Diagramas, componentes e portabilidade multi-cloud
│   └── decisions/         # ADRs (Architecture Decision Records)
├── terraform/
│   ├── hetzner/           # Infraestrutura real, codificada (IaC)
│   └── aws/               # Port AWS da mesma stack (portabilidade)
├── ansible/               # Configuração de servidor (idempotente, agnóstica de provider)
├── docker/                # Dockerfile multi-stage + compose para dev local
├── k8s/                   # Manifests Kubernetes (k3s): deployment, service, ingress, HPA
├── observability/         # Prometheus, dashboards Grafana, Loki, regras de alerta
├── scripts/               # Automação operacional (backup, health-check)
├── .env.example           # Template de variáveis (sem valores reais)
└── .gitignore
```

## Configuração

As variáveis de ambiente são carregadas de um arquivo `.env` que **nunca é
versionado**. Use o [`.env.example`](.env.example) como referência das chaves
necessárias. Os valores reais vivem apenas no servidor.

## Licença

Código de infraestrutura sob [licença MIT](LICENSE). Conteúdo, marca e código
de aplicação do HoraAmiga são reservados.
