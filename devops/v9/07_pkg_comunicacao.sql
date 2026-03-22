-- 07_pkg_comunicacao.sql
-- SGUF v9 - Fase 6: Sistema de Automação de Comunicações (Motor PL/SQL)

CREATE OR REPLACE PACKAGE PKG_COMUNICACAO AS
    -- Função para substituir variáveis (O "Motor")
    FUNCTION Processar_Template(
        p_modelo_id IN NUMBER,
        p_aluno_id  IN NUMBER DEFAULT NULL,
        p_turma_id  IN NUMBER DEFAULT NULL
    ) RETURN CLOB;

    -- Função para encontrar o template correto (com fallback)
    FUNCTION Get_Modelo_Id(
        p_codigo_ref IN VARCHAR2,
        p_curso_id   IN NUMBER DEFAULT NULL
    ) RETURN NUMBER;

    -- Procedimento para Agendar um Email (Colocar na Fila)
    PROCEDURE Agendar_Email(
        p_para          IN VARCHAR2,
        p_assunto       IN VARCHAR2,
        p_corpo         IN CLOB,
        p_data_agendada IN TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        p_origem        IN VARCHAR2 DEFAULT NULL
    );

    -- Procedimento para Disparar Emails Pendentes (Será usado pela Automação)
    PROCEDURE Processar_Fila;
END PKG_COMUNICACAO;
/

CREATE OR REPLACE PACKAGE BODY PKG_COMUNICACAO AS

    FUNCTION Get_Modelo_Id(
        p_codigo_ref IN VARCHAR2,
        p_curso_id   IN NUMBER DEFAULT NULL
    ) RETURN NUMBER IS
        l_id NUMBER;
    BEGIN
        BEGIN
            SELECT ID_Modelo INTO l_id 
            FROM Modelos_Comunicacao 
            WHERE Codigo_Ref = p_codigo_ref 
              AND ID_Curso = p_curso_id
              AND Ativo = 'S';
            RETURN l_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            NULL; 
        END;

        BEGIN
            SELECT ID_Modelo INTO l_id 
            FROM Modelos_Comunicacao 
            WHERE Codigo_Ref = p_codigo_ref 
              AND ID_Curso IS NULL
              AND Ativo = 'S';
            RETURN l_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RETURN NULL; 
        END;
    END;

    FUNCTION Processar_Template(
        p_modelo_id IN NUMBER,
        p_aluno_id  IN NUMBER DEFAULT NULL,
        p_turma_id  IN NUMBER DEFAULT NULL
    ) RETURN CLOB IS
        l_html      CLOB;
        l_assunto   VARCHAR2(200);
        l_nome      VARCHAR2(200);
        l_curso     VARCHAR2(200);
        l_turma_ref VARCHAR2(100);
        l_data_inicio VARCHAR2(20);
    BEGIN
        SELECT Corpo_HTML INTO l_html FROM Modelos_Comunicacao WHERE ID_Modelo = p_modelo_id;

        IF p_aluno_id IS NOT NULL THEN
            SELECT Nome_Completo INTO l_nome FROM Entidades WHERE ID_Entidade = p_aluno_id;
            l_html := REPLACE(l_html, '#NOME#', l_nome);
        END IF;

        IF p_turma_id IS NOT NULL THEN
            SELECT c.Nome, t.Codigo_Turma, TO_CHAR(t.Data_Inicio, 'DD/MM/YYYY')
            INTO l_curso, l_turma_ref, l_data_inicio 
            FROM Turmas t JOIN Cursos c ON t.ID_Curso = c.ID_Curso
            WHERE t.ID_Turma = p_turma_id;
            
            l_html := REPLACE(l_html, '#CURSO#', l_curso);
            l_html := REPLACE(l_html, '#TURMA#', l_turma_ref); 
            l_html := REPLACE(l_html, '#DATA_INICIO#', l_data_inicio);
        END IF;

        RETURN l_html;
    EXCEPTION WHEN OTHERS THEN 
        RETURN 'Erro ao processar template: ' || SQLERRM;
    END;

    PROCEDURE Agendar_Email(
        p_para          IN VARCHAR2,
        p_assunto       IN VARCHAR2,
        p_corpo         IN CLOB,
        p_data_agendada IN TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        p_origem        IN VARCHAR2 DEFAULT NULL
    ) IS
    BEGIN
        INSERT INTO Log_Comunicacoes (Destinatario, Assunto, Corpo_HTML, Data_Agendada, Contexto_Origem)
        VALUES (p_para, p_assunto, p_corpo, p_data_agendada, p_origem);
    END;

    PROCEDURE Processar_Fila IS
        v_errmsg VARCHAR2(4000);
    BEGIN
        FOR r IN (SELECT * FROM Log_Comunicacoes WHERE Estado = 'PENDENTE' AND Data_Agendada <= CURRENT_TIMESTAMP) LOOP
            BEGIN
                APEX_MAIL.SEND(
                    p_to   => r.Destinatario,
                    p_from => r.Remetente,
                    p_subj => r.Assunto,
                    p_body => TO_CLOB('Por favor ative HTML para ler este email.'), 
                    p_body_html => r.Corpo_HTML
                );
                
                UPDATE Log_Comunicacoes SET Estado = 'ENVIADO', Data_Envio = CURRENT_TIMESTAMP WHERE ID_Log = r.ID_Log;
            EXCEPTION WHEN OTHERS THEN
                v_errmsg := SUBSTR(SQLERRM, 1, 4000);
                UPDATE Log_Comunicacoes SET Estado = 'ERRO', Erro_Msg = v_errmsg WHERE ID_Log = r.ID_Log;
            END;
        END LOOP;
        
        -- Apenas chamamos push queue se estivermos no contexto do APEX.
        -- Como isto pode correr num job, fazemos block exception para n falhar.
        BEGIN
             APEX_MAIL.PUSH_QUEUE;
        EXCEPTION WHEN OTHERS THEN NULL;
        END;
    END;
END PKG_COMUNICACAO;
/
