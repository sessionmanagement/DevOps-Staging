# dim_location_new

[[_TOC_]]

The conformed enterprise location dimension — unifies physical workplace locations from **IntelliHR** with financial accounting locations from **Business Central**.

> **Supersedes legacy table.** `dim_location_new` (DataLoadId 774) replaces the legacy `dim_location` (DataLoadId 477). All current finance and HR facts connect to `dim_location_new`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `774` |
| Target table | `edw.dim_location_new` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Business Central, IntelliHR |

## Data lineage

```text
Business Central (dimensionValues) / IntelliHR (locations)
  ├─ Business Central: dimensionValues (dimensionCode = LOCATE)
  └─ IntelliHR: locations
       └─ ODS view: ETL.dim_location_new
            └─ landing.edw_dim_location_new             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_location_new      (staging.insert_staging_dim_location_new)
                      └─ edw.dim_location_new           (edw.Updateedwdim_location_new)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_location_key` | `int` | Surrogate primary key (identity 1, 1) | — |
| `dim_location_code_company_key` | `nvarchar(4000)` | Composite natural key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `intelliHR_location_id` | `nvarchar(36)` | IntelliHR location GUID | IntelliHR |
| `business_central_location_id` | `nvarchar(max)` | Business Central location ID | Business Central |
| `location_code` | `nvarchar(4000)` | Location code | — |
| `intelliHR_location_name` | `nvarchar(150)` | IntelliHR location name | — |
| `business_central_location_name` | `nvarchar(max)` | Business Central location name | — |
| `parent_location_id` / `code` / `name` | `nvarchar` | Parent location hierarchy | Location hierarchy |
| `exists_in_intelliHR` | `int` | Presence flag (1=Yes, 0=No) | — |
| `exists_in_business_central` | `int` | Presence flag (1=Yes, 0=No) | — |
| `company_name` | `nvarchar(4000)` | Business Central company scope | — |

::: mermaid
erDiagram
    dim_company      ||--o{ dim_location_new : "dim_company_key"
    dim_location_new ||--o{ fact_finance_general_ledger : "business_central_location_id"
    dim_location_new ||--o{ fact_employee_remuneration : "dim_location_key"
    dim_location_new ||--o{ dim_service : "location_code"
:::

## Direct business key join patterns

```sql
-- Finance facts (Business Central location ID join)
FROM edw.fact_finance_general_ledger AS gl
INNER JOIN edw.dim_location_new AS loc
    ON CAST(gl.location_id AS NVARCHAR(MAX)) = loc.business_central_location_id
    AND loc.DWHIsCurrent = 1
```

```sql
-- HR / IntelliHR location GUID join
FROM edw.fact_employee_remuneration AS rem
INNER JOIN edw.dim_location_new AS loc
    ON rem.fact_employee_remuneration_location_id = loc.intelliHR_location_id
    AND loc.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_location_new` |
| Landing | `landing.edw_dim_location_new` |
| Staging | `staging.ODSETLdim_location_new` |
| Stored procedures | `staging.insert_staging_dim_location_new`, `edw.Updateedwdim_location_new` |
| Target | `edw.dim_location_new` |

## Notes

- **Dual presence flags**: `exists_in_intelliHR` and `exists_in_business_central` quickly identify if a site is recognized in payroll/HR, financial ledgers, or both.
- **Parent hierarchy**: Supports physical and organizational location rollups via `parent_location_id`, `parent_location_code`, and `parent_location_name`.
