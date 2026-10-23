# fact_finance_general_ledger

[[_TOC_]]

Business Central general-ledger entries — the authoritative actuals fact for finance reporting. The grain is one G/L entry per company and Business Central storage row.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `516` |
| Target table | `edw.fact_finance_general_ledger` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| Actual target behaviour | In-place merge; no SCD effective/current columns |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central REST API
  ├─ glEntries
  ├─ dimensionSetEntries
  └─ dimensionValues
       └─ ODS view: ETL.fact_finance_general_ledger
            └─ landing.edw_fact_finance_general_ledger
                 └─ staging.ODSETLfact_finance_general_ledger
                      └─ edw.fact_finance_general_ledger
```

Staging converts posting and document dates to `YYYYMMDD` integer keys and maps source type, document type and general posting type through `reference.EDW_Mapping`.

## Key fields and relationships

### Row identity

| Column | Type | Role |
| --- | --- | --- |
| `fact_finance_general_ledger_key` | `int` | Surrogate primary key, identity starting at 100000 |
| `fact_finance_general_ledger_partition_key` | `nvarchar(150)` | Business Central partition component |
| `fact_finance_general_ledger_row_key` | `nvarchar(150)` | Business Central row component; MERGE key with partition |
| `finance_general_ledger_transaction_no` | `int` | Business Central transaction number |
| `finance_general_ledger_document_no` | `nvarchar(150)` | Degenerate document reference |

### Dimension relationships

To join using an `_id`, match it directly to the dimension's corresponding `_id` and filter the SCD2 dimension to `DWHIsCurrent = 1`. Do not add company to the join.

| Fact `_id` | Join to dimension column | Required filter |
| --- | --- | --- |
| `finance_budget_holder_id` | `edw.dim_finance_budget_holder.finance_budget_holder_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_contract_id` | `edw.dim_finance_contract.finance_contract_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_customer_id` | `edw.dim_finance_customer.finance_customer_dimension_value_id` | `DWHIsCurrent = 1` |
| `department_id` | `edw.dim_department.department_dimension_value_id` | `DWHIsCurrent = 1` |
| `district_id` | `edw.dim_district.district_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_funder_id` | `edw.dim_finance_funder.finance_funder_dimension_value_id` | `DWHIsCurrent = 1` |
| `finance_funding_agency_id` | `edw.dim_finance_funding_agency.finance_funding_agency_dimension_value_id` | `DWHIsCurrent = 1` |
| `location_id` | `edw.dim_location_new.business_central_location_id` | `DWHIsCurrent = 1` |
| `region_id` | `edw.dim_region.region_dimension_value_id` | `DWHIsCurrent = 1` |
| `service_id` | `edw.dim_service.service_id` | `DWHIsCurrent = 1` |
| `finance_vendor_id` | `edw.dim_finance_vendor.finance_vendor_dimension_value_id` | `DWHIsCurrent = 1` |

The G/L account, company and date relationships use account code, company name and date keys rather than retained `_id` fields.

```sql
FROM edw.fact_finance_general_ledger AS gl
INNER JOIN edw.dim_department AS department
     ON gl.department_id = department.department_dimension_value_id
     AND department.DWHIsCurrent = 1
```

::: mermaid
erDiagram
    dim_finance_general_ledger_account ||--o{ fact_finance_general_ledger : "G/L account"
    dim_finance_budget_holder          ||--o{ fact_finance_general_ledger : "budget holder"
    dim_finance_contract               ||--o{ fact_finance_general_ledger : "contract"
    dim_finance_customer               ||--o{ fact_finance_general_ledger : "customer"
    dim_department                     ||--o{ fact_finance_general_ledger : "department"
    dim_district                       ||--o{ fact_finance_general_ledger : "district"
    dim_finance_funder                 ||--o{ fact_finance_general_ledger : "funder"
    dim_finance_funding_agency         ||--o{ fact_finance_general_ledger : "funding agency"
    dim_location_new                   ||--o{ fact_finance_general_ledger : "location"
    dim_region                         ||--o{ fact_finance_general_ledger : "region"
    dim_service                        ||--o{ fact_finance_general_ledger : "service"
    dim_finance_vendor                 ||--o{ fact_finance_general_ledger : "vendor"
    dim_company                        ||--o{ fact_finance_general_ledger : "company"
    dim_date                           ||--o{ fact_finance_general_ledger : "posting + document dates"
:::

## Measures

| Column | Type | Meaning |
| --- | --- | --- |
| `finance_general_ledger_amount` | `decimal(38,18)` | Signed G/L entry amount |
| `finance_general_ledger_debit_amount` | `decimal(38,18)` | Debit component |
| `finance_general_ledger_credit_amount` | `decimal(38,18)` | Credit component |

The signed amount should reconcile to debit minus credit according to Business Central sign conventions.

## Reference mappings

| Target field | Mapping category | Unmapped value |
| --- | --- | --- |
| `finance_general_ledger_source_type` | `Journal_Source_Type` | `-1` |
| `finance_general_ledger_document_type` | `Journal_Document_Type` | `-1` |
| `finance_general_ledger_gen_posting_type` | `Gen_Posting_Type` | `-1` |

## Incremental and merge behaviour

`edw.GetHighwaterForedwfact_finance_general_ledger` returns:

```sql
DATEADD(YEAR, -1, MAX(finance_general_ledger_last_modified_date_time))
```

Each run therefore re-extracts a rolling year before the latest target modification timestamp. This overlap protects against corrections to recently posted entries while the compound partition/row key prevents duplicates.

Matched rows are updated in place. Dimension keys use the standard `0` Not Applicable / `-1` Unknown rule.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_finance_general_ledger` |
| Landing | `landing.edw_fact_finance_general_ledger` |
| Staging | `staging.ODSETLfact_finance_general_ledger` |
| Stored procedures | `staging.insert_staging_fact_finance_general_ledger`, `edw.Updateedwfact_finance_general_ledger`, `edw.GetHighwaterForedwfact_finance_general_ledger` |
| Target | `edw.fact_finance_general_ledger` |

## Notes

### One-year overlap has a cost

The overlap is deliberately conservative but means a year of G/L entries is copied and merged every day. Monitor duration and source API load; a shorter overlap may be sufficient if source correction behaviour is understood.

### User is not conformed

`user_id` is retained as `nvarchar(150)` but there is no `dim_employee_key`. Finance activity cannot be reliably analysed by employee without a separate Business Central-user-to-employee mapping.

### Business Central option values

Source, document and posting types are converted from text labels to integer IDs in staging. The IDs belong to `reference.EDW_Mapping`, not to dedicated dimensions; reports must decode them through the same reference category or through semantic-model labels.
