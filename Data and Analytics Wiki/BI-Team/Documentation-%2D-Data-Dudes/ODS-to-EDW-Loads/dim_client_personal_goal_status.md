# dim_client_personal_goal_status

[[_TOC_]]

Status classification for a client's overall personal goal (distinct from the action-level status on `dim_client_personal_goal_action_status`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `481` |
| Target table | `edw.dim_client_personal_goal_status` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_personal_goal_status
       └─ landing.edw_dim_client_personal_goal_status             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_personal_goal_status      (staging.insert_staging_dim_client_personal_goal_status)
                 └─ edw.dim_client_personal_goal_status           (edw.Updateedwdim_client_personal_goal_status)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlDimGoalStatusType` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_personal_goal_status_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `personal_goal_status_type_id` | `int` | Business key | Recordbase |
| `dim_client_personal_goal_status_unique_key` | `nvarchar(100)` | Combined natural key | — |
| `company_id` | `int` | Business key (raw) | `edw.dim_company.company_id` |

::: mermaid
erDiagram
    dim_client_personal_goal_status ||--o{ fact_client_personal_goal : "dim_client_personal_goal_status_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_personal_goal_status` |
| Landing | `landing.edw_dim_client_personal_goal_status` |
| Staging | `staging.ODSETLdim_client_personal_goal_status` |
| Stored procedures | `staging.insert_staging_dim_client_personal_goal_status`, `edw.Updateedwdim_client_personal_goal_status` |
| Target | `edw.dim_client_personal_goal_status` |

## Notes

### Goal-level versus action-level status

Do not confuse this table with [dim_client_personal_goal_action_status](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_personal_goal_action_status) — the two model different grains (the goal itself, versus individual actions within it) and are near-identical in structure.
