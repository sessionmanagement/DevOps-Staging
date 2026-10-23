# dim_finance_funding_agency

[[_TOC_]]

Business Central Funding Agency reporting-dimension values, carried separately from the Funder dimension on all four finance facts.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `469` |
| Target table | `edw.dim_finance_funding_agency` |
| Load type | `ODSINCHWTMRG` — incremental by highwater, row-versioned merge |
| Load phase | `101 Dimensions` |
| Source system | Microsoft Dynamics 365 Business Central |

## Data lineage

```text
Business Central dimensionValues (dimensionCode = FUNDING AGENCY)
  └─ ODS view: ETL.dim_finance_funding_agency
       └─ landing.edw_dim_finance_funding_agency
            └─ staging.ODSETLdim_finance_funding_agency
                 └─ edw.dim_finance_funding_agency
```

## Key fields and attributes

| Column | Type | Role |
| --- | --- | --- |
| `dim_finance_funding_agency_key` | `int` | Surrogate primary key |
| `finance_funding_agency_dimension_value_id` | `int` | Business Central dimension-value ID |
| `finance_funding_agency_code` | `varchar(20)` | Funding-agency code |
| `finance_funding_agency_name` | `varchar(100)` | Name; SCD Type 2 attribute |
| `finance_funding_agency_company_name` | `varchar(50)` | Business Central company scope |
| `finance_funding_agency_last_modified_date_time` | `datetime2(7)` | Highwater field |

::: mermaid
erDiagram
    dim_finance_funding_agency ||--o{ fact_finance_budget : "dim_finance_funding_agency_key"
    dim_finance_funding_agency ||--o{ fact_finance_general_ledger : "dim_finance_funding_agency_key"
    dim_finance_funding_agency ||--o{ fact_finance_customer_ledger : "dim_finance_funding_agency_key"
    dim_finance_funding_agency ||--o{ fact_finance_vendor_ledger : "dim_finance_funding_agency_key"
:::

## Incremental and SCD behavior

`edw.GetHighwaterForedwdim_finance_funding_agency` returns the maximum target `finance_funding_agency_last_modified_date_time`.

- Code, company and timestamp are updated in place.
- Name changes create a new SCD Type 2 version.
- Facts resolve the current agency by dimension-value ID and company.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_finance_funding_agency` |
| Landing | `landing.edw_dim_finance_funding_agency` |
| Staging | `staging.ODSETLdim_finance_funding_agency` |
| Procedures | `staging.insert_staging_dim_finance_funding_agency`, `edw.Updateedwdim_finance_funding_agency`, `edw.GetHighwaterForedwdim_finance_funding_agency` |
| Target | `edw.dim_finance_funding_agency` |

## Notes

### Merge key is not company-scoped

The update procedure matches on `finance_funding_agency_dimension_value_id` only; facts join on ID plus company. Include company in the SCD business key unless global uniqueness is proven.

### Similar name, distinct role

Funding Agency and Funder are independent Business Central dimensions and have separate surrogate keys on every finance fact. Reports should define their business distinction explicitly rather than choosing one based only on label familiarity.
