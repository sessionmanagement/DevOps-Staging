# Tenancy

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
| **Power BI Table Name** | Tenancy |
| **Source** | `edw.dim_property_tenancy` |
| **Query Group** | Dim Tables |
| **Row Description** | Each row represents a tenancy agreement (lease) linking a property to a tenant |
| **Column Count** | 69 (64 SQL columns + 5 DAX calculated columns) |
| **Overall Classification** | Sensitive |

The Tenancy table contains tenancy agreements linking properties to tenants. It uses a 4-step CTE chain with LAG window functions to calculate tenancy chain logic -- determining whether consecutive tenancies for the same tenant are continuations (gap of 3 days or fewer) or new chains. Five DAX calculated columns enrich the table with referral bridge data at the model level.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive business data freely shared within the organisation | Tenancy dates, Status, Tenancy Type, chain fields |
| :yellow_circle: **In-Confidence** | Business-sensitive data requiring controlled access | Rent, Bond, Rent Payable Weekly, financial fields |
| :red_circle: **Sensitive** | Personally identifiable information requiring strict controls | Tenant Name, Household Name, Tangata Whaiora ID |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Dim Property Tenancy KEY | int64 | Hidden | :green_circle: Public | Surrogate key |
| 2 | Dim Property KEY | int64 | Hidden | :green_circle: Public | FK surrogate to Property |
| 3 | Property Tenancy ID | string | Hidden | :green_circle: Public | Business key (GUID) |
| 4 | Property ID | string | Hidden | :green_circle: Public | FK to Property |
| 5 | Tenancy Manager | string | Visible | :green_circle: Public | Assigned tenancy manager |
| 6 | Tenancy Manager Email | string | Visible | :green_circle: Public | Manager email address |
| 7 | Tenancy Type | string | Visible | :green_circle: Public | Type of tenancy agreement |
| 8 | Owning Business Unit | string | Visible | :green_circle: Public | Business unit owning the tenancy |
| 9 | BOS/HUD Ref. | string | Visible | :green_circle: Public | Government reference (renamed from Tenancy Reference) |
| 10 | Tenancy ID | string | Visible | :green_circle: Public | Tenancy identifier (renamed from Tenancy Identifier) |
| 11 | Tenancy Name | string | Visible | :red_circle: Sensitive | Tenancy name (contains tenant PII) |
| 12 | Household Name | string | Visible | :red_circle: Sensitive | Household name (contains PII) |
| 13 | Tenant Name | string | Visible | :red_circle: Sensitive | Primary tenant name |
| 14 | Lease Agreement Date | date | Visible | :green_circle: Public | Date lease was agreed |
| 15 | Tenancy Start Date | date | Visible | :green_circle: Public | Official tenancy start |
| 16 | Activate Tenancy Date | date | Visible | :green_circle: Public | Date tenancy was activated |
| 17 | Actual Start Date | date | Hidden | :green_circle: Public | Actual start date |
| 18 | Fixed Term Tenancy End Date | date | Visible | :green_circle: Public | Fixed term end date |
| 19 | Short Term Tenancy End Date | date | Visible | :green_circle: Public | Short term end date |
| 20 | Expected Vacated Date | date | Visible | :green_circle: Public | Expected vacate date |
| 21 | Signed MSD Responsibilities Conditions Date | date | Visible | :green_circle: Public | Date MSD conditions signed |
| 22 | Signed SNG Forms Date | date | Visible | :green_circle: Public | Date SNG forms signed |
| 23 | Actual Close Date | date | Hidden | :green_circle: Public | Actual tenancy close date |
| 24 | Bond Lodged Date | date | Visible | :green_circle: Public | Date bond was lodged |
| 25 | Bond Refund Lodged Date | date | Visible | :green_circle: Public | Date bond refund was lodged |
| 26 | Check Body Corp Or Residents Date | date | Visible | :green_circle: Public | Body corp check date |
| 27 | Notice To Vacate Date | date | Visible | :green_circle: Public | Date notice to vacate was given |
| 28 | Health Disability Information Date | date | Hidden | :green_circle: Public | Health/disability info date |
| 29 | Tenancy Pack Date | date | Visible | :green_circle: Public | Tenancy pack issued date |
| 30 | Refund Lodged Date | date | Visible | :green_circle: Public | Refund lodged date |
| 31 | Pay Tenancy Services By Date | date | Visible | :green_circle: Public | Payment due date |
| 32 | Short Term (In Days) | int64 | Visible | :green_circle: Public | Short term duration in days |
| 33 | Bond Reference | string | Visible | :yellow_circle: In-Confidence | Bond reference number |
| 34 | Tenancy Service Bond Number | string | Visible | :yellow_circle: In-Confidence | Tenancy services bond number |
| 35 | Tenancy Services Property Identifier | string | Hidden | :green_circle: Public | Tenancy services property ID |
| 36 | Arrears Arrangement Activated | string | Visible | :yellow_circle: In-Confidence | Arrears arrangement status |
| 37 | Arrears Arrangement Signed | string | Visible | :yellow_circle: In-Confidence | Arrears arrangement signed status |
| 38 | Bond Refund SNG Claim Completed | string | Visible | :green_circle: Public | SNG claim completion status |
| 39 | Bond Refund SNG Claim Lodged | string | Visible | :green_circle: Public | SNG claim lodged status |
| 40 | Exit Point | string | Visible | :green_circle: Public | Tenant exit destination |
| 41 | Expected Payment Day | string | Visible | :green_circle: Public | Expected day of payment |
| 42 | Expected Payment Frequency | string | Visible | :green_circle: Public | Payment frequency |
| 43 | Leaving Reason | string | Visible | :green_circle: Public | Reason for leaving tenancy |
| 44 | Rent Charged Day | string | Visible | :green_circle: Public | Day rent is charged |
| 45 | Rent Paid In Advance | string | Visible | :yellow_circle: In-Confidence | Whether rent is paid in advance |
| 46 | Inspection Frequency | string | Visible | :green_circle: Public | Frequency of inspections |
| 47 | Weeks Bond Requested | string | Visible | :yellow_circle: In-Confidence | Number of weeks bond requested |
| 48 | Rent Payable Weekly | double | Visible | :yellow_circle: In-Confidence | Weekly rent payable amount |
| 49 | Rent | double | Visible | :yellow_circle: In-Confidence | Rent amount |
| 50 | Rent (Base) | double | Hidden | :yellow_circle: In-Confidence | Rent in base currency |
| 51 | Primary Tenant Record Base ID | string | Visible | :green_circle: Public | Source record ID for tenant extraction |
| 52 | Number Of Tenancy Signatories | int64 | Visible | :green_circle: Public | Count of signatories |
| 53 | Tenant 2 | string | Visible | :red_circle: Sensitive | Second tenant name |
| 54 | Rent Amount Start Date | date | Visible | :green_circle: Public | Start date of current rent amount |
| 55 | Vacated Date | date | Visible | :green_circle: Public | Date tenancy was vacated |
| 56 | Tenancy Status | string | Visible | :green_circle: Public | Current tenancy status |
| 57 | DWH DML Operation | string | Hidden | :green_circle: Public | SCD2 DML operation flag |
| 58 | DWH Is Current | boolean | Hidden | :green_circle: Public | SCD2 current record flag |
| 59 | Prev Vacate Date | date | Hidden | :green_circle: Public | Previous tenancy vacate date (LAG) |
| 60 | Gap Days | int64 | Hidden | :green_circle: Public | Days between prev vacate and current start |
| 61 | Is New Chain | int64 | Hidden | :green_circle: Public | 1 if new chain, 0 if continuation |
| 62 | Chain ID | int64 | Hidden | :green_circle: Public | Running chain identifier per tenant |
| 63 | Chain Start Date | date | Visible | :green_circle: Public | Start date of the tenancy chain |
| 64 | Tangata Whaiora ID | int64 | Hidden | :red_circle: Sensitive | Client ID extracted from Primary Tenant Record Base ID |
| 65 | Referral Count | int64 | Visible | :green_circle: Public | DAX: count of matching referrals from bridge |
| 66 | First Referral Accepted Date | date | Visible | :green_circle: Public | DAX: earliest referral accepted date |
| 67 | Last Referral Discharge Date | date | Visible | :green_circle: Public | DAX: latest referral discharge date |
| 68 | Has Matching Referrals | boolean | Visible | :green_circle: Public | DAX: true if Referral Count > 0 |
| 69 | Most Recent Referrer | string | Visible | :green_circle: Public | DAX: name of most recent referrer |

---

## Source SQL

```sql
WITH TenancyBase AS (
    SELECT
        [dim_property_tenancy_key]                                                      AS [Dim Property Tenancy KEY],
        [dim_property_key]                                                              AS [Dim Property KEY],
        [property_tenancy_id]                                                           AS [Property Tenancy ID],
        [property_id]                                                                   AS [Property ID],
        [property_tenancy_manager_name]                                                 AS [Tenancy Manager],
        [property_tenancy_manager_email]                                                AS [Tenancy Manager Email],
        [property_tenancy_tenancy_type]                                                 AS [Tenancy Type],
        [property_tenancy_owning_business_unit_name]                                    AS [Owning Business Unit],
        [property_tenancy_tenancy_reference]                                            AS [BOS/HUD Ref.],
        [property_tenancy_tenancy_identifier]                                           AS [Tenancy ID],
        [property_tenancy_tenancy_name]                                                 AS [Tenancy Name],
        [property_tenancy_household_name]                                               AS [Household Name],
        [property_tenancy_customer_name]                                                AS [Tenant Name],
        CAST([property_tenancy_lease_agreement_datetime] AS DATE)                       AS [Lease Agreement Date],
        CAST([property_tenancy_tenancy_start_date] AS DATE)                             AS [Tenancy Start Date],
        CAST([property_tenancy_activate_tenancy_datetime] AS DATE)                      AS [Activate Tenancy Date],
        CAST([property_tenancy_actual_start_date] AS DATE)                              AS [Actual Start Date],
        CAST([property_tenancy_fixed_term_tenancy_end_date] AS DATE)                    AS [Fixed Term Tenancy End Date],
        CAST([property_tenancy_short_term_tenancy_end_date] AS DATE)                    AS [Short Term Tenancy End Date],
        CAST([property_tenancy_expected_vacated_date] AS DATE)                          AS [Expected Vacated Date],
        CAST([property_tenancy_signed_msd_responsibilities_conditions_datetime] AS DATE) AS [Signed MSD Responsibilities Conditions Date],
        CAST([property_tenancy_signed_sng_forms_datetime] AS DATE)                      AS [Signed SNG Forms Date],
        CAST([property_tenancy_actual_close_date] AS DATE)                              AS [Actual Close Date],
        CAST([property_tenancy_bond_lodged_date] AS DATE)                               AS [Bond Lodged Date],
        CAST([property_tenancy_bond_refund_lodged_date] AS DATE)                        AS [Bond Refund Lodged Date],
        CAST([property_tenancy_check_bodycorp_or_residents_datetime] AS DATE)           AS [Check Body Corp Or Residents Date],
        CAST([property_tenancy_notice_to_vacate_date] AS DATE)                          AS [Notice To Vacate Date],
        CAST([property_tenancy_health_disability_information_datetime] AS DATE)          AS [Health Disability Information Date],
        CAST([property_tenancy_tenancy_pack_datetime] AS DATE)                          AS [Tenancy Pack Date],
        CAST([property_tenancy_refund_lodged_date] AS DATE)                             AS [Refund Lodged Date],
        CAST([property_tenancy_pay_tenancy_services_by_date] AS DATE)                   AS [Pay Tenancy Services By Date],
        [property_tenancy_short_term_in_days]                                           AS [Short Term (In Days)],
        [property_tenancy_bond_reference]                                               AS [Bond Reference],
        [property_tenancy_tenancy_service_bond_number]                                  AS [Tenancy Service Bond Number],
        [property_tenancy_tenancy_services_property_identifier]                         AS [Tenancy Services Property Identifier],
        [property_tenancy_arrears_arrangement_activated]                                AS [Arrears Arrangement Activated],
        [property_tenancy_arrears_arrangement_signed]                                   AS [Arrears Arrangement Signed],
        [property_tenancy_bond_refund_sng_claim_completed]                              AS [Bond Refund SNG Claim Completed],
        [property_tenancy_bond_refund_sng_claim_lodged]                                 AS [Bond Refund SNG Claim Lodged],
        [property_tenancy_exit_point]                                                   AS [Exit Point],
        [property_tenancy_expected_payment_day]                                         AS [Expected Payment Day],
        [property_tenancy_expected_payment_frequency]                                   AS [Expected Payment Frequency],
        [property_tenancy_leaving_reason]                                               AS [Leaving Reason],
        [property_tenancy_rent_charged_day]                                             AS [Rent Charged Day],
        [property_tenancy_rent_paid_in_advance]                                         AS [Rent Paid In Advance],
        [property_tenancy_inspection_frequency]                                         AS [Inspection Frequency],
        [property_tenancy_weeks_bond_requested]                                         AS [Weeks Bond Requested],
        [property_tenancy_weekly_rent_payable]                                          AS [Rent Payable Weekly],
        [property_tenancy_rent]                                                         AS [Rent],
        [property_tenancy_rent_base]                                                    AS [Rent (Base)],
        [property_tenancy_primary_tenant_recordbaseid]                                  AS [Primary Tenant Record Base ID],
        [property_tenancy_number_signatories]                                           AS [Number Of Tenancy Signatories],
        [property_tenancy_second_client_name]                                           AS [Tenant 2],
        CAST([property_tenancy_rent_amount_start_date] AS DATE)                         AS [Rent Amount Start Date],
        CAST([property_tenancy_vacated_date] AS DATE)                                   AS [Vacated Date],
        [property_tenant_opportunity_status]                                             AS [Tenancy Status],
        [DWHDMLOperation]                                                               AS [DWH DML Operation],
        [DWHIsCurrent]                                                                  AS [DWH Is Current]
    FROM [edw].[dim_property_tenancy]
    WHERE [DWHIsCurrent] = 1
        AND [DWHDMLOperation] <> 'D'
        AND [property_tenancy_id] IS NOT NULL
),

-- Step 1: Calculate Previous Vacate Date using LAG window function
TenancyWithPrev AS (
    SELECT *,
        LAG(CAST([Vacated Date] AS DATE)) OVER (
            PARTITION BY [Tenant Name]
            ORDER BY [Tenancy Start Date]
        ) AS [Prev Vacate Date]
    FROM TenancyBase
),

-- Step 2: Calculate Gap Days and determine if this starts a new chain
TenancyWithGap AS (
    SELECT *,
        DATEDIFF(DAY, [Prev Vacate Date], [Tenancy Start Date]) AS [Gap Days],
        CASE
            WHEN [Prev Vacate Date] IS NULL
                OR DATEDIFF(DAY, [Prev Vacate Date], [Tenancy Start Date]) > 3
            THEN 1
            ELSE 0
        END AS [Is New Chain]
    FROM TenancyWithPrev
),

-- Step 3: Calculate Chain ID as running sum of Is New Chain
TenancyWithChainID AS (
    SELECT *,
        SUM([Is New Chain]) OVER (
            PARTITION BY [Tenant Name]
            ORDER BY [Tenancy Start Date]
            ROWS UNBOUNDED PRECEDING
        ) AS [Chain ID]
    FROM TenancyWithGap
),

-- Step 4: Calculate Chain Start Date as MIN start date within each chain
TenancyFinal AS (
    SELECT *,
        MIN([Tenancy Start Date]) OVER (
            PARTITION BY [Tenant Name], [Chain ID]
        ) AS [Chain Start Date]
    FROM TenancyWithChainID
)

SELECT
    tf.*,
    TRY_CAST(
        (SELECT STRING_AGG(v.c, '') WITHIN GROUP (ORDER BY v.n)
         FROM (
             SELECT SUBSTRING(tf.[Primary Tenant Record Base ID], n.n, 1) AS c, n.n
             FROM (SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                   FROM sys.objects) n
             WHERE n.n <= LEN(tf.[Primary Tenant Record Base ID])
               AND SUBSTRING(tf.[Primary Tenant Record Base ID], n.n, 1) LIKE '[0-9]'
         ) v)
    AS BIGINT) AS [Tangata Whaiora ID]
FROM TenancyFinal tf
WHERE tf.[Tenancy Status] <> 'Cancelled';
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, applies proper case. Capitalises ID, KEY, DWH, IRRS, BOS, HUD, MSD.
- **Column renames in M**:
  - "Tenancy Reference" renamed to "BOS/HUD Ref."
  - "Tenancy Identifier" renamed to "Tenancy ID"
- **Tangata Whaiora ID extraction**: In Power Query, numeric characters are extracted from Primary Tenant Record Base ID using `Text.Select(sourceValue, {"0".."9"})` then cast to `Int64.From`. The SQL equivalent uses STRING_AGG with a character filter.
- **Cancelled tenancies filtered out**: `Tenancy Status <> 'Cancelled'` applied as M filter step.
- **Filters**:
  - `DWHIsCurrent = 1`
  - `DWHDMLOperation <> 'D'`
  - `property_tenancy_id IS NOT NULL`
  - `Tenancy Status <> 'Cancelled'` (M filter)
- **Type conversions**: All datetime columns CAST to DATE (18 date columns total)
- **Chain logic (4-step CTE)**:
  1. LAG to get previous vacate date per Tenant Name, ordered by Tenancy Start Date
  2. Gap Days = DATEDIFF between previous vacate and current start; Is New Chain = 1 if gap > 3 days or first tenancy
  3. Chain ID = running SUM of Is New Chain per Tenant Name
  4. Chain Start Date = MIN(Tenancy Start Date) within each chain
- **DAX calculated columns** (5 columns computed at model level):
  - **Referral Count**: CALCULATE(COUNTROWS('Tenancy Referral Bridge'), TREATAS(...))
  - **First Referral Accepted Date**: CALCULATE(MIN('Tenancy Referral Bridge'[Referral Accepted Date]), TREATAS(...))
  - **Last Referral Discharge Date**: CALCULATE(MAX('Tenancy Referral Bridge'[Referral Discharge Date]), TREATAS(...))
  - **Has Matching Referrals**: [Referral Count] > 0
  - **Most Recent Referrer**: VAR-based lookup to Tenancy Referral Bridge for most recent referrer name

---

## Relationships

| From Table | From Column | To Table | To Column | Cardinality | Cross Filter |
|-----------|-------------|----------|-----------|-------------|-------------|
| Tenant | Property Tenancy ID | Tenancy | Property Tenancy ID | Many-to-One | Both |
| Tenancy Transaction | Property Tenancy ID | Tenancy | Property Tenancy ID | Many-to-One | Single |
| Property Inspection | Property Tenancy ID | Tenancy | Property Tenancy ID | Many-to-One | Single |
| Tenancy Referral Bridge | Property Tenancy ID | Tenancy | Property Tenancy ID | Many-to-One | Single |
| Tenancy | Property ID | Property | Property ID | Many-to-One | Single |
| Tenancy | Tangata Whaiora ID | Client | Tangata Whaiora ID | Many-to-One | Single |

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Total Tenancies | 02. Tenancy | Count of all tenancy records |
| Active Tenancies | 02. Tenancy | Count of tenancies with active status |
| Closed Tenancies | 02. Tenancy | Count of closed/vacated tenancies |
| Average Tenancy Duration | 02. Tenancy | Average days between start and vacate |
| New Tenancies (Period) | 02. Tenancy | Count of tenancies started in selected period |
| Vacated Tenancies (Period) | 02. Tenancy | Count of tenancies vacated in selected period |
| Turnover Rate % | 09. THVM Dashboard | Tenancy turnover as percentage |
| Average Time To Fill | 09. THVM Dashboard | Average days between vacancy and new tenancy |
| Chain Count | 02. Tenancy | Count of distinct tenancy chains |
