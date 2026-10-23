# Property Maintenance

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
| **Power BI Table Name** | Property Maintenance |
| **Source** | `edw.dim_property_maintenance` |
| **Query Group** | Dim Tables |
| **Row Description** | Each row represents a maintenance work order for a property |
| **Column Count** | 55 |
| **Overall Classification** | In-Confidence |

The Property Maintenance table contains maintenance work orders for properties. Each record represents a maintenance request or job with its status, contractor assignment, and workflow flags. This is the header-level dimension; individual maintenance tasks are tracked in the separate Property Maintenance Task table. The table includes numerous boolean flags tracking the workflow state of each work order through its lifecycle.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive business data freely shared within the organisation | Task State, Status, Urgency, workflow flags, dates |
| :yellow_circle: **In-Confidence** | Business-sensitive data requiring controlled access | Housing Officer, Owning User, Client, cost-related flags |
| :red_circle: **Sensitive** | No sensitive (PII) columns in this table | N/A |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Dim Property Maintenance KEY | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Property Maintenance ID | string | Hidden | :green_circle: Public | Business key (GUID) |
| 3 | Task State | string | Visible | :green_circle: Public | Current state of the maintenance task |
| 4 | Task State Status | string | Visible | :green_circle: Public | Status within the task state |
| 5 | Maintenance Type | string | Visible | :green_circle: Public | Type of maintenance work |
| 6 | Acknowledgment Type | string | Visible | :green_circle: Public | Type of acknowledgment |
| 7 | Contractor Status | string | Visible | :green_circle: Public | Status of contractor assignment |
| 8 | Contractor Status Date | date | Visible | :green_circle: Public | Date of contractor status change |
| 9 | Damage Type | string | Visible | :green_circle: Public | Type of damage reported |
| 10 | Key Access Information | string | Visible | :green_circle: Public | Key access details for property |
| 11 | Property Status | string | Visible | :green_circle: Public | Property status at time of work order |
| 12 | Send Workorder To | string | Visible | :green_circle: Public | Recipient of the work order |
| 13 | Task Status | string | Visible | :green_circle: Public | Current task status |
| 14 | Task Urgency | string | Visible | :green_circle: Public | Urgency level of the task |
| 15 | Is Completed By Contractor | int64 | Visible | :green_circle: Public | 1 = completed by contractor |
| 16 | Is Post Inspection Done | int64 | Visible | :green_circle: Public | 1 = post inspection completed |
| 17 | Has Tenant Consent | int64 | Visible | :green_circle: Public | 1 = tenant consent obtained |
| 18 | Is Acknowledgment Sent To Tenant | int64 | Visible | :green_circle: Public | 1 = acknowledgment sent |
| 19 | Is Work Task Cancelled | int64 | Visible | :green_circle: Public | 1 = task cancelled |
| 20 | Is Completed Satisfactorily | int64 | Visible | :green_circle: Public | 1 = completed satisfactorily |
| 21 | Is Confirmed For Payment | int64 | Visible | :yellow_circle: In-Confidence | 1 = confirmed for payment |
| 22 | Is Dummy Completed Keep Status | int64 | Hidden | :green_circle: Public | Internal workflow flag |
| 23 | Is ECD Queue Processed | int64 | Hidden | :green_circle: Public | Internal queue processing flag |
| 24 | Has Email | int64 | Visible | :green_circle: Public | 1 = email communication exists |
| 25 | Is Exported | int64 | Hidden | :green_circle: Public | 1 = record exported |
| 26 | Is Work Task Finalised | int64 | Visible | :green_circle: Public | 1 = task finalised |
| 27 | Is Flexi Fund | int64 | Hidden | :yellow_circle: In-Confidence | 1 = funded via flexi fund |
| 28 | Is Invoice Details Queue Processed | int64 | Hidden | :yellow_circle: In-Confidence | Invoice queue processing flag |
| 29 | Has Letter | int64 | Visible | :green_circle: Public | 1 = letter communication exists |
| 30 | Is On Hold | int64 | Visible | :green_circle: Public | 1 = task on hold |
| 31 | Is Owner Recovery | int64 | Visible | :yellow_circle: In-Confidence | 1 = cost recoverable from owner |
| 32 | Has Phone Call | int64 | Visible | :green_circle: Public | 1 = phone call logged |
| 33 | Is Request Queue Processed | int64 | Hidden | :green_circle: Public | Request queue processing flag |
| 34 | Send Email When PFM Cancelled | int64 | Hidden | :green_circle: Public | Email notification on cancellation |
| 35 | Has Support Email | int64 | Visible | :green_circle: Public | 1 = support email sent |
| 36 | Is Tenant Email Suppressed | int64 | Visible | :green_circle: Public | 1 = tenant email suppressed |
| 37 | Is Tenant Damage | int64 | Visible | :green_circle: Public | 1 = damage caused by tenant |
| 38 | Is Tenant Liable | int64 | Visible | :yellow_circle: In-Confidence | 1 = tenant financially liable |
| 39 | Are Tenants Charged | int64 | Visible | :yellow_circle: In-Confidence | 1 = tenants have been charged |
| 40 | Has Tenants Permission | int64 | Visible | :green_circle: Public | 1 = tenant permission obtained |
| 41 | Has Text Message | int64 | Visible | :green_circle: Public | 1 = text message sent |
| 42 | Is Variation Queue Processed | int64 | Hidden | :green_circle: Public | Variation queue processing flag |
| 43 | Is Work Quote Queue Processed | int64 | Hidden | :green_circle: Public | Work quote queue flag |
| 44 | Is Work Task Completion Queue Processed | int64 | Hidden | :green_circle: Public | Task completion queue flag |
| 45 | Inspection ID | string | Hidden | :green_circle: Public | Related inspection identifier |
| 46 | Cancellation Requested By | string | Visible | :yellow_circle: In-Confidence | Person who requested cancellation |
| 47 | Client | string | Hidden | :yellow_circle: In-Confidence | Client name (hidden) |
| 48 | Housing Officer | string | Visible | :yellow_circle: In-Confidence | Assigned housing officer |
| 49 | ZAV Invoice Approved By | string | Hidden | :yellow_circle: In-Confidence | Invoice approval authority |
| 50 | Key Support Contact | string | Visible | :green_circle: Public | Key support contact person |
| 51 | Legal Owner Primary Contact | string | Visible | :green_circle: Public | Legal owner primary contact |
| 52 | Owning Business Unit Name | string | Visible | :green_circle: Public | Business unit owning the record |
| 53 | Owning User Full Name | string | Hidden | :yellow_circle: In-Confidence | CRM record owner |
| 54 | Created Date | date | Visible | :green_circle: Public | Record creation date |
| 55 | Modified Date | date | Visible | :green_circle: Public | Record last modified date |

---

## Source SQL

```sql
SELECT
    [dim_property_maintenance_key]                                              AS [Dim Property Maintenance KEY],
    [property_maintenance_id]                                                   AS [Property Maintenance ID],
    [property_maintenance_task_state]                                            AS [Task State],
    [property_maintenance_task_state_status]                                     AS [Task State Status],
    [property_maintenance_type]                                                 AS [Maintenance Type],
    [property_maintenance_acknowledgment_type]                                  AS [Acknowledgment Type],
    [property_maintenance_contractor_status]                                    AS [Contractor Status],
    CAST([property_maintenance_contractor_status_datetime] AS DATE)             AS [Contractor Status Date],
    [property_maintenance_damage_type]                                          AS [Damage Type],
    [property_maintenance_key_access_information]                               AS [Key Access Information],
    [property_maintenance_property_status]                                      AS [Property Status],
    [property_maintenance_send_workorder_to]                                    AS [Send Workorder To],
    [property_maintenance_task_status]                                          AS [Task Status],
    [property_maintenance_task_urgency]                                         AS [Task Urgency],
    [property_maintenance_completed_by_contractor_flag]                         AS [Is Completed By Contractor],
    [property_maintenance_post_inspection_done_flag]                            AS [Is Post Inspection Done],
    [property_maintenance_tenant_consent_flag]                                  AS [Has Tenant Consent],
    [property_maintenance_acknowledgment_sent_to_tenant_flag]                   AS [Is Acknowledgment Sent To Tenant],
    [property_maintenance_cancel_work_task_flag]                                AS [Is Work Task Cancelled],
    [property_maintenance_completed_satisfactorily_flag]                        AS [Is Completed Satisfactorily],
    [property_maintenance_confirmed_for_payment_flag]                           AS [Is Confirmed For Payment],
    [property_maintenance_dummy_completed_but_keep_task_status_flag]            AS [Is Dummy Completed Keep Status],
    [property_maintenance_ecd_processed_queue_flag]                             AS [Is ECD Queue Processed],
    [property_maintenance_email_flag]                                           AS [Has Email],
    [property_maintenance_exported_flag]                                        AS [Is Exported],
    [property_maintenance_finalised_work_task_flag]                             AS [Is Work Task Finalised],
    [property_maintenance_flexi_fund_flag]                                      AS [Is Flexi Fund],
    [property_maintenance_invoice_details_processed_queue_flag]                 AS [Is Invoice Details Queue Processed],
    [property_maintenance_letter_flag]                                          AS [Has Letter],
    [property_maintenance_onhold_flag]                                          AS [Is On Hold],
    [property_maintenance_owner_recovery_flag]                                  AS [Is Owner Recovery],
    [property_maintenance_phonecall_flag]                                       AS [Has Phone Call],
    [property_maintenance_request_received_sent_processed_queue_flag]           AS [Is Request Queue Processed],
    [property_maintenance_send_email_notification_when_pfm_cancelled_flag]      AS [Send Email When PFM Cancelled],
    [property_maintenance_support_email_flag]                                   AS [Has Support Email],
    [property_maintenance_suppress_tenant_email_flag]                           AS [Is Tenant Email Suppressed],
    [property_maintenance_tenant_damage_flag]                                   AS [Is Tenant Damage],
    [property_maintenance_tenant_liable_flag]                                   AS [Is Tenant Liable],
    [property_maintenance_tenants_charged_flag]                                 AS [Are Tenants Charged],
    [property_maintenance_tenants_permission_flag]                              AS [Has Tenants Permission],
    [property_maintenance_text_message_flag]                                    AS [Has Text Message],
    [property_maintenance_variation_processed_queue_flag]                       AS [Is Variation Queue Processed],
    [property_maintenance_work_quote_processed_queue_flag]                      AS [Is Work Quote Queue Processed],
    [property_maintenance_work_task_completion_processed_queue_flag]            AS [Is Work Task Completion Queue Processed],
    [property_maintenance_inspection_identifier]                                AS [Inspection ID],
    [property_maintenance_cancellation_requested_by]                            AS [Cancellation Requested By],
    [property_maintenance_client]                                               AS [Client],
    [property_maintenance_housing_officer]                                      AS [Housing Officer],
    [property_maintenance_zav_invoice_approved_by]                              AS [ZAV Invoice Approved By],
    [property_maintenance_key_support_contact]                                  AS [Key Support Contact],
    [property_maintenance_legal_owner_primary_contact]                          AS [Legal Owner Primary Contact],
    [property_maintenance_owning_business_unit_name]                            AS [Owning Business Unit Name],
    [property_maintenance_owning_user]                                          AS [Owning User Full Name],
    CAST([property_maintenance_created_datetime] AS DATE)                       AS [Created Date],
    CAST([property_maintenance_modified_datetime] AS DATE)                      AS [Modified Date]
FROM [edw].[dim_property_maintenance]
WHERE [property_maintenance_is_delete_flag] IS NULL
    AND [DWHIsCurrent] = 1
    AND [DWHDMLOperation] <> 'D'
    AND [property_maintenance_id] IS NOT NULL;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, applies proper case. Capitalises ID, KEY, DWH.
- **Filters**:
  - `property_maintenance_is_delete_flag IS NULL` (exclude soft-deleted records)
  - `DWHIsCurrent = 1` (current SCD Type 2 record only)
  - `DWHDMLOperation <> 'D'` (exclude deleted records)
  - `property_maintenance_id IS NOT NULL`
- **Type conversions**: `property_maintenance_contractor_status_datetime`, `property_maintenance_created_datetime`, `property_maintenance_modified_datetime` all CAST to DATE

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Maintenance Task | Property Maintenance ID | Property Maintenance | Property Maintenance ID | Many-to-One | Both |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Work Orders | 05. Maintenance | Count of all maintenance work orders |
| Open Work Orders | 05. Maintenance | Count of work orders not yet finalised |
| Completed Work Orders | 05. Maintenance | Count of finalised work orders |
| Cancelled Work Orders | 05. Maintenance | Count of cancelled work orders |
| Tenant Damage Count | 05. Maintenance | Count of work orders flagged as tenant damage |
| Tenant Liable Count | 05. Maintenance | Count of work orders where tenant is liable |
| Owner Recovery Count | 05. Maintenance | Count of work orders with owner recovery |
| Average Time To Complete | 05. Maintenance | Average days from creation to completion |
