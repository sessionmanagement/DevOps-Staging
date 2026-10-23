# dim_employee_pay_component

[[_TOC_]]

Payroll pay component classification dimension sourced from Datapay.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `757` |
| Target table | `edw.dim_employee_pay_component` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Datapay |

## Data lineage

```text
Datapay
  ├─ pay_run_report
  ├─ pay_groups
  ├─ companies
  ├─ pay_runs
  └─ components
       └─ ODS view: ETL.dim_employee_pay_component
            └─ landing.edw_dim_employee_pay_component             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_pay_component      (staging.insert_staging_dim_employee_pay_component)
                      └─ edw.dim_employee_pay_component           (edw.Updateedwdim_employee_pay_component)
```

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_employee_pay_component_key` | `int` | Surrogate primary key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_company_key_pay_component_key` | `nvarchar(100)` | Compound business key | — |
| `pay_component_code` | `nvarchar(50)` | Pay component code | — |
| `pay_component_name` | `nvarchar(100)` | Pay component description | — |
| `pay_component_category` | `nvarchar(50)` | Category (e.g. Earnings, Allowance, Deduction) | — |
| `company_code` | `int` | Datapay company ID | — |

::: mermaid
erDiagram
    dim_company ||--o{ dim_employee_pay_component : "dim_company_key"
    dim_employee_pay_component ||--o{ fact_employee_pay_run_item : "dim_employee_pay_component_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_pay_component` |
| Landing | `landing.edw_dim_employee_pay_component` |
| Staging | `staging.ODSETLdim_employee_pay_component` |
| Stored procedures | `staging.insert_staging_dim_employee_pay_component`, `edw.Updateedwdim_employee_pay_component` |
| Target | `edw.dim_employee_pay_component` |
