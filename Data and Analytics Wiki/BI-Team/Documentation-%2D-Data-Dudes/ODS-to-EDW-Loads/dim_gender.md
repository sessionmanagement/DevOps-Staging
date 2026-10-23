# dim_gender

[[_TOC_]]

The conformed gender dimension — standardizes gender classifications across all operational source systems (Datapay, Emplive, IntelliHR, Recordbase, and Zavanti).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `526` |
| Target table | `edw.dim_gender` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 1 (in-place merge) |
| Source systems | Datapay, Emplive, IntelliHR, Recordbase, Zavanti |

## Data lineage

```text
Datapay / Emplive / IntelliHR / Recordbase / Zavanti
  ├─ Datapay: employees
  ├─ Emplive: employees
  ├─ IntelliHR: people
  ├─ Recordbase: dlDimGender
  └─ Zavanti: vw_OptionsetMetadata (OptionSetName = 'gendercode')
       └─ ODS view: ETL.dim_gender
            └─ landing.edw_dim_gender             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_gender      (staging.insert_staging_dim_gender)
                      └─ edw.dim_gender           (edw.Updateedwdim_gender)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_gender_key` | `int` | Surrogate primary key (identity 1, 1) | — |
| `gender_id` | `int` | Conformed gender ID | — |
| `gender_code` | `nvarchar(10)` | Standard gender code | — |
| `gender_name` | `nvarchar(100)` | Standard gender label (e.g. Female, Male, Diverse, Unknown) | — |
| `intellihr_gender_key` | `nvarchar(100)` | Source mapping key | IntelliHR |
| `datapay_gender_key` | `nvarchar(100)` | Source mapping key | Datapay |
| `zavanti_gender_key` | `nvarchar(100)` | Source mapping key | Zavanti |
| `emplive_gender_key` | `nvarchar(100)` | Source mapping key | Emplive |

::: mermaid
erDiagram
    dim_gender ||--o{ dim_property_tenancy : "dim_gender_key"
    dim_gender ||--o{ dim_employee : "gender_name"
    dim_gender ||--o{ dim_client : "gender_name"
:::

## Direct business key join pattern

```sql
FROM edw.dim_client AS c
INNER JOIN edw.dim_gender AS g
    ON c.client_gender = g.gender_name
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_gender` |
| Landing | `landing.edw_dim_gender` |
| Staging | `staging.ODSETLdim_gender` |
| Stored procedures | `staging.insert_staging_dim_gender`, `edw.Updateedwdim_gender` |
| Target | `edw.dim_gender` |
