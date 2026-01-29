# Guia de Implementação: Importação de Dados (Staging)

**Objetivo:** Permitir importar ficheiros Excel com segurança, validando dados (como "Cursos" inexistentes) antes de gravar.
**Ficheiros Necessários:** `08_Staging.sql` (Já criado).

---

## Passo 1: Preparar a Base de Dados

1.  Aceda ao **APEX > SQL Workshop > SQL Scripts**.
2.  Faça **Upload** do ficheiro `08_Staging.sql` que criei para si.
3.  Clique em **Run** para criar a tabela de Staging e a lógica de validação.

*O que isto fez:* Criei uma tabela "Purgatório" (`Staging_Importacao`) e um "Cérebro" (`PKG_IMPORTACAO`) que sabe validar emails e cursos.

---

## Passo 2: Configurar a Definição de Carga (Data Load Definition)

O erro "Please select a data load definition" acontece porque precisamos de ensinar o APEX a mapear o Excel *antes* de criar a página.

1.  Aceda a **Shared Components** (Componentes Partilhados).
2.  Na secção **Data References**, clique em **Data Load Definitions**.
3.  Clique em **Create**.
4.  **Wizard de Definição:**
    *   **Name:** `Definicao_Importacao_Candidatos`.
    *   **Type:** `Table`.
    *   **Table Name:** `STAGING_IMPORTACAO`.
    *   **Unique Column:** `EMAIL_EXCEL` (Isto previne carregar o mesmo ficheiro 2 vezes se não quisermos, ou ajuda a identificar).
5.  **Add/Edit Columns (Mapeamento):**
    *   Certifique-se que adiciona **apenas** estas colunas (remova as outras se virem auto-selecionadas):
        *   `NOME_EXCEL`
        *   `EMAIL_EXCEL`
        *   `CURSO_EXCEL`
        *   `NIF_EXCEL`
        *   `GENERO_EXCEL`
        *   `TIPO_DOC_EXCEL`
        *   `NUM_DOC_EXCEL`
        *   `SIT_PROF_EXCEL`
        *   `QUALIFICACAO_EXCEL` (Opcional - Ex: "Licenciatura")
        *   `DATA_INTERESSE_EXCEL` (Opcional - Se vazio, assume Hoje)
        *   `DIAGNOSTICO_EXCEL` (Opcional - Resultado de testes/questionários)
6.  Clique em **Create Data Load Definition**.

---

## Passo 2B: Criar a Página de Importação

Agora sim, podemos criar a página visual.

1.  **App Builder > Create Page > Data Loading**.
2.  **Definições:**
    *   **Page Number:** (Ex: 100).
    *   **Name:** `Importação de Candidatos`.
3.  **Definition:**
    *   Agora, no dropdown "Data Load Definition", já vai aparecer a **`Definicao_Importacao_Candidatos`** que criou antes! Selecione-a.
4.  Avance e conclua o wizard (**Create**).

*Resultado:* O APEX criou 4 páginas para si (Upload, Map, Preview, Finish). Quando o utilizador carregar o Excel, os dados vão para a tabela `STAGING_IMPORTACAO`.

---

## Passo 3: Criar o "Cockpit de Validação" (A Grelha de Correção)

Aqui é onde vemos os erros e corrigimos antes de gravar a sério.

1.  **Create Page > Interactive Grid**.
    *   **Name:** `Validar Importação`.
    *   **Page Number:** (Ex: 105).
    *   **Table:** `STAGING_IMPORTACAO`.
2.  **Configurar a Grid (Visual):**
    *   **Columns to Hide:** `ID_Staging`, `Data_Upload`, `Utilizador`.
    *   **Columns Read-Only:** `Mensagem_Erro`, `Linha_Valida` (coloque como Type: Display Only).
    *   **Validation Highlight:** Selecione a coluna `Mensagem_Erro` e ative *Highlight* a vermelho se não estiver nula, para chamar a atenção.
3.  **Tornar Editável (Para corrigir erros):**
    *   **Attributes > Edit > Enable:** Yes.
    *   Deixe o utilizador editar `CURSO_EXCEL`, `EMAIL_EXCEL`, etc.
    *   **Dica Pro:** No campo `Curso_Excel`, pode mudar o Type para **Select List** (baseado na tabela `Cursos`) para facilitar a correção!

---

## Passo 4: O Botão Mágico "Processar"

Finalmente, o botão que move os dados válidos para o sistema real.

1.  Na página **Validar Importação** (105), crie um botão na Toolbar (Ex: `PROCESSAR`).
2.  **Create Process (Page Processing):**
    *   **Name:** `Executar Importação`.
    *   **Type:** `Execute Code`.
    *   **PL/SQL Code:**
        ```sql
        PKG_IMPORTACAO.Processar_Staging;
        ```
    *   **Success Message:** "Dados processados! Linhas com erro mantidas para correção."
3.  **Comportamento:**
    *   Quando clica, o sistema verifica tudo. Se estiver OK, move para a tabela de Alunos. Se não, atualiza a coluna `Mensagem_Erro` na grid.

---

## Passo 5: Testar

1.  Crie um Excel simples com: `Nome Completo`, `Email`, `Curso`.
2.  Coloque um Curso que **não existe** (ex: "Curso Fantasma").
3.  Use o Wizard (Passo 2) para carregar.
4.  Vá à Página de Validação (Passo 3).
5.  Verá o erro. Corrija o nome do curso na Grid.
6.  Clique em "Processar".
7.  Verifique se o aluno apareceu na página de "Pessoas".
