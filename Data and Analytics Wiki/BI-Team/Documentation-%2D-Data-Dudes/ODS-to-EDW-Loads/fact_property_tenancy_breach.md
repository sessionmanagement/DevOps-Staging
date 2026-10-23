# fact_property_tenancy_breach

[[_TOC_]]

Breaches recorded against a tenancy, together with any tribunal order and outcome that followed.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `711` |
| Target table | `edw.fact_property_tenancy_breach` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_tenancy_breach
       └─ landing.edw_fact_property_tenancy_breach             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_tenancy_breach      (staging.insert_staging_fact_property_tenancy_breach)
                 └─ edw.fact_property_tenancy_breach           (edw.Updateedwfact_property_tenancy_breach)
```

### Distinguishing source views

`vw_zav_tenancybreach`, `vw_zav_tribunalorder`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_tenancy_breach_key` | `int` | Surrogate primary key | — |
| `tenancy_breach_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_tenancybreach` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `breach_id` | `varchar(400)` | Business key (breach reference) | Zavanti |
| `tribunal_order_id` | `uniqueidentifier` | Business key (tribunal order) | Zavanti `vw_zav_tribunalorder` |
| `tribunal_outcome_id` | `uniqueidentifier` | Business key (tribunal outcome) | Zavanti |

::: mermaid
erDiagram
    dim_property_tenancy ||--o{ fact_property_tenancy_breach : "dim_property_tenancy_key"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`, `IsMerged = 1` with **no row versioning**.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_tenancy_breach` |
| Landing | `landing.edw_fact_property_tenancy_breach` |
| Staging | `staging.ODSETLfact_property_tenancy_breach` |
| Stored procedures | `staging.insert_staging_fact_property_tenancy_breach`, `edw.Updateedwfact_property_tenancy_breach` |
| Target | `edw.fact_property_tenancy_breach` |

## Notes

### Breach type is not conformed

[dim_property_breach_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_breach_type) exists and is loaded (DataLoadId 720), but this fact carries **no** `dim_property_breach_type_key`. The join from breach to breach type must therefore go through a business key rather than a surrogate key, which is inconsistent with how every other dimension is consumed here. Worth confirming whether the dimension key was intended and omitted.

### Only one dimension key

Despite being the central breach fact, only `dim_property_tenancy_key` is present. There is no `dim_property_key`, unlike `fact_property_remedy_notice` and `fact_property_tribunal_order`, which both carry one. Property-level breach reporting must traverse `dim_property_tenancy` to reach `dim_property`.

### Overlap with fact_property_tribunal_order

`tribunal_order_id` and `tribunal_outcome_id` duplicate territory covered at finer grain by [fact_property_tribunal_order](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_tribunal_order) (719), which reads the same `vw_zav_tribunalorder` view. A breach with multiple tribunal orders cannot be represented here, since only one order id is held per breach row. Confirm which fact is authoritative for tribunal reporting.

### `breach_id` is wide

`breach_id` is `varchar(400)`, suggesting a concatenated or descriptive value rather than a simple identifier. Verify its content before using it as a join key.

### No date keys

No role-playing date keys are present, so breach timing is not conformed to `dim_date`.
