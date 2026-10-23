# dim_finance_contract

[[_TOC_]]

Business Central Contract reporting-dimension values, used to attribute budgets and transactions to funding or service contracts.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `472` |
| Target table | `edw.dim_finance_contract` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, row-versioned merge |
| Load phase | `101 Dimensions` |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central dimensionValues (dimensionCode = CONTRACT)
  └─ ODS view: ETL.dim_finance_contract
       └─ landing.edw_dim_finance_contract
            └─ staging.ODSETLdim_finance_contract
                 └─ edw.dim_finance_contract
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_finance_contract_key` | `int` | Surrogate primary key |
| `finance_contract_dimension_value_id` | `int` | Business Central dimension-value ID |
| `finance_contract_code` | `varchar(20)` | Contract code |
| `finance_contract_name` | `varchar(100)` | Contract name; SCD Type 2 attribute |
| `finance_contract_company_name` | `varchar(50)` | Business Central company scope |
| `finance_contract_last_modified_date_time` | `datetime2(7)` | Highwater field |

::: mermaid
erDiagram
    dim_finance_contract ||--o{ fact_finance_budget : "dim_finance_contract_key"
    dim_finance_contract ||--o{ fact_finance_general_ledger : "dim_finance_contract_key"
    dim_finance_contract ||--o{ fact_finance_customer_ledger : "dim_finance_contract_key"
    dim_finance_contract ||--o{ fact_finance_vendor_ledger : "dim_finance_contract_key"
:::

## Incremental and SCD behavior

`edw.GetHighwaterForedwdim_finance_contract` returns the maximum target `finance_contract_last_modified_date_time`.

- Code, company and timestamp are SCD Type 1 attributes.
- Name is SCD Type 2.
- Facts resolve the current contract using dimension-value ID and company name.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_finance_contract` |
| Landing | `landing.edw_dim_finance_contract` |
| Staging | `staging.ODSETLdim_finance_contract` |
| Procedures | `staging.insert_staging_dim_finance_contract`, `edw.Updateedwdim_finance_contract`, `edw.GetHighwaterForedwdim_finance_contract` |
| Target | `edw.dim_finance_contract` |

## Notes

### Merge key is not company-scoped

The update procedure matches on `finance_contract_dimension_value_id` only; finance facts join on ID plus company. Include company in the merge business key unless the source ID is proven globally unique.

### Reporting dimension, not contract master

The table contains Business Central dimension values rather than a dedicated contract master. It supports financial attribution but may not hold operational contract dates, terms, funders or owners.
