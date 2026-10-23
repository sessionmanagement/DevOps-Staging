# Business Central - nb_bc_ingest

Notebook: `nb_bc_ingest`. Metadata-driven load of Business Central into `lh_bronze.bc.bc_<entity>`. One notebook ingests every enabled entity for every company, with no company- or entity-specific code.

Back to [Business Central - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/Business-Central-%2D-Notebook-Summary). Setup: [Business Central - nb_bc_setup_control](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/Business-Central-%2D-Notebook-Summary/Business-Central-%2D-nb_bc_setup_control).

## What it does

1. **Token:** OAuth client credentials, one token per run, refreshed when it nears expiry or on a 401. The client secret comes from Key Vault secret `Business-Central-API`.
2. **Companies:** discovered from `/api/v2.0/companies`.
3. **Control table:** `bc_ingestion_control` is synced. Every template row (`company_id = '*'`) is expanded to one row per company. New rows inherit the template; existing rows only have `company_name` refreshed.
4. **Load:** entities run in parallel (`max_parallel_entities`, keep 5 or fewer as BC allows about 5 concurrent requests per user). Companies within an entity run in sequence, so each bronze table has one writer at a time.
5. **Per load:** read the watermark, call the API with an OData filter, follow `@odata.nextLink`, write bronze in batches, then update the watermark and run status.

## API client

- Retries 408, 429, 500, 502, 503 and 504 and network errors with exponential backoff and jitter. `Retry-After` is honoured.
- One forced token refresh on 401.
- Page size is set with `Prefer: odata.maxpagesize`.

## Load behaviour

| Situation | Bronze write |
|---|---|
| `full` mode, or first incremental load (no watermark) | Replace that company's slice (`replaceWhere company_id = ...`) |
| `incremental` with a watermark | Append rows where `incremental_column gt watermark - overlap` |
| `record_reload_from` set | Delete company rows from that date, reload from that date, then clear the override |

- Incremental bronze is append-only. The overlap window (`watermark_overlap_minutes`, default 5) can re-read a few rows, so Silver must de-duplicate on `company_id` + `systemId`, keeping the latest `systemModifiedAt` / `_ingested_at`.
- The new watermark is the highest `incremental_column` value landed. It never moves backwards on an empty read.
- An empty full load deletes that company's rows from the table.
- BC blank dates (`0001-01-01`) are ignored for watermarks. Parquet rebase mode is set to `CORRECTED` so they can be written.
- By default all primitives are landed as strings (`bronze_all_strings`) to avoid type-drift failures. Schema evolution (`mergeSchema`) adds new BC fields.

## Bronze tables and columns

- Table: `lh_bronze.bc.bc_<entity in snake_case>` (for example `customerLedgerEntries` becomes `bc_customer_ledger_entries`). All companies are in one table.
- Added columns: `company_id`, `company_name`, `_bc_environment`, `_ingested_at`, `_run_id`.
- Source column names are made Delta-safe (spaces and `,;{}()=` replaced with `_`). `@odata` fields are dropped.

## Parameters

| Parameter | Purpose |
|---|---|
| `bc_tenant_id`, `bc_environment`, `bc_client_id` | BC connection (defaults are the dev sandbox from `ls_REST_Business_Central`) |
| `key_vault_uri`, `kv_secret_client_id`, `kv_secret_client_secret` | Key Vault and secret names. `kv_secret_client_id` is only used if `bc_client_id` is blank |
| `table_namespace`, `control_table`, `bronze_table_prefix` | Where bronze tables and the control table live |
| `entity_filter`, `company_filter` | Limit a run, for example `customers,items` or `CRONUS NZ` |
| `force_full_load` | Treat every entity as full for this run |
| `new_companies_enabled` | `False`: companies not yet in the control table are added disabled |
| `page_size`, `write_batch_rows` | API page size and rows buffered per Delta write |
| `watermark_overlap_minutes` | Re-read window for in-flight BC transactions |
| `bronze_all_strings` | Land primitives as strings |
| `max_retries`, `base_backoff_seconds`, `max_backoff_seconds`, `request_timeout_seconds` | Retry and timeout settings |
| `max_parallel_entities` | Entities loaded concurrently |
| `fail_on_error` | Raise at the end if any load failed |

## Output

- Tables: `lh_bronze.bc.bc_<entity>`.
- Log: per company and entity in `bc_ingestion_control` (`last_run_time`, `last_run_row_count`, `last_run_status`, `last_run_error_message`, `last_success_watermark`). Errors are truncated to 4000 characters.
- Notebook exit value: JSON with `run_id`, `loads`, `failed` and `rows`. The notebook raises an error after all loads are attempted if any failed.

## Running it

- **First run:** companies are added disabled. Enable them with the `MERGE` printed in the log, then run again.
- **One entity or company:** set `entity_filter` / `company_filter`.
- **Reload a period:** set `record_reload_from` on the control row.
- **Full reload:** clear `last_success_watermark` or set `force_full_load = True`.

Default lakehouse: `lh_bronze`. Control table default: `lh_bronze.control.bc_ingestion_control`.

## Next step: Silver

A generic Silver step can keep the latest row per `company_id` + `systemId` (ordered by `systemModifiedAt` then `_ingested_at` descending), cast types, and `MERGE` into the Silver table.
