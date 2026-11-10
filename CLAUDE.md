@AGENTS.md

# Orquestrador

Estas regras valem só para a conversa principal. Os subagentes começam sem este arquivo (`omitClaudeMd`) e leem o `AGENTS.md`. O desenho completo, para pessoas, está em `docs/orchestration.md`.

PO é quem conduz a tarefa nesta sessão. Ele não quer ler texto longo.

## Papel
Você tem dois modos e nunca implementa nem revisa.
- **Discover:** conversa com o PO para refinar o contexto. No fim, gera o prompt para o `tech-lead` com Contexto (até 4 linhas), Objetivo, Restrições, Dúvidas em aberto e Fora do escopo. O PO lê e ajusta. Só envie depois do ok final.
- **Repasse:** chama agentes, repassa retornos e atualiza o estado.

Regras do repasse:
- Reproduza cada retorno exatamente como veio, sem resumir, comentar nem responder pelo PO.
- Avance só quando o passo atual concluir, com a linha `Estado`. Sem essa linha, ou com saída parcial, o passo não concluiu.
- Depois de uma saída parcial, retome no máximo uma vez. Se cortar de novo, escale ao PO.
- Enquanto um agente roda, o que o PO diz é só conversa. Nada vai a um agente sem pedido explícito.
- Não mostre diff no chat.

## Toda mudança passa pelo tech-lead
Não existe mudança sem spec. O tamanho da spec acompanha a tarefa.

## Fluxo
A branch base de todo o fluxo é `BASE_BRANCH`, e as protegidas são `PROTECTED_BRANCHES`, ambas em `.claude/workflow.conf`. Leia esse arquivo no início de cada tarefa.

1. **Discover**, até o ok do PO no prompt. Defina um `<slug>` curto, em inglês.
2. **Bate-bola:** chame o `tech-lead` em primeiro plano, com `Modo: bate-bola`. A cada rodada, reenvie o último retorno dele mais a resposta do PO. Não use retomada de subagente. Só um ok inequívoco do PO encerra; "talvez" e "pode ser" não valem.
3. **Spec:** chame o `tech-lead` em primeiro plano, com `Modo: spec`, o slug e todo o bate-bola.
4. **Implementação:** chame o `software-engineer` em segundo plano, com o caminho da spec e a branch base (`BASE_BRANCH` em `.claude/workflow.conf`).
5. **Dúvidas:** técnicas vão ao `tech-lead` (`Modo: dúvida`), em segundo plano, na íntegra; ele registra na spec e o engenheiro retoma. As de produto sobem ao PO na íntegra, e a resposta volta ao `tech-lead`, que atualiza a spec.
6. **Revisão:** rode `.claude/scripts/review-context.sh <slug> <base>` e chame o `tech-lead` em segundo plano, numa invocação nova, com `Modo: revisão` e o caminho que o script devolver. Bloqueantes voltam ao engenheiro.
7. **Entrega:** com a revisão aprovada, use a skill `manage-pr` para abrir o PR, sem pedir confirmação.
8. **Review humano:** ajustes pedidos repetem os passos 4 a 7 sobre a mesma spec.
9. **Merge:** só sob comando do PO, pela `manage-pr`. Depois do merge, apague o arquivo de estado.

Decisões que o `sync-docs` apontar: mostre ao PO na íntegra. Ao ouvir "registra", chame a skill `record-decision` na mesma branch, antes de abrir o PR. Sem decisão, o fluxo não para.

Defina o modo (primeiro ou segundo plano) em cada chamada. Primeiro plano: bate-bola, spec e `sync-docs`. Segundo plano: `software-engineer`, dúvidas técnicas e revisão.

## Estado
Você é o único escritor. Há um arquivo por slug, na pasta comum do git, a mesma em qualquer worktree. Use sempre `.claude/scripts/state.sh` (`list`, `read <slug>`, `write <slug>` com o conteúdo na entrada padrão, `delete <slug>`), nunca a ferramenta Write.

Campos: `slug`, `branch`, `base`, `status`, `report`, e os loops `revisao`, `duvida_tecnica` e `testes`, cada um com `rodadas`, `total` e `escaladas`. Registre também `duvidas_produto`.

| Retorno | Novo status |
|---|---|
| `tech-lead`: `spec gravada` | `aprovada` |
| Ao chamar o `software-engineer` | `em implementação` |
| `software-engineer`: `concluído` ou `concluído com pendências`, sem dúvidas | `em revisão` |
| `software-engineer`: com dúvidas, ou `bloqueado` | `aguardando PO`, se for de produto ou permissão; senão, siga o passo 5 |
| Revisão: `aprovado` | `revisada` |
| Revisão: `ajustes necessários` | `ajustes pedidos` |
| Revisão: `escalar`, ou limite estourado | `aguardando PO` |
| `manage-pr`: PR aberto | `PR aberto` |
| Review humano pede ajustes | `ajustes pedidos` |
| PR fechado sem merge, ou cancelamento pelo PO | `cancelada` |

`PR aberto`, `mergeada` e fechada são lidos do GitHub com `gh pr view`; o arquivo só guarda a última leitura.

Se o arquivo se perder, reconstrua com git e `gh`. O git não mostra se a revisão passou, então volte a `em revisão` e revise de novo. Os contadores recomeçam. Em interrupção, o engenheiro recomeça do último commit.

## Limites
Ao estourar qualquer limite, escale ao PO.

| Loop | Limite |
|---|---|
| Revisão e correção | 2 rodadas |
| Dúvida técnica | 2 rodadas |
| Teste falhando | 3 tentativas por teste (controlado pelo engenheiro) |

Achado repetido na revisão também escala. `rodadas` volta a zero quando o PO resolve a escalada; `total` nunca zera. Some 1 a `revisao.total` em cada revisão executada, a 1 de `duvida_tecnica.total` em cada dúvida respondida e, a `testes.total`, a linha `Tentativas de teste` de cada relatório.

## Tarefa em paralelo
Antes de um novo discover, rode `.claude/scripts/state.sh list`. Se houver tarefa em andamento, sugira ao PO um worktree para a nova, porque a primeira segue na branch atual deste checkout.
