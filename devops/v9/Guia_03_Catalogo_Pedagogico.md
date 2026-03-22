# Manual de Implementação APEX (v9) - Capítulo 3: Catálogo Pedagógico e Medalhas
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Estruturar a oferta formativa hierárquica (Programas > Cursos > Módulos) e ligar o sistema de avaliação baseada em Competências e Medalhas (Open Badges).

---

## 1. Visão Geral da Arquitetura Pedagógica (v9)
No SGUF v9, a estrutura é rigidamente hierárquica mas altamente descritiva:
*   **Programas:** Agrupadores macro (ex: "Passaporte Competências Digitais").
*   **Cursos:** A unidade de formação certificável. Contêm `CLOBs` ricos para Metodologias e Recursos.
*   **Módulos:** Unidades fracionárias do Curso com `Carga_Horaria`.
*   **Competências:** O referencial base (DigComp 2.2). Associam-se aos Módulos (N:M).
*   **Medalhas:** Micro-credenciais gráficas associadas a competências.

---

## 2. Bibliotecas Base: Competências e Medalhas
Antes de criar os Cursos, precisamos de criar os "bancos" globais de onde a formação se irá abastecer.

### 2.1. O Catálogo Global de Medalhas (Open Badges)
1.  No App Builder, clique em **Create Page** > **Report** > **Interactive Grid**.
2.  **Page Name:** `Catálogo Global de Medalhas`.
3.  **Data Source > Table Name:** `CATALOGO_MEDALHAS`.
4.  **Editing > Enable Editing:** Clique no interruptor para **On**.
5.  Clique em **Create Page**.
6.  **Configurar Pré-visualização de Imagem:**
    *   No Page Designer, no painel esquerdo (**Rendering**), expanda a região > **Columns**.
    *   Clique com o botão direito em **Columns** > **Create Column**.
    *   **Identification > Name:** `PREVIEW_MEDALHA`.
    *   **Identification > Type:** `Display Image`.
    *   **Source > Type:** `Database Column` | **Column:** `URL_IMAGEM`.
    *   **Appearance > CSS Classes:** `u-color-1` (opcional).

### 2.2. O Banco Global de Competências
1.  **Create Page** > **Report** > **Interactive Grid**.
2.  **Page Name:** `Banco Global de Competências`.
3.  **Table Name:** `CATALOGO_COMPETENCIAS`.
4.  **Editing > Enable Editing:** **On**.
5.  Clique em **Create Page**.
6.  **Configurar Colunas Pedagógicas:**
    *   Selecione a coluna `ID_AREA_COMPETENCIA`. No painel direito, mude **Type** para `Select List`.
    *   **List of Values > List of Values:** `LOV_TIPOS_AREA_COMPETENCIA` (criada no Cap. 1).
    *   Selecione a coluna `ID_NIVEL_PROFICIENCIA`. Mude **Type** para `Select List`.
    *   **List of Values > List of Values:** `LOV_TIPOS_NIVEL_PROFICIENCIA`.

---

## 3. Gestão Hierárquica: Programas e Cursos
A verdadeira gestão operacional do Coordenador Pedagógico.

### 3.1. Gestão de Programas
1.  **Create Page** > **Report** > **Interactive Report**.
2.  **Page Name:** `Gestão de Programas`.
3.  **Table Name:** `PROGRAMAS`.
4.  **Include Form Page:** Marque como **On**.
5.  Clique em **Create Page**.

### 3.2. A Ficha do Curso (Master-Detail)
1.  **Create Page** > **Master-Detail** > **Stacked**.
2.  **Master Source:** `Local Database` | **Table:** `CURSOS` | **PK:** `ID_CURSO`.
3.  **Detail Source:** `Local Database` | **Table:** `MODULOS` | **FK:** `ID_CURSO`.
4.  **Page Name:** `Catálogo de Cursos`.
5.  Clique em **Create Page**.

### 3.3. Refatorar a Interface do Curso (Abas)
1.  No Page Designer, selecione a região **Curso** (Master).
2.  No painel direito, mude **Appearance > Template** para **Tabs Container**.
3.  Crie 3 Sub-regiões (Abas) clicando com o direito na região **Curso**:
    *   **Identificação:** Mova para aqui `P_NOME`, `P_CODIGO`, `P_ID_PROGRAMA`, `P_CARGA_HORARIA`, `P_MODALIDADE`.
    *   **Metodologia:** Mova para aqui `P_OBJETIVOS_GERAIS`, `P_METODOLOGIA_FORMACAO`, `P_RECURSOS_DIDATICOS`.
        *   **Ajuste:** Mude o **Type** destes 3 campos para **Rich Text Editor**.
    *   **Configuração SIGO:** Mova `P_NOME_CURSO_SIGO`.

---

## 4. O Coração Pedagógico: Módulo -> Competências (N:M)
Ligação crítica para que o sistema saiba que competências o formando está a adquirir em cada módulo.

### 4.1. Criar o Modal de Associação
1.  **Create Page** > **Blank Page**.
2.  **Page Name:** `Competências do Módulo`.
3.  **Page Mode:** Escolha **Modal Dialog**.
4.  Clique em **Create Page**.
5.  **Criar o Filtro e a Grid:**
    *   Crie um item na região **Breadcrumb Bar**: `P_ID_MODULO` (**Hidden**).
    *   No **Body**, crie uma região do tipo **Interactive Grid**.
    *   **Name:** `Lista de Competências Trabalhadas`.
    *   **Source > Type:** `SQL Query`.
    *   **SQL Query:** `SELECT ID_MODULO_COMP, ID_MODULO, ID_COMPETENCIA, OBRIGATORIO FROM MODULO_COMPETENCIAS WHERE ID_MODULO = :P_ID_MODULO`.
    *   **Editing > Enable Editing:** **On**.
6.  **Configurar Colunas da Grid:**
    *   `ID_MODULO`: Mude para **Hidden**. **Default > Type:** `Item` | **Item:** `P_ID_MODULO`.
    *   `ID_COMPETENCIA`: Mude para **Popup LOV**.
        *   **LOV > Type:** `SQL Query`.
        *   **SQL Query:** `SELECT Nome as d, ID_Competencia as r FROM Catalogo_Competencias ORDER BY 1`.
    *   `OBRIGATORIO`: Mude para **Switch** (On Value: `S`, Off Value: `N`).

### 4.2. Ligar o Catálogo de Cursos ao Modal
1.  Volte à página do **Catálogo de Cursos** (Capítulo 3.2).
2.  No painel esquerdo, expanda a região **Módulos** (Detail) > **Columns**.
3.  Clique com o direito em **Columns** > **Create Column**.
    *   **Identification > Name:** `LINK_COMPETENCIAS`.
    *   **Identification > Type:** `Link`.
    *   **Heading:** `Competências`.
4.  **Configurar Destino:**
    *   Clique em **Link > [No Link Defined]**.
    *   **Target > Page:** Selecione a página modal `Competências do Módulo`.
    *   **Set Items:** Name: `P_ID_MODULO` | Value: `&ID_MODULO.`.
    *   **Clear Cache:** Ponha o número da página modal.
5.  **Appearance > Link Icon:** Escreva `fa-tasks`.

---

## Done When
- [ ] O Catálogo de Medalhas exibe uma pré-visualização gráfica da medalha.
- [ ] O Banco de Competências permite selecionar Áreas e Níveis via menus dropdown.
- [ ] A Ficha de Curso está organizada em abas funcionais (Identificação, Metodologia, SIGO).
- [ ] Os campos de Metodologia usam o editor de texto rico (Rich Text).
- [ ] É possível abrir a janela modal de competências a partir de qualquer módulo do curso e gravar a associação.

**Conclusão Capítulo 3:**
A estrutura pedagógica está montada. O sistema já sabe "o que" é ensinado e "que competências" cada parte do curso confere. No próximo capítulo, vamos instanciar esta oferta em Turmas e gerir as Matrículas.
