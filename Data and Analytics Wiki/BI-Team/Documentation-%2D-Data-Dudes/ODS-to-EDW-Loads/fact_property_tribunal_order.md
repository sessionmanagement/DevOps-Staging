# fact_property_tribunal_order

[[_TOC_]]

Tenancy Tribunal orders arising from a tenancy breach — the determination made when a breach is escalated to the Tenancy Tribunal.

> **Loads before every dimension.** This load is configured with phase `100 Facts`, which sorts ahead of all dimension phases. See [Notes](#notes).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `719` |
| Target table | `edw.fact_property_tribunal_order` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `100 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_tribunal_order
       └─ landing.edw_fact_property_tribunal_order             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_tribunal_order      (staging.insert_staging_fact_property_tribunal_order)
                 └─ edw.fact_property_tribunal_order           (edw.Updateedwfact_property_tribunal_order)
```

### Distinguishing source views

`vw_zav_tribunalorder`, `vw_zav_tenancybreach`

Plus `vw_StateMetadata` and `vw_StatusMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_tribunal_order_key` | `int` | Surrogate primary key | — |
| `property_tribunal_order_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_tribunalorder` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_breach_id` | `uniqueidentifier` | Business key (originating breach) | Zavanti `vw_zav_tenancybreach` |

::: mermaid
erDiagram
    dim_property         ||--o{ fact_property_tribunal_order : "dim_property_key"
    dim_property_tenancy ||--o{ fact_property_tribunal_order : "dim_property_tenancy_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_tribunal_order` |
| Landing | `landing.edw_fact_property_tribunal_order` |
| Staging | `staging.ODSETLfact_property_tribunal_order` |
| Stored procedures | `staging.insert_staging_fact_property_tribunal_order`, `edw.Updateedwfact_property_tribunal_order` |
| Target | `edw.fact_property_tribunal_order` |

## Notes

### Phase 100 — runs before its dimensions

Same issue as [fact_property_remedy_notice](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_remedy_notice): this fact references `dim_property` and `dim_property_tenancy`, both in phase `101`, yet loads in phase `100` ahead of them. These two loads are the only members of phase `100 Facts` in the whole framework.

### Overlap with fact_property_tenancy_breach

`fact_property_tenancy_breach` (711) also carries `tribunal_order_id` and `tribunal_outcome_id`, sourced from the same `vw_zav_tribunalorder` view. The two facts model overlapping territory at different grains — breach-level versus order-level. Confirm which is authoritative for tribunal reporting.

### Structurally identical to the remedy notice fact

This fact and `fact_property_remedy_notice` have the same column set apart from the grain key, and both derive from a breach. They are effectively the same pattern applied to two different breach outcomes.
