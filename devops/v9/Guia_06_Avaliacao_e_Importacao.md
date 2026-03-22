# Manual de Implementação APEX (v9) - Capítulo 6: Avaliação, Administração e Importação
**Aplicação:** SGUF v9 (Passaporte Competências Digitais)  
**Objetivo:** Fechar o ciclo letivo. Registar as notas, reclamar os Badges, garantir o Dossier Pedagógico, controlar Faturas e gerir a importação massiva de dados por Excel.

---

## 1. Avaliação Pedagógica e Badges
A Turma acabou. É hora do formador (ou o Coordenador) lançar as notas dos módulos e atestar as competências.

### 1.1. Lançamento de Notas por Módulo
Pode ser feito diretamente na Ficha da Turma ou numa página dedicada para o Formador.
1. **Create Page** > **Interactive Grid**.
2. **Page Name:** `Pauta de Avaliação`.
3. **Table Name:** `AVALIACOES_MODULO`.
4. **Where Clause:** `ID_TURMA = :PXX_ID_TURMA`.
5. **Configuração da Grelha:**
   * Ativar Edição.
   * `ID_ALUNO` -> Popup LOV (com todos os alunos dessa turma).
   * `ID_MODULO` -> Select List (com os módulos alocados a esse curso específico).
   * Transforme `Data_Avaliacao` para ter como *Default* o dia de hoje (`SYSDATE`).

### 1.2. Painel de Badges Conquistados (Gamification)
Um ecrã onde o utilizador consulta quem tem o quê.
1. **Create Page** > **Interactive Report**.
2. **Page Name:** `Medalheiro Digital`.
3. **Table Name:** `BADGES_CONQUISTADOS`.
4. Faça Join visual com `Entidades` (Aluno), `Turmas` (Onde conquistou) e `Catalogo_Medalhas` (O que ganhou) para apresentar uma lista rica e com imagens dos badges no APEX.

---

## 2. Dossier Pedagógico e Faturação (Burocracia)
A visão administrativa do processo.

### 2.1. Checklist do Dossier da Turma
1. Crie uma **Interactive Grid** na Ficha de Turma.
2. **Table:** `ITENS_DOSSIER_TURMA`.
3. **O Botão Mágico "Inicializar Dossier":**
   Crie um botão na Ficha de Turma que executa um bloco PL/SQL simples para gerar as linhas para os documentos obrigatórios baseados na tabela `Tipos_Documento_Dossier`:
   ```sql
   INSERT INTO Itens_Dossier_Turma (ID_Turma, ID_Tipo_Doc, Entregue)
   SELECT :PXX_ID_TURMA, ID_Tipo_Doc, 'N'
   FROM Tipos_Documento_Dossier
   WHERE Obrigatorio = 'S'
     AND ID_Tipo_Doc NOT IN (SELECT ID_Tipo_Doc FROM Itens_Dossier_Turma WHERE ID_Turma = :PXX_ID_TURMA);
   ```

### 2.2. Controlo de Faturas
1. **Create Page** > **Interactive Report com Form**.
2. **Name:** `Controlo de Faturas` e `Editar Fatura`.
3. **Table:** `FATURAS_FORMADORES`.
4. Na Grelha, mascare a coluna `Valor` em Reais ou Euros usando a Format Mask (ex: `FML999G999G990D00`). Mostre o estado do pagamento criando uma lógica visual (`Data_Pagamento IS NULL -> Pendente`).

### 2.3. Gestão de Equipamentos (Inventário)
Para registar as entregas de Portáteis/Hotspots à Turma.
1. **Create Page** > **Report with Form**.
2. **Page Name:** `Equipamentos Alocados` e Form `Registar Entrega`.
3. **Table:** `EQUIPAMENTOS_ALOCADOS`.
4. No Form gerado, transforme `PXX_ID_TURMA` num Popup LOV e `PXX_ID_TIPO_EQUIPAMENTO` num Select List para facilitar a vida ao técnico de logística.

### 2.4. Questionários de Satisfação (Feedback)
1. Para recolher o feedback final, o coordenador precisa do Link para o questionário externo (Ex: Microsoft Forms ou Typeform).
2. Na Master Page (ou Tabela) `Turmas`, garanta a existência de uma coluna `URL_Questionario`.
3. Exponha esse `URL_Questionario` na listagem da Turma ou use-o no Capítulo 5 (Automação de E-mails) como uma variável mágica `#LINK_SATISFACAO#` a ser enviada no último dia de aulas.

---

## 3. Integração em Massa: A Nova Página de Staging
Quando temos 300 inscrições numa folha de Excel, não usamos formulários. Usamos o nativo Data Loading do APEX ligado ao nosso "Purgatório" (Staging).

1. No APEX, vá a **Shared Components** > **Data Load Definitions**.
2. Crie uma nova definição apontando para a tabela `STAGING_IMPORTACAO`. 
3. Mapeie as 12 colunas base (Nome_Excel, Email_Excel, Curso_Excel, etc.).
4. Vá ao **App Builder** > **Create Page** > **Data Loading**.
5. Selecione a Definição que acabou de criar.
6. **O Cockpit de Correção:**
   * Crie uma página extra (**Interactive Grid** editável) baseada na `STAGING_IMPORTACAO`.
   * **Highlight:** Pinte a linha de vermelho se o campo `Mensagem_Erro` da tabela contiver texto.
   * Crie um botão **PROCESSAR IMPORTAÇÃO** no topo que executa um bloco de validação (ou PKG_IMPORTACAO se o tiver gerado no motor) para transpor quem não tiver erro para a tabela principal de `Inscricoes` e `Entidades`.

**Conclusão da Biblioteca de Guias v9:**
Parabéns. Seguindo estes 6 módulos, tem arquitetada e desenhada a aplicação **Passaporte Digital SGUF v9**. Desde a conceção da pessoa, aos catálogos, operação formativa, automação de disparo de emails diários e fecho de notas no SIGO. O Sistema está operacional!
