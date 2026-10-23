# dim_client_incident

[[_TOC_]]

Client incident header — one row per incident version, including narrative fields (description, location, immediate actions, investigation and outcome details).

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `728` |
| Target table | `edw.dim_client_incident` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_incident
       └─ landing.edw_dim_client_incident             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_incident      (staging.insert_staging_dim_client_incident)
                 └─ edw.dim_client_incident           (edw.Updateedwdim_client_incident)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlFactIncident` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_incident_key` | `int` | Surrogate primary key | — |
| `incident_id` | `int` | Business key | Recordbase |
| `dim_client_incident_company_key_incident_id_key` | `bigint` | Compound company + incident lookup key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |

::: mermaid
erDiagram
    dim_company        ||--o{ dim_client_incident : "dim_company_key"
    dim_client_incident ||--o{ fact_client_incident : "dim_client_incident_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_incident` |
| Landing | `landing.edw_dim_client_incident` |
| Staging | `staging.ODSETLdim_client_incident` |
| Stored procedures | `staging.insert_staging_dim_client_incident`, `edw.Updateedwdim_client_incident` |
| Target | `edw.dim_client_incident` |

## Notes

### Uses a surrogate dim_company_key, unlike most of the client group

This table (and its three `dim_client_incident_*` peers) resolve company via `dim_company_key`, while `dim_client` and most other client dimensions use a raw `company_id`. See [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Dimension-Load-Overview) for the full comparison.

### Long narrative text fields

Six columns (`incident_description`, `incident_location`, `incident_immediate_action_taken`, `incident_possible_prevention`, `incident_further_action_required`, `incident_investigation_details`, `incident_outcome_details`) are `nvarchar(max)` free text. Full-text search or a separate reporting extract may be preferable to loading these into general-purpose semantic models.
