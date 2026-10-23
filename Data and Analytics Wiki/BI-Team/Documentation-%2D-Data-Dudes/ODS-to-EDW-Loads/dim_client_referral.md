# dim_client_referral

[[_TOC_]]

Client referral header — one row per referral version, including referral source, team, status reasons and discharge/acceptance/waitlist/decline commentary.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `464` |
| Target table | `edw.dim_client_referral` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_referral
       └─ landing.edw_dim_client_referral             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_referral      (staging.insert_staging_dim_client_referral)
                 └─ edw.dim_client_referral           (edw.Updateedwdim_client_referral)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlfactreferral`, `dldimreferrer`, `dlfactreferralstatus`, `dldimreferralstatustype`, `dldimreferralstatustypereason` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_referral_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `client_referral_id` | `int` | Business key | Recordbase |
| `dim_client_referral_unique_key` | `nvarchar(200)` | Combined natural key | — |
| `company_id` | `int` | Business key (raw) | `edw.dim_company.company_id` |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_team_id` | `int` | Business key | `edw.dim_client_team.client_team_id` |
| `client_referral_source_id` | `int` | Business key | Recordbase referrer lookup |

::: mermaid
erDiagram
    dim_client       ||--o{ dim_client_referral : "client_id"
    dim_client_team  ||--o{ dim_client_referral : "client_team_id"
    dim_client_referral ||--o{ dim_client_referral_service_level : "dim_client_referral_key"
    dim_client_referral ||--o{ dim_client_person_relationship : "dim_client_referral_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_referral AS fact
INNER JOIN edw.dim_client_referral AS r
    ON fact.client_referral_id = r.client_referral_id
    AND r.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_referral` |
| Landing | `landing.edw_dim_client_referral` |
| Staging | `staging.ODSETLdim_client_referral` |
| Stored procedures | `staging.insert_staging_dim_client_referral`, `edw.Updateedwdim_client_referral` |
| Target | `edw.dim_client_referral` |

## Notes

### Related role-playing date views

Three views — `dim_client_referral_created_date`, `dim_client_referral_discharge_date`, `dim_client_referral_received_date` — expose referral lifecycle dates as role-playing `dim_date` keys. These are views, not Framework-managed loads, and have no DataLoadId.

### Status reason text stored alongside codes

Discharge/accepted/waitlist/declined/pending reasons are stored as both a code (`*_reason_code`) and free-text comment (`*_comment`, `nvarchar(max)`), for five separate referral outcomes. Consuming reports typically only need the code plus `client_referral_status`.
