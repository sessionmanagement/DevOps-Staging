# fact_client_referral

[[_TOC_]]

Primary client referral fact — measures referral status transitions, team/service assignments, bed night durations, hospital stay nights, and absence days.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `485` |
| Target table | `edw.fact_client_referral` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb), IntelliHR |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb) / IntelliHR
  ├─ dlfactreferral
  ├─ dlfactreferralstatus
  ├─ dlFactPersonStatus
  ├─ dlFactPersonRelationship
  └─ people (IntelliHR)
       └─ ODS view: ETL.fact_client_referral
            └─ landing.edw_fact_client_referral             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_referral      (staging.insert_staging_fact_client_referral)
                      └─ edw.fact_client_referral           (edw.Updateedwfact_client_referral)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_referral_key` | `int` | Surrogate primary key | — |
| `fact_client_referral_unique_key` | `nvarchar(200)` | Compound natural key | — |
| `client_referral_id` | `int` | Business key | Recordbase |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_team_id` | `int` | Business key | `edw.dim_client_team.client_team_id` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_client_team_key` | `int` | Dimension foreign key | `edw.dim_client_team.dim_client_team_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |

### Role-playing date keys

- `client_referral_received_date_key`
- `client_referral_created_date_key`
- `client_referral_end_date_key`
- `client_referral_discharge_date_key`
- `client_referral_accepted_date_key`
- `client_referral_waitlist_date_key`
- `client_referral_decline_date_key`
- `client_referral_person_relationship_start_date_key`
- `client_referral_person_relationship_end_date_key`

::: mermaid
erDiagram
    dim_client          ||--o{ fact_client_referral : "client_id / dim_client_key"
    dim_client_referral ||--o{ fact_client_referral : "client_referral_id / dim_client_referral_key"
    dim_client_team     ||--o{ fact_client_referral : "client_team_id / dim_client_team_key"
    dim_employee        ||--o{ fact_client_referral : "dim_employee_key"
    dim_service         ||--o{ fact_client_referral : "dim_service_key"
    dim_company         ||--o{ fact_client_referral : "dim_company_key"
    dim_date            ||--o{ fact_client_referral : "9 date roles"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_referral AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_client_referral AS r
    ON fact.client_referral_id = r.client_referral_id
    AND r.DWHIsCurrent = 1
```

## Measures

- `client_referral_bed_nights`: Number of bed nights (`int`).
- `client_referral_hospital_nights`: Number of hospital nights (`int`).
- `client_referral_absence`: Days absent (`int`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_referral` |
| Landing | `landing.edw_fact_client_referral` |
| Staging | `staging.ODSETLfact_client_referral` |
| Stored procedures | `staging.insert_staging_fact_client_referral`, `edw.Updateedwfact_client_referral` |
| Target | `edw.fact_client_referral` |

## Notes

- See also [fact_client_referral_V2](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_client_referral_V2) (DataLoadId 587) which extends this table with caseworker assignment indicator fields.
