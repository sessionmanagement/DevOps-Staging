# fact_employee_certification_progress

[[_TOC_]]

Employee certification progress, compliance milestones, expiry, and recertification history sourced from Akoranga (Totara / MySQL). Runs in phase `201 Facts`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `646` |
| Target table | `edw.fact_employee_certification_progress` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `201 Facts` |
| Source system | Akoranga (Totara / MySQL) |

## Data lineage

```text
Akoranga (Totara / MySQL)
  ├─ mdl_prog
  ├─ mdl_certif_completion
  ├─ mdl_certif_completion_history
  └─ mdl_user
       └─ ODS view: ETL.fact_employee_certification_progress
            └─ landing.edw_fact_employee_certification_progress             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_certification_progress      (staging.insert_staging_fact_employee_certification_progress)
                      └─ edw.fact_employee_certification_progress           (edw.Updateedwfact_employee_certification_progress)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_certification_progress_key` | `int` | Surrogate primary key | — |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_certification_key` | `int` | Dimension foreign key | `edw.dim_certification.dim_certification_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_business_unit_hierarchy_key` | `int` | Dimension foreign key | `edw.dim_business_unit_hierarchy.dim_business_unit_hierarchy_key` |
| `employee_certification_id` | `int` | Business key | `edw.dim_certification.certification_id` |
| `employee_certification_progress_user_id` | `nvarchar(200)` | User business key | `edw.dim_employee` |

::: mermaid
erDiagram
    dim_employee                     ||--o{ fact_employee_certification_progress : "user_id / dim_employee_key"
    dim_certification                ||--o{ fact_employee_certification_progress : "employee_certification_id / dim_certification_key"
    dim_service                      ||--o{ fact_employee_certification_progress : "dim_service_key"
    dim_business_unit_hierarchy      ||--o{ fact_employee_certification_progress : "dim_business_unit_hierarchy_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_certification_progress AS fact
INNER JOIN edw.dim_certification AS cert
    ON fact.employee_certification_id = cert.certification_id
    AND cert.DWHIsCurrent = 1
```

## Dates & Attributes

- `employee_certification_assigned_date`, `employee_certification_due_date`, `employee_certification_expiry_date`, `employee_certification_window_opens_date`, `employee_certification_completed_date` (`date` / `datetime2(7)`)
- `employee_certification_status` (`int`), `employee_certification_renewal_status` (`int`), `is_recertification` (`int`)
- `is_cerification_delivered_face_to_face_flag` (`int`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_certification_progress` |
| Landing | `landing.edw_fact_employee_certification_progress` |
| Staging | `staging.ODSETLfact_employee_certification_progress` |
| Stored procedures | `staging.insert_staging_fact_employee_certification_progress`, `edw.Updateedwfact_employee_certification_progress` |
| Target | `edw.fact_employee_certification_progress` |
