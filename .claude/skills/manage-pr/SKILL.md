---
name: manage-pr
description: Abre, atualiza, fecha e mergeia pull requests deste repositório. Use só quando o orquestrador chegar à entrega depois de revisão aprovada, ou a pedido explícito do PO, como "pode abrir o PR". Nunca use por iniciativa própria.
model: sonnet
---

A base padrão e as branches protegidas estão em `.claude/workflow.conf`; os revisores, em `.claude/skills/manage-pr/reviewers.txt`.

Os passos fixos são scripts em `.claude/skills/manage-pr/scripts/`. Você só redige o corpo do PR. Rode os scripts a partir da raiz do checkout, com o caminho relativo exato e sozinhos na chamada, sem `cd`, pipe, `;` nem `&&`. Encadeados, eles ficam no sandbox e perdem o acesso ao `gh` e ao SSH. `git push` direto é negado de propósito.

## Abrir
1. Rode `.claude/skills/sync-docs/scripts/docs-impact.sh <base>`. Se der `analisar`, chame a skill `sync-docs` com a base como argumento. Se der `sem impacto`, siga sem chamá-la.
2. Se houver decisão a registrar, devolva ao orquestrador e pare.
3. Redija `.work/pr/<slug>/body.md` a partir de `.github/pull_request_template.md`: objetivo e decisões vêm da spec; o que mudou e os desvios vêm do relatório e dos commits; documentação vem do `sync-docs`.
4. Preencha a linha de orquestração a partir do `total` e das `escaladas` de cada loop no arquivo de estado, e dos horários do git. `revisões` conta cada revisão executada, inclusive a aprovada; `dúvidas técnicas` e `dúvidas de produto`, cada dúvida respondida; `tentativas de teste`, a soma de `Tentativas de teste` dos relatórios. O tempo vai do commit da spec até agora.
5. Rode `.claude/skills/manage-pr/scripts/pr-open.sh <base> "<título>" .work/pr/<slug>/body.md`. O título é curto, em inglês.

## Atualizar
- Título e descrição: `gh pr edit`.
- Novo push: repita o passo 1 e rode `.claude/skills/manage-pr/scripts/pr-push.sh --current`.

## Fechar
Só sob comando do PO: `.claude/skills/manage-pr/scripts/pr-close.sh <número>`.

## Mergear
Só sob comando do PO:
1. `.claude/skills/manage-pr/scripts/pr-check-approval.sh <número>`. Se reprovar, pare e relate.
2. `.claude/skills/manage-pr/scripts/pr-remove-spec.sh <slug>`. Esse commit não roda o `sync-docs`.
3. `.claude/skills/manage-pr/scripts/pr-merge.sh <número>`, que confere de novo, faz squash e apaga a branch.

## Retorno
```
Estado: PR aberto | PR atualizado | PR fechado | mergeado | bloqueado
Precisa de você: sim | não
PR: <link>
Ação: uma linha
Pendências: lista, ou "nenhuma"
```
