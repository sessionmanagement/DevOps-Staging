# fact_employee_qualification

[[_TOC_]]

Employee qualification instances, registrations, issuing organisations, status, and expiry dates sourced from IntelliHR.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `723` |
| Target table | `edw.fact_employee_qualification` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source system | IntelliHR |

## Data lineage

```text
IntelliHR (REST API)
  ├─ qualification_instances
  ├─ qualification_library_items
  ├─ people
  └─ jobs
       └─ ODS view: ETL.fact_employee_qualification
            └─ landing.edw_fact_employee_qualification             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_qualification      (staging.insert_staging_fact_employee_qualification)
                      └─ edw.fact_employee_qualification           (edw.Updateedwfact_employee_qualification)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_qualification_key` | `int` | Surrogate primary key | — |
| `qualification_instance_id` | `nvarchar(36)` | Business key | IntelliHR |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_employee_qualification_library_key` | `int` | Dimension foreign key | `edw.dim_employee_qualification_library.dim_employee_qualification_library_key` |
| `dim_employee_qualification_type_key` | `int` | Dimension foreign key | `edw.dim_employee_qualification_type.dim_employee_qualification_type_key` |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |
| `employee_qualification_library_id` | `nvarchar(36)` | Business key | `edw.dim_employee_qualification_library.employee_qualification_library_id` |
| `employee_qualification_type_id` | `nvarchar(36)` | Business key | `edw.dim_employee_qualification_type.employee_qualification_type_id` |

::: mermaid
erDiagram
    dim_employee                        ||--o{ fact_employee_qualification : "employee_id / dim_employee_key"
    dim_employee_qualification_library  ||--o{ fact_employee_qualification : "employee_qualification_library_id"
    dim_employee_qualification_type     ||--o{ fact_employee_qualification : "employee_qualification_type_id"
    dim_service                         ||--o{ fact_employee_qualification : "dim_service_key"
    dim_company                         ||--o{ fact_employee_qualification : "dim_company_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_qualification AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
INNER JOIN edw.dim_employee_qualification_library AS ql
    ON fact.employee_qualification_library_id = ql.employee_qualification_library_id
    AND ql.DWHIsCurrent = 1
INNER JOIN edw.dim_employee_qualification_type AS qt
    ON fact.employee_qualification_type_id = qt.employee_qualification_type_id
    AND qt.DWHIsCurrent = 1
```

## Attributes & Dates

- `issue_date`, `expiry_date` (`datetime2(7)`)
- `issuing_organisation` (`nvarchar(200)`), `registration_number` (`nvarchar(80)`), `qualification_status` (`nvarchar(50)`), `notes` (`nvarchar(2000)`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_qualification` |
| Landing | `landing.edw_fact_employee_qualification` |
| Staging | `staging.ODSETLfact_employee_qualification` |
| Stored procedures | `staging.insert_staging_fact_employee_qualification`, `edw.Updateedwfact_employee_qualification` |
| Target | `edw.fact_employee_qualification` |
