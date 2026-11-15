---
root: true
targets: ["*"]
description: "Project overview, sandbox conventions, and standards for apex (PRJ-0014 / REP-0015)"
globs: ["**/*"]
---

# Project Instructions: apex (PRJ-0014 / REP-0015)

## Product Vision
Workspace pessoal de desenvolvimento rápido, pesquisa técnica e experimentação de ferramentas e agentes do ecossistema Development Universe.

## DU Context & Pointers
- **Project Dossier**: `02-projects/PRJ-0014/project.md`
- **Repository Identity**: `REP-0015` (Role: standalone)
- **Memory & Planning**: Contexto gerido pelo DU Context Engine; propostas sob `openspec/changes/`.

## Tech Stack
- **Languages**: Python >= 3.10, Node.js >= 20, Bash / PowerShell
- **Tooling**: Graphify local research, Claude Code, Antigravity, OpenCode
- **Dependencies**: Scripts Python ad-hoc e pipelines experimentais

## Architecture
- **Structure**: Sandbox experimental de engenharia.
- **Key Directories**:
  - `devops/`: Scripts e manifestos de infraestrutura e deployment local.
  - `archive/`: Experiências e protótipos descontinuados ou concluídos.
  - `graphify-out/`: Extrações temporárias de grafos de dependências.

## Verification & Workflow Commands
- **Python Scripts**: `python <script.py>`
- **Node Tools**: `node <script.js>`
- **Clean Scratch**: `rm -rf graphify-scratch/`

## Quality Gates & Invariants
- **Isolamento de Produção**: Protótipos em `apex` não devem aceder diretamente a bases de dados ou vaults de produção sem salvaguardas explícitas.
- **Zero Secrets**: Nenhuma chave de API ou token em commits; utilizar `.env`.
