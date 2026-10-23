# fact_property_void_checklist

[[_TOC_]]

Void checklists — the turnaround process tracked when a property becomes vacant between tenancies, including the void reason and the property subsequently offered.

> **Near-duplicate load.** [fact_void_checklist](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_void_checklist) (DataLoadId 679) reads the same source view and has a matching column set under different names. See [Notes](#notes).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `761` |
| Target table | `edw.fact_property_void_checklist` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_void_checklist
       └─ landing.edw_fact_property_void_checklist             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_void_checklist      (staging.insert_staging_fact_property_void_checklist)
                 └─ edw.fact_property_void_checklist           (edw.Updateedwfact_property_void_checklist)
```

### Distinguishing source views

`vw_zav_voidchecklist`, `vw_OptionsetMetadata`

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_void_checklist_key` | `int` | Surrogate primary key | — |
| `void_checklist_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_voidchecklist` |
| `property_void_checklist_id` | `uniqueidentifier` | Business key | Zavanti |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_offered_property_key` | `int` | Dimension foreign key _(role-playing)_ | `edw.dim_property` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `dim_property_void_category_key` | `int` | Dimension foreign key | `edw.dim_void_category` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `offered_property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `vacated_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `void_category_id` | `uniqueidentifier` | Business key (lookup) | Zavanti `vw_zav_voidcategory` |
| `owner_id` | `uniqueidentifier` | Business key (Dataverse owner) | Zavanti `vw_systemuser` |
| `target_completion_date_void` | `datetime2` | **Raw datetime, not a date key** | — |

::: mermaid
erDiagram
    dim_property      ||--o{ fact_property_void_checklist : "dim_property_key + dim_offered_property_key"
    dim_property_tenancy ||--o{ fact_property_void_checklist : "dim_property_tenancy_key"
    dim_void_category ||--o{ fact_property_void_checklist : "dim_property_void_category_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_void_checklist` |
| Landing | `landing.edw_fact_property_void_checklist` |
| Staging | `staging.ODSETLfact_property_void_checklist` |
| Stored procedures | `staging.insert_staging_fact_property_void_checklist`, `edw.Updateedwfact_property_void_checklist` |
| Target | `edw.fact_property_void_checklist` |

## Notes

### Duplicate of fact_void_checklist

DataLoadIds 761 and 679 both read `vw_zav_voidchecklist` and produce structurally identical facts. The differences are cosmetic:

| This fact (761) | fact_void_checklist (679) |
| --- | --- |
| `fact_property_void_checklist_key` | `fact_void_checklist_key` |
| `dim_property_void_category_key` | `dim_void_category_key` |
| `property_id` | `void_checklist_property_id` |
| `offered_property_id` | `void_checklist_offered_property_id` |
| `vacated_tenancy_id` | `void_checklist_vacated_tenancy_id` |
| `void_category_id` | `void_checklist_void_category_id` |
| `owner_id` | `void_checklist_owner_id` |
| `target_completion_date_void` | `void_checklist_target_completion_date_void` |

The higher DataLoadId (761) suggests this is the newer of the two and 679 the original. **Both are active and loading daily**, so void metrics could be double-counted if a report unions them. Confirm which is authoritative and retire the other.

### Role-playing property dimension

`dim_property_key` (the void property) and `dim_offered_property_key` (the replacement offered to the tenant) both point at `dim_property`. Queries must alias the dimension twice.

### Date held as a raw datetime

`target_completion_date_void` is `datetime2`, not an `int` key to `dim_date` — the only date on any property fact not conformed to the date dimension. Void turnaround analysis against the date dimension requires a conversion.
