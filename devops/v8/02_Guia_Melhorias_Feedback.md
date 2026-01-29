# Guia de Implementação: Melhorias de UX e Feedback (V8)

**Objetivo:** Implementar as correções e melhorias identificadas na ronda de testes de 26/Jan (ver `TODO_Feedback_V8.md`).
**Nível:** Intermédio
**Dependências:** V8 Initial Setup.

---

## 1. Administração e Configuração

### 1.1. Gestão de Tabelas de Domínio (Lookups)
**Problema:** Falta de interface para gerir "Tipos" (ex: Tipos de Equipamento, Tipos de Género).

1.  **Criar Nova Página:**
    *   **Type:** Interactive Grid.
    *   **Page Name:** `Gestão de Domínios`.
    *   **Table:** *Nota: Como são várias tabelas, o ideal é criar uma página mestre com Tabs ou Links para várias páginas modais.*
    *   **Alternativa Rápida:** Criar uma página para cada tabela crítica (`Tipos_Equipamento`, `Locais`, `Tipos_Area_Competencia`).
2.  **Configuração da Grid:**
    *   Ativar **Editing > Enabled**.
    *   Ativar **Add/Update/Delete**.

---

## 2. Gestão de Pessoas

### 2.1. O que é o Campo "Ativo"?
**Problema:** Utilizador não percebe o propósito.

1.  **Page Designer (Ficha de Entidade):**
    *   Selecione o item `Pxx_ATIVO`.
    *   **Help Text:** "Indica se a pessoa está disponível no sistema. Se desmarcar, a pessoa deixa de aparecer nas pesquisas de novas matrículas, mas o histórico é mantido."
    *   **Inline Help Text:** "Desmarque para arquivar esta pessoa."

### 2.2. Importação de Pessoas
**Requisito:** Reativar importação Excel.

1.  **Botão "Importar":**
    *   Na página "Diretório de Pessoas", adicione um botão `IMPORTAR` na Toolbar do Report.
    *   **Action:** Redirect to Page (Criar Página Nova).
2.  **Wizard de Importação (Data Loading Wizard):**
    *   **Create Page > Data Loading**.
    *   **Table:** `Entidades`.
    *   **Lookup mapping:** Mapear colunas de texto (ex: "Masculino") para IDs (`ID_Genero`) usando Lovs existentes.

---

## 3. Gestão de Turmas

### 3.1. Calendarização e "Gerar Cronograma"
**Problema:** Dúvidas no funcionamento e edição manual.

1.  **Clarificação UX:**
    *   Renomear botão `GERAR_CRONOGRAMA` para `Gerar Aulas Automáticas`.
    *   Adicionar **Confirm Message:** "Isto irá criar sessões para todas as 2ªs e 4ªs feiras entre a Data Início e Fim. Quer continuar?".
2.  **Edição Individual:**
    *   Na **Interactive Grid de Sessões** (dentro da Ficha de Turma):
        *   Certifique-se que `Data_Sessao`, `Hora_Inicio` e `Hora_Fim` são colunas editáveis (**Type:** Date Picker / Text).
        *   Ativar **Edit** na Grid.

### 3.2. Equipa Formativa (Múltiplos Formadores)
**Problema:** Restrição a um formador.

1.  **Implementação Mestre-Detalhe:**
    *   Na Ficha de Turma, garantir que a região "Formadores" é uma **Interactive Grid**.
    *   **Source:** Tabela `Equipa_Formativa`.
    *   **Parent Column:** `ID_Turma`.
    *   **LOV Formador:** Dropdown com `SELECT Nome_Completo d, ID_Entidade r FROM Entidades ...`.
    *   Isto permite adicionar N linhas (N formadores).

---

## 4. Matrículas

### 4.1. Melhoria do Relatório "Matrículas em Massa"
1.  **Campos de Interesse:**
    *   Na query do relatório "Candidatos Disponíveis", adicionar Joins para mostrar:
        *   `e.Localidade`, `e.Profissao`.
        *   Nível de Experiência (da tabela `Inscricoes` ou `Entidades`).
    *   Renomear coluna `Data_Registo` para `Data Candidatura`.

### 4.2. Gestão Global de Matrículas (NOVO)
1.  **Criar Página:**
    *   **Type:** Interactive Report.
    *   **Name:** `Visão Global de Matrículas`.
    *   **Query:**
        ```sql
        SELECT t.Codigo_Turma, c.Nome as Curso, e.Nome_Completo as Aluno,
               m.Estado_Matricula, m.Data_Inscricao
        FROM Matriculas m
        JOIN Turmas t ON m.ID_Turma = t.ID_Turma
        JOIN Cursos c ON t.ID_Curso = c.ID_Curso
        JOIN Entidades e ON m.ID_Entidade = e.ID_Entidade
        ```
    *   Adicionar Filtros no topo (Turma, Curso, Estado).

---

## 5. Portal do Formador

### 5.1. UX "Minhas Ações"
1.  **Link "Abrir":**
    *   Na coluna de Link (para detalhe da turma), mudar **Link Text** de `#CODIGO_TURMA#` para `<span class="fa fa-external-link" aria-hidden="true"></span> Abrir`.
    *   Ativar **Escape Special Characters: No**.
2.  **Ordenação:**
    *   Remover cláusula `ORDER BY` da query SQL do relatório. Deixar o utilizador ordenar clicando nos cabeçalhos.

---

## 6. Gestão de Aulas (Sessões)

### 6.1. Reestruturação da Página de Sessão
1.  **Cabeçalho:** Criar região "Detalhes da Sessão" (Static Content) com items Display Only (`P_DATA`, `P_HORARIO`).
2.  **Lista de Presenças (Interactive Grid):**
    *   **Source:** Tabela `Presencas`. Linkada por `ID_Sessao`.
    *   **Coluna `Presente`:** Type **Switch** (On Value: 'S', Off Value: 'N').
    *   **Dynamic Action (Change on P_PRESENTE):**
        *   *Opção A (Simples):* Set Value `P_HORAS` = `P_DURACAO_SESSAO` (Item escondido calculado).
        *   *Opção B (PL/SQL):* Calcular no lado do servidor ao gravar.
    *   **Botão "Gerar Lista de Participantes":**
        *   Criar botão que executa PL/SQL:
            ```sql
            INSERT INTO Presencas (ID_Sessao, ID_Matricula, ID_Estado_Presenca)
            SELECT :P_SESSION_ID, ID_Matricula, 1 -- (1=Pendente)
            FROM Matriculas WHERE ID_Turma = :P_TURMA_ID
            AND ID_Matricula NOT IN (SELECT ID_Matricula FROM Presencas WHERE ID_Sessao = :P_SESSION_ID);
            ```
        *   Adicionar **Help Text:** "Importa todos os alunos matriculados nesta turma para a pauta desta sessão."

---

## 7. Avaliação
1.  **Bug Refresh:**
    *   No item Select List `P_TURMA_ID`, mudar **Page Action on Selection** para `Submit Page`.
    *   Isso força o recarregamento da Grid de notas com a nova turma selecionada.

---

## 8. Gestão Financeira (Faturação)

### 8.1. UX: Grid Editável
1.  **Converter Página:**
    *   Mudar a região principal de "Classic Report" para **Interactive Grid**.
    *   Tabela: `Faturas_Formadores`.
    *   Tornar editáveis: `Valor`, `Data_Emissao`, `Data_Pagamento`, `Estado`.
2.  **Detalhes (Modal):**
    *   Configurar a coluna `Num_Fatura` como Link.
    *   Target: Página Modal existente (Detalhe Fatura) para upload de ficheiros.

### 8.2. Automação "Gerar Faturas"
1.  **Criar Botão "Gerar Rascunhos":**
    *   Na página de Faturas, adicionar botão na toolbar.
    *   **Processo PL/SQL:**
        ```sql
        -- Pseudo-código
        FOR r IN (SELECT * FROM Equipa_Formativa WHERE ID_Turma = :P_TURMA_FILTRO) LOOP
           INSERT INTO Faturas_Formadores (ID_Entidade, ID_Turma, Estado, Valor)
           VALUES (r.ID_Formador, r.ID_Turma, 'EMITIDA', 0); -- Valor 0 a preencher
        END LOOP;
        ```

---

## 9. Dossier Técnico-Pedagógico (Reformulação)

### 9.1. Checklist Visual
**Objetivo:** Tabela de verificação.

1.  **Criar Página:** "Dossier da Turma".
2.  **Região:** Interactive Grid baseado em `Itens_Dossier_Turma`.
3.  **Colunas:**
    *   `Tipo_Documento` (Display Only).
    *   `Obrigatorio` (Checkbox/Switch Read-only).
    *   `Estado` (Select List: 'Em Falta', 'Entregue', 'Validado').
    *   `Ficheiro` (File Browse - Upload).

---

## 10. Equipamentos (Inventário)

### 10.1. Inventário Global
1.  **Página Mestre-Detalhe:**
    *   **Mestre:** Tipos de Equipamento (`Tipos_Equipamento` + Count de itens).
    *   **Detalhe:** Lista de Alocações (`Equipamentos_Alocados`) filtrada pelo tipo selecionado.

### 10.2. Movimentos (Entrada/Saída)
1.  **Botão "Registar Movimento":**
    *   Abre Modal.
    *   Campos: `Equipamento`, `Turma/Formador`, `Qt`, `Data`.
    *   Ao gravar, faz `INSERT INTO Equipamentos_Alocados`.

---

## 11. UX Global
1.  **Quick View (Pessoas):**
    *   Configurar coluna `Nome_Aluno` como Link.
    *   **Target:** Página Modal "Resumo Pessoa" (Read-only, com foto e contactos).
    *   Adicionar botão "Editar" nessa modal que redireciona para a Ficha completa.
