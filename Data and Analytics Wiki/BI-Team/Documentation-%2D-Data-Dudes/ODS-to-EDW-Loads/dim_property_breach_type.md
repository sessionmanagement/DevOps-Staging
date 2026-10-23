# dim_property_breach_type

[[_TOC_]]

Classification of tenancy breaches — the breach categories used when a tenancy breach is recorded. NOTE: This table does not related to any other table in the DWH. It should be linked to edw.fact_property_tenancy_breach

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `720` |
| Target table | `edw.dim_property_breach_type` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_breach_type
       └─ landing.edw_dim_property_breach_type             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_property_breach_type      (staging.insert_staging_dim_property_breach_type)
                 └─ edw.dim_property_breach_type           (edw.Updateedwdim_property_breach_type)
```

### Distinguishing source views

`vw_zav_tenancybreach`, `vw_GlobalOptionsetMetadata`

Breach types are held as a global option set in Dataverse rather than as a standalone entity, so this dimension is built by resolving distinct option-set values observed on the breach entity.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_breach_type_key` | `int` | Surrogate primary key | — |
| `breach_type_id` | `int` | Business key (option-set value) | Zavanti global option set |

No foreign keys.

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning. No watermark procedure is involved, so `ForceFullLoadFlag` has no additional effect on this load.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_breach_type` |
| Landing | `landing.edw_dim_property_breach_type` |
| Staging | `staging.ODSETLdim_property_breach_type` |
| Stored procedures | `staging.insert_staging_dim_property_breach_type`, `edw.Updateedwdim_property_breach_type` |
| Target | `edw.dim_property_breach_type` |

## Notes

- Because the dimension is derived from option-set values _observed on the breach entity_, a breach type that has never been used will not appear. This differs from dimensions sourced from a first-class entity, which carry unused reference rows.

