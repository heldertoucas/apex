-- 05_DummyData_Inscricao.sql
-- Objetivo: Gerar Alunos e Inscrições para testar o Fluxo de Matrícula (Cap 5)
-- Dep: 04_DummyData_Logistica (precisa de Turmas e Cursos)

BEGIN
    -- 1. Criar um Segundo Curso (para testar filtros de interesse)
    BEGIN
        INSERT INTO Cursos (ID_Programa, Codigo, Nome, Carga_Horaria)
        VALUES (
            (SELECT ID_Programa FROM Programas WHERE Codigo='LIT_DIG'), 
            'WORD_BASICO', 'Curso de Word Básico', 20
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
    END;

    -- 2. Criar 20 Candidatos Genéricos
    FOR i IN 1..20 LOOP
        BEGIN
            INSERT INTO Entidades (
                Nome_Completo, 
                Email, 
                NIF, 
                ID_Genero, 
                ID_Tipo_Doc,
                Ativo
            ) VALUES (
                'Candidato Teste ' || i,
                'candidato.' || i || '@teste.com',
                '9000000' || LPAD(i, 2, '0'), -- NIF Fake 900000001...
                (SELECT ID_Genero FROM Tipos_Genero WHERE Codigo = CASE WHEN MOD(i,2)=0 THEN 'M' ELSE 'F' END),
                (SELECT ID_Tipo_Doc FROM Tipos_Doc_Identificacao WHERE Codigo='CC'),
                'S'
            );
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;

    -- 3. Criar INSCRIÇÕES (O "Interesse" Prévio)
    
    -- Grupo A: Candidatos 1 a 10 querem EXCEL (Onde temos a Turma) -> Devem aparecer VERDES
    -- Grupo A1: Candidatos 1 a 5 querem EXPLICITAMENTE a Turma de Excel de Jan/2026 -> PRIORIDADE OURO
    FOR i IN 1..5 LOOP
        BEGIN
            INSERT INTO Inscricoes (ID_Curso, ID_Entidade, Estado_Inscricao, ID_Turma_Preferencia)
            VALUES (
                (SELECT ID_Curso FROM Cursos WHERE Codigo='EXCEL_BASICO'),
                (SELECT ID_Entidade FROM Entidades WHERE Email='candidato.'||i||'@teste.com'),
                'VALIDADO',
                (SELECT ID_Turma FROM Turmas WHERE Codigo_Turma='TURMA_EXCEL_01_2026')
            );
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;

    -- Grupo A2: Candidatos 6 a 10 querem "EXCEL" (Genérico, sem turma) -> PRIORIDADE VERDE
    FOR i IN 6..10 LOOP
        BEGIN
            INSERT INTO Inscricoes (ID_Curso, ID_Entidade, Estado_Inscricao, ID_Turma_Preferencia)
            VALUES (
                (SELECT ID_Curso FROM Cursos WHERE Codigo='EXCEL_BASICO'),
                (SELECT ID_Entidade FROM Entidades WHERE Email='candidato.'||i||'@teste.com'),
                'VALIDADO',
                NULL -- Sem preferência específica de turma
            );
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;

    -- Grupo B: Candidatos 11 a 15 querem WORD (Outro Curso) -> Devem aparecer CINZENTOS/GERAL na turma de Excel
    FOR i IN 11..15 LOOP
        BEGIN
            INSERT INTO Inscricoes (ID_Curso, ID_Entidade, Estado_Inscricao)
            VALUES (
                (SELECT ID_Curso FROM Cursos WHERE Codigo='WORD_BASICO'),
                (SELECT ID_Entidade FROM Entidades WHERE Email='candidato.'||i||'@teste.com'),
                'PENDENTE'
            );
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;

    -- Grupo C: Candidatos 16 a 20 não têm inscrição nenhuma -> Aparecem GERAL

    -- 4. Criar 1 MATRÍCULA JÁ EXISTENTE
    -- O Candidato 1 já foi matriculado na Turma de Excel -> NÃO deve aparecer na lista de disponíveis
    BEGIN
        INSERT INTO Matriculas (ID_Turma, ID_Aluno, ID_Estado_Matricula, Data_Inscricao)
        VALUES (
            (SELECT ID_Turma FROM Turmas WHERE Codigo_Turma='TURMA_EXCEL_01_2026'),
            (SELECT ID_Entidade FROM Entidades WHERE Email='candidato.1@teste.com'),
            (SELECT ID_Estado_Matricula FROM Tipos_Estado_Matricula WHERE Codigo='SELECIONADO'),
            SYSDATE - 1
        );
    EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL; 
    END;

    COMMIT;
END;
/
