# dim_vehicle

[[_TOC_]]

Fleet motor vehicle asset dimension — tracks organizational vehicles, registration number plates, vehicle make/model/year, and NZTA WoF, license, and Road User Charges (RUC) compliance dates sourced from the **Tapu Waka** fleet management API.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `786` |
| Target table | `edw.dim_vehicle` |
| Load type | `ODSFLLMRGIRV` — ODS: Full row-versioned merged |
| Load phase | `101 Dimensions` |
| Highwater / Incremental / Merged | No / No / Yes |
| SCD behaviour | Type 2 (row-versioned) |
| Source system | Tapu Waka (REST API) |

## Data lineage

```text
Tapu Waka (REST API)
  └─ asset
       └─ ODS view: ETL.dim_vehicle
            └─ landing.edw_dim_vehicle             (TRUNCATE + full Copy)
                 └─ staging.ODSETLdim_vehicle      (staging.insert_staging_dim_vehicle)
                      └─ edw.dim_vehicle           (edw.Updateedwdim_vehicle)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `dim_vehicle_key` | `int` | Surrogate primary key (identity 1, 1) | — |
| `vehicle_id` | `varchar(40)` | Primary business key (Tapu Waka asset ID) | Tapu Waka |
| `vehicle_number_plate` | `nvarchar(255)` | Vehicle registration number plate | — |
| `vehicle_name` | `nvarchar(255)` | Vehicle display name | — |
| `vehicle_make` / `vehicle_model` | `nvarchar(255)` | Vehicle manufacturer and model | — |
| `vehicle_year` | `int` | Manufacture year | — |
| `vehicle_type` / `vehicle_class` | `nvarchar` | Vehicle classification | — |
| `vehicle_nzta_wof_expiry_date` | `datetime2(7)` | Warrant of Fitness (WoF) expiry | — |
| `vehicle_nzta_wof_type` | `nvarchar(50)` | WoF / CoF inspection type | — |
| `vehicle_nzta_license_expiry_date` | `datetime2(7)` | Vehicle license / registration expiry | — |
| `vehicle_nzta_fuel_type` | `nvarchar(50)` | Fuel type (Petrol, Diesel, EV, Hybrid) | — |
| `vehicle_nzta_subject_to_ruc` | `int` | Road User Charges subject flag | — |
| `vehicle_nzta_ruc_expiry` / `expiry_date` | `int` / `datetime2` | RUC distance and expiry date | — |

::: mermaid
erDiagram
    dim_vehicle ||--o{ fact_vehicle_trip : "vehicle_id / dim_vehicle_key"
:::

## Direct business key join pattern

To join using `vehicle_id`, match directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_vehicle_trip AS fact
INNER JOIN edw.dim_vehicle AS v
    ON fact.vehicle_id = v.vehicle_id
    AND v.DWHIsCurrent = 1
```

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.dim_vehicle` |
| Landing | `landing.edw_dim_vehicle` |
| Staging | `staging.ODSETLdim_vehicle` |
| Stored procedures | `staging.insert_staging_dim_vehicle`, `edw.Updateedwdim_vehicle` |
| Target | `edw.dim_vehicle` |

## Notes

- **NZTA Compliance tracking**: Enables fleet management reports on impending Warrant of Fitness, vehicle licensing, and RUC expiry across the organizational fleet.
