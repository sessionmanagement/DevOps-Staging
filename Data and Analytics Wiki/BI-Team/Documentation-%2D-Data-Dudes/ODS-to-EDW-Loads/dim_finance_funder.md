# dim_finance_funder

[[_TOC_]]

Business Central Funder reporting-dimension values, used to attribute finance activity to the organisation funding a service or contract.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `476` |
| Target table | `edw.dim_finance_funder` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, row-versioned merge |
| Load phase | `101 Dimensions` |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central dimensionValues (dimensionCode = FUNDER)
  └─ ODS view: ETL.dim_finance_funder
       └─ landing.edw_dim_finance_funder
            └─ staging.ODSETLdim_finance_funder
                 └─ edw.dim_finance_funder
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_finance_funder_key` | `int` | Surrogate primary key |
| `finance_funder_dimension_value_id` | `int` | Business Central dimension-value ID |
| `finance_funder_code` | `varchar(20)` | Funder code |
| `finance_funder_name` | `varchar(100)` | Funder name; SCD Type 2 attribute |
| `finance_funder_company_name` | `varchar(50)` | Business Central company scope |
| `finance_funder_last_modified_date_time` | `datetime2(7)` | Highwater field |

::: mermaid
erDiagram
    dim_finance_funder ||--o{ fact_finance_budget : "dim_finance_funder_key"
    dim_finance_funder ||--o{ fact_finance_general_ledger : "dim_finance_funder_key"
    dim_finance_funder ||--o{ fact_finance_customer_ledger : "dim_finance_funder_key"
    dim_finance_funder ||--o{ fact_finance_vendor_ledger : "dim_finance_funder_key"
:::

## Incremental and SCD behavior

`edw.GetHighwaterForedwdim_finance_funder` returns the maximum target `finance_funder_last_modified_date_time`.

- Code, company and timestamp are SCD Type 1 attributes.
- Name is SCD Type 2.
- Facts resolve the current funder using dimension-value ID and company name.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_finance_funder` |
| Landing | `landing.edw_dim_finance_funder` |
| Staging | `staging.ODSETLdim_finance_funder` |
| Procedures | `staging.insert_staging_dim_finance_funder`, `edw.Updateedwdim_finance_funder`, `edw.GetHighwaterForedwdim_finance_funder` |
| Target | `edw.dim_finance_funder` |

## Notes

### Merge key is not company-scoped

The update procedure matches on `finance_funder_dimension_value_id` only; facts join on ID plus company. Include company in the merge business key unless source IDs are globally unique.

### Funder and funding agency are separate

Both dimensions appear on every finance fact. A funder identifies who funds the activity; a funding agency is a separate reporting classification. Do not treat the two keys as interchangeable even where their names happen to match.
