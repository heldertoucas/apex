# Ponto de Situação - SGUF v9 (Passaporte Competências Digitais)
**Data:** 10 de Março de 2026

## Ponto de Situação Atual

A arquitetura e planeamento da nova versão do **SGUF (Sistema de Gestão de Utilizadores e Formação)**, designada por **v9**, encontram-se concluídos e prontos para a fase de materialização (construção da interface).

### 1. Base de Dados (Back-end)
* O novo modelo de dados (Esquema v9) está concebido para suportar uma experiência de utilizador "híbrida", permitindo o registo rápido de cidadãos e o enriquecimento progressivo de dados (perfil SIGO).
* O servidor MCP (Oracle Database) está ligado com sucesso ao workspace `PCD_CLOUD` (APEX 24.2.14).

### 2. Guiões de Implementação (Front-end APEX)
Foi criada uma biblioteca exaustiva de 6 Guias de Implementação detalhados na diretoria `devops/v9/`, que servirão de "guião step-by-step" para o desenvolvimento na plataforma Oracle APEX:
* **Guia 01:** Fundação da App, Shared LOVs e Dashboard Híbrido.
* **Guia 02:** Gestão de Entidades (Grelha de Triagem com Semáforos e Ficha de Cidadão).
* **Guia 03:** Catálogo Pedagógico (Programas, Cursos, Módulos).
* **Guia 04:** Gestão Operacional (Turmas, Sessões, Matrículas Automáticas).
* **Guia 05:** Motor de Automação de E-Mails (Envios transacionais e agendados).
* **Guia 06:** Fim de Ciclo (Avaliações, Dossier Pedagógico, Faturação e Importação em Massa).

### 3. Integração de Módulos Complementares (Opção A)
As funcionalidades periféricas idealizadas em iterações anteriores (v7 e v8) foram integradas de forma nativa e fluída nos Guiões da v9, nomeadamente:
* **Marketing:** Listas de Mailing (integradas no Guia 02).
* **Pedagogia Adicional:** Equipa Formativa Múltipla e Sumários de Sessões (integrados no Guia 04).
* **Logística e Qualidade:** Gestão de Equipamentos e Questionários de Feedback (integrados no Guia 06).

---

## Próximos Passos (Fase de Materialização)

Com o plano estrutural e documental fechado (detalhado em `apex-implementation-v9.md`), a equipa transita agora para a fase de **Execução no App Builder do Oracle APEX**.

**Metodologia a adotar:**
Dado que o APEX é uma plataforma *Low-Code* gerida de forma *metadata-driven* via interface Web, a construção dos ecrãs será efetuada manualmente pelos developers no Browser, seguindo rigorosamente a ordem estipulada nos 6 Guias. 

A automação e a assistência IA (via MCP) focar-se-ão na auditoria de código, resolução de erros na interface APEX e injeção do código PL/SQL profundo (Packages como `PKG_MATRICULAS` e Automações) diretamente na base de dados durante o progresso da construção.

**Próxima Ação Imediata:**
* Iniciar a construção da aplicação no workspace usando o **Guia 01**.
