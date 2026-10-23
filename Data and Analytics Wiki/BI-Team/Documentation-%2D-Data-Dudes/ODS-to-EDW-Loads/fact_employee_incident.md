# fact_employee_incident

[[_TOC_]]

Employee health & safety incident investigation facts, severity gauge scores, and occurrence metrics sourced from EcoPortal.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `752` |
| Target table | `edw.fact_employee_incident` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source system | EcoPortal (GraphQL API) |

## Data lineage

```text
EcoPortal (GraphQL API)
  └─ incident_investigations
       └─ ODS view: ETL.fact_employee_incident
            └─ landing.edw_fact_employee_incident             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_employee_incident      (staging.insert_staging_fact_employee_incident)
                      └─ edw.fact_employee_incident           (edw.Updateedwfact_employee_incident)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_employee_incident_key` | `int` | Surrogate primary key | — |
| `dim_employee_incident_key` | `int` | Dimension foreign key | `edw.dim_employee_incident.dim_employee_incident_key` |
| `dim_client_incident_key` | `int` | Dimension foreign key | `edw.dim_client_incident.dim_client_incident_key` |
| `dim_incident_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_incident_reported_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_investigation_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_investigation_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_incident_close_out_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `incident_id` | `nvarchar(4000)` | Business key | `edw.dim_employee_incident.incident_id` |
| `client_incident_id` | `nvarchar(4000)` | Business key | Recordbase client incident |

::: mermaid
erDiagram
    dim_employee_incident ||--o{ fact_employee_incident : "incident_id / dim_employee_incident_key"
    dim_client_incident   ||--o{ fact_employee_incident : "dim_client_incident_key"
    dim_date              ||--o{ fact_employee_incident : "incident / investigation dates"
:::

## Direct business key join pattern

```sql
FROM edw.fact_employee_incident AS fact
INNER JOIN edw.dim_employee_incident AS inc
    ON fact.incident_id = inc.incident_id
    AND inc.DWHIsCurrent = 1
```

## Measures & Attributes

- `actual_severity_gauge_score` (`decimal(18,6)`)
- `ongoing_risk_gauge_score` (`decimal(18,6)`)
- `number_of_times_incident_occurred` (`decimal(18,6)`)
- Raw text dates: `incident_date`, `incident_reported_date`, `investigation_start_date`, `investigation_end_date`, `incident_close_out_date` (`nvarchar(4000)`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_employee_incident` |
| Landing | `landing.edw_fact_employee_incident` |
| Staging | `staging.ODSETLfact_employee_incident` |
| Stored procedures | `staging.insert_staging_fact_employee_incident`, `edw.Updateedwfact_employee_incident` |
| Target | `edw.fact_employee_incident` |
