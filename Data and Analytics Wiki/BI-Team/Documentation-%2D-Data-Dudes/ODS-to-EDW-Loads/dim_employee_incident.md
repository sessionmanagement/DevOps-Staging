# dim_employee_incident

[[_TOC_]]

Employee health & safety incident investigations recorded in EcoPortal.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `749` |
| Target table | `edw.dim_employee_incident` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | EcoPortal (GraphQL API) |

## Data lineage

```text
EcoPortal (GraphQL API)
  └─ incident_investigations
       └─ ODS view: ETL.dim_employee_incident
            └─ landing.edw_dim_employee_incident             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_incident      (staging.insert_staging_dim_employee_incident)
                      └─ edw.dim_employee_incident           (edw.Updateedwdim_employee_incident)
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_employee_incident_key` | `int` | Surrogate primary key |
| `incident_id` | `nvarchar(4000)` | Business key (EcoPortal incident ID) |
| `incident_title` | `nvarchar(4000)` | Incident title |
| `current_stage` | `nvarchar(4000)` | Current investigation stage |
| `active_stage_status` | `nvarchar(4000)` | Status of active stage |
| `incident_business_unit` | `nvarchar(255)` | Business unit name |
| `incident_sub_unit` | `nvarchar(255)` | Sub-unit name |
| `incident_team` | `nvarchar(255)` | Team name |

::: mermaid
erDiagram
    dim_employee_incident ||--o{ fact_employee_incident : "dim_employee_incident_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_incident AS fact
INNER JOIN edw.dim_employee_incident AS inc
    ON fact.incident_id = inc.incident_id
    AND inc.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_incident` |
| Landing | `landing.edw_fact_employee_incident` / `edw_dim_employee_incident` |
| Staging | `staging.ODSETLdim_employee_incident` |
| Stored procedures | `staging.insert_staging_dim_employee_incident`, `edw.Updateedwdim_employee_incident` |
| Target | `edw.dim_employee_incident` |

## Notes

- `incident_id` is defined as `nvarchar(4000)` in table DDL to accommodate text/GUID formats from EcoPortal.
