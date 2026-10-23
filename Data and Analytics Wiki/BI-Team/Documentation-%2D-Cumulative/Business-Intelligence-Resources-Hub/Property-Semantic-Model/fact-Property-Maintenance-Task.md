# Property Maintenance Task

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
| **Power BI Table Name** | Property Maintenance Task |
| **Source** | `edw.fact_property_maintenance_task` |
| **Query Group** | Fact Tables |
| **Row Description** | One maintenance task (line item) within a maintenance work order, with location, work type, cost, and timeline dates |
| **Column Count** | 42 |
| **Overall Classification** | In-Confidence |

Individual maintenance tasks (line items) within a maintenance work order. Each record represents a specific task with its location within the property, work type classification, cost amount, and a series of timeline dates tracking acknowledgment through to completion and invoicing. Tasks link to the parent maintenance work order via Property Maintenance ID and to the property via Property ID.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive operational data | All date columns, Location Name, Location Code, Work Task, Work Type, Information Code, Assets, Created Date, Modified Date |
| :yellow_circle: **In-Confidence** | Business-sensitive cost and contractor data | Amount, G/L Code, Comments, Contract Service Name, Information Code Detail |
| :red_circle: **Sensitive** | N/A | No columns at this level |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Fact Property Maintenance Task KEY | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Property Maintenance Task ID | string | Hidden | :green_circle: Public | Business key from source system |
| 3 | Property Maintenance ID | string | Hidden | :green_circle: Public | Parent work order ID (join to Property Maintenance) |
| 4 | Dim Property Maintenance KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Maintenance |
| 5 | Dim Property KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property |
| 6 | Dim Property Detail KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Detail |
| 7 | Dim Property Healthy Homes KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Healthy Homes |
| 8 | Dim Property Tenancy KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Tenancy |
| 9 | Dim Property Program KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Program |
| 10 | Dim Property Maintenace Type KEY | int64 | Hidden | :green_circle: Public | FK to Dim Property Maintenance Type |
| 11 | Property ID | string | Hidden | :green_circle: Public | Property business key (join to Property) |
| 12 | Property Maintenance Type ID | string | Hidden | :green_circle: Public | Maintenance type identifier |
| 13 | Property Program ID | string | Hidden | :green_circle: Public | Program identifier |
| 14 | Property Subprogram ID | string | Hidden | :green_circle: Public | Subprogram identifier |
| 15 | Property Tenancy ID | string | Hidden | :green_circle: Public | Tenancy identifier |
| 16 | Property Maintenace Type ID | string | Hidden | :green_circle: Public | Maintenance type ID (alternate spelling from source) |
| 17 | Property Tenancy Type ID | string | Hidden | :green_circle: Public | Tenancy type identifier |
| 18 | Acknowledgment Start Date And Time | date | Visible | :green_circle: Public | Date contractor acknowledged the task |
| 19 | Acknowledgment End Date And Time | date | Visible | :green_circle: Public | Date acknowledgment window closed |
| 20 | Invoice Processed Date | date | Visible | :green_circle: Public | Date the invoice was processed |
| 21 | Actual Contractor Completion Date | date | Visible | :green_circle: Public | Date the contractor completed work on-site |
| 22 | Expected Completion Date | date | Visible | :green_circle: Public | Target date for task completion |
| 23 | Expected On-Site Date | date | Visible | :green_circle: Public | Expected date for contractor to arrive on-site |
| 24 | Total Amount Last Updated On | date | Visible | :green_circle: Public | Date the capped amount was last updated |
| 25 | Web Expenses Amount Last Updated On | date | Visible | :green_circle: Public | Date the web expenses amount was last updated |
| 26 | Installation Date | date | Visible | :green_circle: Public | Date of asset installation (if applicable) |
| 27 | Contractor Completion Email Received | date | Visible | :green_circle: Public | Date the contractor completion email was received |
| 28 | Icode | string | Hidden | :green_circle: Public | Internal information code identifier |
| 29 | Information Code | string | Visible | :green_circle: Public | Descriptive information code for the task type |
| 30 | Location Code | string | Visible | :green_circle: Public | Code for the property location where work is performed |
| 31 | Location Name | string | Visible | :green_circle: Public | Name of the property area (e.g., Kitchen, Bathroom) |
| 32 | Work Task | string | Visible | :green_circle: Public | Description of the specific task to be performed |
| 33 | Area Seq | int64 | Hidden | :green_circle: Public | Sequence number for the area |
| 34 | Assets | string | Visible | :green_circle: Public | Asset name associated with the task |
| 35 | Contract Service Name | string | Visible | :yellow_circle: In-Confidence | Contractor/service provider name |
| 36 | Comments | string | Visible | :yellow_circle: In-Confidence | Free-text comments about the task |
| 37 | Information Code Detail | string | Visible | :yellow_circle: In-Confidence | Detailed information code description |
| 38 | G/L Code | string | Hidden | :yellow_circle: In-Confidence | General ledger maintenance code |
| 39 | Work Type | string | Visible | :green_circle: Public | Classification of the maintenance work type |
| 40 | Amount | double | Visible | :yellow_circle: In-Confidence | Cost amount for this task |
| 41 | Created Date | date | Visible | :green_circle: Public | Date the task record was created |
| 42 | Modified Date | date | Visible | :green_circle: Public | Date the task record was last modified |

---

## Source SQL

```sql
SELECT
    [fact_property_maintenance_task_key]                                                                         AS [Fact Property Maintenance Task KEY],
    [property_maintenance_task_id]                                                                               AS [Property Maintenance Task ID],
    [property_maintenance_id]                                                                                    AS [Property Maintenance ID],
    [dim_property_maintenance_key]                                                                               AS [Dim Property Maintenance KEY],
    [dim_property_key]                                                                                           AS [Dim Property KEY],
    [dim_property_detail_key]                                                                                    AS [Dim Property Detail KEY],
    [dim_property_healthy_homes_key]                                                                             AS [Dim Property Healthy Homes KEY],
    [dim_property_tenancy_key]                                                                                   AS [Dim Property Tenancy KEY],
    [dim_property_program_key]                                                                                   AS [Dim Property Program KEY],
    [dim_property_maintenace_type_key]                                                                           AS [Dim Property Maintenace Type KEY],
    [property_id]                                                                                                AS [Property ID],
    [property_maintenance_type_id]                                                                               AS [Property Maintenance Type ID],
    [property_program_id]                                                                                        AS [Property Program ID],
    [property_subprogram_id]                                                                                     AS [Property Subprogram ID],
    [property_tenancy_id]                                                                                        AS [Property Tenancy ID],
    [property_maintenace_type_id]                                                                                AS [Property Maintenace Type ID],
    [property_tenancy_type_id]                                                                                   AS [Property Tenancy Type ID],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_acknowledgment_date_key], -1) AS VARCHAR(8)), 112)  AS [Acknowledgment Start Date And Time],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_acknowledgment_end_date_key], -1) AS VARCHAR(8)), 112) AS [Acknowledgment End Date And Time],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_actual_completion_date_key], -1) AS VARCHAR(8)), 112) AS [Invoice Processed Date],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_contractor_work_completion_date_key], -1) AS VARCHAR(8)), 112) AS [Actual Contractor Completion Date],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_expected_completion_date_key], -1) AS VARCHAR(8)), 112) AS [Expected Completion Date],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_expected_onsite_date_key], -1) AS VARCHAR(8)), 112) AS [Expected On-Site Date],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_total_capped_amount_date_key], -1) AS VARCHAR(8)), 112) AS [Total Amount Last Updated On],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_web_expenses_amount_date_key], -1) AS VARCHAR(8)), 112) AS [Web Expenses Amount Last Updated On],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_assets_installation_date_key], -1) AS VARCHAR(8)), 112) AS [Installation Date],
    TRY_CONVERT(DATE, CAST(NULLIF([property_maintenance_task_contractor_status_date_key], -1) AS VARCHAR(8)), 112) AS [Contractor Completion Email Received],
    [property_maintenance_task_icode]                                                                            AS [Icode],
    [property_maintenance_task_information_code_name]                                                            AS [Information Code],
    [property_maintenance_task_location_code]                                                                    AS [Location Code],
    [property_maintenance_task_location_name]                                                                    AS [Location Name],
    [property_maintenance_task_work_task_name]                                                                   AS [Work Task],
    [property_maintenance_task_area_seq]                                                                         AS [Area Seq],
    [property_maintenance_task_assets_name]                                                                      AS [Assets],
    [property_maintenance_contract_service_name]                                                                 AS [Contract Service Name],
    [property_maintenance_task_comments]                                                                         AS [Comments],
    [property_maintenance_task_information_code_detail_name]                                                     AS [Information Code Detail],
    [property_maintenance_task_maintenance_code]                                                                 AS [G/L Code],
    [property_maintenance_task_maintenance_type_name]                                                            AS [Work Type],
    [property_maintenance_task_amount]                                                                           AS [Amount],
    CAST([property_maintenance_task_created_datetime] AS DATE)                                                   AS [Created Date],
    CAST([property_maintenance_task_modified_datetime] AS DATE)                                                  AS [Modified Date]
FROM [edw].[fact_property_maintenance_task]
WHERE [property_maintenance_task_is_delete_flag] IS NULL
    AND [DWHDMLOperation] <> 'D';
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, capitalises ID/KEY suffixes. Applied to all column names after SQL aliasing.
- **Filters**:
  - `property_maintenance_task_is_delete_flag IS NULL` -- Excludes source-system deleted tasks
  - `DWHDMLOperation <> 'D'` -- Excludes soft-deleted EDW rows
- **Type conversions**:
  - 10 date key columns (int YYYYMMDD) converted to DATE via `TRY_CONVERT(DATE, CAST(NULLIF(..., -1) AS VARCHAR(8)), 112)`
  - `NULLIF(..., -1)` handles the EDW sentinel value -1 for missing dates
  - 2 datetime columns (`created_datetime`, `modified_datetime`) converted to DATE via `CAST(... AS DATE)`

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Property Maintenance Task | Property ID | Property | Property ID | Many-to-One | Single |
| Property Maintenance Task | Property Maintenance ID | Property Maintenance | Property Maintenance ID | Many-to-One | Both |
| Property Maintenance Task | Property Maintenance Type ID | Property Maintenance Type | Property Maintenance Type ID | Many-to-One | Both |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Maintenance Work Orders | 05. Maintenance | Count of parent work order rows (from Property Maintenance table) |
| Active Maintenance Work Orders | 05. Maintenance | Work orders where Task State = "Active" |
| Inactive Maintenance Work Orders | 05. Maintenance | Work orders where Task State = "Inactive" |
| Total Maintenance Tasks | 05. Maintenance | Count of all task line items |
| Total Maintenance Cost | 05. Maintenance | Sum of Amount across all tasks |
| Avg Maintenance Task Cost | 05. Maintenance | Average Amount per task |
| Maintenance - Emergency | 05. Maintenance\By Urgency | Work orders with urgency = "Emergency" |
| Maintenance - Urgent | 05. Maintenance\By Urgency | Work orders with urgency = "Urgent" |
| Maintenance - Standard | 05. Maintenance\By Urgency | Work orders with urgency = "Standard" |
| Maintenance - Cyclical | 05. Maintenance\By Urgency | Work orders with urgency = "Cyclical" |
| Maintenance Completed By Contractor | 05. Maintenance\Completion | Work orders flagged as completed by contractor |
| Maintenance Post Inspection Done | 05. Maintenance\Completion | Work orders with post-inspection completed |
| Maintenance Completed Satisfactorily | 05. Maintenance\Completion | Work orders flagged as completed satisfactorily |
| Maintenance Confirmed For Payment | 05. Maintenance\Completion | Work orders confirmed for payment |
| Maintenance Finalised | 05. Maintenance\Completion | Work orders flagged as finalised |
| Maintenance - Tenant Damage | 05. Maintenance\Liability | Work orders flagged as tenant damage |
| Maintenance - Tenant Liable | 05. Maintenance\Liability | Work orders where tenant is liable |
| Maintenance - Tenants Charged | 05. Maintenance\Liability | Work orders where tenants have been charged |
| Maintenance - Cancelled | 05. Maintenance | Work orders flagged as cancelled |
| Maintenance - On Hold | 05. Maintenance | Work orders flagged as on hold |
