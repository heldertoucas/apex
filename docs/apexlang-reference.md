# APEXlang Reference — Oracle APEX 26.1 AI App Builder Specification

Official Reference Link: https://docs.oracle.com/en/database/oracle/apex/26.1/apxln/?component=app

## Overview
**APEXlang** is the domain-specific declarative language introduced in Oracle APEX 26.1 enabling GenAI App Builders and AI Agents to programmatically construct, inspect, and modify APEX applications.

## Key Component Structure

### 1. `app` (Root Application Container)
High-level application properties, supporting:
- `aiAgent` (Embedded AI agents and tool definitions)
- `appProcess` (Application logic and processes)
- `appItem` (Application items)
- `appComputation` (Computations)
- `appSetting` (Configurable app parameters)
- `authentication` & `authorization` (Security schemes)

### 2. `aiAgent` (Native AI Agent Integration)
Declares AI agent capabilities within the APEX app:
- `tool` types:
  - `executeClientsideCode`: Dynamic client JS execution.
  - `executeServersideCode`: PL/SQL or server script invocation.
  - `retrieveData`: Data fetching and retrieval queries.
- `parameter`: Explicit parameter contracts for agent tools.

### 3. AI Process Execution (`generateTextWithAi`)
- `appProcess (generateTextWithAi)`: Built-in process type to trigger GenAI inference directly inside application workflows.

## Formal Specification
- **Version**: Oracle APEX 26.1.0 (Identifier `G57748-03`)
- **EBNF Grammar**: `apexlang.ebnf`
