# fact_vehicle_trip

[[_TOC_]]

GPS telematics trip log for fleet vehicles — records trip start/end timestamps, GPS coordinates, start/end addresses, matched driver employees, trip distances, and speeding compliance metrics sourced from **Tapu Waka**.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `787` |
| Target table | `edw.fact_vehicle_trip` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Source system | Tapu Waka (REST API) |

## Data lineage

```text
Tapu Waka (REST API)
  ├─ asset_trip
  └─ contact
       └─ ODS view: ETL.fact_vehicle_trip
            └─ landing.edw_fact_vehicle_trip             (TRUNCATE + full Copy)
                 └─ staging.ODSETLfact_vehicle_trip      (staging.insert_staging_fact_vehicle_trip)
                      └─ edw.fact_vehicle_trip           (edw.Updateedwfact_vehicle_trip)
```

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_vehicle_trip_key` | `int` | Surrogate primary key (identity 1, 1) | — |
| `vehicle_trip_id` | `varchar(100)` | Primary business key (Tapu Waka trip ID) | Tapu Waka |
| `dim_vehicle_key` | `int` | Dimension foreign key | `edw.dim_vehicle.dim_vehicle_key` |
| `dim_employee_key` | `int` | Dimension foreign key | `edw.dim_employee.dim_employee_key` |
| `vehicle_id` | `varchar(40)` | Business key (vehicle) | `edw.dim_vehicle.vehicle_id` |
| `employee_id` | `int` | Business key (driver employee) | `edw.dim_employee.employee_id` |

::: mermaid
erDiagram
    dim_vehicle  ||--o{ fact_vehicle_trip : "vehicle_id / dim_vehicle_key"
    dim_employee ||--o{ fact_vehicle_trip : "employee_id / dim_employee_key"
:::

## Direct business key join pattern

To join using `vehicle_id` and `employee_id`, match directly and filter `DWHIsCurrent = 1`:

```sql
FROM edw.fact_vehicle_trip AS fact
INNER JOIN edw.dim_vehicle AS v
    ON fact.vehicle_id = v.vehicle_id
    AND v.DWHIsCurrent = 1
LEFT JOIN edw.dim_employee AS e
    ON fact.employee_id = e.employee_id
    AND e.DWHIsCurrent = 1
```

## Telematics metrics & attributes

- **Timestamps & Geolocation**: `start_timestamp`, `end_timestamp`, `start_point_latitude`, `start_point_longitude`, `start_address`, `end_point_latitude`, `end_point_longitude`, `end_address`, `is_towed`.
- **Driver identification**: `driver_full_name`, `driver_email_address` (used in staging to resolve `dim_employee_key`).
- **Distance & Speed measures**: `distance_meters`, `distance_meters_offroad`, `average_speed`, `max_speed`, `num_polls`.
- **Speed compliance bands**:
  - On-road: `on_road_within_speed_limit`, `on_road_over_speed_limit_band1` to `band5`.
  - Off-road: `offroad_within_speed_limit`, `offroad_over_speed_limit_band1` to `band5`.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_vehicle_trip` |
| Landing | `landing.edw_fact_vehicle_trip` |
| Staging | `staging.ODSETLfact_vehicle_trip` |
| Stored procedures | `staging.insert_staging_fact_vehicle_trip`, `edw.Updateedwfact_vehicle_trip` |
| Target | `edw.fact_vehicle_trip` |

## Notes

- **Driver resolution logic**: Staging matches driver full name and email address against `edw.dim_employee` to resolve `employee_id` and `dim_employee_key`. If unassigned or unmatched, defaults to Unknown (`-1`).
