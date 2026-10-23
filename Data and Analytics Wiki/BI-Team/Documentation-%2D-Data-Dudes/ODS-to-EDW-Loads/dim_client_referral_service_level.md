# dim_client_referral_service_level

[[_TOC_]]

Service level assigned to a client referral over time (e.g. intensity/frequency of support). Loads in phase `103` because it snowflakes onto both `dim_client` and `dim_client_referral` (both phase `101`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `705` |
| Target table | `edw.dim_client_referral_service_level` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `103 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_referral_service_level
       └─ landing.edw_dim_client_referral_service_level             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_referral_service_level      (staging.insert_staging_dim_client_referral_service_level)
                 └─ edw.dim_client_referral_service_level           (edw.Updateedwdim_client_referral_service_level)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dldimperson`, `dlfactreferralservicelevel`, `dlfactreferral`, `dldimlookup` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_referral_service_level_key` | `int` | Surrogate primary key | — |
| `client_referral_service_level_id` | `int` | Business key | Recordbase |
| `dim_client_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_client_referral.dim_client_referral_key` |
| `company_id` | `int` | Business key (raw) | `edw.dim_company.company_id` |
| `client_id` | `int` | Business key (lookup) | Recordbase |
| `client_referral_id` | `int` | Business key (lookup) | Recordbase |

::: mermaid
erDiagram
    dim_client          ||--o{ dim_client_referral_service_level : "dim_client_key"
    dim_client_referral ||--o{ dim_client_referral_service_level : "dim_client_referral_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_referral_service_level` |
| Landing | `landing.edw_dim_client_referral_service_level` |
| Staging | `staging.ODSETLdim_client_referral_service_level` |
| Stored procedures | `staging.insert_staging_dim_client_referral_service_level`, `edw.Updateedwdim_client_referral_service_level` |
| Target | `edw.dim_client_referral_service_level` |

## Notes

### Correctly sequenced snowflake

Unlike the property subject area's phase-101 dependency issue, this table is a good example of correct phase sequencing: it depends on two phase-101 dimensions and is itself placed in phase 103, after both are guaranteed current.

### DWHDMLOperationField naming

The DML-operation audit column is named `DWHDMLOperationField` here, rather than the standard `DWHDMLOperation` used elsewhere in the EDW.
