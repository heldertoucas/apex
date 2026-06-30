<!-- converted from Modelo_de_Dados.xlsx -->

## Sheet: Index
| Tabelas |
| --- |
| Programas |
| Competencias |
| Cursos |
| Tipos__De__Qualificacao |
| Modelos__De__Comunicacao |
| Configuracoes__Formulario |
| Tipos__Equipamento |
| Lookups |
| Pre__Inscricoes |
| Inscritos |
| Turmas |
| Sessoes |
| Matriculas |
| Presencas |
| Badges__Atribuidos |
| Equipamentos__Alocados |
| Dossier__Submissoes |
| Registos__De__Acoes |
| Tipos__De__Acao |
| Turma__Competencias__Lecionadas |
| Desafios__Turma |
| Faturas |
| Dossier_Controlo |
| Tipos_Documento_Dossier |
| Dossier_Conformidade |
## Sheet: Programas
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Programa | **Número (Identity)** | Chave primária única para cada programa. |
| Nome | Texto (Curto, Único) | O nome oficial do programa (ex: "Passaporte Competências Digitais"). |
| Descricao | Texto (Longo) | Uma breve descrição dos objetivos e público-alvo do programa. |
## Sheet: Competencias
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Competencia | Identificador Único (PK) | Chave primária única para cada competência. |
| Nome | Texto (Curto) | O nome oficial da competência (ex: "Cidadania Digital"). |
| Descricao | Texto (Longo) | Descrição detalhada da competência. |
| ID\_Area\_Competencia | Relação (FK) | Referência à área da competência na tabela Tipos\_Area\_Competencia. |
| ID\_Nivel\_Proficiencia | Relação (FK) | Referência ao nível de proficiência na tabela Tipos\_Nivel\_Proficiencia. |
| URL\_Medalha\_Digital | URL / Hiperligação | O link único para a conquista da medalha digital associada a esta competência. |
| URL\_Icone\_Badge | URL / Hiperligação | O link para o ficheiro de imagem (.svg, .png) do ícone visual do badge. |
## Sheet: Cursos
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Curso | Identificador Único (PK) | Chave primária única para cada curso. |
| ID\_Programa | Relação (FK) | Referência ao programa ao qual o curso pertence na tabela Programas. |
| Nome | Texto (Curto) | O nome oficial do curso. |
| Nome_Curso_SIGO | Texto (Curto) | Designação oficial do curso para efeitos de exportação SIGO. |
| ID\_Estado\_Curso | Relação (FK) | Referência ao estado do curso na tabela Tipos\_Estado\_Curso. |
| Carga\_Horaria | Numérico (Inteiro) | Duração total do curso em horas. |
| Competencias\_Associadas | Relação Múltipla (FK) | Referência a uma ou mais competências da tabela Competencias que são abordadas neste curso. |
| Modalidade\_Formacao | Texto (Curto) | A modalidade geral da formação (ex: "Formação contínua"). |
| Forma\_Organizacao | Texto (Curto) | O formato de entrega do curso (ex: "Presencial", "Online (síncrona)", "Híbrido"). |
| Publico\_Alvo | Texto (Longo) | Descrição detalhada dos destinatários preferenciais do curso. |
| Objetivos\_Gerais | Texto (Longo, Formatado) | Os objetivos de aprendizagem gerais do curso. |
| Objetivos\_Especificos | Texto (Longo, Formatado) | Os objetivos de aprendizagem detalhados e específicos. |
| Conteudos\_Programaticos | Texto (Longo, Formatado) | A lista de tópicos e conteúdos abordados no curso. |
| Metodologia\_Avaliacao | Texto (Longo) | Descrição dos métodos e critérios de avaliação utilizados no curso. |
| URL\_Manual\_Digital | URL / Hiperligação | Link para o manual digital ou material de apoio principal do curso. |
## Sheet: Tipos__De__Qualificacao
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Qualificacao | Identificador Único (PK) | Chave primária única para cada tipo de qualificação. |
| Nome | Texto (Curto) | O nome da qualificação (ex: "Ensino Secundário", "Mestrado"). |
| Nivel\_QEQ | Numérico (Inteiro) | O nível correspondente no Quadro Europeu de Qualificações (1 a 8). |
| Descricao | Texto (Longo) | Descrição mais detalhada da qualificação, se necessário. |
## Sheet: Modelos__De__Comunicacao
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Modelo | Identificador Único (PK) | Chave primária única para cada modelo. |
| Nome | Texto (Curto) | Nome interno para identificar o modelo (ex: "Email de Boas-Vindas"). |
| Assunto | Texto (Curto) | O assunto pré-preenchido do email ou comunicação. |
| Corpo | Texto (Longo, Formatado) | O corpo da mensagem em HTML, com suporte para formatação e placeholders (ex: {NomeInscrito}, {NomeCurso}). |
| ID\_Tipo\_Notificacao | Relação (FK) | Referência ao tipo de notificação na tabela Tipos\_Notificacao. |
| Evento\_Gatilho | Texto (Curto) | Descrição do evento que despoleta a notificação (ex: "Inscrição confirmada"). |
| **Codigo_Referencia** | Texto (Curto, Único) | **(Novo)** Código único para chamada via PL/SQL (ex: `EMAIL_BOAS_VINDAS`). |
## Sheet: Configuracoes__Formulario
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Configuracao | Identificador Único (PK) | Chave primária da configuração. |
| Nome | Texto (Curto) | Um nome para esta configuração (ex: "Desafio Digital Final V1", "Avaliação de Curso Padrão"). |
| Tipo\_Formulario | Lista de Escolha | O tipo de formulário (ex: "Google Form", "Microsoft Form"). |
| ID\_Formulario\_Externo | Texto (Curto) | O ID do formulário (ex: o GOOGLE\_FORM\_ID). |
| URL\_Base | URL / Hiperligação | O link base do formulário, sem campos pré-preenchidos. |
| Mapeamento\_Campos | JSON | Armazena a "tradução" dos campos da base de dados para os campos do formulário. Ex: {"nome\_curso": "entry.123", "nome\_formador\_1": "entry.456"}. |
## Sheet: Tipos__Equipamento
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Tipo\_Equipamento | Identificador Único (PK) | Chave primária única para cada tipo de equipamento. |
| Nome | Texto (Curto, Único) | Nome ou modelo do equipamento (ex: "Webcam Logitech C920", "Kit Micro:bit V2"). |
| Descricao | Texto (Longo) | Descrição detalhada do equipamento e das suas características. |
| ID\_Categoria\_Equipamento | Relação (FK) | Referência à categoria do equipamento na tabela Tipos\_Categoria\_Equipamento. |
## Sheet: Lookups
| Nome da Tabela | Propósito |
| --- | --- |
| **Tipos\_Area\_Competencia** | Armazena as áreas do modelo DigComp (ex: "Segurança"). |
| **Tipos\_Nivel\_Proficiencia** | Armazena os níveis de proficiência (ex: "Introdução"). |
| **Tipos\_Estado\_Curso** | Armazena os estados de um curso no catálogo (ex: "Ativo"). |
| **Tipos\_Notificacao** | Armazena os tipos de notificação (ex: "Automática"). |
| **Tipos\_Categoria\_Equipamento** | Armazena as categorias de equipamento (ex: "Hardware"). |
| **Tipos\_Estado\_Pre\_Inscricao** | Armazena os estados do funil de pré-inscrição (ex: "Nova"). |
| **Tipos\_Genero** | Armazena as opções de género (ex: "Feminino"). |
| **Tipos\_Doc\_Identificacao** | Armazena os tipos de documento de identificação (ex: "Cartão de Cidadão"). |
| **Tipos\_Situacao\_Profissional** | Armazena as situações profissionais dos inscritos (ex: "Desempregado"). |
| **Tipos\_Estado\_Geral\_Inscrito** | Armazena o estado geral de um participante no programa (ex: "Ativo"). |
| **Tipos\_Estado\_Turma** | Armazena os estados de uma turma (ex: "Em Curso"). |
| **Tipos\_Estado\_Dossier** | Armazena os estados do dossier pedagógico (ex: "Pendente"). |
| **Tipos\_Estado\_Matricula** | Armazena os estados de uma matrícula (ex: "A frequentar"). |
| **Tipos\_Nivel\_Experiencia** | Armazena os níveis de experiência auto-reportados (ex: "Iniciante"). |
| **Tipos\_Estado\_Presenca** | Armazena os estados de uma presença numa sessão (ex: "Presente"). |
| **Tipos\_Metodo\_Registo** | Armazena os métodos de registo de presença (ex: "Manual"). |
| **Tipos\_Estado\_Alocacao** | Armazena os estados de uma alocação de equipamento (ex: "Em Uso"). |
| **Tipos\_Funcao\_Turma** | Armazena as funções de um utilizador numa turma (ex: "Formador"). |
| **Tipos\_Estado\_Submissao** | Armazena os estados de submissão de um relatório (ex: "Submetido"). |
| **Tipos_Plano_DDF** | **(Novo)** Armazena os tipos de plano (ex: "Formação Interna", "Formação para o Exterior"). |
## Sheet: Pre__Inscricoes
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Pre\_Inscricao | Identificador Único (PK) | Chave primária única para cada pré-inscrição. |
| Nome\_Completo | Texto (Curto) | Nome completo do interessado. |
| Email | Texto (Email) | Email de contacto do interessado. |
| Contacto\_Telefonico | Texto (Curto) | Número de telefone de contacto. |
| NIF | Numérico (Inteiro) | Número de Identificação Fiscal do interessado. |
| Data\_Nascimento | Data | Data de nascimento do interessado. |
| Consentimento\_Dados | **Texto (1) - S/N** | Registo do consentimento da política de privacidade. |
| Interesses | JSON / Texto (Longo) | Armazena os dados estruturados (cursos, locais, experiência) da submissão do formulário. |
| Data\_Submissao | Data e Hora | Data e hora exatas da submissão do formulário (preenchido automaticamente). |
| ID\_Estado\_Pre\_Inscricao | Relação (FK) | Referência ao estado da pré-inscrição na tabela Tipos\_Estado\_Pre\_Inscricao. |
## Sheet: Inscritos
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Inscrito | Identificador Único (PK) | Chave primária única para cada participante. |
| Nome\_Completo | Texto (Curto) | Nome completo oficial do participante. |
| Email | Texto (Email, Único) | Email principal do participante, usado como identificador único. |
| Contacto\_Telefonico | Texto (Curto) | Número de telefone principal. |
| NIF | Numérico (Inteiro, Único) | NIF do participante, usado como identificador único secundário. |
| Data\_Nascimento | Data | Data de nascimento. |
| ID\_Genero | Relação (FK) | Referência ao género do participante na tabela Tipos\_Genero. |
| Naturalidade | Texto (Curto) | Local de nascimento. |
| Nacionalidade | Texto (Curto) | Nacionalidade. |
| ID\_Tipo\_Doc\_Identificacao | Relação (FK) | Referência ao tipo de documento na tabela Tipos\_Doc\_Identificacao. |
| Doc\_Identificacao\_Num | Texto (Curto) | Número do documento de identificação. |
| Validade\_Doc\_Identificacao | Data | Data de validade do documento. |
| Morada | Texto (Curto) | Morada de residência. |
| Codigo\_Postal | Texto (Curto) | Código Postal de residência. |
| Localidade\_Codigo\_Postal | Texto (Curto) | Localidade de residência. |
| ID\_Situacao\_Profissional | Relação (FK) | Referência à situação profissional na tabela Tipos\_Situacao\_Profissional. |
| ID\_Qualificacao | Relação (FK) | Referência ao nível de habilitações literárias na tabela Tipos\_De\_Qualificacao. |
| Consentimento\_RGPD | **Texto (1) - S/N** | Registo do consentimento explícito do participante para o tratamento de dados, de acordo com o RGPD. |
| ID\_Estado\_Geral\_Inscrito | Relação (FK) | Referência ao estado geral do participante na tabela Tipos\_Estado\_Geral\_Inscrito. |
| Interesses\_Iniciais | JSON / Texto (Longo) | Armazena os interesses originais da primeira pré-inscrição. |
| Origem\_Inscricao | Texto (Curto) | Canal através do qual a inscrição foi feita (ex: "Formulário Online", "Sessão Presencial"). |
| Observacoes | Texto (Longo) | Campo para notas e observações gerais sobre o inscrito. |
| Data\_Criacao | Data e Hora | Data e hora em que o registo do inscrito foi criado. |
## Sheet: Turmas
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Turma | Identificador Único (PK) | Chave primária única para cada turma. |
| Nome | Texto (Curto) | Nome ou código da turma (ex: "NIS-T5-Lumiar"). |
| ID\_Curso | Relação (FK) | Referência ao curso correspondente na tabela Cursos. |
| Formadores | Relação Múltipla (FK) | Referência a um ou mais utilizadores do sistema (formadores) responsáveis pela turma. |
| ID\_Coordenador | Relação (FK) | Referência ao utilizador do sistema que é o coordenador desta turma. |
| Numero\_Da\_Turma | Texto (Curto) | Código interno ou número sequencial da turma (ex: "Ação nº 1"). |
| ID\_Estado\_Turma | Relação (FK) | Referência ao estado da turma na tabela Tipos\_Estado\_Turma. |
| ID\_Estado\_Dossier | Relação (FK) | Referência ao estado do dossier na tabela Tipos\_Estado\_Dossier. |
| Data\_Inicio | Data | Data de início da turma. |
| Data\_Fim | Data | Data de fim da turma. |
| Local\_Formacao | Texto (Curto) | Local principal onde decorre a formação. |
| Horario | Texto (Curto) | Horário principal da turma (ex: "Pós-laboral, 19h-22h"). |
| Calendarizacao\_Texto | Texto (Longo) | Descrição textual do calendário da turma (ex: "27, 28 e 29 de abril de 2020, das 10h00 às 13h00"). |
| Estrutura\_Sessoes\_Texto | Texto (Longo) | Descrição sumária da estrutura das sessões (ex: "9 horas, distribuídas por 3 sessões de 3 horas"). |
| Vagas | Numérico (Inteiro) | Número de vagas disponíveis para a turma. |
| Total\_Inquiridos | Numérico (Inteiro) | O número de respostas recebidas no questionário de avaliação. |
| ID\_Config\_Avaliacao | Relação (FK) | Aponta para a Configuracoes\_Formulario a usar para o questionário de avaliação desta turma. |
| ID\_Config\_Desafio\_Final | Relação (FK) | Aponta para a Configuracoes\_Formulario a usar para o desafio digital desta turma. |
| Num_Informacao | Texto (Curto) | Nº Informação de autorização (ex: INF/255/DDF/DMRH/CML/25 de 04-08-2025). |
| Num_Informacao_Mae | Texto (Curto) | Nº Informação Mãe, caso exista (ex: INF/255/DDF/DMRH/CML/25 de 04-08-2025). |
| Cod_Acao_BD_Formacao | Texto (Curto) | Código da ação na BD Formação do DDF (ex: IOU/PE_ID:AUCT/05). |
| ID_Tipo_Plano_DDF | Relação (FK) | Referência ao tipo de plano na tabela Tipos_Plano_DDF. |
| Competencias\_Para\_Desafio | Relação Múltipla (FK) | Aponta para as Competencias que poderão ser testadas no desafio digital desta turma. |
| Competencias\_Lecionadas | Relação Múltipla (FK) | Referência, através da tabela Turma\_Competencias\_Lecionadas, às competências que o formador marcou como tendo sido efetivamente abordadas na formação. |
| Observacoes | Texto (Longo) | Notas e observações sobre a turma. |
## Sheet: Sessoes
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Sessao | Identificador Único (PK) | Chave primária única para cada sessão. |
| Nome | Texto (Curto) | Título da sessão (ex: "Sessão 1: Introdução à Segurança Digital"). |
| ID\_Turma | Relação (FK) | Referência à Turma a que esta sessão pertence. |
| ID\_Formadores\_Sessao | Relação Múltipla (FK) | Referência aos formadores específicos desta sessão. Se nulo, herda os formadores da Turma. Permite registar substituições. |
| Data\_Sessao | Data | Data específica da sessão. |
| Hora\_Inicio | Hora | Hora de início da sessão. |
| Hora\_Fim | Hora | Hora de fim da sessão. |
| Duracao\_Horas | Numérico (Decimal) | Duração da sessão em horas (ex: 2.5 para 2h30m). |
| Sumario | Texto (Longo) | Tópicos e sumário dos conteúdos a abordar na sessão. |
| **URL\_Recursos\_Pedagogicos** | **URL / Hiperligação** | **(Novo)** Link para materiais de apoio específicos desta sessão (ex: slides, vídeos, artigos). |
## Sheet: Matriculas
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Matricula | Identificador Único (PK) | Chave primária única para cada matrícula. |
| ID\_Inscrito | Relação (FK) | Referência ao participante na tabela Inscritos. |
| ID\_Turma | Relação (FK) | Referência à turma na tabela Turmas. |
| ID\_Estado\_Matricula | Relação (FK) | Referência ao estado da matrícula na tabela Tipos\_Estado\_Matricula. |
| ID\_Nivel\_Experiencia | Relação (FK) | Referência ao nível de experiência na tabela Tipos\_Nivel\_Experiencia. |
| Respostas\_Desafio\_Final | JSON / Texto (Longo) | Uma cópia das respostas do formando ao desafio digital final, para fins de auditoria e consulta. |
| Classificacao\_Desafio\_Final | Texto (Curto) | A classificação obtida no desafio digital (ex: "Aprovado", "20", "Apto"). |
| Classificacao\_Final | Texto (Curto) | A classificação final atribuída ao formando na conclusão da sua participação na turma. |
| Total\_Horas\_Assistidas | Numérico (Decimal) | O total de horas de formação frequentadas pelo formando, calculado a partir da soma das presenças. |
| Avaliacao\_Do\_Curso | Numérico (Inteiro) | Avaliação do curso pelo participante (ex: 1 a 5), preenchida no final. |
| Comentarios\_Avaliacao | Texto (Longo) | Comentários de feedback do participante sobre o curso. |
| Data\_De\_Inscricao | Data e Hora | Data e hora em que a matrícula foi efetuada. |
| Data\_De\_Conclusao | Data e Hora | Data e hora em que o estado foi alterado para "Concluído com Sucesso". |
| Obs_Certificacao_SIGO | Texto (Longo) | Observações para o certificado SIGO (ex: "tem direito aos dois módulos", "só um módulo"). |
## Sheet: Presencas
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Presenca | Identificador Único (PK) | Chave primária única para cada registo de presença. |
| ID\_Matricula | Relação (FK) | Referência à matrícula do participante na tabela Matriculas. |
| ID\_Sessao | Relação (FK) | Referência à sessão na tabela Sessoes. |
| ID\_Estado\_Presenca | Relação (FK) | Referência ao estado da presença na tabela Tipos\_Estado\_Presenca. |
| Horas\_Assistidas | Numérico (Decimal) | Permite registar presenças parciais (ex: 1.5 horas numa sessão de 3 horas). |
| ID\_Metodo\_Registo | Relação (FK) | Referência ao método de registo na tabela Tipos\_Metodo\_Registo. |
| Data\_Registo | Data e Hora | Data e hora em que a presença foi efetivamente registada. |
## Sheet: Badges__Atribuidos
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Badge\_Atribuido | Identificador Único (PK) | Chave primária única para cada badge emitido. |
| ID\_Inscrito | Relação (FK) | Referência ao participante na tabela Inscritos. |
| ID\_Competencia | Relação (FK) | Referência à competência certificada na tabela Competencias. |
| ID\_Matricula\_Origem | Relação (FK) | Referência à matrícula na tabela Matriculas que originou a emissão deste badge. |
| Data\_De\_Emissao | Data e Hora | Data e hora exatas da emissão do badge. |
| URL\_Certificado | URL / Hiperligação | Link para o certificado digital ou página do Open Badge. |
## Sheet: Equipamentos__Alocados
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Alocacao | Identificador Único (PK) | Chave primária única para cada alocação. |
| ID\_Turma | Relação (FK) | Referência à Turma que está a utilizar o equipamento. |
| ID\_Tipo\_Equipamento | Relação (FK) | Referência ao tipo de equipamento na tabela Tipos\_Equipamento. |
| Quantidade | Numérico (Inteiro) | Número de unidades do equipamento alocadas a esta turma. |
| Data\_Entrega | Data e Hora | Data e hora em que o equipamento foi entregue ao formador/local. |
| Data\_Recolha\_Prevista | Data | Data prevista para a devolução do equipamento. |
| Data\_Recolha\_Efetiva | Data e Hora | Data e hora em que o equipamento foi efetivamente devolvido. |
| ID\_Estado\_Alocacao | Relação (FK) | Referência ao estado da alocação na tabela Tipos\_Estado\_Alocacao. |
| Observacoes | Texto (Longo) | Notas sobre o estado do equipamento na entrega ou recolha. |
## Sheet: Dossier__Submissoes
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Submissao | Identificador Único (PK) | Chave primária única para cada registo de submissão. |
| ID\_Turma | Relação (FK) | Referência à Turma a que este registo diz respeito. |
| ID\_Utilizador | Relação (FK) | Referência ao utilizador (coordenador ou formador) que deve submeter o relatório. |
| ID\_Funcao\_Turma | Relação (FK) | Referência à função do utilizador na tabela Tipos\_Funcao\_Turma. |
| ID\_Estado\_Submissao | Relação (FK) | Referência ao estado da submissão na tabela Tipos\_Estado\_Submissao. |
| Data\_Submissao | Data e Hora | Data e hora em que o relatório foi efetivamente submetido. |
| URL\_Relatorio\_Satisfacao | URL / Hiperligação | Link para o relatório de avaliação de satisfação submetido pelo utilizador. |
## Sheet: Registos__De__Acoes
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Acao | Identificador Único (PK) | Chave primária única para cada ação registada. |
| ID\_Tipo\_De\_Acao | Relação (FK) | Referência ao tipo de ação na tabela Tipos\_De\_Acao. |
| ID\_Autor\_Da\_Acao | Relação (FK) | Referência ao utilizador do sistema que executou a ação. |
| ID\_Contexto | Relação (FK) | Referência polimórfica ao registo principal afetado (ex: um ID de Inscritos ou Matriculas). |
| Detalhes | JSON / Texto (Longo) | Campo para guardar informação contextual extra (ex: o JSON de uma submissão de formulário). |
| Data\_Da\_Acao | Data e Hora | Data e hora exatas em que a ação ocorreu. |
## Sheet: Tipos__De__Acao
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Tipo\_De\_Acao | Identificador Único (PK) | Chave primária única para cada tipo de ação. |
| Nome | Texto (Curto) | Nome descritivo da ação. |
| Palavra\_Chave | Texto (Curto, Único) | Palavra-chave para uso interno no código. |
| Descricao | Texto (Longo) | Explicação detalhada do propósito da ação no sistema. |
## Sheet: Turma__Competencias__Lecionadas
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Turma | Relação (FK) | Referência à Turmas. |
| ID\_Competencia | Relação (FK) | Referência à Competencias. |
## Sheet: Desafios__Turma
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Desafio\_Turma | Identificador Único (PK) | Chave primária única para cada desafio gerado. |
| ID\_Turma | Relação (FK) | Referência à Turmas para a qual este desafio foi criado. |
| ID\_Utilizador\_Criador | Relação (FK) | Referência ao Utilizadores (Formador) que gerou o link. |
| Token\_Acesso | Texto (Curto, Único) | Um código único e não sequencial (ex: UUID) que torna o URL do desafio impossível de adivinhar. |
| URL\_Gerado | URL / Hiperligação | O "link mágico" completo que é partilhado com os formandos. |
| Data\_Criacao | Data e Hora | Data e hora exatas em que o link foi gerado. |
| Data\_Expiracao | Data e Hora | (Opcional) Data a partir da qual o link deixa de ser válido. |
| Estado | Lista de Escolha | Estado do link (ex: "Ativo", "Expirado", "Fechado"). |
## Sheet: Faturas
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Fatura | Identificador Único (PK) | Chave primária única para cada fatura. |
| ID\_Turma | Relação (FK) | Referência à Turma a que diz respeito a fatura. |
| ID\_Formador | Relação (FK) | Referência ao Formador a quem a fatura diz respeito. |
| Valor\_Faturado | Numérico (Monetário) | O valor total a faturar. |
| Data\_Elaboracao | Data | Data de elaboração da fatura. |
| Mes\_Previsto\_Processamento | Texto / Data | Mês previsto para o processamento da fatura. |
| Mes\_Pagamento | Texto / Data | Mês efetivo do pagamento. |
| Snapshot\_Num\_Informacao | Texto (Curto) | Cópia do Nº Informação da Turma à data da fatura (para histórico). |
| Snapshot\_Cod\_Acao | Texto (Curto) | Cópia do Código da Ação à data da fatura (para histórico). |
## Sheet: Dossier_Controlo
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Dossier\_Controlo | **Número (Identity)** | Chave primária do registo de controlo. |
| ID\_Turma | Relação (FK, Único) | Referência à Turma. |
| Check\_Horas\_BD | **Texto (1) - S/N** | As horas assistidas foram verificadas na BD? |
| Check\_Acao\_Inserida\_Sigo | **Texto (1) - S/N** | A ação foi inserida corretamente no SIGO? |
| Check\_Certificados\_Emitidos | **Texto (1) - S/N** | Os certificados dos formandos foram emitidos? |
| Check\_Dossier\_Completo | **Texto (1) - S/N** | O dossier técnico-pedagógico está completo fisicamente/digitalmente? |
| Check\_Relatorio\_Avaliacao\_Produzido | **Texto (1) - S/N** | O relatório de avaliação da ação foi produzido? |
| Check\_Badges\_Validados | **Texto (1) - S/N** | Os badges da ação foram validados? |
| Check\_Quest\_Formandos\_Carregados | **Texto (1) - S/N** | **(Automático)** Calculado com base na existência de ficheiros do tipo 'QUEST_FORMANDOS' na tabela `Arquivos_Anexos` para esta turma. |
| Check\_Quest\_Formadores\_Carregados | **Texto (1) - S/N** | **(Automático)** Calculado com base na existência de ficheiros do tipo 'QUEST_FORMADORES'. |
| Check\_Quest\_Coordenadores\_Carregados | **Texto (1) - S/N** | **(Automático)** Calculado com base na existência de ficheiros do tipo 'QUEST_COORDENADORES'. |
## Sheet: Tipos_Documento_Dossier
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Tipo\_Doc | Identificador Único (PK) | Chave primária. |
| Nome | Texto (Curto) | Designação do item (ex: "Folha de Presenças", "Relatório de Avaliação", "Sumários"). |
| Obrigatorio | Booleano (Y/N) | Define se este item é mandatório para fechar o dossier. |
| Ordem\_Apresentacao | Numérico | Para ordenação visual na checklist. |
## Sheet: Dossier_Conformidade
| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| --- | --- | --- |
| ID\_Conformidade | Identificador Único (PK) | Chave primária. |
| ID\_Turma | Relação (FK) | A turma a que este registo pertence. |
| ID\_Tipo\_Doc | Relação (FK) | O item da checklist que está a ser verificado. |
| **Conforme** | **Booleano (Y/N)** | **Check de validação. 'Y' indica que o documento existe e está válido.** |
| **URL\_Localizacao** | **Texto (Longo)** | **(Opcional) Link para o SharePoint/Drive/Pasta de Rede onde o ficheiro real está arquivado.** |
| Data\_Verificacao | Data e Hora | Quando é que este item foi marcado como conforme. |
| Verificado\_Por | Texto (Curto) | O utilizador (Técnico/Coordenador) que validou o item. |
| Observacoes | Texto (Longo) | Notas sobre a conformidade ou localização específica. |