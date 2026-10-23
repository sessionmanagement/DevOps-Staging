# Property Inspection

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
| **Power BI Table Name** | Property Inspection |
| **Source** | `edw.fact_property_inspection` |
| **Query Group** | Fact Tables |
| **Row Description** | One property inspection event (routine, pre-vacate, final, or property condition report) |
| **Column Count** | 38 |
| **Overall Classification** | In-Confidence |

Property inspections including routine tenancy inspections, pre-vacate inspections, and property condition reports. Each record represents a single inspection event with its scheduled date, actual date, outcome, inspector, and any associated maintenance summary. Inspections link to tenancies and may generate maintenance work orders.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive operational data | Actual Inspection Date, Scheduled Date, Category, Type, State, Status, Tenant Present, Cancel Inspection, Owning Business Unit |
| :yellow_circle: **In-Confidence** | Business-sensitive inspection details | Inspection Summary, Maintenance Required, Comments, Any Other Issues, Suggested Improvements, Inspected By, Property Manager, Tenancy Manager, Owner |
| :red_circle: **Sensitive** | N/A | No columns at this level |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Fact Property Inspection KEY | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Property Inspection ID | string | Hidden | :green_circle: Public | Business key from source system |
| 3 | Dim Property KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property |
| 4 | Dim Property Detail KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Detail |
| 5 | Dim Property Healthy Homes KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Healthy Homes |
| 6 | Dim Property Tenancy KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Tenancy |
| 7 | Dim Property Maintenance KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Maintenance |
| 8 | Property ID | string | Hidden | :green_circle: Public | Property business key |
| 9 | Property Tenancy ID | string | Hidden | :green_circle: Public | Tenancy business key (join to Tenancy table) |
| 10 | Property Maintenance ID | string | Hidden | :green_circle: Public | Maintenance work order reference |
| 11 | Inspection Code | string | Visible | :green_circle: Public | System code for the inspection type |
| 12 | Inspection Name | string | Visible | :green_circle: Public | Human-readable inspection name |
| 13 | Actual Inspection Date | date | Visible | :green_circle: Public | Date the inspection was actually performed |
| 14 | Scheduled Date | date | Visible | :green_circle: Public | Originally scheduled inspection date |
| 15 | Date Inspection Finalized | date | Visible | :green_circle: Public | Date inspection was completed/finalized |
| 16 | Next Routine Inspection | date | Visible | :green_circle: Public | Scheduled date for the next routine inspection |
| 17 | Inspection Summary | string | Visible | :yellow_circle: In-Confidence | Summary of inspection findings |
| 18 | Inspected By | string | Visible | :yellow_circle: In-Confidence | Name of the inspector |
| 19 | Category | string | Visible | :green_circle: Public | Inspection category (Tenancy Routine Inspection, Tenancy Inspection Report, Property Condition Report) |
| 20 | Type | string | Visible | :green_circle: Public | Inspection type classification |
| 21 | Maintenance Required | string | Visible | :yellow_circle: In-Confidence | Summary of maintenance work identified |
| 22 | State | string | Visible | :green_circle: Public | Inspection state (Active/Inactive) |
| 23 | Status | string | Visible | :green_circle: Public | Inspection status (Completed, New, Canceled, Work Task Fully/Partially created) |
| 24 | Tenant Present | int64 | Visible | :green_circle: Public | Flag: 1 if tenant was present during inspection |
| 25 | Cancel Inspection | int64 | Visible | :green_circle: Public | Flag: 1 if inspection was cancelled |
| 26 | Ignore Plugin Validate | int64 | Hidden | :green_circle: Public | System flag for plugin validation |
| 27 | Tenant Confirmed Condition | int64 | Visible | :green_circle: Public | Flag: 1 if tenant confirmed property condition |
| 28 | Owning Business Unit | string | Visible | :green_circle: Public | Business unit responsible for the inspection |
| 29 | Client | string | Hidden | :yellow_circle: In-Confidence | Client reference |
| 30 | Property | string | Hidden | :yellow_circle: In-Confidence | Property reference |
| 31 | Property Manager | string | Hidden | :yellow_circle: In-Confidence | Property manager name |
| 32 | Tenancy Manager | string | Hidden | :yellow_circle: In-Confidence | Tenancy manager name |
| 33 | Tenant | string | Hidden | :yellow_circle: In-Confidence | Tenant reference |
| 34 | Owner | string | Hidden | :yellow_circle: In-Confidence | Property owner name |
| 35 | Any Other Issues | string | Visible | :yellow_circle: In-Confidence | Free-text field for additional issues noted |
| 36 | Comments | string | Visible | :yellow_circle: In-Confidence | General comments about the inspection |
| 37 | Relative Url | string | Visible | :green_circle: Public | URL path to the inspection record in source system |
| 38 | Suggested Improvements | string | Visible | :yellow_circle: In-Confidence | Recommended improvements from the inspection |

---

## Source SQL

```sql
SELECT
    [fact_property_inspection_key]                                                              AS [Fact Property Inspection KEY],
    [property_inspection_id]                                                                    AS [Property Inspection ID],
    [dim_property_key]                                                                          AS [Dim Property KEY],
    [dim_property_detail_key]                                                                   AS [Dim Property Detail KEY],
    [dim_property_healthy_homes_key]                                                            AS [Dim Property Healthy Homes KEY],
    [dim_property_tenancy_key]                                                                  AS [Dim Property Tenancy KEY],
    [dim_property_maintenance_key]                                                              AS [Dim Property Maintenance KEY],
    [property_id]                                                                               AS [Property ID],
    [property_tenancy_id]                                                                       AS [Property Tenancy ID],
    [property_maintenance_id]                                                                   AS [Property Maintenance ID],
    [property_inspection_code]                                                                  AS [Inspection Code],
    [property_inspection_name]                                                                  AS [Inspection Name],
    TRY_CONVERT(DATE, CAST(NULLIF([property_inspection_date_key], -1) AS VARCHAR(8)), 112)      AS [Actual Inspection Date],
    TRY_CONVERT(DATE, CAST(NULLIF([property_inspection_scheduled_date_key], -1) AS VARCHAR(8)), 112) AS [Scheduled Date],
    TRY_CONVERT(DATE, CAST(NULLIF([property_inspection_completion_date_key], -1) AS VARCHAR(8)), 112) AS [Date Inspection Finalized],
    TRY_CONVERT(DATE, CAST(NULLIF([property_inspection_next_routine_inspection_date_key], -1) AS VARCHAR(8)), 112) AS [Next Routine Inspection],
    [property_inspection_summary]                                                               AS [Inspection Summary],
    [property_inspection_inspected_by]                                                          AS [Inspected By],
    [property_inspection_category]                                                              AS [Category],
    [property_inspection_type]                                                                  AS [Type],
    [property_inspection_maintenance_summary]                                                   AS [Maintenance Required],
    [property_inspection_state]                                                                 AS [State],
    [property_inspection_status]                                                                AS [Status],
    [property_inspection_tenant_present_flag]                                                   AS [Tenant Present],
    [property_inspection_cancel_inspection_flag]                                                AS [Cancel Inspection],
    [property_inspection_ignore_plugin_validate_flag]                                           AS [Ignore Plugin Validate],
    [property_inspection_tenant_confirmed_condition_flag]                                       AS [Tenant Confirmed Condition],
    [property_inspection_owning_business_unit_name]                                             AS [Owning Business Unit],
    [property_inspection_client]                                                                AS [Client],
    [property_inspection_property]                                                              AS [Property],
    [property_inspection_property_manager]                                                      AS [Property Manager],
    [property_inspection_tenancy_manager]                                                       AS [Tenancy Manager],
    [property_inspection_tenant]                                                                AS [Tenant],
    [property_inspection_owner_name]                                                            AS [Owner],
    [property_inspection_other_issue_comments]                                                  AS [Any Other Issues],
    [property_inspection_comments]                                                              AS [Comments],
    [property_inspection_relative_url]                                                          AS [Relative Url],
    [property_inspection_suggested_improvements]                                                AS [Suggested Improvements]
FROM [edw].[fact_property_inspection]
WHERE [DWHDMLOperation] <> 'D'
    AND [property_inspection_is_delete_flag] IS NULL;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, capitalises ID/KEY suffixes. Applied to all column names after SQL aliasing.
- **Filters**:
  - `DWHDMLOperation <> 'D'` -- Excludes soft-deleted EDW rows
  - `property_inspection_is_delete_flag IS NULL` -- Excludes source-system deleted inspections
- **Type conversions**:
  - 4 date key columns (int YYYYMMDD) converted to DATE via `TRY_CONVERT(DATE, CAST(NULLIF(..., -1) AS VARCHAR(8)), 112)`
  - `NULLIF(..., -1)` handles the EDW sentinel value -1 for missing dates, converting them to NULL
- **M transforms**: Date columns converted to date type in "Changed Type" step

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Property Inspection | Property Tenancy ID | Tenancy | Property Tenancy ID | Many-to-One | Single |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Inspections | 06. Inspections | Count of all inspection rows |
| Inspections Completed | 06. Inspections\By Status | Inspections with Status = "Completed" |
| Inspections New/Pending | 06. Inspections\By Status | Inspections with Status = "New" |
| Inspections Cancelled | 06. Inspections\By Status | Inspections with Status = "Canceled" |
| Inspections With Work Task Created | 06. Inspections\By Status | Inspections with Status "Work Task Fully created" or "Work Task Partially created" |
| Inspection Completion Rate % | 06. Inspections | Completed / (Total - Cancelled) as percentage |
| Inspections - Routine | 06. Inspections\By Category | Inspections with Category = "Tenancy Routine Inspection" |
| Inspections - Tenancy Report | 06. Inspections\By Category | Inspections with Category = "Tenancy Inspection Report" |
| Inspections - Property Condition | 06. Inspections\By Category | Inspections with Category = "Property Condition Report" |
| Inspections With Tenant Present | 06. Inspections | Inspections where Tenant Present = 1 |
