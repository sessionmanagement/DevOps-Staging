# fact_client_incident

[[_TOC_]]

Client incident events recorded in Recordbase (`rbeal` and `rbmnb`), connecting client incident classifications, severities, statuses, team, and owner/investigator/reporter/creator/originator employee assignments.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `735` |
| Target table | `edw.fact_client_incident` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  ├─ dlFactIncident
  ├─ dlFactIncidentStatus
  ├─ dlFactIncidentCategory
  ├─ dlFactIncidentAssessment
  ├─ dlDimIncidentStatus
  ├─ dlDimUser
  └─ incidentFactIncidentStatistics
       └─ ODS view: ETL.fact_client_incident
            └─ landing.edw_fact_client_incident             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_incident      (staging.insert_staging_fact_client_incident)
                      └─ edw.fact_client_incident           (edw.Updateedwfact_client_incident)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_incident_key` | `int` | Surrogate primary key | — |
| `incident_id` | `int` | Business key | Recordbase |
| `dim_client_incident_key` | `int` | Dimension foreign key | `edw.dim_client_incident.dim_client_incident_key` |
| `dim_client_incident_category_type_key` | `int` | Dimension foreign key | `edw.dim_client_incident_category_type.dim_client_incident_category_type_key` |
| `dim_current_client_incident_severity_key` | `int` | Dimension foreign key | `edw.dim_client_incident_severity.dim_client_incident_severity_key` |
| `dim_current_client_incident_status_type_key` | `int` | Dimension foreign key | `edw.dim_client_incident_status_type.dim_client_incident_status_type_key` |
| `dim_client_team_key` | `int` | Dimension foreign key | `edw.dim_client_team.dim_client_team_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_current_owner_employee_key` | `int` | Role-playing employee FK | `edw.dim_employee.dim_employee_key` |
| `dim_current_investigator_employee_key` | `int` | Role-playing employee FK | `edw.dim_employee.dim_employee_key` |
| `dim_current_reporter_employee_key` | `int` | Role-playing employee FK | `edw.dim_employee.dim_employee_key` |
| `dim_creator_employee_key` | `int` | Role-playing employee FK | `edw.dim_employee.dim_employee_key` |
| `dim_originator_employee_key` | `int` | Role-playing employee FK | `edw.dim_employee.dim_employee_key` |
| `dim_incident_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `dim_incident_created_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |

::: mermaid
erDiagram
    dim_client_incident                 ||--o{ fact_client_incident : "dim_client_incident_key"
    dim_client_incident_category_type    ||--o{ fact_client_incident : "dim_client_incident_category_type_key"
    dim_client_incident_severity         ||--o{ fact_client_incident : "dim_current_client_incident_severity_key"
    dim_client_incident_status_type      ||--o{ fact_client_incident : "dim_current_client_incident_status_type_key"
    dim_client_team                     ||--o{ fact_client_incident : "dim_client_team_key"
    dim_company                         ||--o{ fact_client_incident : "dim_company_key"
    dim_employee                        ||--o{ fact_client_incident : "5 employee roles"
    dim_date                            ||--o{ fact_client_incident : "incident / created date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_incident AS fact
INNER JOIN edw.dim_client_incident AS inc
    ON fact.incident_id = inc.incident_id
    AND inc.DWHIsCurrent = 1
INNER JOIN edw.dim_client_incident_status_type AS st
    ON fact.current_incident_status_type_id = st.incident_status_type_id
    AND st.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_incident` |
| Landing | `landing.edw_fact_client_incident` |
| Staging | `staging.ODSETLfact_client_incident` |
| Stored procedures | `staging.insert_staging_fact_client_incident`, `edw.Updateedwfact_client_incident` |
| Target | `edw.fact_client_incident` |
