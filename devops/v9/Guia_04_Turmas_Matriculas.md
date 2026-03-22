# Manual de Implementação APEX (v9) - Capítulo 4: Turmas, Inscrições e Matrículas Automáticas
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Gerir o planeamento logístico (Turmas e Sessões) e executar o "Funil de Conversão": transformar candidatos interessados (`Inscricoes`) em alunos efetivos (`Matriculas`), tirando partido das novas automações PL/SQL da v9.

---

## 1. Gestão Logística: Turmas e Sessões
O contentor onde a ação formativa acontece.

### 1.1. Relatório e Ficha de Turma
1. Use o Wizard: **Create Page** > **Report** > **Interactive Report**.
2. **Page Name:** `Gestão de Turmas`.
3. **Table:** `TURMAS`.
4. **Include Form Page:** Ative e chame `Ficha de Turma`. (Primary Key: `ID_TURMA`).
5. Nas definições da Ficha de Turma gerada, substitua os itens numéricos como `P_ID_CURSO` e `P_ID_ESTADO_TURMA` por **Select Lists**, usando as Shared LOVs criadas no Capítulo 1.

### 1.2. Painel de Sessões (Aulas)
Dentro da Ficha de Turma, crie uma grelha para as aulas.
1. Adicione uma **Region** do tipo **Interactive Grid** chamada `Sessões Agendadas`.
2. **Table:** `SESSOES`.
3. **Where Clause:** `ID_TURMA = :PXX_ID_TURMA`.
4. Ative a **Edição** (Enable Editing) na Grid para que o técnico possa adicionar as datas de cada Sessão.
5. Esconda a coluna `ID_TURMA` e defina o seu valor _Default_ para o item da página (`PXX_ID_TURMA`).

### 1.3. Equipa Formativa (Múltiplos Formadores)
Uma turma pode ter vários formadores.
1. Adicione uma **Region** do tipo **Interactive Grid** chamada `Equipa Formativa`.
2. **Table:** `EQUIPA_FORMATIVA`.
3. **Where Clause:** `ID_TURMA = :PXX_ID_TURMA` (mesma lógica das sessões).
4. Na coluna `ID_FORMADOR`, altere o tipo para **Select List** e faça um *SQL Query* à tabela `Entidades` para mostrar os docentes disponíveis: 
   `SELECT Nome_Completo d, ID_Entidade r FROM Entidades WHERE Ativo = 'S' ORDER BY 1`.

### 1.4. Sumários das Sessões
O formador precisa de justificar o que lecionou.
1. Na Grid de `Sessões Agendadas` (criada em 1.2), garanta que a coluna `Sumario_Descritivo` (ou similar, dependendo do campo exato na sua BD) está como editável.
2. Mude o *Type* para **Textarea** ou **Rich Text Editor**.
3. *Melhoria UX UX:* Se a grid ficar demasiado larga, transforme essa coluna num *Dialog* ou esconda-a no relatório principal, ativando a vista de `Single Row View` do Interactive Grid.

---

## 2. A Inscrição no APEX (A Visão do Cidadão vs Técnico)
Na v9, o cidadão pode demonstrar interesse preenchendo apenas "Nome e Email". E isso bate na tabela `Inscricoes`.

### 2.1. O Ecrã de "Triagem de Inscrições"
Esta é a fila de espera.
1. **Create Page** > **Interactive Report**.
2. **Name:** `Triagem de Candidatos`.
3. **Query Híbrida de Inscrições:**
    ```sql
    SELECT 
        i.ID_Inscricao,
        i.Data_Registo,
        e.Nome_Completo as "Candidato",
        e.Email,
        c.Nome as "Curso Pretendido",
        
        -- Alerta UX (Opção C)
        CASE 
            WHEN e.NIF IS NULL THEN '<span class="u-warning-text"><i class="fa fa-warning"></i> Faltam Dados ID</span>'
            ELSE '<span class="u-success-text"><i class="fa fa-check"></i> Completo</span>'
        END as "Estado Dados",
        
        i.ID_Estado_Inscricao
    FROM Inscricoes i
    JOIN Entidades e ON i.ID_Entidade = e.ID_Entidade
    JOIN Cursos c ON i.ID_Curso = c.ID_Curso
    ORDER BY i.Data_Registo ASC;
    ```
4. A partir deste ecrã, os técnicos sabem a quem devem ligar ou pedir para completar o perfil (acionando o Capítulo 2).

---

## 3. Matrícula em Massa e Automação de Presenças
Quando o curso vai arrancar, os Gestores selecionam os candidatos "Verdes" e inserem-nos na Turma. A arquitetura v9 faz três coisas automaticamente:
* Cria o registo de `Matriculas`.
* Gera o `Codigo_Matricula` legível para os diplomas (via Trigger BD).
* Dispara a conversão automática das `Presencas` esperadas (via PKG na BD).

### 3.1. Processo de Matrícula Múltipla a partir da Ficha de Turma
Vamos adicionar à `Ficha de Turma` a capacidade de importar candidatos.
1. Na `Ficha de Turma`, adicione uma Região Modal (Dialog) extra ou um Botão "Matricular Candidatos".
2. **Construção Simples (Processo PL/SQL Custom):**
   Suponha que usa um relatório clássico com Checkboxes de candidatos ( `APEX_ITEM.CHECKBOX2(1, e.ID_Entidade)` ).
3. **O Botão de Gravar (Submit):** Crie um processo do tipo `Execute Code` associado ao botão "Matricular":
    ```sql
    DECLARE
        v_Contador NUMBER := 0;
        v_EstadoMatricula NUMBER;
    BEGIN
        -- Vai buscar o ID do estado "FREQUENTAR"
        SELECT ID_Estado_Matricula INTO v_EstadoMatricula 
        FROM Tipos_Estado_Matricula WHERE Codigo = 'FREQUENTAR';

        -- Loop pelas checkboxes ativadas no relatório
        FOR i IN 1..APEX_APPLICATION.G_F01.COUNT LOOP
            
            -- 1. Inserir a Matrícula
            -- Nota: O campo CODIGO_MATRICULA é preenchido automaticamente pelo TRG_MATRICULAS_CODIGO na Base de Dados. Não mencionar aqui.
            INSERT INTO Matriculas (
                ID_Turma, 
                ID_Aluno, 
                ID_Estado_Matricula
            ) VALUES (
                :PXX_ID_TURMA,
                APEX_APPLICATION.G_F01(i),
                v_EstadoMatricula
            );
            
            -- 2. Chamar o Package v9 para gerar a folha de presenças!
            -- Isto poupa que o formador tenha de inserir os alunos um a um na folha.
            PKG_MATRICULAS.Criar_Presencas_Auto(p_ID_Turma => :PXX_ID_TURMA);
            
            v_Contador := v_Contador + 1;
        END LOOP;
        
        apex_application.g_print_success_message := v_Contador || ' Alunos Matriculados. Códigos e Grelhas de Presença gerados com sucesso!';
    END;
    ```

### 3.2. A Grelha de Presenças do Formador
Na v9, ao contrário de sistemas rígidos, o `PKG_MATRICULAS` já criou linhas para todos os alunos em todas as sessões, com o estado "CV" (Convocado). O Formador só tem de as atualizar.
1. **Create Page** > **Interactive Grid**.
2. **Name:** `Lançamento de Presenças`.
3. **Query de Edição:**
    ```sql
    SELECT 
        p.ID_Presenca,
        e.Nome_Completo as "Aluno",
        m.Codigo_Matricula as "Código Aluno",
        p.ID_Estado_Presenca,
        p.Observacoes
    FROM Presencas p
    JOIN Matriculas m ON p.ID_Matricula = m.ID_Matricula
    JOIN Entidades e ON m.ID_Aluno = e.ID_Entidade
    WHERE p.ID_Sessao = :PXX_ID_SESSAO_ACTUAL;  
    ```
4. **Edição Fácil:** Altere a coluna `ID_Estado_Presenca` para um **Select List**, usando a LOV `LOV_TIPOS_ESTADO_PRESENCA`.
5. O formador abre a página, vê os alunos todos como "Convocados" ou "P" (dependendo da lógica de default), e só altera os que faltaram (para F). Fazer Gravar altera apenas o Estado_Presenca.

**Conclusão Capítulo 4:**
O ciclo central do SGUF está montado. A automação da BD (Triggers e Packages) tira 90% do peso do trabalho transacional do APEX. No Capítulo 5, mergulharemos no motor de E-mails que avisa os alunos matriculados de que a turma vai arrancar.
