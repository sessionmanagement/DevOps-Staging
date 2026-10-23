# dim_client_activity_breakdown_type

[[_TOC_]]

Classification of client activity breakdown types, with a self-referencing parent/child hierarchy and an associated team configuration name.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `467` |
| Target table | `edw.dim_client_activity_breakdown_type` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_activity_breakdown_type
       └─ landing.edw_dim_client_activity_breakdown_type             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_activity_breakdown_type      (staging.insert_staging_dim_client_activity_breakdown_type)
                 └─ edw.dim_client_activity_breakdown_type           (edw.Updateedwdim_client_activity_breakdown_type)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlDimTeamConfiguration`, `dlDimActivityBreakdownType` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_activity_breakdown_type_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `client_activity_breakdown_type_id` | `int` | Business key | Recordbase |
| `dim_client_activity_breakdown_type_unique_key` | `nvarchar(50)` | Combined natural key | — |
| `company_id` | `int` | Business key (raw) | `edw.dim_company.company_id` |
| `client_parent_activity_breakdown_type` | `int` | Self-referencing parent | `client_activity_breakdown_type_id` on this table |

::: mermaid
erDiagram
    dim_client_activity_breakdown_type ||--o{ dim_client_activity_breakdown_type : "parent / child hierarchy"
    dim_client_activity_breakdown_type ||--o{ fact_client_activity_breakdown : "dim_client_activity_breakdown_type_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_activity_breakdown_type` |
| Landing | `landing.edw_dim_client_activity_breakdown_type` |
| Staging | `staging.ODSETLdim_client_activity_breakdown_type` |
| Stored procedures | `staging.insert_staging_dim_client_activity_breakdown_type`, `edw.Updateedwdim_client_activity_breakdown_type` |
| Target | `edw.dim_client_activity_breakdown_type` |

## Notes

### Single-level parent reference, no path column

The parent reference supports a two-level hierarchy (via `client_parent_activity_breakdown_type` / `client_parent_activity_breakdown_type_name`), but there is no pre-built path or depth column — unlike the finance G/L account dimension's flattened hierarchy levels.
