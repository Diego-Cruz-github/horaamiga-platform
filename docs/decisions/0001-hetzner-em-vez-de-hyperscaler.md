# ADR 0001 - Hetzner em vez de hyperscaler

**Data:** 2026-06-10
**Status:** Accepted

## Contexto

A plataforma precisa rodar na Uniao Europeia (GDPR), com custo previsivel e baixo -
e um projeto social incubado, nao uma operacao com orcamento de cloud corporativa.
O trafego e modesto e estavel (publico inicial: idosos em Braga e regiao), sem picos
que justifiquem elasticidade automatica de hyperscaler.

## Decisao

Infraestrutura em VPS Hetzner (datacenter na Alemanha), com Cloudflare na frente
(DNS, CDN e protecao). Banco de dados gerenciado (Supabase, regiao UE) para nao
operar PostgreSQL na mao neste estagio.

## Alternativas consideradas

- **AWS/GCP/Azure:** o equivalente funcional (instancia + load balancer + NAT + banco gerenciado)
  custa varias vezes mais por mes para o mesmo resultado neste porte. Servicos gerenciados
  valem o preco quando ha equipe e escala que os justifique; aqui seriam custo sem retorno.
- **Self-hosted total (banco incluso):** maior controle, porem backup, replicacao e upgrade
  de banco viram responsabilidade operacional de uma pessoa. O banco gerenciado reduz esse risco.

## Consequencias

- Positivo: custo mensal baixo e previsivel; dados em territorio europeu; stack simples de operar solo.
- Trade-off: sem elasticidade automatica - escalar significa redimensionar o servidor ou adicionar
  um segundo no (decisao consciente, documentada para revisao quando o trafego justificar).
- A arquitetura e portavel: os componentes (compute, banco PostgreSQL, DNS/CDN, storage)
  tem equivalente direto em qualquer hyperscaler, entao a migracao futura e uma troca de
  provedor, nao um redesenho.
