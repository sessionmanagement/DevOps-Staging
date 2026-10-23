# dim_client

[[_TOC_]]

The core conformed client dimension — one row per client version. Stores demographic, contact, address, ethnicity/iwi, legal status, health and residency attributes.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `461` |
| Target table | `edw.dim_client` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client
       └─ landing.edw_dim_client             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client      (staging.insert_staging_dim_client)
                 └─ edw.dim_client           (edw.Updateedwdim_client)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dldimperson`, `dlDimEthnicity`, `dlDimPhysicalCondition`, `dlDimSubstanceType`, `dlDimMentalCondition`, `dlDimLegalStatus`, `dlDimCustomField`, `dlDimLookup`, `dldimgender`, `dldimresidency`, `dldimsmokingstatus`, `dldimphonenumbertype`, `dlfactaddress`, `dlfactemail`, `dlfactphone`, `dlFactReferral`, `dlFactPersonHealthCondition`, `dlFactPersonLegalStatus`, `dlFactPersonContact`, `dlFactCustomFieldDataItem`, `dlfactpersonsmokinghistory` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `client_id` | `int` | Business key | Recordbase |
| `dim_client_unique_key` | `nvarchar(200)` | Combined natural key | — |
| `company_id` | `int` | Business key (raw, **not** a `dim_company_key` FK) | `edw.dim_company.company_id` |
| `primary_ethnicity_id` / `secondary_ethnicity_id` / `tertiary_ethnicity_id` / `fourth_ethnicity_id` / `priority_ethnicity_id` | `int` | Business key | `edw.dim_ethnicity` |
| `primary_iwi_id` / `secondary_iwi_id` / `tertiary_iwi_id` / `fourth_iwi_id` | `int` | Business key | Reference iwi lookup |

::: mermaid
erDiagram
    dim_client ||--o{ dim_client_referral : "client_id"
    dim_client ||--o{ dim_client_referral_service_level : "dim_client_key"
    dim_client ||--o{ dim_client_absence : "dim_client_key"
    dim_client ||--o{ dim_client_person_relationship : "dim_client_key"
    dim_ethnicity ||--o{ dim_client : "primary/secondary/tertiary/fourth/priority ethnicity_id"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_referral AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client` |
| Landing | `landing.edw_dim_client` |
| Staging | `staging.ODSETLdim_client` |
| Stored procedures | `staging.insert_staging_dim_client`, `edw.Updateedwdim_client` |
| Target | `edw.dim_client` |

## Notes

### company_id is a raw business key, not a dimension foreign key

Unlike `dim_client_incident` and its peers (which use a surrogate `dim_company_key`), `dim_client` carries `company_id` as a plain business key with no FK relationship to `edw.dim_company`. See [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Dimension-Load-Overview) for the full pattern comparison across the client group.

### Five ethnicity/iwi business keys, no surrogate FKs

All five ethnicity fields (`primary`, `secondary`, `tertiary`, `fourth`, `priority`) and four iwi fields are stored as raw business-key IDs rather than `dim_ethnicity_key` surrogates. Joins to the conformed ethnicity dimension must resolve through these business keys with a `DWHIsCurrent = 1` filter on `dim_ethnicity`.

### Business definition

Column-level business detail: [EDW dimension tables](/BI-Team/Documentation-%2D-Data-Dudes/Data-Documentation/EDW-dimension-tables).
