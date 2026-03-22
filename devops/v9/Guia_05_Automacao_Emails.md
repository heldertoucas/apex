# Manual de Implementação APEX (v9) - Capítulo 5: Automação Central de E-mails
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Implementar o motor de comunicações integrado. O sistema permite desenhar templates HTML, definir regras automáticas (ex: 2 dias antes de uma turma arrancar) e auditar todo o log de envio para garantir que nenhum cidadão fica sem informação.

---

## 1. Gestão de Modelos de Comunicação (Templates HTML)
Definição dos conteúdos base dos e-mails utilizando variáveis dinâmicas (#NOME#, #CURSO#, etc.).

### 1.1. Criar a Página de Modelos
1.  No App Builder, clique em **Create Page** > **Report** > **Interactive Report**.
2.  **Page Name:** `Modelos de Comunicação`.
3.  **Data Source > Table Name:** `MODELOS_COMUNICACAO`.
4.  **Include Form Page:** Ative o interruptor para **On**.
    *   **Form Page Name:** `Editor de Modelo de E-mail`.
5.  Clique em **Create Page**.

### 1.2. Configurar o Editor de Conteúdo Rico
1.  Abra a página **Editor de Modelo de E-mail** no Page Designer.
2.  Selecione o item `P5_CORPO_HTML` (ou o número da sua página).
    *   **Identification > Type:** Mude para **Rich Text Editor**.
    *   **Settings > Toolbar:** Escolha **Full** (permite tabelas, cores e links).
3.  Selecione o item `P5_CONTEXTO`.
    *   **Identification > Type:** `Select List`.
    *   **List of Values > Type:** `Static Values`.
    *   **Static Values:** `STATIC:Candidato;CANDIDATO,Aluno;ALUNO,Turma;TURMA,Geral;GERAL`.
4.  **Ajuda ao Utilizador (Variáveis):**
    *   Crie uma região do tipo **Static Content** ao lado do formulário chamada `Tags Disponíveis`.
    *   **Text:** Escreva: *"Utilize estas tags no Assunto ou Corpo: #NOME#, #CURSO#, #DATA_INICIO#, #LOCAL#, #COD_MATRICULA#."*

---

## 2. Regras de Comunicação (A Lógica Automática)
Configuração de "quando" o sistema deve gerar um e-mail automaticamente com base em eventos de negócio.

### 2.1. Criar a Grelha de Regras
1.  **Create Page** > **Report** > **Interactive Grid**.
2.  **Page Name:** `Regras de Automação`.
3.  **Data Source > Table Name:** `REGRAS_COMUNICACAO`.
4.  **Editing > Enable Editing:** **On**.
5.  Clique em **Create Page**.
6.  **Configurar Colunas Inteligentes:**
    *   Selecione a coluna `ID_MODELO`. Mude **Type** para `Popup LOV`.
        *   **LOV > SQL Query:** `SELECT Assunto d, ID_Modelo r FROM Modelos_Comunicacao ORDER BY 1`.
    *   Selecione a coluna `EVENTO_GATILHO`. Mude **Type** para `Select List`.
        *   **LOV > Static Values:** `STATIC:Nova Inscrição;NOVA_INSCRICAO,Turma a Iniciar;INICIO_TURMA,Turma a Terminar;FIM_TURMA,Certificado Disponível;CERTIFICADO_EMITIDO`.
    *   Selecione a coluna `DIAS_DESLOCAMENTO`.
        *   **Help Text:** *"Ex: -2 para enviar 2 dias antes do evento; 0 para enviar no próprio dia."*

---

## 3. Log e Auditoria (Monitorização de Envios)
Interface para confirmar se as comunicações estão a sair corretamente ou se existem erros de servidor.

### 3.1. Criar o Log de Comunicações
1.  **Create Page** > **Report** > **Interactive Report**.
2.  **Page Name:** `Log de Envios`.
3.  **Source > Type:** `SQL Query`.
4.  **SQL Query:**
    ```sql
    SELECT 
        l.ID_Log,
        l.Data_Agendada,
        l.Destinatario,
        l.Assunto,
        mc.Codigo_Ref as "Modelo",
        l.Contexto_Origem as "Origem",
        
        -- Semáforo de Estado do Email
        CASE 
            WHEN l.Estado = 'PENDENTE' THEN '<span class="u-warning-text"><i class="fa fa-clock-o"></i> Pendente</span>'
            WHEN l.Estado = 'ENVIADO'  THEN '<span class="u-success-text"><i class="fa fa-paper-plane"></i> Enviado</span>'
            WHEN l.Estado = 'ERRO'     THEN '<span class="u-danger-text"><i class="fa fa-times-circle"></i> Erro</span>'
        END as "Estado_Visual",
        
        l.Data_Envio,
        l.Erro_Msg
    FROM Log_Comunicacoes l
    LEFT JOIN Modelos_Comunicacao mc ON l.ID_Modelo = mc.ID_Modelo
    ORDER BY l.Data_Agendada DESC;
    ```
5.  **Ajuste Visual:** Selecione a coluna `Estado_Visual` e desative **Escape special characters**.

---

## 4. O Motor de Disparo (APEX Automations)
Configuração do "cron job" interno do APEX que varre a fila de e-mails e faz o disparo real.

### 4.1. Configurar a Automação
1.  Vá a **Shared Components** > **Workflows and Automations** > **Automations**.
2.  Clique em **Create**.
3.  **Name:** `Motor de Comunicações SGUF`.
4.  **Type:** `Scheduled`.
5.  **Execution Schedule:** `FREQ=MINUTELY;INTERVAL=5` (executa a cada 5 minutos).
6.  Clique em **Next**.
7.  **Source > Type:** `PL/SQL`.
8.  **Source > PL/SQL Code:**
    ```sql
    BEGIN
        -- Chama o package da v9 que processa a substituição de tags e faz o APEX_MAIL.SEND
        PKG_COMUNICACAO.Processar_Fila_Envio;
    END;
    ```
9.  Clique em **Create**.
10. **Ativação Final:** Na página da Automação, garanta que o campo **Status** está em `Active`. Clique em **Save and Run** para testar imediatamente.

---

## Done When
- [ ] O editor de modelos permite formatar texto (negrito, cores, tabelas) via Rich Text.
- [ ] As regras de automação permitem associar modelos a eventos (ex: INICIO_TURMA).
- [ ] O Log de Envios mostra ícones coloridos para os estados Pendente, Enviado e Erro.
- [ ] A Automação em Shared Components está ativa e configurada para 5 minutos.
- [ ] Ao inserir um registo manual em `Log_Comunicacoes` com estado 'PENDENTE', o e-mail é disparado pelo motor (pode validar em *Mail Queue* da instância).

**Conclusão Capítulo 5:**
O SGUF v9 agora comunica autonomamente. O técnico foca-se em gerir as turmas e o sistema encarrega-se de informar os alunos. No último capítulo, fecharemos o ciclo com a Avaliação e Exportação de Resultados.
