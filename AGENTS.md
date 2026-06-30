# Project Instructions: apex

## Product Vision
Oracle APEX implementation for Passaporte Competencias
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


> Note: Memory Protocol and Global Rules are inherited from the global AGENTS.md.

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

When the user types `/graphify`, invoke the `skill` tool with `skill: "graphify"` before doing anything else.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- Dirty graphify-out/ files are expected after hooks or incremental updates; dirty graph files are not a reason to skip graphify. Only skip graphify if the task is about stale or incorrect graph output, or the user explicitly says not to use it.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).
