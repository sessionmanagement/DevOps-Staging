# fact_client_primhd_service_review

[[_TOC_]]

PRIMHD service review records (accommodation status, education status, employment status, wellness plan status) for Ministry of Health reporting, sourced from Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `780` |
| Target table | `edw.fact_client_primhd_service_review` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  ├─ dlfactprimhdservicereview
  ├─ dlDimPRIMHDReviewAccommodationStatus
  ├─ dlDimPRIMHDReviewEducationStatus
  ├─ dlDimPRIMHDReviewEmploymentStatus
  ├─ dlDimPRIMHDReviewWellnessPlanStatus
  └─ dlDimUser
       └─ ODS view: ETL.fact_client_primhd_service_review
            └─ landing.edw_fact_client_primhd_service_review             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_primhd_service_review      (staging.insert_staging_fact_client_primhd_service_review)
                      └─ edw.fact_client_primhd_service_review           (edw.Updateedwfact_client_primhd_service_review)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_primhd_service_review_key` | `int` | Surrogate primary key | — |
| `primhd_service_review_id` | `int` | Business key | Recordbase |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_referral_id` | `int` | Business key | `edw.dim_client_referral.client_referral_id` |
| `created_by_employee_id` | `nvarchar(50)` | Business key | `edw.dim_employee.employee_id` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_referral_key` | `int` | Dimension foreign key | `edw.dim_client_referral.dim_client_referral_key` |
| `dim_created_by_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_review_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_created_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |

::: mermaid
erDiagram
    dim_client          ||--o{ fact_client_primhd_service_review : "client_id / dim_client_key"
    dim_client_referral ||--o{ fact_client_primhd_service_review : "client_referral_id / dim_client_referral_key"
    dim_employee        ||--o{ fact_client_primhd_service_review : "dim_created_by_employee_key"
    dim_company         ||--o{ fact_client_primhd_service_review : "dim_company_key"
    dim_date            ||--o{ fact_client_primhd_service_review : "review / created date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_primhd_service_review AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_client_referral AS r
    ON fact.client_referral_id = r.client_referral_id
    AND r.DWHIsCurrent = 1
```

## Attributes & Status Fields

- Accommodation status: `accommodation_status_value`, `accommodation_status_text`, `parent_accommodation_status_value`, `parent_accommodation_status_text`.
- Education status: `education_status_value`, `education_status_text`, `parent_education_status_value`, `parent_education_status_text`.
- Employment status: `employment_status_value`, `employment_status_text`, `parent_employment_status_value`, `parent_employment_status_text`.
- Wellness plan status: `wellness_plan_status_value`, `wellness_plan_status_text`, `parent_wellness_plan_status_value`, `parent_wellness_plan_status_text`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_primhd_service_review` |
| Landing | `landing.edw_fact_client_primhd_service_review` |
| Staging | `staging.ODSETLfact_client_primhd_service_review` |
| Stored procedures | `staging.insert_staging_fact_client_primhd_service_review`, `edw.Updateedwfact_client_primhd_service_review` |
| Target | `edw.fact_client_primhd_service_review` |

## Notes

- Loaded as `ODSFLLMRG` (Type 1 non-versioned merge).
- Essential for PRIMHD national collections reporting to Te Whatu Ora / MoH.
