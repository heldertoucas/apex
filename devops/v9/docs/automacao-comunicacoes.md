# SGUF v9 — Implementação Completa do Schema

## Contexto
A BD Oracle (ADB Amsterdam, Oracle 23c) está **vazia** — apenas existe a tabela interna do MCP.
Todos os scripts são implementação de raiz (não migração). Tudo vai para `devops/v9/`.

## Goal
Criar o schema completo SGUF v9 na BD Oracle, incluindo o subsistema de automação de comunicações (lacuna identificada no gap analysis vs Microsoft Lists).

---

## Tasks

### Fase 1 — Fundações (Lookups + Entidades Base)
- [ ] **T1:** Criar `01_lookup_tables.sql` e executar — Programas, Tipos_* (Genero, Qualificacao, Situacao_Prof, Doc_Identificacao, Estado_Turma, Estado_Matricula, Estado_Presenca com CV, Nivel_Experiencia, Equipamento, Plano_DDF, Documento_Dossier, Notificacao, Area_Competencia, Nivel_Proficiencia, Estado_Curso)  
  → Verificar: `SELECT COUNT(*) FROM user_tables WHERE table_name LIKE 'TIPOS_%'` retorna ≥ 14

- [ ] **T2:** Criar `02_core_catalog.sql` e executar — Programas, Cursos, Modulos, Catalogo_Competencias, Catalogo_Medalhas + tabelas M:N (Modulo_Competencias, Competencia_Medalhas)  
  → Verificar: Tabelas `CURSOS`, `MODULOS`, `CATALOGO_COMPETENCIAS` existem com colunas corretas

### Fase 2 — Pessoas e Operação Formativa
- [ ] **T3:** Criar `03_people.sql` e executar — Entidades (com campo `Aceita_Newsletter`), Papeis_Entidade, Locais, Listas_Mailing, Entidade_Listas  
  → Verificar: `DESC ENTIDADES` mostra colunas `EMAIL`, `CONSENTIMENTO_RGPD`, `ACEITA_NEWSLETTER`

- [ ] **T4:** Criar `04_ops_formativa.sql` e executar — Turmas, Equipa_Formativa, Turma_Medalhas_Elegiveis, Inscricoes, Matriculas (com `Codigo_Matricula`), Sessoes, Presencas  
  → Verificar: `DESC MATRICULAS` mostra `CODIGO_MATRICULA`; tabela `PRESENCAS` existe

- [ ] **T5:** Criar trigger `TRG_MATRICULAS_CODIGO` (dentro de `04_ops_formativa.sql`) que gera `INSCXXXX` automaticamente após insert  
  → Verificar: Inserir registo de teste em `MATRICULAS` → `CODIGO_MATRICULA` preenchido com `INSC0001`

### Fase 3 — Avaliação e Administração
- [ ] **T6:** Criar `05_eval_admin.sql` e executar — Avaliacoes_Modulo, Badges_Conquistados, Staging_Importacao, Itens_Dossier_Turma, Faturas_Formadores, Equipamentos_Alocados  
  → Verificar: `SELECT COUNT(*) FROM user_tables` retorna ~30+ tabelas

### Fase 4 — Sistema de Comunicação (Nova funcionalidade v9)
- [ ] **T7:** Criar `06_comunicacao.sql` e executar — Modelos_Comunicacao, Log_Comunicacoes, **Regras_Comunicacao** (nova), seed data com 3 regras base  
  → Verificar: `SELECT COUNT(*) FROM REGRAS_COMUNICACAO` retorna 3

- [ ] **T8:** Criar `07_pkg_comunicacao.sql` e executar — PKG_COMUNICACAO (Get_Modelo_Id, Processar_Template, Agendar_Email, Processar_Fila)  
  → Verificar: `SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_COMUNICACAO'` retorna `VALID`

- [ ] **T9:** Criar `08_pkg_matriculas.sql` e executar — PKG_MATRICULAS com `Criar_Presencas_Auto` que insere registos em `PRESENCAS` (estado CV) para todas as sessões da turma  
  → Verificar: `SELECT STATUS FROM USER_OBJECTS WHERE OBJECT_NAME='PKG_MATRICULAS'` retorna `VALID`

### Fase 5 — Documentação e Verificação Final
- [ ] **T10:** Executar query de auditoria final e confirmar todas as tabelas e packages  
  → Verificar: `SELECT object_name, object_type, status FROM user_objects ORDER BY object_type, object_name` — todos `VALID`

- [ ] **T11:** Criar `modelodedados9.md` em `devops/v9/` — cópia do v8 atualizada com campos novos (`Aceita_Newsletter`, `Codigo_Matricula`, tabela `Regras_Comunicacao`)

## Done When
- [ ] ~30 tabelas criadas na BD Oracle (confirmar com `SELECT COUNT(*) FROM user_tables`)
- [ ] 2 packages (`PKG_COMUNICACAO`, `PKG_MATRICULAS`) com status `VALID`
- [ ] Tabela `REGRAS_COMUNICACAO` criada com seed data
- [ ] `modelodedados9.md` documenta o schema completo

## Notes
- Executar scripts na BD via MCP Oracle (`mcp_oracle-database_run-sql`)
- Cada script é idempotente: usar `CREATE OR REPLACE` para packages e triggers; para tabelas verificar antes se existe
- Conexão ativa: **ADMIN_MCP** (Oracle 23c ADB, eu-amsterdam-1)
- Ficheiros em: `devops/v9/`
