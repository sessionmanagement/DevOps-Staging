# fact_client_incident_person

[[_TOC_]]

Bridge/fact table connecting clients involved in health & safety / operational incidents recorded in Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `743` |
| Target table | `edw.fact_client_incident_person` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ dlFactIncidentPerson
       └─ ODS view: ETL.fact_client_incident_person
            └─ landing.edw_fact_client_incident_person             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_incident_person      (staging.insert_staging_fact_client_incident_person)
                      └─ edw.fact_client_incident_person           (edw.Updateedwfact_client_incident_person)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_incident_person_key` | `int` | Surrogate primary key | — |
| `incident_id` | `int` | Business key | `edw.dim_client_incident.incident_id` |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `dim_client_incident_key` | `int` | Dimension foreign key | `edw.dim_client_incident.dim_client_incident_key` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_client_incident_company_key_incident_id_key` | `bigint` | Compound lookup key | — |

::: mermaid
erDiagram
    dim_client_incident ||--o{ fact_client_incident_person : "incident_id / dim_client_incident_key"
    dim_client          ||--o{ fact_client_incident_person : "client_id / dim_client_key"
    dim_company         ||--o{ fact_client_incident_person : "dim_company_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_incident_person AS fact
INNER JOIN edw.dim_client_incident AS inc
    ON fact.incident_id = inc.incident_id
    AND inc.DWHIsCurrent = 1
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_incident_person` |
| Landing | `landing.edw_fact_client_incident_person` |
| Staging | `staging.ODSETLfact_client_incident_person` |
| Stored procedures | `staging.insert_staging_fact_client_incident_person`, `edw.Updateedwfact_client_incident_person` |
| Target | `edw.fact_client_incident_person` |
