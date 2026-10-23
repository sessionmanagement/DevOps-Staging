# Business Central - nb_bc_setup_control

Notebook: `nb_bc_setup_control`. One-off setup for the Business Central ingestion framework. Creates the control table `bc_ingestion_control` and seeds the entity templates.

Back to [Business Central - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/Business-Central-%2D-Notebook-Summary). The load notebook is [Business Central - nb_bc_ingest](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/Business-Central-%2D-Notebook-Summary/Business-Central-%2D-nb_bc_ingest).

## How the control table works

- A **template row** has `company_id = '*'`. It defines an entity once: `api_path`, incremental column, load mode and enabled flag.
- At run time `nb_bc_ingest` creates a **per-company row** from each template (`load_key = <company_id>|<entity>`). New companies and new templates are picked up automatically.
- Per-company rows can then be tuned independently: disable one company, force a reload date, or switch to full.

To add an entity later, insert one template row. No code change.

## What it does

- **Parameters:** `table_namespace` (default `lh_bronze.dbo`), `control_table` (default `bc_ingestion_control`) and `custom_api_path` (default `api/theta/emergeAPI/v1.0`, the Emerge custom API route from the ADF linked service `ls_REST_Business_Central`).
- **Create table:** `CREATE TABLE IF NOT EXISTS` as Delta. Safe to re-run.
- **Seed templates:** builds the 23 templates in a temp view and `MERGE`s them on `load_key` with `WHEN NOT MATCHED THEN INSERT`. Existing templates are not overwritten.

## Control table columns

| Column | Purpose |
|---|---|
| `load_key` | `company_id|entity` (`*|entity` for templates) |
| `company_id`, `company_name` | BC company GUID or `*`, and name (refreshed each run) |
| `entity`, `api_path` | API entity set and its route under the environment root |
| `incremental_column` | Column for the OData incremental filter (`systemModifiedAt`) |
| `load_mode` | `incremental` or `full` |
| `record_reload_from` | Optional override: purge and reload bronze from this date, cleared after a successful run |
| `last_success_watermark` | Highest `incremental_column` value loaded by the last successful run |
| `last_run_time`, `last_run_row_count`, `last_run_status`, `last_run_error_message` | Result of the last run |
| `enabled` | Only enabled rows are loaded |

## Seeded entities

All entities expose `systemId` (key) and `systemModifiedAt` (incremental column).

| Load mode | Entities |
|---|---|
| `incremental` | `bankAccounts`, `bankAccountLedgerEntries`, `customers`, `customerLedgerEntries`, `detailedCustLedgEntries`, `dimensionSetEntries`, `fixedAssets`, `faDepreciationBooks`, `faLedgerEntries`, `glAccounts`, `glEntries`, `vatEntries`, `vendors`, `vendorLedgerEntries`, `detailedVendorLedgEntries` |
| `full` | `accountingPeriods`, `dimensions`, `dimensionValues`, `defaultDimensions`, `dimHierarchySetups`, `dimensionHierarchies`, `vatPostingSetups`, `glBudgetEntries` |

- **Incremental:** ledger entries (BC never deletes posted entries) and master data.
- **Full:** small setup tables and tables where rows are deleted or rebuilt (budgets, default dimensions). An incremental load cannot see deletions.
- Masters can occasionally be deleted in BC. If that matters, schedule a periodic full refresh by clearing `last_success_watermark` for those rows.

## Useful control operations

```sql
-- add a custom API entity for every company
INSERT INTO lh_bronze.bc_ingestion_control VALUES
  ('*|projectTasks','*',NULL,'projectTasks','api/contoso/projects/v1.0','systemModifiedAt','incremental',
   NULL,NULL,NULL,NULL,NULL,NULL,true);

-- enable a company that was added disabled
MERGE INTO lh_bronze.bc_ingestion_control t
USING (SELECT entity, enabled FROM lh_bronze.bc_ingestion_control WHERE company_id = '*') s
ON t.entity = s.entity AND t.company_name IN ('Emerge NZ')
WHEN MATCHED THEN UPDATE SET t.enabled = s.enabled;

-- purge and reload customers for one company from 1 July
UPDATE lh_bronze.bc_ingestion_control SET record_reload_from = TIMESTAMP'2026-07-01'
WHERE company_name = 'CRONUS NZ' AND entity = 'customers';

-- force a full reload of an entity for all companies next run
UPDATE lh_bronze.bc_ingestion_control SET last_success_watermark = NULL
WHERE entity = 'items' AND company_id <> '*';
```

Adjust the table name in these examples to match `table_namespace` and `control_table`.

Default lakehouse: `lh_bronze`.
