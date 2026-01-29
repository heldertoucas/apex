-- Script para extrair informações do esquema atual (Tabelas e Colunas)
-- Execute este script no SQL Workshop do APEX para validar o estado atual da BD
-- e comparar com o modelo de dados.

-- 1. Listar todas as tabelas e comentários
SELECT 
    t.table_name,
    c.comments as table_comment
FROM user_tables t
LEFT JOIN user_tab_comments c ON t.table_name = c.table_name
ORDER BY t.table_name;

-- 2. Detalhes das Colunas (Nome, Tipo, Tamanho, Nullable)
SELECT 
    table_name,
    column_name,
    data_type,
    data_length,
    data_precision,
    data_scale,
    nullable,
    column_id
FROM user_tab_columns
ORDER BY table_name, column_id;

-- 3. Constraints (Primary Keys, Foreign Keys, Unique)
SELECT 
    uc.table_name,
    uc.constraint_name,
    uc.constraint_type,
    ucc.column_name,
    uc.search_condition -- Para Check Constraints
FROM user_constraints uc
JOIN user_cons_columns ucc ON uc.constraint_name = ucc.constraint_name
WHERE uc.constraint_type IN ('P', 'R', 'U', 'C') -- Primary, Referential, Unique, Check
ORDER BY uc.table_name, uc.constraint_type;

-- 4. Resumo Rápido (Tabela | Contagem de Linhas - aproximado stats)
SELECT 
    table_name, 
    num_rows 
FROM user_tables
ORDER BY table_name;
