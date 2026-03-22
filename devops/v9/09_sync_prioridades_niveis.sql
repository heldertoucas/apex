-- 09_sync_prioridades_niveis.sql
-- SGUF v9 - Fase 7: Automação Inteligente de Triage (Chefias e Conhecimentos)

-- 1. ADICIONAR AS COLUNAS EM FALTA NA 'SALA DE ESPERA' (INSCRICOES)
ALTER TABLE Inscricoes ADD Prioridade_Chefia NUMBER CHECK (Prioridade_Chefia IN (1, 2, 3));
ALTER TABLE Inscricoes ADD ID_Nivel_Dominio NUMBER;
ALTER TABLE Inscricoes ADD CONSTRAINT FK_Inscricoes_Nivel 
    FOREIGN KEY (ID_Nivel_Dominio) REFERENCES Tipos_Nivel_Experiencia(ID_Nivel_Experiencia);

-- 2. TRIGGER A: QUANDO ALGUEM E MATRICULADO DIRETO NA TURMA
-- Se o nível não for preenchido pela pessoa que está a matricular,
-- o sistema vai procurar o nível ao questionário original da Inscrição.
CREATE OR REPLACE TRIGGER TRG_MATRICULAS_SYNC_NIVEL
BEFORE INSERT OR UPDATE OF ID_Nivel_Experiencia ON Matriculas
FOR EACH ROW
WHEN (NEW.ID_Nivel_Experiencia IS NULL)
DECLARE
    v_nivel_inscricao NUMBER;
    v_id_curso NUMBER;
BEGIN
    -- Descobrir de que curso é esta Turma
    SELECT ID_Curso INTO v_id_curso FROM Turmas WHERE ID_Turma = :NEW.ID_Turma;

    -- Tentar encontrar a Inscrição daquela pessoa para este mesmo curso
    BEGIN
        SELECT ID_Nivel_Dominio INTO v_nivel_inscricao
        FROM Inscricoes
        WHERE ID_Entidade = :NEW.ID_Aluno
          AND ID_Curso = v_id_curso
        ORDER BY Data_Registo DESC
        FETCH FIRST 1 ROW ONLY;

        -- Se encontrou um nível na inscrição, mete-o na Matrícula automaticamente!
        :NEW.ID_Nivel_Experiencia := v_nivel_inscricao;
        
    EXCEPTION WHEN NO_DATA_FOUND THEN
        -- Não faz mal, era uma matrícula direta sem inscrição ou a inscrição não tinha nível
        NULL;
    END;
END;
/

-- 3. TRIGGER B: QUANDO UM FORMADOR PREENCHE A PAUTA FINAL (Update da Matrícula)
-- Se na Matrícula for preenchido um nível final, e a Inscrição original estivesse vazia,
-- vamos atualizar a Inscrição por uma questão de Registo Histórico Limpo.
CREATE OR REPLACE TRIGGER TRG_INSCRICOES_SYNC_NIVEL
AFTER INSERT OR UPDATE OF ID_Nivel_Experiencia ON Matriculas
FOR EACH ROW
WHEN (NEW.ID_Nivel_Experiencia IS NOT NULL)
DECLARE
    v_id_curso NUMBER;
BEGIN
    -- Descobre o curso desta matrícula
    SELECT ID_Curso INTO v_id_curso FROM Turmas WHERE ID_Turma = :NEW.ID_Turma;

    -- Atualiza a inscrição original (SE E SÓ SE lá estivesse nulo)
    UPDATE Inscricoes
    SET ID_Nivel_Dominio = :NEW.ID_Nivel_Experiencia
    WHERE ID_Entidade = :NEW.ID_Aluno
      AND ID_Curso = v_id_curso
      AND ID_Nivel_Dominio IS NULL;
END;
/
