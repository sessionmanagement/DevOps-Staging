# Property

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
| **Power BI Table Name** | Property |
| **Source** | `edw.dim_property` LEFT JOIN `edw.dim_property_program` |
| **Query Group** | Dim Tables |
| **Row Description** | Each row represents a unique property managed by Emerge Aotearoa housing services |
| **Column Count** | 66 |
| **Overall Classification** | In-Confidence |

The Property table is the central dimension in the Property Semantic Model star schema. It contains all properties managed by Emerge Aotearoa, including transitional housing, community housing, and supported accommodation. Each record represents a unique property with its current state, joined to the property program dimension for program ownership details.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive business data freely shared within the organisation | Address fields, Program, Sub Program, Status, dates, Property Type |
| :yellow_circle: **In-Confidence** | Business-sensitive data requiring controlled access | IRRS amounts, Current Rent, Market Rent, financial data |
| :red_circle: **Sensitive** | No sensitive (PII) columns in this table | N/A |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Dim Property KEY | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Property ID | string | Hidden | :green_circle: Public | Business key (GUID) |
| 3 | Acquired Date | date | Visible | :green_circle: Public | Date property was acquired |
| 4 | Property Service Code | string | Visible | :green_circle: Public | EAHT Business Central service code |
| 5 | Property Service Name | string | Visible | :green_circle: Public | EAHT Business Central service name |
| 6 | Suburb | string | Visible | :green_circle: Public | Suburb/city name (sourced from property_city_name) |
| 7 | Confirmed Disposal Date | date | Visible | :green_circle: Public | Date disposal was confirmed |
| 8 | Contract Service Name | string | Visible | :green_circle: Public | EAL Business Central service name |
| 9 | Contract Service Code | string | Visible | :green_circle: Public | EAL Business Central service code |
| 10 | Current Rent | double | Visible | :yellow_circle: In-Confidence | Weekly rent amount |
| 11 | Current Rent (Base) | double | Hidden | :yellow_circle: In-Confidence | Base currency rent amount |
| 12 | Tenant Name | string | Hidden | :green_circle: Public | Current tenancy name |
| 13 | Date Constructed | date | Visible | :green_circle: Public | Construction date |
| 14 | Days Available To Let | int64 | Visible | :green_circle: Public | Number of days available to let |
| 15 | Days Under Maintenance | int64 | Visible | :green_circle: Public | Number of days under maintenance |
| 16 | Disposal Date | date | Visible | :green_circle: Public | Disposal date |
| 17 | Service District | string | Visible | :green_circle: Public | Geographic hierarchy - district level |
| 18 | Full Address | string | Visible | :green_circle: Public | Full street address |
| 19 | Gifted Name | string | Visible | :green_circle: Public | Gifted/cultural name of property |
| 20 | BOS/HUD Ref | string | Visible | :green_circle: Public | Government contract reference number |
| 21 | Latitude | double | Visible | :green_circle: Public | Geographic latitude |
| 22 | Legal Owner Account | string | Visible | :green_circle: Public | Legal owner account name |
| 23 | Longitude | double | Visible | :green_circle: Public | Geographic longitude |
| 24 | Property Name | string | Visible | :green_circle: Public | Property display name |
| 25 | Maximum People Allowed To Reside | int64 | Visible | :green_circle: Public | Maximum occupancy |
| 26 | Room Number | string | Hidden | :green_circle: Public | Number of rooms |
| 27 | Owner Account Name | string | Visible | :green_circle: Public | Property owner account |
| 28 | Owner Full Name | string | Visible | :green_circle: Public | Property owner contact name |
| 29 | Owner Email | string | Visible | :green_circle: Public | Owner organisation email |
| 30 | Parent Property Name | string | Visible | :green_circle: Public | Parent property in hierarchy |
| 31 | Service Region | string | Visible | :green_circle: Public | Top geographic hierarchy level |
| 32 | Postal Code | string | Hidden | :green_circle: Public | Postal code |
| 33 | Program | string | Visible | :green_circle: Public | Housing program name |
| 34 | Program Owner | string | Visible | :green_circle: Public | Business Central company entity owning the program |
| 35 | Property Manager Name | string | Visible | :green_circle: Public | Assigned property manager |
| 36 | Property Manager Email | string | Visible | :green_circle: Public | Property manager email |
| 37 | Property Manager Mobile | string | Visible | :green_circle: Public | Property manager mobile number |
| 38 | Ownership Type | string | Visible | :green_circle: Public | Property ownership classification |
| 39 | Property Type | string | Visible | :green_circle: Public | Type of property |
| 40 | Provider Agreement Number | string | Visible | :green_circle: Public | Funding contract number |
| 41 | Reason For Disposal | string | Visible | :green_circle: Public | Reason property was disposed |
| 42 | Property Ref | string | Visible | :green_circle: Public | Property reference identifier |
| 43 | Relettable Date | date | Visible | :green_circle: Public | Date property is available for re-letting |
| 44 | State | string | Visible | :green_circle: Public | CRM state code |
| 45 | Status | string | Visible | :green_circle: Public | Property status |
| 46 | Status Code | string | Visible | :green_circle: Public | Property status code |
| 47 | Street Name | string | Hidden | :green_circle: Public | Street name component |
| 48 | Street Number | string | Hidden | :green_circle: Public | Street number component |
| 49 | Sub Program | string | Visible | :green_circle: Public | Housing sub-program |
| 50 | Sub Program Owner | string | Hidden | :green_circle: Public | Sub-program owning entity |
| 51 | Property Sub Type | string | Visible | :green_circle: Public | Property sub-type classification |
| 52 | City | string | Visible | :green_circle: Public | City name (sourced from property_suburb) |
| 53 | Housing Group | string | Visible | :green_circle: Public | Target demographic group |
| 54 | District Name | string | Visible | :green_circle: Public | Territorial authority name |
| 55 | Total Days Vacant | int64 | Visible | :green_circle: Public | Cumulative days vacant |
| 56 | Total Heat Source Capacity (Kw) | double | Visible | :green_circle: Public | Total heating capacity in kilowatts |
| 57 | Total IRRS | double | Visible | :yellow_circle: In-Confidence | Income Related Rent Subsidy total |
| 58 | Total IRRS (Base) | double | Hidden | :yellow_circle: In-Confidence | IRRS in base currency |
| 59 | Total IRRS (Last Updated On) | date | Visible | :green_circle: Public | IRRS last update date |
| 60 | Total IRRS (State) | int64 | Hidden | :yellow_circle: In-Confidence | IRRS state code |
| 61 | Transitional Housing Market Rent (Base) | double | Hidden | :yellow_circle: In-Confidence | TH market rent in base currency |
| 62 | Unit | string | Hidden | :green_circle: Public | Unit number |
| 63 | Built Year | string | Visible | :green_circle: Public | Year property was built |
| 64 | Transitional Housing Market Rent | double | Visible | :yellow_circle: In-Confidence | Transitional housing market rent |
| 65 | DWH DML Operation | string | Hidden | :green_circle: Public | SCD2 DML operation flag |
| 66 | DWH Is Current | boolean | Hidden | :green_circle: Public | SCD2 current record flag |

---

## Source SQL

```sql
SELECT
    dp.[dim_property_key]                                           AS [Dim Property KEY],
    dp.[property_id]                                                AS [Property ID],
    CAST(dp.[property_acquired_date] AS DATE)                       AS [Acquired Date],
    dp.[property_bc_service_code]                                   AS [Property Service Code],
    dp.[property_bc_service_name]                                   AS [Property Service Name],
    dp.[property_city_name]                                         AS [Suburb],
    CAST(dp.[property_confirmed_disposal_date] AS DATE)             AS [Confirmed Disposal Date],
    dp.[property_contract_bc_service]                               AS [Contract Service Name],
    dp.[property_contract_bc_service_code]                          AS [Contract Service Code],
    dp.[property_current_rent]                                      AS [Current Rent],
    dp.[property_current_rent_base]                                 AS [Current Rent (Base)],
    dp.[property_current_tenancy]                                   AS [Tenant Name],
    CAST(dp.[property_date_constructed] AS DATE)                    AS [Date Constructed],
    dp.[property_days_available_to_let]                             AS [Days Available To Let],
    dp.[property_days_under_maintenence]                            AS [Days Under Maintenance],
    CAST(dp.[property_disposal_date] AS DATE)                       AS [Disposal Date],
    dp.[property_district]                                          AS [Service District],
    dp.[property_full_address]                                      AS [Full Address],
    dp.[property_gifted_name]                                       AS [Gifted Name],
    dp.[property_hud_msd_reference_number]                          AS [BOS/HUD Ref],
    dp.[property_latitude]                                          AS [Latitude],
    dp.[property_legal_owner]                                       AS [Legal Owner Account],
    dp.[property_longitude]                                         AS [Longitude],
    dp.[property_name]                                              AS [Property Name],
    dp.[property_no_of_people_allowed_to_reside]                    AS [Maximum People Allowed To Reside],
    dp.[property_no_of_rooms]                                       AS [Room Number],
    dp.[property_owner_account]                                     AS [Owner Account Name],
    dp.[property_owner_contact]                                     AS [Owner Full Name],
    dp.[property_owner_organisation_contact_email]                  AS [Owner Email],
    dp.[property_parent_hierarchy]                                  AS [Parent Property Name],
    dp.[property_postal_region]                                     AS [Service Region],
    dp.[property_postcode]                                          AS [Postal Code],
    dp.[property_program]                                           AS [Program],
    dpp.[property_program_owner_name]                               AS [Program Owner],
    dp.[property_property_manager]                                  AS [Property Manager Name],
    dp.[property_property_manager_email]                            AS [Property Manager Email],
    dp.[property_property_manager_mobile_number]                    AS [Property Manager Mobile],
    dp.[property_property_ownership]                                AS [Ownership Type],
    dp.[property_property_type]                                     AS [Property Type],
    dp.[property_provider_agreement_number]                         AS [Provider Agreement Number],
    dp.[property_reason_for_disposal]                               AS [Reason For Disposal],
    dp.[property_reference_id]                                      AS [Property Ref],
    CAST(dp.[property_relettable_date] AS DATE)                     AS [Relettable Date],
    dp.[property_statecode]                                         AS [State],
    dp.[property_status]                                            AS [Status],
    dp.[property_statuscode]                                        AS [Status Code],
    dp.[property_street_name]                                       AS [Street Name],
    dp.[property_street_number]                                     AS [Street Number],
    dp.[property_sub_program]                                       AS [Sub Program],
    dpp.[property_subprogram_owner_name]                            AS [Sub Program Owner],
    dp.[property_sub_property_type]                                 AS [Property Sub Type],
    dp.[property_suburb]                                            AS [City],
    dp.[property_target_group]                                      AS [Housing Group],
    dp.[property_territory]                                         AS [District Name],
    dp.[property_total_days_vacant]                                 AS [Total Days Vacant],
    dp.[property_total_heat_source_capacity_kw]                     AS [Total Heat Source Capacity (Kw)],
    dp.[property_total_irrs]                                        AS [Total IRRS],
    dp.[property_total_irrs_base]                                   AS [Total IRRS (Base)],
    CAST(dp.[property_total_irrs_date] AS DATE)                     AS [Total IRRS (Last Updated On)],
    dp.[property_total_irrs_state]                                  AS [Total IRRS (State)],
    dp.[property_transitional_housing_market_rent_base]             AS [Transitional Housing Market Rent (Base)],
    dp.[property_unit]                                              AS [Unit],
    dp.[property_year_built]                                        AS [Built Year],
    dp.[property_zav_transitional_housing_market_rent]              AS [Transitional Housing Market Rent],
    dp.[DWHDMLOperation]                                            AS [DWH DML Operation],
    dp.[DWHIsCurrent]                                               AS [DWH Is Current]
FROM [edw].[dim_property] dp
LEFT JOIN [edw].[dim_property_program] dpp
    ON dp.[property_program] = dpp.[property_program_name]
    AND dp.[property_sub_program] = dpp.[property_subprogram_name]
    AND dpp.[DWHIsCurrent] = 1
    AND dpp.[DWHDMLOperation] <> 'D'
WHERE dp.[DWHIsCurrent] = 1
    AND dp.[DWHDMLOperation] <> 'D'
    AND dp.[property_id] IS NOT NULL
    AND dp.[property_id] <> 'DBC86A56-6CE2-4B1F-9C6B-33EA1ADF6598';
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, applies proper case. Capitalises ID, KEY, DWH, IRRS, BOS, HUD, MSD. Replaces `client_` prefix with `Tangata_Whaiora_`.
- **Filters**:
  - `DWHIsCurrent = 1` (current SCD Type 2 record only)
  - `DWHDMLOperation <> 'D'` (exclude deleted records)
  - `property_id IS NOT NULL`
  - Property ID `DBC86A56-6CE2-4B1F-9C6B-33EA1ADF6598` excluded via M query filter
- **Type conversions**: `property_acquired_date`, `property_confirmed_disposal_date`, `property_date_constructed`, `property_disposal_date`, `property_relettable_date`, `property_total_irrs_date` all CAST to DATE
- **JOIN**: LEFT JOIN to `edw.dim_property_program` on program name + sub-program name to bring in Program Owner and Sub Program Owner

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Tenancy | Property ID | Property | Property ID | Many-to-One | Single |
| Healthy Homes | Property ID | Property | Property ID | One-to-One | Both |
| Maintenance Task | Property ID | Property | Property ID | Many-to-One | Single |
| Void Checklist | Property ID | Property | Property ID | Many-to-One | Single |
| Property Timeline | Property ID | Property | Property ID | Many-to-One | Single |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Properties | 01. Property Portfolio | Count of all properties in the portfolio |
| Occupied Properties | 01. Property Portfolio | Count of properties with active tenancies |
| Vacant Properties | 01. Property Portfolio | Count of properties without active tenancies |
| Occupancy Rate % | 01. Property Portfolio | Percentage of occupied properties |
| Properties Under Maintenance | 01. Property Portfolio | Count of properties currently under maintenance |
| Available To Let | 01. Property Portfolio | Count of properties available for letting |
| Total Days Vacant (Measure) | 01. Property Portfolio | Sum of vacancy days across properties |
| Average Days Vacant | 01. Property Portfolio | Average vacancy duration |
