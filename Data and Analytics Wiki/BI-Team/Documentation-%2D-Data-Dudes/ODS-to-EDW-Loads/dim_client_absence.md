# dim_client_absence

[[_TOC_]]

Client absence periods (e.g. leave from a residential or supported service), with approval and reason detail. Despite the `dim_` name, this table is configured to run in the **Facts** load phase.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `641` |
| Target table | `edw.dim_client_absence` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `200 Facts` _(see [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Dimension-Load-Overview#known-issues))_ |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source systems | Recordbase (rbeal, rbmnb) |

## Data lineage

```text
Recordbase EAL (rbeal) / Recordbase MNB (rbmnb)
  └─ ODS view: ETL.dim_client_absence
       └─ landing.edw_dim_client_absence             (TRUNCATE + full Copy)
            └─ staging.ODSETLdim_client_absence      (staging.insert_staging_dim_client_absence)
                 └─ edw.dim_client_absence           (edw.Updateedwdim_client_absence)
```

### Source objects behind the ODS view

| Source | Contributing objects |
| --- | --- |
| `rbeal` | `dldimlookup`, `dlDimPersonStatusType`, `dlFactPersonStatus` |
| `rbmnb` | Same object set as `rbeal` |

## Key fields and attributes

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_client_absence_key` | `int` | Surrogate primary key | — |
| `dim_client_key` | `int` | Dimension foreign key | `edw.dim_client.dim_client_key` |
| `dim_client_unique_key` | `varchar(30)` | Business key | `edw.dim_client.dim_client_unique_key` |
| `company_id` | `int` | Business key (raw) | `edw.dim_company.company_id` |
| `client_id` | `int` | Business key (lookup) | `edw.dim_client.client_id` |
| `client_absence_reason_id` | `int` | Business key | Recordbase lookup |

::: mermaid
erDiagram
    dim_client ||--o{ dim_client_absence : "dim_client_key"
:::

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_client_absence` |
| Landing | `landing.edw_dim_client_absence` |
| Staging | `staging.ODSETLdim_client_absence` |
| Stored procedures | `staging.insert_staging_dim_client_absence`, `edw.Updateedwdim_client_absence` |
| Target | `edw.dim_client_absence` |

## Notes

### Only one dependency — placement in Facts phase looks avoidable

Unlike `dim_client_person_relationship`, this table only depends on `dim_client` (phase `101`). It did not need to wait until phase `200` to load safely — its Facts-phase placement looks more like an inconsistency in how it was classified than a genuine sequencing requirement. See [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Dimension-Load-Overview#known-issues).

### No measures

This is a factless table — it records an absence event and its reason, with no additive measures.
