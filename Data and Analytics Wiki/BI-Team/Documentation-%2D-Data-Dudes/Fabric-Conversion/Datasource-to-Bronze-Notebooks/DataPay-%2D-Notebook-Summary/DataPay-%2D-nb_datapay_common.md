# DataPay - nb_datapay_common

> **Status: draft. The notebook has not been run in Fabric yet.**

Shared helpers for the DataPay bronze loads. It is a copy of [nb_emplive_common](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_common) with the changes listed below. It is not run on its own: [nb_datapay_report_bronze](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/DataPay-%2D-Notebook-Summary/DataPay-%2D-nb_datapay_report_bronze) pulls it in with `%run nb_datapay_common`.

Back to [DataPay - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/DataPay-%2D-Notebook-Summary).

## How it is used

- It must be in the same Fabric workspace under this exact name.
- `%run nb_datapay_common` must be alone in its cell and must be run before any helper is used. If `%run` is skipped or fails, later cells fail with errors such as `NameError: name 'run_id' is not defined`.
- To check the helpers loaded:

```python
print({n: n in globals() for n in ["to_snake", "upsert_bronze", "write_load_log", "run_id", "LOAD_LOG_TABLE"]})
```

After it runs, the report notebook uses `run_id()`, `to_snake()`, `ensure_schema()`, `upsert_bronze(...)` and `write_load_log([...])`.

## Bronze load pattern

- Every source column is kept as text, exactly as received.
- `_row_hash` is a SHA-256 of the row's source columns (JSON of the non-null values, columns sorted by name). A reordered column or a new, empty column does not change the hash of existing rows.
- A row never seen before is inserted. An identical row only has its `_last_seen_*` columns moved forward.
- Re-running the same window is safe (idempotent).

## Difference from `nb_emplive_common`

- **Report window columns:** DataPay reports are a rolling date window. Rows carry `_report_start_date` and `_report_end_date`, added **after** the row hash is calculated. Overlapping daily windows therefore do not insert the same rows again. (The ADF pipeline added `start-date` / `end-date` as data columns, which would have made every window a new set of rows.)
- **Own load log:** `lh_bronze.control.datapay_load_log`.
- **No `loaded_objects`:** the report is a rolling window, so nothing is skipped as "already loaded".
- **`write_load_log(rows)`** takes only the rows (EmpLive's version also took a schema name that was never used).

## Sections

### 1. Header (markdown)
Describes the bronze load pattern and why the report-window columns are kept outside the hash.

### 2. Imports, constants and setup (code)
- Imports `re`, `json`, `traceback`, PySpark, Delta and `ZoneInfo`. The report notebook relies on these (for example `json`, `traceback`, `datetime`).
- `NZ_TZ` is Pacific/Auckland.
- Turns on Delta `schema.autoMerge`, so a `MERGE` can add new source columns to an existing table instead of failing.
- `META_COLS` lists the metadata columns added to every table (see below).
- `LOAD_LOG_TABLE` is `lh_bronze.control.datapay_load_log`.

### 3. Helper functions (same code cell)

| Function | What it does |
|---|---|
| `to_snake` | Converts names such as `CostAllocations` to `cost_allocations`. Used for table names. |
| `clean_columns` | Makes column names Delta / SQL-endpoint safe: replaces special characters, removes a BOM, prefixes names starting with a digit (`c_`) or an underscore (`src_`), and de-duplicates. Keeps source casing. |
| `table_exists` | Checks whether a table exists by querying it and catching `AnalysisException`. |
| `ensure_schema` | Runs `CREATE SCHEMA IF NOT EXISTS`. |
| `add_row_hash` | Builds `_row_hash` from `to_json(struct(...))` over the sorted source columns, ignoring `_`-prefixed columns. `to_json` drops nulls, so adding a new null column later does not change existing hashes. |
| `upsert_bronze` | The core loader (below). |
| `write_load_log` | Appends one row per run to the load-log table using `LOAD_LOG_SCHEMA`. Errors are truncated to 4000 characters. |
| `run_id` | NZ-time timestamp `yyyyMMddTHHmmss` that tags a run in the log. |

## Metadata columns

| Column | Meaning |
|---|---|
| `_row_hash` | SHA-256 of the source columns |
| `_first_seen_date`, `_first_seen_batch` | Extract that first contained the row |
| `_last_seen_date`, `_last_seen_batch` | Latest extract that contained the row |
| `_report_start_date` | Start of the report window of the extract that first saw the row |
| `_report_end_date` | End of the report window of the latest extract that saw the row |
| `_source`, `_source_file` | `report` and the raw file path the row came from |
| `_load_ts` | UTC time of the load |

## `upsert_bronze(df, full_table, batch_no, extract_date, source, source_file, load_mode, report_start, report_end)`

1. Clean the column names, cast every column to string, add `_row_hash`, count rows read, and drop duplicate hashes inside the file.
2. Add the metadata columns: first / last seen date and batch, the report window (`report_start`, `report_end`), source, source file and load timestamp.
3. **Table does not exist:** write a new Delta table, source columns first and metadata last.
4. **`load_mode = "append"`:** append with `mergeSchema`, no dedupe.
5. **Otherwise (dedupe):**
   - Fill columns the table has but the file lacks with nulls, so the insert lines up.
   - Delta `MERGE` on `_row_hash`:
     - matched and the new batch is later: move `_last_seen_*`, `_report_end_date` and `_load_ts` forward;
     - matched and the new batch is earlier (a back-load): move `_first_seen_*` and `_report_start_date` back;
     - not matched: insert the row.
   - Read the inserted / updated counts from the Delta history `operationMetrics`.
6. Return `rows_read`, `rows_inserted` and `rows_updated`.

A back-loaded older window never moves `_last_seen_*` backwards.

## Load log (`LOAD_LOG_SCHEMA`)

| Column | Meaning |
|---|---|
| `source` | `report` |
| `source_object` | Report name, for example `cost_allocations` |
| `source_file` | Raw file path under `Files/`, or empty when the report had no data |
| `target_table` | Bronze table that was loaded |
| `batch_no`, `extract_date` | Run timestamp `yyyyMMddHHmm` and the NZ run date |
| `rows_read`, `rows_inserted`, `rows_updated` | Counts from `upsert_bronze` (`rows_updated` = rows seen again) |
| `status`, `error` | `succeeded` or `failed`, and the error text |
| `run_id`, `load_ts` | Run id from `run_id()` and the UTC time of the log write |
