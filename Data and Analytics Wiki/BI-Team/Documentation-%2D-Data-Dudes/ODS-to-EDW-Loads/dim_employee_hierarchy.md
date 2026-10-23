# dim_employee_hierarchy

[[_TOC_]]

Employee organizational reporting hierarchy — models manager-to-subordinate relationships and reporting lines. Loads in phase `102` to ensure [dim_employee](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_employee) (phase `101`) completes first.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `478` |
| Target table | `edw.dim_employee_hierarchy` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `102 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | IntelliHR |

## Data lineage

```text
IntelliHR (REST API)
  ├─ people
  └─ JOBS
       └─ ODS view: ETL.dim_employee_hierarchy
            └─ landing.edw_dim_employee_hierarchy             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_hierarchy      (staging.insert_staging_dim_employee_hierarchy)
                      └─ edw.dim_employee_hierarchy           (edw.Updateedwdim_employee_hierarchy)
```

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_employee_hierarchy_key` | `int` | Surrogate primary key | — |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |
| `employee_primary_email_address` | `nvarchar(100)` | Employee email | — |
| `employee_company_name` | `nvarchar(200)` | Company name | — |

::: mermaid
erDiagram
    dim_employee ||--o{ dim_employee_hierarchy : "dim_employee_key"
:::

## Direct business key join pattern

```sql
FROM edw.dim_employee_hierarchy AS h
INNER JOIN edw.dim_employee AS e
    ON h.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
WHERE h.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_hierarchy` |
| Landing | `landing.edw_dim_employee_hierarchy` |
| Staging | `staging.ODSETLdim_employee_hierarchy` |
| Stored procedures | `staging.insert_staging_dim_employee_hierarchy`, `edw.Updateedwdim_employee_hierarchy` |
| Target | `edw.dim_employee_hierarchy` |

## Notes

- Phase `102` guarantees `dim_employee` finishes loading prior to rebuilding the hierarchy table.
