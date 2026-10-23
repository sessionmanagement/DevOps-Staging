# fact_client_personal_goal

[[_TOC_]]

Client personal goals and action plan tracking, including goal categories, status transitions, and completion dates. Runs in phase `201 Facts`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `486` |
| Target table | `edw.fact_client_personal_goal` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `201 Facts` |
| Source systems | Recordbase (rbeal, rbmnb), IntelliHR |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb) / IntelliHR
  ├─ dlFactPersonalPlan
  ├─ dlFactGoal
  ├─ dlFactGoalAction
  ├─ dlFactGoalActionOwner
  ├─ dlFactGoalLookupStatus
  ├─ dlDimGoalCategory
  ├─ dlDimUser
  └─ people (IntelliHR)
       └─ ODS view: ETL.fact_client_personal_goal
            └─ landing.edw_fact_client_personal_goal             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_personal_goal      (staging.insert_staging_fact_client_personal_goal)
                      └─ edw.fact_client_personal_goal           (edw.Updateedwfact_client_personal_goal)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_personal_goal_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `fact_client_personal_goal_unique_key` | `nvarchar(100)` | Compound natural key | — |
| `client_personal_goal_id` | `int` | Business key | Recordbase |
| `client_personal_goal_action_id` | `int` | Business key (action level) | Recordbase |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_referral_id` | `int` | Business key | `edw.dim_client_referral.client_referral_id` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_client_personal_goal_status_key` | `int` | Dimension foreign key | `edw.dim_client_personal_goal_status.dim_client_personal_goal_status_key` |
| `dim_client_personal_goal_action_status_key` | `int` | Dimension foreign key | `edw.dim_client_personal_goal_action_status.dim_client_personal_goal_action_status_key` |
| `fact_client_referral_goal_key` | `int` | Fact foreign key | `edw.fact_client_referral_goal.fact_client_referral_goal_key` |

### Role-playing date keys

- `client_personal_goal_created_date_key`
- `client_personal_plan_start_date_key`
- `client_personal_plan_end_date_key`
- `client_personal_goal_start_date_key`
- `client_personal_goal_due_date_key`
- `client_personal_goal_action_due_date_key`
- `client_personal_goal_action_completed_date_key`
- `client_personal_goal_close_completed_date_key`
- `client_personal_goal_close_not_completed_date_key`
- `client_personal_goal_close_date_key`
- `client_personal_goal_action_created_date_key`

::: mermaid
erDiagram
    dim_client                               ||--o{ fact_client_personal_goal : "client_id / dim_client_key"
    dim_client_referral                      ||--o{ fact_client_personal_goal : "client_referral_id / dim_client_referral_key"
    dim_employee                             ||--o{ fact_client_personal_goal : "dim_employee_key"
    dim_company                              ||--o{ fact_client_personal_goal : "dim_company_key"
    dim_client_personal_goal_status          ||--o{ fact_client_personal_goal : "dim_client_personal_goal_status_key"
    dim_client_personal_goal_action_status   ||--o{ fact_client_personal_goal : "dim_client_personal_goal_action_status_key"
    fact_client_referral_goal                ||--o{ fact_client_personal_goal : "fact_client_referral_goal_key"
    dim_date                                 ||--o{ fact_client_personal_goal : "11 date roles"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_personal_goal AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_client_personal_goal_status AS s
    ON fact.client_personal_goal_status_id = s.personal_goal_status_type_id
    AND s.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_personal_goal` |
| Landing | `landing.edw_fact_client_personal_goal` |
| Staging | `staging.ODSETLfact_client_personal_goal` |
| Stored procedures | `staging.insert_staging_fact_client_personal_goal`, `edw.Updateedwfact_client_personal_goal` |
| Target | `edw.fact_client_personal_goal` |

## Notes

- Placed in phase `201 Facts` to ensure prerequisite fact `fact_client_referral_goal` (phase `200`) has completed first.
