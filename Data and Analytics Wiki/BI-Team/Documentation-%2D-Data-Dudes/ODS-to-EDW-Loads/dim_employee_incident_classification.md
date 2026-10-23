# dim_employee_incident_classification

[[_TOC_]]

Classification taxonomy hierarchy (Level 1, Level 2, Level 3) for EcoPortal health & safety incident investigations.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `750` |
| Target table | `edw.dim_employee_incident_classification` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 1 (in-place merge) |
| Source system | EcoPortal (GraphQL API) |

## Data lineage

```text
EcoPortal (GraphQL API)
  └─ incident_investigations
       └─ ODS view: ETL.dim_employee_incident_classification
            └─ landing.edw_dim_employee_incident_classification             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_incident_classification      (staging.insert_staging_dim_employee_incident_classification)
                      └─ edw.dim_employee_incident_classification           (edw.Updateedwdim_employee_incident_classification)
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_employee_incident_classification_key` | `int` | Surrogate primary key |
| `incident_id` | `nvarchar(4000)` | Business key |
| `incident_classification_level1_code` | `nvarchar(100)` | Level 1 category code |
| `incident_classification_level1_name` | `nvarchar(1000)` | Level 1 category name |
| `incident_classification_level2_code` | `nvarchar(100)` | Level 2 sub-category code |
| `incident_classification_level2_name` | `nvarchar(1000)` | Level 2 sub-category name |
| `incident_classification_level3_code` | `nvarchar(100)` | Level 3 detail code |
| `incident_classification_level3_name` | `nvarchar(1000)` | Level 3 detail name |

## Direct business key join pattern

```sql
FROM edw.fact_employee_incident AS fact
INNER JOIN edw.dim_employee_incident_classification AS c
    ON fact.incident_id = c.incident_id
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_incident_classification` |
| Landing | `landing.edw_dim_employee_incident_classification` |
| Staging | `staging.ODSETLdim_employee_incident_classification` |
| Stored procedures | `staging.insert_staging_dim_employee_incident_classification`, `edw.Updateedwdim_employee_incident_classification` |
| Target | `edw.dim_employee_incident_classification` |

## Notes

- Loaded as `ODSFLLMRG` (Type 1 in-place merge).
