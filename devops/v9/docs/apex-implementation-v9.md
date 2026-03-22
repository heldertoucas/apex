# Planeamento de Construção APEX SGUF v9

## Goal
Implementar de forma iterativa e estruturada a nova aplicação APEX ("Passaporte Digital SGUF v9"), com base nos 6 Guias de Implementação detalhados desenvolvidos e na base de dados (Esquema v9) existente. A construção será faseada para permitir testes contínuos de cada módulo antes de avançar para o seguinte.

## Tasks
- [ ] Task 1: **Fundação da Aplicação e Configurações Base** (Guia 01). → Verify: Criação da App V9. Theme Customizations feitas. LOVs (List of Values) Partilhadas Mapeadas. Dashboard de Métricas visível na Home Page (Page 1) e configurado com a View de "Semáforos".
- [ ] Task 2: **Módulo de Pessoas e Gestão de Mailing** (Guia 02 + Opção A). → Verify: Existência da "Grelha de Triagem" (Interactive Grid) com iconografia (Verde/Amarelo/Vermelho). Criação da Ficha de Entidade dividida por Tabs. Processo PL/SQL customizado a gravar corretamente o Checkbox Group de Mailing Lists.
- [ ] Task 3: **Módulo do Catálogo Formativo** (Guia 03). → Verify: Relatório de Programas criado. Master-Detail hierárquico construído para Cursos e Módulos. Existência do Modal popup para mapeamento M:N (Módulo <> Competências do Referencial).
- [ ] Task 4: **Módulo Operacional Logístico** (Guia 04 + Opção A). → Verify: Ficha de Turma refatorada com "Sessões Agendadas" e "Equipa Formativa" em detalhe. Automação PL/SQL validada: O botão de "Matricular" deverá executar o pacote e gerar os devidos códigos e linhas pendentes na listagem de Presenças.
- [ ] Task 5: **Motor Central de Automação de E-Mails** (Guia 05). → Verify: Módulo de Templates HTML funcional. Regras de agendamento transacionais. "APEX Automation" mapeado e ativo a chamar o `PKG_COMUNICACAO.Processar_Fila` a cada X minutos com monitorização via Cockpit de Logs (Enviado/Erro).
- [ ] Task 6: **Avaliação, Dossier e Extensibilidade** (Guia 06 + Opção A). → Verify: Existência da Pauta Numérica por Módulo conectável a sistema SIGO. Grelha Editável da Checklist do Dossier e de Equipamentos Atribuídos. Formulamento robusto na Página "Cockpit Data Loading" permitindo importação através de Excel Staging e exibição dos Alertas.

## Done When
- [ ] As 6 Tasks correspondentes aos 6 pilares do SGUF v9 APEX App foram concluídas de forma sucessiva e funcional.
- [ ] Os scripts PL/SQL de Packages e Triggers comportam-se de forma fiável como Back-end da Interface APEX para a automação de Turmas/Emails/Presenças.
