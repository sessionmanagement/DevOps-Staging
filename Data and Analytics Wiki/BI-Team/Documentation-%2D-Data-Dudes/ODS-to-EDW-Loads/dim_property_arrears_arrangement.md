# dim_property_arrears_arrangement

[[_TOC_]]

Arrears repayment arrangements agreed with a tenant. Loads in phase `103` — the latest dimension phase — because it depends on three other property dimensions.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `713` |
| Target table | `edw.dim_property_arrears_arrangement` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `103 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_arrears_arrangement
       └─ landing.edw_dim_property_arrears_arrangement             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_arrears_arrangement      (staging.insert_staging_dim_property_arrears_arrangement)
                 └─ edw.dim_property_arrears_arrangement           (edw.Updateedwdim_property_arrears_arrangement)
```

### Distinguishing source views

`vw_zav_arrearsarrangement`, `vw_opportunity`

Plus `vw_OptionsetMetadata` and `vw_GlobalOptionsetMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

This is the most heavily related dimension in the property group — it snowflakes onto three other dimensions and carries three role-playing date keys.

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_arrears_arrangement_key` | `int` | Surrogate primary key | — |
| `dim_property_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_property.dim_property_key` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_property_tenancy.dim_property_tenancy_key` |
| `dim_property_program_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_property_program` |
| `property_arrears_arrangement_id` | `uniqueidentifier` | Business key | Zavanti `vw_zav_arrearsarrangement` |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti `vw_opportunity` |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti `vw_zav_property` |
| `property_program_id` | `uniqueidentifier` | Business key (lookup) | Zavanti `vw_zav_program` |
| `property_subprogram_id` | `uniqueidentifier` | Business key (lookup) | Zavanti `vw_zav_subprogram` |
| `tenancy_transaction_type_id` | `uniqueidentifier` | Business key | Zavanti |
| `start_date_id` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `end_date_id` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `first_payment_date_id` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |

::: mermaid
erDiagram
    dim_property         ||--o{ dim_property_arrears_arrangement : "dim_property_key"
    dim_property_tenancy ||--o{ dim_property_arrears_arrangement : "dim_property_tenancy_key"
    dim_property_program ||--o{ dim_property_arrears_arrangement : "dim_property_program_key"
    dim_date             ||--o{ dim_property_arrears_arrangement : "3 roles"
    dim_property_arrears_arrangement ||--o{ fact_property_arrears_transaction : "dim_property_arrears_arrangement_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 713` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_arrears_arrangement` |
| Landing | `landing.edw_dim_property_arrears_arrangement` |
| Staging | `staging.ODSETLdim_property_arrears_arrangement` |
| Stored procedures | `staging.insert_staging_dim_property_arrears_arrangement`, `edw.Updateedwdim_property_arrears_arrangement`, highwater procedure |
| Target | `edw.dim_property_arrears_arrangement` |

## Notes

### Phase placement is correct here

Unlike `dim_property_lease` and `dim_property_tenancy`, this load is correctly sequenced — phase `103` runs after `101`, so all three parent dimensions are current before it loads. It is a useful reference point when reviewing the intra-phase dependency issue on the other two.

### Date keys named `_id`, not `_key`

`start_date_id`, `end_date_id` and `first_payment_date_id` are role-playing foreign keys to `dim_date` but use the `_id` suffix normally reserved for business keys. They hold `dim_date_key` values in `YYYYMMDD` integer format, not source-system identifiers. The same pattern appears on several property facts.

### Dimension carrying dates

Holding three date keys on a dimension rather than a fact is unusual for a Kimball model. It works here because an arrangement is a slowly changing entity with its own lifecycle dates, but it does mean arrangement date analysis is done from the dimension rather than from `fact_property_arrears_transaction`.
