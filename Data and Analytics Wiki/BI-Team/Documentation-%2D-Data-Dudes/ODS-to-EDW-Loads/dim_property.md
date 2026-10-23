# dim_property

[[_TOC_]]

The core property dimension — one row per property. Most property facts and several property dimensions join back to this table via `dim_property_key`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `558` |
| Target table | `edw.dim_property` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property
       └─ landing.edw_dim_property             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property      (staging.insert_staging_dim_property)
                 └─ edw.dim_property           (edw.Updateedwdim_property)
```

### Distinguishing source views

`vw_zav_property`, `vw_zav_propertytype`, `vw_zav_subpropertytype`, `vw_zav_program`, `vw_zav_subprogram`, `vw_zav_servicename`, `vw_zav_postalcity`, `vw_zav_postalregion`, `vw_opportunity`, `vw_account`, `vw_contact`, `vw_territory`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

This is the most heavily joined view in the property group — 16 source views in total.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_key` | `int` | Surrogate primary key | — |
| `property_id` | `uniqueidentifier` | Business key | Zavanti `vw_zav_property` |
| `property_reference_id` | `varchar(400)` | Alternate business reference | Zavanti |

::: mermaid
erDiagram
    dim_property ||--o{ dim_property_lease : "dim_property_key"
    dim_property ||--o{ dim_property_tenancy : "dim_property_key"
    dim_property ||--o{ dim_property_inspection_detail : "dim_property_key"
    dim_property ||--o{ dim_property_arrears_arrangement : "dim_property_key"
:::

`dim_property` has no outbound foreign keys — it is the root of the property snowflake.

## Incremental behaviour

`IsHighwater = 1`. `30_Load_From_ODS` calls the procedure named in `BIML.DataLoadDetail.TargetHighwaterProcedureName` to obtain the watermark, then injects it into the `BIML.DataLoadQuery` source query before copying. Only rows changed since the last successful load reach landing.

To force a full reload of this load only, run `10_Load_Master` with `DataLoadId = 558` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property` |
| Landing | `landing.edw_dim_property` |
| Staging | `staging.ODSETLdim_property` |
| Stored procedures | `staging.insert_staging_dim_property`, `edw.Updateedwdim_property`, highwater procedure |
| Target | `edw.dim_property` |

## Notes

- Because so much of the property model snowflakes onto this table, a failure here degrades the whole subject area. It shares phase `101` with two dimensions that hold a FK to it — see [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).
- Business definition and column-level detail: [EDW dimension tables](/BI-Team/Documentation-%2D-Data-Dudes/Data-Documentation/EDW-dimension-tables).
