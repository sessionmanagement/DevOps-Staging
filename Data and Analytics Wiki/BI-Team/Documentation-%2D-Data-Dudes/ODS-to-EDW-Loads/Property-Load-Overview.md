# Property Load Overview

[[_TOC_]]

The property subject area is sourced entirely from **Zavanti (Waharoa)**, a Dynamics 365 / Dataverse application. Zavanti is one of two source systems that bypass blob landing entirely — the ODS reads it through direct-connect views rather than external tables over Parquet files.

This page covers all **25 property loads** — 12 dimensions and 13 facts.

## Execution order

`10_Load_Master` runs load phases sequentially in `DataLoadPhaseNo` order. Within a phase, `20_Load_Phase` runs loads **in parallel**, up to 5 concurrently.

| Phase | Property loads |
| --- | --- |
| `100 Facts` | `fact_property_remedy_notice`, `fact_property_tribunal_order` |
| `101 Dimensions` | `dim_property`, `dim_property_detail`, `dim_property_healthy_homes`, `dim_property_lease`, `dim_property_maintenace_type`, `dim_property_maintenance`, `dim_property_program`, `dim_property_tenancy`, `dim_property_breach_type`, `dim_void_category` |
| `102 Dimensions` | `dim_property_inspection_detail` |
| `103 Dimensions` | `dim_property_arrears_arrangement` |
| `200 Facts` | `fact_property_arrears_transaction`, `fact_property_hazard`, `fact_property_inspection`, `fact_property_maintenance_task`, `fact_property_rent_charges`, `fact_property_tenancy_breach`, `fact_property_tenancy_transaction`, `fact_property_tenant`, `fact_property_void_checklist`, `fact_void_checklist` |
| `201 Facts` | `fact_property_risk` |

> **Note.** Phase `100 Facts` sorts **before** every dimension phase, so `fact_property_remedy_notice` and `fact_property_tribunal_order` load ahead of the dimensions they reference. See [Known issues](#known-issues).

## Load inventory

| DataLoadId | Target table | Load type | Phase | Incremental |
| --- | --- | --- | --- | --- |
| 532 | [dim_property_lease](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_lease) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 533 | [dim_property_program](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_program) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 537 | [dim_property_maintenace_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_maintenace_type) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 558 | [dim_property](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 559 | [dim_property_detail](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_detail) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 560 | [dim_property_healthy_homes](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_healthy_homes) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 612 | [dim_property_maintenance](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_maintenance) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 613 | [dim_property_tenancy](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_tenancy) | `ODSINCHWTMRG` | 101 | Yes (highwater) |
| 676 | [dim_void_category](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_void_category) | `ODSFLLMRGIRV` | 101 | No |
| 713 | [dim_property_arrears_arrangement](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_arrears_arrangement) | `ODSINCHWTMRG` | 103 | Yes (highwater) |
| 720 | [dim_property_breach_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_breach_type) | `ODSFLLMRGIRV` | 101 | No |
| 800 | [dim_property_inspection_detail](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_property_inspection_detail) | `ODSFLLMRG` | 102 | No |

### Facts

| DataLoadId | Target table | Load type | Phase | Dimension keys |
| --- | --- | --- | --- | --- |
| 615 | [fact_property_inspection](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_inspection) | `ODSFLLMRG` | 200 | 5 + 6 date/time |
| 616 | [fact_property_tenancy_transaction](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_tenancy_transaction) | `ODSFLLMRG` | 200 | 5 + 5 date |
| 622 | [fact_property_tenant](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_tenant) | `ODSFLLMRG` | 200 | 3 + 2 date |
| 623 | [fact_property_maintenance_task](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_maintenance_task) | `ODSFLLMRG` | 200 | 7 + 10 date |
| 679 | [fact_void_checklist](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_void_checklist) | `ODSFLLMRGIRV` | 200 | 4 |
| 695 | [fact_property_risk](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_risk) | `ODSFLLMRGIRV` | 201 | 2 |
| 696 | [fact_property_hazard](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_hazard) | `ODSFLLMRGIRV` | 200 | 1 + 1 date |
| 711 | [fact_property_tenancy_breach](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_tenancy_breach) | `ODSFLLMRG` | 200 | 1 |
| 712 | [fact_property_arrears_transaction](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_arrears_transaction) | `ODSFLLMRGIRV` | 200 | 4 + 1 date |
| 718 | [fact_property_remedy_notice](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_remedy_notice) | `ODSFLLMRGIRV` | **100** | 2 |
| 719 | [fact_property_tribunal_order](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_tribunal_order) | `ODSFLLMRGIRV` | **100** | 2 |
| 734 | [fact_property_rent_charges](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_rent_charges) | `ODSFLLMRGIRV` | 200 | 3 |
| 761 | [fact_property_void_checklist](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/fact_property_void_checklist) | `ODSFLLMRGIRV` | 200 | 4 |

No property fact uses an incremental highwater load — every one is a full reload on each run.

## Load types used in this group

| Code | Description | Behaviour |
| --- | --- | --- |
| `ODSINCHWTMRG` | ODS: Incremental by highwater row-versioned merged | Reads only rows changed since the last watermark, then MERGEs with SCD Type 2 row versioning |
| `ODSFLLMRGIRV` | ODS: Full row-versioned merged | Reads the full ODS view every run, then MERGEs with SCD Type 2 row versioning |
| `ODSFLLMRG` | ODS: Full non-versioned merged | Reads the full ODS view every run, then MERGEs in place with no history (SCD Type 1) |

## Relationships across the property dimensions

Three property dimensions snowflake onto `dim_property`, so it must be current before they load.

::: mermaid
erDiagram
    dim_property ||--o{ dim_property_lease : "dim_property_key"
    dim_property ||--o{ dim_property_tenancy : "dim_property_key"
    dim_property ||--o{ dim_property_inspection_detail : "dim_property_key"
    dim_property ||--o{ dim_property_arrears_arrangement : "dim_property_key"
    dim_property_tenancy ||--o{ dim_property_arrears_arrangement : "dim_property_tenancy_key"
    dim_property_program ||--o{ dim_property_arrears_arrangement : "dim_property_program_key"
    dim_gender ||--o{ dim_property_tenancy : "dim_gender_key"
:::

`dim_property_arrears_arrangement` is placed in phase `103` precisely because it depends on `dim_property`, `dim_property_tenancy` and `dim_property_program`, all of which load in `101`. `dim_property_inspection_detail` sits in `102` for the same reason.

`dim_property_lease` and `dim_property_tenancy`, however, both hold a FK to `dim_property` yet share phase `101` with it — see [Known issues](#known-issues).

## Common source views

Most Zavanti-sourced ODS views join the same Dataverse metadata views to resolve option-set codes into labels. These are omitted from the "distinguishing source views" list on each page:

| View | Purpose |
| --- | --- |
| `vw_StateMetadata` | Resolves Dataverse `statecode` to a label |
| `vw_StatusMetadata` | Resolves Dataverse `statuscode` to a label |
| `vw_OptionsetMetadata` | Resolves entity-local option sets |
| `vw_GlobalOptionsetMetadata` | Resolves global (shared) option sets |
| `vw_systemuser` | Owning / modifying user detail |

## Known issues

Items found while documenting this group. **None have been changed** — they are recorded here for the team to decide on.

### Intra-phase dependency risk

`dim_property_lease` (532) and `dim_property_tenancy` (613) both carry a foreign key to `dim_property` (558), but all three sit in phase `101 Dimensions` and are run **in parallel** by `20_Load_Phase`. If the dependency is real, these should sit in a later phase, as `dim_property_inspection_detail` (102) and `dim_property_arrears_arrangement` (103) already do. Worth confirming whether the FK is resolved at load time or by a later lookup.

### Facts loading before dimensions

`fact_property_remedy_notice` (718) and `fact_property_tribunal_order` (719) are configured with phase `100 Facts`, which sorts ahead of every dimension phase. Both reference `dim_property_key` and `dim_property_tenancy_key`, so on any given run they resolve against the _previous_ day's dimension rows. These are the only two loads in phase `100 Facts` in the entire framework. Confirm whether this is deliberate.

### Duplicate void checklist facts

`fact_void_checklist` (679) and `fact_property_void_checklist` (761) read the same `vw_zav_voidchecklist` source view and produce structurally identical rows under different column names. **Both are active and load daily**, so void metrics will double-count if the two are unioned. Confirm which is authoritative, check which is referenced by live Power BI datasets, and retire the other.

### Breach type dimension is not consumed

`dim_property_breach_type` (720) is built and loaded, but `fact_property_tenancy_breach` (711) carries no `dim_property_breach_type_key`. The dimension appears to be unused by any fact.

### Overlapping tribunal modelling

`fact_property_tenancy_breach` (711) carries `tribunal_order_id` and `tribunal_outcome_id`, while `fact_property_tribunal_order` (719) models tribunal orders at their own grain from the same `vw_zav_tribunalorder` view. A breach with multiple orders cannot be represented on 711. Confirm which is authoritative.

### Ambiguous date key names on maintenance tasks

`fact_property_maintenance_task` has two columns combining "amount" and "date_key": `property_maintenance_task_total_capped_amount_date_key` and `property_maintenance_task_web_expenses_amount_date_key`. Both are `int`, consistent with a `dim_date` key, but the naming needs confirming against the ODS view.

### Void completion dates are not conformed

`target_completion_date_void` (761) and `void_checklist_target_completion_date_void` (679) are `datetime2` rather than `int` keys to `dim_date` — the only dates on any property fact not conformed to the date dimension.

### No conformed link between tenants and clients

`fact_property_tenant` carries no `dim_client_key`. The only route from a tenancy to a Recordbase client is `property_tenancy_primary_tenant_recordbaseid` on `dim_property_tenancy`, which covers the primary tenant only.

### fact_aged_debt has no load

`edw.fact_aged_debt` has key fields defined (`dim_property_tenancy_key`, `dim_property_key`, `dim_property_program_key`) but **no DataLoadId** in the Framework export. Confirm whether it is loaded by another mechanism, or is dormant and should be dropped.

### Surrogate key naming deviations

The standard is `[table]_key`. These use `_id` instead:

- `dim_property_lease.dim_property_lease_id`
- `dim_property_maintenace_type.dim_property_maintenace_type_id`
- `dim_property_program.dim_property_program_id`

### Object name misspelling

`dim_property_maintenace_type` is missing the second `n` in "maintenance". The live object name is preserved exactly throughout this documentation.

### Business key type drift

`property_id` is `uniqueidentifier` on most property tables, but `nvarchar(40)` on `dim_property_lease`. Joining on the business key across these tables requires a cast; join on the surrogate `dim_property_key` instead.

### Missing lineage

`dim_property_inspection_detail` (800) does not appear in the ODS ETL view lineage extract. Its source views are unconfirmed.

### Non-standard audit column

`dim_property_inspection_detail` carries an `EDWBatchId` column that no other property dimension has.

### Trigger state

The `EDW Daily Load` trigger definition in the Synapse repo shows `"runtimeState": "Stopped"`. Confirm the live trigger state in the Synapse workspace — the repo definition may not reflect the published state.

## Verification note

Landing table, staging table and stored procedure names on the per-load pages follow the documented EDW naming conventions. They have **not** been read back from `BIML.DataLoadDetail`. Before treating these pages as authoritative for a given load, confirm `TargetLandingTableName`, `TargetTemporaryTableName`, `TargetUpdateProcedureName` and `TargetHighwaterProcedureName` for that `DataLoadId`.
