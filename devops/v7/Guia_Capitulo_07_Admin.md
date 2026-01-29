# Manual de Implementação - Capítulo 7: Administração e Conformidade (Detalhado)
**Aplicação:** Academia Digital  
**Versão do Guia:** 3.0 (Passo-a-Passo Beginner Friendly)  
**Objetivo:** Criar a área de backoffice administrativo: Faturas, Dossier Pedagógico e Equipamentos.

---

## Introdução
Este módulo foca-se na parte burocrática da formação. Vamos criar:
1.  **Faturas:** Um relatório para controlar pagamentos.
2.  **Dossier Digital:** Uma checklist de documentos por turma.
3.  **Equipamentos:** Registo de entrega de computadores.

---

## Parte 1: Base de Dados (SQL)

### Passo 1.1: Criar as Tabelas
1.  Vá ao **SQL Workshop** > **SQL Scripts**.
2.  Clique **Create**.
3.  **Name:** `07_Admin`.
4.  Copie o conteúdo do ficheiro `07_Admin.sql` (ou use o código abaixo):
    *(O código abaixo é idêntico ao do ficheiro, garantindo todas as tabelas e lookups)*
    ```sql
    -- (O Assistente já criou o ficheiro 07_Admin.sql na pasta. Use esse conteúdo.)
    -- Se preferir copiar/colar, peça ao assistente para mostrar o conteúdo novamente.
    ```
5.  **Run** > **Run Now**.
6.  Confirme que criou as tabelas `ITENS_DOSSIER_TURMA`, `FATURAS_FORMADORES` e `EQUIPAMENTOS_ALOCADOS`.

---

## Parte 2: Controlo de Faturação

Vamos criar um relatório com formulário (Report with Form) para gerir faturas.

### Passo 2.1: Criar as Páginas
1.  No **App Builder**, clique **Create Page**.
2.  Escolha **Report**.
3.  Escolha **Interactive Report**.
4.  **Page Name:** `Controlo de Faturação`.
5.  **Include Form Page:** ✅ (Marque esta opção!).
    *   *Isto diz ao APEX para criar logo a página de edição.*
6.  **Table:** `FATURAS_FORMADORES`.
7.  Clique **Next**.
8.  **Primary Key Column:** `ID_FATURA` (O APEX deve detetar).
9.  **Form Page Name:** `Editar Fatura`.
10. Clique **Create Page**.

### Passo 2.2: Ajustar o Relatório (Lista)
O APEX redireciona-o para a página do Relatório (Lista). Vamos melhorar.
1.  Na árvore esquerda, clique em **Attributes** da região `Controlo de Faturação`.
2.  **Link Column:** Verifique se aponta para a página de formulário criada (ex: proxima página disponível).
3.  **Columns:**
    *   Esconda `ID_FATURA`, `ID_FORMADOR` (IDs técnicos).
    *   **ID_FORMADOR:** Mude Type para `Plain Text (based on LOV)`.
        *   **LOV SQL:** `SELECT Nome_Completo d, ID_Entidade r FROM Entidades ORDER BY 1`.
        *   *Isto faz com que apareça o nome "Maria" em vez do número "34".*
    *   **VALOR:** Mude format mask para Moeda (`FML999G999G990D00`).

### Passo 2.3: Ajustar o Formulário (Edição)
Vá à outra página criada (a Page de "Editar Fatura").
1.  Selecione o campo `Pxx_ID_FORMADOR`.
2.  **Type:** `Popup LOV`.
3.  **SQL Query:** `SELECT Nome_Completo d, ID_Entidade r FROM Entidades WHERE Ativo = 'S' ORDER BY 1`.
4.  **Page Item:** `Pxx_MES_REF`.
    *   Ponha uma másscara de ajuda "YYYY-MM" no campo **Placeholder**.

---

## Parte 3: Dossier Digital (Checklist)

A parte mais interessante. Uma checklist dentro da Turma para verificar documentos.

### Passo 3.1: Criar a Página de Grelha
1.  **Create Page** > **Interactive Grid**.
2.  **Page Name:** `Dossier da Turma`.
3.  **Table:** `ITENS_DOSSIER_TURMA`.
4.  Clique **Next** (se pedir Primary Key, confirme `ID_ITEM_DOSSIER`).
5.  Clique **Create Page**.

### Passo 3.2: Garantir que é Editável
1.  Na árvore esquerda (Rendering), clique na região **Dossier da Turma**.
2.  No painel direito (Attributes), clique no separador **Attributes**.
3.  **Edit > Enabled:** Mude para `On`.
4.  **Allowed Operations:** Marque `Update` e `Delete` (Desmarque `Add`, pois vamos gerar as linhas via botão).

### Passo 3.3: Configurar as Colunas
Agora vamos tornar a grelha bonita e funcional. Expanda a lista **Columns** na árvore esquerda.

1.  **ID_ITEM_DOSSIER:** Type `Hidden`.
2.  **ID_TURMA:** Type `Hidden`.
3.  **ID_TIPO_DOC:**
    *   **Type:** `Select List`.
    *   **Heading:** `Documento`.
    *   **List of Values > SQL Query:** `SELECT Descricao d, ID_Tipo_Doc r FROM Tipos_Documento_Dossier ORDER BY 1`.
    *   **Display Extra Values:** `No`.
4.  **PRESENTE:**
    *   **Type:** `Switch` (Interruptor).
    *   **Heading:** `Entregue?`.
    *   **On Value:** `S` (Sim).
    *   **Off Value:** `N` (Não).
5.  **URL_FICHEIRO:**
    *   **Type:** `Text Field`.
    *   **Heading:** `Link para Ficheiro`.
6.  **DATA_VALIDACAO:**
    *   **Type:** `Date Picker`.
    *   **Heading:** `Validado em`.

### Passo 3.4: Filtrar por Turma
Esta página precisa de saber qual a turma que estamos a ver.
1.  **Criar Item:** Clique com o botão direito em **Breadcrumb Bar** > **Create Page Item**.
2.  **Name:** `P_FILTRO_TURMA` (ajuste o prefixo Pxx).
3.  **Type:** `Select List` (ou Popup LOV).
4.  **LOV SQL:** `SELECT Codigo_Turma d, ID_Turma r FROM Turmas ORDER BY 1`.
5.  **Filtrar Grelha:**
    *   Clique na região **Dossier da Turma**.
    *   Mude **Source > Type** para `SQL Query`.
    *   **SQL Code:** `SELECT * FROM Itens_Dossier_Turma WHERE ID_Turma = :P_FILTRO_TURMA`
    *   **Page Items to Submit:** `P_FILTRO_TURMA`.

### Passo 3.5: Botão "Inicializar Checklist"
A grelha começa vazia. Precisamos de um botão que diga: "Quais são os documentos obrigatórios? Cria uma linha para cada um nesta turma."

1.  **Criar Botão:** Right-click na região > Create Button.
    *   **Name:** `BTN_GERAR_DOSSIER`.
    *   **Label:** `Inicializar Dossier`.
    *   **Position:** `Right of Interactive Grid Toolbar`.
    *   **Action:** `Submit Page`.
2.  **Criar Processo:**
    *   Vá à tab **Processing**.
    *   Right-click > Create Process.
    *   **Name:** `Gerar Itens Dossier`.
    *   **PL/SQL Code:**
        ```sql
        -- Insere uma linha por cada Tipo de Documento que ainda não exista para esta turma
        INSERT INTO Itens_Dossier_Turma (ID_Turma, ID_Tipo_Doc, Presente)
        SELECT :P_FILTRO_TURMA, t.ID_Tipo_Doc, 'N'
          FROM Tipos_Documento_Dossier t
          WHERE NOT EXISTS (
              SELECT 1 FROM Itens_Dossier_Turma i 
               WHERE i.ID_Turma = :P_FILTRO_TURMA 
                 AND i.ID_Tipo_Doc = t.ID_Tipo_Doc
          );
        ```
    *   **Server-side Condition > When Button Pressed:** `BTN_GERAR_DOSSIER`.

---

## Parte 4: Gestão de Equipamentos

Vamos usar o wizard "Report with Form" para criar duas páginas de uma vez: uma lista de alocações e um formulário para registar novas entregas.

### Passo 4.1: Iniciar o Wizard
1.  **Create Page** > **Report**.
2.  Selecione **Report with Form** (Relatório com Formulário).
3.  **Page Name:** `Equipamentos Alocados`.
4.  **Form Page Name:** `Registar Entrega`.
5.  **Table:** `EQUIPAMENTOS_ALOCADOS` (escreva para filtrar).
6.  Clique **Next**.

### Passo 4.2: Configurar Chaves e Navegação
1.  **Primary Key:** O APEX deve detetar `ID_ALOCACAO`. Clique **Next**.
2.  **Navigation:** Crie uma entrada no menu chamada `Equipamentos`.
3.  Clique **Next** e depois **Create Page**.

### Passo 4.3: Melhorar o Relatório (Lista)
O APEX criou a lista, mas mostra IDs. Vamos pôr nomes.
1.  Vá à página do **Relatório** (a primeira das duas).
2.  Clique na região **Equipamentos Alocados** (Classic Report ou Interactive Report).
3.  Expanda **Columns**.
    *   **ID_TURMA:** Mude para `Plain Text (based on LOV)`.
        *   **LOV SQL:** `SELECT Codigo_Turma d, ID_Turma r FROM Turmas`.
    *   **ID_TIPO_EQUIPAMENTO:** Mude para `Plain Text (based on LOV)`.
        *   **LOV SQL:** `SELECT Descricao d, ID_Tipo_Equipamento r FROM Tipos_Equipamento`.
4.  **Grave.**

### Passo 4.4: Melhorar o Formulário (Registo)
Agora vamos à página de "Registar Entrega" (navegue para ela usando o dropdown de páginas no topo).
1.  **Configurar Turma:**
    *   Selecione o item `Pxx_ID_TURMA`.
    *   **Type:** `Popup LOV`.
    *   **LOV SQL:** `SELECT Codigo_Turma d, ID_Turma r FROM Turmas WHERE ID_Estado_Turma IN (SELECT ID_Estado_Turma FROM Tipos_Estado_Turma WHERE Codigo='DECORRER')`.
    *   *(Isto mostra apenas turmas ativas!)*.
2.  **Configurar Equipamento:**
    *   Selecione `Pxx_ID_TIPO_EQUIPAMENTO`.
    *   **Type:** `Select List`.
    *   **LOV SQL:** `SELECT Descricao d, ID_Tipo_Equipamento r FROM Tipos_Equipamento ORDER BY 1`.
3.  **Data de Entrega:**
    *   Selecione `Pxx_DATA_ENTREGA`.
    *   **Default > Type:** `Expression`.
    *   **Default > SQL Expression:** `SYSDATE`.
4.  **Grave.**

Agora tem um sistema completo para dizer "Entreguei 10 Portáteis à Turma X no dia de hoje".

---

---

## Anexo: Dados de Teste
Para preencher as tabelas com dados fictícios (Faturas, Equipamentos):
1.  Crie/Abra o script `07_DummyData_Admin` (copiar do ficheiro `07_DummyData_Admin.sql`).
2.  Execute.
3.  As suas grelhas e relatórios já deverão mostrar dados.

---

## Conclusão
Criou agora as ferramentas de suporte administrativo. O sistema permite controlar quem pagou, se a turma tem os papéis todos e onde andam os PCs.

