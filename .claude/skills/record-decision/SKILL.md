---
name: record-decision
description: Registra uma decisão no repositório a partir de uma nota de decisão, trazida pelo PO (por exemplo, de uma conversa fora do repositório) ou aprovada por ele depois do sync-docs. Use só com a nota em mãos e a pedido do PO.
effort: medium
---

A nota traz decisão, motivo, alternativas descartadas, o que faria mudar de ideia e impacto na documentação. Se faltar decisão ou motivo, pergunte em vez de inventar.

1. Grave a nota em `docs/decisions/<AAAA-MM-DD>-<slug>.md`. Se a pasta não estiver no índice, inclua-a em `docs/README.md`, como doc decidido.
2. Atualize as docs afetadas, em especial as marcadas como Decidido em `docs/README.md`. Mude só o que a nota decide.
3. Commite na branch atual, nunca numa branch protegida (`PROTECTED_BRANCHES` em `.claude/workflow.conf`), com `git add` de caminhos explícitos e `git commit -m "..."` sozinho na chamada. Não faça push. Se estiver numa branch protegida, crie antes a branch `docs/<slug>`.

Retorno:
```
Estado: decisão registrada
Precisa de você: não
Nota: <caminho>
Docs atualizadas: uma linha cada
Lembrete: se um doc decidido tem cópia fora do repositório, atualizá-la
```
