# EmpLive - nb_emplive_common

Shared helpers for the EmpLive bronze loads. It is not run on its own. [nb_emplive_sftp_bronze](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_sftp_bronze) and [nb_emplive_api_bronze](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_api_bronze) pull it in with `%run nb_emplive_common`.

Back to [EmpLive - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary) or [Fabric Conversion - Overview](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion).

## 1. Header (markdown)

Describes the bronze load pattern: text columns, `_row_hash` dedupe, first / last seen history, and safe re-runs.

## 2. Imports, constants and setup

- Imports `re`, `json`, PySpark, Delta and `ZoneInfo`.
- `NZ_TZ` is Pacific/Auckland.
- Turns on Delta `schema.autoMerge`, so a `MERGE` can add new source columns to an existing table instead of failing.
- `META_COLS` lists the metadata columns added to every table.
- The load log is `lh_bronze.control.emplive_load_log`.

## 3. Helper functions

| Function | What it does |
|---|---|
| `to_snake` | `RosterEntryPayInterpretation` becomes `roster_entry_pay_interpretation`. Used for table names. |
| `clean_columns` | Makes column names Delta / SQL-endpoint safe: replaces special characters, removes a BOM, prefixes names starting with a digit (`c_`) or an underscore (`src_`), and de-duplicates. Keeps source casing. |
| `table_exists` | Checks whether a table exists by querying it and catching `AnalysisException`. |
| `ensure_schema` | Runs `CREATE SCHEMA IF NOT EXISTS`. |
| `add_row_hash` | Builds `_row_hash` from `to_json(struct(...))` over the sorted source columns, ignoring `_`-prefixed columns. `to_json` drops nulls, so a new null column does not change existing hashes. |
| `upsert_bronze` | The core loader (below). |
| `write_load_log` | Appends one row per file / endpoint to the load-log table (`LOAD_LOG_SCHEMA`). Errors are truncated to 4000 characters. |
| `loaded_objects` | Returns the source objects (for example zip names) whose files all succeeded in their latest run. The SFTP notebook uses it to skip zips already loaded. |
| `run_id` | NZ-time timestamp `yyyyMMddTHHmmss` that tags a run in the log. |

### `upsert_bronze`

1. Clean the column names, cast every column to string, add `_row_hash`, count rows read, and drop duplicate hashes inside the file.
2. Add the metadata columns: first / last seen date and batch, source, source file and load timestamp.
3. **Table does not exist:** write a new Delta table, source columns first and metadata last.
4. **`load_mode = "append"`:** append with `mergeSchema`, no dedupe.
5. **Otherwise (dedupe):**
   - Fill columns the table has but the file lacks with nulls, so the insert lines up.
   - Delta `MERGE` on `_row_hash`:
     - matched and the new batch is later: move `_last_seen_*` and `_load_ts` forward;
     - matched and the new batch is earlier: move `_first_seen_*` back;
     - not matched: insert the row.
   - Read the inserted / updated counts from the Delta history `operationMetrics`.
6. Return `rows_read`, `rows_inserted` and `rows_updated`.
