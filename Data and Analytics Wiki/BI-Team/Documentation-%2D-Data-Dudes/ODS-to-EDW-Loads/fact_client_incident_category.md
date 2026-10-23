# fact_client_incident_category

[[_TOC_]]

Bridge/fact table mapping client incidents to one or more incident category types in Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `737` |
| Target table | `edw.fact_client_incident_category` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ dlFactIncidentCategory
       └─ ODS view: ETL.fact_client_incident_category
            └─ landing.edw_fact_client_incident_category             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_incident_category      (staging.insert_staging_fact_client_incident_category)
                      └─ edw.fact_client_incident_category           (edw.Updateedwfact_client_incident_category)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_incident_category_key` | `int` | Surrogate primary key | — |
| `incident_id` | `int` | Business key | `edw.dim_client_incident.incident_id` |
| `incident_category_type_id` | `int` | Business key | `edw.dim_client_incident_category_type.incident_category_type_id` |
| `dim_client_incident_key` | `int` | Dimension foreign key | `edw.dim_client_incident.dim_client_incident_key` |
| `dim_client_incident_category_type_key` | `int` | Dimension foreign key | `edw.dim_client_incident_category_type.dim_client_incident_category_type_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `dim_client_incident_company_key_incident_id_key` | `bigint` | Compound lookup key | — |
| `dim_client_incident_company_key_category_type_id_key` | `bigint` | Compound lookup key | — |

::: mermaid
erDiagram
    dim_client_incident               ||--o{ fact_client_incident_category : "incident_id / dim_client_incident_key"
    dim_client_incident_category_type  ||--o{ fact_client_incident_category : "incident_category_type_id / dim_client_incident_category_type_key"
    dim_company                       ||--o{ fact_client_incident_category : "dim_company_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_incident_category AS fact
INNER JOIN edw.dim_client_incident AS inc
    ON fact.incident_id = inc.incident_id
    AND inc.DWHIsCurrent = 1
INNER JOIN edw.dim_client_incident_category_type AS cat
    ON fact.incident_category_type_id = cat.incident_category_type_id
    AND cat.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_incident_category` |
| Landing | `landing.edw_fact_client_incident_category` |
| Staging | `staging.ODSETLfact_client_incident_category` |
| Stored procedures | `staging.insert_staging_fact_client_incident_category`, `edw.Updateedwfact_client_incident_category` |
| Target | `edw.fact_client_incident_category` |
