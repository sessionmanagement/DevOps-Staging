# dim_leave_type

[[_TOC_]]

Payroll leave type dimension — categorizes employee leave entitlements and taken leave (Annual Leave, Sick Leave, Bereavement, Alternative Holidays, etc.) mapped between Datapay and Emplive.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `541` |
| Target table | `edw.dim_leave_type` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 1 (in-place merge) |
| Source systems | Datapay, Emplive, Reference lookups |

## Data lineage

```text
Datapay / Emplive / Reference Lookups
  ├─ Datapay: companies, leave_types
  ├─ Emplive: time_categories
  └─ Reference: reference.edw_lookup (Category = 'dim_leave_type.leave_type_name')
       └─ ODS view: ETL.dim_leave_type
            └─ landing.edw_dim_leave_type             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_leave_type      (staging.insert_staging_dim_leave_type)
                      └─ edw.dim_leave_type           (edw.Updateedwdim_leave_type)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_leave_type_key` | `int` | Surrogate primary key (identity 1, 1) | — |
| `leave_type_id` | `nvarchar(50)` | Primary business key | Datapay / Emplive |
| `leave_type_name` | `nvarchar(50)` | Leave type name | — |
| `leave_type_group` | `nvarchar(50)` | High-level leave category grouping | — |
| `leave_type_company_name` | `nvarchar(50)` | Company scope | `edw.dim_company` |

::: mermaid
erDiagram
    dim_leave_type ||--o{ fact_employee_leave : "leave_type_id / dim_leave_type_key"
    dim_leave_type ||--o{ fact_employee_hours_worked : "dim_leave_type_key"
:::

## Direct business key join pattern

To join using `leave_type_id`, match directly:

```sql
FROM edw.fact_employee_leave AS fact
INNER JOIN edw.dim_leave_type AS lt
    ON fact.leave_type_id = lt.leave_type_id
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_leave_type` |
| Landing | `landing.edw_dim_leave_type` |
| Staging | `staging.ODSETLdim_leave_type` |
| Reference | `reference.EDW_Lookup` |
| Stored procedures | `staging.insert_staging_dim_leave_type`, `edw.Updateedwdim_leave_type` |
| Target | `edw.dim_leave_type` |

## Notes

- **Reference standardisation**: Staging applies `reference.EDW_Lookup` transformations on `dim_leave_type.leave_type_name` to unify differences in leave descriptions between Emplive and Datapay.
