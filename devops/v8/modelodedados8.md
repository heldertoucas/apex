# Modelo de Dados Refatorado: SGUF (v7.0 - User Approved)

**Versão:** 7.0 (Unified & Expanded)
**Data:** 18 de Janeiro de 2026
**Base:** Estrutura v6 (High Fidelity) + Alterações aprovadas (Novos campos).

---

## 1. Princípios desta Versão

1.  **Estrutura Base v6:** Mantém-se a estrutura consolidada da v6.
2.  **Enriquecimento de Dados:** Adição de campos em falta identificados na análise de `documentos.md` (Profissão, Faturação, Detalhes Pedagógicos).
3.  **Diagnóstico:** Inclusão das respostas de diagnóstico na matrícula.

---

## 2. Convenções de Desenvolvimento (Standard v1.0)

Para garantir consistência e manutenibilidade, todo o desenvolvimento deve seguir estas regras estritas:

### 2.3. Staging and Integration
*   **Staging:** `Staging_Importacao` (Tabela temporária para cargas).
*   **Logs:** `Log_Comunicacoes` (Auditoria e Fila de emails).

### 2.1. Nomenclatura de Base de Dados (PL/SQL e SQL)
*   **Idioma:** Português (PT-PT) para todos os objetos visíveis.
*   **Tabelas (Tables):**
    *   **Entidades Principais:** PascalCase, Plural. Ex: `Alunos`, `Turmas`, `Cursos`.
    *   **Tabelas de Lookup:** Prefixo `Tipos_` + Singular. Ex: `Tipos_Genero`.
    *   **Associações:** Funcional. Ex: `Equipa_Formativa`.
*   **Colunas:**
    *   **PK:** `ID_` + Nome Tabela Singular. Ex: `ID_Aluno`.
    *   **FK:** Igual à PK referenciada. Ex: `ID_Curso`.
    *   **Flags:** `Ativo`, `Aprovado` ('S'/'N').
    *   **Datas:** Prefixo `Data`. Ex: `Data_Inicio`.

### 2.2. Nomenclatura APEX
*   **Items:** `P<Page>_<NomeColuna>`. Ex: `P10_Nome_Completo`.
*   **Regions:** Nomes funcionais em Português.

---

## 3. Diagrama de Esquema

### A. Domínio: Configuração e Catálogo (CORE)

#### 1. `Programas` (Programas)
*Catálogo de topo.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Programa** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK, Not Null` | Ex: 'PASSAPORTE'. |
| **Nome** | `VARCHAR2(200)` | `Not Null` | Nome do programa. |
| **Descricao** | `VARCHAR2(4000)` | | Descrição pública. |
| **Ativo** | `CHAR(1)` | `Check ('S','N')` | Se o programa está ativo. |

#### 2. `Cursos` (Cursos)
*Unidade de formação. Enriquecido com metodologia e recursos.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Curso** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Programa** | `NUMBER` | `FK` | Programa associado. |
| **Codigo** | `VARCHAR2(50)` | `UK` | Código único (ex: 'LIT_DIG_01'). |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome oficial. |
| **Nome_Curso_SIGO** | `VARCHAR2(100)` | | Referência SIGO. |
| **Carga_Horaria** | `NUMBER` | | Carga horária total. |
| **Modalidade** | `VARCHAR2(50)` | | Online, Presencial, Híbrido. |
| **Forma_Organizacao** | `VARCHAR2(50)` | | Formato de entrega. |
| **Publico_Alvo** | `VARCHAR2(4000)` | | Destinatários. |
| **Objetivos_Gerais** | `CLOB` | | Objetivos gerais de aprendizagem. |
| **Objetivos_Especificos** | `CLOB` | | Objetivos específicos. |
| **Conteudos_Programaticos**| `CLOB` | | Programa detalhado. |
| **Metodologia_Avaliacao** | `CLOB` | | Métodos de avaliação. |
| **Metodologia_Formacao** | `CLOB` | **[NOVO]** | Metodologia pedagógica/ensino. |
| **Recursos_Didaticos** | `CLOB` | **[NOVO]** | Descrição de atividades e recursos didáticos. |
| **URL_Manual_Digital** | `VARCHAR2(500)` | | Link para manual/recursos base. |
| **ID_Estado_Curso** | `NUMBER` | `FK` | Lookup: `Tipos_Estado_Curso`. |

#### 3. `Modulos` (Modulos)
*Estrutura hierárquica.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Modulo** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Curso** | `NUMBER` | `FK` | Curso associado. |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome do módulo. |
| **Ordem** | `NUMBER` | | Sequência no curso. |
| **Carga_Horaria** | `NUMBER` | | Horas do módulo. |
| **Tipo_Avaliacao** | `VARCHAR2(20)` | `Check` | 'QUANTITATIVA', 'QUALITATIVA', 'NENHUMA'. |

#### 4. `Catalogo_Competencias` (Catalogo_Competencias)
*Banco central de competências e badges (Reutilizável).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Competencia** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome da competência. |
| **Descricao** | `VARCHAR2(4000)` | | Detalhe da competência. |
| **ID_Area_Competencia** | `NUMBER` | `FK` | Lookup: `Tipos_Area_Competencia`. |
| **ID_Nivel_Proficiencia** | `NUMBER` | `FK` | Lookup: `Tipos_Nivel_Proficiencia`. |
| **Ativo** | `CHAR(1)` | `Default 'S'` | Se está disponível para seleção. |

#### 4a. `Modulo_Competencias` (Modulo_Competencias)
*Tabela de associação (M:N) - Que competências este módulo ensina.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Associacao** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Modulo** | `NUMBER` | `FK` | Módulo pai. |
| **ID_Competencia** | `NUMBER` | `FK` | Competência do catálogo. |
| **Obrigatorio** | `CHAR(1)` | `Default 'S'` | Se é obrigatória para o módulo. |

#### 4b. `Catalogo_Medalhas` (Catalogo_Medalhas)
*Open Badges disponíveis no sistema (Reutilizável).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Medalha** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Nome** | `VARCHAR2(255)` | `Not Null` | Nome do Badge (ex: Excel Expert). |
| **Descricao** | `VARCHAR2(4000)` | | Descrição do Badge. |
| **URL_Medalha_Digital** | `VARCHAR2(500)` | | Link para definição do Open Badge. |
| **URL_Imagem** | `VARCHAR2(500)` | | Link para a imagem do Badge. |
| **URL_Claim_Badge** | `VARCHAR2(500)` | | Link para formulário de claim. |
| **Ativo** | `CHAR(1)` | `Default 'S'` | 'S'/'N'. |

#### 4c. `Competencia_Medalhas` (Competencia_Medalhas)
*Associação M:N - Quais medalhas uma competência pode dar.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Associacao** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Competencia** | `NUMBER` | `FK` | Competência. |
| **ID_Medalha** | `NUMBER` | `FK` | Medalha associada. |

---

### B. Domínio: Pessoas e Entidades (PEOPLE)

#### 5. `Entidades` (Entidades)
*Tabela única para todos os intervenientes. Enriquecida com dados profissionais.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Entidade** | `NUMBER` | `PK, Identity` | Identificador único. |
| **NIF** | `VARCHAR2(20)` | `UK` | Identificador Fiscal. |
| **Email** | `VARCHAR2(255)` | `UK` | Contacto principal. |
| **Nome_Completo** | `VARCHAR2(255)` | `Not Null` | Nome oficial. |
| **Telemovel** | `VARCHAR2(50)` | | Contacto telefónico. |
| **Data_Nascimento** | `DATE` | | Data de nascimento. |
| **ID_Genero** | `NUMBER` | `FK` | Lookup: `Tipos_Genero`. |
| **Naturalidade** | `VARCHAR2(100)` | | Local de nascimento. |
| **Nacionalidade** | `VARCHAR2(100)` | | País de nacionalidade. |
| **ID_Tipo_Doc** | `NUMBER` | `FK` | Lookup: `Tipos_Doc_Identificacao`. |
| **Num_Doc_Identificacao** | `VARCHAR2(50)` | | Nº CC/BI/Passaporte. |
| **Validade_Doc** | `DATE` | | Validade do documento. |
| **Morada** | `VARCHAR2(255)` | | Rua, Nº, Andar. |
| **Codigo_Postal** | `VARCHAR2(20)` | | Código postal. |
| **Localidade** | `VARCHAR2(100)` | | Localidade. |
| **ID_Situacao_Prof** | `NUMBER` | `FK` | Lookup: `Tipos_Situacao_Profissional`. |
| **Profissao** | `VARCHAR2(100)` | **[NOVO]** | Profissão (Texto livre). |
| **Entidade_Empregadora** | `VARCHAR2(200)` | **[NOVO]** | Entidade Empregadora. |
| **Morada_Prof** | `VARCHAR2(255)` | **[NOVO]** | Morada Profissional. |
| **Codigo_Postal_Prof** | `VARCHAR2(20)` | **[NOVO]** | Código Postal Profissional. |
| **Localidade_Prof** | `VARCHAR2(100)` | **[NOVO]** | Localidade Profissional. |
| **Telemovel_Prof** | `VARCHAR2(50)` | **[NOVO]** | Contacto Profissional. |
| **URL_CV** | `VARCHAR2(500)` | **[NOVO]** | Link para o CV (Formadores). |
| **ID_Qualificacao** | `NUMBER` | `FK` | Lookup: `Tipos_De_Qualificacao`. |
| **Consentimento_RGPD**| `CHAR(1)` | | 'S'/'N'. |
| **Observacoes** | `CLOB` | | Notas gerais. |
| **Data_Criacao** | `DATE` | | Data de registo no sistema. |
| **Ativo** | `CHAR(1)` | | Estado da entidade. |
| **Origem_Registo** | `VARCHAR2(50)` | | 'EXCEL', 'FORM', 'MANUAL'. |

#### 6. `Papeis_Entidade` (Papeis_Entidade)
*Define os papéis (Roles).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Papel** | `NUMBER` | `PK` | Chave primária. |
| **ID_Entidade** | `NUMBER` | `FK` | Relaciona com `Entidades`. |
| **Codigo_Papel** | `VARCHAR2(20)` | `Check` | 'ADMIN', 'FORMADOR', 'FORMANDO', 'COORDENADOR'. |

#### 6a. `Listas_Mailing` (Listas_Mailing)
*Grupos de distribuição de emails/contactos.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Lista** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Nome_Lista** | `VARCHAR2(100)` | `Not Null` | Nome da lista. |
| **Descricao** | `VARCHAR2(255)` | | Descrição do propósito. |
| **Ativo** | `CHAR(1)` | | 'S'/'N'. |

#### 6b. `Entidade_Listas` (Entidade_Listas)
*Associação M:N entre Entidades e Listas.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Entidade** | `NUMBER` | `PK, FK` | Entidade. |
| **ID_Lista** | `NUMBER` | `PK, FK` | Lista. |
| **Data_Associacao** | `DATE` | | Data de inclusão. |
| **Created_By** | `VARCHAR2(100)` | | Utilizador que adicionou. |

---

### C. Domínio: Operação Formativa (OPS)

#### 7. `Turmas` (Turmas)
*Instância de um curso.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Turma** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Curso** | `NUMBER` | `FK` | Curso base. |
| **Codigo_Turma** | `VARCHAR2(100)` | `UK` | Ex: "LIS_T1_2025". |
| **Nome_Turma** | `VARCHAR2(200)` | | Designação amigável. |
| **ID_Estado_Turma** | `NUMBER` | `FK` | Lookup: `Tipos_Estado_Turma`. |
| **Data_Inicio** | `DATE` | | Início da turma. |
| **Data_Fim** | `DATE` | | Fim da turma. |
| **ID_Local** | `NUMBER` | `FK` | Lookup: `Locais`. |
| **Horario_Descritivo** | `VARCHAR2(500)` | | Texto do horário. |
| **ID_Coordenador** | `NUMBER` | `FK` | Coordenador pedagógico. |
| **Vagas** | `NUMBER` | | Capacidade da turma. |
| **Num_Informacao** | `VARCHAR2(100)` | | Nº Informação Interna/SIGO. |
| **Num_Informacao_Mae**| `VARCHAR2(100)` | | Nº Informação Agrupadora. |
| **Cod_Acao_SIGO** | `VARCHAR2(100)` | | Código Ação SIGO. |
| **ID_Tipo_Plano** | `NUMBER` | `FK` | Lookup: `Tipos_Plano_DDF`. |
| **Avaliacao_Ativa** | `CHAR(1)` | | 'S'/'N'. |
| **Observacoes** | `CLOB` | | Notas internas. |

#### 8. `Equipa_Formativa` (Equipa_Formativa)
*Associação N:N Formadores-Turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Formador** | `NUMBER` | `FK` | Formador. |
| **Principal** | `CHAR(1)` | | Formador responsável? |

#### 9. `Turma_Medalhas_Elegiveis` (Turma_Medalhas_Elegiveis)
*Seleção do Formador - Quais medalhas serão atribuídas nesta turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Associacao** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Medalha** | `NUMBER` | `FK` | Medalha selecionada. |
| **Selecionado_Por** | `VARCHAR2(255)` | | User que selecionou (Formador). |

#### 9a. `Inscricoes` (Inscricoes)
*Pré-inscrição ou candidatura a cursos (antes da matrícula).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Inscricao** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Curso** | `NUMBER` | `FK` | Curso de interesse. |
| **ID_Entidade** | `NUMBER` | `FK` | Candidato. |
| **ID_Turma_Preferencia**| `NUMBER` | `FK` | Turma preferencial (opcional). |
| **Data_Registo** | `DATE` | | Data da candidatura. |
| **Origem** | `VARCHAR2(50)` | | 'SITE', 'BALCAO', etc. |
| **Respostas_Diagnostico**| `CLOB` | | Respostas ao questionário inicial. |
| **Estado_Inscricao** | `VARCHAR2(50)` | | 'PENDENTE', 'ACEITE', 'RECUSADA'. |
| **Observacoes** | `VARCHAR2(4000)` | | Notas internas. |

#### 10. `Matriculas` (Matriculas)
*Inscrição do aluno na turma. Inclui agora o diagnóstico.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Matricula** | `NUMBER` | `PK, Identity` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Aluno** | `NUMBER` | `FK` | Aluno. |
| **Token_Acesso** | `VARCHAR2(20)` | `UK` | Token estático para acesso. |
| **ID_Estado_Matricula**| `NUMBER` | `FK` | Lookup: `Tipos_Estado_Matricula`. |
| **Data_Inscricao** | `DATE` | | Data de criação da matrícula. |
| **Diagnostico_Respostas**| `CLOB` | **[NOVO]** | Respostas ao diagnóstico (JSON/Texto). |
| **Data_Conclusao** | `DATE` | | Data de fecho. |
| **Classificacao_Final**| `VARCHAR2(50)` | | Nota final. |
| **Total_Horas** | `NUMBER` | | Horas assistidas. |
| **Avaliacao_Curso** | `NUMBER` | | (1-5) Satisfação do aluno. |
| **Comentario_Aluno** | `CLOB` | | Feedback qualitativo do aluno. |
| **Obs_SIGO** | `VARCHAR2(4000)` | | Notas para certificação. |
| **ID_Nivel_Experiencia**| `NUMBER` | `FK` | Lookup: `Tipos_Nivel_Experiencia`. |

#### 10. `Sessoes` (Sessoes)
*Aulas.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Sessao** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **Nome** | `VARCHAR2(200)` | | Título da sessão. |
| **Data_Sessao** | `DATE` | | Dia da aula. |
| **Hora_Inicio** | `VARCHAR2(5)` | | Hora HH:MM. |
| **Hora_Fim** | `VARCHAR2(5)` | | Hora HH:MM. |
| **Duracao_Horas** | `NUMBER` | | Duração decimal. |
| **Sumario** | `CLOB` | | Conteúdo lecionado. |
| **ID_Formador** | `NUMBER` | `FK` | Formador desta sessão. |
| **URL_Recursos** | `VARCHAR2(1000)` | | Link para materiais. |

#### 11. `Presencas` (Presencas)
*Assiduidade.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Presenca** | `NUMBER` | `PK` | Chave primária. |
| **ID_Sessao** | `NUMBER` | `FK` | Sessão. |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno. |
| **ID_Estado_Presenca**| `NUMBER` | `FK` | Lookup: `Tipos_Estado_Presenca`. |
| **Horas_Assistidas** | `NUMBER` | | Horas creditadas. |
| **Data_Registo** | `TIMESTAMP` | | Auditoria de registo. |

---

### D. Domínio: Avaliação (EVAL)

#### 12. `Avaliacoes_Modulo` (Avaliacoes_Modulo)
*Notas granulares por módulo.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Avaliacao** | `NUMBER` | `PK` | Chave primária. |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno. |
| **ID_Modulo** | `NUMBER` | `FK` | Módulo. |
| **Nota_Valor** | `NUMBER` | | Nota quantitativa. |
| **Feedback_Texto** | `CLOB` | | Feedback qualitativo. |
| **Aprovado** | `CHAR(1)` | | 'S'/'N'. |

#### 13. `Badges_Conquistados` (Badges_Conquistados)
*Passaporte de competências.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Badge_Aluno** | `NUMBER` | `PK` | Chave primária. |
| **ID_Matricula** | `NUMBER` | `FK` | Aluno/Turma. |
| **ID_Competencia** | `NUMBER` | `FK` | Badge/Competência. |
| **Data_Conquista** | `DATE` | | Data de emissão. |
| **URL_Evidencia** | `VARCHAR2(500)` | | Link para badge externo. |
| **Token_Validacao**| `VARCHAR2(100)` | | Token de validação pública. |

---

### E. Domínio: Administrativo (ADMIN)

#### 13a. `Staging_Importacao` (Staging_Importacao)
*Tabela temporária para validação de dados antes da inserção final.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Staging** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Data_Upload** | `TIMESTAMP` | | Data da carga. |
| **Utilizador** | `VARCHAR2(100)` | | Quem carregou. |
| **Nome_Excel** | `VARCHAR2(255)` | | Nome bruto. |
| **Email_Excel** | `VARCHAR2(255)` | | Email bruto. |
| **NIF_Excel** | `VARCHAR2(50)` | | NIF bruto. |
| **Curso_Excel** | `VARCHAR2(255)` | | Nome do curso bruto. |
| **Data_Excel** | `VARCHAR2(50)` | | Data bruta. |
| **Linha_Valida** | `CHAR(1)` | | 'S'/'N'. |
| **Mensagem_Erro** | `VARCHAR2(4000)` | | Motivo da falha. |
| **ID_Curso_Mapeado** | `NUMBER` | | ID resolvido após correção. |
| **ID_Genero_Mapeado**| `NUMBER` | | ID resolvido após correção. |

#### 14. `Itens_Dossier_Turma` (Itens_Dossier_Turma)
*Checklist de documentos.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Item_Dossier** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Tipo_Doc** | `NUMBER` | `FK` | Lookup: `Tipos_Documento_Dossier`. |
| **Presente** | `CHAR(1)` | | 'S'/'N'. |
| **URL_Ficheiro** | `VARCHAR2(500)` | | Link para arquivo. |
| **Validado_Por** | `VARCHAR2(255)` | | Utilizador que validou. |
| **Data_Validacao** | `DATE` | | Data. |
| **Data_Upload** | `DATE` | **[NOVO_DB]** | Data de carregamento. |
| **Observacoes** | `VARCHAR2(4000)` | **[NOVO_DB]** | Notas sobre o documento. |

#### 15. `Faturas_Formadores` (Faturas_Formadores)
*Processamento de pagamentos. Enriquecido com datas finanças.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Fatura** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Formador** | `NUMBER` | `FK` | Formador. |
| **Num_Fatura** | `VARCHAR2(50)` | **[NOVO]** | Número da fatura. |
| **Valor** | `NUMBER` | | Montante. |
| **Mes_Ref** | `VARCHAR2(7)` | | 'YYYY-MM'. |
| **Estado** | `VARCHAR2(20)` | | 'EMITIDA', 'PAGA'. |
| **Data_Emissao** | `DATE` | | Data emissão. |
| **Data_Contabilistica** | `DATE` | **[NOVO]** | Data de contabilidade. |
| **Data_Pagamento** | `DATE` | **[NOVO]** | Data do pagamento. |
| **Observacoes** | `CLOB` | **[NOVO_DB]** | Observações ou detalhes extra. |

#### 16. `Equipamentos_Alocados` (Equipamentos_Alocados)
*Gestão de hardware.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Alocacao** | `NUMBER` | `PK` | Chave primária. |
| **ID_Turma** | `NUMBER` | `FK` | Turma. |
| **ID_Tipo_Equipamento**| `NUMBER` | `FK` | Lookup: `Tipos_Equipamento`. |
| **Quantidade** | `NUMBER` | | Qtd alocada. |
| **Data_Entrega** | `DATE` | | Entrega ao formador. |
| **Data_Devolucao** | `DATE` | | Devolução. |
| **Estado_Conservacao** | `VARCHAR2(200)` | | Obs estado. |
| **Responsavel_Entrega**| `VARCHAR2(200)` | **[NOVO_DB]** | Quem entregou o equipamento. |
| **Recebido_Por** | `VARCHAR2(200)` | **[NOVO_DB]** | Quem recebeu (se diferente do formador). |



---

### F. Tabelas de Lookup (Domínios)

Definição das tabelas de domínio para normalização de dados. Todas seguem um padrão base, exceto onde indicado.

#### 19. `Tipos_Area_Competencia`
*Áreas do referencial (ex: DigComp).*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Area_Competencia**| `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | Ex: 'SEGURANCA', 'INFORMACAO'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Nome da área. |
| **Ordem** | `NUMBER` | | Ordem de apresentação. |
| **Ativo** | `CHAR(1)` | | 'S'/'N'. |

#### 20. `Tipos_Nivel_Proficiencia`
*Níveis de competência.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Nivel_Proficiencia**| `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | Ex: 'BASICO', 'INTERMEDIO'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |
| **Ordem** | `NUMBER` | | Ordem. |

#### 21. `Tipos_Estado_Curso`
*Estados de ciclo de vida do curso.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Estado_Curso** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | Ex: 'ATIVO', 'RASCUNHO', 'ARQUIVADO'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 22. `Tipos_Genero`
*Género.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Genero** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(20)` | `UK` | 'M', 'F', 'O'. |
| **Descricao** | `VARCHAR2(100)` | `Not Null` | Designação. |

#### 23. `Tipos_Doc_Identificacao`
*Tipos de documento legal.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Tipo_Doc** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(20)` | `UK` | 'CC', 'PASSAPORTE', 'AR'. |
| **Descricao** | `VARCHAR2(100)` | `Not Null` | Designação. |

#### 24. `Tipos_Situacao_Profissional`
*Situação face ao emprego.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Situacao_Prof** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | 'EMPREGADO', 'DESEMPREGADO'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 25. `Tipos_De_Qualificacao`
*Habilitações literárias.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Qualificacao** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | '12ANO', 'LICENCIATURA'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |
| **Ordem** | `NUMBER` | | Nível para ordenação. |

#### 26. `Tipos_Estado_Turma`
*Ciclo de vida da turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Estado_Turma** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | 'PLANEADA', 'CONFIRMADA', 'DECORRER', 'TERMINADA'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 27. `Tipos_Estado_Matricula`
*Estado do aluno na turma.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Estado_Matricula**| `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | 'INSCRITO', 'FREQUENTAR', 'CONCLUIDO', 'DESISTIU'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 28. `Tipos_Estado_Presenca`
*Classificação da assiduidade.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Estado_Presenca** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(20)` | `UK` | 'P' (Presente), 'F' (Falta), 'FJ' (Falta Justificada). |
| **Descricao** | `VARCHAR2(100)` | `Not Null` | Designação. |
| **Considera_Presenca** | `CHAR(1)` | | 'S'/'N' (Se conta para horas). |

#### 29. `Tipos_Nivel_Experiencia`
*Auto-classificação do aluno.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Nivel_Experiencia**| `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | 'INICIANTE', 'AVANCADO'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 30. `Tipos_Equipamento`
*Categorias de inventário.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Tipo_Equipamento**| `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | 'PC', 'ROUTER'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 31. `Tipos_Plano_DDF`
*Classificação interna DDF.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Tipo_Plano** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | 'INTERNA', 'EXTERNA'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 32. `Tipos_Documento_Dossier`
*Tipologia de documentos para checklist.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Tipo_Doc** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | 'SUMARIO', 'PAUTA', 'QUEST_SAT'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |
| **Obrigatorio** | `CHAR(1)` | | 'S'/'N'. |

#### 33. `Tipos_Notificacao`
*Canais de comunicação.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Tipo_Notificacao**| `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(20)` | `UK` | 'EMAIL', 'SMS'. |
| **Descricao** | `VARCHAR2(200)` | `Not Null` | Designação. |

#### 34. `Locais` (Locais)
*Espaços físicos.*

| Nome do Campo | Tipo (Oracle) | Constraints | Descrição |
| :--- | :--- | :--- | :--- |
| **ID_Local** | `NUMBER` | `PK, Identity` | Chave primária. |
| **Codigo** | `VARCHAR2(50)` | `UK` | Ex: 'EDIF_CAMPO_GRANDE'. |
| **Nome** | `VARCHAR2(200)` | `Not Null` | Nome do local/sala. |
| **Morada** | `VARCHAR2(500)` | | Endereço completo. |
| **Capacidade** | `NUMBER` | | Lotação máxima. |
| **Ativo** | `CHAR(1)` | | 'S'/'N'. |
