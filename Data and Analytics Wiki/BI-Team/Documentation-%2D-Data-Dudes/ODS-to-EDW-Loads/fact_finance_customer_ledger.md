# fact_finance_customer_ledger

[[_TOC_]]

Business Central customer-ledger entries — invoices, payments, credits, remaining balances and settlement details for receivables. The grain is one customer-ledger entry per company and Business Central storage row.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `514` |
| Target table | `edw.fact_finance_customer_ledger` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| Actual target behaviour | In-place merge; no SCD effective/current columns |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central REST API
  ├─ customerLedgerEntries
  ├─ dimensionSetEntries
  └─ dimensionValues
       └─ ODS view: ETL.fact_finance_customer_ledger
            └─ landing.edw_fact_finance_customer_ledger
                 └─ staging.ODSETLfact_finance_customer_ledger
                      └─ edw.fact_finance_customer_ledger
```

Staging preserves Business Central document, due and posting dates; the EDW update resolves them to the three integer date keys on the target. Document and balancing-account types are normalized through `reference.EDW_Mapping`.

## Key fields and relationships

### Row identity

| Column | Type | Role |
| --- | --- | --- |
| `fact_finance_customer_ledger_key` | `int` | Surrogate primary key, identity starting at 100000 |
| `fact_finance_customer_ledger_partition_key` | `nvarchar(129)` | Business Central partition component |
| `fact_finance_customer_ledger_row_key` | `nvarchar(107)` | Business Central row component; MERGE key with partition |
| `finance_customer_ledger_entry_no` | `int` | Customer-ledger entry number |
| `finance_customer_ledger_transaction_no` | `int` | Business Central transaction number |
| `finance_customer_ledger_document_no` | `nvarchar(111)` | Degenerate document reference |
| `finance_customer_ledger_dimension_set_id` | `int` | Business Central dimension-set reference |

### Dimension relationships

To join using an `_id`, match it directly to the dimension's corresponding `_id` and filter the SCD2 dimension to `DWHIsCurrent = 1`. Do not add company to the join.

| Fact `_id` | Join to dimension column | Required filter |
| --- | --- | --- |
| `finance_customer_ledger_customer_id` | `edw.dim_finance_customer.finance_customer_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_budget_holder_id` | `edw.dim_finance_budget_holder.finance_budget_holder_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_contract_id` | `edw.dim_finance_contract.finance_contract_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_department_id` | `edw.dim_department.department_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_district_id` | `edw.dim_district.district_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_funder_id` | `edw.dim_finance_funder.finance_funder_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_funding_agency_id` | `edw.dim_finance_funding_agency.finance_funding_agency_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_location_id` | `edw.dim_location_new.business_central_location_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_region_id` | `edw.dim_region.region_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_service_id` | `edw.dim_service.service_id` | `DWHIsCurrent = 1` |
| `finance_customer_ledger_vendor_id` | `edw.dim_finance_vendor.finance_vendor_dimension_value_id` | `DWHIsCurrent = 1` |

The balancing G/L account, company and date relationships do not use retained `_id` fields.

```sql
FROM edw.fact_finance_customer_ledger AS customer_ledger
INNER JOIN edw.dim_department AS department
     ON customer_ledger.finance_customer_ledger_department_id = department.department_dimension_value_id
     AND department.DWHIsCurrent = 1
```

::: mermaid
erDiagram
    dim_finance_general_ledger_account ||--o{ fact_finance_customer_ledger : "balancing account"
    dim_finance_customer               ||--o{ fact_finance_customer_ledger : "customer"
    dim_finance_budget_holder          ||--o{ fact_finance_customer_ledger : "budget holder"
    dim_finance_contract               ||--o{ fact_finance_customer_ledger : "contract"
    dim_department                     ||--o{ fact_finance_customer_ledger : "department"
    dim_district                       ||--o{ fact_finance_customer_ledger : "district"
    dim_finance_funder                 ||--o{ fact_finance_customer_ledger : "funder"
    dim_finance_funding_agency         ||--o{ fact_finance_customer_ledger : "funding agency"
    dim_location_new                   ||--o{ fact_finance_customer_ledger : "location"
    dim_region                         ||--o{ fact_finance_customer_ledger : "region"
    dim_service                        ||--o{ fact_finance_customer_ledger : "service"
    dim_finance_vendor                 ||--o{ fact_finance_customer_ledger : "vendor"
    dim_company                        ||--o{ fact_finance_customer_ledger : "company"
    dim_date                           ||--o{ fact_finance_customer_ledger : "document + posting + due dates"
:::

## Measures

| Column | Meaning |
| --- | --- |
| `finance_customer_ledger_amount` | Entry amount |
| `finance_customer_ledger_amount_local_currency` | Entry amount in local currency |
| `finance_customer_ledger_debit_amount` / `credit_amount` | Debit and credit components |
| `finance_customer_ledger_remaining_amount` | Outstanding amount |
| `finance_customer_ledger_original_amount` | Original entry amount |
| `finance_customer_ledger_closed_by_amount` | Amount used to close the entry |
| `finance_customer_ledger_sales_local_currency` | Sales amount in local currency |
| `finance_customer_ledger_profit_local_currency` | Profit in local currency |
| `finance_customer_ledger_withholding_tax_amount` | Withholding-tax amount |

All monetary measures are `decimal(38,18)`.

## Reference mappings

| Target field | Mapping category | Unmapped value |
| --- | --- | --- |
| `finance_customer_ledger_document_type` | `Journal_Document_Type` | `-1` |
| `finance_customer_ledger_bal_account_type` | `Journal_Account_Type` | `-1` |

## Incremental and merge behaviour

`edw.GetHighwaterForedwfact_finance_customer_ledger` returns the maximum `finance_customer_ledger_ODSEffectiveFrom` already in the target. The ODS query should therefore return only rows newer than the most recently loaded ODS effective timestamp.

The target `MERGE` matches on partition and row key and updates matched rows in place. Dimension keys use the standard `0` Not Applicable / `-1` Unknown rule.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_finance_customer_ledger` |
| Landing | `landing.edw_fact_finance_customer_ledger` |
| Staging | `staging.ODSETLfact_finance_customer_ledger` |
| Stored procedures | `staging.insert_staging_fact_finance_customer_ledger`, `edw.Updateedwfact_finance_customer_ledger`, `edw.GetHighwaterForedwfact_finance_customer_ledger` |
| Target | `edw.fact_finance_customer_ledger` |

## Notes

### G/L account means balancing account

Unlike budget and general ledger, `dim_finance_general_ledger_account_key` is resolved from `finance_customer_ledger_bal_account_no`. It represents the balancing G/L account, not the customer account or an explicit transaction G/L account.

### Customer identifiers serve different purposes

`finance_customer_ledger_customer_id` is the dimension-value ID used to resolve `dim_finance_customer_key`. `finance_customer_ledger_customer_no` and `sell_to_customer_no` are Business Central customer numbers retained as transaction attributes. Do not assume these fields are interchangeable.

### Strict highwater boundary

The watermark uses a strict target maximum with no overlap. If multiple rows share the maximum timestamp, or if corrections do not advance `ODSEffectiveFrom`, the source query must use inclusive logic or a tie-breaker to avoid missing rows. Confirm the comparison in `BIML.DataLoadQuery`.

### Open and reversed are integers

`finance_customer_ledger_open`, `reversed` and `withholding_tax_payment` are stored as `int` rather than `bit`. Semantic models should expose them as booleans or labelled statuses.
