# Manual de Implementação - Capítulo 8: UX e Polimento Final (Detalhado)
**Aplicação:** Academia Digital  
**Versão do Guia:** 3.0 (Passo-a-Passo Beginner Friendly)  
**Objetivo:** Tornar a aplicação profissional, intuitiva e fácil de navegar. Foco na "Home Page" (Dashboard) e na organização dos menus.

---

## Introdução
Neste capítulo final, não vamos criar tabelas novas. Vamos "arrumar a casa".
1.  **Dashboard:** Criar um painel de controlo na página inicial.
2.  **Navegação:** Organizar o menu lateral.
3.  **Usabilidade:** Adicionar botões "Voltar" e melhorar títulos.
4.  **Visual:** Aplicar o esquema de cores da instituição.

---

## Parte 1: Dashboard (Página Inicial)

Atualmente a sua "Home" está vazia. Vamos transformá-la num painel de gestão.

### Passo 1.1: KPI Cards (Indicadores Chave)
Vamos mostrar 3 cartões no topo: "Turmas a Decorrer", "Alunos Ativos" e "Faturas Pendentes".

1.  **Editar a Página:**
    *   Vá à **Page 1 (Home)**.
2.  **Criar Região:**
    *   Na árvore (Rendering), clique com o botão direito em **Body** > **Create Region**.
    *   **Title:** `Indicadores`.
    *   **Type:** `Cards`.
    *   **Source > Location:** `Local Database`.
    *   **Source > Type:** `SQL Query`.
    *   **SQL Query:** (Copie com atenção - note o uso de `ID_Estado_Turma`)
        ```sql
        SELECT 'Turmas a Decorrer' as LABEL, 
               COUNT(*) as VALUE, 
               'fa-graduation-cap' as ICON, 
               'u-color-1' as COLOR 
          FROM Turmas 
         WHERE ID_Estado_Turma IN (SELECT ID_Estado_Turma FROM Tipos_Estado_Turma WHERE Codigo='DECORRER')
        UNION ALL
        SELECT 'Alunos Ativos', 
               COUNT(*), 
               'fa-users', 
               'u-color-2' 
          FROM Entidades e
          JOIN Papeis_Entidade p ON e.ID_Entidade = p.ID_Entidade
         WHERE e.Ativo='S' AND p.Codigo_Papel='FORMANDO'
        UNION ALL
        SELECT 'Faturas Pendentes', 
               COUNT(*), 
               'fa-euro', 
               'u-color-9' 
          FROM Faturas_Formadores 
         WHERE Estado='EMITIDA'
        ```
3.  **Configurar os Atributos dos Cards:**
    *   Com a região `Indicadores` selecionada, vá ao separador **Attributes** (painel direito).
    *   **Card:**
        *   **Primary Key Column:** (Deixe vazio ou selecione LABEL se obrigatório).
        *   **Title Column:** `LABEL`.
        *   **Body Column:** (Vazio).
        *   **Icon Source:** `Icon Class Column`.
        *   **Icon Class Column:** `ICON`.
        *   **Badge Column:** `VALUE`.
    *   *(Dica: Para um visual mais moderno, em **Template Options**, escolha Style: **Compact**).*

### Passo 1.2: Gráfico de Evolução
Vamos mostrar um gráfico de barras com as matrículas por mês.

1.  **Criar Região:**
    *   Right-click em **Body** > **Create Region**.
    *   **Title:** `Evolução de Matrículas`.
    *   **Type:** `Chart`.
2.  **Configurar o Gráfico:**
    *   Expanda a região na árvore e clique em **New** (dentro de Series).
    *   **Source > SQL Query:**
        ```sql
        SELECT TO_CHAR(Data_Inscricao, 'YYYY-MM') as MES, 
               COUNT(*) as QTD
          FROM Matriculas
         GROUP BY TO_CHAR(Data_Inscricao, 'YYYY-MM')
         ORDER BY 1
        ```
    *   **Column Mapping:**
        *   **Label:** `MES`.
        *   **Value:** `QTD`.
3.  **Ajustes Visuais (Attributes):**
    *   Clique na região `Evolução de Matrículas`.
    *   Vá a **Attributes**.
    *   **Type:** `Bar`.
    *   **Appearance > Orientation:** `Vertical`.

---

## Parte 2: Navegação e Menus

O APEX adiciona tudo ao menu automaticamente. Vamos organizar por categorias.

### Passo 2.1: Abrir o Editor de Menu
1.  No topo do App Builder, clique em **Shared Components**.
2.  Em "Navigation", clique em **Navigation Menu**.
3.  Clique em **Desktop Navigation Menu**.

### Passo 2.2: Criar as "Pastas" (Categorias)
Vamos criar 4 entradas "Pai" que não clicam em nada (só abrem o submenu).

1.  Clique **Create Entry**.
    *   **Parent Entry:** (Vazio - Root).
    *   **Image/Class:** `fa-graduation-cap`
    *   **List Entry Label:** `Pedagógico`.
    *   **Target type:** `No Target` (importante!).
    *   Clique **Create**.
2.  Repita para **Catálogo** (`fa-book`), **Administrativo** (`fa-briefcase`) e **Configuração** (`fa-cogs`).

### Passo 2.3: Arrastar e Organizar
Agora, reorganize as páginas existentes (drag & drop) para dentro destas pastas (indentado à direita):

*   **PEDAGÓGICO:**
    *   Turmas (Dashboard)
    *   Minhas Turmas (Card View para Formadores)
    *   Sessões
*   **CATÁLOGO:**
    *   Cursos
    *   Módulos
    *   Programas
*   **ADMINISTRATIVO:**
    *   Entidades (Pessoas)
    *   Controlo de Faturação
    *   Equipamentos Alocados
    *   Pré-Inscrições (se existir)
*   **CONFIGURAÇÃO:**
    *   Locais
    *   Domínios / Lookups

Clique **Apply Changes**. Execute a App para ver a diferença!

---

## Parte 3: Usabilidade (Botão Voltar)

Muitas vezes entramos num detalhe (ex: "Sessões da Turma") e queremos voltar à lista anterior ("Minhas Turmas") sem usar o menu lateral.

### Passo 3.1: Adicionar Botão "Voltar" (Exemplo em Sessões)
Vamos aplicar isto na página **Sessões** (ou qualquer página "Filha").

1.  Vá à página `Sessões` (via Page Designer).
2.  **Criar Região de Botões:**
    *   Na posição **Breadcrumb Bar**, verifique se já existe uma região. Se não, crie uma região `Static Content` chamada `Navegação` na posição `After Header` ou `Breadcrumb Bar`.
    *   *(Normalmente usamos a posição "Region Body" com Template "Blank with Attributes" no topo, ou a "Breadcrumb Bar").*
3.  **Criar o Botão:**
    *   Create Button.
    *   **Name:** `BTN_VOLTAR`.
    *   **Label:** `Voltar`.
    *   **Position:** `Previous` (ou `Copy` region position). Se usar a *Breadcrumb Bar*, ponha na posição `Create` mas com alinhamento à esquerda se possível, ou simplesmente `Right of Region`.
    *   **Icon:** `fa-arrow-left`.
4.  **Ação do Botão:**
    *   **Behavior > Action:** `Redirect to Page in this Application`.
    *   **Target:** Página `Minhas Turmas` (ex: Pagina 20).
    *   **Clear Cache:** (Número da página Minhas Turmas).

*(Repita esta lógica para páginas profundas como "Editar Fatura", apontando para "Lista de Faturas".)*

---

## Parte 4: Refinamento de Links (Crucial)

No Capítulo 6, criámos um Card "Minhas Turmas" que deve ligar à página "Sessões". Vamos garantir que isto funciona perfeitamente.

### Passo 4.1: Confirmar o Link "Minhas Turmas" -> "Diário"
1.  Vá à página **Minhas Turmas**.
2.  Vá à Action **Full Card** (o link principal).
3.  **Target:**
    *   **Page:** `Sessões`.
    *   **Set Items:**
        *   *Se a página Diário já tiver o filtro:* `P_ID_TURMA` = `&ID_TURMA.`
        *   *Se ainda não tiver filtro:* Certifique-se apenas que redireciona. (O ideal é adicionar o filtro `WHERE ID_TURMA = :P_ID_TURMA` na query do Diário, criar o Item Hidden `P_ID_TURMA`, e passar o valor aqui).

---

## Parte 5: Polimento Visual (Theme Roller)

1.  Execute a aplicação.
2.  Na barra de developer (fundo), clique em **Theme Roller**.
3.  Experimente alterar o **Redwood Light** (ou Vita) para cores que goste mais.
4.  Mude o **Header Accent** para a cor principal da sua marca.
5.  Clique **Save As** e defina como "Estilo Oficial".

---

## Conclusão
A sua aplicação está pronta!
*   Tem dados reais (ou quase).
*   Tem navegação lógica.
*   Tem indicadores de gestão na entrada.
*   Tem fluxos funcionais para Alunos, Formadores e Administrativos.

**Seguintes Passos:** Fazer uma demonstração ao cliente (ou ao User)!
