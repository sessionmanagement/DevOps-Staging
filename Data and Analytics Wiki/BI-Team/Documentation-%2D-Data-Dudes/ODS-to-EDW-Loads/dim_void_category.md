# dim_void_category

[[_TOC_]]

NOTE: This table should be renamed dim_property_void_category

Void categories — the reason classification applied when a property becomes vacant (void) between tenancies. Used in void-turnaround and lost-rent reporting.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `676` |
| Target table | `edw.dim_void_category` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_void_category
       └─ landing.edw_dim_void_category             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_void_category      (staging.insert_staging_dim_void_category)
                 └─ edw.dim_void_category           (edw.Updateedwdim_void_category)
```

### Distinguishing source views

`vw_zav_voidcategory`

This is the simplest ODS view in the property group — a single source entity with no metadata joins.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_void_category_key` | `int` | Surrogate primary key | — |
| `void_category_id` | `uniqueidentifier` | Business key | Zavanti `vw_zav_voidcategory` |
| `owning_user_id` | `uniqueidentifier` | Business key (Dataverse owning user) | Zavanti `vw_systemuser` |
| `owner_id` | `uniqueidentifier` | Business key (Dataverse owner) | Zavanti `vw_systemuser` |

No foreign keys to other EDW dimensions.

::: mermaid
erDiagram
    dim_void_category ||--o{ fact_void_checklist : "dim_void_category_key"
    dim_void_category ||--o{ fact_property_void_checklist : "dim_property_void_category_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_void_category` |
| Landing | `landing.edw_dim_void_category` |
| Staging | `staging.ODSETLdim_void_category` |
| Stored procedures | `staging.insert_staging_dim_void_category`, `edw.Updateedwdim_void_category` |
| Target | `edw.dim_void_category` |

## Notes

### Naming

This is the only property-group dimension without a `property_` prefix, despite being property-specific. `dim_property_tenancy` also sources from `vw_zav_voidcategory` for its void attributes.

### Two consuming facts

Both `fact_void_checklist` (679) and `fact_property_void_checklist` (761) consume this dimension, under different column names (`dim_void_category_key` and `dim_property_void_category_key` respectively). The two facts appear near-duplicate — see [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

### Dataverse ownership columns

`owning_user_id` and `owner_id` are Dataverse platform columns carried through unchanged. They are rarely useful for reporting and are retained mainly for traceability back to the source record.
