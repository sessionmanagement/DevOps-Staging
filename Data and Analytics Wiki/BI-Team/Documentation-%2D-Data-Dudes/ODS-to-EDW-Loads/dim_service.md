# dim_service

[[_TOC_]]

The conformed enterprise service dimension — one row per service version. Represents Emerge Aotearoa operational services, cost centers, and business units across client operations, property services, HR cost allocation, and financial ledger reporting.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `480` |
| Target table | `edw.dim_service` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `102 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Business Central, IntelliHR, Datapay, Reference data |

## Data lineage

```text
Business Central / IntelliHR / Datapay / Reference
  ├─ Business Central: dimensionValues, dimensionHierarchies
  ├─ Datapay: cost_structures
  ├─ IntelliHR: business_unit
  └─ Reference: ref_location_data
       └─ ODS view: ETL.dim_service
            └─ landing.edw_dim_service             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_service      (staging.insert_staging_dim_service)
                      └─ edw.dim_service           (edw.Updateedwdim_service)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_service_key` | `int` | Surrogate primary key (identity 100000, 1) | — |
| `service_id` | `int` | Primary integer business key | Business Central / operational systems |
| `dim_service_unique_key` | `nvarchar(200)` | Composite natural key (`rowkey_serviceid_company`) | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `intellihr_service_id` | `nvarchar(200)` | External system key | IntelliHR `business_unit` |
| `datapay_service_id` | `nvarchar(200)` | External system key | Datapay `cost_structures` |
| `service_code` | `nvarchar(200)` | Service code | — |
| `service_name` | `nvarchar(200)` | Service title | — |
| `service_type_code` / `service_type_name` | `nvarchar(200)` | Service classification | — |
| `department_code` / `department_name` | `nvarchar(200)` | Department classification | `edw.dim_department` |
| `district_code` / `district_name` | `nvarchar(200)` | District classification | `edw.dim_district` |
| `region_code` / `region_name` | `nvarchar(200)` | Region classification | `edw.dim_region` |
| `location_code` / `location_name` | `nvarchar(200)` | Location classification | `edw.dim_location_new` |
| `finance_funder_code` / `name` | `nvarchar(200)` | Funder classification | `edw.dim_finance_funder` |
| `finance_funding_agency_code` / `name` | `nvarchar(200)` | Funding agency classification | `edw.dim_finance_funding_agency` |
| `finance_budget_holder_code` / `name` | `nvarchar(200)` | Budget holder classification | `edw.dim_finance_budget_holder` |
| `finance_contract_code` / `name` | `nvarchar(200)` | Contract classification | `edw.dim_finance_contract` |
| `is_inactive` | `int` | Inactive / blocked status indicator | — |
| `latitude` / `longitude` | `decimal(13,8)` | Geographic coordinates | Service delivery site coordinates |

::: mermaid
erDiagram
    dim_company ||--o{ dim_service : "dim_company_key"
    dim_service ||--o{ fact_finance_general_ledger : "service_id / dim_service_key"
    dim_service ||--o{ fact_client_referral : "dim_service_key"
    dim_service ||--o{ fact_client_activity_breakdown : "dim_service_key"
    dim_service ||--o{ fact_employee_cost_allocation : "dim_service_key"
:::

## Direct business key join pattern

To join facts or queries to `edw.dim_service` using `service_id`, match directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_finance_general_ledger AS gl
INNER JOIN edw.dim_service AS s
    ON gl.service_id = s.service_id
    AND s.DWHIsCurrent = 1
```

## Special member records

`edw.dim_service` includes pre-seeded special member keys:

- `0`: `N/A` (Not Applicable)
- `-1`: `Unknown` (Data quality issue / unmatched)
- `-2`: `Closed` ("Closed or discontinued service")

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_service` |
| Landing | `landing.edw_dim_service` |
| Staging | `staging.ODSETLdim_service` |
| Stored procedures | `staging.insert_staging_dim_service`, `edw.Updateedwdim_service` |
| Target | `edw.dim_service` |

## Notes

- **Phase 102 ordering**: Loads in phase `102 Dimensions` so that prerequisite dimension `dim_company` (phase `101`) completes first.
- **Geocoding**: `latitude` and `longitude` enable spatial analytics and map visualisations in Power BI.
- **Timestamp rounding**: `last_modified_date_time` is minute-rounded in staging to prevent redundant SCD2 micro-versions when timestamps fluctuate by seconds.
