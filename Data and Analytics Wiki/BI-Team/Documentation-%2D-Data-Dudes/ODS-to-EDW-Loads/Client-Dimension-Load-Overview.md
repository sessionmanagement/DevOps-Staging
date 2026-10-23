# Client Dimension Load Overview

[[_TOC_]]

The client subject area is sourced almost entirely from **Recordbase** — Emerge Aotearoa's client management system, replicated as two parallel database instances, **rbeal** and **rbmnb**. Every client dimension merges rows from both instances into a single conformed table. `dim_client_person_relationship` additionally draws from **IntelliHR** for the caseworker/employee side of the relationship.

This page covers all **15 client dimension loads**.

## Execution order

`10_Load_Master` runs load phases sequentially in `DataLoadPhaseNo` order. Within a phase, `20_Load_Phase` runs loads **in parallel**, up to 5 concurrently.

| Phase | Client dimension loads |
| --- | --- |
| `101 Dimensions` | `dim_client`, `dim_client_referral`, `dim_client_personal_goal_action_status`, `dim_client_activity_breakdown_type`, `dim_client_personal_goal_status`, `dim_client_incident`, `dim_client_incident_category_type`, `dim_client_incident_severity`, `dim_client_incident_status_type`, `dim_client_interaction_type`, `dim_client_outcome_questions` |
| `103 Dimensions` | `dim_client_team`, `dim_client_referral_service_level` |
| `200 Facts` | `dim_client_person_relationship`, `dim_client_absence` |

> **Note.** Two loads named `dim_*` are configured to run in the **Facts** phase, not a dimension phase — see [Known issues](#known-issues).

## Load inventory

| DataLoadId | Target table | Source system(s) | Load type | Phase |
| --- | --- | --- | --- | --- |
| 461 | [dim_client](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 463 | [dim_client_team](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_team) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 103 |
| 464 | [dim_client_referral](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_referral) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 465 | [dim_client_personal_goal_action_status](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_personal_goal_action_status) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 467 | [dim_client_activity_breakdown_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_activity_breakdown_type) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 481 | [dim_client_personal_goal_status](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_personal_goal_status) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 628 | [dim_client_person_relationship](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_person_relationship) | Recordbase (rbeal, rbmnb), IntelliHR | `ODSFLLMRGIRV` | 200 |
| 641 | [dim_client_absence](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_absence) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 200 |
| 705 | [dim_client_referral_service_level](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_referral_service_level) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 103 |
| 728 | [dim_client_incident](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_incident) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 729 | [dim_client_incident_category_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_incident_category_type) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 730 | [dim_client_incident_severity](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_incident_severity) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 731 | [dim_client_incident_status_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_incident_status_type) | Recordbase (rbeal, rbmnb) | `ODSFLLMRGIRV` | 101 |
| 803 | [dim_client_interaction_type](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_interaction_type) | Recordbase (unconfirmed — see page) | `ODSFLLMRGIRV` | 101 |
| 804 | [dim_client_outcome_questions](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_outcome_questions) | Unconfirmed — no repo object found | `ODSFLLMRGIRV` | 101 |

All 15 loads are `ODSFLLMRGIRV` (full row-versioned merge / SCD Type 2). None use a highwater watermark — there are no `GetHighwaterForedwdim_client*` procedures in the repo, confirmed against the Framework `IsHighwater = 0` flag on every row.

## Conformed relationships

`edw.dim_client` is the primary conformed dimension for client reporting, joined via its surrogate `dim_client_key` from most client-related facts, and directly via `client_id` where a fact retains the business key.

::: mermaid
erDiagram
    dim_client                ||--o{ dim_client_referral : "dim_client_key (via client_id)"
    dim_client                ||--o{ dim_client_referral_service_level : "dim_client_key"
    dim_client                ||--o{ dim_client_absence : "dim_client_key"
    dim_client                ||--o{ dim_client_person_relationship : "dim_client_key"
    dim_client_referral       ||--o{ dim_client_referral_service_level : "dim_client_referral_key"
    dim_client_referral       ||--o{ dim_client_person_relationship : "dim_client_referral_key"
    dim_client_team           ||--o{ dim_client_person_relationship : "dim_client_team_key"
    dim_service                ||--o{ dim_client_team : "dim_service_Key"
    dim_client_incident        ||--o{ fact_client_incident : "dim_client_incident_key"
    dim_client_incident_category_type ||--o{ dim_client_incident : "incident_category_type_id"
:::

## Recordbase dual-instance merge pattern

Every dimension in this group (except `dim_client_person_relationship`'s IntelliHR side) is built by merging matching `rbeal` and `rbmnb` Recordbase objects in the ODS `ETL.*` view — e.g. `ETL.dim_client` unions `rbeal.dldimperson` with `rbmnb.dldimperson`, and equivalent pairs for every other source object (`dlDimUser`, `dlFactReferral`, `dlDimIncidentCategoryType`, etc.). This is the same merge pattern documented for `dim_employee`, `dim_gender` and `dim_company` in the finance/employee subject areas.

## Known issues

Items found while documenting this group. **None have been changed** — they are recorded here for the team to decide on.

### Two `dim_*` tables load in the Facts phase

`dim_client_person_relationship` (628) and `dim_client_absence` (641) are configured with `LoadPhase = 200 Facts`, not a dimension phase, despite being named and structured as dimensions.

- `dim_client_person_relationship` carries six dimension foreign keys (`dim_company_key`, `dim_employee_key`, `dim_client_key`, `dim_client_referral_key`, `dim_client_team_key`, `dim_service_key`), including `dim_client_team_key` which only becomes available after phase `103`. Placing it in the Facts phase is a reasonable way to guarantee all its dependencies (including phase 103) have loaded first, even though it is not itself a fact.
- `dim_client_absence` only depends on `dim_client` (phase 101), so it did not need to wait until the Facts phase — this one looks more like a naming/classification inconsistency than a load-order necessity.

### Inconsistent company-reference pattern across the group

Three different conventions are used for the company reference, sometimes within the same load phase:

| Pattern | Tables |
| --- | --- |
| `company_id` (raw business key, no dimension link) | `dim_client`, `dim_client_referral`, `dim_client_team`, `dim_client_referral_service_level`, `dim_client_activity_breakdown_type`, `dim_client_personal_goal_action_status`, `dim_client_personal_goal_status` |
| `dim_company_key` (surrogate FK to `edw.dim_company`) | `dim_client_incident`, `dim_client_incident_category_type`, `dim_client_incident_severity`, `dim_client_incident_status_type`, `dim_client_person_relationship` |
| `company_key` (ambiguous — no `dim_` prefix, unclear if raw or surrogate) | `dim_client_interaction_type`, `dim_client_outcome_questions` |

Confirm which pattern is authoritative before building new joins against `dim_company` from this subject area.

### dim_client_outcome_questions has no object in the EDW repo

DataLoadId `804` is configured in the Framework and its columns are confirmed via a database schema extract (`dim_client_outcome_questions_key`, `company_key`, `outcome_tool_template_id`, `outcome_tool_question_id`), but there is **no matching file anywhere in the EDW repository** — no `edw/Tables/dim_client_outcome_questions.sql`, no landing/staging table, no `insert_staging_*` or `Updateedw*` procedure. The object exists in the live database but appears to have been deployed outside the normal repo/DACPAC process, or the repo has not been kept in sync. See [its page](/BI-Team/Documentation-%2D-Data-Dudes/ODS-to-EDW-Loads/dim_client_outcome_questions) for what is known.

### dim_client_interaction_type has no confirmed lineage

Unlike every other table in this group, `dim_client_interaction_type` (803) does not appear in the ODS ETL view lineage extract, so its exact Recordbase source object(s) are unconfirmed.

### Self-referencing hierarchies

`dim_client_activity_breakdown_type` (`client_parent_activity_breakdown_type`) and `dim_client_incident_category_type` (`incident_category_type_parent_Id`) both carry a parent reference to their own business key, modelling a category hierarchy without a separate hierarchy table. Neither exposes a pre-built path/depth like the finance G/L account hierarchy does.

### Compound BIGINT lookup keys

`dim_client_incident`, `dim_client_incident_category_type`, `dim_client_incident_severity` and `dim_client_incident_status_type` each carry a `dim_client_incident_company_key_[x]_id_key` (`bigint`) column — a combined company+business-key value, the same pattern used on the employee pay dimensions (`dim_company_key_pay_run_id_key`, etc.).

## Verification basis

Checked against EDW table DDL, stored procedures, Framework load metadata, the ODS ETL view lineage extract, and a live database column extract (for the table with no repo object).
