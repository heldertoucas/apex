# Manual de Implementação APEX (v9) - Capítulo 2: Gestão de Entidades (UX Híbrida)
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Criar o módulo principal de Diretório de Pessoas suportando desde o primeiro contacto (Pré-inscrição com Nome/Email) até ao enriquecimento completo de perfil SIGO com a abordagem de semáforos visuais (UX Híbrida).

---

## 1. O Conceito Híbrido no SGUF v9
No SGUF v9, a tabela `Entidades` exige obrigatoriamente apenas o `Nome_Completo`. O `Email`, apesar de não ser `NOT NULL` estrito na DB (para dar margem de manobra absoluta), deve ser forçado no formulário de entrada porque alavanca o motor de automação (Capítulo 5). 
Os restantes dados (NIF, Morada, etc.) são "Soft Requirements": podem estar vazios no dia 1, mas terão de ser preenchidos antes da conclusão do curso.

---

## 2. A Grelha de Triagem (Interactive Grid com Semáforos)
Vamos construir o ecrã onde o técnico visualiza as entidades e percebe de imediato quem precisa de completar dados.

### 2.1. Criar a Página de Relatório
1. No **App Builder**, clique em **Create Page** > **Report** > **Interactive Grid**.
2. **Page Name:** `Diretório de Cidadãos`.
3. **Table Name:** `ENTIDADES`.
4. **Editing:** Marque *Enable Editing* (para permitir correções rápidas na grelha sem ter de entrar no formulário completo).
5. Clique **Create**.

### 2.2. Configurar o SQL e os Semáforos Visuais
1. Abra a página recém-criada no **Page Designer**.
2. Selecione a região **Diretório de Cidadãos**.
3. Altere o **Source Type** de *Table* para **SQL Query**.
4. Use a seguinte *query* melhorada:
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
5. **Ajuste Crítico de UI:**
    * Na árvore de colunas à esquerda, selecione a coluna `"Estado do Perfil"`.
    * Na secção **Security**, altere **Escape special characters** para **No**. (Isto permite que o APEX renderize os ícones e cores HTML que escrevemos no SQL em vez de mostrar o código em texto limpo).

---

## 3. O Formulário Detalhado (Enriquecimento Progressivo)
A Grid serve para a triagem rápida. Agora vamos criar a "Ficha de Cidadão" onde se podem inserir os dados em profundidade.

### 3.1. Criar a Ficha
1. **Create Page** > **Form**.
2. **Page Name:** `Ficha de Cidadão`.
3. **Table Name:** `ENTIDADES`.
4. **Primary Key:** `ID_ENTIDADE`.
5. Clique **Create**.

### 3.2. Organização Visual (Tabs Híbridas)
Como a Entidade tem muitos dados, separe-os para não sobrecarregar quer o utilizador quer o cidadão.
1. No Page Designer, selecione a região principal gerada e mude o **Template** para **Tabs Container**.
2. Clique com o direito e crie 3 Sub-regiões (Tabs):
    * **Identidade Base** (Arraste `P_NOME_COMPLETO`, `P_EMAIL`, `P_TELEMOVEL`).
    * **Dados Oficiais / SIGO** (Arraste `P_NIF`, `P_DATA_NASCIMENTO`, `P_ID_GENERO`).
    * **Situação Socioeconómica** (Arraste `P_ID_SITUACAO_PROF`, `P_ID_QUALIFICACAO`, `P_PROFISSAO`).

### 3.3. Configurar as LOVs do Capítulo 1
Os campos de "IDs" (como `P_ID_GENERO` ou `P_ID_QUALIFICACAO`) devem ser transformados em Listas de Seleção, reaproveitando o que fez no Capítulo 1.
1. Selecione o item `P_ID_GENERO` (o nome exato depende do número da sua página).
2. **Type:** `Select List`.
3. **List of Values:** 
    * Type: `Shared Component`.
    * List of Values: Escolha `LOV_TIPOS_GENERO`.
    * Display Null Value: `Yes` (pois o campo não é obrigatório na criação inicial).
4. Proceda igualmente para `P_ID_SITUACAO_PROF`, `P_ID_QUALIFICACAO` e `P_ID_TIPO_DOC`.

### 3.4. Forçar a Automação: O Email Obrigatório
Aqui é onde a magia Híbrida acontece: o Oracle aceita Pessoas sem Email. Mas o nosso APEX não vai aceitar (a menos que seja um caso super excecional que o Coordenador introduza).
1. Selecione o campo `P_EMAIL`.
2. Em **Validation**, altere **Value Required** para **Yes**.
3. O APEX só deixará gravar a Ficha se houver um E-mail (que servirá de Pivot para o envio do *Link Mágico* na Fase 5).

### 3.5. Listas de Mailing (Marketing)
Permite associar a pessoa a múltiplas listas de comunicação (VIP, Newsletter, etc.).
1. Na Ficha de Cidadão, crie uma sub-região (ou adicione à aba `Identidade Base`) chamada `Marketing`.
2. Adicione um item `PXX_LISTAS_MAILING` do tipo **Checkbox Group**.
3. **List of Values:** SQL Query `SELECT Nome_Lista d, ID_Lista r FROM Listas_Mailing WHERE Ativo='S' ORDER BY 1`.
4. **Fonte de Dados (Pre-Rendering):** Crie uma *Computation* (*Before Header*) no PXX_LISTAS_MAILING para carregar as opções ativas:
    `SELECT LISTAGG(ID_Lista, ':') WITHIN GROUP (ORDER BY ID_Lista) FROM Entidade_Listas WHERE ID_Entidade = :PXX_ID_ENTIDADE`
5. **Processo de Gravação Customizado:** Como o APEX não mapeia grupos N:N nativamente no form base, vá a *Processing* > *Create Process* (Execute Code) com ordem de execução *após* a gravação da `Entidade`:
    ```sql
    DELETE FROM Entidade_Listas WHERE ID_Entidade = :PXX_ID_ENTIDADE;
    IF :PXX_LISTAS_MAILING IS NOT NULL THEN
        DECLARE l_list_ids APEX_T_VARCHAR2 := APEX_STRING.SPLIT(:PXX_LISTAS_MAILING, ':');
        BEGIN
            FOR i IN 1 .. l_list_ids.COUNT LOOP
                INSERT INTO Entidade_Listas (ID_Entidade, ID_Lista) VALUES (:PXX_ID_ENTIDADE, TO_NUMBER(l_list_ids(i)));
            END LOOP;
        END;
    END IF;
    ```

---

## 4. Unir o Diretório à Ficha
Falta garantir que o botão "Editar" na Grelha (Capítulo 2.1) abre a Ficha (Capítulo 3.1).
1. Volte à página do **Diretório de Cidadãos**.
2. Na Interactive Grid, expanda a secção de colunas.
3. Se o APEX não tiver criado uma coluna Link, crie uma (botão direito em Columns > **Create Action Column** e mude o tipo para Link).
4. **Link Target:**
    * **Page:** Selecione a página da `Ficha de Cidadão`.
    * **Set Items:** Name = `P_ID_ENTIDADE` (da página Ficha), Value = `&ID_ENTIDADE.` (selecionado da grid).
    * **Clear Cache:** Ponha o número da página Ficha.
5. Isto constrói o fluxo normal de CRUD.

**Conclusão Capítulo 2:**
Tem um backoffice capaz de lidar com a "sujidade" do mundo real: recebe inscrições apenas com Nome e Email (com Alerta Amarelo na Grelha) e permite facilmente abrir a ficha da pessoa e preencher os dados do SIGO à posteriori (passando o Semáforo a Verde). No próximo capítulo vamos montar a Oferta Formativa.
