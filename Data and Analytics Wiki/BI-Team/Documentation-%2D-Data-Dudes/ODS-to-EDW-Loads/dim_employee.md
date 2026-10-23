# dim_employee

[[_TOC_]]

The core conformed employee dimension — one row per employee version. Stores employee demographic, employment status, contact, remuneration, job, ethnicity, address, emergency contact, and manager details.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `470` |
| Target table | `edw.dim_employee` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | IntelliHR, Datapay, Emplive, Recordbase (EAL & MNB), ETL |

## Data lineage

```text
IntelliHR (REST API) / Datapay / Emplive / Recordbase
  └─ ODS view: ETL.dim_employee
       └─ landing.edw_dim_employee             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_employee      (staging.insert_staging_dim_employee)
                 └─ edw.dim_employee           (edw.Updateedwdim_employee)
```

### Source tables behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `intellihr` | `people`, `jobs`, `people_addresses`, `people_custom_fields`, `people_phone_numbers` |
| `datapay` | `employees`, `pay_groups`, `companies` |
| `emplive` | `employees`, `pay_levels`, `entities` |
| `rbeal` | `dlDimUser` |
| `rbmnb` | `dlDimUser` |
| `etl` | `reference_intelliHR_person_ethnicity` |

## Key fields and attributes

### Key columns

| Column | Type | Role |
| --- | --- | --- |
| `dim_employee_key` | `int` | Surrogate primary key (identity 0, 1) |
| `employee_id` | `int` | Business key |
| `employee_profile_system_id` | `nvarchar(50)` | Secondary system identifier (Humanforce/IntelliHR ID) |
| `employee_people_manager_id` | `nvarchar(100)` | Manager identifier |

### Ethnicity foreign key references

- `primary_ethnicity_id` (`int`)
- `secondary_ethnicity_id` (`int`)
- `tertiary_ethnicity_id` (`int`)
- `fourth_ethnicity_id` (`int`)
- `primary_iwi_id` (`int`)
- `identified_ethnicity_id` (`int`)

::: mermaid
erDiagram
    dim_employee ||--o{ fact_employee_hours_worked : "employee_id"
    dim_employee ||--o{ fact_employee_leave : "employee_id"
    dim_employee ||--o{ fact_employee_pay_slip : "employee_id"
    dim_employee ||--o{ fact_employee_qualification : "employee_id"
    dim_employee ||--o{ fact_employee_remuneration : "employee_id"
    dim_employee ||--o{ dim_employee_hierarchy : "dim_employee_key"
:::

## Direct business key join pattern

To join a fact table to this dimension using `employee_id`, match directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_employee_hours_worked AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
```

## Security & Data Masking

- `employee_bank_details` is masked with SQL Server Data Masking: `MASKED WITH (FUNCTION = 'partial(0, "XXXX-XXXX-XXXX-", 4)')`.
- `employee_salary_sacrifice` is masked with `MASKED WITH (FUNCTION = 'default()')`.
- Sensitivity classifications are applied for GDPR / Confidential tracking across name, DOB, phone, email, address, work rights expiration date, ethnicity, and practising certificate expiry.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_employee` |
| Landing | `landing.edw_dim_employee` |
| Staging | `staging.ODSETLdim_employee` |
| Stored procedures | `staging.insert_staging_dim_employee`, `edw.Updateedwdim_employee` |
| Target | `edw.dim_employee` |

## Notes

- Includes special default rows `0` (`N/A`) and `-1` (`Unknown`).
- Business definition and column-level detail: [EDW dimension tables](/BI-Team/Documentation-%2D-Data-Dudes/Data-Documentation/EDW-dimension-tables).
