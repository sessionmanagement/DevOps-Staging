# dim_client_interaction_type

[[_TOC_]]

Classification of client interaction types, with a parent/child category structure. One of the newer additions to the client subject area.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `803` |
| Target table | `edw.dim_client_interaction_type` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Recordbase (unconfirmed — see below) |

## Data lineage

```text
Recordbase (source object unconfirmed)
  └─ ODS view: ETL.dim_client_interaction_type
       └─ landing.edw_dim_client_interaction_type             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_interaction_type      (staging.insert_staging_dim_client_interaction_type)
                 └─ edw.dim_client_interaction_type           (edw.Updateedwdim_client_interaction_type)
```

> **Lineage gap.** This table does not appear in the ODS ETL view lineage extract, so its exact Recordbase source object(s) are unconfirmed. It is assumed to be Recordbase-sourced by naming convention and its presence alongside the other `dim_client_*` loads, but this should be verified against `ETL.dim_client_interaction_type`'s view definition directly.

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_interaction_type_key` | `int` | Surrogate primary key | — |
| `client_interaction_type_id` | `int` | Business key | Recordbase |
| `company_key` | `int` | Business key — **ambiguous, no `dim_` prefix** | `edw.dim_company` (relationship unconfirmed) |
| `client_parent_interaction_type_code` | `nvarchar(20)` | Self-referencing parent | `client_interaction_type_code` on this table |

::: mermaid
erDiagram
    dim_client_interaction_type ||--o{ dim_client_interaction_type : "parent / child hierarchy"
    dim_client_interaction_type ||--o{ fact_client_interaction : "dim_client_interaction_type_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_interaction_type` |
| Landing | `landing.edw_dim_client_interaction_type` |
| Staging | `staging.ODSETLdim_client_interaction_type` |
| Stored procedures | `staging.insert_staging_dim_client_interaction_type`, `edw.Updateedwdim_client_interaction_type` |
| Target | `edw.dim_client_interaction_type` |

## Notes

### company_key is a third, ambiguous naming pattern

This table uses `company_key` — neither the raw `company_id` pattern used by most client dimensions, nor the surrogate `dim_company_key` pattern used by the incident dimensions. It is unclear from the column name alone whether it is a business key or a surrogate FK; confirm against the ODS view before joining to `edw.dim_company`.

### Parent reference uses code, not id

Unlike `dim_client_activity_breakdown_type` and `dim_client_incident_category_type` (which self-reference via their integer business key), this table's parent reference (`client_parent_interaction_type_code`) points at the `_code` column rather than `client_interaction_type_id`.
