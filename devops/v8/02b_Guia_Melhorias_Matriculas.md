# Guia: Melhorias na Gestão de Matrículas (V8)

**Objetivo:** Resolver as dificuldades de coordenação na gestão de matrículas.
**Problema Identificado:** O utilizador atual gere matrículas "às cegas", sem ver detalhes críticos (localidade, profissão) e sem uma visão global de quem está inscrito onde.

---

## Parte A: Análise e Estratégia (Critical UX Review)

Como especialista em Apex, identifico duas falhas críticas na implementação anterior:
1.  **Visibilidade Limitada:** A página de "Matrículas em Massa" usa uma Shuttle ou Checkbox list simples que mostra apenas o nome. Em processos de seleção, o coordenador precisa de saber *Localidade* (para turmas presenciais), *Profissão* (para elegibilidade), ou *Data de Candidatura* (para priorizar FIFO).
2.  **Fragmentação:** Não existe um "cockpit" onde se possa responder: "Quem são todos os alunos matriculados este mês?". O utilizador é forçado a entrar turma a turma.

**Solução Proposta:**
1.  **Global Enrollment View:** Um relatório centralizado para pesquisa transversal.
2.  **Smart Candidate List:** Enriquecimento do relatório de seleção de candidatos com colunas de suporte à decisão.

---

## Parte B: Implementação Passo a Passo

### Passo 1: Visão Global de Matrículas (Cockpit)

Vamos criar uma página que centraliza tudo.

1.  **Create Page:**
    *   **Type:** `Interactive Report`.
    *   **Page Name:** `Visão Global de Matrículas`.
    *   **Page Number:** (Sugestão: 45).
    *   **Navigation:** Menu "Gestão Formativa".
2.  **Source SQL Query:**
    Use esta query que junta as peças essenciais:
    ```sql
    SELECT 
        m.ID_Matricula,
        t.Codigo_Turma,
        c.Nome as Curso,
        e.Nome_Completo as Aluno,
        e.Email,
        e.Localidade,             -- Ajuda a filtrar por zona
        e.Nivel_Experiencia,      -- Ajuda a homogeneizar turmas
        m.Data_Inscricao,
        m.Estado_Matricula,       -- PENDENTE, CONFIRMADO, ETC
        CASE 
            WHEN m.Estado_Matricula = 'CONFIRMADO' THEN 'badge-success'
            WHEN m.Estado_Matricula = 'PENDENTE' THEN 'badge-warning'
            ELSE 'badge-danger'
        END as Estado_Class       -- Para colorir a coluna depois
    FROM Matriculas m
    JOIN Turmas t ON m.ID_Turma = t.ID_Turma
    JOIN Cursos c ON t.ID_Curso = c.ID_Curso
    JOIN Entidades e ON m.ID_Entidade = e.ID_Entidade
    ```
3.  **Configurar Colunas (Report Attributes):**
    *   **Estado_Matricula:** Use **HTML Expression** para colorir: `<span class="t-Badge #ESTADO_CLASS#">#ESTADO_MATRICULA#</span>`.
    *   **Aluno:** Transforme em **Link** para a ficha do aluno (Modal).
    *   **Turma:** Transforme em **Link** para a gestão da turma.

---

### Passo 2: Melhorar o Wizard de "Matrículas em Massa"

Vamos enriquecer a lista de candidatos que aparece quando selecionamos uma turma para encher.

1.  **Aceda à Página:** Vá à página existente de "Matrículas em Massa" (Provavelmente Pag 50 ou similar).
2.  **Localize a Região de Candidatos:** Deve ser um *Classic Report* ou *Interactive Grid* do lado esquerdo (Candidatos Disponíveis).
3.  **Atualizar a Query:**
    Atualmente deve ser algo simples como `SELECT Nome FROM Entidades`. Mude para algo rico:
    ```sql
    SELECT 
        e.ID_Entidade,
        e.Nome_Completo,
        e.Localidade,
        e.Profissao,
        trunc(sysdate - i.Data_Interesse) as Dias_Espera, -- FIFO Priority
        i.Data_Interesse as Data_Candidatura -- Renomeado de Data_Registo
    FROM Entidades e
    JOIN Inscricoes i ON i.ID_Entidade = e.ID_Entidade
    WHERE i.ID_Curso = :P50_CURSO_ID -- Filtra pelo curso da turma selecionada
      AND NOT EXISTS (SELECT 1 FROM Matriculas m WHERE m.ID_Entidade = e.ID_Entidade AND m.ID_Turma = :P50_TURMA_ID)
    ORDER BY i.Data_Interesse ASC -- Os mais antigos primeiro!
    ```
4.  **Layout (Columns):**
    *   Mostre as colunas `Dias_Espera` e `Localidade`.
    *   Isto permite ao coordenador dizer: *"Vou selecionar estes 5 de Lisboa que estão à espera há 20 dias".*

---

### Passo 3: Filtros de Apoio (Facets)

Se a página for um Interactive Report, ative a **Search Bar** mas também considere **Faceted Search** se tiver muitos candidatos.

*   **Filtros recomendados:**
    *   Localidade (Checkbox group).
    *   Profissão (Dropdown).
    *   Tem Computador? (Se houver esse dado no perfil).

---

**Resultado Final:**
O utilizador deixa de selecionar nomes numa lista cega e passa a gerir uma fila de espera priorizada e informada.
