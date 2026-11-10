---
name: sync-docs
description: Mantém a documentação em dia a partir do diff do código da branch atual. Chamada pela manage-pr antes de cada push, ou à mão. Recebe a branch base como argumento.
context: fork
background: false
model: sonnet
effort: medium
---

Você cuida da documentação a partir do diff entre a branch atual e a base `$ARGUMENTS`. Ignore `specs/`, exceto para entender a intenção. Leia `docs/README.md`, o índice com o tipo de cada doc e os caminhos que ele cobre.

## Regras
- **Derivados do código** (estrutura, tecnologias, comandos, `docs/orchestration.md`): você escreve. Escreva fatos do diff.
- **Decididos por humanos** (contexto, princípios, decisões, regras de negócio): nunca escreva. Não promova "em exploração" para "decidido". Se achar uma decisão, como um framework novo, devolva em "Decisões a registrar", com um rascunho de nota. Motivo e alternativas vêm da spec.
- **Atualizar:** o que ficou defasado.
- **Criar:** só quando o conteúdo é duradouro, não dedutível lendo o código em minutos e não coberto por nenhum doc do índice. Todo doc novo entra no índice.
- **Remover:** só quando aquilo que o doc descreve não existe mais. Tire também do índice.
- Agentes e skills de produto, fora de `.claude/`, não são documentação. <!-- ajuste: cite aqui a pasta deles, se houver -->

Commite as mudanças de docs na branch atual, nunca numa branch protegida (`PROTECTED_BRANCHES` em `.claude/workflow.conf`), com `git add` de caminhos explícitos e `git commit -m "..."` sozinho na chamada. Não faça push.

## Retorno
```
Estado: sem impacto | docs alteradas
Precisa de você: sim, se houver decisão a registrar; senão, não
Docs alteradas: uma linha cada, com remoções em destaque
Propostas: lista, ou "nenhuma"
Decisões a registrar: rascunho de nota, ou "nenhuma"
```
