# dim_property_program

[[_TOC_]]

Programme and sub-programme classification for properties. Programmes group properties by the funding or service arrangement under which they are held.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `533` |
| Target table | `edw.dim_property_program` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_program
       └─ landing.edw_dim_property_program             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_program      (staging.insert_staging_dim_property_program)
                 └─ edw.dim_property_program           (edw.Updateedwdim_property_program)
```

### Distinguishing source views

`vw_zav_subprogram`, `vw_team`

Plus `vw_StateMetadata`, `vw_StatusMetadata` and `vw_systemuser` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_program_id` | `int` | Surrogate primary key | — |
| `property_program_id` | `nvarchar(40)` | Business key (programme) | Zavanti `vw_zav_program` |
| `property_subprogram_id` | `nvarchar(40)` | Business key (sub-programme) | Zavanti `vw_zav_subprogram` |

No foreign keys. The grain is the **sub-programme**, with the parent programme carried as an attribute.

::: mermaid
erDiagram
    dim_property_program ||--o{ dim_property_arrears_arrangement : "dim_property_program_key"
    dim_property_program ||--o{ fact_property_arrears_transaction : "dim_property_program_key"
    dim_property_program ||--o{ fact_property_maintenance_task : "dim_property_program_key"
    dim_property_program ||--o{ fact_property_tenancy_transaction : "dim_property_program_key"
    dim_property_program ||--o{ fact_property_tenant : "dim_property_program_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 533` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_program` |
| Landing | `landing.edw_dim_property_program` |
| Staging | `staging.ODSETLdim_property_program` |
| Stored procedures | `staging.insert_staging_dim_property_program`, `edw.Updateedwdim_property_program`, highwater procedure |
| Target | `edw.dim_property_program` |

## Notes

### Surrogate key naming

The surrogate key is `dim_property_program_id`, not `dim_property_program_key`. Note that facts reference it as `dim_property_program_key` — confirm how the join is resolved, since the column names do not match.

### Small dimension on an incremental load

This dimension is small (roughly 15 rows historically). The highwater/incremental configuration delivers little benefit here compared with a full merge, and adds a watermark procedure to maintain.
