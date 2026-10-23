# dim_property_healthy_homes

[[_TOC_]]

Healthy Homes compliance attributes for a property. Healthy Homes standards are a New Zealand regulatory requirement for rental properties, covering heating, insulation, ventilation, moisture ingress, drainage and draught stopping.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `560` |
| Target table | `edw.dim_property_healthy_homes` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_healthy_homes
       └─ landing.edw_dim_property_healthy_homes             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_healthy_homes      (staging.insert_staging_dim_property_healthy_homes)
                 └─ edw.dim_property_healthy_homes           (edw.Updateedwdim_property_healthy_homes)
```

### Distinguishing source views

`vw_zav_property`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview). Healthy Homes attributes are stored as option sets on the property entity, so the metadata joins carry most of the meaning.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_healthy_homes_key` | `int` | Surrogate primary key | — |
| `property_healthy_homes_id` | `uniqueidentifier` | Business key | Zavanti `vw_zav_property` |

No foreign keys.

::: mermaid
erDiagram
    dim_property_healthy_homes ||--o{ fact_property_inspection : "dim_property_healthy_homes_key"
    dim_property_healthy_homes ||--o{ fact_property_maintenance_task : "dim_property_healthy_homes_key"
    dim_property_healthy_homes ||--o{ fact_property_tenancy_transaction : "dim_property_healthy_homes_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 560` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_healthy_homes` |
| Landing | `landing.edw_dim_property_healthy_homes` |
| Staging | `staging.ODSETLdim_property_healthy_homes` |
| Stored procedures | `staging.insert_staging_dim_property_healthy_homes`, `edw.Updateedwdim_property_healthy_homes`, highwater procedure |
| Target | `edw.dim_property_healthy_homes` |

## Notes

- Because this is a Type 2 dimension, compliance status changes over time are retained. Point-in-time compliance reporting must filter on `DWHEffectiveFrom` / `DWHEffectiveTo` rather than `DWHIsCurrent = 1`.
