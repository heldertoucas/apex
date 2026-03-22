import os
import csv

dados_dir = r"c:\Users\helder.toucas\OneDrive - Câmara Municipal de Lisboa\01 Projetos\16 Outros projetos\Apexv1\apex1-competenciasdigitais\devops\v9\dados\nivel 1"
if not os.path.exists(dados_dir):
    os.makedirs(dados_dir)

# Nível 1: Tabelas que precisam dos IDs gerados no Nível 0 para existirem.
arquivos = {
    "Cursos.csv": [
        ["ID_PROGRAMA", "CODIGO", "NOME", "NOME_CURSO_SIGO", "CARGA_HORARIA", "MODALIDADE", "FORMA_ORGANIZACAO", "PUBLICO_ALVO", "OBJETIVOS_GERAIS", "METODOLOGIA_AVALIACAO", "ID_ESTADO_CURSO"],
        ["1", "EXCEL_AVANC", "Excel Avançado para Gestão", "Folhas de Cálculo - Nível 3", "14", "Presencial", "Formação Contínua", "Técnicos Superiores", "Dominar tabelas dinâmicas", "Quantitativa de 0 a 20", "2"]
    ],
    "Entidades.csv": [
        ["NIF", "EMAIL", "NOME_COMPLETO", "TELEMOVEL", "ID_GENERO", "NATURALIDADE", "NACIONALIDADE", "ID_TIPO_DOC", "NUM_DOC_IDENTIFICACAO", "MORADA", "ID_SITUACAO_PROF", "PROFISSAO", "ENTIDADE_EMPREGADORA", "ID_QUALIFICACAO", "CONSENTIMENTO_RGPD", "ATIVO"],
        ["123456789", "joao.silva@cm-lisboa.pt", "João da Silva", "910000000", "1", "Lisboa", "Portuguesa", "1", "11111111", "Rua ABC, 12", "1", "Assistente Técnico", "CML - DMIRH", "1", "S", "S"],
        ["987654321", "maria.costa@cm-lisboa.pt", "Maria Costa", "920000000", "2", "Porto", "Portuguesa", "1", "22222222", "Rua DEF, 34", "1", "Técnica Superior", "CML - DSI", "2", "S", "S"]
    ],
    "Catalogo_Competencias.csv": [
        ["CODIGO", "NOME", "DESCRICAO", "ID_AREA_COMPETENCIA", "ID_NIVEL_PROFICIENCIA", "ATIVO"],
        ["COMP01", "Análise de Dados em Excel", "Capacidade de extrair conhecimento de raw data via Pivot Tables", "1", "1", "S"]
    ]
}

for nome_ficheiro, linhas in arquivos.items():
    caminho = os.path.join(dados_dir, nome_ficheiro)
    # UTF-8 SIG para garantir perfeita leitura e acentos no Excel
    with open(caminho, 'w', newline='', encoding='utf-8-sig') as f:
        writer = csv.writer(f, delimiter=';')
        writer.writerows(linhas)

print(f"CSVs de Nível 1 criados com sucesso na diretoria {dados_dir}")
