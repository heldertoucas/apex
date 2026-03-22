import os
import csv

dados_dir = r"c:\Users\helder.toucas\OneDrive - Câmara Municipal de Lisboa\01 Projetos\16 Outros projetos\Apexv1\apex1-competenciasdigitais\devops\v9\dados"
if not os.path.exists(dados_dir):
    os.makedirs(dados_dir)

arquivos = {
    "1_Programas.csv": [
        ["CODIGO", "NOME", "DESCRICAO", "ATIVO"],
        ["PRG_CD", "Competências Digitais", "Programa de literacia digital e inovação para trabalhadores da CML", "S"]
    ],
    "1_Locais.csv": [
        ["NOME", "MORADA", "LOTACAO", "OBSERVACOES", "ATIVO"],
        ["Sala B - Fórum Picoas", "Avenida Fontes Pereira de Melo", "25", "Dispõe de computadores", "S"]
    ],
    "1_Entidades.csv": [
        ["NIF", "EMAIL", "NOME_COMPLETO", "TELEMOVEL", "PROFISSAO", "ENTIDADE_EMPREGADORA"],
        ["123456789", "joao.silva@cm-lisboa.pt", "João da Silva", "910000000", "Assistente Técnico", "CML - DMIRH"]
    ],
    "2_Cursos.csv": [
        ["ID_PROGRAMA", "CODIGO", "NOME", "NOME_CURSO_SIGO", "CARGA_HORARIA", "MODALIDADE"],
        ["1", "EXCEL_AVANC", "Excel Avançado para Gestão", "Folhas de Cálculo - Nível 3", "14", "Presencial"]
    ],
    "2_Modulos.csv": [
        ["ID_CURSO", "NOME", "ORDEM", "CARGA_HORARIA", "TIPO_AVALIACAO"],
        ["1", "Tabelas Dinâmicas e Dashboards", "1", "7", "QUANTITATIVA"]
    ],
    "3_Turmas.csv": [
        ["ID_CURSO", "ID_COORDENADOR", "CODIGO_TURMA", "NOME_TURMA", "DATA_INICIO", "DATA_FIM", "VAGAS"],
        ["1", "1", "TUR_EXCEL_2026_01", "Edição Especial de Março", "2026-03-20", "2026-03-22", "20"]
    ],
    "3_Inscricoes.csv": [
        ["ID_CURSO", "ID_ENTIDADE", "ORIGEM", "ESTADO_INSCRICAO", "ID_NIVEL_DOMINIO", "PRIORIDADE_CHEFIA"],
        ["1", "1", "Indicação Diretor", "PENDENTE", "2", "1"]
    ]
}

for nome_ficheiro, linhas in arquivos.items():
    caminho = os.path.join(dados_dir, nome_ficheiro)
    # UTF-8 SIG garante que o Excel PT abre os acentos automaticamente
    with open(caminho, 'w', newline='', encoding='utf-8-sig') as f:
        # Ponto e vírgula é o standard do Excel em PT
        writer = csv.writer(f, delimiter=';')
        writer.writerows(linhas)

print(f"CSVs criados com sucesso na diretoria {dados_dir}")
