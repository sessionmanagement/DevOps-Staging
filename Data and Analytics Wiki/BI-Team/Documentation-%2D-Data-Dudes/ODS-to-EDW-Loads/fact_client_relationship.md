# fact_client_relationship

[[_TOC_]]

Client-to-client relationship facts (e.g. family, whānau, carer, dependent links between primary and related clients), sourced from Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `739` |
| Target table | `edw.fact_client_relationship` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  ├─ dlFactPersonLinkRelationship
  ├─ dlfactPersonlink
  ├─ dlDimPerson
  └─ dldimlookup
       └─ ODS view: ETL.fact_client_relationship
            └─ landing.edw_fact_client_relationship             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_relationship      (staging.insert_staging_fact_client_relationship)
                      └─ edw.fact_client_relationship           (edw.Updateedwfact_client_relationship)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_relationship_key` | `int` | Surrogate primary key | — |
| `client_relationship_id` | `int` | Business key | Recordbase |
| `primary_client_id` | `int` | Business key (primary client) | `edw.dim_client.client_id` |
| `related_client_id` | `int` | Business key (related client) | `edw.dim_client.client_id` |
| `dim_primary_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_related_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `client_relationship_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `client_relationship_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |

::: mermaid
erDiagram
    dim_client  ||--o{ fact_client_relationship : "primary_client_id / dim_primary_client_key"
    dim_client  ||--o{ fact_client_relationship : "related_client_id / dim_related_client_key"
    dim_company ||--o{ fact_client_relationship : "dim_company_key"
    dim_date    ||--o{ fact_client_relationship : "start / end date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_relationship AS fact
INNER JOIN edw.dim_client AS c_primary
    ON fact.primary_client_id = c_primary.client_id
    AND c_primary.DWHIsCurrent = 1
INNER JOIN edw.dim_client AS c_related
    ON fact.related_client_id = c_related.client_id
    AND c_related.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_relationship` |
| Landing | `landing.edw_fact_client_relationship` |
| Staging | `staging.ODSETLfact_client_relationship` |
| Stored procedures | `staging.insert_staging_fact_client_relationship`, `edw.Updateedwfact_client_relationship` |
| Target | `edw.fact_client_relationship` |
