-- 07_DummyData_Admin.sql
-- Objetivo: Gerar dados de teste para o Capítulo 7 (Admin)
-- Requisito: Ter corrido 07_Admin.sql previamente.

BEGIN
    -- 1. Gerar Faturas para Formadores
    -- Para cada Formador que deu sessões no passado
    FOR r_formador IN (
        SELECT DISTINCT ID_Formador 
          FROM Sessoes 
         WHERE Data_Sessao < SYSDATE
           AND ID_Formador IS NOT NULL
    ) LOOP
        -- Criar uma fatura
        INSERT INTO Faturas_Formadores (ID_Formador, Num_Fatura, Valor, Mes_Ref, Estado, Data_Emissao, Observacoes)
        VALUES (
            r_formador.ID_Formador, 
            'FT-' || TO_CHAR(SYSDATE, 'YYYY') || '-' || TRUNC(DBMS_RANDOM.VALUE(100, 999)),
            TRUNC(DBMS_RANDOM.VALUE(500, 1500), 2), -- Valor entre 500 e 1500
            TO_CHAR(ADD_MONTHS(SYSDATE, -1), 'YYYY-MM'), -- Mês anterior
            'EMITIDA',
            SYSDATE - 5,
            'Honorários de Formação'
        );
    END LOOP;

    -- 2. Inicializar Dossier para Turmas Ativas
    -- Simula que o coordenador verificou alguns documentos
    FOR r_turma IN (SELECT ID_Turma FROM Turmas WHERE ROWNUM <= 5) LOOP
        -- Inserir itens obrigatórios
        FOR r_doc IN (SELECT ID_Tipo_Doc FROM Tipos_Documento_Dossier WHERE Obrigatorio = 'S') LOOP
            BEGIN
                INSERT INTO Itens_Dossier_Turma (ID_Turma, ID_Tipo_Doc, Presente, Validado_Por, Data_Validacao)
                VALUES (
                    r_turma.ID_Turma,
                    r_doc.ID_Tipo_Doc,
                    CASE WHEN DBMS_RANDOM.VALUE < 0.7 THEN 'S' ELSE 'N' END, -- 70% chance de ter entregue
                    'COORD_TESTE',
                    SYSDATE
                );
            EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
            END;
        END LOOP;
    END LOOP;

    -- 3. Alocar Equipamentos
    FOR r_turma IN (SELECT ID_Turma FROM Turmas WHERE ROWNUM <= 3) LOOP
        BEGIN
            INSERT INTO Equipamentos_Alocados (ID_Turma, ID_Tipo_Equipamento, Quantidade, Data_Entrega, Responsavel_Entrega)
            VALUES (
                r_turma.ID_Turma,
                (SELECT ID_Tipo_Equipamento FROM Tipos_Equipamento WHERE Codigo = 'PC_PORTATIL'),
                15, -- 15 PCs
                SYSDATE - 20,
                'Logística Central'
            );
        EXCEPTION WHEN DUP_VAL_ON_INDEX THEN NULL;
        END;
    END LOOP;

    COMMIT;
END;
/
