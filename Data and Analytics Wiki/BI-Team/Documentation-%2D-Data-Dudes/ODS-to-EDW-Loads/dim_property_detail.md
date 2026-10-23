# dim_property_detail

[[_TOC_]]

Extended attribute detail for a property, split out from [dim_property](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property) to keep the core dimension narrow.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `559` |
| Target table | `edw.dim_property_detail` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_detail
       └─ landing.edw_dim_property_detail             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_detail      (staging.insert_staging_dim_property_detail)
                 └─ edw.dim_property_detail           (edw.Updateedwdim_property_detail)
```

### Distinguishing source views

`vw_zav_property`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview). This view is essentially `vw_zav_property` with heavy option-set resolution — the metadata joins do most of the work.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_detail_key` | `int` | Surrogate primary key | — |
| `property_detail_id` | `uniqueidentifier` | Business key | Zavanti `vw_zav_property` |

No foreign keys. Facts join to this dimension directly via `dim_property_detail_key`:

::: mermaid
erDiagram
    dim_property_detail ||--o{ fact_property_inspection : "dim_property_detail_key"
    dim_property_detail ||--o{ fact_property_maintenance_task : "dim_property_detail_key"
    dim_property_detail ||--o{ fact_property_tenancy_transaction : "dim_property_detail_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 559` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_detail` |
| Landing | `landing.edw_dim_property_detail` |
| Staging | `staging.ODSETLdim_property_detail` |
| Stored procedures | `staging.insert_staging_dim_property_detail`, `edw.Updateedwdim_property_detail`, highwater procedure |
| Target | `edw.dim_property_detail` |

## Notes

- `dim_property_detail`, `dim_property_healthy_homes` and `dim_property` all derive from `vw_zav_property`. They are separate dimensions over the same source entity, differing in which attributes and option sets they surface.
