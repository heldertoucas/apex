# Fluxos Operacionais e Modelo de Dados: SGUF v9

Este documento detalha o modelo de dados unificado do **SGUF v9** (com foco no repositório Oracle APEX) e descreve a narrativa de como decorre cada fluxo operacional no sistema.

---

## 1. Arquitetura do Modelo de Dados (SGUF v9)

O esquema está dividido em 5 domínios lógicos principais que comunicam entre si:

`mermaid
erDiagram
    PROGRAMAS ||--o{ CURSOS : contem
    CURSOS ||--o{ MODULOS : divide-se-em
    CURSOS ||--o{ TURMAS : instancia
    TURMAS ||--o{ MATRICULAS : regista
    ENTIDADES ||--o{ MATRICULAS : associa
    ENTIDADES ||--o{ INSCRICOES : candidata
    CURSOS ||--o{ INSCRICOES : recebe
    TURMAS ||--o{ SESSOES : agenda
    SESSOES ||--o{ PRESENCAS : controla
    MATRICULAS ||--o{ PRESENCAS : regista-presenca
`

### Principais Tabelas por Domínio

| Domínio | Tabela | Descrição / Chaves Fiscais |
| :--- | :--- | :--- |
| **A. Catálogo (CORE)** | Programas | Catálogo de topo da formação (ID_Programa PK, Codigo UK). |
| | Cursos | Unidades de formação específicas (ID_Curso PK, ID_Programa FK). |
| | Modulos | Unidades curriculares e sua carga horária (ID_Modulo PK, ID_Curso FK). |
| **B. Pessoas (PEOPLE)** | Entidades | Tabela única para formandos, formadores e coordenadores (ID_Entidade PK, NIF/Email UK). |
| **C. Operações (OPS)** | Turmas | Instâncias de cursos com datas de realização e vagas (ID_Turma PK, ID_Curso FK). |
| | Inscricoes | Intenções de frequência (Candidaturas) (ID_Inscricao PK, ID_Curso FK, ID_Entidade FK). |
| | Matriculas | Registo de formandos efetivos numa Turma (ID_Matricula PK, ID_Turma FK, ID_Aluno FK). |
| | Sessoes | Aulas/sessões calendarizadas da turma (ID_Sessao PK, ID_Turma FK). |
| | Presencas | Controlo de assiduidade de cada aluno em cada sessão (ID_Presenca PK, ID_Matricula FK, ID_Sessao FK). |

---

## 2. Fluxo Operacional 1: Criação de Cursos e Ações (Turmas)

### Narrativa do Fluxo
Este fluxo inicia-se no **Catálogo de Formação** e define a estrutura programática que será depois executada no terreno.

1. **Definição da Oferta Formativa (Catálogo):**
   Um **Gestor de Formação**, acedendo à área de administração do Oracle APEX, começa por criar um Programa de formação (ex: "Competências Digitais Globais"). Sob este programa, cria um ou mais Cursos (ex: "Iniciação ao Processamento de Texto"). Cada curso é decomposto em vários Modulos pedagógicos específicos, determinando a sua ordem de lecionação, carga horária e tipo de avaliação (ex: pauta numérica ou qualitativa).

2. **Criação da Ação de Formação (Turma):**
   Com o curso definido, o Gestor de Formação decide abrir uma ação no terreno criando uma Turma. Ele seleciona o curso base, define a data de início e de fim, o coordenador responsável e o número limite de vagas físicas/virtuais.

3. **Planeamento e Calendarização:**
   O gestor agenda o calendário letivo associando Sessoes àquela turma. Cada sessão tem uma data, hora de início, duração estimada, sumário inicial e local físico/sala (associado da tabela Locais). Quando as sessões são criadas, a base de dados fica pronta a controlar a assiduidade dos futuros alunos que ali forem matriculados.

---

## 3. Fluxo Operacional 2: Inscrição dos Interessados (Candidatura)

### Narrativa do Fluxo
Este fluxo descreve como um cidadão manifesta interesse em frequentar um curso e entra no sistema de triagem.

1. **Manifestação de Interesse (Portal / API):**
   Um interessado acede ao formulário de inscrição do portal. Ele submete os seus dados obrigatórios para validação legal: **NIF** (chave de validação fiscal do cidadão), nome completo, e-mail, telemóvel e o curso pretendido. Adicionalmente, o formulário recolhe o consentimento para a política de RGPD e, opcionalmente, para receber mailing de divulgação (Aceita_Newsletter).

2. **Ingresso na Base de Dados (Deduplicação):**
   Ao submeter a candidatura, a base de dados executa uma verificação através do NIF:
   * **Se o NIF não existir:** É criado um novo registo na tabela centralizada de Entidades.
   * **Se o NIF já existir:** A base de dados atualiza os contactos (e-mail, telemóvel, dados profissionais) mantendo a mesma ID_Entidade única. Isto evita a proliferação de registos duplicados no sistema.

3. **Criação da Candidatura:**
   O sistema regista uma nova linha na tabela Inscricoes ligando a ID_Entidade ao ID_Curso selecionado, com o estado inicial definido como **'PENDENTE'**. O sistema de automação deteta a nova inscrição e gera um registo em Log_Comunicacoes para disparar um e-mail automático de confirmação de receção para o candidato.

---

## 4. Fluxo Operacional 3: Seleção e Matrícula dos Inscritos

### Narrativa do Fluxo
Este fluxo representa o núcleo operacional da secretaria, onde as candidaturas pendentes são triadas e convertidas em matrículas ativas.

1. **Triagem e Seleção:**
   Através de um painel de triagem no Oracle APEX, o coordenador da formação analisa a lista de Inscricoes pendentes. O ecrã exibe indicadores visuais de integridade e prioridade (ex: semáforos baseados no histórico de formação do candidato). O coordenador seleciona os candidatos validados e altera o estado da inscrição para **'ACEITE'**.

2. **O Processo de Matrícula (Transição Automática):**
   Ao clicar no botão "Matricular", o APEX invoca o procedimento PL/SQL PKG_MATRICULAS.Matricular_Formando fornecendo o ID da inscrição aceite e o ID da turma de destino. A base de dados executa atomicamente as seguintes operações:
   * Insere um registo na tabela Matriculas, cruzando o aluno com a turma.
   * O trigger associado à tabela (TRG_MATRICULAS_CODIGO) gera de forma segura o Codigo_Matricula sequencial amigável (ex: 'MAT-2026-0043') e um Token_Acesso único (UUID hash).
   * O estado da inscrição correspondente transita de 'PENDENTE' para 'MATRICULADO'.

3. **Geração Automática de Assiduidade (Presenças):**
   Ainda na execução da matrícula, o pacote invoca PKG_MATRICULAS.Criar_Presencas_Auto. Este método pesquisa todas as Sessoes calendarizadas para aquela turma de destino. Por cada sessão encontrada, o sistema insere previamente uma linha na tabela Presencas associada à matrícula do formando, inicializando o estado de assiduidade como **'CV' (Convocado)**.

4. **Notificação Automática:**
   Finalmente, a matrícula gera um registo na tabela Log_Comunicacoes associado ao formando e ao modelo de email correspondente. O motor assíncrono envia o e-mail de boas-vindas contendo as datas, as salas e o link cifrado (com o Token_Acesso) para o formando preencher as suas presenças de forma simples.
