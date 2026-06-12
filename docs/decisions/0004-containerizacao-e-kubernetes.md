# ADR 0004 - Containerizacao e Kubernetes (k3s)

**Data:** 2026-06-12
**Status:** Accepted

## Contexto

A API hoje roda direto no servidor via PM2 (gerenciador de processos), o que funciona
bem para o porte atual. Para padronizar empacotamento, portabilidade e escala futura,
a evolucao desenhada e containerizar a API e orquestrar com Kubernetes.

## Decisao

- **Docker multi-stage** para empacotar a API: imagem pequena, sem ferramenta de build
  no runtime, rodando como usuario nao-root.
- **k3s** (Kubernetes leve, da Rancher) como orquestrador, em vez de Kubernetes completo
  ou de um hyperscaler gerenciado. k3s roda confortavelmente em servidor pequeno e
  entrega a mesma experiencia (pods, deployments, services, HPA, ingress).
- Imagens publicadas no GHCR; o cluster puxa do registry (o build acontece no CI, nao
  no servidor - por isso o host nem precisa de Docker).

## Alternativas consideradas

- **Continuar so com PM2:** simples e suficiente hoje, mas nao da orquestracao, autoscaling
  nem padroniza deploy para escala. Mantido como baseline; K8s e o passo de evolucao.
- **EKS/GKE/AKS (K8s gerenciado):** control plane cobra fixo (~USD 73/mes na AWS) mesmo
  ocioso. Para o porte atual e overkill de custo. k3s da o aprendizado e o resultado por
  custo proximo de zero. A portabilidade pro gerenciado fica documentada (multi-cloud.md).
- **Docker Compose em vez de K8s:** otimo pra dev local (e usado aqui), mas nao cobre
  autoscaling/self-healing de producao.

## Consequencias

- Positivo: deploy padronizado e portavel; autoscaling (HPA) e self-healing; mesma stack
  conceitual de qualquer cloud gerenciada.
- Trade-off honesto: K8s e mais complexo que PM2 para 1 app de trafego baixo - aqui ele
  entra como capacitacao e preparo para escala, nao por necessidade imediata. Decisao
  consciente e documentada.
