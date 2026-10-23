# EmpLive - nb_emplive_api_bronze

Notebook: `nb_emplive_api_bronze`. Loads the EmpLive REST API into `lh_bronze.emplive.<endpoint name>`. Replaces the ADF *Extract Emplive API Master / Child* pipelines.

Back to [EmpLive - Notebook Summary](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary). Helpers: [EmpLive - nb_emplive_common](/BI-Team/Documentation-%2D-Data-Dudes/Fabric-Conversion/Datasource-to-Bronze-Notebooks/EmpLive-%2D-Notebook-Summary/EmpLive-%2D-nb_emplive_common).

## What it does

- Logs in with `Emplive-Api-User` / `Emplive-Api-Key` from Key Vault. The token is refreshed in the notebook when it is older than `token_max_age_min` or when a call returns 401. There is no writing tokens back to Key Vault and no 18-minute Until loop.
- For each endpoint in `endpoints_json` (taken from the old `configuration.json`), requests `?page=0,1,2...` until a page is empty. It follows RFC 5988 `Link: rel="next"` headers when the API sends them, as the ADF Copy did.
- Stops if the API returns the same page twice (it ignored the page parameter) and fails if `max_pages` is reached.
- Retries 429 and 5xx responses, honouring `Retry-After`.
- Top-level JSON fields become text columns. Nested objects and arrays are kept as JSON text. Booleans become `true` / `false`.
- Loads with the dedupe-on-row-hash pattern. `_first_seen_batch` / `_last_seen_batch` hold the run timestamp (`yyyyMMddHHmm`, NZ time).

## Endpoints

| Name | Endpoint | Bronze table |
|---|---|---|
| `leave_requests` | `/leaverequests` | `lh_bronze.emplive.leave_requests` |
| `leave_codes` | `/leavecodes` | `lh_bronze.emplive.leave_codes` |
| `leave_types` | `/leavetypes` | `lh_bronze.emplive.leave_types` |
| `leave_requestchanges` | `/leaverequestchanges` | `lh_bronze.emplive.leave_requestchanges` |

To add an endpoint, add an entry to `endpoints_json`. Use `endpoint_filter` to run a single endpoint.

## Parameters

| Parameter | Purpose |
|---|---|
| `key_vault_url`, `api_user_secret`, `api_key_secret` | Where the API credentials are read from |
| `api_base_url` | EmpLive API base URL |
| `endpoints_json`, `endpoint_filter` | Endpoints to load, optionally just one |
| `start_page`, `max_pages` | First page and a safety stop per endpoint |
| `token_max_age_min`, `request_timeout_s` | Token refresh age and request timeout |
| `target_schema`, `load_mode` | `lh_bronze.emplive`, `dedupe` or `append` |

## Output

- Tables: `lh_bronze.emplive.<endpoint name>`.
- Log: `lh_bronze.control.emplive_load_log` (`source = 'api'`, `source_object` is the endpoint name, `source_file` is the endpoint path).
- Notebook exit value: JSON with `run_id`, `batch_no`, `endpoints_loaded` and `failed`. The notebook raises an error if any endpoint failed.

Default lakehouse: `lh_bronze` (schema-enabled).
