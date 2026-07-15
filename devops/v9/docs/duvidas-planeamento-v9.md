# Questões Pendentes e Explorações (SGUF v9)

Este documento centraliza as dúvidas levantadas durante a fase de planeamento do SGUF v9, mapeando-as para futuras explorações ou transformando-as em tarefas de implementação.

---

## 1. Registo de Dúvidas & Análise Técnica

### ❓ Dúvida 1: Ligação ao SIGO (BD Atual do Ministério da Educação)
* **Descrição:** Como será realizada a integração e sincronização de dados com o sistema SIGO?
* **Ações/Explorações:**
  - Identificar os formatos de exportação/importação aceites pelo SIGO (XML, CSV, etc.).
  - Desenhar as tabelas de staging necessárias no APEX para validação prévia de dados antes da submissão.
  - Verificar se existe API/Webservice disponível ou se o processo continuará a ser por carregamento manual de ficheiros.

### ❓ Dúvida 2: Integração do Processo Atual de Certificação
* **Descrição:** De que forma o APEX gerará, registará e validará a emissão de certificados digitais de competências?
* **Ações/Explorações:**
  - Mapear a transição de estados do aluno desde a conclusão com aproveitamento até à emissão do certificado.
  - Avaliar o uso de assinaturas digitais ou chaves de verificação públicas para os certificados gerados.

### ❓ Dúvida 3: Ligação aos Quizzes de Avaliação do Futuro Digital
* **Descrição:** Como serão capturadas as respostas e resultados dos quizzes de avaliação gerados no ecossistema Futuro Digital?
* **Ações/Explorações:**
  - Mapear os Webhooks ou APIs de receção de quiz-submissões (ex: integração com MS Forms ou quiz-engines customizados).
  - Validar como a pontuação final dos quizzes é processada e associada automaticamente ao formando na tabela Avaliacoes_Modulo.

### ❓ Dúvida 4: Ligação ao Registo de Avaliações do Portal Futuro Digital
* **Descrição:** Como integrar a pauta de classificações do SGUF v9 com o portal atual do Futuro Digital?
* **Ações/Explorações:**
  - Especificar a sincronização de dados entre a base de dados do portal e o repositório Oracle APEX.
  - Mapear fluxos de reconciliação de notas para garantir que não há divergências entre sistemas.

### ❓ Dúvida 5: Funcionamento do Estado do Participante
* **Descrição:** Como funcionam as regras de transição de estado automática do participante ao longo da sua jornada (Inscrito, Selecionado, Matriculado, Convocado, Desistente, Concluído)?
* **Ações/Explorações:**
  - Desenhar uma matriz de transição de estados.
  - Implementar triggers e lógicas no pacote PL/SQL PKG_MATRICULAS para garantir a integridade dessas mudanças.

### ❓ Dúvida 6: Melhoria do Registo de Presenças e Comunicações por E-Mail
* **Descrição:** Como otimizar a usabilidade do controlo de presenças no APEX e robustecer as comunicações transacionais?
* **Ações/Explorações:**
  - Simplificar o ecrã de assiduidade na UI do APEX utilizando Interactive Grids rápidas.
  - Mapear o cockpit de controlo de logs de email (Log_Comunicacoes) com alertas visuais claros em caso de falha de envio.

---

## 2. Roadmap de Resolução (Tarefas)
* [ ] **Fase A (Arquitetura):** Definir matriz de estados do formando (Dúvida 5).
* [ ] **Fase B (Integração):** Desenhar especificações da API de Webhooks para Quizzes (Dúvida 3).
* [ ] **Fase C (Exportação):** Criar templates de ficheiros para integração com o SIGO (Dúvida 1).
