# ADR 0002 - Gestao de segredos

**Data:** 2026-06-10
**Status:** Accepted

## Contexto

A plataforma lida com dados pessoais de pessoas idosas sob GDPR e integra varios
servicos externos (banco de dados, notificacoes, email), cada um com suas credenciais.
Credenciais nao podem, em nenhuma hipotese, acabar no controle de versao - nem em
repositorio privado, ja que um repositorio privado pode se tornar publico, ser clonado
ou ter o acesso ampliado no futuro.

## Decisao

Os segredos vivem exclusivamente em um arquivo `.env` no servidor, fora do versionamento.
O repositorio contem apenas um `.env.example` com as chaves e placeholders, nunca valores.

A protecao e aplicada em camadas (shift-left), da mais cedo para a mais tardia:

1. `.gitignore` cobrindo `.env`, chaves, estado do Terraform e credenciais desde o primeiro commit.
2. Secret scanning no fluxo de trabalho, para barrar um segredo antes de ele sair da maquina.
3. `.env.example` como contrato do que precisa ser preenchido, sem expor nada.
4. Procedimento de resposta a exposicao: rotacionar primeiro (gerar valor novo e invalidar o antigo),
   limpar o historico depois. Rotacao e o que de fato neutraliza, porque quem ja clonou levou o valor antigo.

## Alternativas consideradas

- **Segredos em variavel de ambiente do CI apenas:** cobre o pipeline, mas nao o desenvolvimento local. Mantido como complemento, nao como unica camada.
- **Cofre dedicado (HashiCorp Vault / Secret Manager):** e o passo natural de evolucao quando o numero de servicos e ambientes crescer. Para o estagio atual, `.env` no servidor com disciplina de rotacao atende, com custo operacional menor.

## Consequencias

- Positivo: nenhum segredo no historico do repositorio; processo de rotacao definido; repositorio seguro para ser publico.
- Trade-off: a disciplina depende de processo (gitignore + scanning + rotacao). Por isso as camadas sao automatizadas onde possivel, e nao deixadas a cargo da memoria de quem comita.
