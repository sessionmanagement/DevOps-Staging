# fact_employee_leave_request

[[_TOC_]]

Employee leave request submissions, dates, and approval statuses sourced from Emplive and Emplive API.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `763` |
| Target table | `edw.fact_employee_leave_request` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Emplive, Emplive API |

## Data lineage

```text
Emplive API / Emplive
  ├─ employees
  └─ leave_requests
       └─ ODS view: ETL.fact_employee_leave_request
            └─ landing.edw_fact_employee_leave_request             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_leave_request      (staging.insert_staging_fact_employee_leave_request)
                      └─ edw.fact_employee_leave_request           (edw.Updateedwfact_employee_leave_request)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_leave_request_key` | `int` | Surrogate primary key | — |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_employee_leave_request_type_key` | `int` | Dimension foreign key | `edw.dim_employee_leave_request_type.dim_employee_leave_request_type_key` |
| `dim_leave_request_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_leave_request_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `leave_request_id` | `nvarchar(36)` | Business key | Emplive API |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |
| `leave_request_type_id` | `nvarchar(36)` | Business key | `edw.dim_employee_leave_request_type.leave_request_type_id` |

::: mermaid
erDiagram
    dim_employee                        ||--o{ fact_employee_leave_request : "employee_id / dim_employee_key"
    dim_employee_leave_request_type     ||--o{ fact_employee_leave_request : "leave_request_type_id"
    dim_date                            ||--o{ fact_employee_leave_request : "start / end date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_leave_request AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
INNER JOIN edw.dim_employee_leave_request_type AS t
    ON fact.leave_request_type_id = t.leave_request_type_id
    AND t.DWHIsCurrent = 1
```

## Attributes

- `leave_request_start_date_time`, `leave_request_end_date_time` (`datetime2(7)`)
- `leave_request_status` (`nvarchar(255)`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_leave_request` |
| Landing | `landing.edw_fact_employee_leave_request` |
| Staging | `staging.ODSETLfact_employee_leave_request` |
| Stored procedures | `staging.insert_staging_fact_employee_leave_request`, `edw.Updateedwfact_employee_leave_request` |
| Target | `edw.fact_employee_leave_request` |
