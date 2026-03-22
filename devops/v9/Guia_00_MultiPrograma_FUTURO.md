# Guia 00: Arquitetura Multi-Programa e Pipeline FUTURO (SGUF v9)

## Goal
Implementar a infraestrutura de filtragem global por Programa (PASS, FUTURO, IAPT) e o Cockpit de Sincronização Excel para o workflow do Programa FUTURO (Recrutamento de 10.000 trabalhadores).

---

## Task 1: Infraestrutura Multi-Programa (Contexto Global)
*Esta tarefa deve ser realizada logo após a criação da App (Guia 01, Task 1.1) e antes de criar o Dashboard.*

### 1.1. Criar a "Gaveta" de Memória (Application Item)
O Application Item funciona como uma variável que guarda informação durante toda a sessão do utilizador.
1.  No topo do ecrã do App Builder, clique em **Shared Components** (ícone de rodas dentadas).
2.  Na coluna **Application Logic**, clique em **Application Items**.
3.  Clique no botão azul **Create**.
4.  **Name:** Escreva `F_ID_PROGRAMA`.
5.  **Scope:** Garanta que está selecionado **Global**.
6.  Clique em **Create Application Item**.

### 1.2. Criar a Lista de Escolha (Shared LOV)
Para que o utilizador possa escolher o programa, precisamos de uma lista vinda da base de dados.
1.  Volte a **Shared Components**.
2.  Na coluna **Other Components**, clique em **List of Values**.
3.  Clique em **Create** > Escolha **From Scratch** > Clique em **Next**.
4.  **Name:** Escreva `LOV_PROGRAMAS`.
5.  **Type:** Escolha **Dynamic**. Clique em **Next**.
6.  **SQL Query:** No campo de texto, cole este código:
    `SELECT Nome as d, ID_Programa as r FROM Programas WHERE Ativo = 'S' ORDER BY Nome`
    *(Nota: 'd' é o que o utilizador vê, 'r' é o ID que o sistema guarda).*
7.  Clique em **Create List of Values**.

### 1.3. Criar o Seletor no Topo da App (Page 0)
A Page 0 é uma página especial: tudo o que colocar nela aparece em todas as outras páginas da App.
1.  No topo do Page Designer, clique no seletor de páginas (**Page Finder**) e selecione a **Page 0 (Global Page)**.
2.  No painel central (**Layout**), localize a região **Breadcrumb Bar** (ou similar no topo).
3.  Clique com o botão direito nessa região e escolha **Create Page Item**.
4.  No painel da direita (**Property Editor**), configure os seguintes campos:
    *   **Identification > Name:** `P0_ID_PROGRAMA`.
    *   **Identification > Type:** Escolha **Select List**.
    *   **Label > Label:** Escreva `Programa Ativo`.
    *   **List of Values > Type:** Escolha **Shared Component**.
    *   **List of Values > List of Values:** Selecione a `LOV_PROGRAMAS` que criou antes.
    *   **List of Values > Display Extra Values:** Mude para **Off**.
    *   **List of Values > Null Display Value:** Escreva `- Selecione o Programa -`.
5.  **Configurar a Ação Automática (Dynamic Action):**
    Queremos que a App se atualize mal mude o valor no menu.
    *   No painel da esquerda (**Rendering**), clique com o botão direito em cima de `P0_ID_PROGRAMA` e escolha **Create Dynamic Action**.
    *   **Identification > Name:** Escreva `Mudar Contexto Programa`.
    *   No item **True** (por baixo da nova ação no painel esquerdo), clique na ação padrão (**Show**) e mude no painel da direita para **Execute PL/SQL Code**.
    *   **Settings > PL/SQL Code:** Cole o código: `:F_ID_PROGRAMA := :P0_ID_PROGRAMA;`
    *   **Settings > Items to Submit:** Escreva `P0_ID_PROGRAMA`.
    *   **Settings > Items to Return:** Escreva `F_ID_PROGRAMA`.
6.  **Adicionar Refrescamento:**
    *   Clique com o botão direito no item **True** anterior e escolha **Create Action**.
    *   **Identification > Action:** Escolha **Submit Page**.
7.  Clique no botão **Save** (disquete) no canto superior direito.

---

## Task 2: Cockpit de Sincronização Excel (Programa FUTURO)
*Acessível apenas quando `F_ID_PROGRAMA` for o ID do Programa 'FUTURO'.*

### 2.1. Criar a Página do Cockpit
1.  No topo, clique no botão **+** e escolha **Page**.
2.  Escolhe **Blank Page**.
3.  **Page Number:** 10. **Name:** `FUTURO: Cockpit de Importação`.
4.  No painel da direita, procure a secção **Server-Side Condition**:
    *   **Type:** Escolha **Item is NOT NULL**.
    *   **Item:** Selecione `F_ID_PROGRAMA`.
5.  Clique em **Create Page**.

### 2.2. Configurar Exportação para Validação (Region 2)
1.  Na nova página 10, no painel da esquerda, clique com o botão direito em **Body** > **Create Region**.
2.  **Identification > Name:** `Lista para Validação pelos Departamentos`.
3.  **Identification > Type:** Escolha **Interactive Report**.
4.  **Source > Type:** SQL Query. Cole o código:
    ```sql
    SELECT i.ID_Inscricao as "Worker ID",
           e.Nome_Completo as "Nome",
           e.Email, 
           e.UO,
           i.Prioridade_Inicial as "Prioridade Inicial",
           i.Score_Diagnostico as "Resultado Quiz",
           NULL as "Prioridade Final"
    FROM Inscricoes i
    JOIN Entidades e ON i.ID_Entidade = e.ID_Entidade
    WHERE i.ID_Programa = :F_ID_PROGRAMA
      AND i.Estado_Inscricao = 'DIAGNOSTICADO';
    ```
5.  No painel da esquerda, por baixo da região, clique em **Attributes**.
    *   Procure a secção **Download** e garanta que **Excel** está ativo.

---

## Done When
- [ ] O menu de programas aparece no topo de todas as páginas.
- [ ] Ao mudar o programa no menu, a página atualiza-se.
- [ ] A página 10 (Cockpit) só é visível se houver um programa selecionado.
