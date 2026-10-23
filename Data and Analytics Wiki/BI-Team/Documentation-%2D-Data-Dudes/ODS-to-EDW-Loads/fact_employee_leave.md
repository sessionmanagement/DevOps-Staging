# fact_employee_leave

[[_TOC_]]

Employee leave balances, entitlement, accruals, and taken units sourced from Datapay and IntelliHR.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `566` |
| Target table | `edw.fact_employee_leave` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Datapay, IntelliHR |

## Data lineage

```text
Datapay / IntelliHR
  ├─ employees
  ├─ companies
  ├─ leave_balances
  ├─ cost_structures
  ├─ leave_types
  ├─ people_custom_fields
  └─ people
       └─ ODS view: ETL.fact_employee_leave
            └─ landing.edw_fact_employee_leave             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_leave      (staging.insert_staging_fact_employee_leave)
                      └─ edw.fact_employee_leave           (edw.Updateedwfact_employee_leave)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_leave_key` | `int` | Surrogate primary key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_business_unit_hierarchy_key` | `int` | Dimension foreign key | `edw.dim_business_unit_hierarchy.dim_business_unit_hierarchy_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_leave_type_key` | `int` | Dimension foreign key | `edw.dim_leave_type.dim_leave_type_key` |
| `dim_ethnicity_key` | `int` | Dimension foreign key | `edw.dim_ethnicity.dim_ethnicity_key` |
| `dim_payroll_category_key` | `int` | Dimension foreign key | `edw.dim_payroll_category.dim_payroll_category_key` |
| `employee_leave_effective_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `employee_leave_anniversary_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |
| `leave_type_id` | `nvarchar(50)` | Business key | `edw.dim_leave_type.leave_type_id` |

::: mermaid
erDiagram
    dim_employee                     ||--o{ fact_employee_leave : "employee_id / dim_employee_key"
    dim_company                      ||--o{ fact_employee_leave : "dim_company_key"
    dim_business_unit_hierarchy      ||--o{ fact_employee_leave : "dim_business_unit_hierarchy_key"
    dim_leave_type                   ||--o{ fact_employee_leave : "leave_type_id / dim_leave_type_key"
    dim_ethnicity                    ||--o{ fact_employee_leave : "dim_ethnicity_key"
    dim_payroll_category             ||--o{ fact_employee_leave : "dim_payroll_category_key"
    dim_date                         ||--o{ fact_employee_leave : "effective / anniversary dates"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_leave AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
INNER JOIN edw.dim_leave_type AS lt
    ON fact.leave_type_id = lt.leave_type_id
    AND lt.DWHIsCurrent = 1
```

## Measures

- `employee_leave_entitlement`, `employee_leave_accrual`, `employee_leave_taken`, `employee_leave_balance` (`real`)
- `employee_leave_entitlement_hours`, `employee_leave_accrual_hours`, `employee_leave_taken_hours`, `employee_leave_balance_hours`, `employee_leave_next_entitlement_hours` (`real`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_leave` |
| Landing | `landing.edw_fact_employee_leave` |
| Staging | `staging.ODSETLfact_employee_leave` |
| Stored procedures | `staging.insert_staging_fact_employee_leave`, `edw.Updateedwfact_employee_leave` |
| Target | `edw.fact_employee_leave` |
