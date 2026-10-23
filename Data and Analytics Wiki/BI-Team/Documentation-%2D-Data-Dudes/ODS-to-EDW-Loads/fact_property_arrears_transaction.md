# fact_property_arrears_transaction

[[_TOC_]]

Individual transactions recorded against an arrears repayment arrangement — payments made, missed and adjusted under an agreed arrears plan.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `712` |
| Target table | `edw.fact_property_arrears_transaction` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_arrears_transaction
       └─ landing.edw_fact_property_arrears_transaction             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_arrears_transaction      (staging.insert_staging_fact_property_arrears_transaction)
                 └─ edw.fact_property_arrears_transaction           (edw.Updateedwfact_property_arrears_transaction)
```

### Distinguishing source views

`vw_zav_arrearsarrangementstransactions`, `vw_opportunity`

Plus `vw_StateMetadata` and `vw_StatusMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_arrears_transaction_key` | `int` | Surrogate primary key | — |
| `transaction_id` | `uniqueidentifier` | Business key (grain) | Zavanti |
| `dim_property_arrears_arrangement_key` | `int` | Dimension foreign key | `edw.dim_property_arrears_arrangement` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `dim_property_program_key` | `int` | Dimension foreign key | `edw.dim_property_program` |
| `property_arrears_arrangement_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_program_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_subprogram_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `transaction_detail_id` | `uniqueidentifier` | Business key (transaction line) | Zavanti |
| `transaction_date_id` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `owner_id` | `uniqueidentifier` | Business key (Dataverse owner) | Zavanti `vw_systemuser` |

::: mermaid
erDiagram
    dim_property_arrears_arrangement ||--o{ fact_property_arrears_transaction : "dim_property_arrears_arrangement_key"
    dim_property         ||--o{ fact_property_arrears_transaction : "dim_property_key"
    dim_property_tenancy ||--o{ fact_property_arrears_transaction : "dim_property_tenancy_key"
    dim_property_program ||--o{ fact_property_arrears_transaction : "dim_property_program_key"
    dim_date             ||--o{ fact_property_arrears_transaction : "transaction_date_id"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`. The full ODS view is read on every run, then merged with row versioning.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_arrears_transaction` |
| Landing | `landing.edw_fact_property_arrears_transaction` |
| Staging | `staging.ODSETLfact_property_arrears_transaction` |
| Stored procedures | `staging.insert_staging_fact_property_arrears_transaction`, `edw.Updateedwfact_property_arrears_transaction` |
| Target | `edw.fact_property_arrears_transaction` |

## Notes

### Date key named `_id`

`transaction_date_id` is a role-playing foreign key to `dim_date` holding a `YYYYMMDD` integer, despite the `_id` suffix normally reserved for source-system business keys. The same pattern appears on [dim_property_arrears_arrangement](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_arrears_arrangement) and several other property facts.

### Grain ambiguity

Both `transaction_id` and `transaction_detail_id` are present. Confirm which defines the grain — if a transaction can have multiple detail lines, the fact grain is the detail, and `transaction_id` is a degenerate header reference.

### Depends on a phase 103 dimension

This is the only property fact referencing `dim_property_arrears_arrangement`, which loads in phase `103`. The phase `200` placement correctly sequences after it.
