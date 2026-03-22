# Manual de Implementação APEX (v9) - Capítulo 5: Automação Central de E-mails
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Implementar o motor de comunicações integrado. O sistema permite desenhar templates HTML, definir regras automáticas (ex: 5 dias antes de uma turma arrancar) e auditar todo o log de envio.

---

## 1. Gestão de Modelos de Comunicação (O HTML)
É aqui que o coordenador define o "texto" dos e-mails usando variáveis (#NOME#, #CURSO#, etc.).

### 1.1. Criar a Página Base
1. **Create Page** > **Report** > **Interactive Report**.
2. **Page Name:** `Modelos de E-mail`.
3. **Table Name:** `MODELOS_COMUNICACAO`.
4. Ative **Include Form Page** e chame-lhe `Editor de Modelo`.
5. Clique **Create**.

### 1.2. Melhorar o Editor
1. Abra a página `Editor de Modelo` no **Page Designer**.
2. Selecione o campo `PXX_CORPO_HTML`.
3. Altere o **Type** para **Rich Text Editor**. Isto permitirá embelezar os textos com formatação sem saber HTML puro.
4. Transforme `PXX_CONTEXTO` num **Select List** (Valores: `ALUNO;ALUNO`, `TURMA;TURMA`).
5. Nas definições da página (`Help Text` ou campo Display Only), explique as variáveis: *"Pode usar as seguintes tags: #NOME#, #CURSO#, #COD_MATRICULA#, #DATA_INICIO#"*. (A lógica por trás da substituição está embebida no `PKG_COMUNICACAO`).

---

## 2. Regras de Comunicação (A Lógica Automática)
A grande novidade da V9. Em vez do utilizador carregar num botão para enviar o lembrete 2 dias antes da aula, o sistema obedece a regras de negócio.

### 2.1. O Ecrã das Regras
1. **Create Page** > **Interactive Grid**.
2. **Page Name:** `Regras de Automação`.
3. **Table Name:** `REGRAS_COMUNICACAO`.
4. Ative **Editing** (Add, Update, Delete).
5. **Configuração de Colunas:**
   * `ID_MODELO`: Transforme numa **Popup LOV**. Query: `SELECT Assunto d, ID_Modelo r FROM Modelos_Comunicacao`.
   * `EVENTO_GATILHO`: Transforme num **Select List**. Valores Estáticos: `STATIC:Nova Inscrição PENDENTE;NOVA_INSCRICAO,Turma a Iniciar;INICIO_TURMA,Turma a Terminar;FIM_TURMA,Conclusão com Sucesso;CONCLUIU_CURSO`.
   * `DIAS_DESLOCAMENTO`: Campo numérico. (Ex: -2 significa "2 dias antes", +1 significa "1 dia depois").

---

## 3. Gestão e Auditoria (O Log de E-mails)
A caixa de saída do SGUF. Onde os gestores confirmam se um e-mail foi realmente enviado ou deu erro de servidor.

1. **Create Page** > **Interactive Report** (SEM Formulário de edição).
2. **Page Name:** `Log de Comunicações`.
3. **SQL Query:**
    ```sql
    SELECT 
        l.ID_Log,
        l.Data_Agendada,
        l.Destinatario,
        l.Assunto,
        mc.Codigo_Ref as "Modelo Usado",
        l.Contexto_Origem,
        
        -- Semáforo UX para o Estado do Email
        CASE 
            WHEN l.Estado = 'PENDENTE' THEN '<span class="u-warning-text"><i class="fa fa-clock-o"></i> Na Fila</span>'
            WHEN l.Estado = 'ENVIADO'  THEN '<span class="u-success-text"><i class="fa fa-paper-plane"></i> Enviado</span>'
            WHEN l.Estado = 'ERRO'     THEN '<span class="u-danger-text"><i class="fa fa-times-circle"></i> Falhou</span>'
        END as "Estado",
        
        l.Data_Envio,
        l.Erro_Msg
    FROM Log_Comunicacoes l
    LEFT JOIN Modelos_Comunicacao mc ON l.ID_Modelo = mc.ID_Modelo
    ORDER BY l.Data_Agendada DESC;
    ```
4. Na coluna `Estado`, certifique-se que desliga a opção **Escape special characters** em **Security**.

---

## 4. Ligar a Ignição: O Processo Automático do APEX (Automations)
Temos as tabelas, as regras e a Package `PKG_COMUNICACAO` (compilada na Base de Dados). Mas quem aperta o gatilho? Vamos usar a funcionalidade de *Automations* do APEX que substitui por completo o DBMS_SCHEDULER.

1. No ecrã inicial da sua aplicação no APEX, clique em **Shared Components**.
2. Na secção *Workflows and Automations*, clique em **Automations**.
3. Clique em **Create**.
4. **Configuração do Motor:**
   * **Name:** `Motor de Disparo de E-mails (SGUF)`.
   * **Type:** `Scheduled`.
   * **Execution Schedule:** Escreva `FREQ=MINUTELY;INTERVAL=5` (ou seja, de 5 em 5 minutos a BD verifica se há algo a enviar).
   * Clique **Next**.
5. **Código PL/SQL da Automação:**
   * **Action Code:** 
     ```sql
     BEGIN
         -- 1. Opcional/Crítico Futuro: Inserir a lógica que varre as "Regras" ativas e insere no LOG para o dia de hoje.
         
         -- 2. Processa a Fila Pendente: Lê a tabela Log e faz o disparo via APEX_MAIL
         PKG_COMUNICACAO.Processar_Fila;
     END;
     ```
6. Clique em **Create**.
7. Na página de detalhes da Automation recém-criada, em **Schedule**, garanta que o **Status** está como `Active`.

**Conclusão Capítulo 5:**
Com a automação ativa, qualquer e-mail inserido na tabela de Logs (manualmente ou via Triggers de regra) com estado `PENDENTE` será injetado pelo APEX na caixa de correio do cidadão a cada 5 minutos. Isto conclui o ecossistema relacional e comunicativo. O próximo (e último) guia foca-se no rescaldo logístico: Dossiers, Faturação e SIGO.
