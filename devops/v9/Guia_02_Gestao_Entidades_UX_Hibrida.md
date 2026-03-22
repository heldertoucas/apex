# Manual de Implementação APEX (v9) - Capítulo 2: Gestão de Entidades (UX Híbrida)
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Criar o módulo principal de Diretório de Pessoas suportando desde o primeiro contacto (Pré-inscrição com Nome/Email) até ao enriquecimento completo de perfil SIGO com a abordagem de semáforos visuais (UX Híbrida).

---

## 1. O Conceito Híbrido no SGUF v9
No SGUF v9, a tabela `Entidades` exige obrigatoriamente apenas o `Nome_Completo`. O `Email`, apesar de não ser `NOT NULL` na base de dados, deve ser forçado no formulário de entrada porque alavanca o motor de automação (Capítulo 5). 
Os restantes dados (NIF, Morada, etc.) são "Soft Requirements": podem estar vazios no dia 1, mas terão de ser preenchidos antes da conclusão do curso para cumprimento das regras SIGO.

---

## 2. A Grelha de Triagem (Interactive Grid com Semáforos)
Vamos construir o ecrã onde o técnico visualiza as entidades e percebe de imediato quem precisa de completar dados através de indicadores visuais.

### 2.1. Criar a Página do Diretório
1.  No topo do ecrã do App Builder, clique no botão azul **Create Page**.
2.  Escolha a opção **Report** e depois **Interactive Grid**.
3.  **Page Number:** 2 (ou o seguinte disponível).
4.  **Name:** Escreva `Diretório de Cidadãos`.
5.  **Data Source:** Garanta que está em **Local Database**.
6.  **Source Type:** Escolha **Table**.
7.  **Table / View Name:** Selecione `ENTIDADES`.
8.  **Editing > Enable Editing:** Clique no interruptor para **On** (permite correções rápidas na grelha).
9.  Clique em **Create Page**.

### 2.2. Configurar o SQL e os Semáforos Visuais
1.  Com a Página 2 aberta no **Page Designer**, localize a região **Diretório de Cidadãos** no painel da esquerda (**Rendering**).
2.  No painel da direita (**Property Editor**), altere:
    *   **Source > Type:** Mude para **SQL Query**.
    *   **Source > SQL Query:** Clique no ícone de expandir e cole este código:
    ```sql
    SELECT 
        e.ID_Entidade,
        e.Nome_Completo,
        e.Email,
        e.Telemovel,
        e.NIF,
        g.Descricao as "Genero",
        q.Descricao as "Qualificacao",
        
        -- Lógica Híbrida (Semáforo Operacional)
        CASE 
            WHEN e.NIF IS NOT NULL AND e.ID_Genero IS NOT NULL AND e.Morada IS NOT NULL
            THEN '<span class="fa fa-check-circle u-success-text" title="Perfil SIGO Completo"></span> Completo'
            WHEN e.Email IS NOT NULL 
            THEN '<span class="fa fa-exclamation-triangle u-warning-text" title="Faltam Dados Oficiais"></span> Incompleto'
            ELSE '<span class="fa fa-times-circle u-danger-text" title="Falta Email Crítico"></span> Contato Base'
        END as "Estado do Perfil",
        
        e.Ativo
    FROM Entidades e
    LEFT JOIN Tipos_Genero g ON e.ID_Genero = g.ID_Genero
    LEFT JOIN Tipos_De_Qualificacao q ON e.ID_Qualificacao = q.ID_Qualificacao;
    ```
3.  **Ajuste de Renderização (Ícones):**
    *   No painel da esquerda, expanda a região **Diretório de Cidadãos** > **Columns**.
    *   Clique na coluna **Estado do Perfil**.
    *   No painel da direita, procure a secção **Security**.
    *   **Escape special characters:** Mude para **Off**.
4.  Clique em **Save**.

---

## 3. O Formulário Detalhado (Enriquecimento Progressivo)
A Grid serve para a triagem. Agora criaremos a "Ficha de Cidadão" para edição profunda dos dados.

### 3.1. Criar a Página de Formulário
1.  Clique no botão **+** (Create) no topo e escolha **Page**.
2.  Escolha **Form**.
3.  **Page Name:** Escreva `Ficha de Cidadão`.
4.  **Data Source > Table Name:** Selecione `ENTIDADES`.
5.  **Primary Key Column 1:** Garanta que é `ID_ENTIDADE`.
6.  Clique em **Create Page**.

### 3.2. Organização Visual (Tabs Híbridas)
Vamos dividir os campos em abas para uma interface limpa.
1.  No painel da esquerda (**Rendering**), clique na região **Ficha de Cidadão**.
2.  No painel da direita, mude **Appearance > Template** para **Tabs Container**.
3.  **Criar as Abas:**
    *   Clique com o botão direito na região **Ficha de Cidadão** no painel esquerdo e escolha **Create Sub Region**.
    *   **Name:** `Identidade Base`. Crie mais duas: `Dados Oficiais / SIGO` e `Situação Socioeconómica`.
4.  **Distribuir os Campos:** No painel esquerdo, arraste os campos para as respetivas sub-regiões:
    *   **Identidade Base:** `P3_NOME_COMPLETO`, `P3_EMAIL`, `P3_TELEMOVEL`.
    *   **Dados Oficiais / SIGO:** `P3_NIF`, `P3_DATA_NASCIMENTO`, `P3_ID_GENERO`, `P3_ID_TIPO_DOC`, `P3_NR_DOC_IDENTIFICACAO`.
    *   **Situação Socioeconómica:** `P3_ID_SITUACAO_PROF`, `P3_ID_QUALIFICACAO`, `P3_PROFISSAO`.

### 3.3. Configurar Listas de Escolha (LOVs)
Transformar IDs em menus de seleção usando os componentes criados no Capítulo 1.
1.  Selecione o item `P3_ID_GENERO`. No painel da direita, configure:
    *   **Identification > Type:** `Select List`.
    *   **List of Values > Type:** `Shared Component`.
    *   **List of Values > List of Values:** `LOV_TIPOS_GENERO`.
    *   **List of Values > Display Null Value:** `Yes`.
    *   **List of Values > Null Display Value:** `- Selecione -`.
2.  Repita o processo para `P3_ID_SITUACAO_PROF`, `P3_ID_QUALIFICACAO` e `P3_ID_TIPO_DOC` usando as LOVs correspondentes.

### 3.4. Validar Email Obrigatório
1.  Selecione o item `P3_EMAIL`.
2.  No painel da direita, procure a secção **Validation**.
3.  **Value Required:** Mude para **On**.

### 3.5. Gestão de Listas de Mailing (N:N)
1.  Crie uma nova Sub-região dentro de `Identidade Base` chamada `Comunicação`.
2.  Clique com o botão direito nessa sub-região > **Create Page Item**.
    *   **Name:** `P3_LISTAS_MAILING`.
    *   **Type:** `Checkbox Group`.
    *   **List of Values > Type:** `SQL Query`.
    *   **SQL Query:** `SELECT Nome_Lista d, ID_Lista r FROM Listas_Mailing WHERE Ativo='S' ORDER BY 1`.
3.  **Carregar Dados Atuais:**
    *   No painel da esquerda, clique no separador **Pre-Rendering** (ícone de página com seta).
    *   Clique com o direito em **Before Header** > **Create Computation**.
    *   **Identification > Item Name:** `P3_LISTAS_MAILING`.
    *   **Computation > Type:** `SQL Query (return single value)`.
    *   **SQL Query:** `SELECT LISTAGG(ID_Lista, ':') WITHIN GROUP (ORDER BY ID_Lista) FROM Entidade_Listas WHERE ID_Entidade = :P3_ID_ENTIDADE`.
4.  **Gravar as Escolhas:**
    *   No painel da esquerda, clique no separador **Processing** (ícone de engrenagem).
    *   Clique com o direito em **Processing** > **Create Process**.
    *   **Identification > Name:** `Gravar Listas Mailing`.
    *   **Source > PL/SQL Code:** Cole este código:
    ```sql
    DELETE FROM Entidade_Listas WHERE ID_Entidade = :P3_ID_ENTIDADE;
    IF :P3_LISTAS_MAILING IS NOT NULL THEN
        DECLARE l_list_ids APEX_T_VARCHAR2 := APEX_STRING.SPLIT(:P3_LISTAS_MAILING, ':');
        BEGIN
            FOR i IN 1 .. l_list_ids.COUNT LOOP
                INSERT INTO Entidade_Listas (ID_Entidade, ID_Lista) VALUES (:P3_ID_ENTIDADE, TO_NUMBER(l_list_ids(i)));
            END LOOP;
        END;
    END IF;
    ```
    *   **Execution > Sequence:** Garanta que é maior que o processo `Process Form Ficha de Cidadão` (ex: 40).

---

## 4. Unir o Diretório à Ficha
1.  Volte à **Página 2 (Diretório de Cidadãos)**.
2.  No painel esquerdo, expanda **Diretório de Cidadãos** > **Columns**.
3.  Clique com o direito em **Columns** > **Create Column**.
    *   **Identification > Name:** `EDITAR`.
    *   **Identification > Type:** `Link`.
4.  **Configurar o Link:**
    *   No painel direito, clique em **Link > [No Link Defined]**.
    *   **Target > Page:** `3` (Ficha de Cidadão).
    *   **Set Items > Name:** `P3_ID_ENTIDADE` | **Value:** `&ID_ENTIDADE.`.
    *   **Clear Cache:** `3`.
    *   Clique em **OK**.
5.  **Appearance > Link Icon:** Escreva `fa-edit`.

---

## Done When
- [ ] A grelha de cidadãos exibe os ícones de semáforo (Verde/Amarelo/Vermelho).
- [ ] Ao clicar no ícone de editar, abre a Ficha de Cidadão com os dados carregados.
- [ ] O formulário está dividido em abas funcionais.
- [ ] As checkboxes de mailing refletem os dados da tabela `Entidade_Listas` e gravam corretamente.
- [ ] O campo Email é obrigatório na submissão do formulário.

**Conclusão Capítulo 2:**
Implementou um backoffice resiliente que aceita o fluxo "sujo" do mundo real e incentiva o enriquecimento progressivo dos dados para conformidade SIGO. O próximo capítulo focará na montagem da Oferta Formativa.
