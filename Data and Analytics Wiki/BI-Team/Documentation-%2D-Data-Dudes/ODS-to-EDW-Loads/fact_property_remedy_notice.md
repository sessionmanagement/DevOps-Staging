# fact_property_remedy_notice

[[_TOC_]]

Notices to remedy issued against a tenancy — the formal notice served on a tenant requiring a breach to be put right within a set period.

> **Loads before every dimension.** This load is configured with phase `100 Facts`, which sorts ahead of all dimension phases. See [Notes](#notes).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `718` |
| Target table | `edw.fact_property_remedy_notice` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `100 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_remedy_notice
       └─ landing.edw_fact_property_remedy_notice             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_remedy_notice      (staging.insert_staging_fact_property_remedy_notice)
                 └─ edw.fact_property_remedy_notice           (edw.Updateedwfact_property_remedy_notice)
```

### Distinguishing source views

`vw_zav_noticetoremedy`

Plus `vw_StateMetadata` and `vw_StatusMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_remedy_notice_key` | `int` | Surrogate primary key | — |
| `property_remedy_notice_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_noticetoremedy` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_breach_id` | `uniqueidentifier` | Business key (originating breach) | Zavanti `vw_zav_tenancybreach` |

::: mermaid
erDiagram
    dim_property         ||--o{ fact_property_remedy_notice : "dim_property_key"
    dim_property_tenancy ||--o{ fact_property_remedy_notice : "dim_property_tenancy_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_remedy_notice` |
| Landing | `landing.edw_fact_property_remedy_notice` |
| Staging | `staging.ODSETLfact_property_remedy_notice` |
| Stored procedures | `staging.insert_staging_fact_property_remedy_notice`, `edw.Updateedwfact_property_remedy_notice` |
| Target | `edw.fact_property_remedy_notice` |

## Notes

### Phase 100 — runs before its dimensions

This fact holds foreign keys to `dim_property` (phase `101`) and `dim_property_tenancy` (phase `101`), but is itself configured in phase `100 Facts`, which `10_Load_Master` runs **first**. On any given run, the dimension rows this fact resolves against are from the _previous_ day's load.

Only two loads in the entire framework sit in phase `100 Facts` — this one and [fact_property_tribunal_order](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_tribunal_order). Every other fact is in `200` or `201`. Confirm whether the phase value is deliberate or a configuration error.

### No date dimension keys

Unusually for a fact, no role-playing date keys are present. Notice issue and expiry dates, if carried, are held as plain columns rather than `dim_date` foreign keys.

### No measures

This is a factless fact — it records that a notice event occurred, with no additive measures.

### Relationship to breach

`property_tenancy_breach_id` links back to the originating breach as a raw business key. There is no `fact_property_tenancy_breach_key`, so joining notice to breach requires a lookup through the business key.
