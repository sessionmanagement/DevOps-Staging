# ODS to EDW Loads

[[_TOSP_]]

Documentation of the Synapse pipeline framework that loads data from the **ODS** into the **EDW**, and a per-load reference for each table it maintains.

## What this section covers

Every ODS → EDW load is driven by metadata in the Framework database, not by a bespoke pipeline per table. A single orchestration chain reads `BIML.DataLoadDetail` and processes every enabled load in phase order:

```text
Trigger "EDW Daily Load"
  └─ 10_Load_Master      opens parent ETL.Batch, loops load phases sequentially
       └─ 20_Load_Phase   loops loads within a phase in parallel (max 5)
            └─ 30_Load_From_ODS   per table: ODS view → landing → staging → edw
```

Each load follows the same five-layer path:

```text
source system → ODS ETL.[view] → landing.edw_* → staging.ODSETL* → edw.*
```

## Current scope

This section is being built incrementally. Property tables, finance tables, employee tables, client tables, and core/shared operational tables are documented.

| Group | Status |
| --- | --- |
| [Property dimensions](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview) | Documented (12 loads) |
| [Property facts](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Property-Load-Overview) | Documented (13 loads) |
| [Finance dimensions](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Finance-Dimension-Load-Overview) | Documented (7 loads) |
| [Finance facts](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Finance-Fact-Load-Overview) | Documented (4 loads) |
| [Employee dimensions](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Employee-Dimension-Load-Overview) | Documented (11 loads) |
| [Employee facts](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Employee-Fact-Load-Overview) | Documented (15 loads) |
| [Client dimensions](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Dimension-Load-Overview) | Documented (15 loads) |
| [Client facts](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Client-Fact-Load-Overview) | Documented (15 loads) |
| [Core & shared tables](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/Core-and-Shared-Load-Overview) | Documented (9 loads) |
| Remaining loads | Discontinued / dormant (to be dropped) |

## Out of scope

Documented separately, or not yet documented:

- Datalanding → ODS source loads (`[Source] Load - all tables` / `- single table` pipelines).
- The KPI load chain (`10_Load_Master_KPI`, `20_Load_Phase_KPI`, `30_Load_From_EDW_KPI`, `00_Monthly_KPI_History`).
- Power BI refresh and metadata-discovery pipelines.
- The Microsoft Fabric target architecture (see the Fabric Migration solution architecture documents).

## Where the code lives

| Artefact | Location |
| --- | --- |
| Pipelines | `Synapse Integration` repo → `Synapse_Integration/pipeline/` |
| Triggers | `Synapse Integration` repo → `Synapse_Integration/trigger/` |
| Staging and EDW stored procedures | `EDW` repo → `staging/`, `edw/Stored Procedures/` |
| Load configuration | Framework database → `BIML`, `ETL`, `Metadata` schemas |

## Related pages

- [EDW dimension tables](/BI-Team/Documentation-%2D-Data-Dudes/Data-Documentation/EDW-dimension-tables) — business definitions and source detail.
- [Property details](/BI-Team/Documentation-%2D-Data-Dudes/Data-Documentation/Property-details)
