# Guia de Planeamento: Estratégia de Importação de Dados

**Objetivo:** Definir como transformar ficheiros Excel brutos em registos válidos nas tabelas `Entidades` e `Inscricoes`.

---

## 1. Resposta às Questões Chave

### A. "Qual a melhor forma de preparar o ficheiro Excel?"
A melhor forma é criar um "Template Canónico" (Modelo Padrão) que a sua equipa deve tentar seguir.
*   **Cabeçalhos Limpos:** Use a 1ª linha apenas para nomes de colunas. Sem linhas em branco antes.
*   **Uma Pessoa por Linha:** Cada linha deve representar um indivíduo único.
*   **Valores de Texto (Lookups):** Para campos como "Género" ou "Habilitações", escreva o texto exato (ex: "Masculino", "Licenciatura") em vez de códigos numéricos. O sistema fará a tradução.
*   **Datas:** Formatar colunas de data como *Texto* (ex: "YYYY-MM-DD") ou garantir que o Excel as reconhece como data, para evitar erros de conversão.

### B. "Têm de ter o mesmo nome de campo?"
**Não, mas ajuda muito.**
*   **Mapeamento Manual:** O APEX permite mapear manualmente "Nome do Participante" (Excel) -> `NOME_COMPLETO` (Base de Dados) durante o wizard de importação.
*   **Mapeamento Automático:** Se os cabeçalhos do Excel coincidirem com os nomes das colunas da tabela de destino (ex: `EMAIL`, `NIF`), o APEX faz a correspondência automática, poupando tempo.

---

## 2. Estratégia Técnica: Importação via "Staging" (Recomendada)

Dado que uma "Pré-Inscrição" envolve tocar em várias tabelas (`Entidades`, `Inscricoes` e validação de duplicados), não devemos importar diretamente para as tabelas finais.

### O Fluxo Proposto:
1.  **Upload:** O utilizador carrega o Excel para uma tabela temporária: `STAGING_IMPORTACAO`.
2.  **Validação (O "Purgatório"):** O sistema apresenta uma grelha com os dados carregados e valida erros:
    *   *"Este NIF já existe?"*
    *   *"O email é válido?"*
    *   *"O curso 'Excel Avançado' existe?"*
3.  **Processamento:** Ao clicar em "Processar", um script PL/SQL move os dados válidos para as tabelas reais (`Entidades` e `Inscricoes`).

### C. "E se o Curso não existir? (Correção de Erros)"
**Sim, é possível corrigir antes de importar.**
Esta é a grande vantagem da tabela `Staging`:
1.  **Deteção:** O sistema "pinta" de vermelho as linhas onde o Curso (Ex: "Excel 2000") não tem correspondência na tabela `Cursos`.
2.  **Correção:** O utilizador clica na célula errada (na própria grelha do APEX) e corrige para "Excel V8" ou seleciona o ID correto de uma lista.
3.  **Revalidação:** O sistema valida novamente.
4.  **Conclusão:** Só quando a linha está válida é que o botão "Processar" a deixa passar.

---

## 3. Modelo do Ficheiro Excel (Exemplo)

Recomendo que o seu Excel tenha estas colunas base. O sistema será flexível, mas isto cobre 90% dos casos.

| Coluna Excel (Sugestão) | Tabela Destino | Campo Destino | Notas |
| :--- | :--- | :--- | :--- |
| **Nome Completo** | `Entidades` | `NOME_COMPLETO` | Obrigatório. |
| **Email** | `Entidades` | `EMAIL` | Obrigatório (Chave de unicidade). |
| **NIF** | `Entidades` | `NIF` | Melhor identificador único. |
| **Telemóvel** | `Entidades` | `TELEMOVEL` | |
| **Data Nascimento** | `Entidades` | `DATA_NASCIMENTO` | |
| **Género** | `Entidades` | `ID_GENERO` | O sistema procurará "Masculino" na tabela `Tipos_Genero`. |
| **Curso Interesse** | `Inscricoes` | `ID_CURSO` | O sistema procurará "Excel V8" na tabela `Cursos`. |
| **Data Interesse** | `Inscricoes` | `DATA_INTERESSE` | Data da candidatura. |

---

## 4. Próximos Passos Técnicos

Para implementar isto, precisaremos de:
1.  Criar a tabela `Staging_Importacao` (que tínhamos deixado em stand-by).
2.  Criar o **Data Load Wizard** em APEX apontando para esta tabela.
3.  Criar o processo PL/SQL `Processar_Importacao` para distribuir os dados.

Podemos avançar com a criação desta estrutura?
