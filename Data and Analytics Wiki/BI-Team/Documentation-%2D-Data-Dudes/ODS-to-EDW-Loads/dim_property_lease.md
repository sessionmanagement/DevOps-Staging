# dim_property_lease

[[_TOC_]]

Lease agreements held against a property — the contract under which Emerge leases a property _in_, as distinct from a tenancy, which is the agreement under which a property is let _out_.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `532` |
| Target table | `edw.dim_property_lease` |
| Load type | `ODSINCHWTMRG` — ODS: Incremental by highwater row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | Yes / Yes / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.dim_property_lease
       └─ landing.edw_dim_property_lease             (TRUNCATE + Copy, highwater-filtered)
            └─ staging.ODSETLdim_property_lease      (staging.insert_staging_dim_property_lease)
                 └─ edw.dim_property_lease           (edw.Updateedwdim_property_lease)
```

### Distinguishing source views

`vw_zav_leasedetails`, `vw_zav_leasecontract`, `vw_team`

Plus the [common Zavanti metadata views](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_property_lease_id` | `int` | Surrogate primary key | — |
| `dim_property_key` | `int` | Dimension foreign key _(snowflake)_ | `edw.dim_property.dim_property_key` |
| `property_lease_details_id` | `nvarchar(40)` | Business key | Zavanti `vw_zav_leasedetails` |
| `property_id` | `nvarchar(40)` | Business key (parent property) | Zavanti `vw_zav_property` |

::: mermaid
erDiagram
    dim_property ||--o{ dim_property_lease : "dim_property_key"
:::

## Incremental behaviour

`IsHighwater = 1`. Only rows changed since the last watermark are copied to landing. Force a full reload with `DataLoadId = 532` and `ForceFullLoadFlag = true`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_property_lease` |
| Landing | `landing.edw_dim_property_lease` |
| Staging | `staging.ODSETLdim_property_lease` |
| Stored procedures | `staging.insert_staging_dim_property_lease`, `edw.Updateedwdim_property_lease`, highwater procedure |
| Target | `edw.dim_property_lease` |

## Notes

### Surrogate key naming

The surrogate key is `dim_property_lease_id`, not `dim_property_lease_key`. This departs from the `[table]_key` standard and is shared with `dim_property_maintenace_type` and `dim_property_program`.

### Business key type drift

`property_id` is `nvarchar(40)` here but `uniqueidentifier` on [dim_property](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property). Joining the two on the business key requires a cast — join on `dim_property_key` instead.

### Intra-phase dependency

This load holds a FK to `dim_property` (DataLoadId 558) but shares phase `101` with it, so the two run in parallel. See [Known issues](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview).
