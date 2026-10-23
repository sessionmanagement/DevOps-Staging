# fact_client_interaction

[[_TOC_]]

Client interaction events, date/time timestamps, and interaction comments, connecting clients to interaction types and staff.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `802` |
| Target table | `edw.fact_client_interaction` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source system | Recordbase (unconfirmed — see notes) |

## Data lineage

```text
Recordbase (source objects unconfirmed)
  └─ ODS view: ETL.fact_client_interaction
       └─ landing.edw_fact_client_interaction             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_client_interaction      (staging.insert_staging_fact_client_interaction)
                 └─ edw.fact_client_interaction           (edw.Updateedwfact_client_interaction)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_interaction_key` | `int` | Surrogate primary key | — |
| `client_interaction_id` | `int` | Business key | Recordbase |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_interaction_type_id` | `int` | Business key | `edw.dim_client_interaction_type.client_interaction_type_id` |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_interaction_type_key` | `int` | Dimension foreign key | `edw.dim_client_interaction_type.dim_client_interaction_type_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |

::: mermaid
erDiagram
    dim_client                  ||--o{ fact_client_interaction : "client_id / dim_client_key"
    dim_client_interaction_type ||--o{ fact_client_interaction : "client_interaction_type_id"
    dim_employee                ||--o{ fact_client_interaction : "dim_employee_key"
    dim_company                 ||--o{ fact_client_interaction : "dim_company_key"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_interaction AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
INNER JOIN edw.dim_client_interaction_type AS it
    ON fact.client_interaction_type_id = it.client_interaction_type_id
    AND it.DWHIsCurrent = 1
```

## Attributes & Comments

- `client_interaction_date` (`datetime2(7)`), `client_interaction_created_date` (`datetime`)
- `client_interaction_comments` (`nvarchar(max)`)

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_interaction` |
| Landing | `landing.edw_fact_client_interaction` |
| Staging | `staging.ODSETLfact_client_interaction` |
| Stored procedures | `staging.insert_staging_fact_client_interaction`, `edw.Updateedwfact_client_interaction` |
| Target | `edw.fact_client_interaction` |

## Notes

- Loaded as `ODSFLLMRG` (Type 1 non-versioned merge).
- Lineage details in ODS to be confirmed against source view definition.
