# dim_property_inspection_detail

[[_TOC_]]

Detail attributes captured during a property inspection, including asset condition assessment. Loads in phase `102` because it depends on `dim_property`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `800` |
| Target table | `edw.dim_property_inspection_detail` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `102 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | **Type 1** (no row versioning — history is not retained) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_inspection_detail
       └─ landing.edw_dim_property_inspection_detail             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_property_inspection_detail      (staging.insert_staging_dim_property_inspection_detail)
                 └─ edw.dim_property_inspection_detail           (edw.Updateedwdim_property_inspection_detail)
```

### Distinguishing source views

> **Lineage unconfirmed.** This load does not appear in the ODS ETL view lineage extract. Its source views have not been verified. Expected to derive from `vw_zav_inspection` and related asset/condition entities, but this must be confirmed against the ODS view definition before relying on it.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_inspection_detail_key` | `int` | Surrogate primary key | — |
| `dim_property_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_property.dim_property_key` |
| `property_inspection_detail_id` | `uniqueidentifier` | Business key | Zavanti |
| `property_inspection_id` | `uniqueidentifier` | Business key (parent inspection) | Zavanti `vw_zav_inspection` |
| `property_id` | `uniqueidentifier` | Business key (parent property) | Zavanti `vw_zav_property` |
| `asset_condition_id` | `int` | Business key (condition rating) | Zavanti option set |
| `EDWBatchId` | `int` | Load audit column | `ETL.Batch.BatchID` |

::: mermaid
erDiagram
    dim_property ||--o{ dim_property_inspection_detail : "dim_property_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`, `IsMerged = 1` with **no row versioning**. The full ODS view is read on every run and merged in place. Prior attribute values are overwritten and not retained.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_inspection_detail` |
| Landing | `landing.edw_dim_property_inspection_detail` |
| Staging | `staging.ODSETLdim_property_inspection_detail` |
| Stored procedures | `staging.insert_staging_dim_property_inspection_detail`, `edw.Updateedwdim_property_inspection_detail` |
| Target | `edw.dim_property_inspection_detail` |

## Notes

### Type 1, unlike its peers

This is the only property dimension loaded as `ODSFLLMRG` (non-versioned). Every other property dimension retains history. Condition ratings recorded here therefore reflect only the latest inspection detail — historical condition trend analysis is not possible from this table. If trend reporting is required, the fact `fact_property_inspection` is the correct source.

### Non-standard audit column

`EDWBatchId` appears on no other property dimension. It links a row to the `ETL.Batch` record that loaded it, which is useful for troubleshooting but inconsistent with the rest of the model, where the standard audit columns (`DWHEffectiveFrom`, `DWHEffectiveTo`, `DWHIsCurrent`, `DWHDMLOperation`, `DWHSource`) carry this responsibility.

### Newer load

DataLoadId `800` places this among the more recently added loads, which is consistent with it predating neither the lineage extract nor the conventions applied to the older property dimensions.
