# dim_finance_customer

[[_TOC_]]

Business Central Customer reporting-dimension values used to classify budgets, general-ledger entries and customer-ledger entries.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `475` |
| Target table | `edw.dim_finance_customer` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, row-versioned merge |
| Load phase | `101 Dimensions` |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central dimensionValues (dimensionCode = CUSTOMER)
  └─ ODS view: ETL.dim_finance_customer
       └─ landing.edw_dim_finance_customer
            └─ staging.ODSETLdim_finance_customer
                 └─ edw.dim_finance_customer
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_finance_customer_key` | `int` | Surrogate primary key |
| `finance_customer_dimension_value_id` | `int` | Business Central dimension-value ID |
| `finance_customer_code` | `varchar(20)` | Customer reporting code |
| `finance_customer_name` | `varchar(100)` | Customer reporting name; SCD Type 2 attribute |
| `finance_customer_company_name` | `varchar(50)` | Business Central company scope |
| `finance_customer_last_modified_date_time` | `datetime2(7)` | Highwater field |

::: mermaid
erDiagram
    dim_finance_customer ||--o{ fact_finance_budget : "dim_finance_customer_key"
    dim_finance_customer ||--o{ fact_finance_general_ledger : "dim_finance_customer_key"
    dim_finance_customer ||--o{ fact_finance_customer_ledger : "dim_finance_customer_key"
:::

`fact_finance_vendor_ledger` does not contain a customer key.

## Incremental and SCD behavior

`edw.GetHighwaterForedwdim_finance_customer` returns the maximum target `finance_customer_last_modified_date_time`.

- Code, company and timestamp are updated in place.
- Name changes create a new SCD Type 2 version.
- Facts resolve the current customer using dimension-value ID and company name.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_finance_customer` |
| Landing | `landing.edw_dim_finance_customer` |
| Staging | `staging.ODSETLdim_finance_customer` |
| Procedures | `staging.insert_staging_dim_finance_customer`, `edw.Updateedwdim_finance_customer`, `edw.GetHighwaterForedwdim_finance_customer` |
| Target | `edw.dim_finance_customer` |

## Notes

### Merge key is not company-scoped

The update procedure matches on `finance_customer_dimension_value_id` only; facts join on ID plus company. Include company in the SCD business key unless global uniqueness is proven.

### Not the operational customer master

This dimension comes from `dimensionValues`, not `customerLedgerEntries` or a Business Central customer master. `finance_customer_code` may differ from the transaction fields `finance_customer_ledger_customer_no` and `sell_to_customer_no`; use `dim_finance_customer_key` for conformed reporting.
