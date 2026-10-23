# dim_employee_leave_request_type

[[_TOC_]]

Leave request type classifications sourced from the Emplive API.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `762` |
| Target table | `edw.dim_employee_leave_request_type` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Emplive API |

## Data lineage

```text
Emplive API
  └─ leave_types
       └─ ODS view: ETL.dim_employee_leave_request_type
            └─ landing.edw_dim_employee_leave_request_type             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_leave_request_type      (staging.insert_staging_dim_employee_leave_request_type)
                      └─ edw.dim_employee_leave_request_type           (edw.Updateedwdim_employee_leave_request_type)
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_employee_leave_request_type_key` | `int` | Surrogate primary key |
| `leave_request_type_id` | `nvarchar(36)` | Business key |
| `leave_request_type_code` | `nvarchar(255)` | Leave type code |
| `leave_request_type` | `nvarchar(255)` | Leave type description |

::: mermaid
erDiagram
    dim_employee_leave_request_type ||--o{ fact_employee_leave_request : "dim_employee_leave_request_type_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_leave_request AS fact
INNER JOIN edw.dim_employee_leave_request_type AS t
    ON fact.leave_request_type_id = t.leave_request_type_id
    AND t.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_leave_request_type` |
| Landing | `landing.edw_dim_employee_leave_request_type` |
| Staging | `staging.ODSETLdim_employee_leave_request_type` |
| Stored procedures | `staging.insert_staging_dim_employee_leave_request_type`, `edw.Updateedwdim_employee_leave_request_type` |
| Target | `edw.dim_employee_leave_request_type` |
