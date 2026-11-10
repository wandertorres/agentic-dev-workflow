# Índice de documentos

**Derivado:** vem do código, e o `sync-docs` pode escrever. **Decidido:** vem de pessoas, e só entra por nota de decisão (skill `record-decision`).

A coluna "Caminhos cobertos" é lida pelo `.claude/skills/sync-docs/scripts/docs-impact.sh`: uma mudança num desses caminhos dispara o `sync-docs`. Mantenha o formato da tabela.

| Documento | Tipo | Caminhos cobertos |
|---|---|---|
| `docs/orchestration.md` | Derivado | `.claude/agents/` `.claude/skills/` `CLAUDE.md` |

<!-- ajuste: inclua os documentos do seu projeto na tabela acima. Exemplos (sem o recuo):
    | `docs/project-context.md` | Decidido | |
    | `docs/architecture.md` | Derivado | `src/` |
-->
