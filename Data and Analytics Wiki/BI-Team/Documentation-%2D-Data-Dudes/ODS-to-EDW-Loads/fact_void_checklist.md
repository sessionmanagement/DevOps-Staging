# fact_void_checklist

[[_TOC_]]

NOTE: This table has been super-seeded by fact_property_void_checklist 

Void checklists — the turnaround process tracked when a property becomes vacant between tenancies.

> **Near-duplicate load.** [fact_property_void_checklist](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_void_checklist) (DataLoadId 761) reads the same source view and has a matching column set under different names. This page is the older of the two. See [Notes](#notes).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `679` |
| Target table | `edw.fact_void_checklist` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_void_checklist
       └─ landing.edw_fact_void_checklist             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_void_checklist      (staging.insert_staging_fact_void_checklist)
                 └─ edw.fact_void_checklist           (edw.Updateedwfact_void_checklist)
```

### Distinguishing source views

`vw_zav_voidchecklist`, `vw_OptionsetMetadata`

Identical to `fact_property_void_checklist` (761).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_void_checklist_key` | `int` | Surrogate primary key | — |
| `void_checklist_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_voidchecklist` |
| `void_checklist_void_checklist_id` | `uniqueidentifier` | Business key | Zavanti |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_offered_property_key` | `int` | Dimension foreign key _(role-playing)_ | `edw.dim_property` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `dim_void_category_key` | `int` | Dimension foreign key | `edw.dim_void_category` |
| `void_checklist_property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `void_checklist_offered_property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `void_checklist_vacated_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `void_checklist_void_category_id` | `uniqueidentifier` | Business key (lookup) | Zavanti `vw_zav_voidcategory` |
| `void_checklist_owner_id` | `uniqueidentifier` | Business key (Dataverse owner) | Zavanti `vw_systemuser` |
| `void_checklist_target_completion_date_void` | `datetime2` | **Raw datetime, not a date key** | — |

::: mermaid
erDiagram
    dim_property         ||--o{ fact_void_checklist : "dim_property_key + dim_offered_property_key"
    dim_property_tenancy ||--o{ fact_void_checklist : "dim_property_tenancy_key"
    dim_void_category    ||--o{ fact_void_checklist : "dim_void_category_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_void_checklist` |
| Landing | `landing.edw_fact_void_checklist` |
| Staging | `staging.ODSETLfact_void_checklist` |
| Stored procedures | `staging.insert_staging_fact_void_checklist`, `edw.Updateedwfact_void_checklist` |
| Target | `edw.fact_void_checklist` |

## Notes

### Duplicate of fact_property_void_checklist

See the comparison table on [fact_property_void_checklist](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_void_checklist). Both loads are active, read the same source view and land the same rows under different column names. **Void metrics will double-count if the two are unioned.**

This fact (679) is the older of the pair. It is also the one referenced by name in `edw.dim_void_category`'s consuming relationships, which suggests existing reports may point here rather than at 761.

Before retiring either, check which is referenced by live Power BI datasets.

### Naming

Unlike every other fact in this group, this one has no `property_` prefix despite being property-specific — matching [dim_void_category](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_void_category), which has the same inconsistency.

### Redundant business key

`void_checklist_id` and `void_checklist_void_checklist_id` appear to be the same value under two names, the second carrying a doubled prefix from the ODS view's column aliasing.

### Date held as a raw datetime

`void_checklist_target_completion_date_void` is `datetime2` rather than a `dim_date` key.
