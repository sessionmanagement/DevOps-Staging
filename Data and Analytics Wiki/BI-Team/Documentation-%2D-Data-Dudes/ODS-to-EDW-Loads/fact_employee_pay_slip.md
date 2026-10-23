# fact_employee_pay_slip

[[_TOC_]]

Payroll pay packet / pay slip summary totals (gross, deduction, net amounts) per employee pay slip sourced from Datapay.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `758` |
| Target table | `edw.fact_employee_pay_slip` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source system | Datapay |

## Data lineage

```text
Datapay
  ├─ employees
  ├─ companies
  └─ pay_slips
       └─ ODS view: ETL.fact_employee_pay_slip
            └─ landing.edw_fact_employee_pay_slip             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_pay_slip      (staging.insert_staging_fact_employee_pay_slip)
                      └─ edw.fact_employee_pay_slip           (edw.Updateedwfact_employee_pay_slip)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_pay_slip_key` | `int` | Surrogate primary key | — |
| `dim_employee_pay_slip_key` | `int` | Dimension foreign key | `edw.dim_employee_pay_slip.dim_employee_pay_slip_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_pay_run_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_pay_period_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_pay_period_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `pay_packet_id` | `int` | Business key | `edw.dim_employee_pay_slip.pay_packet_id` |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |

::: mermaid
erDiagram
    dim_employee_pay_slip ||--o{ fact_employee_pay_slip : "pay_packet_id / dim_employee_pay_slip_key"
    dim_employee          ||--o{ fact_employee_pay_slip : "employee_id / dim_employee_key"
    dim_company           ||--o{ fact_employee_pay_slip : "dim_company_key"
    dim_date              ||--o{ fact_employee_pay_slip : "run / start / end date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_pay_slip AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
INNER JOIN edw.dim_employee_pay_slip AS ps
    ON fact.pay_packet_id = ps.pay_packet_id
    AND ps.DWHIsCurrent = 1
```

## Measures

- `gross_total_amount` (`float`)
- `deduction_total_amount` (`float`)
- `net_total_amount` (`float`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_pay_slip` |
| Landing | `landing.edw_fact_employee_pay_slip` |
| Staging | `staging.ODSETLfact_employee_pay_slip` |
| Stored procedures | `staging.insert_staging_fact_employee_pay_slip`, `edw.Updateedwfact_employee_pay_slip` |
| Target | `edw.fact_employee_pay_slip` |
