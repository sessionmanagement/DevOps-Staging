# fact_property_tenancy_transaction

[[_TOC_]]

Financial transactions posted against a tenancy — rent charges, payments, adjustments and the rent-paid-to position at each posting.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `616` |
| Target table | `edw.fact_property_tenancy_transaction` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_tenancy_transaction
       └─ landing.edw_fact_property_tenancy_transaction             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_tenancy_transaction      (staging.insert_staging_fact_property_tenancy_transaction)
                 └─ edw.fact_property_tenancy_transaction           (edw.Updateedwfact_property_tenancy_transaction)
```

### Distinguishing source views

`vw_zav_tenancytransactiondetails`, `vw_opportunity`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_tenancy_transaction_id` | `int` | Surrogate primary key | — |
| `property_tenancy_transaction_id` | `uniqueidentifier` | Business key (grain) | Zavanti |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_detail_key` | `int` | Dimension foreign key | `edw.dim_property_detail` |
| `dim_property_healthy_homes_key` | `int` | Dimension foreign key | `edw.dim_property_healthy_homes` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `dim_property_program_key` | `int` | Dimension foreign key | `edw.dim_property_program` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_program_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_subprogram_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_transaction_payment_type_id` | `bigint` | Business key (payment type) | Zavanti option set |
| `property_tenancy_transaction_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_tenancy_transaction_rent_from_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_tenancy_transaction_rent_to_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_tenancy_transaction_rent_paid_to_date_key` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_tenancy_transaction_as_at_date_key` | `int` | Role-playing date FK | `edw.dim_date` |

::: mermaid
erDiagram
    dim_property               ||--o{ fact_property_tenancy_transaction : ""
    dim_property_detail        ||--o{ fact_property_tenancy_transaction : ""
    dim_property_healthy_homes ||--o{ fact_property_tenancy_transaction : ""
    dim_property_tenancy       ||--o{ fact_property_tenancy_transaction : ""
    dim_property_program       ||--o{ fact_property_tenancy_transaction : ""
    dim_date                   ||--o{ fact_property_tenancy_transaction : "5 roles"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`, `IsMerged = 1` with **no row versioning**.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_tenancy_transaction` |
| Landing | `landing.edw_fact_property_tenancy_transaction` |
| Staging | `staging.ODSETLfact_property_tenancy_transaction` |
| Stored procedures | `staging.insert_staging_fact_property_tenancy_transaction`, `edw.Updateedwfact_property_tenancy_transaction` |
| Target | `edw.fact_property_tenancy_transaction` |

## Notes

### Surrogate key naming

The surrogate key is `fact_property_tenancy_transaction_id`, not `..._key` — the only property _fact_ with this deviation. Three property dimensions share the same pattern.

### Rent period semantics

`rent_from_date_key` and `rent_to_date_key` bound the period the transaction covers, while `transaction_date_key` is when it was posted and `rent_paid_to_date_key` is the resulting arrears position. Reporting on rent _due_ should use the rent period keys; reporting on cash movement should use the transaction date. These are easy to confuse.

### Full reload of a transactional fact

This is a transaction-grain fact loaded by full reload on every run. Volume growth should be monitored — an incremental highwater pattern (as used by the finance ledger facts) may become necessary.
