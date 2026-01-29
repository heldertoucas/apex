-- 06_DummyData_Pedagogia.sql
-- Objetivo: Gerar dados de teste para o Capítulo 6 (Presenças, Notas, Medalhas)
-- Inclui agora a geração de SESSÕES para garantir que há aulas para marcar presenças.

BEGIN
    -- 0. Gerar Sessões para as Turmas (Se não existirem)
    -- Cria 10 sessões para cada turma ativa/planeada
    FOR r_turma IN (SELECT ID_Turma, Data_Inicio FROM Turmas) LOOP
        -- Verificar se já tem sessões
        DECLARE
            v_qtd NUMBER;
        BEGIN
            SELECT count(*) INTO v_qtd FROM Sessoes WHERE ID_Turma = r_turma.ID_Turma;
            
            IF v_qtd = 0 THEN
                -- Criar 5 sessões no Passado (para ter presenças) e 5 no Futuro
                FOR i IN 1..5 LOOP
                    INSERT INTO Sessoes (ID_Turma, Nome, Data_Sessao, Hora_Inicio, Hora_Fim, Duracao_Horas)
                    VALUES (
                        r_turma.ID_Turma, 
                        'Sessão Prática ' || i, 
                        r_turma.Data_Inicio + i, -- Dias seguidos a partir do inicio
                        '09:00', '13:00', 4
                    );
                END LOOP;
            END IF;
        END;
    END LOOP;

    -- 1. Gerar Presenças (Assiduidade)
    -- Para cada Sessão que já aconteceu (data < sysdate), marcar presenças
    FOR r_sessao IN (
        SELECT s.ID_Sessao, s.ID_Turma, s.Duracao_Horas
          FROM Sessoes s
         WHERE s.Data_Sessao < SYSDATE + 100 -- Truque: Marcar para todas (passado e futuro proximo) para ver dados já
    ) LOOP
        -- Para cada aluno Matriculado na turma dessa sessão
        FOR r_aluno IN (
            SELECT ID_Matricula 
              FROM Matriculas 
             WHERE ID_Turma = r_sessao.ID_Turma
               AND ID_Estado_Matricula IN (SELECT ID_Estado_Matricula FROM Tipos_Estado_Matricula WHERE Codigo IN ('INSCRITO','SELECIONADO','FREQUENTAR'))
        ) LOOP
            -- Evitar duplicados
            BEGIN
                -- 90% de probabilidade de estar presente
                IF DBMS_RANDOM.VALUE < 0.9 THEN
                    INSERT INTO Presencas (ID_Sessao, ID_Matricula, Horas_Assistidas, Data_Registo)
                    VALUES (r_sessao.ID_Sessao, r_aluno.ID_Matricula, r_sessao.Duracao_Horas, SYSDATE - DBMS_RANDOM.VALUE(1,10));
                ELSE
                    -- 10% de faltar
                     INSERT INTO Presencas (ID_Sessao, ID_Matricula, Horas_Assistidas, Data_Registo)
                    VALUES (r_sessao.ID_Sessao, r_aluno.ID_Matricula, 0, SYSDATE - DBMS_RANDOM.VALUE(1,10));               
                END IF;
            EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
    END LOOP;

    -- 2. Gerar Avaliações (Notas)
    FOR r_turma IN (SELECT ID_Turma, ID_Curso FROM Turmas) LOOP
        FOR r_modulo IN (SELECT ID_Modulo FROM Modulos WHERE ID_Curso = r_turma.ID_Curso) LOOP
            FOR r_aluno IN (
                SELECT ID_Matricula 
                  FROM Matriculas 
                 WHERE ID_Turma = r_turma.ID_Turma
            ) LOOP
                BEGIN
                    INSERT INTO Avaliacoes_Modulo (ID_Matricula, ID_Modulo, Nota_Valor, Aprovado, Feedback_Texto)
                    VALUES (r_aluno.ID_Matricula, r_modulo.ID_Modulo, TRUNC(DBMS_RANDOM.VALUE(10, 20)), 'S', 'Bom trabalho.');
                EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
                END;
            END LOOP;
        END LOOP;
    END LOOP;

    -- 3. Definir Medalhas Elegíveis
    FOR r_turma IN (SELECT ID_Turma FROM Turmas) LOOP
        FOR r_medalha IN (SELECT * FROM (SELECT ID_Medalha FROM Catalogo_Medalhas ORDER BY DBMS_RANDOM.VALUE) WHERE ROWNUM <= 2) LOOP
            BEGIN
                INSERT INTO Turma_Medalhas_Elegiveis (ID_Turma, ID_Medalha, Selecionado_Por)
                VALUES (r_turma.ID_Turma, r_medalha.ID_Medalha, 'TEST_USER');
            EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
    END LOOP;

    COMMIT;
END;
/
