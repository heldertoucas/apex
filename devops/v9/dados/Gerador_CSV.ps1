$dadosDir = "c:\Users\helder.toucas\OneDrive - Câmara Municipal de Lisboa\01 Projetos\16 Outros projetos\apex\apex\devops\v9\dados"

# Function to create CSV
function Create-CSV {
    param([string]$Path, [string[]]$Content)
    $Content | Out-File -FilePath "$dadosDir\$Path" -Encoding UTF8
}

# Nivel 0
New-Item -ItemType Directory -Force -Path "$dadosDir\nivel 0" | Out-Null
Create-CSV -Path "nivel 0\Programas.csv" -Content @(
    "CODIGO;NOME;DESCRICAO;ATIVO",
    "PRG_CD;Competências Digitais;Programa de literacia digital da CML;S"
)
Create-CSV -Path "nivel 0\Locais.csv" -Content @(
    "CODIGO;NOME;MORADA;CAPACIDADE;ATIVO",
    "SALA_B;Sala B - Fórum Picoas;Avenida Fontes Pereira de Melo;25;S"
)
Create-CSV -Path "nivel 0\Listas_Mailing.csv" -Content @(
    "NOME_LISTA;DESCRICAO;ATIVO",
    "All_Formadores;Lista agregadora de todos os formadores internos;S"
)
Create-CSV -Path "nivel 0\Catalogo_Medalhas.csv" -Content @(
    "NOME;DESCRICAO;URL_MEDALHA_DIGITAL;URL_IMAGEM;URL_CLAIM_BADGE;ATIVO",
    "Mestre em Excel;Medalha atribuída após concluir Excel Avançado;;;;S"
)
Create-CSV -Path "nivel 0\Tipos_Genero.csv" -Content @("CODIGO;DESCRICAO;ATIVO", "M;Masculino;S", "F;Feminino;S", "O;Outro;S")
Create-CSV -Path "nivel 0\Tipos_Doc_Identificacao.csv" -Content @("CODIGO;DESCRICAO;ATIVO", "CC;Cartão de Cidadão;S", "BI;Bilhete de Identidade;S", "PASS;Passaporte;S")
Create-CSV -Path "nivel 0\Tipos_Estado_Curso.csv" -Content @("CODIGO;DESCRICAO;ATIVO", "RASCUNHO;Em Rascunho / Planeamento;S", "ATIVO;Aberto e Ativo;S", "FECHADO;Fechado / Arquivado;S")
Create-CSV -Path "nivel 0\Tipos_Area_Competencia.csv" -Content @("CODIGO;NOME;DESCRICAO;ATIVO", "DIG_LIT;Literacia Digital;Competências base de computador;S")
Create-CSV -Path "nivel 0\Tipos_Nivel_Proficiencia.csv" -Content @("CODIGO;NOME;DESCRICAO;PONTUACAO_BASE;ATIVO", "NIV_1;Iniciação;Conhecimentos básicos;1;S")
Create-CSV -Path "nivel 0\Tipos_Estado_Turma.csv" -Content @("CODIGO;DESCRICAO;ATIVO", "PLANEADA;Planeada;S", "A_DECORRER;A Decorrer;S", "CONCLUIDA;Concluída;S")
Create-CSV -Path "nivel 0\Tipos_Estado_Matricula.csv" -Content @("CODIGO;DESCRICAO;ATIVO", "ATIVA;Ativa na Turma;S", "CANCELADA;Cancelada / Desistência;S")
Create-CSV -Path "nivel 0\Tipos_Estado_Presenca.csv" -Content @("CODIGO;DESCRICAO;ATIVO", "CV;Convocado;S", "P;Presente;S", "F;Falta Injustificada;S", "FJ;Falta Justificada;S")
Create-CSV -Path "nivel 0\Tipos_Nivel_Experiencia.csv" -Content @("CODIGO;DESCRICAO;ORDEM;ATIVO", "NIV_0;Nível 0 - Sem conhecimentos;1;S", "NIV_I;Nível I - Conhecimentos Base;2;S", "NIV_II;Nível II - Avançado;3;S")

# Nivel 1
New-Item -ItemType Directory -Force -Path "$dadosDir\nivel 1" | Out-Null
Create-CSV -Path "nivel 1\Cursos.csv" -Content @(
    "ID_PROGRAMA;CODIGO;NOME;NOME_CURSO_SIGO;CARGA_HORARIA;MODALIDADE;FORMA_ORGANIZACAO;PUBLICO_ALVO;OBJETIVOS_GERAIS;METODOLOGIA_AVALIACAO;ID_ESTADO_CURSO",
    "1;EXCEL_AVANC;Excel Avançado para Gestão;Folhas de Cálculo - Nível 3;14;Presencial;Formação Contínua;Técnicos Superiores;Dominar tabelas dinâmicas;Quantitativa de 0 a 20;2"
)
Create-CSV -Path "nivel 1\Entidades.csv" -Content @(
    "NIF;EMAIL;NOME_COMPLETO;TELEMOVEL;ID_GENERO;NATURALIDADE;NACIONALIDADE;ID_TIPO_DOC;NUM_DOC_IDENTIFICACAO;MORADA;ID_SITUACAO_PROF;PROFISSAO;ENTIDADE_EMPREGADORA;ID_QUALIFICACAO;CONSENTIMENTO_RGPD;ATIVO",
    "123456789;joao.silva@cm-lisboa.pt;João da Silva;910000000;1;Lisboa;Portuguesa;1;11111111;Rua ABC 12;1;Assistente Técnico;CML - DMIRH;1;S;S",
    "987654321;maria.costa@cm-lisboa.pt;Maria Costa;920000000;2;Porto;Portuguesa;1;22222222;Rua DEF 34;1;Técnica Superior;CML - DSI;2;S;S"
)
Create-CSV -Path "nivel 1\Catalogo_Competencias.csv" -Content @(
    "NOME;DESCRICAO;ID_AREA_COMPETENCIA;ID_NIVEL_PROFICIENCIA;ATIVO",
    "Análise de Dados em Excel;Extrair conhecimento de raw data;1;1;S"
)

# Nivel 2
New-Item -ItemType Directory -Force -Path "$dadosDir\nivel 2" | Out-Null
Create-CSV -Path "nivel 2\Modulos.csv" -Content @(
    "ID_CURSO;NOME;ORDEM;CARGA_HORARIA;DESCRICAO;TIPO_AVALIACAO",
    "1;Tabelas Dinâmicas e Dashboards;1;7;Exploração de Pivot Tables;QUANTITATIVA",
    "1;Fórmulas Avançadas;2;7;Exploração de VLOOKUP e INDEX MATCH;QUANTITATIVA"
)
Create-CSV -Path "nivel 2\Turmas.csv" -Content @(
    "ID_CURSO;ID_LOCAL;ID_COORDENADOR;CODIGO_TURMA;NOME_TURMA;VAGAS;ID_ESTADO_TURMA;DATA_INICIO;DATA_FIM",
    "1;1;1;TUR_EXCEL_2026_01;Edição Especial Executivos;20;2;2026-03-20;2026-03-22"
)
Create-CSV -Path "nivel 2\Inscricoes.csv" -Content @(
    "ID_CURSO;ID_ENTIDADE;ORIGEM;ESTADO_INSCRICAO;ID_NIVEL_DOMINIO;PRIORIDADE_CHEFIA",
    "1;2;Indicação Diretor;PENDENTE;2;1",
    "1;1;Auto-Proposta;PENDENTE;1;2"
)

# Nivel 3
New-Item -ItemType Directory -Force -Path "$dadosDir\nivel 3" | Out-Null
Create-CSV -Path "nivel 3\Sessoes.csv" -Content @(
    "ID_TURMA;ID_FORMADOR;RESUMO;TIPO_SESSAO;DATA_SESSAO;HORA_INICIO;HORA_FIM;DURACAO_HORAS;SALA;SUMARIO_REALIZADO;SUMARIO_DATA",
    "1;1;Aula 1: Fórmulas Base;PRATICA;2026-03-20;09:30;13:00;3.5;Sala Principal;S;2026-03-20",
    "1;1;Aula 2: Pivot Tables;PRATICA;2026-03-20;14:00;17:30;3.5;Sala Principal;S;2026-03-20"
)
Create-CSV -Path "nivel 3\Equipa_Formativa.csv" -Content @(
    "ID_TURMA;ID_ENTIDADE;PAPEL_ESPECIFICO;TIPO_REMUNERACAO;VALOR_HORA;ATIVO",
    "1;1;FORMADOR;INTERNA_ISENTA;0;S"
)
Create-CSV -Path "nivel 3\Matriculas.csv" -Content @(
    "ID_TURMA;ID_ALUNO;ID_ESTADO_MATRICULA;CLASSIFICACAO_FINAL;TOTAL_HORAS;AVALIACAO_CURSO;OBSERVACOES",
    "1;2;1;18;7;5;Excelente prestação"
)
Create-CSV -Path "nivel 3\Presencas.csv" -Content @(
    "ID_SESSAO;ID_MATRICULA;ID_ESTADO_PRESENCA;HORAS_ASSISTIDAS;NOTAS",
    "1;1;2;3.5;",
    "2;1;2;3.5;Saiu mais cedo mas compensou"
)

Write-Host "Todos os 26 ficheiros CSV foram gerados com sucesso."
