# fact_client_referral_goal

[[_TOC_]]

Client referral goals set within a referral, sourced from Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `483` |
| Target table | `edw.fact_client_referral_goal` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ dlFactPersonalPlan
       └─ ODS view: ETL.fact_client_referral_goal
            └─ landing.edw_fact_client_referral_goal             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_referral_goal      (staging.insert_staging_fact_client_referral_goal)
                      └─ edw.fact_client_referral_goal           (edw.Updateedwfact_client_referral_goal)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_referral_goal_key` | `int` | Surrogate primary key | — |
| `fact_client_referral_goal_unique_key` | `nvarchar(100)` | Compound natural key | — |
| `client_referral_goal_id` | `int` | Business key | Recordbase |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_referral_id` | `int` | Business key | `edw.dim_client_referral.client_referral_id` |
| `client_referral_goal_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `client_referral_goal_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `client_referral_goal_created_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `client_referral_goal_next_review_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |

::: mermaid
erDiagram
    dim_client          ||--o{ fact_client_referral_goal : "client_id / dim_client_key"
    dim_client_referral ||--o{ fact_client_referral_goal : "client_referral_id / dim_client_referral_key"
    dim_company         ||--o{ fact_client_referral_goal : "dim_company_key"
    dim_date            ||--o{ fact_client_referral_goal : "start / end / created / review dates"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_referral_goal AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_client_referral AS r
    ON fact.client_referral_id = r.client_referral_id
    AND r.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_referral_goal` |
| Landing | `landing.edw_fact_client_referral_goal` |
| Staging | `staging.ODSETLfact_client_referral_goal` |
| Stored procedures | `staging.insert_staging_fact_client_referral_goal`, `edw.Updateedwfact_client_referral_goal` |
| Target | `edw.fact_client_referral_goal` |
