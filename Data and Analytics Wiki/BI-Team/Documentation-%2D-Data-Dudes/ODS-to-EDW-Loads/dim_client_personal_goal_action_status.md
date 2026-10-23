# dim_client_personal_goal_action_status

[[_TOC_]]

Status classification for individual actions within a client's personal goal plan (e.g. completed, cancelled, in progress).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `465` |
| Target table | `edw.dim_client_personal_goal_action_status` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_personal_goal_action_status
       └─ landing.edw_dim_client_personal_goal_action_status             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_personal_goal_action_status      (staging.insert_staging_dim_client_personal_goal_action_status)
                 └─ edw.dim_client_personal_goal_action_status           (edw.Updateedwdim_client_personal_goal_action_status)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlDimGoalActionStatus` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_personal_goal_action_status_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `personal_goal_action_status_id` | `int` | Business key | Recordbase |
| `dim_client_personal_goal_action_status_unique_key` | `nvarchar(100)` | Combined natural key | — |
| `company_id` | `int` | Business key (raw) | `edw.dim_company.company_id` |

::: mermaid
erDiagram
    dim_client_personal_goal_action_status ||--o{ fact_client_personal_goal : "dim_client_personal_goal_action_status_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_personal_goal_action_status` |
| Landing | `landing.edw_dim_client_personal_goal_action_status` |
| Staging | `staging.ODSETLdim_client_personal_goal_action_status` |
| Stored procedures | `staging.insert_staging_dim_client_personal_goal_action_status`, `edw.Updateedwdim_client_personal_goal_action_status` |
| Target | `edw.dim_client_personal_goal_action_status` |

## Notes

### Boolean semantics carried as BIT flags

`personal_goal_action_status_is_completed_status` and `personal_goal_action_status_is_cancelled_status` are `bit` flags derived from the status text — useful for filtering completed/cancelled actions without string matching on `personal_goal_action_status_text`.
