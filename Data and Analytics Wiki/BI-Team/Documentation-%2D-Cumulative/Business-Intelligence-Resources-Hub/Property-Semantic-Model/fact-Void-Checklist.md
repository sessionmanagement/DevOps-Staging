# Void Checklist

## Table of Contents
1. [Overview](#overview)
2. [Data Classification](#data-classification)
3. [Column Reference](#column-reference)
4. [Source SQL](#source-sql)
5. [Transformation Notes](#transformation-notes)
6. [Relationships](#relationships)
7. [Related Measures](#related-measures)

---

## Overview

| Property | Value |
|----------|-------|
| **Power BI Table Name** | Void Checklist |
| **Source** | `edw.fact_void_checklist` LEFT JOIN `edw.dim_void_category` |
| **Query Group** | Fact Tables |
| **Row Description** | One void checklist instance tracking the lifecycle of a vacant property from tenant vacate through to re-tenanting or return to landlord |
| **Column Count** | 45 |
| **Overall Classification** | In-Confidence |

Void management checklists tracking the process of turning over a vacated property back to a tenantable state. Each record represents a void checklist with 31 milestone dates covering the full void lifecycle from tenant vacate through inspections, repairs, compliance checks, and new tenancy allocation. Void categories include NEW* (new property onboarding), ROUT/ROTH (routine turnovers), and RTLL (return to landlord). The LEFT JOIN to `dim_void_category` brings in the category description and comments.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive operational dates and categories | Void Category, Void Status, all 31 milestone date columns, Created On, Target Completion dates |
| :yellow_circle: **In-Confidence** | Operational workflow details | Comments, Owner, Vacated Tenancy, Name, Void Category Comment, Void Category Description |
| :red_circle: **Sensitive** | N/A | No columns at this level |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Fact Void Checklist KEY | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Dim Property KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property |
| 3 | Dim Property Tenancy KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Tenancy |
| 4 | Void Checklist ID | string | Hidden | :green_circle: Public | Business key from source system |
| 5 | Void Checklist Property ID | string | Hidden | :green_circle: Public | Property business key (join to Property) |
| 6 | Void Checklist Vacated Tenancy ID | string | Hidden | :green_circle: Public | Tenancy that vacated the property |
| 7 | Void Category Comment | string | Visible | :yellow_circle: In-Confidence | Notes about the void category selection |
| 8 | Void Category Description | string | Visible | :yellow_circle: In-Confidence | Full descriptive name of the void category (from dim_void_category) |
| 9 | Void Category | string | Visible | :green_circle: Public | Classification code (NEWC, NEWR, NEWS, NEWT, NEWP, ROUT, ROTH, RTLL) |
| 10 | Void Status | string | Visible | :green_circle: Public | Current workflow state (Current, Void, Complete) |
| 11 | Comments | string | Visible | :yellow_circle: In-Confidence | Free-text notes about the void process |
| 12 | Owner | string | Visible | :yellow_circle: In-Confidence | Staff member responsible for the void checklist |
| 13 | Vacated Tenancy | string | Visible | :yellow_circle: In-Confidence | Name of the vacated tenancy |
| 14 | Name | string | Visible | :yellow_circle: In-Confidence | Void checklist name/reference |
| 15 | Created On | date | Visible | :green_circle: Public | Date the checklist was created |
| 16 | All Compliance Issues Completed | date | Visible | :green_circle: Public | Date all compliance items were resolved |
| 17 | Assessment Scoping | date | Visible | :green_circle: Public | Date assessment and scoping was completed |
| 18 | Bond Recovery Forms Completed | date | Visible | :green_circle: Public | Date bond recovery forms were submitted |
| 19 | BOS Updated Vacancy Listed | date | Visible | :green_circle: Public | Date vacancy was listed in BOS system |
| 20 | BOS Updated Vacate Date | date | Visible | :green_circle: Public | Date vacate was recorded in BOS system |
| 21 | Car Parking Provisioned | date | Visible | :green_circle: Public | Date car parking was provisioned |
| 22 | Confirm Tenancy Accepted In BOS | date | Visible | :green_circle: Public | Date new tenancy acceptance was confirmed in BOS |
| 23 | Damage Assessment | date | Visible | :green_circle: Public | Date damage assessment was completed |
| 24 | Date Key Received From Tenant | date | Visible | :green_circle: Public | Date keys were received from outgoing tenant |
| 25 | Property is ready - convert to VACANT: Tenantable | date | Visible | :green_circle: Public | Critical milestone: date keys were given to tenancy team; sets the Relettable Date |
| 26 | Date Offer Confirmed Accepted | date | Visible | :green_circle: Public | Date a tenancy offer was confirmed and accepted |
| 27 | Date of Final inspection | date | Visible | :green_circle: Public | Date the final inspection after keys received was completed |
| 28 | Date Pre Vacate Inspection | date | Visible | :green_circle: Public | Date the pre-vacate inspection was conducted |
| 29 | Date Tenancy Terminated | date | Visible | :green_circle: Public | Date the previous tenancy was formally terminated |
| 30 | Property Units Submitted To BOS Approved | date | Visible | :green_circle: Public | Date property units were approved in BOS |
| 31 | Refurbishment Completed | date | Visible | :green_circle: Public | Date refurbishment works were completed |
| 32 | Repairs Completed | date | Visible | :green_circle: Public | Date repair works were completed |
| 33 | Residential Tenancy Agreement Prepared | date | Visible | :green_circle: Public | Date the new tenancy agreement was prepared |
| 34 | Rubbish And Equipment Removed | date | Visible | :green_circle: Public | Date rubbish and leftover equipment were cleared |
| 35 | Safety Check Completed | date | Visible | :green_circle: Public | Date all safety checks were completed |
| 36 | Shortlist Created | date | Visible | :green_circle: Public | Date a shortlist of prospective tenants was created |
| 37 | Signed Lease Or Agreement Received | date | Visible | :green_circle: Public | Date signed lease/agreement was received from new tenant |
| 38 | Target Completion Date Vacant | date | Visible | :green_circle: Public | Target date for property to reach Vacant: Tenantable status |
| 39 | Target Completion Date Void | date | Visible | :green_circle: Public | Target date for void process to complete |
| 40 | Tenancy Resolved And Exited | date | Visible | :green_circle: Public | Date the previous tenancy was fully resolved |
| 41 | Tenant Improvements Scoped And Agreed | date | Visible | :green_circle: Public | Date tenant improvements were scoped and agreed |
| 42 | Upcoming Maintenance Jobs Booked | date | Visible | :green_circle: Public | Date upcoming maintenance jobs were scheduled |
| 43 | Utilities connections recorded and set up [if appl] | date | Visible | :green_circle: Public | Date utility connections were set up (if applicable) |
| 44 | Utilities Disconnected | date | Visible | :green_circle: Public | Date utilities were disconnected after vacate |
| 45 | Void Completed Date | date | Visible | :green_circle: Public | Date the void process was completed |

---

## Source SQL

```sql
SELECT
    fc.[fact_void_checklist_key]                                                    AS [Fact Void Checklist KEY],
    fc.[dim_property_key]                                                           AS [Dim Property KEY],
    fc.[dim_property_tenancy_key]                                                   AS [Dim Property Tenancy KEY],
    fc.[void_checklist_id]                                                          AS [Void Checklist ID],
    fc.[void_checklist_property_id]                                                 AS [Void Checklist Property ID],
    fc.[void_checklist_vacated_tenancy_id]                                          AS [Void Checklist Vacated Tenancy ID],
    vc.[void_category_comments]                                                     AS [Void Category Comment],
    vc.[void_category_description]                                                  AS [Void Category Description],
    fc.[void_checklist_void_category_name]                                          AS [Void Category],
    fc.[void_checklist_status_name]                                                 AS [Void Status],
    fc.[void_checklist_crba8_comments]                                              AS [Comments],
    fc.[void_checklist_owner_id_name]                                               AS [Owner],
    fc.[void_checklist_vacated_tenancy_name]                                        AS [Vacated Tenancy],
    fc.[void_checklist_name]                                                        AS [Name],
    CAST(fc.[void_checklist_created_on] AS DATE)                                    AS [Created On],
    CAST(fc.[void_checklist_all_compliance_issues_completed] AS DATE)               AS [All Compliance Issues Completed],
    CAST(fc.[void_checklist_assessment_scoping] AS DATE)                            AS [Assessment Scoping],
    CAST(fc.[void_checklist_bond_recovery_forms_completed] AS DATE)                 AS [Bond Recovery Forms Completed],
    CAST(fc.[void_checklist_bos_updated_vacancy_listed] AS DATE)                    AS [BOS Updated Vacancy Listed],
    CAST(fc.[void_checklist_bos_updated_vacate_date] AS DATE)                       AS [BOS Updated Vacate Date],
    CAST(fc.[void_checklist_car_parking_provisioned] AS DATE)                       AS [Car Parking Provisioned],
    CAST(fc.[void_checklist_confirm_tenancy_accepted_in_bos] AS DATE)               AS [Confirm Tenancy Accepted In BOS],
    CAST(fc.[void_checklist_damage_assessment] AS DATE)                             AS [Damage Assessment],
    CAST(fc.[void_checklist_date_key_received_from_tenant] AS DATE)                 AS [Date Key Received From Tenant],
    CAST(fc.[void_checklist_date_keys_to_tenancy_team_to_allocate] AS DATE)         AS [Property is ready - convert to VACANT: Tenantable],
    CAST(fc.[void_checklist_date_offer_confirmed_accepted] AS DATE)                 AS [Date Offer Confirmed Accepted],
    CAST(fc.[void_checklist_date_of_final_inspection_after_keys_received] AS DATE)  AS [Date of Final inspection],
    CAST(fc.[void_checklist_date_pre_vacate_inspection] AS DATE)                    AS [Date Pre Vacate Inspection],
    CAST(fc.[void_checklist_date_tenancy_terminated] AS DATE)                       AS [Date Tenancy Terminated],
    CAST(fc.[void_checklist_property_units_submitted_to_bos_approved] AS DATE)      AS [Property Units Submitted To BOS Approved],
    CAST(fc.[void_checklist_refurbishment_completed] AS DATE)                       AS [Refurbishment Completed],
    CAST(fc.[void_checklist_repairs_completed] AS DATE)                             AS [Repairs Completed],
    CAST(fc.[void_checklist_residential_tenancy_agreement_prepared] AS DATE)        AS [Residential Tenancy Agreement Prepared],
    CAST(fc.[void_checklist_rubbish_and_equipment_removed] AS DATE)                 AS [Rubbish And Equipment Removed],
    CAST(fc.[void_checklist_safety_check_completed] AS DATE)                        AS [Safety Check Completed],
    CAST(fc.[void_checklist_shortlist_created] AS DATE)                             AS [Shortlist Created],
    CAST(fc.[void_checklist_signed_lease_or_agreement_received] AS DATE)            AS [Signed Lease Or Agreement Received],
    CAST(fc.[void_checklist_target_completion_date_vacant] AS DATE)                 AS [Target Completion Date Vacant],
    CAST(fc.[void_checklist_target_completion_date_void] AS DATE)                   AS [Target Completion Date Void],
    CAST(fc.[void_checklist_tenancy_resolved_and_exited] AS DATE)                   AS [Tenancy Resolved And Exited],
    CAST(fc.[void_checklist_tenant_improvements_scoped_and_agreed] AS DATE)         AS [Tenant Improvements Scoped And Agreed],
    CAST(fc.[void_checklist_upcoming_maintenance_jobs_booked] AS DATE)              AS [Upcoming Maintenance Jobs Booked],
    CAST(fc.[void_checklist_utilities_connections_recorded_and_setup_if_applicable] AS DATE) AS [Utilities connections recorded and set up [if appl]],
    CAST(fc.[void_checklist_utilities_disconnected] AS DATE)                        AS [Utilities Disconnected],
    CAST(fc.[void_checklist_void_completed_date] AS DATE)                           AS [Void Completed Date]
FROM [edw].[fact_void_checklist] fc
LEFT JOIN [edw].[dim_void_category] vc
    ON fc.[void_checklist_void_category_id] = vc.[void_category_id]
    AND vc.[DWHDMLOperation] <> 'D'
    AND vc.[DWHIsCurrent] = 1
    AND vc.[void_category_is_delete_flag] IS NULL
    AND vc.[void_category_id] IS NOT NULL
WHERE fc.[DWHDMLOperation] <> 'D'
    AND fc.[void_checklist_is_delete_flag] IS NULL
    AND fc.[DWHIsCurrent] = 1;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, capitalises ID/KEY suffixes. Applied to all column names after SQL aliasing.
- **Filters**:
  - `fc.DWHDMLOperation <> 'D'` -- Excludes soft-deleted EDW rows
  - `fc.void_checklist_is_delete_flag IS NULL` -- Excludes source-system deleted checklists
  - `fc.DWHIsCurrent = 1` -- Only current SCD Type 2 records
  - LEFT JOIN conditions on `dim_void_category`: `DWHDMLOperation <> 'D'`, `DWHIsCurrent = 1`, `void_category_is_delete_flag IS NULL`, `void_category_id IS NOT NULL`
- **Type conversions**:
  - 31 date columns converted via `CAST(... AS DATE)` from datetime to date
  - No NULLIF required as these are stored as datetime (not integer date keys)
- **LEFT JOIN**: `edw.dim_void_category` is joined on `void_checklist_void_category_id = void_category_id` to bring in category description and comments

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Void Checklist | Void Checklist Property ID | Property | Property ID | Many-to-One | Single |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Voids | 08. Void Management | Count of all void checklist rows |
| Active Voids | 08. Void Management | Voids where Void Completed Date is blank |
| Completed Voids | 08. Void Management | Voids where Void Completed Date is not blank |
| Void Completion Rate % | 08. Void Management | Completed Voids / Total Voids as percentage |
| Voids - New Property | 08. Void Management\By Category | Voids where category starts with "NEW" |
| Voids - Routine Turnover | 08. Void Management\By Category | Voids where category is ROUT or ROTH |
| Voids - Return to Landlord | 08. Void Management\By Category | Voids where category is RTLL |
| Voids - Transitional Housing | 08. Void Management\By Category | Voids where category is NEWT or ROTH |
| Avg Days Key to Tenantable | 08. Void Management\Duration KPIs | Average days from Key Received to Property Ready |
| Avg Days Void to Complete | 08. Void Management\Duration KPIs | Average days from Created On to Void Completed Date |
| Total Days Void (Sum) | 08. Void Management\Duration KPIs | Sum of void duration days |
| Avg Days Assessment to Repairs | 08. Void Management\Duration KPIs | Average days from Assessment Scoping to Repairs Completed |
| Avg Days Repairs to Tenantable | 08. Void Management\Duration KPIs | Average days from Repairs Completed to Property Ready |
| Avg Days Vacancy to Offer | 08. Void Management\Duration KPIs | Average days from BOS Vacancy Listed to Offer Accepted |
| Voids Completed On Target | 08. Void Management\Target Performance | Voids where completed date <= target completion date |
| Voids Completed Over Target | 08. Void Management\Target Performance | Voids where completed date > target completion date |
| On Target Rate % | 08. Void Management\Target Performance | Percentage of voids completed on or before target |
| Avg Days Over Target | 08. Void Management\Target Performance | Average days beyond target for overdue voids |
| Voids Overdue (Active) | 08. Void Management\Target Performance | Active voids past their target completion date |
| Voids Due Within 7 Days | 08. Void Management\Target Performance | Active voids with target date within next 7 days |
| Awaiting Assessment | 08. Void Management\Workflow Stage | Active voids without Assessment Scoping date |
| Awaiting Repairs | 08. Void Management\Workflow Stage | Active voids without Repairs Completed date |
| Awaiting Offer | 08. Void Management\Workflow Stage | Active voids without Offer Confirmed Accepted date |
| Lease Signed | 08. Void Management\Workflow Stage | Voids with Signed Lease Or Agreement Received date |
| Pre-Vacate Inspection Done | 08. Void Management\Milestones | Voids with Pre-Vacate Inspection date |
| Final Inspection Done | 08. Void Management\Milestones | Voids with Final Inspection date |
| Safety Check Done | 08. Void Management\Milestones | Voids with Safety Check Completed date |
| Property Ready (Tenantable) | 08. Void Management\Milestones | Voids with Property Ready date |
| BOS Vacancy Listed | 08. Void Management\Milestones | Voids with BOS Updated (Vacancy Listed) date |
| Offer Accepted | 08. Void Management\Milestones | Voids with Date Offer Confirmed Accepted date |
| Bond Recovery Done | 08. Void Management\Milestones | Voids with Bond Recovery Forms Completed date |
| All Compliance Done | 08. Void Management\Milestones | Voids with All Compliance Issues Completed date |
| Signed Lease Received | 08. Void Management\Milestones | Voids with Signed Lease Or Agreement Received date |
| Voids Created This Year | 08. Void Management\Trends | Voids created in the current calendar year |
| Voids Completed This Year | 08. Void Management\Trends | Voids completed in the current calendar year |
| Net Void Movement | 08. Void Management\Trends | Voids Completed This Month minus Voids Created This Month |
