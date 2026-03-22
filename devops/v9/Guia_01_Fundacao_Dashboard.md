# Manual de Implementação APEX (v9) - Capítulo 1: Fundação e Dashboard Híbrido
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Configurar o ambiente APEX, ligar o modelo de dados v9 e preparar o ecrã de entrada (Dashboard Híbrido).

---

## 1. Configuração Inicial do Ambiente

Garantir que o fuso horário e os formatos de data do Oracle APEX estão ajustados a Portugal, algo crítico para o motor de comunicações e para as datas do SIGO.

### 1.1. Preferências do Utilizador
1.  **Login:** Aceda ao seu Workspace Oracle APEX.
2.  **Definir Timezone e Formatos:**
    *   No canto superior direito, clique no seu nome de utilizador > **Edit Profile**.
    *   **Default Date Format:** Escreva `DD/MM/YYYY`. (Importante ter as barras em vez de traços para facilitar a leitura em PT).
    *   **Default Timestamp Time Zone:** Selecione `Europe/Lisbon`.
    *   Clique em **Apply Changes**.

---

## 2. Criação da Aplicação Base

Com o novo modelo de dados v9 totalmente alojado na base de dados (Scripts 01 a 08), vamos criar a camada visual que vai interagir com ele.

### 2.1. Iniciar o Wizard
1.  **Aceda ao App Builder:** Na página inicial, clique em **App Builder**.
2.  **Criar Nova App:** Clique no botão azul **Create** > **New Application**.

### 2.2. Definir Parâmetros Principais
No ecrã "Create an Application":
1.  **Name:** Escreva `SGUF V9 - Passaporte Digital`.
2.  **Appearance:**
    *   Verifique se o tema é **Vita** (ou *Redwood Light* nas versões mais recentes).
    *   Clique no ícone de "Settings".
    *   **Navigation:** Escolha **Side Menu** (Menu Lateral - acomoda melhor os múltiplos domínios do sistema).
    *   **App Icon:** Escolha um ícone relacionado com educação (ex: `fa-graduation-cap`).
    *   Clique **Save Changes**.
3.  **Pages:** Deixe apenas as páginas padrão (*Home*, *Login* e *Administration*).
4.  **Features:** Garanta que as seguintes caixas estão ativas:
    *   [x] **Install PWA** (Permite usar a app em telemóveis/tablets nas salas de formação).
    *   [x] **Access Control** (Controlo de níveis de utilizador ADMIN/READER).
    *   [x] **Theme Style Selection**.
5.  **Finalizar:** Clique **Create Application**. O esqueleto está feito.

---

> [!IMPORTANT]
> **PARE AQUI!** Antes de avançar para a criação de LOVs ou do Dashboard, deve agora abrir e executar o **`Guia_00_MultiPrograma_FUTURO.md`**.
> Este passo é crítico para configurar a filtragem global (Contexto de Programa) que será utilizada em todas as páginas e componentes que irá criar a seguir.

---

## 3. Preparação dos Domínios (List of Values - LOVs)

O APEX usa *Shared Components* para não passarmos a vida a escrever `SELECT * FROM Tipos_Genero`. Vamos mapear as tabelas de Lookup criadas no script `01_lookup_tables.sql` da sua base de dados v9.

### 3.1. Criar LOVs baseadas nas tabelas Tipo
1. Na página inicial da sua App no App Builder, clique em **Shared Components**.
2. Em *Other Components*, clique em **List of Values**.
3. Clique em **Create**.
4. Siga este processo, repetindo-o para cada tabela de lookup listada abaixo:
    *   **Create List of Values:** `From Scratch` > Next.
    *   **Name:** `LOV_TIPOS_GENERO` (por exemplo) | **Type:** `Dynamic` > Next.
    *   **Table / View Name:** Escreva a tabela correspondente (ex: `Tipos_Genero`) > Next.
    *   **Return Column:** `ID_GENERO` (A chave primária).
    *   **Display Column:** `DESCRICAO` (O texto legível).
    *   Clique **Create**.

**Tabelas Críticas a Mapear como LOVs:**
- `Tipos_Genero` -> Retorna `ID_Genero`, Exibe `Descricao`
- `Tipos_Doc_Identificacao` -> Retorna `ID_Tipo_Doc`, Exibe `Codigo` ou `Descricao`
- `Tipos_De_Qualificacao` -> Retorna `ID_Qualificacao`, Exibe `Descricao` (Adicionar `ORDER BY Ordem` na query final da LOV).
- `Tipos_Situacao_Profissional` -> Retorna `ID_Situacao_Prof`, Exibe `Descricao`.
- `Tipos_Estado_Curso`, `Tipos_Estado_Turma`, `Tipos_Estado_Matricula`.
- **(Nova na v9)** `Tipos_Estado_Presenca` -> Retorna `ID_Estado_Presenca`, Exibe `Descricao` (Terá os estados 'P', 'F', 'FJ', e o novo 'CV' Convocado).

---

## 4. O Dashboard Híbrido (Triagem vs Operação)

O SGUF V9 distingue-se por ser Híbrido. O Ecrã Principal (Home, Página 1) vai ser desenhado para dar logo os alertas "Semáforo" aos técnicos (Opção C da UX).

1. Abra a **Página 1 (Home)** no Page Designer.
2. Apague o texto de *welcome* predefinido.
3. No painel da esquerda (Rendering), clique com o botão direito em **Body** > **Create Region**.
4. **Name:** `Métricas Operacionais`.
5. **Type:** `Cards` (Cartões visuais modernos).
6. **SQL Query:** 
   Vamos criar um sumário rápido sobre a saúde dos dados de candidatos:
    ```sql
    SELECT 
        'Inscrições Verdes (Dados Completos)' as TITULO,
        COUNT(i.ID_Inscricao) as VALOR,
        'fa-check-circle' as ICONE,
        'u-success-text' as COR_CSS
    FROM Inscricoes i
    JOIN Entidades e ON i.ID_Entidade = e.ID_Entidade
    WHERE e.NIF IS NOT NULL AND e.ID_Genero IS NOT NULL

    UNION ALL

    SELECT 
        'Inscrições Amarelas (Faltam Dados SIGO)' as TITULO,
        COUNT(i.ID_Inscricao) as VALOR,
        'fa-exclamation-triangle' as ICONE,
        'u-warning-text' as COR_CSS
    FROM Inscricoes i
    JOIN Entidades e ON i.ID_Entidade = e.ID_Entidade
    WHERE e.NIF IS NULL OR e.ID_Genero IS NULL;
    ```
7. No painel da direita, secção **Attributes**, mapeie:
   * **Title Column:** `TITULO`
   * **Badge Column:** `VALOR`
   * **Icon Customization:** `Icon Column` -> `ICONE`
   * **CSS Classes:** `&COR_CSS.` (Para aplicar a cor verde/amarela ao cartão).

---

**Conclusão Capítulo 1:**
O ambiente APEX está pronto. Validou as métricas consoante o planeamento Híbrido (Opção C). O próximo capítulo guirá a criação e visualização das Entidades suportando a triagem manual vs self-service.
