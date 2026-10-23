# fact_property_maintenance_task

[[_TOC_]]

Maintenance tasks carried out on a property — the work items, contractor activity, costs and completion milestones behind a maintenance job.

## Load identity

| Property | Value |
| --- | --- |
| DataLoadId | `623` |
| Target table | `edw.fact_property_maintenance_task` |
| Load type | `ODSFLLMRG` — ODS: Full non-versioned merged |
| Load phase | `200 Facts` |
| Highwater / Incremental / Merged | No / No / Yes |
| Source system | Zavanti (Waharoa) — Dataverse D365 |

## Data lineage

```
Zavanti (Dataverse D365)
  └─ ODS view: ETL.fact_property_maintenance_task
       └─ landing.edw_fact_property_maintenance_task             (TRUNCATE + full Copy)
            └─ staging.ODSETLfact_property_maintenance_task      (staging.insert_staging_fact_property_maintenance_task)
                 └─ edw.fact_property_maintenance_task           (edw.Updateedwfact_property_maintenance_task)
```

### Distinguishing source views

`vw_zav_maintenancetask`, `vw_zav_maintenancedetail`, `vw_zav_maintenancetype`, `vw_zav_propertyassets`, `vw_zav_location`, `vw_zav_informationcodedetails`, `vw_opportunity`

Seven distinguishing source views — the widest source footprint of any property fact.

## Key fields and relationships

| Column | Type | Role | Links to |
| --- | --- | --- | --- |
| `fact_property_maintenance_task_key` | `int` | Surrogate primary key | — |
| `property_maintenance_task_id` | `uniqueidentifier` | Business key (grain) | Zavanti `vw_zav_maintenancetask` |
| `dim_property_maintenance_key` | `int` | Dimension foreign key | `edw.dim_property_maintenance` |
| `dim_property_maintenace_type_key` | `int` | Dimension foreign key | `edw.dim_property_maintenace_type` |
| `dim_property_key` | `int` | Dimension foreign key | `edw.dim_property` |
| `dim_property_detail_key` | `int` | Dimension foreign key | `edw.dim_property_detail` |
| `dim_property_healthy_homes_key` | `int` | Dimension foreign key | `edw.dim_property_healthy_homes` |
| `dim_property_tenancy_key` | `int` | Dimension foreign key | `edw.dim_property_tenancy` |
| `dim_property_program_key` | `int` | Dimension foreign key | `edw.dim_property_program` |
| `property_maintenance_id` | `uniqueidentifier` | Business key (parent job) | Zavanti |
| `property_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_maintenance_type_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_maintenace_type_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_tenancy_type_id` | `uniqueidentifier` | Business key | Zavanti |
| `property_program_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |
| `property_subprogram_id` | `uniqueidentifier` | Business key (lookup) | Zavanti |

### Role-playing date keys

Ten date keys, all `int` foreign keys to `edw.dim_date`:

| Column | Milestone |
| --- | --- |
| `property_maintenance_task_acknowledgment_date_key` | Task acknowledged |
| `property_maintenance_task_acknowledgment_end_date_key` | Acknowledgement window closed |
| `property_maintenance_task_expected_onsite_date_key` | Contractor expected on site |
| `property_maintenance_task_expected_completion_date_key` | Expected completion |
| `property_maintenance_task_contractor_work_completion_date_key` | Contractor reported completion |
| `property_maintenance_task_actual_completion_date_key` | Actual completion |
| `property_maintenance_task_contractor_status_date_key` | Contractor status last changed |
| `property_maintenance_assets_installation_date_key` | Asset installed |
| `property_maintenance_task_total_capped_amount_date_key` | See [Notes](#notes) |
| `property_maintenance_task_web_expenses_amount_date_key` | See [Notes](#notes) |

::: mermaid
erDiagram
    dim_property_maintenance     ||--o{ fact_property_maintenance_task : ""
    dim_property_maintenace_type ||--o{ fact_property_maintenance_task : ""
    dim_property                 ||--o{ fact_property_maintenance_task : ""
    dim_property_detail          ||--o{ fact_property_maintenance_task : ""
    dim_property_healthy_homes   ||--o{ fact_property_maintenance_task : ""
    dim_property_tenancy         ||--o{ fact_property_maintenance_task : ""
    dim_property_program         ||--o{ fact_property_maintenance_task : ""
    dim_date                     ||--o{ fact_property_maintenance_task : "10 roles"
:::

## Load behaviour

`IsHighwater = 0`, `IsIncremental = 0`, `IsMerged = 1` with **no row versioning**. Prior values are overwritten on each run.

## Objects touched

| Layer | Object |
| --- | --- |
| ODS | `ETL.fact_property_maintenance_task` |
| Landing | `landing.edw_fact_property_maintenance_task` |
| Staging | `staging.ODSETLfact_property_maintenance_task` |
| Stored procedures | `staging.insert_staging_fact_property_maintenance_task`, `edw.Updateedwfact_property_maintenance_task` |
| Target | `edw.fact_property_maintenance_task` |

## Notes

### Two date keys that look like amounts

`property_maintenance_task_total_capped_amount_date_key` and `property_maintenance_task_web_expenses_amount_date_key` combine "amount" and "date_key" in the same name. Either they are dates associated with a capped amount and a Web Expenses claim, or they are misnamed. Both are `int`, consistent with a `dim_date` key, but the naming should be confirmed against the ODS view before use in reporting.

### Duplicate maintenance type business keys

`property_maintenance_type_id` and `property_maintenace_type_id` are both present, differing only by the missing `n` in the second. This mirrors the misspelling in the [dim_property_maintenace_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_maintenace_type) object name. Confirm whether both are populated and which the dimension key resolves from.

### Link to Web Expenses

The Web Expenses reference suggests maintenance spend reconciles against `edw.fact_webexpenses`. There is no `dim_webexpense_key` on this fact, so any such reconciliation is currently done by amount and date rather than by key.
