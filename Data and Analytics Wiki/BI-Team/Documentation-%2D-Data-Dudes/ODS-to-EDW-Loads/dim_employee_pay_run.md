# dim_employee_pay_run

[[_TOC_]]

Payroll pay run header dimension sourced from Datapay.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `756` |
| Target table | `edw.dim_employee_pay_run` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Datapay |

## Data lineage

```text
Datapay
  ├─ pay_runs
  ├─ companies
  └─ pay_groups
       └─ ODS view: ETL.dim_employee_pay_run
            └─ landing.edw_dim_employee_pay_run             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_pay_run      (staging.insert_staging_dim_employee_pay_run)
                      └─ edw.dim_employee_pay_run           (edw.Updateedwdim_employee_pay_run)
```

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_employee_pay_run_key` | `int` | Surrogate primary key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_company_key_pay_run_id_key` | `bigint` | Compound business key | — |
| `pay_run_id` | `int` | Datapay pay run ID | — |
| `pay_run_type` | `nvarchar(50)` | Pay run type | — |
| `pay_run_status` | `nvarchar(20)` | Pay run status | — |
| `pay_run_date` | `date` | Pay run date | — |
| `pay_period_start_date` | `date` | Pay period start date | — |
| `pay_period_end_date` | `date` | Pay period end date | — |

::: mermaid
erDiagram
    dim_company ||--o{ dim_employee_pay_run : "dim_company_key"
    dim_employee_pay_run ||--o{ fact_employee_pay_run_item : "dim_employee_pay_run_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_pay_run_item AS fact
INNER JOIN edw.dim_employee_pay_run AS r
    ON fact.pay_run_id = r.pay_run_id
    AND r.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_pay_run` |
| Landing | `landing.edw_dim_employee_pay_run` |
| Staging | `staging.ODSETLdim_employee_pay_run` |
| Stored procedures | `staging.insert_staging_dim_employee_pay_run`, `edw.Updateedwdim_employee_pay_run` |
| Target | `edw.dim_employee_pay_run` |
