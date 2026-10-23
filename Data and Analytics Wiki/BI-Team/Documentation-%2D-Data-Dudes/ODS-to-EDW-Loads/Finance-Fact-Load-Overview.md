# Finance Fact Load Overview

[[_TOC_]]

The finance facts are sourced from **Microsoft Dynamics 365 Business Central**. Business Central data is extracted through its REST API, landed by Data Factory, loaded into ODS external tables/dataflows, and exposed to the EDW framework through ODS `ETL.*` views.

This page covers all **4 finance fact loads**. Their seven conformed finance dimensions are documented in [Finance Dimension Load Overview](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Finance-Dimension-Load-Overview).

## Execution order

All four loads run in phase `200 Facts`. `20_Load_Phase` therefore runs them in parallel, subject to the framework limit of 5 concurrent loads. Their finance and organisational dimensions load earlier in phases `101`–`103`.

| DataLoadId | Target table | Source ODS view | Phase |
| --- | --- | --- | --- |
| 513 | [fact_finance_budget](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_finance_budget) | `ETL.fact_finance_budget` | 200 Facts |
| 514 | [fact_finance_customer_ledger](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_finance_customer_ledger) | `ETL.fact_finance_customer_ledger` | 200 Facts |
| 515 | [fact_finance_vendor_ledger](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_finance_vendor_ledger) | `ETL.fact_finance_vendor_ledger` | 200 Facts |
| 516 | [fact_finance_general_ledger](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_finance_general_ledger) | `ETL.fact_finance_general_ledger` | 200 Facts |

All four are configured as `ODSINCHWTMRG` (**incremental by highwater, merged**), but their watermark strategies differ substantially.

## Highwater strategies

| Load | Highwater field | Procedure behaviour | Effective extraction |
| --- | --- | --- | --- |
| Budget (513) | `Last_Date_Modified` | Always returns `1900-01-01` | Effectively full extraction every run |
| Customer ledger (514) | `ODSEffectiveFrom` | Returns target maximum | Strict incremental |
| Vendor ledger (515) | `ODSEffectiveFrom` | Returns target maximum | Strict incremental |
| General ledger (516) | `Last_Modified_DateTime` | Returns target maximum minus one year | Rolling one-year overlap |

The overlap on general ledger allows corrections to older postings to be re-read. The budget procedure is intentionally or accidentally fixed to 1900; this should be reviewed if source volume becomes material.

## Source tables behind the ODS views

| Fact | Business Central source tables |
| --- | --- |
| Budget | `glBudgetEntries`, `dimensionSetEntries` |
| Customer ledger | `customerLedgerEntries`, `dimensionSetEntries`, `dimensionValues` |
| General ledger | `glEntries`, `dimensionSetEntries`, `dimensionValues` |
| Vendor ledger | `vendorLedgerEntries`, `dimensionSetEntries`, `dimensionValues` |

`dimensionSetEntries` pivots Business Central dimensions such as Budget Holder, Contract, Customer, Department, District, Funder, Funding Agency, Location, Region, Service and Vendor onto each transaction.

## Conformed dimensions

The same lookup pattern is reused across all four facts:

::: mermaid
erDiagram
    dim_finance_general_ledger_account ||--o{ finance_facts : "general ledger / balancing account"
    dim_finance_budget_holder          ||--o{ finance_facts : "budget holder"
    dim_finance_contract               ||--o{ finance_facts : "contract"
    dim_finance_customer               ||--o{ finance_facts : "customer (where applicable)"
    dim_department                     ||--o{ finance_facts : "department"
    dim_district                       ||--o{ finance_facts : "district"
    dim_finance_funder                 ||--o{ finance_facts : "funder"
    dim_finance_funding_agency         ||--o{ finance_facts : "funding agency"
    dim_location_new                   ||--o{ finance_facts : "location"
    dim_region                         ||--o{ finance_facts : "region"
    dim_service                        ||--o{ finance_facts : "service"
    dim_finance_vendor                 ||--o{ finance_facts : "vendor"
    dim_company                        ||--o{ finance_facts : "company"
    dim_date                           ||--o{ finance_facts : "role-playing dates"
:::

For reporting queries that use retained `_id` fields, join the fact `_id` directly to the corresponding dimension ID and add only `DWHIsCurrent = 1`. Do not include company in these analytical joins.

```sql
FROM edw.fact_finance_general_ledger AS gl
INNER JOIN edw.dim_department AS department
    ON gl.department_id = department.department_dimension_value_id
    AND department.DWHIsCurrent = 1
```

The EDW load procedures currently use company-qualified lookups when populating the surrogate `dim_*_key` columns. That is ETL implementation detail and is separate from the direct `_id` join convention documented above.

### Default keys

The update procedures use a consistent rule when a dimension lookup fails:

| Source value | Dimension key |
| --- | --- |
| Source business key is absent | `0` — Not Applicable |
| Source business key is present but no current dimension row matches | `-1` — Unknown / data-quality issue |
| Matching current dimension row exists | Its surrogate `dim_*_key` |

## Row identity and merge behaviour

Each fact uses the compound Business Central storage identity:

- `fact_finance_*_partition_key`
- `fact_finance_*_row_key`

The EDW `MERGE` matches on both columns. Although the Framework description says “row-versioned merged,” these target facts do **not** have `DWHEffectiveFrom`, `DWHEffectiveTo` or `DWHIsCurrent`; matched rows are updated in place. They behave as Type 1 transaction facts, with `DWHCreatedAt`, `DWHModifiedOn`, `DWHBatchId` and `DWHDMLOperation` for auditability.

## Reference mappings

Staging normalises Business Central text option values through `reference.EDW_Mapping`:

| Category | Used by | Target field |
| --- | --- | --- |
| `Journal_Source_Type` | General ledger | `finance_general_ledger_source_type` |
| `Journal_Document_Type` | General, customer and vendor ledgers | `*_document_type` |
| `Gen_Posting_Type` | General ledger | `finance_general_ledger_gen_posting_type` |
| `Journal_Account_Type` | Customer and vendor ledgers | `*_bal_account_type` |

Unmapped values become `-1`.

## Known issues and review points

### Budget highwater is fixed to 1900

`edw.GetHighwaterForedwfact_finance_budget` always returns `1900-01-01`; its target-based calculation is commented out. Despite the `ODSINCHWTMRG` configuration, the source is effectively re-read in full.

### Inconsistent highwater windows

Customer and vendor ledger loads use a strict maximum timestamp, while general ledger deliberately overlaps one year. Strict maximum watermarks can miss late corrections when the source modifies a row without advancing the ODS effective timestamp. Confirm that Business Central/ODS guarantees this field changes on every correction.

### Location joins use dim_location_new

The target column is named `dim_location_key`, but all four procedures resolve it against `edw.dim_location_new`, casting the integer source value to `nvarchar` and joining to `business_central_location_id`. Documentation and semantic models should not assume it points to legacy `edw.dim_location`.

### Ledger account meaning varies

Budget and general ledger use the transaction G/L account. Customer and vendor ledgers instead resolve `dim_finance_general_ledger_account_key` from the **balancing account number**. The same dimension key therefore has different business semantics across facts.

### No physical foreign-key constraints

Relationships are populated by ETL but are not enforced as SQL foreign-key constraints. Data quality depends on the `0`/`-1` lookup logic and monitoring of unknown-key counts.

## Verification basis

These pages were checked against the current EDW table DDL, staging procedures, EDW update procedures and highwater procedures in the EDW repository. Source-view lineage comes from the supplied ODS ETL view dependency extract.
