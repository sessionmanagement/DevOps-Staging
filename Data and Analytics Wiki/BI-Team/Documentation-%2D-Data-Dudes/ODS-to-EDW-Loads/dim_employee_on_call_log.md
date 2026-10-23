# dim_employee_on_call_log

[[_TOC_]]

On-call log dimension classification for employee on-call duties and escalations.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `813` |
| Target table | `edw.dim_employee_on_call_log` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 1 (in-place merge) |
| Source system | On Call |

## Data lineage

```text
On Call System
  └─ ODS view: ETL.dim_employee_on_call_log
       └─ landing.edw_dim_employee_on_call_log             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_employee_on_call_log      (staging.insert_staging_dim_employee_on_call_log)
                 └─ edw.dim_employee_on_call_log           (edw.Updateedwdim_employee_on_call_log)
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_employee_on_call_log_key` | `int` | Surrogate primary key |
| `on_call_id` | `int` | Business key |

::: mermaid
erDiagram
    dim_employee_on_call_log ||--o{ fact_employee_on_call_log : "dim_employee_on_call_log_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_on_call_log AS fact
INNER JOIN edw.dim_employee_on_call_log AS l
    ON fact.on_call_id = l.on_call_id
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_on_call_log` |
| Landing | `landing.edw_dim_employee_on_call_log` |
| Staging | `staging.ODSETLdim_employee_on_call_log` |
| Target | `edw.dim_employee_on_call_log` |

## Notes

- Lineage details to be confirmed as system extract evolves.
