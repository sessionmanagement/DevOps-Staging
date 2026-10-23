# Finance Dimension Load Overview

[[_TOC_]]

The seven finance dimensions are sourced from **Microsoft Dynamics 365 Business Central** and provide the conformed account, customer, vendor, funding and contract classifications used by all four finance facts.

## Execution order

All seven dimensions run in phase `101 Dimensions`, before the finance facts in phase `200 Facts`. `20_Load_Phase` runs loads within the phase in parallel, up to 5 at once.

| DataLoadId | Target table | Source | Load type |
| --- | --- | --- | --- |
| 466 | [dim_finance_general_ledger_account](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_finance_general_ledger_account) | `glAccounts` | Full row-versioned merge |
| 468 | [dim_finance_vendor](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_finance_vendor) | `dimensionValues` (`VENDOR`) | Incremental highwater merge |
| 469 | [dim_finance_funding_agency](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_finance_funding_agency) | `dimensionValues` (`FUNDING AGENCY`) | Incremental highwater merge |
| 471 | [dim_finance_budget_holder](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_finance_budget_holder) | `dimensionValues` (`BUDGET HOLDER`) | Incremental highwater merge |
| 472 | [dim_finance_contract](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_finance_contract) | `dimensionValues` (`CONTRACT`) | Incremental highwater merge |
| 475 | [dim_finance_customer](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_finance_customer) | `dimensionValues` (`CUSTOMER`) | Incremental highwater merge |
| 476 | [dim_finance_funder](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_finance_funder) | `dimensionValues` (`FUNDER`) | Incremental highwater merge |

The `dimensionValues` discriminator is applied in the ODS view; the staging procedures receive only rows for their own finance dimension.

## Shared dimensionValues pattern

Six dimensions have the same shape:

| Column pattern | Purpose |
| --- | --- |
| `dim_finance_*_key` | EDW surrogate key |
| `finance_*_dimension_value_id` | Business Central dimension-value ID |
| `finance_*_code` | Business-facing dimension code |
| `finance_*_name` | Description; treated as SCD Type 2 |
| `finance_*_company_name` | Business Central company scope |
| `finance_*_last_modified_date_time` | Incremental watermark source |
| Standard DWH columns | Batch, operation and SCD effective/current tracking |

Each highwater procedure returns the maximum target `last_modified_date_time`. New and changed source rows are extracted incrementally.

### SCD behavior

For the six `dimensionValues` dimensions:

- Code, company name and last-modified timestamp are updated in place as SCD Type 1 attributes.
- A name change closes the current row and inserts a new current row (SCD Type 2).
- Keys `0` (N/A) and `-1` (Unknown) are seeded by the EDW procedure.

## G/L account pattern

The G/L account dimension differs:

- Full load from `glAccounts`; there is no highwater procedure.
- Business key is `(company_name, account_code)`.
- Staging recursively constructs a company-specific hierarchy of up to six levels.
- Known source hierarchy exceptions for accounts `1000`, `1001`, `2000`, `2999`, `3000`, `3001`, `4000` and `5000` are hard-coded before recursion.
- Missing source accounts are soft-deleted/versioned out.

## Relationships to finance facts

::: mermaid
erDiagram
    dim_finance_general_ledger_account ||--o{ fact_finance_budget : "G/L account"
    dim_finance_general_ledger_account ||--o{ fact_finance_general_ledger : "G/L account"
    dim_finance_general_ledger_account ||--o{ fact_finance_customer_ledger : "balancing account"
    dim_finance_general_ledger_account ||--o{ fact_finance_vendor_ledger : "balancing account"
    dim_finance_customer ||--o{ fact_finance_budget : "customer"
    dim_finance_customer ||--o{ fact_finance_general_ledger : "customer"
    dim_finance_customer ||--o{ fact_finance_customer_ledger : "customer"
    dim_finance_vendor ||--o{ fact_finance_budget : "vendor"
    dim_finance_vendor ||--o{ fact_finance_general_ledger : "vendor"
    dim_finance_vendor ||--o{ fact_finance_customer_ledger : "vendor"
    dim_finance_vendor ||--o{ fact_finance_vendor_ledger : "vendor"
:::

Budget holder, contract, funder and funding agency each relate to all four finance facts.

## Business-key and company scoping

Finance facts resolve each dimension using the source ID/code **and Business Central company name**, with `DWHIsCurrent = 1`. Company scoping is necessary because Business Central dimension values are company-specific.

However, the dimension merge procedures are inconsistent:

| Dimension | Merge business key |
| --- | --- |
| Vendor | `(dimension_value_id, company_name)` |
| G/L account | `(company_name, account_code)` |
| Budget holder, contract, customer, funder, funding agency | `dimension_value_id` only |

If `dimension_value_id` can repeat between companies, the five ID-only merges can update or version the wrong company row. This should be tested against current data and corrected to include company name if IDs are not globally unique.

## Known issues and review points

### IDs start at zero

All seven surrogate keys use `IDENTITY(0,1)` while the procedures also seed explicit `0` and `-1` rows using `IDENTITY_INSERT`. Verify identity reseeding after first deployment so generated business rows do not collide with the special members.

### DWHIsCurrent type inconsistency

The six `dimensionValues` dimensions define `DWHIsCurrent` as `INT`; G/L account uses `BIT`. Both are consumed as boolean values, but this differs from the EDW standard (`BIT`).

### Source strings are non-Unicode on six dimensions

Code, name and company columns use `VARCHAR` on the six `dimensionValues` dimensions, while G/L account uses `NVARCHAR`. This is inconsistent with the Unicode standard and may matter if Business Central names contain Māori characters.

### Hard-coded G/L hierarchy exceptions

Eight account-parent overrides are embedded in `staging.insert_staging_dim_finance_general_ledger_account`. Any chart-of-accounts change affecting these nodes requires a code deployment rather than a metadata change.

### Dimension code versus customer/vendor master

`dim_finance_customer` and `dim_finance_vendor` are built from `dimensionValues`, not directly from Business Central customer/vendor master tables. They represent reporting-dimension values and may not contain every operational customer or vendor.

## Verification basis

Checked against Framework load metadata, ODS ETL view lineage, EDW table DDL, staging procedures, update procedures and highwater procedures in the EDW repository.
