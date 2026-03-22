# Manual de Implementação APEX (v9) - Capítulo 4: Turmas, Inscrições e Matrículas Automáticas
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Gerir o planeamento logístico (Turmas e Sessões) e executar o "Funil de Conversão": transformar candidatos interessados (`Inscricoes`) em alunos efetivos (`Matriculas`), tirando partido das novas automações PL/SQL da v9.

---

## 1. Gestão Logística: Turmas e Sessões
O contentor operacional onde a ação formativa acontece e onde se definem os calendários.

### 1.1. Criar a Página de Gestão de Turmas
1.  No App Builder, clique em **Create Page** > **Report** > **Interactive Report**.
2.  **Page Name:** `Gestão de Turmas`.
3.  **Data Source > Table Name:** `TURMAS`.
4.  **Include Form Page:** Ative o interruptor para **On**.
    *   **Form Page Name:** `Ficha de Turma`.
    *   **Primary Key Column:** `ID_TURMA`.
5.  Clique em **Create Page**.
6.  **Ajustes na Ficha de Turma (Página de Formulário):**
    *   No Page Designer, selecione o item `P4_ID_CURSO`. No painel direito, mude **Type** para `Select List`.
    *   **List of Values > List of Values:** `LOV_CURSOS` (Crie uma LOV dinâmica se ainda não existir: `SELECT Nome d, ID_Curso r FROM Cursos ORDER BY 1`).
    *   Selecione `P4_ID_ESTADO_TURMA`. Mude **Type** para `Select List`.
    *   **List of Values > List of Values:** `LOV_TIPOS_ESTADO_TURMA`.

### 1.2. Painel de Sessões (Aulas)
Dentro da **Ficha de Turma**, vamos permitir o agendamento das sessões.
1.  No painel esquerdo (**Rendering**), clique com o direito em **Body** > **Create Region**.
2.  **Identification > Name:** `Sessões Agendadas`.
3.  **Identification > Type:** `Interactive Grid`.
4.  **Source > Table Name:** `SESSOES`.
5.  **Source > Where Clause:** `ID_TURMA = :P4_ID_TURMA` (Substitua `P4` pelo número da sua página).
6.  **Attributes > Edit > Enabled:** Mude para **On**.
7.  **Configurar Coluna de Turma:**
    *   Expanda **Columns** e selecione `ID_TURMA`.
    *   **Identification > Type:** `Hidden`.
    *   **Default > Type:** `Item` | **Item:** `P4_ID_TURMA`.

### 1.3. Equipa Formativa (Múltiplos Formadores)
1.  Crie outra **Region** do tipo **Interactive Grid** chamada `Equipa Formativa`.
2.  **Source > Table Name:** `EQUIPA_FORMATIVA`.
3.  **Source > Where Clause:** `ID_TURMA = :P4_ID_TURMA`.
4.  **Attributes > Edit > Enabled:** **On**.
5.  **Configurar Seleção de Formadores:**
    *   Selecione a coluna `ID_FORMADOR`.
    *   **Identification > Type:** `Select List`.
    *   **List of Values > Type:** `SQL Query`.
    *   **SQL Query:** `SELECT Nome_Completo d, ID_Entidade r FROM Entidades WHERE Ativo = 'S' ORDER BY 1`.

---

## 2. Triagem de Inscrições (Fila de Espera)
Interface para o técnico decidir quem está apto para ser matriculado numa turma.

### 2.1. Criar a Página de Triagem
1.  **Create Page** > **Report** > **Interactive Report**.
2.  **Page Name:** `Triagem de Candidatos`.
3.  **Source > Type:** `SQL Query`.
4.  **SQL Query:**
    ```sql
    SELECT 
        i.ID_Inscricao,
        i.Data_Registo,
        e.Nome_Completo as "Candidato",
        e.Email,
        c.Nome as "Curso Pretendido",
        
        -- Alerta UX (Semáforo de Dados)
        CASE 
            WHEN e.NIF IS NULL OR e.ID_Genero IS NULL THEN 
                 '<span class="u-warning-text"><i class="fa fa-warning"></i> Faltam Dados SIGO</span>'
            ELSE '<span class="u-success-text"><i class="fa fa-check"></i> Dados Completos</span>'
        END as "Estado Dados",
        
        i.ID_Estado_Inscricao
    FROM Inscricoes i
    JOIN Entidades e ON i.ID_Entidade = e.ID_Entidade
    JOIN Cursos c ON i.ID_Curso = c.ID_Curso
    ORDER BY i.Data_Registo DESC;
    ```
5.  **Ajuste de Ícones:** Selecione a coluna `Estado Dados` e desative **Escape special characters**.

---

## 3. Matrícula em Massa e Automação de Presenças
Transformar candidatos em alunos de uma turma específica com um clique.

### 3.1. Adicionar Seletor de Candidatos à Ficha de Turma
1.  Na **Ficha de Turma**, crie uma nova **Region** do tipo **Classic Report**.
2.  **Name:** `Candidatos Disponíveis para Matrícula`.
3.  **SQL Query:**
    ```sql
    SELECT 
        APEX_ITEM.CHECKBOX2(p_idx => 1, p_value => e.ID_Entidade) as "Selecionar",
        e.Nome_Completo as "Nome",
        e.NIF,
        i.Data_Registo as "Data Inscrição"
    FROM Inscricoes i
    JOIN Entidades e ON i.ID_Entidade = e.ID_Entidade
    WHERE i.ID_Curso = :P4_ID_CURSO
      AND i.Estado_Inscricao = 'DIAGNOSTICADO'
      AND NOT EXISTS (SELECT 1 FROM Matriculas m WHERE m.ID_Aluno = e.ID_Entidade AND m.ID_Turma = :P4_ID_TURMA);
    ```
4.  **Ajuste da Coluna Checkbox:** Selecione a coluna `Selecionar` e desative **Escape special characters**.

### 3.2. Criar o Botão e Processo de Matrícula
1.  Crie um **Button** na região de Candidatos chamado `BT_MATRICULAR`.
    *   **Label:** `Matricular Selecionados`.
    *   **Hot:** `Yes` (Azul).
2.  No separador **Processing** (engrenagem), clique com o direito em **Processing** > **Create Process**.
3.  **Identification > Name:** `Executar Matrículas em Massa`.
4.  **Source > PL/SQL Code:**
    ```sql
    DECLARE
        v_Contador NUMBER := 0;
        v_EstadoMatricula NUMBER;
    BEGIN
        -- ID do estado "FREQUENTAR"
        SELECT ID_Estado_Matricula INTO v_EstadoMatricula 
        FROM Tipos_Estado_Matricula WHERE Codigo = 'FREQUENTAR';

        -- Loop pelas checkboxes (F01 corresponde ao p_idx => 1 do APEX_ITEM)
        FOR i IN 1..APEX_APPLICATION.G_F01.COUNT LOOP
            
            -- 1. Inserir a Matrícula (O Trigger da BD gera o Código automaticamente)
            INSERT INTO Matriculas (
                ID_Turma, 
                ID_Aluno, 
                ID_Estado_Matricula
            ) VALUES (
                :P4_ID_TURMA,
                APEX_APPLICATION.G_F01(i),
                v_EstadoMatricula
            );
            
            v_Contador := v_Contador + 1;
        END LOOP;
        
        -- 2. Chamar a Automação de Presenças da v9
        IF v_Contador > 0 THEN
            PKG_MATRICULAS.Criar_Presencas_Auto(p_ID_Turma => :P4_ID_TURMA);
        END IF;
        
        apex_application.g_print_success_message := v_Contador || ' Alunos Matriculados. Grelhas de Presença geradas com sucesso!';
    END;
    ```
5.  **Server-Side Condition > When Button Pressed:** `BT_MATRICULAR`.

---

## Done When
- [ ] É possível criar uma turma e agendar sessões (aulas) numa grelha editável.
- [ ] O Relatório de Triagem mostra claramente quem tem dados SIGO completos (Verde) ou em falta (Amarelo).
- [ ] Na Ficha de Turma, aparecem apenas os candidatos inscritos naquele curso específico.
- [ ] Ao selecionar candidatos e clicar em "Matricular", o sistema cria as matrículas e gera automaticamente as linhas de presença para todas as sessões agendadas.
- [ ] A mensagem de sucesso confirma o número de matrículas realizadas.

**Conclusão Capítulo 4:**
O motor operacional está a funcionar. O APEX agora orquestra a inteligência da Base de Dados v9 para automatizar o trabalho administrativo pesado. No próximo capítulo, ativaremos o motor de e-mails para comunicar com estes novos alunos.
