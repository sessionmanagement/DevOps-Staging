# dim_client_incident_severity

[[_TOC_]]

Severity classification applied to a client incident, with an active/inactive flag.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `730` |
| Target table | `edw.dim_client_incident_severity` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_incident_severity
       └─ landing.edw_dim_client_incident_severity             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_incident_severity      (staging.insert_staging_dim_client_incident_severity)
                 └─ edw.dim_client_incident_severity           (edw.Updateedwdim_client_incident_severity)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dlDimIncidentSeverity` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_incident_severity_key` | `int` | Surrogate primary key | — |
| `incident_severity_id` | `int` | Business key | Recordbase |
| `dim_client_incident_company_key_severity_id_key` | `bigint` | Compound company + severity lookup key | — |
| `dim_company_key` | `int` | Dimension foreign key | `edw.dim_company.dim_company_key` |

::: mermaid
erDiagram
    dim_company                 ||--o{ dim_client_incident_severity : "dim_company_key"
    dim_client_incident_severity ||--o{ fact_client_incident : "incident_severity_id"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_incident_severity` |
| Landing | `landing.edw_dim_client_incident_severity` |
| Staging | `staging.ODSETLdim_client_incident_severity` |
| Stored procedures | `staging.insert_staging_dim_client_incident_severity`, `edw.Updateedwdim_client_incident_severity` |
| Target | `edw.dim_client_incident_severity` |

## Notes

Both `incident_severity_value` and `incident_severity_text` are carried — confirm which is the display label before building reports, as the two are populated from different source fields and may not always agree.
