# fact_employee_cost_allocation

[[_TOC_]]

Employee cost allocation percentages across business units, cost centers, companies, and services, sourced from Datapay and IntelliHR.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `764` |
| Target table | `edw.fact_employee_cost_allocation` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Datapay, IntelliHR |

## Data lineage

```text
Datapay / IntelliHR
  ├─ cost_allocations
  ├─ people
  ├─ jobs
  └─ business_unit
       └─ ODS view: ETL.fact_employee_cost_allocation
            └─ landing.edw_fact_employee_cost_allocation             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_cost_allocation      (staging.insert_staging_fact_employee_cost_allocation)
                      └─ edw.fact_employee_cost_allocation           (edw.Updateedwfact_employee_cost_allocation)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_cost_allocation_key` | `int` | Surrogate primary key | — |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `dim_business_unit_hierarchy_key` | `int` | Dimension foreign key | `edw.dim_business_unit_hierarchy.dim_business_unit_hierarchy_key` |
| `employee_id` | `int` | Business key | `edw.dim_employee.employee_id` |
| `intellihr_business_unit_id` | `nvarchar(36)` | Business key | `edw.dim_business_unit_hierarchy.business_unit_id` |

::: mermaid
erDiagram
    dim_employee                     ||--o{ fact_employee_cost_allocation : "employee_id / dim_employee_key"
    dim_company                      ||--o{ fact_employee_cost_allocation : "dim_company_key"
    dim_service                      ||--o{ fact_employee_cost_allocation : "dim_service_key"
    dim_business_unit_hierarchy      ||--o{ fact_employee_cost_allocation : "intellihr_business_unit_id / dim_business_unit_hierarchy_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_cost_allocation AS fact
INNER JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
INNER JOIN edw.dim_business_unit_hierarchy AS bu
    ON fact.intellihr_business_unit_id = bu.business_unit_id
    AND bu.DWHIsCurrent = 1
```

## Measures & Attributes

- `cost_allocation_percentage`: Cost allocation percentage (`float`).
- `datapay_cost_center_code`, `datapay_cost_center_name`: Datapay cost center details (`varchar(200)`).
- `intellihr_business_unit_code`, `intellihr_business_unit_name`, `job_title`: IntelliHR attributes.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_cost_allocation` |
| Landing | `landing.edw_fact_employee_cost_allocation` |
| Staging | `staging.ODSETLfact_employee_cost_allocation` |
| Stored procedures | `staging.insert_staging_fact_employee_cost_allocation`, `edw.Updateedwfact_employee_cost_allocation` |
| Target | `edw.fact_employee_cost_allocation` |
