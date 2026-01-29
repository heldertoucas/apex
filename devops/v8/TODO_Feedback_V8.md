# TODO: Processamento de Feedback (V8)

Documento de trabalho gerado a partir das observações de testes do Utilizador (26/Jan).

---

## 1. Administração e Configuração
*   **Gestão de Tabelas de Domínio (Lookups)**
    *   [ ] **Criar Páginas:** Criar interfaces (IG Editable) para gestão das tabelas de "Tipos" (Domínio F do modelo de dados), ex: `Tipos_Genero`, `Tipos_Estado_Turma`. Sem isto, o utilizador não consegue configurar as dropdowns.

---

## 2. Gestão de Pessoas (Página "Pessoas")
*   **Funcionalidade de Importação**
    *   [ ] **Botão "Importar":** Adicionar botão na toolbar do relatório de pessoas.
    *   [ ] **Página "Importar Pessoas":** Reativar o requisito de Importação (Excel/CSV) que estava em *stand-by*. Implementar Wizard de upload e validação.
*   **Clarificação de Campos**
    *   [ ] **Campo "Ativo":** Adicionar *Help Text* ou *Tooltip*.
        *   *Definição:* Indica se a pessoa está disponível para novas matrículas/contratações. "Não Ativo" (Soft Delete) remove-a das pesquisas padrão mas mantém o histórico.

---

## 3. Gestão de Turmas (Página "Gestão de Turmas")
*   **Formadores**
    *   [ ] **Múltiplos Formadores:** Verificar se a UI (Master-Detail ou IG) permite adicionar N linhas à sub-tabela `Equipa_Formativa`.
        *   *Explicação:* O modelo suporta M:N. A UI deve refletir isso (não apenas um dropdown único).
*   **Calendarização e Sessões**
    *   [ ] **Clarificar "Gerar Cronograma":** Melhorar a label ou adicionar ajuda.
        *   *Explicação:* É uma automação que cria as sessões (linhas na tabela `Sessoes`) automaticamente entre a Data Início e Fim, baseada num horário padrão (ex: 2ª e 4ª feira).
    *   [ ] **Edição Individual:** Confirmar que a grid de Sessões permite editar a data/hora de cada linha individualmente após a geração.

---

## 4. Matrículas (Página "Matrículas em Massa")
*   **Relatório e Campos**
    *   [ ] **Campos de Interesse:** Adicionar colunas extra ao relatório de candidatos (ex: Área, Nível, Localização).
    *   [ ] **Clarificar "Data de Interesse":** É a data de registo na tabela `Inscricoes` (Pré-inscrição). Renomear para "Data da Candidatura".
*   **Gestão Global**
    *   [ ] **Nova Página "Gestão Global de Matrículas":** Criar um relatório mestre (Interactive Report) que liste *todas* as matrículas de todas as turmas, com filtros avançados e colunas extra.

---

## 5. Portal do Formador (Página "As minhas ações de formação")
*   **UX/UI**
    *   [ ] **Link da Turma:** Alterar o texto do link (ou ícone) para "Abrir".
    *   [ ] **Ordenação:** Remover o `ORDER BY` fixo da query para permitir ordenação pelo utilizador na grid.

---

## 6. Gestão de Aulas (Página "Sessões")
*   **Reestruturação da Página**
    *   [ ] **Filtro de Topo:** Criar região de cabeçalho com os detalhes da sessão (Nome, Data, Hora Início/Fim).
    *   [ ] **Lista de Participantes (Grid):**
        *   Botões/Toggle para "Presença" (Presente/Ausente).
        *   **Lógica de Horas (Dynamic Action):**
            *   Se `Presente` = SIM → `Horas Assistidas` = Duração da Sessão (mas editável).
            *   Se `Presente` = NÃO → `Horas Assistidas` = 0.
*   **Funcionalidades**
    *   [ ] **Clarificar "Gerar Lista de Participantes":**
        *   *Explicação:* Botão que corre o processo para copiar todos os alunos com matrícula ativa na turma para a tabela de presenças desta sessão (Prevenir ter de adicionar alunos linha-a-linha).

---

## 7. Avaliação (Página "Avaliação")
*   **Correção de Bug**
    *   [ ] **Refresh:** Corrigir a interação do Select List da Turma. Ao mudar a turma, a grid de notas deve atualizar (Submit on change ou Dynamic Action 'Refresh').

---

## 8. Gestão Financeira (Faturação)
*   **Mudança de UX (Form → Grid)**
    *   [ ] **Ecrã Principal:** Alterar para **Interactive Grid Editável** (em vez de Report + Form). Permitir edição rápida de valores/estados em linha.
    *   [ ] **Detalhes:** Manter a edição detalhada (upload de PDF, obs longas) num Modal acessível via clique no nº da fatura.
*   **Automação**
    *   [ ] **Botão "Gerar Faturas":** Criar processo que vai à `Equipa_Formativa` da turma selecionada e cria uma linha de fatura (rascunho) para cada formador.
    *   [ ] **Pré-preenchimento:** As faturas geradas devem vir com valores default (exceto Datas de Emissão/Pagamento).

---

## 9. Conformidade (Dossier TP)
*   **Conformidade**
    *   [ ] **Revisão:** A página atual não corresponde aos requisitos.
    *   [ ] **Implementação:** Refazer como uma **Checklist Visual** (Tabela `Itens_Dossier_Turma`). Deve listar os documentos obrigatórios (Pautas, Sumários) e mostrar estado (Em Falta / Validado).

---

## 10. Equipamentos (Gestão de Inventário)
*   **Páginas Necessárias**
    *   [ ] **Inventário Global:** Lista completa de tipos de equipamento e stock total.
    *   [ ] **Drill-down:** Ao clicar num equipamento, ver lista detalhada de alocações (Quem tem o quê? Turma/Formador).
    *   [ ] **Movimentos (Entrada/Saída):** Criar formulário (Modal) para registar Check-in/Check-out de equipamentos.

---

## 11. UX Global
*   **Interatividade**
    *   [ ] **Quick View de Pessoas:** Tornar os nomes de pessoas clicáveis em toda a aplicação. Abrir um Dialog/Popup com o resumo da ficha da pessoa (Foto, Contactos) e link para "Editar Completo".
