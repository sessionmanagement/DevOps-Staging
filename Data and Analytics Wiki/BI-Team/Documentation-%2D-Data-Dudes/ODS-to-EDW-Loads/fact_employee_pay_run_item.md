# fact_employee_pay_run_item

[[_TOC_]]

Payroll pay run report line items per pay component, hours, total amounts, and cost center breakdown sourced from Datapay.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `760` |
| Target table | `edw.fact_employee_pay_run_item` |
| Load type | `ODSFLLINS` — ODS: Truncated reload |
| Load phase | `200 Facts` |
| Source system | Datapay |

## Data lineage

```text
Datapay
  ├─ pay_runs
  ├─ pay_groups
  ├─ companies
  └─ pay_run_report
       └─ ODS view: ETL.fact_employee_pay_run_item
            └─ landing.edw_fact_employee_pay_run_item             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_pay_run_item      (staging.insert_staging_fact_employee_pay_run_item)
                      └─ edw.fact_employee_pay_run_item           (edw.Updateedwfact_employee_pay_run_item)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_pay_run_item_key` | `int` | Surrogate primary key | — |
| `dim_employee_pay_run_key` | `int` | Dimension foreign key | `edw.dim_employee_pay_run.dim_employee_pay_run_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_employee_pay_component_key` | `int` | Dimension foreign key | `edw.dim_employee_pay_component.dim_employee_pay_component_key` |
| `dim_pay_period_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_pay_period_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `pay_run_id` | `bigint` | Business key | `edw.dim_employee_pay_run.pay_run_id` |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |

::: mermaid
erDiagram
    dim_employee_pay_run       ||--o{ fact_employee_pay_run_item : "pay_run_id / dim_employee_pay_run_key"
    dim_employee               ||--o{ fact_employee_pay_run_item : "employee_id / dim_employee_key"
    dim_company                ||--o{ fact_employee_pay_run_item : "dim_company_key"
    dim_employee_pay_component ||--o{ fact_employee_pay_run_item : "dim_employee_pay_component_key"
    dim_date                   ||--o{ fact_employee_pay_run_item : "start / end date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_pay_run_item AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
INNER JOIN edw.dim_employee_pay_run AS pr
    ON fact.pay_run_id = pr.pay_run_id
    AND pr.DWHIsCurrent = 1
```

## Measures & Attributes

- `hours_amount`: Hours worked on item (`float`).
- `total_amount`: Total monetary amount (`float`).
- Organisational codes: `division_code`, `cost_centre_code`, `department_code`, `sub_department_code`, `department`, `sub_department`, `remuneration_type`, `work_class`, `work_type`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_pay_run_item` |
| Landing | `landing.edw_fact_employee_pay_run_item` |
| Staging | `staging.ODSETLfact_employee_pay_run_item` |
| Stored procedures | `staging.insert_staging_fact_employee_pay_run_item`, `edw.Updateedwfact_employee_pay_run_item` |
| Target | `edw.fact_employee_pay_run_item` |
