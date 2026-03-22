# Manual de Implementação APEX (v9) - Capítulo 3: Catálogo Pedagógico e Medalhas
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Estruturar a oferta formativa hierárquica (Programas > Cursos > Módulos) e ligar o sistema de avaliação baseada em Competências e Medalhas (Open Badges).

---

## 1. Visão Geral da Arquitetura Pedagógica (v9)
No SGUF v9, a estrutura é rigidamente hierárquica mas altamente descritiva (preparada para exportação SIGO e geração de emails robustos):
* **Programas:** Agrupadores macro (ex: "Passaporte Competências Digitais").
* **Cursos:** A unidade de formação certificável (ex: "Criador de Conteúdo"). Contêm `CLOBs` ricos para Metodologias e Recursos.
* **Módulos:** Unidades fracionárias do Curso com `Carga_Horaria`.
* **Competências:** O referencial base (DigComp 2.2). As competências associam-se aos Módulos de forma N:M (usando a tabela `Modulo_Competencias`), permitindo que a mesma competência seja trabalhada em 5 módulos de cursos diferentes.
* **Medalhas:** Micro-credenciais gráficas que se ganham ao atingir competências (tabela `Competencia_Medalhas`).

---

## 2. Bases de Dados "Master": Competências e Medalhas
Antes de criar o ecrã dos Cursos, precisamos de criar as bibliotecas (Bancos) de Competências e Medalhas de onde os Cursos se vão "abastecer".

### 2.1. O Catálogo de Medalhas (Open Badges)
1. **Create Page** > **Report** > **Interactive Grid**.
2. **Page Name:** `Catálogo Global de Medalhas`.
3. **Table Name:** `CATALOGO_MEDALHAS`.
4. **Editing:** Marque *Enable Editing* (não inclua Form Page separada).
5. **Colunas:** Certifique-se que a coluna `CODIGO` está visível e definida como campo obrigatório no ecrã.
6. No **Page Designer**, garanta que a coluna `URL_IMAGEM` é tratada corretamente e, opcionalmente, crie uma coluna extra do tipo **Display Image** que renderize a imagem baseada nesse URL.

### 2.2. O Catálogo Global de Competências
1. **Create Page** > **Report** > **Interactive Grid**.
2. **Page Name:** `Banco Global de Competências`.
3. **Table Name:** `CATALOGO_COMPETENCIAS`.
4. **Editing:** Marque *Enable Editing*.
5. **Colunas:** Inclua a coluna `CODIGO` (ajude o utilizador com um formato tipo 'DIG-01').
6. **Configurar as Listas (LOVs):**
    * Altere a coluna `ID_AREA_COMPETENCIA` para **Select List** (usando a LOV correspondente partilhada).
    * Altere a coluna `ID_NIVEL_PROFICIENCIA` para **Select List**.

---

## 3. Gestão Hierárquica: Programas e Cursos
A verdadeira gestão do dia-a-dia do Coordenador.

### 3.1. Gestão de Programas
Crie um simples Interactive Report + Form para a tabela `PROGRAMAS`. (Nome: `Gestão de Programas`).

### 3.2. A Ficha do Curso (Master-Detail)
1. Vá a **Create Page** > **Master-Detail** > **Stacked**.
2. **Master Source:** Tabela `CURSOS` (PK `ID_CURSO`).
3. **Detail Source:** Tabela `MODULOS` (FK `ID_CURSO`).
4. **Page Name:** `Catálogo de Cursos`.
5. Aceite e clique **Create**.

### 3.3. Melhorar o Formulário do Curso (Abas Visuais)
Como a tabela Cursos tem inúmeros campos ricos, empilhar tudo assusta os utilizadores.
1. Abra a "Ficha de Curso" (Página gerada pelo Wizard).
2. Mude o **Template** da região `Curso` para **Tabs Container**.
3. Crie 3 Sub-regiões (Abas):
    * **Identificação:** Campos `NOME`, `CODIGO`, `ID_PROGRAMA`, `CARGA_HORARIA`, `MODALIDADE`.
    * **Pedagogia:** Transforme `P_OBJETIVOS_GERAIS`, `P_METODOLOGIA_FORMACAO` e `P_RECURSOS_DIDATICOS` em **Rich Text Editor** e coloque-os aqui.
    * **Exportação SIGO:** Coloque `P_NOME_CURSO_SIGO`.
4. As `LOVs` na Aba Identificação (`ID_PROGRAMA`, `ID_ESTADO_CURSO`) devem usar os Shared Components.

---

## 4. O Coração Pedagógico: Módulo -> Competências N:M
Esta é uma associação crítica. Um módulo treina múltiplas competências (podendo umas ser obrigatórias e outras opcionais para aprovação).

### 4.1. Construção do Modal de Associação
1. Crie uma página Nova (**Create Page** > **Blank Page**).
2. **Page Name:** `Competências do Módulo`.
3. **Page Mode:** Mude para **Modal Dialog**.
4. Crie um **Item Oculto** chamado `PXX_ID_MODULO` (onde XX é o nº da página atual) - servirá para apanhar o ID de fora.
5. Crie uma **Interactive Grid**:
    * **Title:** Competências do Módulo.
    * **Table:** `MODULO_COMPETENCIAS`.
    * **Where Clause:** `ID_MODULO = :PXX_ID_MODULO`.
    * **Page Action to Submit:** `PXX_ID_MODULO` (Crítico para a Grid saber filtrar).
6. Nas colunas desta grid:
    * `ID_MODULO`: **Hidden** (Em Default, ponha Type=Item, Item=PXX_ID_MODULO).
    * `ID_COMPETENCIA`: Mude para **Popup LOV**, apontando para uma Query (`SELECT Nome, ID_Competencia FROM Catalogo_Competencias`).
    * `OBRIGATORIO`: Mude para **Switch** ou Select List (S/N).
7. Garanta que Ativa o *Editing* na Grid.

### 4.2. Ligar o Curso ao Modal
1. Volte à página do **Catálogo de Cursos** (Ficha do Curso).
2. Na Grelha de **Módulos** (a parte *Detail* do fundo), crie uma nova coluna Virtual (tipo `None` na Source).
3. **Heading:** `Associar Competências`.
4. **Identification > Type:** `Link`.
5. **Link Target:** 
    * Page: A sua página Modal (criada acima).
    * Set Items: `PXX_ID_MODULO` = `&ID_MODULO.`. (Passa a Chave Primária do Módulo da linha atual para a janela Modal).

**Conclusão Capítulo 3:**
O Coordenador Pedagógico consegue agora desenhar um Curso denso, definir-lhe Módulos, e a cada Módulo associar, linha a linha, quais as Competências do referencial que estão a ser trabalhadas. No próximo Guia, vamos juntar as Entidades (Pessoas) e o Catálogo nas Turmas (A Operação Base).
