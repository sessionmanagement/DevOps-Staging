# dim_property_tenancy

[[_TOC_]]

Tenancy agreements — the arrangement under which a property is let to a tenant. This dimension carries limited tenant demographic attributes and is the anchor for arrears, breach, transaction and void reporting.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `613` |
| Target table | `edw.dim_property_tenancy` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_tenancy
       └─ landing.edw_dim_property_tenancy             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_tenancy      (staging.insert_staging_dim_property_tenancy)
                 └─ edw.dim_property_tenancy           (edw.Updateedwdim_property_tenancy)
```

### Distinguishing source views

`vw_opportunity`, `vw_contact`, `vw_zav_voidcategory`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

> In Zavanti, a tenancy is modelled on the Dataverse `opportunity` entity — hence `vw_opportunity` as the primary source.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_tenancy_key` | `int` | Surrogate primary key | — |
| `dim_property_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_property.dim_property_key` |
| `dim_gender_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_gender.dim_gender_key` |
| `property_tenancy_id` | `uniqueidentifier` | Business key | Zavanti `vw_opportunity` |
| `property_id` | `uniqueidentifier` | Business key (parent property) | Zavanti `vw_zav_property` |
| `ethnicity_id` | `int` | Business key (tenant ethnicity) | Reference / `dim_ethnicity` source |
| `property_tenancy_primary_tenant_recordbaseid` | `varchar(50)` | Cross-system business key | Recordbase (`rbeal` / `rbmnb`) client |

::: mermaid
erDiagram
    dim_property ||--o{ dim_property_tenancy : "dim_property_key"
    dim_gender   ||--o{ dim_property_tenancy : "dim_gender_key"
    dim_property_tenancy ||--o{ dim_property_arrears_arrangement : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_tenancy_breach : "dim_property_tenancy_key"
    dim_property_tenancy ||--o{ fact_property_tenant : "dim_property_tenancy_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 613` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_tenancy` |
| Landing | `landing.edw_dim_property_tenancy` |
| Staging | `staging.ODSETLdim_property_tenancy` |
| Stored procedures | `staging.insert_staging_dim_property_tenancy`, `edw.Updateedwdim_property_tenancy`, highwater procedure |
| Target | `edw.dim_property_tenancy` |

## Notes

### Cross-system linkage

`property_tenancy_primary_tenant_recordbaseid` holds a Recordbase client reference, making this one of the few places where the property and client subject areas meet directly. It is a raw business key — there is no `dim_client_key` on this dimension, so joining tenancy to client requires a lookup through `edw.dim_client`.

### Ethnicity is a raw id

`ethnicity_id` is stored as an `int` business key rather than a `dim_ethnicity_key`. Ethnicity reporting from tenancy therefore does not use the conformed ethnicity dimension by default.

### Intra-phase dependency

This load holds a FK to `dim_property` (DataLoadId 558) but shares phase `101` with it. See [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).
