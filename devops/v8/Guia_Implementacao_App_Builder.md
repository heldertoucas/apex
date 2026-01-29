# Guia Mestre de Implementação: Academia Digital (SGUF v7.0)

**Versão:** 2.0 (V8 Update)
**Data:** 26 de Janeiro de 2026  
**Contexto:** Construção de raiz da aplicação central de gestão formativa usando Oracle APEX.  
**Público-Alvo:** Desenvolvedores e Implementadores (Nível Júnior a Sénior).  
**Modelo de Dados:** v8.0 (Includes Communication & Staging).

---

## 1. Introdução e Metodologia
Este documento serve como o índice mestre para a construção da aplicação "Academia Digital". 
**Importante:** Este guia define a *estrutura* e o *que* deve ser feito. Cada Capítulo, Etapa e Tarefa listada abaixo terá o seu próprio "Guia Passo-a-Passo" individual detalhado posteriormente.

O desenvolvimento segue uma lógica **"Data-First"**: primeiro constrói-se a estrutura de dados sólida, depois as interfaces de gestão (Backoffice) e finalmente os fluxos de utilizador (Frontoffice).

---

## Capítulo 1: Fundação do Sistema
**Objetivo:** Preparar o ambiente no Oracle APEX, criar a aplicação esqueleto e implementar o domínio de dados estáticos (Lookups).

### Etapa 1.1: Inicialização do Ambiente
*   **Tarefa 1.1.1:** Aceder e configurar o Workspace APEX (Timezone, Language).
*   **Tarefa 1.1.2:** Criar a Aplicação "Academia Digital" (App ID sugerido: 100).
    *   *Definições:* Tema "Vita" (ou Redwood Light), Navegação Lateral, Autenticação APEX.
*   **Tarefa 1.1.3:** Configurar "Shared Components" iniciais (Lists of Values globais).

### Etapa 1.2: Implementação do Modelo de Dados (Domínio F - Lookups)
*   **Tarefa 1.2.1:** Criar e executar script SQL `01_Dominios.sql` para as tabelas de domínio (19 a 33 do Modelo v7).
    *   *Exemplos:* `Tipos_Genero`, `Tipos_Area_Competencia`, `Tipos_Estado_Matricula`.
*   **Tarefa 1.2.2:** Popular as tabelas de domínio com dados estáticos (Seed Data).
    *   *Ex:* Inserir 'M','F' em `Tipos_Genero`; 'Confirmada','Planeada' em `Tipos_Estado_Turma`.

---

## Capítulo 2: Gestão de Pessoas (Entidades)
**Objetivo:** Criar o repositório único de atores (Formandos, Formadores, Staff) que suportará todo o sistema.

### Etapa 2.1: Estrutura de Dados de Entidades
*   **Tarefa 2.1.1:** Criar e executar script SQL `02_Entidades.sql`.
*   **Tarefa 2.1.2:** Criar tabela `Entidades` com os novos campos v7 (`Profissao`, `Entidade_Empregadora`, `URL_CV`, etc.).
*   **Tarefa 2.1.3:** Criar tabela `Papeis_Entidade` para gestão de perfis múltiplos.

### Etapa 2.2: Módulo de Gestão de Entidades (UI)
*   **Tarefa 2.2.1:** Criar Página de Relatório Interativo "Diretório de Pessoas".
*   **Tarefa 2.2.2:** Criar Página de Formulário "Ficha de Entidade".
    *   *Requisito:* Organizar campos em regiões lógicas (Pessoal, Profissional, Contactos).
    *   *Requisito:* Implementar validação de NIF e Email únicos.
*   **Tarefa 2.2.3:** Criar Grid de "Papéis" dentro da Ficha de Entidade (Master-Detail).

### Etapa 2.3: Listas de Mailing (Bónus)
*   **Tarefa 2.3.1:** Executar script `02C_Mailing_Lists.sql`.
*   **Tarefa 2.3.2:** Implementar Checkbox Group "Listas de Distribuição" na Ficha de Entidade.
    *   *Lógica:* Usar processo PL/SQL para gravar seleção múltipla (ver `Guia_Capitulo_02C_Mailing_Lists.md`).

---

## Capítulo 3: Catálogo Formativo
**Objetivo:** Implementar a estrutura hierárquica da oferta formativa (Programa > Curso > Módulo).

### Etapa 3.1: Estrutura de Dados do Catálogo
*   **Tarefa 3.1.1:** Criar e executar script SQL `03_Catalogo.sql`.
*   **Tarefa 3.1.2:** Tabelas: `Programas`, `Cursos`, `Modulos`, `Competencias`.

### Etapa 3.2: Backoffice do Catálogo
*   **Tarefa 3.2.1:** Criar Interface de Gestão de Programas (CRUD Simples).
*   **Tarefa 3.2.2:** Criar Interface de Gestão de Cursos (Master-Detail com Módulos).
    *   *Módulos UI:* Implementar Interactive Grid (Editable) com lógica Mestre-Detalhe (FK `ID_Curso`).
    *   *Competências UI:* Implementar Modal CRUD (Grelha) para associar competências ao módulo (com flag `Obrigatório`).
*   **Tarefa 3.2.3:** Criar Interface de Gestão de Medalhas (M:N).
    *   *Global:* Página IG para criar Open Badges (`Catalogo_Medalhas`) com `URL_Claim_Badge`.
    *   *Associação:* Modal CRUD para ligar Medalhas a Competências (`Competencia_Medalhas`).

---

## Capítulo 4: Planeamento e Logística (Ops)
**Objetivo:** Transformar cursos abstratos em turmas concretas no tempo e espaço.

### Etapa 4.1: Estrutura de Operações
*   **Tarefa 4.1.1:** Criar e executar script SQL `04_Operacoes.sql`.
*   **Tarefa 4.1.2:** Tabelas: `Locais` (Locais), `Turmas` (Turmas), `Equipa_Formativa` (Equipa), `Sessoes` (Cronograma).

### Etapa 4.2: Gestão de Planeamento
*   **Tarefa 4.2.1:** Criar Formulário "Planeamento de Turma".
    *   *Funcionalidade:* Definição de datas, horário descritivo e coordenador.
*   **Tarefa 4.2.2:** Criar Funcionalidade "Gerar Cronograma".
    *   *Lógica:* Processo (PL/SQL) que gera automaticamente sessões (ver código em `04_Automacao_Cronograma.sql`).
*   **Tarefa 4.2.3:** Criar Calendário Visual (Calendar Region) para visualização de ocupação de salas.

---

## Capítulo 5: Fluxo de Inscrição e Matrícula
**Objetivo:** Gerir a entrada de alunos, pré-inscrições e a matrícuça efetiva em turmas.

### Etapa 5.1: Estrutura de Matrículas
*   **Tarefa 5.1.1:** Criar e executar script SQL `05_Matriculas.sql`.
*   **Tarefa 5.1.2:** Tabela `Matriculas` (Matrículas).
    *   *Nota:* Incluir campo CLOB `Diagnostico_Respostas` para armazenar o JSON do diagnóstico inicial.

### Etapa 5.2: Gestão de Matrículas em Massa (Bulk Enrollment)
**Contexto:** O utilizador (Técnico) precisa de "povoar" uma turma rapidamente selecionando candidatos de uma bolsa de interessados.

*   **Tarefa 5.2.1:** Criar Página "Gestão de Inscritos na Turma".
    *   *Input:* Select List para escolher a Turma (Ação de Formação) e Curso.
*   **Tarefa 5.2.2:** Criar Região 1: "Alunos Matriculados".
    *   *Display:* Interactive Grid/Report mostrando quem já está na turma (`Matriculas` onde `ID_Turma = :P_TURMA`).
*   **Tarefa 5.2.3:** Criar Região 2: "Candidatos Disponíveis".
    *   *Display:* Interactive Report com Checkboxes de seleção.
    *   *Query:* Selecionar Entidades que mostraram interesse no Curso (Pré-inscrição) mas **NÃO** estão matriculados nesta Turma específica.
*   **Tarefa 5.2.4:** Criar Processo "Matricular Selecionados".
    *   *Lógica:* Ao submeter, iterar pelos IDs selecionados na Região 2 e inserir registos em `Matriculas` para a Turma atual.

---

## Capítulo 6: Execução Pedagógica (Sala de Aula)
**Objetivo:** Ferramentas para o dia-a-dia do Formador e avaliação.

### Etapa 6.1: Estrutura Pedagógica
*   **Tarefa 6.1.1:** Criar e executar script SQL `06_Pedagogia.sql`.
*   **Tarefa 6.1.2:** Tabelas: `Presencas` (Assiduidade), `Avaliacoes_Modulo` (Notas), `Badges_Conquistados` (Badges).

### Etapa 6.2: O Portal do Formador
*   **Tarefa 6.2.1:** Criar Dashboard simples "Minhas Turmas" (filtrado pelo utilizador logado).
*   **Tarefa 6.2.2:** Criar Página "Sessões".
    *   *Funcionalidade:* Botão "Gerar Lista" (PL/SQL) que importa alunos matriculados para a sessão.
    *   *Funcionalidade:* Interactive Grid para marcar assiduidade.
*   **Tarefa 6.2.3:** Criar Página "Pauta da Turma" (Avaliação Modular).
    *   *Funcionalidade:* Grelha de notas por Módulo/Aluno com Feedback qualitativo.
*   **Tarefa 6.2.4:** Criar Página "Gestão de Medalhas da Turma".
    *   *Funcionalidade:* Interface de Fecho de Turma onde o formador seleciona as medalhas elegíveis (leitura de `Competencias` -> escrita em `Turma_Medalhas_Elegiveis`).

---

## Capítulo 7: Administração e Conformidade
**Objetivo:** Garantir os requisitos documentais, financeiros e de reporte (SIGO).

### Etapa 7.1: Estrutura Administrativa
*   **Tarefa 7.1.1:** Criar e executar script SQL `07_Admin.sql`.
*   **Tarefa 7.1.2:** Tabelas: `Faturas_Formadores` (Faturas), `Itens_Dossier_Turma` (Documentos), `Equipamentos_Alocados` (Inventário).

### Etapa 7.2: Gestão Financeira e Documental
*   **Tarefa 7.2.1:** Criar Página "Controlo de Faturação".
    *   *Requisito:* Permitir registo de Nº Fatura, Data Emissão, Data Contabilística e Data Pagamento.
*   **Tarefa 7.2.1:** Criar Página "Controlo de Faturação".
*   **Tarefa 7.2.2:** Criar Página "Dossier Técnico-Pedagógico".
    *   *Visual:* Lista de verificação com semáforos (Verde=Entregue, Vermelho=Em Falta) para os documentos obrigatórios da turma (Sumários, Pautas, Inquéritos).

### Etapa 7.3: Exportação SIGO
*   **Tarefa 7.3.1:** Criar Relatório de Exportação.
    *   *Query:* Construir query complexa que junte dados da Turma, Formando e Matrícula no formato exigido pelo SIGO (conforme `documentos.md`).
    *   *Output:* Botão de Download CSV/Excel.

---

## Capítulo 8: UX, Dashboards e Polimento Final
**Objetivo:** Tornar a aplicação profissional, intuitiva e visualmente apelativa.

### Etapa 8.1: Estrutura de Navegação
*   **Tarefa 8.1.1:** Reorganizar Menu e Breadcrumbs.
*   **Tarefa 8.1.2:** Implementar ícones consistentes para cada módulo.

### Etapa 8.2: Dashboard 360º (Landing Page)
*   **Tarefa 8.2.1:** Implementar Cards de KPI (Turmas Ativas, Alunos Inscritos, Faturas Pendentes).
*   **Tarefa 8.2.2:** Implementar Gráficos de Evolução (Inscrições por Mês).

### Etapa 8.3: Segurança e Acessos
*   **Tarefa 8.3.1:** Configurar Esquemas de Autorização (Admin vs Formador vs Técnico).
*   **Tarefa 8.3.2:** Aplicar restrições de menu e página baseadas nos papéis.

---

## Anexo: Log de Execução e Planeamento
*Estado do Projeto em 22 de Janeiro de 2026*

### ✅ Fases Concluídas (Fundação, Catálogo & Logística)
1.  **Modelo de Dados v7:** Unified Schema implementado e validado.
2.  **Capítulo 1 (Fundação):** Tabelas de Domínio e Aplicação Base criadas.
3.  **Capítulo 2 (Pessoas):** Gestão de Entidades Refatorada e Mailing Lists implementadas.
4.  **Capítulo 3 (Catálogo):**
    *   Refatorização M:N (Competências e Medalhas) completa.
    *   Implementação de Grelhas CRUD Mestre-Detalhe (Módulos).
    *   Criação do Banco de Medalhas Global.
5.  **Capítulo 4 (Logística):**
    *   Schema `04_Operacoes.sql` (Turmas/Sessões) criado e validado.
    *   Automação PL/SQL de Cronograma implementada.
    *   Dados de Teste `04_DummyData_Logistica.sql` criados.
6.  **Capítulo 5 (Inscrição):**
    *   **Arquitetura:** Separação entre Interesse (`Inscricoes`) e Matrícula efetiva (`Matriculas`).
    *   **Lógica de Negócio:** Sistema de Prioridades (Turma > Curso > Geral).
    *   **Funcionalidade:** Página "Bulk Enrollment" com listagens inteligentes e ações em massa.
    *   **Segurança:** Filtro automático que esconde contas de Staff/Admin das listas de matrícula.
    *   **Dados:** Script de teste `05_DummyData_Inscricao.sql` com cenários de prioridade.

### 📅 Próximos Passos (Pedagogia & Certificação)
1.  **Capítulo 6 (Pedagogia):** Interfaces do Formador (Sessões, Pauta de Notas e Atribuição de Medalhas).
2.  **Capítulo 7 (Admin):** Validação de Dossier Técnico-Pedagógico.

### 📝 Notas de Validação
*   Confirmada a flexibilidade da arquitetura "Inscrição vs Matrícula" para gerir preferências de turma vs curso.

---

## Capítulo 9: Comunicação e Notificações (V8)
**Objetivo:** Implementar sistema de templates de email (com suporte a *overrides* por curso) e automatizar o ciclo de vida.

### Etapa 9.1: Estrutura de Comunicação
*   **Tarefa 9.1.1:** Criar e executar script SQL `08_Comunicacao.sql`.
*   **Tarefa 9.1.2:** Tabelas: `Modelos_Comunicacao` (Templates), `Log_Comunicacoes` (Fila).
*   **Tarefa 9.1.3:** PL/SQL: Pacote `PKG_COMUNICACAO` com lógica de *placeholders* e fila.

### Etapa 9.2: Gestão de Templates e Envio
*   **Tarefa 9.2.1:** Criar Página "Modelos de Comunicação" (Admin).
    *   *Funcionalidade:* Editor Rich Text para templates HTML. Suporte a hierarquia (Global vs Curso).
*   **Tarefa 9.2.2:** Criar Wizard "Notificar Turma".
    *   *Funcionalidade:* Selecionar Template -> Agendar Data -> Escolher Alunos -> Enviar.

### Etapa 9.3: Automação
*   **Tarefa 9.3.1:** Configurar Automation "Processar Fila" (15 em 15 mins).
*   **Guia Detalhado:** Ver `01_Guia_Implementacao_Comunicacao.md`.

---

## Capítulo 10: Melhorias de UX e Feedback (V8)
**Objetivo:** Refinamento da aplicação com base no feedback de testes (Jan 2026).

### Etapa 10.1: Polimento de Interfaces
*   **Tarefa 10.1.1:** Implementar páginas para gestão de Domínios (Lookups).
*   **Tarefa 10.1.2:** Melhorar Dashboard do Formador (Links 'Abrir', Remover Sort default).
*   **Tarefa 10.1.3:** Reestruturar página de Sessões (Header, Switch Presença, Auto-cálculo horas).

### Etapa 10.2: Novas Funcionalidades
*   **Tarefa 10.2.1:** Gestão Global de Matrículas (Report Consolidado).
*   **Tarefa 10.2.2:** Automação de Faturação (Gerar Rascunhos).
*   **Tarefa 10.2.3:** Checklist Visual para Dossier Técnico-Pedagógico.
*   **Guia Detalhado:** Ver `02_Guia_Melhorias_Feedback.md`.

---

## Capítulo 11: Importação e Tratamento de Dados (Import V8)
**Objetivo:** Mecanismo robusto para carregar Excel de candidaturas com validação prévia ("Staging").

### Etapa 11.1: Estrutura de Staging
*   **Tarefa 11.1.1:** Criar e executar script SQL `08_Staging.sql`.
*   **Tarefa 11.1.2:** Tabela `Staging_Importacao` e Package `PKG_IMPORTACAO` (Validação de emails, cursos, criação de datas default).
*   **Tarefa 11.1.3:** Suporte a campo `Diagnostico_Respostas` (JSON).

### Etapa 11.2: Interface de Importação
*   **Tarefa 11.2.1:** Configurar "Data Load Definition" (Mapeamento CSV > Tabela).
*   **Tarefa 11.2.2:** Criar Wizard de Upload.
*   **Tarefa 11.2.3:** Criar "Cockpit de Validação" (Interactive Grid Editável) para corrigir erros (Curso inexistente, etc.) antes de processar.
*   **Guia Detalhado:** Ver `03_Guia_Implementacao_Importacao.md`.

---

## Anexo: Log de Execução e Planeamento
*Estado do Projeto em 29 de Janeiro de 2026 (Fase V8)*

### ✅ Fases Concluídas (Core V7 & Design V8)
1.  **Fundação V7:** Modelo de dados Base, Catálogo e Logística operacionais.
2.  **Inscrição V7:** Fluxo de Candidatura vs Matrícula implementado.
3.  **Design V8 (Planeamento & Arquitetura):**
    *   **Comunicação:** Modelo de dados (`08_Comunicacao.sql`) e estratégia de Overrides desenhada.
    *   **Importação:** Estratégia "Staging Table" desenhada, SQL (`08_Staging.sql`) criado e workflow de correção de erros definido.
    *   **UX Domínios:** Refatorização para "Seletor Dinâmico" planeada.
    *   **UX Matrículas:** Design da "Visão Global" e melhorias no Bulk Enrollment.

### 🚧 Em Curso / Próximos Passos (Implementação APEX V8)
1.  **Importação de Dados (Prioritário):**
    *   Executar `08_Staging.sql`.
    *   Criar Data Load Definition e Páginas no APEX (Seguir Guia 03).
    *   Testar com `sample_import.csv`.
2.  **Comunicação:**
    *   Implementar páginas de Templates e Envio de Email (Seguir Guia 08/01).
3.  **Melhorias UX:**
    *   Implementar gestão de Domínios e Dashboards melhorados.

### 📝 Notas de Validação
*   Confirmada a necessidade de tratamento de erros no upload (ex: cursos mal escritos no Excel). A solução "Staging" resolve isto.
*   Incluído campo de Diagnóstico no import para não perder dados dos questionários.
