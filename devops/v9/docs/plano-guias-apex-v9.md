# Planeamento da Biblioteca de Guias APEX (SGUF v9)

## Goal
Construir iterativamente uma biblioteca de guias passo-a-passo melhorada, completa e detalhada para o desenvolvimento da aplicação Oracle APEX (v9), integrando o novo modelo de dados (Automação de Comunicações, PKG_MATRICULAS) e implementando a Experiência de Utilizador da **Opção C (Modelo Híbrido)** para a gestão de candidatos e matrículas.

## Tasks

- [ ] Task 1: Escrever `Guia_01_Fundacao_Dashboard.md` → Verificável se contém instruções de criação da App APEX, Lists of Values (Lookups) e o Dashboard inicial.
- [ ] Task 2: Escrever `Guia_02_Gestao_Entidades_UX_Hibrida.md` → Verificável se contém a criação da tabela interativa de Entidades, incluindo as lógicas de validação "Semáforo" (Verde/Amarelo) baseadas no NIF/Género (Opção C).
- [ ] Task 3: Escrever `Guia_03_Catalogo_Pedagogico.md` → Verificável se inclui ecrãs Mestre-Detalhe para Cursos > Módulos > Competências > Medalhas.
- [ ] Task 4: Escrever `Guia_04_Turmas_Matriculas.md` → Verificável se incorpora a gestão da Pré-Inscrição para a Matrícula e aborda o preenchimento automático de Presenças via `PKG_MATRICULAS.Criar_Presencas_Auto`.
- [ ] Task 5: Escrever `Guia_05_Automacao_Emails.md` → Verificável se detalha as interfaces de edição de Modelos e Regras, e explica como integrar os Logs com o APEX.
- [ ] Task 6: Escrever `Guia_06_Avaliacao_e_Importacao.md` → Verificável se detalha as grelhas de avaliação, faturação, itens do dossier e o módulo de staging para importar de Excel.

## Done When
- [ ] Todos os 6 guias (Capítulos) foram gerados e revistos, cobrindo 100% da nova estrutura SGUF v9 e a arquitetura UX Híbrida desenhada (Self-service/Triagem).
