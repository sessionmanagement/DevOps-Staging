# fact_client_activity_breakdown

[[_TOC_]]

Client activity breakdown entries — detailed measures for contact duration, travel time, travel distance, participant counts, and staff counts, sourced from Recordbase and IntelliHR.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `635` |
| Target table | `edw.fact_client_activity_breakdown` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb), IntelliHR |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb) / IntelliHR
  ├─ dlfactactivity
  ├─ dlfactactivitybreakdown
  ├─ dlFactActivityParticipant
  ├─ dldimactivitytype
  ├─ dldimactivityclassification
  ├─ dldimactivitybreakdowntype
  ├─ dldimuser
  ├─ dldimperson
  └─ people (IntelliHR)
       └─ ODS view: ETL.fact_client_activity_breakdown
            └─ landing.edw_fact_client_activity_breakdown             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_activity_breakdown      (staging.insert_staging_fact_client_activity_breakdown)
                      └─ edw.fact_client_activity_breakdown           (edw.Updateedwfact_client_activity_breakdown)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_activity_breakdown_key` | `int` | Surrogate primary key | — |
| `client_activity_breakdown_id` | `int` | Business key | Recordbase |
| `client_activity_id` | `int` | Business key (activity header) | Recordbase |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_referral_id` | `int` | Business key | `edw.dim_client_referral.client_referral_id` |
| `client_activity_breakdown_type_id` | `int` | Business key | `edw.dim_client_activity_breakdown_type.client_activity_breakdown_type_id` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_client_activity_breakdown_type_key` | `int` | Dimension foreign key | `edw.dim_client_activity_breakdown_type.dim_client_activity_breakdown_type_key` |
| `dim_client_team_key` | `int` | Dimension foreign key | `edw.dim_client_team.dim_client_team_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |

### Role-playing date & time keys

- `client_activity_start_date_key`
- `client_activity_end_date_key`
- `client_activity_created_date_key`
- `client_activity_start_time_key`
- `client_activity_end_time_key`

::: mermaid
erDiagram
    dim_client                            ||--o{ fact_client_activity_breakdown : "client_id / dim_client_key"
    dim_client_referral                   ||--o{ fact_client_activity_breakdown : "client_referral_id / dim_client_referral_key"
    dim_client_activity_breakdown_type   ||--o{ fact_client_activity_breakdown : "client_activity_breakdown_type_id"
    dim_client_team                       ||--o{ fact_client_activity_breakdown : "dim_client_team_key"
    dim_employee                          ||--o{ fact_client_activity_breakdown : "dim_employee_key"
    dim_service                           ||--o{ fact_client_activity_breakdown : "dim_service_key"
    dim_company                           ||--o{ fact_client_activity_breakdown : "dim_company_key"
    dim_date                              ||--o{ fact_client_activity_breakdown : "start / end / created date keys"
    dim_time                              ||--o{ fact_client_activity_breakdown : "start / end time keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_activity_breakdown AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_client_activity_breakdown_type AS t
    ON fact.client_activity_breakdown_type_id = t.client_activity_breakdown_type_id
    AND t.DWHIsCurrent = 1
```

## Measures

- `client_activity_duration_in_minutes`: Duration (`decimal(18,2)` / `int`).
- `client_activity_travel_duration_in_minutes`: Travel time (`decimal(18,2)` / `int`).
- `client_activity_distance_in_kilometers`: Travel distance (`decimal(18,2)` / `float`).
- `client_activity_participant_count`: Number of participants (`int`).
- `client_activity_staff_participant_count`: Number of staff participants (`int`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_activity_breakdown` |
| Landing | `landing.edw_fact_client_activity_breakdown` |
| Staging | `staging.ODSETLfact_client_activity_breakdown` |
| Stored procedures | `staging.insert_staging_fact_client_activity_breakdown`, `edw.Updateedwfact_client_activity_breakdown` |
| Target | `edw.fact_client_activity_breakdown` |
