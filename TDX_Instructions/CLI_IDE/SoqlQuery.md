# SOQL Query Editor and Query Planner

## Overview

Write, execute, and optimize SOQL queries directly in VS Code with intelligent code completion, syntax highlighting, and performance analysis.

## Setup

Enable code completion by refreshing SObject definitions:

- Command Palette (`Cmd+Shift+P`): **SFDX: Refresh SObject Definitions**

Open [getContacts.soql](../../scripts/soql/getContacts.soql)

Demonstrate with intelligent autocomplete for SObjects, fields, and relationships by modifying the query and adding `FirstName` to the selected fields.

## Executing Queries

Four execution methods:

1. **Selected Text**: Highlight query → Command Palette → **SFDX: Execute SOQL Query with Currently Selected Text**  
2. **In a .soql File:** Code lens at the top (if the language of the file is not `soql`, you need to manually change it to `soql` in the status bar for the code lens to appear)  
3. **In a .soql File:** Command Palette → **SFDX: Execute SOQL Query with Current File**  
4. **SOQL Builder**: Command Palette → **SFDX: Create Query in SOQL Builder** → Visual interface

Results display in the **Output** panel with record count, field values, and execution time.

## Query Plan Analysis

Optimize performance by analyzing the query execution plan. Four methods:

1. **Selected Text**: Highlight query → Command Palette → **SFDX: Get SOQL Query Plan with Currently Selected Text**  
2. **In a .soql File:** Code lens at the top (if the language of the file is not `soql`, you need to manually change it to `soql` in the status bar for the code lens to appear)  
3. **In a .soql File:** Command Palette → **SFDX: Get SOQL Query Plan with Current File**  
4. **In the SOQL query Builder** → "Get Query Plan" button


**Key Metrics**:

- **relativeCost**: < 0.3 (good), 0.3-0.7 (moderate), > 0.7 (needs optimization)
- **leadingOperationType**: "Index" (good), "TableScan" (slow - full table scan)

**Optimization Tips**:

1. Filter on indexed fields: Id, Name, Email, OwnerId, CreatedDate, SystemModstamp
2. Avoid NOT operators (!=, NOT) - prevents index usage
3. Use selective filters to reduce cardinality
4. Add LIMIT clauses
5. Request custom indexes from Salesforce when needed

## FAQs

| Question                                    | Response                                                                           |
| ------------------------------------------- | ---------------------------------------------------------------------------------- |
| Where should I store .soql files?           | In `scripts/soql` or outside `sfdx-project.json` directories to prevent deployment |
| Why isn't code completion working?          | Run **SFDX: Refresh SObject Definitions** from Command Palette                     |
| What's the difference between REST/Tooling? | REST queries data records; Tooling queries metadata                                |
| How do I know if my query uses an index?    | Query plan shows `leadingOperationType: "Index"` (good) or "TableScan" (slow)      |
| What does relativeCost mean?                | 0-1 scale: < 0.3 (good), 0.3-0.7 (moderate), > 0.7 (needs optimization)            |
