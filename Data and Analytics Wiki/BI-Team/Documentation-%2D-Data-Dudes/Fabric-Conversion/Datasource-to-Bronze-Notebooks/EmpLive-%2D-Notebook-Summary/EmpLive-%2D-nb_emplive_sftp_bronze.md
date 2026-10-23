# EmpLive - nb_emplive_sftp_bronze

Notebook: `nb_emplive_sftp_bronze`. Loads the EmpLive SFTP batch files into `lh_bronze.emplive.<table>` in one step.

Back to [EmpLive - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary). Helpers: [EmpLive - nb_emplive_common](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_common).

## What it does

1. Lists `Batch########.zip` files on the EmpLive SFTP server (one zip per day). Sub-folders are scanned 3 levels deep.
2. Skips zips already loaded successfully (checked against `lh_bronze.control.emplive_load_log`).
3. For each new zip, **oldest batch first**:
   - copies the zip to `Files/emplive/sftp/raw/yyyy/MM/dd/` (kept for replay);
   - unzips it into a temporary work folder;
   - loads each `Batch########_<Table>.csv` into `lh_bronze.emplive.<table>` (snake_case), every column as text, using the dedupe-on-row-hash pattern;
   - writes one log row per file and deletes the work folder.
4. Raises an error at the end if any file failed. Failed zips are retried automatically on the next run.

## Requirements

- Default lakehouse: `lh_bronze` (schema-enabled).
- Library: `paramiko` (add it to the workspace Environment).
- Key Vault secret `EmpLive-sFTP` holds the SFTP password.

## Parameters

| Parameter | Purpose |
|---|---|
| `key_vault_url`, `sftp_secret_name` | Where the SFTP password is read from |
| `sftp_host`, `sftp_port`, `sftp_user`, `sftp_root` | SFTP connection and the folder to scan |
| `sftp_host_key` | Optional pinned host key. Blank accepts the key and prints its fingerprint (as ADF did). |
| `lookback_days` | Only look at zips modified in the last N days. `0` means everything on the server. |
| `batch_filter` | Load or reload a single batch, e.g. `Batch00001480` |
| `force_reload` | Reload zips even if already loaded. This is safe because dedupe makes it idempotent. |
| `target_schema`, `load_mode` | `lh_bronze.emplive`, `dedupe` or `append` |
| `raw_folder`, `work_folder` | Where raw zips and temporary files go under `Files/` |

## Extract date and batch number

- **Batch number** comes from the zip name (`Batch00001480` is batch 1480).
- **Extract date** comes from a `yyyyMMdd` in the parent folder name if there is one (the ADF pipeline did this). Otherwise it is the zip's modified date in NZ time.

## Output

- Tables: `lh_bronze.emplive.<table>`, one per CSV type.
- Log: `lh_bronze.control.emplive_load_log` (`source = 'sftp'`, `source_object` is the zip name, `source_file` is the CSV).
- Notebook exit value: JSON with `run_id`, `zips_loaded`, `zips_failed` and `failed`.

## Notes

- Zero-byte CSV files are logged as succeeded with 0 rows.
- A zip with no `Batch*_<Table>.csv` files is logged as failed.
