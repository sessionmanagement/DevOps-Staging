# fact_finance_budget

[[_TOC_]]

Business Central general-ledger budget entries, enriched with the organisation's finance and operational dimensions. The grain is one Business Central budget entry per company and storage row.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `513` |
| Target table | `edw.fact_finance_budget` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| Actual target behaviour | In-place merge; no SCD effective/current columns |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central REST API
  ├─ glBudgetEntries
  └─ dimensionSetEntries
       └─ ODS view: ETL.fact_finance_budget
            └─ landing.edw_fact_finance_budget
                 └─ staging.ODSETLfact_finance_budget
                      └─ edw.fact_finance_budget
```

Staging converts Business Central `[Date]` to the integer `finance_budget_date_key` in `YYYYMMDD` format.

## Key fields and relationships

### Row identity

| Column | Type | Role |
| --- | --- | --- |
| `fact_finance_budget_key` | `int` | Surrogate primary key, identity starting at 100000 |
| `fact_finance_budget_partition_key` | `nvarchar(200)` | Business Central partition component |
| `fact_finance_budget_row_key` | `nvarchar(200)` | Business Central row component; MERGE key with partition |
| `finance_budget_entry_no` | `int` | Business Central budget entry number |
| `finance_budget_dimension_set_id` | `int` | Business Central dimension-set reference |

### Dimension relationships

The fact contains both surrogate `dim_*_key` columns and retained source `_id` columns. To join using an `_id`, match it directly to the dimension's corresponding `_id` and filter the SCD2 dimension to `DWHIsCurrent = 1`. Do not add company to the join.

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

`dim_finance_general_ledger_account_key`, `dim_company_key` and `finance_budget_date_key` link by account code, company name and date key respectively rather than by an `_id` field.

```sql
FROM edw.fact_finance_budget AS budget
INNER JOIN edw.dim_department AS department
     ON budget.department_id = department.department_dimension_value_id
     AND department.DWHIsCurrent = 1
```

::: mermaid
erDiagram
    dim_finance_general_ledger_account ||--o{ fact_finance_budget : "dim_finance_general_ledger_account_key"
    dim_finance_budget_holder          ||--o{ fact_finance_budget : "dim_finance_budget_holder_key"
    dim_finance_contract               ||--o{ fact_finance_budget : "dim_finance_contract_key"
    dim_finance_customer               ||--o{ fact_finance_budget : "dim_finance_customer_key"
    dim_department                     ||--o{ fact_finance_budget : "dim_department_key"
    dim_district                       ||--o{ fact_finance_budget : "dim_district_key"
    dim_finance_funder                 ||--o{ fact_finance_budget : "dim_finance_funder_key"
    dim_finance_funding_agency         ||--o{ fact_finance_budget : "dim_finance_funding_agency_key"
    dim_location_new                   ||--o{ fact_finance_budget : "dim_location_key"
    dim_region                         ||--o{ fact_finance_budget : "dim_region_key"
    dim_service                        ||--o{ fact_finance_budget : "dim_service_key"
    dim_finance_vendor                 ||--o{ fact_finance_budget : "dim_finance_vendor_key"
    dim_company                        ||--o{ fact_finance_budget : "dim_company_key"
    dim_date                           ||--o{ fact_finance_budget : "finance_budget_date_key"
:::

## Measures and descriptive fields

| Column | Type | Meaning |
| --- | --- | --- |
| `finance_budget_amount` | `decimal(38,18)` | Budget amount |
| `finance_budget_budget_name` | `nvarchar(500)` | Business Central budget name |
| `finance_budget_description` | `nvarchar(200)` | Entry description |
| `finance_budget_general_ledger_account_no` | `nvarchar(200)` | G/L account business key |
| `finance_budget_global_dimension_1_code` | `nvarchar(200)` | Raw Business Central global-dimension code |
| `finance_budget_last_modified_date_time` | `datetime2(0)` | Source modification timestamp |

## Incremental and merge behaviour

`edw.GetHighwaterForedwfact_finance_budget` always returns `1900-01-01`; the code that derives the watermark from the target maximum is commented out. The load is therefore configured as incremental but behaves like a full source extraction.

The target `MERGE` matches on both partition and row key. Matched rows are updated in place; new rows are inserted. Dimension keys use `0` when the source dimension is absent and `-1` when it is populated but cannot be resolved.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_finance_budget` |
| Landing | `landing.edw_fact_finance_budget` |
| Staging | `staging.ODSETLfact_finance_budget` |
| Stored procedures | `staging.insert_staging_fact_finance_budget`, `edw.Updateedwfact_finance_budget`, `edw.GetHighwaterForedwfact_finance_budget` |
| Target | `edw.fact_finance_budget` |

## Notes

### Budget is dimensionalized like actuals

The fact carries the same organisational dimensions used on the general ledger, allowing direct budget-versus-actual comparison by account, company, service, location, region, funder and contract.

### Precision

`finance_budget_amount` uses `decimal(38,18)`, substantially more precision than a conventional currency type. Semantic models should format it as currency and avoid exposing insignificant fractional digits.

### Primary-key constraint typo

The deployed constraint is named `PK_EDW_fact_finace_budget` (missing the second `n` in “finance”). This does not affect behaviour but should be preserved in deployment scripts unless deliberately renamed.
