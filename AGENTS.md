# Project Instructions: apex

## Memory Protocol

Every session must begin by loading the Obsidian context and end by saving
it back. This is how the AI preserves its memory across sessions.

- **Start Session**: Use skill `obsidian-sync` with `oc-start apex`.
  The script prints the `hot.md` cache (open loops, blockers, last decisions)
  from the Obsidian vault and syncs the repo. After it returns, review the
  printed state to brief the user on what was in progress. Never begin coding
  before this context restoration completes.

- **End Session**: Use skill `obsidian-sync` with `oc-close apex`.
  This reviews git changes (`git diff --stat`), writes a session log to
  Obsidian at `03-projetos/apex/sessoes/YYYY-MM-DD-session.md`,
  and refreshes `hot.md` with the new project state. Skipping this loses
  context between sessions.

## Vault Context

This project's knowledge lives in the Obsidian Second Brain. Before making
design or architectural decisions, consult the vault to avoid re-litigating
past choices.

- **Project Folder**: `03-projetos/apex/` — contains session logs, product
  vision specs, and architectural decisions. Search this folder with semantic
  queries (RAG) before designing new features. It is the project's
  institutional memory.

- **Hot Cache**: `03-projetos/apex/hot.md` — the living snapshot of current
  state: open loops, active blockers, next tasks. Read this first at session
  start. Update it at session end. It bridges the gap between the detailed
  session logs and what the AI needs to resume work immediately.

- **Product Vision**: Oracle APEX implementation for Passaporte Competencias
  Digitais (SGUF v9) — infrastructure and deployment configurations.

## Tech Stack
- **Platform**: Oracle APEX (Application Express)
- **Infrastructure**: DevOps configurations in `devops/` directory
- **Versions**: Multiple SGUF versions tracked (v4, v5-6, v7, v8, v9)
- **Documentation**: Oracle APEX App Builder Users Guide (PDF reference)

## Architecture
- **Structure**: DevOps-focused repository with version-specific configurations
- **Key Directories**: `devops/v4/` through `devops/v9/` (version-specific configs), `conductor/` (project management)
- **Key Pattern**: Version-based deployment pipeline for Oracle APEX applications
- **Current Focus**: SGUF v9 implementation

## Build & Run Commands
- **No standard build**: Oracle APEX is managed via web interface and SQL scripts
- **Deployment**: Follow version-specific procedures in `devops/v9/`

## Code Standards
- **SQL Scripts**: Follow Oracle APEX naming conventions
- **Version Control**: Track all SQL and configuration changes in Git
- **Documentation**: Keep `conductor/plan.md` updated with implementation progress

## Quality Gates
- **Oracle APEX Testing**: Verify application functionality in APEX builder
- **Version Tracking**: Ensure all changes are tagged with the correct SGUF version
- **Documentation**: Maintain conductor plan with checklist progress
