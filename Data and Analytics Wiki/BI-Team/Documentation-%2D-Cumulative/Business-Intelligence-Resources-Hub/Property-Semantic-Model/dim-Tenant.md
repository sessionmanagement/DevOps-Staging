# Tenant

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
| **Power BI Table Name** | Tenant |
| **Source** | `edw.fact_property_tenant` |
| **Query Group** | Fact Tables |
| **Row Description** | Each row represents an individual tenant or household member associated with a tenancy |
| **Column Count** | 48 (46 SQL columns + 2 DAX calculated columns) |
| **Overall Classification** | Sensitive |

The Tenant table contains individual tenants and household members associated with tenancies. Despite being sourced from a fact table in the EDW, it serves as a dimensional table in the semantic model. It includes demographic information (name, DOB, gender, ethnicity, disability), contact details, and tenancy relationship data. Two DAX calculated columns compute Age and Age Group dynamically from Date of Birth.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive business data freely shared within the organisation | Registration Date, Is Primary Tenant, Record Source, status fields |
| :yellow_circle: **In-Confidence** | Business-sensitive data requiring controlled access | Total Rent Amount, Rent Share Total, Total Income, Employment Status |
| :red_circle: **Sensitive** | Personally identifiable or health information requiring strict controls | Full Name, First/Last Name, DOB, Gender, Ethnicity, Disability |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Fact Property Tenant KEY | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Dim Property KEY | int64 | Hidden | :green_circle: Public | FK surrogate to Property |
| 3 | Dim Property Tenancy KEY | int64 | Hidden | :green_circle: Public | FK surrogate to Tenancy |
| 4 | Dim Property Program KEY | int64 | Hidden | :green_circle: Public | FK surrogate to Program |
| 5 | Property Tenancy ID | string | Hidden | :green_circle: Public | FK to Tenancy |
| 6 | Property Tenant ID | string | Hidden | :green_circle: Public | Business key (GUID) |
| 7 | Property ID | string | Hidden | :green_circle: Public | FK to Property |
| 8 | Property Program ID | string | Hidden | :green_circle: Public | FK to Program |
| 9 | Property Subprogram ID | string | Hidden | :green_circle: Public | FK to Subprogram |
| 10 | Total Rent Amount | double | Visible | :yellow_circle: In-Confidence | Total rent amount for tenancy |
| 11 | Tenancy Agreement Date | date | Visible | :green_circle: Public | Lease agreement date (converted from YYYYMMDD int) |
| 12 | Tenancy Start Date | date | Visible | :green_circle: Public | Tenancy start date (converted from YYYYMMDD int) |
| 13 | First Name | string | Hidden | :red_circle: Sensitive | Tenant first name (PII) |
| 14 | Last Name | string | Hidden | :red_circle: Sensitive | Tenant last name (PII) |
| 15 | Full Name | string | Visible | :red_circle: Sensitive | Tenant full name (PII) |
| 16 | Date Of Birth | date | Hidden | :red_circle: Sensitive | Tenant date of birth (PII) |
| 17 | Registration Date | date | Visible | :green_circle: Public | Date tenant was registered |
| 18 | Waharoa Client ID | string | Hidden | :green_circle: Public | External client identifier |
| 19 | Is Primary Tenant | int64 | Visible | :green_circle: Public | 1 = primary lease signatory, 0 = household member |
| 20 | Head Of Household | int64 | Visible | :green_circle: Public | 1 = head of household |
| 21 | Record Source | string | Visible | :green_circle: Public | Source system of the record |
| 22 | State Code | int64 | Hidden | :green_circle: Public | CRM state code |
| 23 | Status Code | int64 | Hidden | :green_circle: Public | CRM status code |
| 24 | Tenancy Name | string | Visible | :red_circle: Sensitive | Name of tenancy (contains PII) |
| 25 | Household Name | string | Visible | :red_circle: Sensitive | Household name (contains PII) |
| 26 | Household ID | string | Hidden | :green_circle: Public | Household identifier |
| 27 | Number Of Household Members | int64 | Visible | :green_circle: Public | Count of household members |
| 28 | Named Household Members | string | Visible | :red_circle: Sensitive | Names of household members (PII) |
| 29 | Rent Share Total | double | Visible | :yellow_circle: In-Confidence | Tenant's share of rent |
| 30 | Total Income Of The Household | double | Hidden | :red_circle: Sensitive | Total household income (PII + financial) |
| 31 | Ethnicity | string | Visible | :red_circle: Sensitive | Tenant ethnicity (PII) |
| 32 | Created Date | date | Visible | :green_circle: Public | Record creation date |
| 33 | Modified Date | date | Visible | :green_circle: Public | Record last modified date |
| 34 | Gender | string | Visible | :red_circle: Sensitive | Tenant gender (PII) |
| 35 | Disability | string | Hidden | :red_circle: Sensitive | Disability information (PII/PHI) |
| 36 | Target Group | string | Visible | :green_circle: Public | Target demographic group |
| 37 | Employment Status | string | Visible | :yellow_circle: In-Confidence | Employment status |
| 38 | Contact Type | string | Visible | :green_circle: Public | Type of contact |
| 39 | EA Target Group | string | Hidden | :green_circle: Public | Emerge Aotearoa target group |
| 40 | Occupant State | string | Visible | :green_circle: Public | Occupant CRM state |
| 41 | Occupant Status | string | Visible | :green_circle: Public | Occupant CRM status |
| 42 | Household State | string | Visible | :green_circle: Public | Household CRM state |
| 43 | Household Status | string | Visible | :green_circle: Public | Household CRM status |
| 44 | Tenancy State | string | Visible | :green_circle: Public | Tenancy CRM state |
| 45 | Tenancy Status | string | Hidden | :green_circle: Public | Tenancy CRM status |
| 46 | DWH DML Operation | string | Hidden | :green_circle: Public | SCD2 DML operation flag |
| 47 | Age | int64 | Visible | :red_circle: Sensitive | DAX: calculated years from Date Of Birth to TODAY() |
| 48 | Age Group | string | Visible | :red_circle: Sensitive | DAX: "Adult" if Age >= 18, "Child" if < 18 |

---

## Source SQL

```sql
SELECT
    [fact_property_tenant_key]                                      AS [Fact Property Tenant KEY],
    [dim_property_key]                                              AS [Dim Property KEY],
    [dim_property_tenancy_key]                                      AS [Dim Property Tenancy KEY],
    [dim_property_program_key]                                      AS [Dim Property Program KEY],
    [property_tenancy_id]                                           AS [Property Tenancy ID],
    [property_tenant_id]                                            AS [Property Tenant ID],
    [property_id]                                                   AS [Property ID],
    [property_program_id]                                           AS [Property Program ID],
    [property_subprogram_id]                                        AS [Property Subprogram ID],
    [property_tenancy_total_rent_amount]                            AS [Total Rent Amount],
    CASE
        WHEN [property_tenant_tenancy_lease_agreement_date_id] IS NULL
            OR [property_tenant_tenancy_lease_agreement_date_id] = 0
        THEN NULL
        ELSE DATEFROMPARTS(
            [property_tenant_tenancy_lease_agreement_date_id] / 10000,
            ([property_tenant_tenancy_lease_agreement_date_id] / 100) % 100,
            [property_tenant_tenancy_lease_agreement_date_id] % 100
        )
    END                                                             AS [Tenancy Agreement Date],
    CASE
        WHEN [property_tenant_tenancy_start_date_id] IS NULL
            OR [property_tenant_tenancy_start_date_id] = 0
        THEN NULL
        ELSE DATEFROMPARTS(
            [property_tenant_tenancy_start_date_id] / 10000,
            ([property_tenant_tenancy_start_date_id] / 100) % 100,
            [property_tenant_tenancy_start_date_id] % 100
        )
    END                                                             AS [Tenancy Start Date],
    [property_tenant_first_name]                                    AS [First Name],
    [property_tenant_last_name]                                     AS [Last Name],
    [property_tenant_full_name]                                     AS [Full Name],
    CAST([property_tenancy_tenant_date_of_birth] AS DATE)           AS [Date Of Birth],
    CAST([property_tenant_registration_date] AS DATE)               AS [Registration Date],
    [property_tenant_client_identifier]                             AS [Waharoa Client ID],
    [occupant_is_main_applicant_flag]                               AS [Is Primary Tenant],
    [property_tenant_primary_tenant_flag]                           AS [Head Of Household],
    [occupant_record_source]                                        AS [Record Source],
    [occupant_statecode]                                            AS [State Code],
    [occupant_statuscode]                                           AS [Status Code],
    [property_tenant_tenancy_name]                                  AS [Tenancy Name],
    [property_tenant_household_name]                                AS [Household Name],
    [property_tenancy_household_identifier]                         AS [Household ID],
    [property_tenant_number_of_household_members]                   AS [Number Of Household Members],
    [property_tenant_named_household_members]                       AS [Named Household Members],
    [property_tenant_rent_share_total]                              AS [Rent Share Total],
    [property_tenant_total_household_income]                        AS [Total Income Of The Household],
    [property_tenant_ethnicity_name]                                AS [Ethnicity],
    CAST([property_tenant_created_datetime] AS DATE)                AS [Created Date],
    CAST([property_tenant_modified_datetime] AS DATE)               AS [Modified Date],
    [occupant_gender_label]                                         AS [Gender],
    [occupant_disability_label]                                     AS [Disability],
    [occupant_targetgroup_label]                                    AS [Target Group],
    [occupant_employment_label]                                     AS [Employment Status],
    [occupant_contacttype_label]                                    AS [Contact Type],
    [occupant_eatargetgroup_label]                                  AS [EA Target Group],
    [occupant_state_label]                                          AS [Occupant State],
    [occupant_status_label]                                         AS [Occupant Status],
    [household_state_label]                                         AS [Household State],
    [household_status_label]                                        AS [Household Status],
    [property_tenant_opportunity_state]                             AS [Tenancy State],
    [property_tenant_opportunity_status]                            AS [Tenancy Status],
    [DWHDMLOperation]                                               AS [DWH DML Operation]
FROM [edw].[fact_property_tenant]
WHERE [DWHDMLOperation] <> 'D'
    AND [property_tenant_is_delete_flag] IS NULL;
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, applies proper case. Capitalises ID, KEY, DWH.
- **Filters**:
  - `DWHDMLOperation <> 'D'` (exclude deleted records)
  - `property_tenant_is_delete_flag IS NULL` (exclude soft-deleted records)
- **Type conversions**:
  - `property_tenant_tenancy_lease_agreement_date_id` and `property_tenant_tenancy_start_date_id`: Integer YYYYMMDD format converted to DATE using DATEFROMPARTS (in M query: `Date.FromText` with string manipulation)
  - `property_tenancy_tenant_date_of_birth`, `property_tenant_registration_date`, `property_tenant_created_datetime`, `property_tenant_modified_datetime`: CAST to DATE
- **DAX calculated columns** (2 columns computed at model level):
  - **Age**: Calculates years between Date Of Birth and TODAY(), accounting for whether birthday has occurred this year
  - **Age Group**: Returns "Adult" if Age >= 18, "Child" if < 18, BLANK() if no DOB

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Tenant | Property Tenancy ID | Tenancy | Property Tenancy ID | Many-to-One | Both |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Tenants | 03. Tenant | Count of all tenant records |
| Primary Tenants | 03. Tenant | Count of tenants where Is Primary Tenant = 1 |
| Household Members | 03. Tenant | Count of non-primary household members |
| Average Household Size | 03. Tenant | Average Number Of Household Members |
| Adults | 10. Tenant Demographics | Count of tenants with Age Group = "Adult" |
| Children | 10. Tenant Demographics | Count of tenants with Age Group = "Child" |
| Average Age | 10. Tenant Demographics | Average age of tenants |
| Gender Distribution | 10. Tenant Demographics | Count by gender category |
| Ethnicity Distribution | 10. Tenant Demographics | Count by ethnicity category |
