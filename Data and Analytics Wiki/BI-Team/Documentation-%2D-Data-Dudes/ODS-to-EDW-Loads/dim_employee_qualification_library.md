# dim_employee_qualification_library

[[_TOC_]]

Employee qualification library item dimension sourced from IntelliHR.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `721` |
| Target table | `edw.dim_employee_qualification_library` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | IntelliHR |

## Data lineage

```text
IntelliHR (REST API)
  └─ qualification_library_items
       └─ ODS view: ETL.dim_employee_qualification_library
            └─ landing.edw_dim_employee_qualification_library             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_qualification_library      (staging.insert_staging_dim_employee_qualification_library)
                      └─ edw.dim_employee_qualification_library           (edw.Updateedwdim_employee_qualification_library)
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_employee_qualification_library_key` | `int` | Surrogate primary key |
| `employee_qualification_library_id` | `nvarchar(36)` | Business key |
| `employee_qualification_library` | `nvarchar(60)` | Qualification library name |
| `job_requirement_usage_count` | `int` | Job requirement usage count |

::: mermaid
erDiagram
    dim_employee_qualification_library ||--o{ fact_employee_qualification : "dim_employee_qualification_library_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_qualification AS fact
INNER JOIN edw.dim_employee_qualification_library AS ql
    ON fact.employee_qualification_library_id = ql.employee_qualification_library_id
    AND ql.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_qualification_library` |
| Landing | `landing.edw_dim_employee_qualification_library` |
| Staging | `staging.ODSETLdim_employee_qualification_library` |
| Stored procedures | `staging.insert_staging_dim_employee_qualification_library`, `edw.Updateedwdim_employee_qualification_library` |
| Target | `edw.dim_employee_qualification_library` |
