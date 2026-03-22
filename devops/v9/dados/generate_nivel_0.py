import os
import csv

dados_dir = r"c:\Users\helder.toucas\OneDrive - Câmara Municipal de Lisboa\01 Projetos\16 Outros projetos\Apexv1\apex1-competenciasdigitais\devops\v9\dados\nivel 0"
if not os.path.exists(dados_dir):
    os.makedirs(dados_dir)

# Concentrando-nos apenas nas Tabelas de "Nível 0" (Raiz sem FKs obrigatórias)
arquivos = {
    "Programas.csv": [
        ["CODIGO", "NOME", "DESCRICAO", "ATIVO"],
        ["PRG_CD", "Competências Digitais", "Programa de literacia digital da CML", "S"]
    ],
    "Locais.csv": [
        ["CODIGO", "NOME", "MORADA", "CAPACIDADE", "ATIVO"],
        ["SALA_B", "Sala B - Fórum Picoas", "Avenida Fontes Pereira de Melo, Picoas", "25", "S"],
        ["FCL_INF", "Fundação Cidade de Lisboa (Sala Informática)", "Campo Grande, 382, 1700-097 Lisboa", "15", "S"],
        ["FCL_P1", "Fundação Cidade de Lisboa (Sala Piso 1)", "Campo Grande, 382, 1700-097 Lisboa", "20", "S"],
        ["CG25_S1", "Campo Grande 25, Sala 1", "Campo Grande, 25, 1749-099 Lisboa", "25", "S"],
        ["CG25_S2", "Campo Grande 25, Sala 2", "Campo Grande, 25, 1749-099 Lisboa", "25", "S"],
        ["CG25_S3", "Campo Grande 25, Sala 3", "Campo Grande, 25, 1749-099 Lisboa", "25", "S"],
        ["CG25_S4", "Campo Grande 25, Sala 4", "Campo Grande, 25, 1749-099 Lisboa", "25", "S"],
        ["CG25_S5", "Campo Grande 25, Sala 5 (GVVasco Rato)", "Campo Grande, 25, 1749-099 Lisboa", "15", "S"],
        ["CG25_S6", "Campo Grande 25, Sala 6", "Campo Grande, 25, 1749-099 Lisboa", "25", "S"],
        ["CG25_S7", "Campo Grande 25, Sala 7", "Campo Grande, 25, 1749-099 Lisboa", "25", "S"],
        ["DDF_EJC_S1", "DDF Escola de Jardinagem, Sala 1", "Quinta Conde dos Arcos, Av. Dr. Francisco Luís Gomes, 1800-180 Lisboa", "20", "S"],
        ["DDF_EJC_S2", "DDF Escola de Jardinagem, Sala 2", "Quinta Conde dos Arcos, Av. Dr. Francisco Luís Gomes, 1800-180 Lisboa", "20", "S"],
        ["DDF_EJC_S3", "DDF Escola de Jardinagem, Sala 3", "Quinta Conde dos Arcos, Av. Dr. Francisco Luís Gomes, 1800-180 Lisboa", "20", "S"],
        ["DDF_EJC_S4", "DDF Escola de Jardinagem, Sala 4", "Quinta Conde dos Arcos, Av. Dr. Francisco Luís Gomes, 1800-180 Lisboa", "20", "S"],
        ["DDF_EJC_S5", "DDF Escola de Jardinagem, Sala 5", "Quinta Conde dos Arcos, Av. Dr. Francisco Luís Gomes, 1800-180 Lisboa", "20", "S"],
        ["DDF_EJC_S6", "DDF Escola de Jardinagem, Sala 6", "Quinta Conde dos Arcos, Av. Dr. Francisco Luís Gomes, 1800-180 Lisboa", "20", "S"],
        ["DDF_EJC_S7", "DDF Escola de Jardinagem, Sala 7", "Quinta Conde dos Arcos, Av. Dr. Francisco Luís Gomes, 1800-180 Lisboa", "20", "S"],
        ["BIB_COR_PC", "Biblioteca dos Coruchéus (Sala PC)", "Rua Alberto de Oliveira, 1700-019 Lisboa", "12", "S"],
        ["BIB_COR_POL", "Biblioteca dos Coruchéus (Sala Polivalente)", "Rua Alberto de Oliveira, 1700-019 Lisboa", "40", "S"],
        ["BIB_GAL_POL", "Biblioteca das Galveias (Sala Polivalente)", "Palácio Galveias, Campo Pequeno", "50", "S"],
        ["BIB_GAL_FOR", "Biblioteca das Galveias (Sala Formação)", "Palácio Galveias, Campo Pequeno", "20", "S"],
        ["BIB_ALC_COMP", "Biblioteca de Alcântara (Sala Computadores)", "Rua do Alvito, 1300-054 Lisboa", "15", "S"],
        ["BIB_MARV", "Biblioteca de Marvila", "Rua António Gedeão, 1950-374 Lisboa", "60", "S"],
        ["Q_ALEGRE", "Quinta Alegre", "Palácio da Quinta Alegre, Charneca", "30", "S"],
        ["PM_S1", "Polícia Municipal, Sala 1", "Rua Cardeal Mercier, 1600-026 Lisboa", "20", "S"],
        ["PM_S2", "Polícia Municipal, Sala 2", "Rua Cardeal Mercier, 1600-026 Lisboa", "20", "S"],
        ["PM_S3", "Polícia Municipal, Sala 3", "Rua Cardeal Mercier, 1600-026 Lisboa", "20", "S"],
        ["BOMB_S1", "Bombeiros Sapadores, Sala 1", "Avenida da Praia da Vitória", "20", "S"],
        ["BOMB_S2", "Bombeiros Sapadores, Sala 2", "Avenida da Praia da Vitória", "20", "S"],
        ["BOMB_S3", "Bombeiros Sapadores, Sala 3", "Avenida da Praia da Vitória", "20", "S"],
        ["BOMB_S4", "Bombeiros Sapadores, Sala 4", "Avenida da Praia da Vitória", "20", "S"],
        ["BOMB_S5", "Bombeiros Sapadores, Sala 5", "Avenida da Praia da Vitória", "20", "S"],
        ["BOMB_S6", "Bombeiros Sapadores, Sala 6", "Avenida da Praia da Vitória", "20", "S"],
        ["BOMB_S7", "Bombeiros Sapadores, Sala 7", "Avenida da Praia da Vitória", "20", "S"],
        ["DMHU", "DMHU - Higiene Urbana", "Rua de S. Boaventura", "20", "S"],
        ["DMMC_BF", "DMMC - Sala Bela Flor", "Bairro da Bela Flor, Campolide", "15", "S"],
        ["DMMC_CG13", "DMMC - Campo Grande, 13 (Reuniões)", "Campo Grande, 13", "12", "S"],
        ["SS_CML", "Serviços Sociais CML", "Olaias, Lisboa", "20", "S"],
        ["TEAMS", "Teams (Online)", "Plataforma Microsoft Teams", "999", "S"],
        ["MOODLE", "Moodle (E-Learning)", "Plataforma Moodle CML", "999", "S"],
        ["JF_SCLARA", "Junta de Freguesia de Santa Clara", "Largo da Junta de Freguesia", "25", "S"]
    ],
    "Listas_Mailing.csv": [
        ["NOME_LISTA", "DESCRICAO", "ATIVO"],
        ["PILD - Oficinas Digitais", "Inscritos e interessados nas oficinas de literacia digital (PILD)", "S"],
        ["Newsletter Geral Formação", "Divulgação mensal de novos cursos e eventos da CML", "S"],
        ["Comunidade de Formadores", "Comunicação exclusiva com a bolsa de formadores internos/externos", "S"],
        ["Alumni Competências Digitais", "Ex-formandos interessados em formação contínua e certificada", "S"],
        ["IA e Futuro do Trabalho", "Grupo de interesse para workshops de IA Generativa e produtividade", "S"],
        ["Avisos Técnicos", "Comunicações de manutenção e atualizações da plataforma SGUF", "S"]
    ],
    "Catalogo_Medalhas.csv": [
        ["CODIGO", "NOME", "DESCRICAO", "URL_MEDALHA_DIGITAL", "URL_IMAGEM", "URL_CLAIM_BADGE", "ATIVO"],
        ["MED01", "Mestre em Excel", "Medalha atribuída após concluir Excel Avançado", "", "", "", "S"]
    ],
    "Tipos_Genero.csv": [
        ["CODIGO", "DESCRICAO", "ATIVO"],
        ["M", "Masculino", "S"],
        ["F", "Feminino", "S"],
        ["O", "Outro", "S"]
    ],
    "Tipos_Doc_Identificacao.csv": [
        ["CODIGO", "DESCRICAO", "ATIVO"],
        ["CC", "Cartão de Cidadão", "S"],
        ["BI", "Bilhete de Identidade", "S"],
        ["PASS", "Passaporte", "S"]
    ],
    "Tipos_Estado_Curso.csv": [
        ["CODIGO", "DESCRICAO", "ATIVO"],
        ["RASCUNHO", "Em Rascunho / Planeamento", "S"],
        ["ATIVO", "Aberto e Ativo", "S"],
        ["FECHADO", "Fechado / Arquivado", "S"]
    ],
    "Tipos_Area_Competencia.csv": [
        ["CODIGO", "NOME", "DESCRICAO", "ATIVO"],
        ["DIG_LIT", "Literacia Digital", "Competências base de uso de computador", "S"]
    ],
    "Tipos_Nivel_Proficiencia.csv": [
        ["CODIGO", "NOME", "DESCRICAO", "PONTUACAO_BASE", "ATIVO"],
        ["NIV_1", "Iniciação", "Conhecimentos básicos introdutórios", "1", "S"]
    ],
    "Tipos_Estado_Turma.csv": [
         ["CODIGO", "DESCRICAO", "ATIVO"],
         ["PLANEADA", "Planeada", "S"],
         ["A_DECORRER", "A Decorrer", "S"],
         ["CONCLUIDA", "Concluída", "S"]
    ],
    "Tipos_Estado_Matricula.csv": [
         ["CODIGO", "DESCRICAO", "ATIVO"],
         ["ATIVA", "Ativa na Turma", "S"],
         ["CANCELADA", "Cancelada / Desistência", "S"]
    ],
    "Tipos_Estado_Presenca.csv": [
         ["CODIGO", "DESCRICAO", "ATIVO"],
         ["CV", "Convocado", "S"],
         ["P", "Presente", "S"],
         ["F", "Falta Injustificada", "S"],
         ["FJ", "Falta Justificada", "S"]
    ],
    "Tipos_Nivel_Experiencia.csv": [
         ["CODIGO", "DESCRICAO", "ORDEM", "ATIVO"],
         ["NIV_0", "Nível 0 - Sem conhecimentos", "1", "S"],
         ["NIV_I", "Nível I - Conhecimentos Base", "2", "S"],
         ["NIV_II", "Nível II - Avançado", "3", "S"]
    ]
}

for nome_ficheiro, linhas in arquivos.items():
    caminho = os.path.join(dados_dir, nome_ficheiro)
    with open(caminho, 'w', newline='', encoding='utf-8-sig') as f:
        # Ponto e vírgula é o standard do Excel em PT
        writer = csv.writer(f, delimiter=';')
        writer.writerows(linhas)

print(f"CSVs de Nível 0 criados com sucesso na diretoria {dados_dir}")
