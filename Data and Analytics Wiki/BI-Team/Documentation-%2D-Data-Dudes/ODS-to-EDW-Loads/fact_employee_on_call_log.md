# fact_employee_on_call_log

[[_TOC_]]

Employee on-call duty logs, escalated duties, categories, and regional allocations. Runs in phase `201 Facts`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `814` |
| Target table | `edw.fact_employee_on_call_log` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `201 Facts` |
| Source system | On Call |

## Data lineage

```text
On Call System
  └─ ODS view: ETL.fact_employee_on_call_log
       └─ landing.edw_fact_employee_on_call_log             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_employee_on_call_log      (staging.insert_staging_fact_employee_on_call_log)
                 └─ edw.fact_employee_on_call_log           (edw.Updateedwfact_employee_on_call_log)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_on_call_log_key` | `int` | Surrogate primary key | — |
| `dim_region_key` | `int` | Dimension foreign key | `edw.dim_region.dim_region_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_employee_escalated_to_key` | `int` | Role-playing employee FK | `edw.dim_employee.dim_employee_key` |
| `dim_employee_on_call_key` | `int` | Role-playing employee FK | `edw.dim_employee.dim_employee_key` |
| `on_call_id` | `int` | Business key | `edw.dim_employee_on_call_log.on_call_id` |
| `region_id` | `int` | Business key | `edw.dim_region.region_dimension_value_id` |
| `service_id` | `int` | Business key | `edw.dim_service.service_id` |
| `category_id` | `int` | Category business key | — |
| `employee_escalated_to_id` | `int` | Business key (escalated employee) | `edw.dim_employee.employee_id` |
| `employee_on_call_id` | `int` | Business key (on-call employee) | `edw.dim_employee.employee_id` |

::: mermaid
erDiagram
    dim_region   ||--o{ fact_employee_on_call_log : "region_id / dim_region_key"
    dim_service  ||--o{ fact_employee_on_call_log : "service_id / dim_service_key"
    dim_employee ||--o{ fact_employee_on_call_log : "on_call / escalated_to employee_ids"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_on_call_log AS fact
INNER JOIN edw.dim_employee AS e_oncall
    ON fact.employee_on_call_id = e_oncall.employee_id
    AND e_oncall.DWHIsCurrent = 1
LEFT JOIN edw.dim_employee AS e_esc
    ON fact.employee_escalated_to_id = e_esc.employee_id
    AND e_esc.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_on_call_log` |
| Landing | `landing.edw_fact_employee_on_call_log` |
| Staging | `staging.ODSETLfact_employee_on_call_log` |
| Target | `edw.fact_employee_on_call_log` |
