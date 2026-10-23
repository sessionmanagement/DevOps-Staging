# Property Maintenance Type

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
| **Power BI Table Name** | Property Maintenance Type |
| **Source** | `edw.dim_property_maintenace_type` (note: typo in source table name -- missing 'n' in "maintenance") |
| **Query Group** | Dim Tables |
| **Row Description** | Each row represents a maintenance work type classification used to categorise tasks |
| **Column Count** | 11 |
| **Overall Classification** | Public |

The Property Maintenance Type table is a lookup/reference dimension for maintenance work type classifications. It contains type codes, account codes, priority levels, and liability flags used to categorise maintenance tasks. As reference data with no personally identifiable or business-sensitive information, all columns are classified as Public.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive reference data | All columns -- Name, Priority, Work Type Code, flags |
| :yellow_circle: **In-Confidence** | N/A | N/A |
| :red_circle: **Sensitive** | N/A | N/A |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Dim Property Maintenace Type ID | int64 | Hidden | :green_circle: Public | Surrogate key (note: retains source typo) |
| 2 | Property Maintenance Type ID | string | Hidden | :green_circle: Public | Business key (GUID) |
| 3 | G/L Code | string | Hidden | :green_circle: Public | General ledger account code |
| 4 | Name | string | Visible | :green_circle: Public | Maintenance type name |
| 5 | Work Type Code | string | Hidden | :green_circle: Public | Work type classification code |
| 6 | Service Agreement Priority | string | Visible | :green_circle: Public | Priority under service agreement |
| 7 | Priority | string | Visible | :green_circle: Public | General priority level |
| 8 | Owner Recovery Flag | int64 | Visible | :green_circle: Public | 1 = cost recoverable from owner |
| 9 | Service Agreement Flag | int64 | Visible | :green_circle: Public | 1 = covered by service agreement |
| 10 | Tenant Liable Flag | int64 | Visible | :green_circle: Public | 1 = tenant is liable for cost |
| 11 | Account Type | string | Visible | :green_circle: Public | Account type classification |

---

## Source SQL

```sql
SELECT
    [dim_property_maintenace_type_id]                  AS [Dim Property Maintenace Type ID],
    [property_maintenance_type_id]                     AS [Property Maintenance Type ID],
    [property_maintenance_type_account_code]           AS [G/L Code],
    [property_maintenance_type]                        AS [Name],
    [property_maintenance_type_code]                   AS [Work Type Code],
    [property_maintenance_service_agreement_priority]  AS [Service Agreement Priority],
    [property_maintenance_priority]                    AS [Priority],
    [property_maintenance_owner_recovery_flag]         AS [Owner Recovery Flag],
    [property_maintenance_service_agreement_flag]      AS [Service Agreement Flag],
    [property_maintenance_tenant_liable_flag]          AS [Tenant Liable Flag],
    [property_maintenance_account_type]                AS [Account Type]
FROM [edw].[dim_property_maintenace_type]
WHERE [property_maintenance_deleted_flag] IS NULL
    AND [DWHIsCurrent] = 1
    AND [DWHDMLOperation] <> 'D'
    AND [property_maintenance_type_id] IS NOT NULL;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, applies proper case. Capitalises ID, KEY, DWH.
- **Source table typo**: The EDW source table is named `dim_property_maintenace_type` (missing 'n' in "maintenance"). This typo is retained in the surrogate key column name `Dim Property Maintenace Type ID`.
- **Filters**:
  - `property_maintenance_deleted_flag IS NULL` (exclude soft-deleted records)
  - `DWHIsCurrent = 1` (current SCD Type 2 record only)
  - `DWHDMLOperation <> 'D'` (exclude deleted records)
  - `property_maintenance_type_id IS NOT NULL`

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Maintenance Task | Property Maintenance Type ID | Property Maintenance Type | Property Maintenance Type ID | Many-to-One | Both |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Work Orders by Type | 05. Maintenance | Count of work orders grouped by maintenance type |
| Service Agreement Work Orders | 05. Maintenance | Count of work orders covered by service agreement |
| Tenant Liable Work Orders | 05. Maintenance | Count of work orders where tenant is liable |
