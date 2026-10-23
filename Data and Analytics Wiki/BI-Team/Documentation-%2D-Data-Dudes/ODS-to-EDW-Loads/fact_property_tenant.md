# fact_property_tenant

[[_TOC_]]

Tenants associated with a tenancy — the household members recorded against a tenancy agreement, with lease agreement and tenancy start dates.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `622` |
| Target table | `edw.fact_property_tenant` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_tenant
       └─ landing.edw_fact_property_tenant             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_tenant      (staging.insert_staging_fact_property_tenant)
                 └─ edw.fact_property_tenant           (edw.Updateedwfact_property_tenant)
```

### Distinguishing source views

`vw_zav_household`, `vw_zav_house`, `vw_contact`, `vw_opportunity`

Plus `vw_StateMetadata`, `vw_StatusMetadata` and `vw_GlobalOptionsetMetadata` from the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_tenant_key` | `int` | Surrogate primary key | — |
| `property_tenant_id` | `varchar(50)` | Business key (grain) | Zavanti `vw_contact` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `dim_property_program_key` | `int` | Dimension foreign key | `edw.dim_property_program` |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_program_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_subprogram_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenant_tenancy_lease_agreement_date_id` | `int` | Role-playing date FK | `edw.dim_date` |
| `property_tenant_tenancy_start_date_id` | `int` | Role-playing date FK | `edw.dim_date` |

::: mermaid
erDiagram
    dim_property         ||--o{ fact_property_tenant : "dim_property_key"
    dim_property_tenancy ||--o{ fact_property_tenant : "dim_property_tenancy_key"
    dim_property_program ||--o{ fact_property_tenant : "dim_property_program_key"
    dim_date             ||--o{ fact_property_tenant : "2 roles"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`, `IsMerged = 1` with **no row versioning**.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_tenant` |
| Landing | `landing.edw_fact_property_tenant` |
| Staging | `staging.ODSETLfact_property_tenant` |
| Stored procedures | `staging.insert_staging_fact_property_tenant`, `edw.Updateedwfact_property_tenant` |
| Target | `edw.fact_property_tenant` |

## Notes

### No link to the client dimension

Tenants are people, but this fact carries no `dim_client_key`. The only route from a tenancy to a Recordbase client is `property_tenancy_primary_tenant_recordbaseid` on [dim_property_tenancy](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_tenancy), which covers the primary tenant only. Reporting that spans tenants and clients needs this gap closed.

### Date keys named `_id`

Both date keys use the `_id` suffix while holding `dim_date_key` values. Consistent with several other property tables, inconsistent with the wider EDW convention.

### Grain

The grain is the tenant within a tenancy. A tenancy with three household members produces three rows, so measures aggregated across this fact will overcount at tenancy level unless distinct-counted on `property_tenancy_id`.
