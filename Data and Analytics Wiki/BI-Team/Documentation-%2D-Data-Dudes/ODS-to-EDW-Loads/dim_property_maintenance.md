# dim_property_maintenance

[[_TOC_]]

Maintenance jobs raised against a property. One row per maintenance task record in Zavanti, including the inspection that triggered it where applicable.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `612` |
| Target table | `edw.dim_property_maintenance` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_maintenance
       └─ landing.edw_dim_property_maintenance             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_maintenance      (staging.insert_staging_dim_property_maintenance)
                 └─ edw.dim_property_maintenance           (edw.Updateedwdim_property_maintenance)
```

### Distinguishing source views

`vw_zav_maintenancetask`, `vw_zav_inspection`, `vw_businessunit`, `vw_contact`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_maintenance_key` | `int` | Surrogate primary key | — |
| `property_maintenance_id` | `uniqueidentifier` | Business key | Zavanti `vw_zav_maintenancetask` |

No foreign keys.

::: mermaid
erDiagram
    dim_property_maintenance ||--o{ fact_property_maintenance_task : "dim_property_maintenance_key"
    dim_property_maintenance ||--o{ fact_property_inspection : "dim_property_maintenance_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 612` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_maintenance` |
| Landing | `landing.edw_dim_property_maintenance` |
| Staging | `staging.ODSETLdim_property_maintenance` |
| Stored procedures | `staging.insert_staging_dim_property_maintenance`, `edw.Updateedwdim_property_maintenance`, highwater procedure |
| Target | `edw.dim_property_maintenance` |

## Notes

- `dim_property_maintenance` (the job) and [dim_property_maintenace_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_maintenace_type) (the classification) are separate dimensions. Note the differing spellings — only the _type_ table carries the misspelling.
- The measures and dates for maintenance work live on `fact_property_maintenance_task`, not on this dimension.
