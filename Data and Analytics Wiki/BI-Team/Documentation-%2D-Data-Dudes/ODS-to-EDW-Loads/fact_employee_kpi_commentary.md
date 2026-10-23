# fact_employee_kpi_commentary

[[_TOC_]]

Qualitative employee KPI response commentary and measure feedback sourced from SharePoint lists. Runs in phase `201 Facts`.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `710` |
| Target table | `edw.fact_employee_kpi_commentary` |
| Load type | `ODSFLLINS` — ODS: Truncated reload |
| Load phase | `201 Facts` |
| Source system | SharePoint (KPI list) |

## Data lineage

```text
SharePoint List (MS Graph)
  └─ commentary
       └─ ODS view: ETL.fact_employee_kpi_commentary
            └─ landing.edw_fact_employee_kpi_commentary             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_kpi_commentary      (staging.insert_staging_fact_employee_kpi_commentary)
                      └─ edw.fact_employee_kpi_commentary           (edw.Updateedwfact_employee_kpi_commentary)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_kpi_commentary_key` | `int` | Surrogate primary key | — |
| `dim_kpi_key` | `int` | Dimension foreign key | `edw.dim_kpi.dim_kpi_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_service_key` | `int` | Dimension foreign key | `edw.dim_service.dim_service_key` |
| `kpi_id` | `int` | Business key | `edw.dim_kpi.kpi_id` |
| `company_id` | `int` | Business key | `edw.dim_company.company_id` |
| `service_id` | `int` | Business key | `edw.dim_service.service_id` |

::: mermaid
erDiagram
    dim_kpi      ||--o{ fact_employee_kpi_commentary : "kpi_id / dim_kpi_key"
    dim_company  ||--o{ fact_employee_kpi_commentary : "dim_company_key"
    dim_employee ||--o{ fact_employee_kpi_commentary : "responder / dim_employee_key"
    dim_service  ||--o{ fact_employee_kpi_commentary : "dim_service_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_kpi_commentary AS fact
INNER JOIN edw.dim_kpi AS k
    ON fact.kpi_id = k.kpi_id
    AND k.DWHIsCurrent = 1
```

## Attributes

- `response_id` (`bigint`)
- `measure_selected` (`nvarchar(500)`)
- `commentary` (`nvarchar(1000)`)
- `responder` (`nvarchar(255)`)
- `submitted_date` (`datetime2(7)`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_kpi_commentary` |
| Landing | `landing.edw_fact_employee_kpi_commentary` |
| Staging | `staging.ODSETLfact_employee_kpi_commentary` |
| Stored procedures | `staging.insert_staging_fact_employee_kpi_commentary`, `edw.Updateedwfact_employee_kpi_commentary` |
| Target | `edw.fact_employee_kpi_commentary` |
