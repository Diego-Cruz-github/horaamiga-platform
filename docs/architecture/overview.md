# Arquitetura - visao geral

## Diagrama

```
                         Usuarios (PT / UE)
                                |
                  +---------------------------+
                  |        CLOUDFLARE         |
                  |   DNS + CDN + protecao    |
                  +---------------------------+
                                |
                  +---------------------------+
                  |    VPS HETZNER (DE/UE)    |
                  |                           |
                  |  +---------------------+  |
                  |  |       NGINX         |  |
                  |  |  reverse proxy/SSL  |  |
                  |  +----------+----------+  |
                  |     |       |       |     |
                  |   site     PWA     API    |
                  | (estatico)(estatico)|     |
                  |                     |     |
                  |  +------------------v--+  |
                  |  |  Node.js (Express)  |  |
                  |  |  PM2 cluster (2x)   |  |
                  |  |  + workers (cron)   |  |
                  |  +------------------+--+  |
                  +---------------------|-----+
                                        |
            +---------------------------+---------------------------+
            |                           |                           |
   +--------v--------+        +--------v--------+        +--------v--------+
   |    SUPABASE     |        |    TELEGRAM     |        |     RESEND      |
   | PostgreSQL (UE) |        | alertas em      |        | email (OTP de   |
   | auth + realtime |        | tempo real      |        | autenticacao)   |
   +-----------------+        +-----------------+        +-----------------+
```

## Componentes

| Componente | Papel | Observacao |
|---|---|---|
| Cloudflare | DNS, CDN, camada de protecao | Na frente de todo o trafego |
| Nginx | Reverse proxy, SSL (Let's Encrypt), serve os estaticos | Renovacao de certificado automatizada (cron) |
| Node.js / Express | API REST: autenticacao, check-in, emergencia | PM2 em cluster (2 instancias) para usar os nucleos e sobreviver a crash de processo |
| Workers (cron) | Monitoramento de check-ins atrasados e escalacao de alertas | O coracao do produto: se o idoso nao da sinal, o sistema age |
| Supabase (PostgreSQL) | Dados, autenticacao OTP, realtime | Regiao UE; RLS (row level security) ativo |
| Telegram | Canal de alerta em tempo real para familiares/voluntarios | Dois bots: alertas e servicos |
| Resend | Email transacional (OTP de login) | Dominio verificado |

## Operacao no servidor

- **Processos:** PM2 em modo cluster, com restart automatico em falha.
- **Backups:** diarios, automatizados via cron, com retencao; verificacao por script (`scripts/`).
- **Health-check:** verificacao periodica via cron com log dedicado.
- **Seguranca de host:** firewall (UFW) com portas minimas, fail2ban contra brute-force de SSH,
  acesso somente por chave.
- **SSL:** Let's Encrypt com renovacao automatica.

## Conformidade (GDPR)

- Toda a hospedagem em territorio UE (Hetzner Alemanha, Supabase regiao UE).
- Minimizacao de dados: o sistema coleta o necessario para o servico de cuidado.
- Logs de auditoria; politica de privacidade e termos publicados no site (PT/EN/ES).

## Evolucao planejada

A base atual roda em bare metal gerenciado manualmente. A evolucao desenhada,
nesta ordem:

1. **IaC:** provisionamento em Terraform (servidor, firewall, DNS) e configuracao em
   Ansible (idempotente), tornando o ambiente reproduzivel do zero.
2. **Containerizacao:** empacotar a API em imagem Docker multi-stage.
3. **Orquestracao:** k3s (Kubernetes enxuto, adequado ao porte) com health probes e autoscaling horizontal.
4. **Observabilidade:** Prometheus (metricas), Grafana (dashboards), Loki (logs centralizados),
   com alertas roteados para o Telegram ja integrado.
5. **Multi-cloud:** documentacao de portabilidade com mapeamento de servicos equivalentes
   em AWS/Azure/GCP (ver `docs/architecture/`).

Cada etapa entra neste repositorio conforme implementada, com a decisao registrada em ADR.
