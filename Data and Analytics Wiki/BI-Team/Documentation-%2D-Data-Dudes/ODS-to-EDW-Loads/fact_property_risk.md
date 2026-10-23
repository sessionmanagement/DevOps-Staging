# fact_property_risk

[[_TOC_]]

Risks recorded against a property or tenancy, from the Zavanti risk register. Covers risks attached to a household, a household member or an application.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `695` |
| Target table | `edw.fact_property_risk` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `201 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_risk
       └─ landing.edw_fact_property_risk             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_risk      (staging.insert_staging_fact_property_risk)
                 └─ edw.fact_property_risk           (edw.Updateedwfact_property_risk)
```

### Distinguishing source views

`vw_zav_riskregister`, `vw_OptionsetMetadata`

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_risk_key` | `int` | Surrogate primary key | — |
| `property_risk_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_riskregister` |
| `riskregister_row_id` | `uniqueidentifier` | Business key (register row) | Zavanti `vw_zav_riskregister` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_household_id` | `uniqueidentifier` | Business key (household) | Zavanti `vw_zav_household` |
| `property_householdmember_id` | `uniqueidentifier` | Business key (household member) | Zavanti |
| `property_risk_contact_id` | `uniqueidentifier` | Business key (contact) | Zavanti `vw_contact` |
| `property_risk_application_id` | `uniqueidentifier` | Business key (application) | Zavanti |
| `property_risk_category_id` | `uniqueidentifier` | Business key (category) | Zavanti |
| `property_risk_subcategory_id` | `uniqueidentifier` | Business key (subcategory) | Zavanti |
| `property_risk_chintaro_id` | `varchar(100)` | Legacy system reference | Chintaro (pre-Zavanti) |

::: mermaid
erDiagram
    dim_property         ||--o{ fact_property_risk : "dim_property_key"
    dim_property_tenancy ||--o{ fact_property_risk : "dim_property_tenancy_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_risk` |
| Landing | `landing.edw_fact_property_risk` |
| Staging | `staging.ODSETLfact_property_risk` |
| Stored procedures | `staging.insert_staging_fact_property_risk`, `edw.Updateedwfact_property_risk` |
| Target | `edw.fact_property_risk` |

## Notes

### The only property load in phase 201

Every other property fact is in `200` (or `100`, for the two anomalous ones). Phase `201` runs after `200`, so this fact could depend on another fact's output — but it holds no fact-to-fact keys, so the reason for the later phase is not evident from the schema. Confirm whether the placement is deliberate.

### Risk category is not conformed

`property_risk_category_id` and `property_risk_subcategory_id` are raw business keys with no corresponding dimension. Risk categorisation reporting therefore relies on whatever descriptive columns the ODS view carries, not on a conformed dimension.

### Eight business keys, two dimension keys

The fact carries references to household, household member, contact and application, none of which have dimensions in the EDW. Only property and tenancy are conformed. This limits how far risk can be sliced without going back to the ODS.

### Legacy Chintaro reference

`property_risk_chintaro_id` is `varchar(100)`, wider than the equivalent field on `fact_property_inspection` (`varchar(10)`), suggesting a different migration format. Populated only for risks migrated from Chintaro.
