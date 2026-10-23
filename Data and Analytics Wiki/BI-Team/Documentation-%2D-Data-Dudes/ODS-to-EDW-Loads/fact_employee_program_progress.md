# fact_employee_program_progress

[[_TOC_]]

Employee learning program progress, completion status, due dates, and paths sourced from Akoranga (Totara / MySQL). Runs in phase `201 Facts`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `625` |
| Target table | `edw.fact_employee_program_progress` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `201 Facts` |
| Source system | Akoranga (Totara / MySQL) |

## Data lineage

```text
Akoranga (Totara / MySQL)
  ├─ mdl_prog
  ├─ mdl_prog_completion
  ├─ mdl_prog_user_assignment
  └─ mdl_user
       └─ ODS view: ETL.fact_employee_program_progress
            └─ landing.edw_fact_employee_program_progress             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_program_progress      (staging.insert_staging_fact_employee_program_progress)
                      └─ edw.fact_employee_program_progress           (edw.Updateedwfact_employee_program_progress)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_program_progress_key` | `int` | Surrogate primary key | — |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_program_key` | `int` | Dimension foreign key | `edw.dim_program.dim_program_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_business_unit_hierarchy_key` | `int` | Dimension foreign key | `edw.dim_business_unit_hierarchy.dim_business_unit_hierarchy_key` |
| `employee_program_id` | `int` | Business key | `edw.dim_program.program_id` |
| `employee_program_progress_user_id` | `nvarchar(200)` | User business key | `edw.dim_employee` |

::: mermaid
erDiagram
    dim_employee                     ||--o{ fact_employee_program_progress : "user_id / dim_employee_key"
    dim_program                      ||--o{ fact_employee_program_progress : "employee_program_id / dim_program_key"
    dim_service                      ||--o{ fact_employee_program_progress : "dim_service_key"
    dim_business_unit_hierarchy      ||--o{ fact_employee_program_progress : "dim_business_unit_hierarchy_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_program_progress AS fact
INNER JOIN edw.dim_program AS p
    ON fact.employee_program_id = p.program_id
    AND p.DWHIsCurrent = 1
```

## Dates & Attributes

- `employee_program_started_date`, `employee_program_due_date`, `employee_program_completed_date`, `employee_program_created_date`, `employee_program_assigned_date` (`datetime2(7)`)
- `employee_program_status` (`int`), `employee_program_path` (`nvarchar(1000)`), `employee_program_depth` (`int`)
- `is_program_delivered_face_to_face_flag` (`int`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_program_progress` |
| Landing | `landing.edw_fact_employee_program_progress` |
| Staging | `staging.ODSETLfact_employee_program_progress` |
| Stored procedures | `staging.insert_staging_fact_employee_program_progress`, `edw.Updateedwfact_employee_program_progress` |
| Target | `edw.fact_employee_program_progress` |
