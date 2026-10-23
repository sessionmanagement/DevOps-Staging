# dim_property_maintenace_type

[[_TOC_]]

Classification of maintenance work — the grouped maintenance type hierarchy used to categorise maintenance tasks.

> **Object name.** "maintenance" is misspelled as "maintenace" in the live object name. This documentation preserves the name exactly as deployed. Do not correct it in queries or code without a coordinated rename.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `537` |
| Target table | `edw.dim_property_maintenace_type` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_maintenace_type
       └─ landing.edw_dim_property_maintenace_type             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_maintenace_type      (staging.insert_staging_dim_property_maintenace_type)
                 └─ edw.dim_property_maintenace_type           (edw.Updateedwdim_property_maintenace_type)
```

### Distinguishing source views

`vw_zav_maintenancetype`

Plus `vw_OptionsetMetadata` and `vw_GlobalOptionsetMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_maintenace_type_id` | `int` | Surrogate primary key | — |
| `property_maintenance_type_id` | `nvarchar(40)` | Business key | Zavanti `vw_zav_maintenancetype` |

No foreign keys.

::: mermaid
erDiagram
    dim_property_maintenace_type ||--o{ fact_property_maintenance_task : "dim_property_maintenace_type_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 537` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_maintenace_type` |
| Landing | `landing.edw_dim_property_maintenace_type` |
| Staging | `staging.ODSETLdim_property_maintenace_type` |
| Stored procedures | `staging.insert_staging_dim_property_maintenace_type`, `edw.Updateedwdim_property_maintenace_type`, highwater procedure |
| Target | `edw.dim_property_maintenace_type` |

## Notes

### Naming inconsistencies

Two separate issues on this table:

1. The object name misspells "maintenance" (see the callout above). The business key column `property_maintenance_type_id` spells it correctly, so the two differ within the same table.
2. The surrogate key is `dim_property_maintenace_type_id`, not `..._key`.

### Small dimension on an incremental load

This dimension holds roughly 18 rows. The highwater/incremental configuration adds a watermark procedure to maintain for negligible benefit; a full merge would be simpler.
