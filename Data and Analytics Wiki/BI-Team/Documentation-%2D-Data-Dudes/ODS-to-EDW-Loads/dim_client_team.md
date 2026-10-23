# dim_client_team

[[_TOC_]]

Client-facing service team/bed configuration — team name, function, area hierarchy, accommodation and bed-number attributes. Loads in phase `103` because it depends on `dim_service` (phase `102`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `463` |
| Target table | `edw.dim_client_team` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `103 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_team
       └─ landing.edw_dim_client_team             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_team      (staging.insert_staging_dim_client_team)
                 └─ edw.dim_client_team           (edw.Updateedwdim_client_team)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dldimteam`, `dlDimTeamFunction`, `dlDimArea` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_team_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `client_team_id` | `int` | Business key | Recordbase |
| `dim_client_team_unique_key` | `nvarchar(450)` | Combined natural key | — |
| `company_id` | `int` | Business key (raw) | `edw.dim_company.company_id` |
| `dim_service_Key` | `int` | Dimension foreign key _(note capitalisation)_ | `edw.dim_service.dim_service_key` |
| `service_id` | `nvarchar(300)` | Business key | `edw.dim_service.service_id` |

::: mermaid
erDiagram
    dim_service      ||--o{ dim_client_team : "dim_service_Key"
    dim_client_team  ||--o{ dim_client_referral : "client_team_id"
    dim_client_team  ||--o{ dim_client_person_relationship : "dim_client_team_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_team` |
| Landing | `landing.edw_dim_client_team` |
| Staging | `staging.ODSETLdim_client_team` |
| Stored procedures | `staging.insert_staging_dim_client_team`, `edw.Updateedwdim_client_team` |
| Target | `edw.dim_client_team` |

## Notes

### Column casing inconsistency

`dim_service_Key` is capitalised differently from the standard `dim_service_key` used elsewhere in the EDW. This is a live column name, not a typo introduced here — preserve it exactly in any query against this table.

### Area hierarchy carried as flat text

`client_team_area`, `client_team_parent_area` and `client_team_grand_parent_area` model a three-level area hierarchy as separate text columns rather than a normalised hierarchy dimension.
