# dim_company

[[_TOC_]]

The conformed company and legal entity dimension — maps and unifies organizational operating entities across Business Central, Datapay, IntelliHR, and Recordbase.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `462` |
| Target table | `edw.dim_company` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Business Central, Datapay, IntelliHR, Recordbase (EAL & MNB) |

## Data lineage

```text
Business Central / Datapay / IntelliHR / Recordbase
  ├─ Business Central: dimensionValues
  ├─ Datapay: companies
  ├─ IntelliHR: business_entities
  └─ Recordbase: dlDimCompany (rbeal, rbmnb)
       └─ ODS view: ETL.dim_company
            └─ landing.edw_dim_company             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_company      (staging.insert_staging_dim_company)
                      └─ edw.dim_company           (edw.Updateedwdim_company)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_company_key` | `int` | Surrogate primary key (identity 0, 1) | — |
| `company_id` | `int` | Primary business key | Conformed company ID |
| `company_name` | `nvarchar(50)` | Company name | — |
| `company_short_code` | `nvarchar(10)` | Short code | — |
| `dim_company_intellihr_key` | `nvarchar(36)` | IntelliHR entity GUID | IntelliHR `business_entities` |
| `dim_company_datapay_key` | `nvarchar(50)` | Datapay company ID | Datapay `companies` |
| `company_datapay_code` | `int` | Datapay integer code | Datapay |
| `company_recordbase_id` | `int` | Recordbase company ID | Recordbase `dlDimCompany` |

::: mermaid
erDiagram
    dim_company ||--o{ dim_service : "dim_company_key"
    dim_company ||--o{ dim_employee : "company_id"
    dim_company ||--o{ dim_client : "company_id"
    dim_company ||--o{ fact_finance_general_ledger : "dim_company_key"
:::

## Direct business key join pattern

To join using `company_id`, match directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.dim_client AS c
INNER JOIN edw.dim_company AS co
    ON c.company_id = co.company_id
    AND co.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_company` |
| Landing | `landing.edw_dim_company` |
| Staging | `staging.ODSETLdim_company` |
| Stored procedures | `staging.insert_staging_dim_company`, `edw.Updateedwdim_company` |
| Target | `edw.dim_company` |

## Notes

- **Multi-system cross-reference hub**: `dim_company` acts as the translation matrix linking operational IDs from Datapay (`company_datapay_code`), IntelliHR (`dim_company_intellihr_key`), Recordbase (`company_recordbase_id`), and Business Central company names.
