# fact_employee_hours_worked

[[_TOC_]]

Time & attendance timesheet entries for employee shift hours worked, sourced from Emplive.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `574` |
| Target table | `edw.fact_employee_hours_worked` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source system | Emplive |

## Data lineage

```text
Emplive (SFTP / Zip)
  ├─ time_sheets_entries
  ├─ timesheet_entry_pay_interpretation_time_categories
  ├─ roles
  ├─ services
  ├─ service_names
  ├─ time_categories
  ├─ entities
  └─ employees
       └─ ODS view: ETL.fact_employee_hours_worked
            └─ landing.edw_fact_employee_hours_worked             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_hours_worked      (staging.insert_staging_fact_employee_hours_worked)
                      └─ edw.fact_employee_hours_worked           (edw.Updateedwfact_employee_hours_worked)
```

## Key fields and relationships

### Key columns

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_hours_worked_key` | `int` | Surrogate primary key | — |
| `time_sheet_entry_id` | `nvarchar(36)` | Business key | Emplive |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_ethnicity_key` | `int` | Dimension foreign key | `edw.dim_ethnicity.dim_ethnicity_key` |
| `dim_payroll_category_key` | `int` | Dimension foreign key | `edw.dim_payroll_category.dim_payroll_category_key` |
| `dim_leave_type_key` | `int` | Dimension foreign key | `edw.dim_leave_type.dim_leave_type_key` |
| `dim_shift_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_shift_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_shift_start_time_key` | `int` | Role-playing time FK | `edw.dim_time.dim_time_key` |
| `dim_shift_end_time_key` | `int` | Role-playing time FK | `edw.dim_time.dim_time_key` |

::: mermaid
erDiagram
    dim_employee         ||--o{ fact_employee_hours_worked : "dim_employee_key / employee_number"
    dim_company          ||--o{ fact_employee_hours_worked : "dim_company_key"
    dim_ethnicity        ||--o{ fact_employee_hours_worked : "dim_ethnicity_key"
    dim_payroll_category ||--o{ fact_employee_hours_worked : "dim_payroll_category_key"
    dim_leave_type       ||--o{ fact_employee_hours_worked : "dim_leave_type_key"
    dim_date             ||--o{ fact_employee_hours_worked : "start / end date keys"
    dim_time             ||--o{ fact_employee_hours_worked : "start / end time keys"
:::

## Direct business key join pattern

To join using `employee_id`, match directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_employee_hours_worked AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.fact_hours_worked_employee_number = e.employee_id
    AND e.DWHIsCurrent = 1
```

## Measures & Attributes

- `fact_hours_worked_total_duration`: Total shift hours worked (`real`).
- `fact_hours_worked_approval_status`: Approval status (`nvarchar(100)`).
- `fact_hours_worked_role`: Shift role name (`nvarchar(100)`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_hours_worked` |
| Landing | `landing.edw_fact_employee_hours_worked` |
| Staging | `staging.ODSETLfact_employee_hours_worked` |
| Stored procedures | `staging.insert_staging_fact_employee_hours_worked`, `edw.Updateedwfact_employee_hours_worked` |
| Target | `edw.fact_employee_hours_worked` |
