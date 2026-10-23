# fact_employee_remuneration

[[_TOC_]]

Employee job remuneration, FTE, salary package, pay grade, and turnover history sourced from IntelliHR and ETL mappings. Runs in phase `201 Facts`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `561` |
| Target table | `edw.fact_employee_remuneration` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `201 Facts` |
| Source systems | IntelliHR, ETL |

## Data lineage

```text
IntelliHR (REST API) / ETL
  ├─ jobs
  ├─ locations
  ├─ people_custom_fields
  └─ reference_intelliHR_person_ethnicity
       └─ ODS view: ETL.fact_employee_remuneration
            └─ landing.edw_fact_employee_remuneration             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_remuneration      (staging.insert_staging_fact_employee_remuneration)
                      └─ edw.fact_employee_remuneration           (edw.Updateedwfact_employee_remuneration)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_remuneration_key` | `int` | Surrogate primary key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_location_key` | `int` | Dimension foreign key | `edw.dim_location_new.dim_location_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_ethnicity_key` | `int` | Dimension foreign key | `edw.dim_ethnicity.dim_ethnicity_key` |
| `dim_role_hierarchy_key` | `int` | Dimension foreign key | `edw.dim_employee_hierarchy.dim_employee_hierarchy_key` |
| `dim_people_hierarchy_key` | `int` | Dimension foreign key | `edw.dim_employee_hierarchy.dim_employee_hierarchy_key` |
| `dim_payroll_categories_key` | `int` | Dimension foreign key | `edw.dim_payroll_category.dim_payroll_category_key` |
| `dim_job_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_job_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_position_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_position_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `fact_employee_remuneration_employee_number` | `int` | Business key | `edw.dim_employee.employee_id` |

::: mermaid
erDiagram
    dim_employee               ||--o{ fact_employee_remuneration : "employee_number / dim_employee_key"
    dim_company                ||--o{ fact_employee_remuneration : "dim_company_key"
    dim_location_new           ||--o{ fact_employee_remuneration : "dim_location_key"
    dim_service                ||--o{ fact_employee_remuneration : "dim_service_key"
    dim_ethnicity              ||--o{ fact_employee_remuneration : "dim_ethnicity_key"
    dim_employee_hierarchy     ||--o{ fact_employee_remuneration : "role / people hierarchy keys"
    dim_payroll_category       ||--o{ fact_employee_remuneration : "dim_payroll_categories_key"
    dim_date                   ||--o{ fact_employee_remuneration : "job / position start & end dates"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_remuneration AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.fact_employee_remuneration_employee_number = e.employee_id
    AND e.DWHIsCurrent = 1
```

## Measures

- `fact_employee_remuneration_schedule_annual_package` (`float`)
- `fact_employee_remuneration_schedule_base_annual_salary` (`float`)
- `fact_employee_remuneration_schedule_base_hourly_rate` (`float`)
- `fact_employee_remuneration_schedule_hourly_package` (`float`)
- `fact_employee_remuneration_schedule_hours_per_cycle` (`float`)
- `fact_employee_remuneration_fte` (`float`)
- `fact_employee_remuneration_recruitment_cost` (`float`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_remuneration` |
| Landing | `landing.edw_fact_employee_remuneration` |
| Staging | `staging.ODSETLfact_employee_remuneration` |
| Stored procedures | `staging.insert_staging_fact_employee_remuneration`, `edw.Updateedwfact_employee_remuneration` |
| Target | `edw.fact_employee_remuneration` |
