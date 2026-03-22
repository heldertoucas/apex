# Manual de Implementação APEX (v9) - Capítulo 6: Avaliação, Administração e Importação
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Fechar o ciclo letivo. Registar avaliações, atribuir Medalhas (Badges), gerir o Dossier Pedagógico, controlar faturas de formadores e executar a importação massiva de dados via Excel.

---

## 1. Avaliação Pedagógica e Badges (Gamification)
Registo do sucesso dos formandos e atribuição automática de micro-credenciais digitais.

### 1.1. Criar a Pauta de Avaliação
1.  No App Builder, clique em **Create Page** > **Report** > **Interactive Grid**.
2.  **Page Name:** `Pauta de Avaliação`.
3.  **Data Source > Table Name:** `AVALIACOES_MODULO`.
4.  **Editing > Enable Editing:** **On**.
5.  Clique em **Create Page**.
6.  **Configurar Colunas de Contexto:**
    *   Selecione a coluna `ID_ALUNO`. Mude **Type** para `Popup LOV`.
        *   **LOV > SQL Query:** `SELECT e.Nome_Completo d, e.ID_Entidade r FROM Entidades e JOIN Matriculas m ON e.ID_Entidade = m.ID_Aluno WHERE m.ID_Turma = :P6_ID_TURMA`.
    *   Selecione `ID_MODULO`. Mude **Type** para `Select List`.
        *   **LOV > SQL Query:** `SELECT m.Nome d, m.ID_Modulo r FROM Modulos m JOIN Turmas t ON m.ID_Curso = t.ID_Curso WHERE t.ID_Turma = :P6_ID_TURMA`.
    *   Selecione `RESULTADO`. Mude **Type** para `Select List`.
        *   **LOV > Static Values:** `STATIC:Aprovado;APROVADO,Reprovado;REPROVADO,Faltou;FALTOU`.

### 1.2. O Medalheiro Digital (Visual)
1.  **Create Page** > **Report** > **Cards**.
2.  **Page Name:** `Medalheiro Digital`.
3.  **Source > SQL Query:**
    ```sql
    SELECT 
        e.Nome_Completo as NOME_ALUNO,
        cm.Nome as NOME_MEDALHA,
        cm.URL_IMAGEM,
        bc.Data_Conquista,
        t.Codigo_Turma
    FROM BADGES_CONQUISTADOS bc
    JOIN Entidades e ON bc.ID_Aluno = e.ID_Entidade
    JOIN Catalogo_Medalhas cm ON bc.ID_Medalha = cm.ID_Medalha
    JOIN Turmas t ON bc.ID_Turma = t.ID_Turma;
    ```
4.  **Attributes > Appearance:**
    *   **Title Column:** `NOME_MEDALHA`
    *   **Body Column:** `NOME_ALUNO`
    *   **Subtext Column:** `Data: &DATA_CONQUISTA. (Turma: &CODIGO_TURMA.)`
    *   **Icon Source:** `Image URL` | **URL Column:** `URL_IMAGEM`.

---

## 2. Dossier Pedagógico e Administração
Controlo documental e financeiro da turma.

### 2.1. Checklist do Dossier da Turma
1.  Na página **Ficha de Turma** (Cap. 4), crie uma sub-região tipo **Interactive Grid**.
2.  **Name:** `Documentação do Dossier`.
3.  **Source > Table Name:** `ITENS_DOSSIER_TURMA` | **Where:** `ID_TURMA = :P4_ID_TURMA`.
4.  **Criar Botão de Inicialização:**
    *   Crie um **Button** chamado `BT_GERAR_DOSSIER`.
    *   Crie um **Process** (Execute Code) associado ao botão:
    ```sql
    INSERT INTO Itens_Dossier_Turma (ID_Turma, ID_Tipo_Doc, Entregue)
    SELECT :P4_ID_TURMA, ID_Tipo_Doc, 'N'
    FROM Tipos_Documento_Dossier
    WHERE Obrigatorio = 'S'
      AND ID_Tipo_Doc NOT IN (SELECT ID_Tipo_Doc FROM Itens_Dossier_Turma WHERE ID_Turma = :P4_ID_TURMA);
    ```

### 2.2. Controlo Financeiro (Faturas)
1.  **Create Page** > **Report** > **Interactive Report**.
2.  **Page Name:** `Controlo de Faturas`.
3.  **Data Source > Table Name:** `FATURAS_FORMADORES`.
4.  **Include Form Page:** **On**.
5.  **Ajuste de Formatação:** No Page Designer, selecione a coluna `VALOR` e em **Appearance > Format Mask**, escolha uma máscara de moeda (ex: `FML999G999G990D00`).

---

## 3. Importação Massiva (Data Loading)
Workflow para carregar centenas de inscrições a partir de um ficheiro Excel/CSV.

### 3.1. Configurar Definição de Dados
1.  Vá a **Shared Components** > **Data Load Definitions**.
2.  Clique em **Create**. **Name:** `IMPORT_INSCRICOES`.
3.  **Target Table:** `STAGING_IMPORTACAO`.
4.  Mapeie as colunas do seu Excel (Nome, Email, NIF, Curso) para as colunas da tabela de staging.

### 3.2. Criar a Página de Upload
1.  **Create Page** > **Data Loading**.
2.  **Definition:** Selecione `IMPORT_INSCRICOES`.
3.  **Page Name:** `Importação de Candidatos (Excel)`.
4.  Clique em **Create Page**.

### 3.3. Cockpit de Validação e Processamento
1.  Crie uma página de **Interactive Grid** editável baseada na tabela `STAGING_IMPORTACAO`.
2.  **Destaque de Erros:** No separador **Attributes** da Grid, crie um **Highlight** automático:
    *   **Name:** `Erro de Validação`.
    *   **Condition:** `MENSAGEM_ERRO IS NOT NULL`.
    *   **Background Color:** Vermelho claro.
3.  **Botão Finalizar Importação:** Crie um botão que executa o processo de migração de Staging para as tabelas reais (`Entidades` e `Inscricoes`), chamando o seu package de importação ou um loop PL/SQL de validação.

---

## Done When
- [ ] A Pauta de Avaliação permite filtrar alunos e módulos dinamicamente por turma.
- [ ] O Medalheiro Digital exibe os cartões com as imagens das medalhas conquistadas.
- [ ] O botão "Gerar Dossier" popula automaticamente a lista de documentos obrigatórios para a turma.
- [ ] Os valores monetários nas faturas aparecem formatados corretamente com o símbolo de moeda.
- [ ] O processo de Data Loading carrega dados para a tabela de Staging e o Cockpit permite corrigir erros antes da gravação final.

**Conclusão Final (v9):**
Parabéns! Completou a implementação do **SGUF v9 - Passaporte Digital**. O sistema cobre agora todo o ciclo: da importação massiva de candidatos, passando pela triagem híbrida, gestão pedagógica, automação de comunicações e fecho administrativo com avaliação e badges. A aplicação está pronta para produção!
