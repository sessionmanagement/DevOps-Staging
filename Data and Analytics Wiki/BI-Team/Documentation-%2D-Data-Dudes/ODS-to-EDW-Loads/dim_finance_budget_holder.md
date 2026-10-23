# dim_finance_budget_holder

[[_TOC_]]

Business Central Budget Holder reporting-dimension values, used to assign finance entries and budgets to the person or role accountable for them.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `471` |
| Target table | `edw.dim_finance_budget_holder` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, row-versioned merge |
| Load phase | `101 Dimensions` |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central dimensionValues (dimensionCode = BUDGET HOLDER)
  └─ ODS view: ETL.dim_finance_budget_holder
       └─ landing.edw_dim_finance_budget_holder
            └─ staging.ODSETLdim_finance_budget_holder
                 └─ edw.dim_finance_budget_holder
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_finance_budget_holder_key` | `int` | Surrogate primary key |
| `finance_budget_holder_dimension_value_id` | `int` | Business Central dimension-value ID |
| `finance_budget_holder_code` | `varchar(20)` | Business-facing code |
| `finance_budget_holder_name` | `varchar(100)` | Name; SCD Type 2 attribute |
| `finance_budget_holder_company_name` | `varchar(50)` | Business Central company scope |
| `finance_budget_holder_last_modified_date_time` | `datetime2(7)` | Highwater field |

::: mermaid
erDiagram
    dim_finance_budget_holder ||--o{ fact_finance_budget : "dim_finance_budget_holder_key"
    dim_finance_budget_holder ||--o{ fact_finance_general_ledger : "dim_finance_budget_holder_key"
    dim_finance_budget_holder ||--o{ fact_finance_customer_ledger : "dim_finance_budget_holder_key"
    dim_finance_budget_holder ||--o{ fact_finance_vendor_ledger : "dim_finance_budget_holder_key"
:::

## Incremental and SCD behavior

`edw.GetHighwaterForedwdim_finance_budget_holder` returns the maximum `finance_budget_holder_last_modified_date_time` from the target.

- Code, company and timestamp changes are updated in place.
- Name changes close the current row and insert a new current row.
- Facts resolve the dimension by `(finance_budget_holder_dimension_value_id, company_name)` and current status.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_finance_budget_holder` |
| Landing | `landing.edw_dim_finance_budget_holder` |
| Staging | `staging.ODSETLdim_finance_budget_holder` |
| Procedures | `staging.insert_staging_dim_finance_budget_holder`, `edw.Updateedwdim_finance_budget_holder`, `edw.GetHighwaterForedwdim_finance_budget_holder` |
| Target | `edw.dim_finance_budget_holder` |

## Notes

### Merge key is not company-scoped

The update procedure matches current rows using `finance_budget_holder_dimension_value_id` only, while facts join using ID and company. If IDs repeat across Business Central companies, records can be cross-updated or incorrectly versioned. The merge key should include `finance_budget_holder_company_name` unless global uniqueness is proven.

### Person or role, not employee

There is no `dim_employee_key`. Budget-holder values are reporting classifications, not necessarily employee records, so HR analysis requires a separate mapping.
