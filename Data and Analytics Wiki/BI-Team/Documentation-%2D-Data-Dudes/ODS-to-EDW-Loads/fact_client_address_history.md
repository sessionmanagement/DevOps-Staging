# fact_client_address_history

[[_TOC_]]

Historical address tracking for clients, sourced from Recordbase (`rbeal` and `rbmnb`).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `482` |
| Target table | `edw.fact_client_address_history` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ dlfactaddress
       └─ ODS view: ETL.fact_client_address_history
            └─ landing.edw_fact_client_address_history             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_client_address_history      (staging.insert_staging_fact_client_address_history)
                      └─ edw.fact_client_address_history           (edw.Updateedwfact_client_address_history)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_client_address_history_key` | `int` | Surrogate primary key | — |
| `fact_client_address_history_unique_key` | `nvarchar(200)` | Compound natural key | — |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `client_id` | `int` | Business key | `edw.dim_client.client_id` |
| `client_address_id` | `int` | Business key | Recordbase |
| `client_address_created_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `client_address_start_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |
| `client_address_end_date_key` | `int` | Role-playing date FK | `edw.dim_date.dim_date_key` |

::: mermaid
erDiagram
    dim_client  ||--o{ fact_client_address_history : "client_id / dim_client_key"
    dim_company ||--o{ fact_client_address_history : "dim_company_key"
    dim_date    ||--o{ fact_client_address_history : "created / start / end date keys"
:::

## Direct business key join pattern

```sql
FROM edw.fact_client_address_history AS fact
INNER JOIN edw.dim_client AS c
    ON fact.client_id = c.client_id
    AND c.DWHIsCurrent = 1
```

## Attributes

- Address details: `client_address_name`, `client_address_line1`, `client_address_line2`, `client_address_line3`, `client_address_suburb`, `client_address_town_or_city`, `client_address_post_code`.
- `client_address_is_primary_address_flag` (`int`).

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_client_address_history` |
| Landing | `landing.edw_fact_client_address_history` |
| Staging | `staging.ODSETLfact_client_address_history` |
| Stored procedures | `staging.insert_staging_fact_client_address_history`, `edw.Updateedwfact_client_address_history` |
| Target | `edw.fact_client_address_history` |
