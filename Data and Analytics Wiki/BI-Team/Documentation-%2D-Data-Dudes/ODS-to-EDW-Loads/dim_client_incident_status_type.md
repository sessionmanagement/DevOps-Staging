# dim_client_incident_status_type

[[_TOC_]]

Status classification for a client incident's investigation workflow (e.g. open, under investigation, closed), grouped into a status group category.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `731` |
| Target table | `edw.dim_client_incident_status_type` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_incident_status_type
       └─ landing.edw_dim_client_incident_status_type             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_incident_status_type      (staging.insert_staging_dim_client_incident_status_type)
                 └─ edw.dim_client_incident_status_type           (edw.Updateedwdim_client_incident_status_type)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlDimIncidentStatusType` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_incident_status_type_key` | `int` | Surrogate primary key | — |
| `incident_status_type_id` | `int` | Business key | Recordbase |
| `dim_client_incident_company_key_status_type_id_key` | `bigint` | Compound company + status lookup key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |

::: mermaid
erDiagram
    dim_company                    ||--o{ dim_client_incident_status_type : "dim_company_key"
    dim_client_incident_status_type ||--o{ fact_client_incident : "current_incident_status_type_id"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_incident_status_type` |
| Landing | `landing.edw_dim_client_incident_status_type` |
| Staging | `staging.ODSETLdim_client_incident_status_type` |
| Stored procedures | `staging.insert_staging_dim_client_incident_status_type`, `edw.Updateedwdim_client_incident_status_type` |
| Target | `edw.dim_client_incident_status_type` |

## Notes

`incident_status_type_group` groups individual status values into a higher-level category (e.g. open vs. closed), useful for status funnels without enumerating every individual status value.
