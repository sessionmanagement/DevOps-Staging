# dim_client_incident_category_type

[[_TOC_]]

Classification of client incident categories, with a self-referencing parent/child hierarchy and an active/inactive flag.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `729` |
| Target table | `edw.dim_client_incident_category_type` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_incident_category_type
       └─ landing.edw_dim_client_incident_category_type             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_incident_category_type      (staging.insert_staging_dim_client_incident_category_type)
                 └─ edw.dim_client_incident_category_type           (edw.Updateedwdim_client_incident_category_type)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlDimIncidentCategoryType` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_incident_category_type_key` | `int` | Surrogate primary key | — |
| `incident_category_type_id` | `int` | Business key | Recordbase |
| `dim_client_incident_company_key_category_type_id_key` | `bigint` | Compound company + category lookup key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |
| `incident_category_type_parent_Id` | `int` | Self-referencing parent | `incident_category_type_id` on this table |

::: mermaid
erDiagram
    dim_company                       ||--o{ dim_client_incident_category_type : "dim_company_key"
    dim_client_incident_category_type ||--o{ dim_client_incident_category_type : "parent / child hierarchy"
    dim_client_incident_category_type ||--o{ dim_client_incident : "incident_category_type_id"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_incident_category_type` |
| Landing | `landing.edw_dim_client_incident_category_type` |
| Staging | `staging.ODSETLdim_client_incident_category_type` |
| Stored procedures | `staging.insert_staging_dim_client_incident_category_type`, `edw.Updateedwdim_client_incident_category_type` |
| Target | `edw.dim_client_incident_category_type` |

## Notes

### Column name casing

`incident_category_type_parent_Id` has an unusual internal capital `I` in `Id`, inconsistent with the `_id` suffix convention used elsewhere. Preserve exactly in queries.
