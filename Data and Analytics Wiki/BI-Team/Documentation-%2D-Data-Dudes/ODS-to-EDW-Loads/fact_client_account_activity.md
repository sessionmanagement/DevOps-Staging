# fact_client_account_activity

[[_TOC_]]

Client account activity records (e.g. non-direct or administrative client support activity), including participated and creator employees, travel time, and duration measures, sourced from Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `661` |
| Target table | `edw.fact_client_account_activity` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  ├─ dlfactaccountactivity
  ├─ dlFactAccountActivityParticipant
  ├─ dldimaccount
  ├─ dldimaccountactivitytype
  ├─ dldimaccountactivityclassification
  └─ dlDimUser
       └─ ODS view: ETL.fact_client_account_activity
            └─ landing.edw_fact_client_account_activity             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_account_activity      (staging.insert_staging_fact_client_account_activity)
                      └─ edw.fact_client_account_activity           (edw.Updateedwfact_client_account_activity)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_account_activity_key` | `int` | Surrogate primary key | — |
| `fact_client_account_activity_id` | `nvarchar(100)` | Compound natural key | — |
| `client_account_activity_id` | `int` | Business key | Recordbase |
| `dim_client_team_key` | `int` | Dimension foreign key | `edw.dim_client_team.dim_client_team_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_participated_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_created_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `participated_employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |
| `created_employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |

### Role-playing date & time keys

- `client_account_activity_date_key`
- `client_account_activity_created_date_key`
- `client_account_activity_start_time_key`
- `client_account_activity_end_time_key`

::: mermaid
erDiagram
    dim_client_team ||--o{ fact_client_account_activity : "dim_client_team_key"
    dim_service     ||--o{ fact_client_account_activity : "dim_service_key"
    dim_company     ||--o{ fact_client_account_activity : "dim_company_key"
    dim_employee    ||--o{ fact_client_account_activity : "participated / created employee_keys"
    dim_date        ||--o{ fact_client_account_activity : "activity / created date keys"
    dim_time        ||--o{ fact_client_account_activity : "start / end time keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_account_activity AS fact
INNER JOIN edw.dim_employee AS e_part
    ON fact.participated_employee_id = e_part.employee_id
    AND e_part.DWHIsCurrent = 1
```

## Measures

- `client_account_activity_duration_in_minutes`: Activity duration (`decimal(18,2)` / `int`).
- `client_account_activity_travel_duration_in_minutes`: Travel time (`decimal(18,2)` / `int`).
- `client_account_activity_distance_in_kilometers`: Distance (`decimal(18,2)` / `float`).
- `client_account_activity_participant_count`: Participant count (`int`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_account_activity` |
| Landing | `landing.edw_fact_client_account_activity` |
| Staging | `staging.ODSETLfact_client_account_activity` |
| Stored procedures | `staging.insert_staging_fact_client_account_activity`, `edw.Updateedwfact_client_account_activity` |
| Target | `edw.fact_client_account_activity` |
