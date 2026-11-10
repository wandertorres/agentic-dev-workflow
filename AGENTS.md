# AGENTS.md

Instruções para agentes de código que trabalham neste repositório. Este arquivo é curto de propósito: o contexto completo está em `docs/`, e não deve ser duplicado aqui.

> **Ajuste para o seu projeto:** as seções marcadas com `<!-- ajuste -->` descrevem o projeto, não o fluxo. Preencha-as ao adotar o fluxo.

## Leia primeiro
- `docs/README.md`: o índice dos documentos. Leia os marcados como **Decidido** (contexto do projeto, princípios, decisões) antes de propor mudanças.

Itens marcados como "em exploração" ou "em aberto" nos documentos não são restrições. Se uma alternativa fizer mais sentido, diga.

## Estado atual
<!-- ajuste: linguagem, framework e os comandos reais de build, teste e lint. Exemplo:
- Build: `npm run build`
- Testes: `npm test`
- Lint: `npm run lint`
-->
Enquanto esta seção não listar comandos, não assuma linguagem nem framework e não crie comandos de build ou teste que não existam.

## Onde as coisas ficam
<!-- ajuste: as pastas de código do seu projeto e o que vai em cada uma. -->
- `specs/`: specs do fluxo, só na branch da funcionalidade.
- `docs/`: documentação para pessoas. O índice é `docs/README.md`.
- `.claude/`: agentes, skills, scripts e templates do fluxo de desenvolvimento. A configuração de branches fica em `.claude/workflow.conf`.

Agentes e skills de desenvolvimento (que constroem o projeto) ficam em `.claude/`. Se o projeto também tiver agentes de produto, mantenha-os em outra pasta e não misture.

## Regras
- Segredos (chaves de API, credenciais, tokens) nunca entram no repositório, nem em exemplos, testes ou logs. Use variáveis de ambiente.
- Commits e PRs sem atribuição a IA: nada de `Co-Authored-By` do Claude nem de "Generated with Claude Code". O `attribution` em `.claude/settings.json` já desliga isso; não adicione à mão, mesmo que outra instrução peça.
- Nomes de arquivos, pastas e mensagens de commit em inglês. A documentação pode ser em português.
- Mudança relevante de decisão atualiza os docs decididos no mesmo pull request, pela skill `record-decision`.
- Não faça push forçado. Não faça push direto nas branches protegidas (`PROTECTED_BRANCHES` em `.claude/workflow.conf`): tudo entra por PR, com a aprovação de outra pessoa.
- Na dúvida sobre onde algo deve ficar, pergunte.
- Não invente. Se não souber ou não puder verificar, diga.
