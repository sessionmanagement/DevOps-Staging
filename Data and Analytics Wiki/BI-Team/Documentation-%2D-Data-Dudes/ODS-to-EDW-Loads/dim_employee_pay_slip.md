# dim_employee_pay_slip

[[_TOC_]]

Payroll pay packet / pay slip header dimension sourced from Datapay.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `755` |
| Target table | `edw.dim_employee_pay_slip` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Datapay |

## Data lineage

```text
Datapay
  ├─ companies
  └─ pay_slips
       └─ ODS view: ETL.dim_employee_pay_slip
            └─ landing.edw_dim_employee_pay_slip             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_employee_pay_slip      (staging.insert_staging_dim_employee_pay_slip)
                      └─ edw.dim_employee_pay_slip           (edw.Updateedwdim_employee_pay_slip)
```

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_employee_pay_slip_key` | `int` | Surrogate primary key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_company_key_pay_packet_id_key` | `bigint` | Compound business key | — |
| `pay_packet_id` | `int` | Datapay pay packet ID | — |
| `pay_packet_type` | `nvarchar(50)` | Pay packet type | — |
| `pay_run_date` | `date` | Pay run date | — |
| `pay_period_start_date` | `date` | Pay period start date | — |
| `pay_period_end_date` | `date` | Pay period end date | — |

::: mermaid
erDiagram
    dim_company ||--o{ dim_employee_pay_slip : "dim_company_key"
    dim_employee_pay_slip ||--o{ fact_employee_pay_slip : "dim_employee_pay_slip_key"
    dim_employee_pay_slip ||--o{ fact_employee_pay_slip_item : "dim_employee_pay_slip_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_pay_slip AS fact
INNER JOIN edw.dim_employee_pay_slip AS ps
    ON fact.pay_packet_id = ps.pay_packet_id
    AND ps.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee_pay_slip` |
| Landing | `landing.edw_dim_employee_pay_slip` |
| Staging | `staging.ODSETLdim_employee_pay_slip` |
| Stored procedures | `staging.insert_staging_dim_employee_pay_slip`, `edw.Updateedwdim_employee_pay_slip` |
| Target | `edw.dim_employee_pay_slip` |
