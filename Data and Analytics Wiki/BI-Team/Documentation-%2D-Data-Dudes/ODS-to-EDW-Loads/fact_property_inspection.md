# fact_property_inspection

[[_TOC_]]

Property inspections — scheduled and completed inspection events against a property, including the tenancy in place and any maintenance arising.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `615` |
| Target table | `edw.fact_property_inspection` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_inspection
       └─ landing.edw_fact_property_inspection             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_inspection      (staging.insert_staging_fact_property_inspection)
                 └─ edw.fact_property_inspection           (edw.Updateedwfact_property_inspection)
```

### Distinguishing source views

`vw_zav_inspection`

Plus `vw_StateMetadata`, `vw_StatusMetadata` and `vw_GlobalOptionsetMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

The most heavily conformed fact in the property group — five dimension keys plus six role-playing date and time keys.

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_inspection_key` | `int` | Surrogate primary key | — |
| `property_inspection_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_inspection` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_detail_key` | `int` | Dimension foreign key | `edw.dim_property_detail` |
| `dim_property_healthy_homes_key` | `int` | Dimension foreign key | `edw.dim_property_healthy_homes` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `dim_property_maintenance_key` | `int` | Dimension foreign key | `edw.dim_property_maintenance` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_maintenance_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_inspection_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_inspection_scheduled_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_inspection_completion_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_inspection_next_routine_inspection_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_inspection_scheduled_time_key` | `int` | Role-playing time FK | `edw.dim_time` |
| `property_inspection_scheduled_end_time_key` | `int` | Role-playing time FK | `edw.dim_time` |
| `property_inspection_chintaro_id` | `varchar(10)` | Legacy system reference | Chintaro (pre-Zavanti) |

::: mermaid
erDiagram
    dim_property               ||--o{ fact_property_inspection : "dim_property_key"
    dim_property_detail        ||--o{ fact_property_inspection : "dim_property_detail_key"
    dim_property_healthy_homes ||--o{ fact_property_inspection : "dim_property_healthy_homes_key"
    dim_property_tenancy       ||--o{ fact_property_inspection : "dim_property_tenancy_key"
    dim_property_maintenance   ||--o{ fact_property_inspection : "dim_property_maintenance_key"
    dim_date                   ||--o{ fact_property_inspection : "4 roles"
    dim_time                   ||--o{ fact_property_inspection : "2 roles"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`, `IsMerged = 1` with **no row versioning**. The full ODS view is read on every run and merged in place; prior values are overwritten.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_inspection` |
| Landing | `landing.edw_fact_property_inspection` |
| Staging | `staging.ODSETLfact_property_inspection` |
| Stored procedures | `staging.insert_staging_fact_property_inspection`, `edw.Updateedwfact_property_inspection` |
| Target | `edw.fact_property_inspection` |

## Notes

### Legacy Chintaro reference

`property_inspection_chintaro_id` carries an identifier from Chintaro, the system Zavanti replaced. It is populated only for migrated historical inspections and will be null for anything recorded natively in Zavanti. Useful for reconciling pre-migration history; not a reliable join key going forward.

### Correct dimension for condition trend

[dim_property_inspection_detail](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_inspection_detail) is loaded as SCD Type 1 and therefore does not retain condition history. For inspection trend analysis over time, use this fact rather than that dimension.

### Time dimension usage

This is one of the few facts in the EDW using `dim_time`. Inspection appointments are scheduled to a time of day, so both start and end times are conformed.
