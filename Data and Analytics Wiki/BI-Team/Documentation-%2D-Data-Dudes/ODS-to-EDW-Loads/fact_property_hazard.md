# fact_property_hazard

[[_TOC_]]

Hazards identified against a property, from the Zavanti hazards register. Supports health and safety reporting and pre-visit risk awareness.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `696` |
| Target table | `edw.fact_property_hazard` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_hazard
       └─ landing.edw_fact_property_hazard             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_hazard      (staging.insert_staging_fact_property_hazard)
                 └─ edw.fact_property_hazard           (edw.Updateedwfact_property_hazard)
```

### Distinguishing source views

`vw_zav_hazardsregister`

Plus `vw_OptionsetMetadata` and `vw_GlobalOptionsetMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_hazard_key` | `int` | Surrogate primary key | — |
| `property_hazard_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_hazardsregister` |
| `hazardsregister_row_id` | `uniqueidentifier` | Business key (register row) | Zavanti `vw_zav_hazardsregister` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `hazard_date_identified_id` | `int` | Role-playing date FK | `edw.dim_date` |

::: mermaid
erDiagram
    dim_property ||--o{ fact_property_hazard : "dim_property_key"
    dim_date     ||--o{ fact_property_hazard : "hazard_date_identified_id"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_hazard` |
| Landing | `landing.edw_fact_property_hazard` |
| Staging | `staging.ODSETLfact_property_hazard` |
| Stored procedures | `staging.insert_staging_fact_property_hazard`, `edw.Updateedwfact_property_hazard` |
| Target | `edw.fact_property_hazard` |

## Notes

### Two identifiers at the same grain

`property_hazard_id` and `hazardsregister_row_id` both derive from `vw_zav_hazardsregister`. Confirm which defines the grain — the same pattern appears on [fact_property_risk](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_risk), which pairs `property_risk_id` with `riskregister_row_id`.

### No link to employee incidents

Property hazards are recorded in Zavanti, while employee health and safety incidents are recorded in EcoPortal and land in `edw.fact_employee_incident`. There is no key linking the two, so a hazard at a property cannot be traced to an incident that occurred there without matching on property and date.

### Date key named `_id`

`hazard_date_identified_id` is a `dim_date` foreign key despite the `_id` suffix.
