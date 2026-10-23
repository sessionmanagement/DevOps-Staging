# fact_employee_course_progress

[[_TOC_]]

Employee course progress, completion status, grades, and renewal metrics sourced from Akoranga (Totara / MySQL). Runs in phase `201 Facts`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `645` |
| Target table | `edw.fact_employee_course_progress` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `201 Facts` |
| Source system | Akoranga (Totara / MySQL) |

## Data lineage

```text
Akoranga (Totara / MySQL)
  ├─ mdl_course
  ├─ mdl_course_completions
  ├─ mdl_user
  ├─ mdl_grade_grades
  └─ mdl_user_enrolments
       └─ ODS view: ETL.fact_employee_course_progress
            └─ landing.edw_fact_employee_course_progress             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_course_progress      (staging.insert_staging_fact_employee_course_progress)
                      └─ edw.fact_employee_course_progress           (edw.Updateedwfact_employee_course_progress)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_course_progress_key` | `int` | Surrogate primary key | — |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_course_key` | `int` | Dimension foreign key | `edw.dim_course.dim_course_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_business_unit_hierarchy_key` | `int` | Dimension foreign key | `edw.dim_business_unit_hierarchy.dim_business_unit_hierarchy_key` |
| `employee_course_id` | `int` | Business key | `edw.dim_course.course_id` |
| `employee_course_progress_user_id` | `nvarchar(100)` | User business key | `edw.dim_employee` |

::: mermaid
erDiagram
    dim_employee                     ||--o{ fact_employee_course_progress : "user_id / dim_employee_key"
    dim_course                       ||--o{ fact_employee_course_progress : "employee_course_id / dim_course_key"
    dim_service                      ||--o{ fact_employee_course_progress : "dim_service_key"
    dim_business_unit_hierarchy      ||--o{ fact_employee_course_progress : "dim_business_unit_hierarchy_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_course_progress AS fact
INNER JOIN edw.dim_course AS c
    ON fact.employee_course_id = c.course_id
    AND c.DWHIsCurrent = 1
```

## Dates & Measures

- `employee_course_enrolled_date`, `employee_course_started_date`, `employee_course_completed_date`, `employee_course_due_date` (`datetime`)
- `employee_course_completion_percentage` (`int`), `employee_course_completion_grade` (`numeric(38,18)`)
- Flags: `is_course_delivered_face_to_face_flag`, `is_course_core_training_flag`, `is_course_linked_to_certification_flag`

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_course_progress` |
| Landing | `landing.edw_fact_employee_course_progress` |
| Staging | `staging.ODSETLfact_employee_course_progress` |
| Stored procedures | `staging.insert_staging_fact_employee_course_progress`, `edw.Updateedwfact_employee_course_progress` |
| Target | `edw.fact_employee_course_progress` |
