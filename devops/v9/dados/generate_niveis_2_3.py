import os
import csv

base_dir = r"c:\Users\helder.toucas\OneDrive - Câmara Municipal de Lisboa\01 Projetos\16 Outros projetos\Apexv1\apex1-competenciasdigitais\devops\v9\dados"

dirs = {
    "nivel 2": os.path.join(base_dir, "nivel 2"),
    "nivel 3": os.path.join(base_dir, "nivel 3")
}

for d in dirs.values():
    if not os.path.exists(d):
        os.makedirs(d)

# Nível 2: Precisa do Curso (Nível 1) e de Locais/Entidades (Níveis 0/1)
nivel_2_arquivos = {
    "Modulos.csv": [
        ["ID_CURSO", "NOME", "ORDEM", "CARGA_HORARIA", "DESCRICAO", "TIPO_AVALIACAO"],
        ["1", "Tabelas Dinâmicas e Dashboards", "1", "7", "Exploração de Pivot Tables", "QUANTITATIVA"],
        ["1", "Fórmulas Avançadas", "2", "7", "Exploração de VLOOKUP e INDEX MATCH", "QUANTITATIVA"]
    ],
    "Turmas.csv": [
        ["ID_CURSO", "ID_LOCAL", "ID_COORDENADOR", "CODIGO_TURMA", "NOME_TURMA", "VAGAS", "ID_ESTADO_TURMA", "DATA_INICIO", "DATA_FIM"],
        ["1", "1", "1", "TUR_EXCEL_2026_01", "Edição Especial Executivos", "20", "2", "2026-03-20", "2026-03-22"]
    ],
    "Inscricoes.csv": [
        ["ID_CURSO", "ID_ENTIDADE", "ORIGEM", "ESTADO_INSCRICAO", "ID_NIVEL_DOMINIO", "PRIORIDADE_CHEFIA"],
        ["1", "2", "Indicação Diretor", "PENDENTE", "2", "1"],
        ["1", "1", "Auto-Proposta", "PENDENTE", "1", "2"]
    ]
}

# Nível 3: Precisa da Turma e da Inscrição (Nível 2)
nivel_3_arquivos = {
    "Sessoes.csv": [
        ["ID_TURMA", "ID_FORMADOR", "RESUMO", "TIPO_SESSAO", "DATA_SESSAO", "HORA_INICIO", "HORA_FIM", "DURACAO_HORAS", "SALA", "SUMARIO_REALIZADO", "SUMARIO_DATA"],
        ["1", "1", "Aula 1: Fórmulas Base", "PRATICA", "2026-03-20", "09:30", "13:00", "3.5", "Sala Principal", "S", "2026-03-20"],
        ["1", "1", "Aula 2: Pivot Tables", "PRATICA", "2026-03-20", "14:00", "17:30", "3.5", "Sala Principal", "S", "2026-03-20"]
    ],
    "Equipa_Formativa.csv": [
        ["ID_TURMA", "ID_ENTIDADE", "PAPEL_ESPECIFICO", "TIPO_REMUNERACAO", "VALOR_HORA", "ATIVO"],
        ["1", "1", "FORMADOR", "INTERNA_ISENTA", "0", "S"]
    ],
    "Matriculas.csv": [
        ["ID_TURMA", "ID_ALUNO", "ID_ESTADO_MATRICULA", "CLASSIFICACAO_FINAL", "TOTAL_HORAS", "AVALIACAO_CURSO", "OBSERVACOES"],
        ["1", "2", "1", "18", "7", "5", "Excelente prestação"]
    ],
    "Presencas.csv": [
        ["ID_SESSAO", "ID_MATRICULA", "ID_ESTADO_PRESENCA", "HORAS_ASSISTIDAS", "NOTAS"],
        ["1", "1", "2", "3.5", ""],
        ["2", "1", "2", "3.5", "Saiu mais cedo mas compensou"]
    ]
}

def create_csvs(arquivos_dict, path):
    for nome_ficheiro, linhas in arquivos_dict.items():
        caminho = os.path.join(path, nome_ficheiro)
        with open(caminho, 'w', newline='', encoding='utf-8-sig') as f:
            writer = csv.writer(f, delimiter=';')
            writer.writerows(linhas)

create_csvs(nivel_2_arquivos, dirs["nivel 2"])
create_csvs(nivel_3_arquivos, dirs["nivel 3"])

print("CSVs de Nível 2 e Nível 3 criados com sucesso.")
