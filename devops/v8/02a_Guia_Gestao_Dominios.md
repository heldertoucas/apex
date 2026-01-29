# Guia: Gestão de Domínios (Selector Pattern)

**Objetivo:** Criar uma página centralizada para gerir dezenas de tabelas auxiliares (Lookups) sem sobrecarregar a interface.
**Técnica:** Utilizar um **Select List** para escolher qual a tabela ativa e carregar apenas essa Interactive Grid (Server-Side Condition). É mais escalável que Tabs.

---

## Passo 1: Criar a Página Base

1.  **App Builder > Create Page > Blank Page**.
2.  **Name:** `Gestão de Domínios`.
3.  **Page Number:** (Ex: 90).
4.  **Navigation:** Adicionar ao menu Administração.

---

## Passo 2: Criar o Filtro "Automágico"

Vamos criar um filtro que deteta automaticamente todas as Tabelas (Grids) que colocar nesta página.

1.  **Região de Filtro:**
    *   Create Region. Title: `Seleção`.
2.  **Item de Seleção:**
    *   Create Page Item: `P90_TABELA_ALVO`.
    *   **Type:** `Select List`.
3.  **Configurar a Lista (Dynamic LOV):**
    *   **Type:** `SQL Query`.
    *   **SQL Query:** (Copie exatamente)
        ```sql
        SELECT region_name as d, region_name as r
        FROM apex_application_page_regions
        WHERE page_id = :APP_PAGE_ID
          AND source_type_code = 'NATIVE_IG' -- Detecta apenas Interactive Grids
        ORDER BY 1
        ```
    *   **Display Null Value:** `No`.
4.  **Comportamento:**
    *   **Page Action on Selection:** `Submit Page`.

*O que isto faz:* Sempre que adicionar uma nova Interactive Grid à página, ela aparece automaticamente na lista!

---

## Passo 3: Criar as Grids (e ligar ao filtro)

Agora crie as suas tabelas normalmente. A única regra é: **O título da Região deve ser igual à opção do menu.**

### 3.1. Grid 1: Equipamentos
1.  **Create Region**.
    *   **Title:** `Equipamentos` (Nome exato que aparecerá na lista).
    *   **Type:** `Interactive Grid`.
    *   **Source:** Tabela `TIPOS_EQUIPAMENTO`.
2.  **Configurar Visibilidade (Condition):**
    *   Vá a **Server-Side Condition**.
    *   **Type:** `PL/SQL Expression`.
    *   **Expression:** `:P90_TABELA_ALVO = 'Equipamentos' OR :P90_TABELA_ALVO IS NULL`
    *   *(Nota: O "OR IS NULL" garante que a primeira tabela aparece se nada estiver selecionado)*

### 3.2. Grid 2: Locais
1.  **Create Region**.
    *   **Title:** `Locais`.
    *   **Source:** Tabela `LOCAIS`.
2.  **Configurar Visibilidade:**
    *   **Type:** `PL/SQL Expression`.
    *   **Expression:** `:P90_TABELA_ALVO = 'Locais'`

*(Para adicionar mais tabelas, basta criar a região e colocar a condição com o nome dela. O menú atualiza-se sozinho!)*

---

## Passo 4: Limpar a Interface (Opcional)

Para que não pareça que a página "salta" a cada refresh:

1.  Selecione a Região `Seleção` (Passo 2).
2.  **Template Options:** Remova bordas ou títulos se quiser algo mais limpo ("Blank with Attributes" ou "Hero").
3.  Pode colocar o select list como `Pill Button` (Template Options do Item) se tiver poucas opções, ou manter como Dropdown se tiver muitas.

---

## Porquê esta abordagem?
*   **Performance:** O APEX só carrega os dados da tabela que o utilizador pediu. Se usasse Tabs, o "Page Load" ficaria mais lento com 20 grids.
*   **Escalabilidade:** Para adicionar uma nova tabela, basta adicionar uma linha na LOV e criar a Região nova.
