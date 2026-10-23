# fact_finance_vendor_ledger

[[_TOC_]]

Business Central vendor-ledger entries — invoices, payments, credits, remaining balances and settlement details for payables. The grain is one vendor-ledger entry per company and Business Central storage row.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `515` |
| Target table | `edw.fact_finance_vendor_ledger` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| Actual target behaviour | In-place merge; no SCD effective/current columns |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central REST API
  ├─ vendorLedgerEntries
  ├─ dimensionSetEntries
  └─ dimensionValues
       └─ ODS view: ETL.fact_finance_vendor_ledger
            └─ landing.edw_fact_finance_vendor_ledger
                 └─ staging.ODSETLfact_finance_vendor_ledger
                      └─ edw.fact_finance_vendor_ledger
```

Staging converts document, due and posting dates to `YYYYMMDD` integer keys and maps document and balancing-account types through `reference.EDW_Mapping`.

## Key fields and relationships

### Row identity

| Column | Type | Role |
| --- | --- | --- |
| `fact_finance_vendor_ledger_key` | `int` | Surrogate primary key, identity starting at 100000 |
| `fact_finance_vendor_ledger_partition_key` | `nvarchar(150)` | Business Central partition component |
| `fact_finance_vendor_ledger_row_key` | `nvarchar(150)` | Business Central row component; MERGE key with partition |
| `finance_vendor_ledger_dimension_set_id` | `int` | Business Central dimension-set reference |
| `finance_vendor_ledger_document_no` | `nvarchar(150)` | Degenerate document reference |
| `finance_vendor_ledger_external_document_no` | `nvarchar(150)` | Vendor-supplied document reference |

### Dimension relationships

To join using an `_id`, match it directly to the dimension's corresponding `_id` and filter the SCD2 dimension to `DWHIsCurrent = 1`. Do not add company to the join.

| Fact `_id` | Join to dimension column | Required filter |
| --- | --- | --- |
| `finance_budget_holder_id` | `edw.dim_finance_budget_holder.finance_budget_holder_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_contract_id` | `edw.dim_finance_contract.finance_contract_dimension_value_id` | `DWHIsCurrent = 1` |
| `department_id` | `edw.dim_department.department_dimension_value_id` | `DWHIsCurrent = 1` |
| `district_id` | `edw.dim_district.district_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_funder_id` | `edw.dim_finance_funder.finance_funder_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_funding_agency_id` | `edw.dim_finance_funding_agency.finance_funding_agency_dimension_value_id` | `DWHIsCurrent = 1` |
| `location_id` | `edw.dim_location_new.business_central_location_id` | `DWHIsCurrent = 1` |
| `region_id` | `edw.dim_region.region_dimension_value_id` | `DWHIsCurrent = 1` |
| `service_id` | `edw.dim_service.service_id` | `DWHIsCurrent = 1` |
| `finance_vendor_id` | `edw.dim_finance_vendor.finance_vendor_dimension_value_id` | `DWHIsCurrent = 1` |

The balancing G/L account, company and date relationships do not use retained `_id` fields.

```sql
FROM edw.fact_finance_vendor_ledger AS vendor_ledger
INNER JOIN edw.dim_department AS department
     ON vendor_ledger.department_id = department.department_dimension_value_id
     AND department.DWHIsCurrent = 1
```

::: mermaid
erDiagram
    dim_finance_general_ledger_account ||--o{ fact_finance_vendor_ledger : "balancing account"
    dim_finance_budget_holder          ||--o{ fact_finance_vendor_ledger : "budget holder"
    dim_finance_contract               ||--o{ fact_finance_vendor_ledger : "contract"
    dim_department                     ||--o{ fact_finance_vendor_ledger : "department"
    dim_district                       ||--o{ fact_finance_vendor_ledger : "district"
    dim_finance_funder                 ||--o{ fact_finance_vendor_ledger : "funder"
    dim_finance_funding_agency         ||--o{ fact_finance_vendor_ledger : "funding agency"
    dim_location_new                   ||--o{ fact_finance_vendor_ledger : "location"
    dim_region                         ||--o{ fact_finance_vendor_ledger : "region"
    dim_service                        ||--o{ fact_finance_vendor_ledger : "service"
    dim_finance_vendor                 ||--o{ fact_finance_vendor_ledger : "vendor"
    dim_company                        ||--o{ fact_finance_vendor_ledger : "company"
    dim_date                           ||--o{ fact_finance_vendor_ledger : "document + due + posting dates"
:::

## Measures

| Column | Meaning |
| --- | --- |
| `finance_vendor_ledger_amount` | Entry amount |
| `finance_vendor_ledger_amount_local_currency` | Entry amount in local currency |
| `finance_vendor_ledger_credit_amount` | Credit amount |
| `finance_vendor_ledger_credit_amount_local_currency` | Credit amount in local currency |
| `finance_vendor_ledger_original_amount` | Original amount |
| `finance_vendor_ledger_rem_amount` | Remaining amount |
| `finance_vendor_ledger_closed_by_amount` | Amount used to close the entry |
| `finance_vendor_ledger_purchase_local_currency` | Purchase amount in local currency |
| `finance_vendor_ledger_rem_amount_for_withholding_tax` | Remaining withholding-tax amount |

All monetary measures are `decimal(38,18)`.

## Reference mappings

| Target field | Mapping category | Unmapped value |
| --- | --- | --- |
| `finance_vendor_ledger_document_type` | `Journal_Document_Type` | `-1` |
| `finance_vendor_ledger_bal_account_type` | `Journal_Account_Type` | `-1` |

## Incremental and merge behaviour

`edw.GetHighwaterForedwfact_finance_vendor_ledger` returns the maximum `finance_vendor_ledger_ODSEffectiveFrom` already in the target. The target `MERGE` matches on partition and row key and updates matched rows in place.

Dimension keys use the standard `0` Not Applicable / `-1` Unknown rule. For the balancing account specifically, an empty string maps to `0`; a non-empty unmatched account maps to `-1`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_finance_vendor_ledger` |
| Landing | `landing.edw_fact_finance_vendor_ledger` |
| Staging | `staging.ODSETLfact_finance_vendor_ledger` |
| Stored procedures | `staging.insert_staging_fact_finance_vendor_ledger`, `edw.Updateedwfact_finance_vendor_ledger`, `edw.GetHighwaterForedwfact_finance_vendor_ledger` |
| Target | `edw.fact_finance_vendor_ledger` |

## Notes

### No customer dimension

Unlike budget, customer ledger and general ledger, this fact has no `dim_finance_customer_key`; this is appropriate for a vendor-payables fact. It carries 12 organisational dimension keys plus three date roles.

### G/L account means balancing account

`dim_finance_general_ledger_account_key` is resolved from `finance_vendor_ledger_bal_account_no`, not an explicit transaction G/L account. Compare G/L-account totals with the general ledger carefully.

### Multiple vendor identifiers

`finance_vendor_id` resolves the conformed vendor dimension. `finance_vendor_ledger_vendor_no` and `buy_from_vendor_no` are retained Business Central vendor numbers with different transactional meanings. Use `dim_finance_vendor_key` for conformed analysis.

### Strict highwater boundary

Like customer ledger, this load uses the exact target maximum ODS effective timestamp with no overlap. Confirm inclusive comparison/tie-breaking in `BIML.DataLoadQuery` and that source corrections always advance `ODSEffectiveFrom`.

### User is not conformed

`user_id` is retained as `nvarchar(117)` with no `dim_employee_key`, so entry creation cannot be analysed reliably by employee without a separate user mapping.
