# User Experience Story: Sistema de Comunicação e Templates

**Persona:** Ana, Coordenadora Pedagógica.
**Objetivo:** Garantir que todos os formandos recebem informações consistentes e personalizadas, sem ter de escrever emails manuais repetitivos.

---

## Cenário 1: Configuração do Template (O "Setup")

1.  **Acesso:** A Ana acede ao menu **"Administração" > "Modelos de Comunicação"**.
2.  **Visualização:** Ela vê uma lista dos templates existentes (ex: "Boas-vindas", "Aviso de Falta", "Certificado Disponível").
3.  **Edição:** Ela decide melhorar o email de "Boas-vindas". Clica no lápis para editar.
4.  **Interface de Edição:**
    *   **Assunto:** Ela altera de "Bem-vindo" para "Bem-vindo ao curso de #CURSO# - Importante!".
    *   **Corpo (Rich Text):** Ela vê um editor visual (CKEditor/TinyMCE).
    *   **Placeholders:** Do lado direito, existe uma "Cábula de Variáveis" que lhe diz que pode usar tags como `#NOME_ALUNO#`, `#DATA_INICIO#`, `#LOCAL#`.
    *   **Ação:** Ela escreve: "Olá #NOME_ALUNO#, vimos confirmar a tua inscrição na turma #TURMA# que inicia a #DATA_INICIO# no #LOCAL#."
5.  **Validação:** Ao gravar, o sistema valida se o HTML é seguro e guarda a alteração.

---

## Cenário 2: Envio em Massa (A "Execução")

1.  **Contexto:** A Ana acabou de fechar a turma "Informática Básica - Jan 2026".
2.  **Ação:** Ela vai ao menu **"Gestão Formativa" > "Turmas"** e entra na ficha da turma.
3.  **Comando:** No topo da ficha da turma, clica no botão **"Notificar Turma"**.
4.  **Wizard de Envio:**
    *   **Passo 1 (Escolha do Modelo):** Aparece uma popup a perguntar "Que mensagem deseja enviar?". Ela escolhe "Boas-vindas" numa lista (que lê da tabela `Modelos_Comunicacao`).
    *   **Passo 2 (Previsão):** O sistema mostra uma pré-visualização da mensagem com os dados do *primeiro* aluno da lista substituídos, para ela confirmar que os placeholders funcionam. Ex: "Olá *João Silva*, vimos confirmar..."
    *   **Passo 3 (Seleção de Destinatários):** Ela vê a lista dos 20 alunos com checkboxes.
    *   **Passo 4 (Envio ou Agendamento):** O sistema pergunta "Quando enviar?".
        *   Opção A: "Agora".
        *   Opção B: "Agendar para..." (Ela escolhe "Segunda-feira às 09:00").
5.  **Confirmação:** Ela clica em "Agendar".
6.  **Feedback:** O sistema informa: "19 emails agendados para 2026-02-02 09:00."

---

## Cenário 3: O "Piloto Automático" (Ciclo de Vida)

1.  **Configuração:** A Ana sabe que o sistema está configurado para reagir a eventos.
2.  **Inscrição:** Quando um aluno se inscreve no site, recebe imediatamente o template `CONFIRMACAO_INSCRICAO` sem intervenção da Ana.
3.  **Lembrete Automático:** O sistema verifica todas as noites as turmas que começam "Amanhã" e envia o template `LEMBRETE_INICIO` com as coordenadas do local.
4.  **Conclusão:** No dia em que a turma termina (Data Fim), o sistema envia automaticamente o email de `AVALIACAO_SATISFACAO` com o link para o inquérito.
5.  **A Visibilidade:** A Ana pode consultar o menu **"Log de Comunicações"** para ver o que o "robô" enviou em nome da Academia, garantindo que ninguém ficou esquecido.

---

## Estratégia Técnica (Queue & Triggers)

Para suportar isto, a implementação deve incluir:

1.  **Fila de Envio (`Log_Emails`):** Tabela central onde *todos* os emails aterram antes de sair. Tem campos `Data_Agendada` e `Estado` ('PENDENTE', 'ENVIADO', 'ERRO').
2.  **Agendador (Scheduler):** Um Job de base de dados que corre a cada 15/30 mins, pega nos emails 'PENDENTE' com `Data_Agendada <= AGORA` e despacha.
3.  **Gatilhos de Evento:**
    *   *On-Event:* Procedure de inscrição chama `Enqueue_Email`.
    *   *Time-Based:* Job noturno verifica regras (ex: `Data_Inicio - 1`) e gera emails para a fila.

---

## Cenário 4: A Exceção (Overrides por Curso)

1.  **Problema:** O curso de "Cibersegurança" tem requisitos especiais e o email de "Boas-vindas" padrão não serve.
2.  **Solução:** A Ana cria um **novo** modelo de comunicação.
    *   **Código:** `BOAS_VINDAS` (O mesmo do padrão).
    *   **Curso:** Seleciona "Cibersegurança Avançada".
    *   **Conteúdo:** Escreve o texto específico.
3.  **Resultado:**
    *   Quando um aluno se inscreve em "Excel", o sistema usa o `BOAS_VINDAS` global (onde Curso = NULL).
    *   Quando um aluno se inscreve em "Cibersegurança", o sistema deteta a regra específica e usa esse novo template.


---

## Requisitos Levantados por esta História
Para que isto funcione, o Plano de Implementação precisa de garantir:

1.  **Tabela `Modelos_Comunicacao`:** Precisa de suportar CLOB para o HTML e um campo para o "Código" (ex: `CONFIRMACAO_TURMA`) para que o sistema saiba que templates mostrar em que contexto.
2.  **Placeholders Dinâmicos:** O procedimento PL/SQL de envio tem de ser capaz de fazer *Search & Replace* inteligente num CLOB.
3.  **Contexto de Envio:** Precisamos de saber se o envio é "Por Turma", "Por Aluno" ou "Por Entidade", pois os placeholders disponíveis mudam (ex: `#NOTA_FINAL#` só faz sentido se tivermos contexto de Matrícula).
