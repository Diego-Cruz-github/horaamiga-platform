# ADR 0003 - IaC com Terraform e Ansible

**Data:** 2026-06-11
**Status:** Accepted

## Contexto

A infraestrutura foi inicialmente configurada de forma manual (imperativa) no servidor.
Isso funciona, mas tem dois problemas: nao e reproduzivel (se o servidor for perdido, a
reconstrucao depende de memoria e de passos manuais) e nao e auditavel (nao da pra ver
em codigo o que existe e por que). Para uma plataforma em producao, a infra precisa ser
codigo: versionada, revisavel e recriavel.

## Decisao

Dividir a responsabilidade em duas ferramentas, cada uma no que faz melhor:

- **Terraform** provisiona o que e recurso de nuvem com estado: a VM, o firewall de borda,
  a chave SSH e os registros DNS. Terraform mantem state, entao sabe o que existe e calcula
  a diferenca antes de aplicar.
- **Ansible** configura o que esta dentro do servidor: pacotes, Nginx, Node, PM2, Certbot e
  o hardening. Ansible e idempotente e sem estado - roda quantas vezes precisar e converge
  pro mesmo resultado.

Fluxo: Terraform cria a VM e expoe o IP (output) -> Ansible recebe esse IP e configura o
servidor por dentro.

## Alternativas consideradas

- **Tudo em Ansible (inclusive criar a VM):** o Ansible ate cria recurso de nuvem, mas nao
  guarda state - ele nao sabe o que ja existe, entao gerenciar ciclo de vida de infra fica
  fragil. Provisionamento de recurso com estado e trabalho de Terraform.
- **Tudo em Terraform (inclusive configurar o servidor):** da pra rodar script via Terraform,
  mas configuracao de SO repetivel e idempotente e o terreno do Ansible. Misturar as duas
  responsabilidades deixa o codigo confuso.
- **Pulumi em vez de Terraform:** ecossistema menor; Terraform tem mais providers maduros e
  e o padrao de mercado pra esse tipo de infra.

## Consequencias

- Positivo: infra reproduzivel e auditavel; servidor recriavel do zero a partir do codigo;
  separacao clara de responsabilidades (provisionar x configurar).
- Trade-off: duas ferramentas pra manter em vez de uma. Aceitavel - cada uma resolve um
  problema diferente, e juntas cobrem o ciclo completo.
- O state do Terraform contem dados sensiveis (IPs, ids): fica fora do versionamento
  (.gitignore) e, em time, iria pra backend remoto com lock.
