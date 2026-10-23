# dim_employee_qualification_type

[[_TOC_]]

Employee qualification type dimension sourced from IntelliHR.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `722` |
| Target table | `edw.dim_employee_qualification_type` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | IntelliHR |

## Data lineage

```text
IntelliHR (REST API)
  └─ qualification_types
       └─ ODS view: ETL.dim_employee_qualification_type
            └─ landing.edw_dim_employee_qualification_type             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_qualification_type      (staging.insert_staging_dim_employee_qualification_type)
                      └─ edw.dim_employee_qualification_type           (edw.Updateedwdim_employee_qualification_type)
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_employee_qualification_type_key` | `int` | Surrogate primary key |
| `employee_qualification_type_id` | `nvarchar(36)` | Business key |
| `employee_qualification_type` | `nvarchar(30)` | Qualification type category name |

::: mermaid
erDiagram
    dim_employee_qualification_type ||--o{ fact_employee_qualification : "dim_employee_qualification_type_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_qualification AS fact
INNER JOIN edw.dim_employee_qualification_type AS qt
    ON fact.employee_qualification_type_id = qt.employee_qualification_type_id
    AND qt.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_qualification_type` |
| Landing | `landing.edw_dim_employee_qualification_type` |
| Staging | `staging.ODSETLdim_employee_qualification_type` |
| Stored procedures | `staging.insert_staging_dim_employee_qualification_type`, `edw.Updateedwdim_employee_qualification_type` |
| Target | `edw.dim_employee_qualification_type` |
