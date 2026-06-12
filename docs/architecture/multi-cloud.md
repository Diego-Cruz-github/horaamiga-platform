# Arquitetura multi-cloud (portabilidade)

A plataforma roda em Hetzner (ver ADR 0001), mas a arquitetura e **cloud-agnostica**:
cada componente tem equivalente direto nos hyperscalers. Migrar e trocar de provedor,
nao redesenhar. Este documento mapeia essa portabilidade.

## Mapeamento de servicos

| Componente | Hetzner (atual) | AWS | GCP | Azure |
|---|---|---|---|---|
| Compute | VPS / servidor | EC2 | Compute Engine | Virtual Machine |
| Kubernetes | k3s (self-managed) | EKS | GKE | AKS |
| Banco relacional | Supabase (PostgreSQL UE) | RDS PostgreSQL | Cloud SQL | Azure DB for PostgreSQL |
| Object storage | Volume / MinIO | S3 | Cloud Storage | Blob Storage |
| DNS / CDN | Cloudflare | Route 53 + CloudFront | Cloud DNS + Cloud CDN | Azure DNS + Front Door |
| Secrets | .env / Secret do K8s | Secrets Manager | Secret Manager | Key Vault |
| Load balancer | Nginx / Traefik | ALB | Cloud Load Balancing | Azure Load Balancer |
| Registry de imagem | GHCR | ECR | Artifact Registry | ACR |

## Comparacao de custo (ordem de grandeza, mensal)

| Onde | Custo aproximado | Observacao |
|---|---|---|
| Hetzner (atual) | ~EUR 5-40 | Servidor + DNS Cloudflare gratis |
| AWS equivalente | ~USD 200-300 | EKS (control plane ~USD 73 fixo) + NAT + LB drenam antes da app rodar |
| GCP equivalente | ~USD 180-250 | Similar AWS |

A diferenca nao e a app - e os servicos gerenciados (control plane de K8s, NAT Gateway,
load balancer) que cobram fixo, independente de uso. Para um projeto social de trafego
modesto, Hetzner entrega o mesmo resultado por uma fracao do custo. Ver ADR 0001.

## Como aplicar em outra cloud

O codigo Terraform deste repo usa o provider da Hetzner. Portar significa escrever o
equivalente com o provider do hyperscaler (mesma logica: recurso de compute, rede,
DNS, K8s). O `terraform plan` mostra a diferenca antes de aplicar; subir no credito
free, validar e destruir permite ter a evidencia sem custo permanente.

> Status: documento de arquitetura e portabilidade. A aplicacao real em hyperscaler
> e feita sob demanda (provisionar, validar, destruir), nao mantida 24/7 por custo.
