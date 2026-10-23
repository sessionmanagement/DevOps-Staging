# fact_employee_pay_slip_item

[[_TOC_]]

Detailed itemized entries (gross, deduction, net line items) for employee pay slips, sourced from Datapay.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `759` |
| Target table | `edw.fact_employee_pay_slip_item` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source system | Datapay |

## Data lineage

```text
Datapay
  ├─ pay_slips_gross
  ├─ pay_slips_deductions
  ├─ pay_slips_net
  ├─ employees
  └─ companies
       └─ ODS view: ETL.fact_employee_pay_slip_item
            └─ landing.edw_fact_employee_pay_slip_item             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_pay_slip_item      (staging.insert_staging_fact_employee_pay_slip_item)
                      └─ edw.fact_employee_pay_slip_item           (edw.Updateedwfact_employee_pay_slip_item)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_pay_slip_item_key` | `int` | Surrogate primary key | — |
| `dim_employee_pay_slip_key` | `int` | Dimension foreign key | `edw.dim_employee_pay_slip.dim_employee_pay_slip_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `pay_packet_id` | `int` | Business key | `edw.dim_employee_pay_slip.pay_packet_id` |
| `pay_packet_row_id` | `nvarchar(4000)` | Line item business key | Datapay |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |

::: mermaid
erDiagram
    dim_employee_pay_slip ||--o{ fact_employee_pay_slip_item : "pay_packet_id / dim_employee_pay_slip_key"
    dim_employee          ||--o{ fact_employee_pay_slip_item : "employee_id / dim_employee_key"
    dim_company           ||--o{ fact_employee_pay_slip_item : "dim_company_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_pay_slip_item AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
INNER JOIN edw.dim_employee_pay_slip AS ps
    ON fact.pay_packet_id = ps.pay_packet_id
    AND ps.DWHIsCurrent = 1
```

## Measures & Attributes

- `item_type`: Item category (`varchar(9)` — e.g. Gross, Deduction, Net).
- `item_amount`: Monetary amount (`float`).
- `item_type_detail`: Detailed description (`nvarchar(100)`).
- `item_summary`: Summary text (`nvarchar(4000)`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_pay_slip_item` |
| Landing | `landing.edw_fact_employee_pay_slip_item` |
| Staging | `staging.ODSETLfact_employee_pay_slip_item` |
| Stored procedures | `staging.insert_staging_fact_employee_pay_slip_item`, `edw.Updateedwfact_employee_pay_slip_item` |
| Target | `edw.fact_employee_pay_slip_item` |
