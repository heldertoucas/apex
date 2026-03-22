-- 10_extensao_futuro.sql
-- SGUF v9 - Extensão para o Programa FUTURO e Contexto Multi-Programa

-- 1. Extensões de Tabelas Core
ALTER TABLE Entidades ADD (
    UO VARCHAR2(100),
    Tem_Portatil CHAR(1) DEFAULT 'N' CHECK (Tem_Portatil IN ('S','N'))
);

ALTER TABLE Inscricoes ADD (
    ID_Programa NUMBER,
    Prioridade_Inicial NUMBER,
    Score_Diagnostico NUMBER,
    Prioridade_Final NUMBER
);

-- Adicionar FK para Programa em Inscricoes
ALTER TABLE Inscricoes ADD CONSTRAINT FK_Inscricoes_Programa FOREIGN KEY (ID_Programa) REFERENCES Programas(ID_Programa);

-- 2. Seed Data: Programas
-- Garantir que os 3 programas base existem
MERGE INTO Programas p
USING (
    SELECT 'PASS' as Codigo, 'Programa de Autodiagnóstico e Suporte' as Nome FROM DUAL UNION ALL
    SELECT 'FUTURO' as Codigo, 'Programa FUTURO: Competências Digitais' as Nome FROM DUAL UNION ALL
    SELECT 'IAPT' as Codigo, 'Inovação e Apoio Pedagógico e Tecnológico' as Nome FROM DUAL
) src
ON (p.Codigo = src.Codigo)
WHEN NOT MATCHED THEN
    INSERT (Codigo, Nome) VALUES (src.Codigo, src.Nome);

-- 3. Seed Data: Modelos de Comunicação (FUTURO)
INSERT INTO Modelos_Comunicacao (Codigo_Ref, Assunto, Contexto, Corpo_HTML)
VALUES (
    'FUTURO_INVITE_DIAGNOSTICO', 
    'Convite: Realize o seu Diagnóstico de Competências Digitais (Programa FUTURO)', 
    'ALUNO',
    '<p>Olá <strong>#NOME#</strong>,</p><p>Foi selecionado(a) para participar no Programa FUTURO. O primeiro passo é a realização de um diagnóstico de competências.</p><p>Por favor, aceda ao seguinte link: <a href="#LINK#">Realizar Diagnóstico</a></p>'
);

INSERT INTO Modelos_Comunicacao (Codigo_Ref, Assunto, Contexto, Corpo_HTML)
VALUES (
    'FUTURO_QUIZ_RECEIVED', 
    'Diagnóstico Recebido: Próximos Passos', 
    'ALUNO',
    '<p>Olá <strong>#NOME#</strong>,</p><p>Recebemos o seu diagnóstico com sucesso. Estamos agora a validar a sua prioridade de formação com o seu departamento (UO: #UO#).</p><p>Entraremos em contacto assim que tivermos uma vaga disponível.</p>'
);

INSERT INTO Modelos_Comunicacao (Codigo_Ref, Assunto, Contexto, Corpo_HTML)
VALUES (
    'FUTURO_WAITING_LIST', 
    'Atualização de Estado: Lista de Espera', 
    'ALUNO',
    '<p>Olá <strong>#NOME#</strong>,</p><p>Informamos que se encontra na lista de espera para o curso de Teams e SharePoint. Entraremos em contacto brevemente.</p>'
);

-- 4. Seed Data: Regras de Comunicação (FUTURO)
-- Estas regras serão disparadas manualmente via botão ou processo automático em APEX
INSERT INTO Regras_Comunicacao (Nome_Regra, Momento_Envio, Exige_Presenca, ID_Modelo)
VALUES ('FUTURO: Convite Diagnóstico', 0, 'N', (SELECT ID_Modelo FROM Modelos_Comunicacao WHERE Codigo_Ref = 'FUTURO_INVITE_DIAGNOSTICO'));

INSERT INTO Regras_Comunicacao (Nome_Regra, Momento_Envio, Exige_Presenca, ID_Modelo)
VALUES ('FUTURO: Confirmação Quiz', 0, 'N', (SELECT ID_Modelo FROM Modelos_Comunicacao WHERE Codigo_Ref = 'FUTURO_QUIZ_RECEIVED'));

INSERT INTO Regras_Comunicacao (Nome_Regra, Momento_Envio, Exige_Presenca, ID_Modelo)
VALUES ('FUTURO: Lista de Espera', 0, 'N', (SELECT ID_Modelo FROM Modelos_Comunicacao WHERE Codigo_Ref = 'FUTURO_WAITING_LIST'));

COMMIT;
