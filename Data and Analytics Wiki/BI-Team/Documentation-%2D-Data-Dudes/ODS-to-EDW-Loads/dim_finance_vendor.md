# dim_finance_vendor

[[_TOC_]]

Business Central Vendor reporting-dimension values used to classify budgets, general-ledger entries, customer-ledger entries and vendor-ledger entries.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `468` |
| Target table | `edw.dim_finance_vendor` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, row-versioned merge |
| Load phase | `101 Dimensions` |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central dimensionValues (dimensionCode = VENDOR)
  └─ ODS view: ETL.dim_finance_vendor
       └─ landing.edw_dim_finance_vendor
            └─ staging.ODSETLdim_finance_vendor
                 └─ edw.dim_finance_vendor
```

Staging also calculates a binary checksum from vendor name and company name to detect descriptive changes.

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_finance_vendor_key` | `int` | Surrogate primary key |
| `finance_vendor_dimension_value_id` | `int` | Business Central dimension-value ID |
| `finance_vendor_code` | `varchar(20)` | Vendor reporting code |
| `finance_vendor_name` | `varchar(100)` | Vendor reporting name; SCD Type 2 attribute |
| `finance_vendor_company_name` | `varchar(50)` | Business Central company scope |
| `finance_vendor_last_modified_date_time` | `datetime2(7)` | Highwater field |

::: mermaid
erDiagram
    dim_finance_vendor ||--o{ fact_finance_budget : "dim_finance_vendor_key"
    dim_finance_vendor ||--o{ fact_finance_general_ledger : "dim_finance_vendor_key"
    dim_finance_vendor ||--o{ fact_finance_customer_ledger : "dim_finance_vendor_key"
    dim_finance_vendor ||--o{ fact_finance_vendor_ledger : "dim_finance_vendor_key"
:::

## Incremental and SCD behavior

`edw.GetHighwaterForedwdim_finance_vendor` returns the maximum target `finance_vendor_last_modified_date_time`.

- Code and timestamp are SCD Type 1 attributes.
- Name changes create a new SCD Type 2 version.
- The merge business key correctly includes both dimension-value ID and company name.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_finance_vendor` |
| Landing | `landing.edw_dim_finance_vendor` |
| Staging | `staging.ODSETLdim_finance_vendor` |
| Procedures | `staging.insert_staging_dim_finance_vendor`, `edw.Updateedwdim_finance_vendor`, `edw.GetHighwaterForedwdim_finance_vendor` |
| Target | `edw.dim_finance_vendor` |

## Notes

### Correct company-scoped business key

Vendor is the only `dimensionValues` finance dimension whose update procedure matches on `(dimension_value_id, company_name)`. It is the pattern the other five should follow if IDs can repeat between companies.

### Reporting dimension versus vendor master

This table is sourced from `dimensionValues`, while `fact_finance_vendor_ledger` also retains `vendor_no`, `vendor_name` and `buy_from_vendor_no` from transactional vendor data. `dim_finance_vendor` is the conformed reporting classification, not necessarily the full operational vendor master.

### Vendor on customer ledger

`fact_finance_customer_ledger` carries a vendor dimension key as part of its dimension set. This can be valid for balancing or attribution, but it should not be interpreted as the customer itself.
