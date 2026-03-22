-- 08_pkg_matriculas.sql
-- SGUF v9 - Fase 6: Lógica de Negócio para Matrículas e Presenças

CREATE OR REPLACE PACKAGE PKG_MATRICULAS AS
    -- Função principal para inicializar registos de presenças "Convocado"
    -- ao inscrever um aluno numa turma com sessões pré-definidas.
    PROCEDURE Criar_Presencas_Auto(
        p_id_matricula IN NUMBER
    );
END PKG_MATRICULAS;
/

CREATE OR REPLACE PACKAGE BODY PKG_MATRICULAS AS

    PROCEDURE Criar_Presencas_Auto(
        p_id_matricula IN NUMBER
    ) IS
        v_id_turma NUMBER;
        v_id_estado_cv NUMBER;
    BEGIN
        -- Localizar ID_Turma
        SELECT ID_Turma INTO v_id_turma
        FROM Matriculas
        WHERE ID_Matricula = p_id_matricula;

        -- Localizar o ID do estado CV (Convocado)
        BEGIN
            SELECT ID_Estado_Presenca INTO v_id_estado_cv
            FROM Tipos_Estado_Presenca
            WHERE Codigo = 'CV';
        EXCEPTION WHEN NO_DATA_FOUND THEN
            -- Fallback para null se não encontrar, embora deva existir
            v_id_estado_cv := NULL;
        END;

        -- Inserir presenças para todas as sessões da turma
        FOR s_rec IN (SELECT ID_Sessao FROM Sessoes WHERE ID_Turma = v_id_turma) LOOP
            INSERT INTO Presencas (ID_Sessao, ID_Matricula, ID_Estado_Presenca, Horas_Assistidas)
            VALUES (s_rec.ID_Sessao, p_id_matricula, v_id_estado_cv, 0);
        END LOOP;

    EXCEPTION WHEN OTHERS THEN
        raise_application_error(-20001, 'Erro a gerar presenças automáticas: ' || SQLERRM);
    END;

END PKG_MATRICULAS;
/
