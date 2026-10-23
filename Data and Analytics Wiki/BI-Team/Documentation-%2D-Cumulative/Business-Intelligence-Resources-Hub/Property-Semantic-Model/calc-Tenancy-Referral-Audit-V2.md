# Tenancy Referral Audit V2

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
| **Power BI Table Name** | `Tenancy Referral Audit V2` |
| **Source** | DAX Calculated Table |
| **Query Group** | (root) |
| **Row Description** | One row per tenancy (or tenancy-referral pair for matched/pre-existing), classified by Match Quality |
| **Column Count** | 20 + 1 DAX calculated column |
| **Overall Classification** | :red_circle: Sensitive |

This is the improved audit table that classifies every tenancy into a Match Quality category based on date-overlap matching to referrals. It uses a complex UNION of five distinct record sets:

1. **Verified Match** -- Date overlap match with 3-day tolerance (same logic as bridge table)
2. **Pre-existing Referral** -- Unmatched tenancies where the client has referrals with general date overlap (not strict 3-day)
3. **No Overlapping Referral** -- Client has referrals but none overlap the tenancy period
4. **No Matching Referral** -- Client has no referrals at all
5. **Missing Client ID** -- Tenancies with blank Tangata Whaiora ID

Additionally, for matched and pre-existing records, gap day calculations show the temporal distance between tenancy and referral boundaries.

### Match Quality Classifications

| Match Quality | Description | Action Required |
|---------------|-------------|-----------------|
| Verified Match | Referral dates overlap tenancy within 3-day tolerance | None - data is consistent |
| Pre-existing Referral | Client has overlapping referral but outside 3-day window | Review - may indicate pre-existing arrangement |
| No Overlapping Referral | Client has referrals but none overlap this tenancy | Investigate - possible data gap |
| No Matching Referral | Client ID exists but has zero referrals | Investigate - referral may not have been recorded |
| Missing Client ID | Tenancy record has no Tangata Whaiora ID | Data quality issue - ID linkage missing |

---

## Data Classification

| Level | Badge | Description |
|-------|-------|-------------|
| Public | :green_circle: | Non-sensitive operational data |
| Internal | :yellow_circle: | Internal business data |
| Sensitive | :red_circle: | Personal identifiable information |

---

## Column Reference

| # | Column Name | Data Type | Hidden | Classification | Description |
|---|-------------|-----------|--------|----------------|-------------|
| 1 | Property Tenancy ID | string | Yes | :green_circle: Public | Unique tenancy identifier (GUID) |
| 2 | Tenancy Name | string | No | :red_circle: Sensitive | Name of the tenancy record |
| 3 | Tenancy Tangata Whaiora ID | int64 | No | :red_circle: Sensitive | Client ID extracted from tenancy |
| 4 | Tenancy Start Date | date | No | :green_circle: Public | Date tenancy commenced |
| 5 | Tenancy Vacated Date | date | No | :green_circle: Public | Date tenant vacated (NULL if current) |
| 6 | Tenancy Manager | string | No | :red_circle: Sensitive | Property manager name |
| 7 | Referral Tangata Whaiora ID | int64 | Yes | :red_circle: Sensitive | Client ID from referral record |
| 8 | Referrer Name | string | No | :red_circle: Sensitive | Name of the referring person/organisation |
| 9 | Referral Accepted Date | date | No | :green_circle: Public | Date referral was accepted |
| 10 | Referral Discharge Date | date | No | :green_circle: Public | Date referral was discharged |
| 11 | Referral Status | string | No | :green_circle: Public | Current status of the referral |
| 12 | Referral Accepted Reason | string | No | :green_circle: Public | Reason the referral was accepted |
| 13 | Referral Discharge Reason | string | No | :green_circle: Public | Reason the referral was discharged |
| 14 | Referral Received Date | date | No | :green_circle: Public | Date referral was received |
| 15 | Start Gap Days | int64 | No | :green_circle: Public | Days between Tenancy Start Date and Referral Accepted Date |
| 16 | End Gap Days | int64 | No | :green_circle: Public | Days between Referral Discharge Date and Tenancy Vacated Date |
| 17 | Match Quality | string | No | :green_circle: Public | Classification category (see table above) |
| 18 | City | string | No | :green_circle: Public | Property suburb/city from Property dimension |
| 19 | Program | string | No | :green_circle: Public | Property program from Property dimension |
| 20 | Sub Program | string | No | :green_circle: Public | Property sub-program from Property dimension |
| 21 | Vacated Audit Filter | date | No | :green_circle: Public | **DAX calculated column**: `IF(ISBLANK([Tenancy Vacated Date]), DATE(2999,12,31), [Tenancy Vacated Date])` |

---

## Source SQL

The following SQL is a documentation equivalent of the DAX calculated table logic. In Power BI, this table is computed at refresh time using DAX UNION of multiple CROSSJOIN + FILTER expressions.

```sql
-- Tenancy CTE: core tenancy data with extracted Tangata Whaiora ID
WITH Tenancy AS (
    SELECT
        [property_tenancy_id]                                              AS [Property Tenancy ID],
        [property_id]                                                      AS [Property ID],
        [property_tenancy_tenancy_name]                                    AS [Tenancy Name],
        [property_tenancy_property_manager_name]                           AS [Tenancy Manager],
        TRY_CAST(
            (SELECT STRING_AGG(v.c, '') WITHIN GROUP (ORDER BY v.n)
             FROM (
                 SELECT SUBSTRING(t.[property_tenancy_primary_tenant_recordbaseid], n.n, 1) AS c, n.n
                 FROM (SELECT TOP 100 ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
                       FROM sys.objects) n
                 WHERE n.n <= LEN(t.[property_tenancy_primary_tenant_recordbaseid])
                   AND SUBSTRING(t.[property_tenancy_primary_tenant_recordbaseid], n.n, 1) LIKE '[0-9]'
             ) v)
        AS BIGINT)                                                         AS [Tenancy Tangata Whaiora ID],
        CAST([property_tenancy_tenancy_start_date] AS DATE)                AS [Tenancy Start Date],
        CAST([property_tenancy_vacated_date] AS DATE)                      AS [Tenancy Vacated Date]
    FROM [edw].[dim_property_tenancy] t
    WHERE [DWHIsCurrent] = 1
        AND [DWHDMLOperation] <> 'D'
        AND [property_tenancy_id] IS NOT NULL
        AND [property_tenant_opportunity_status] <> 'Cancelled'
),

-- Referral CTE: Transitional Housing Referrals
Referral AS (
    SELECT DISTINCT
        c.[client_id]                                                      AS [Referral Tangata Whaiora ID],
        cr.[client_referrer_name]                                          AS [Referrer Name],
        cr.[client_referral_status]                                        AS [Referral Status],
        cr.[client_referral_accepted_reason]                               AS [Referral Accepted Reason],
        cr.[client_referral_discharge_reason]                              AS [Referral Discharge Reason],
        CASE
            WHEN fcr.[client_referral_received_date_key] IS NULL
                OR fcr.[client_referral_received_date_key] = 0
            THEN NULL
            ELSE DATEFROMPARTS(
                fcr.[client_referral_received_date_key] / 10000,
                (fcr.[client_referral_received_date_key] / 100) % 100,
                fcr.[client_referral_received_date_key] % 100
            )
        END                                                                AS [Referral Received Date],
        CASE
            WHEN fcr.[client_referral_accepted_date_key] IS NULL
                OR fcr.[client_referral_accepted_date_key] = 0
            THEN NULL
            ELSE DATEFROMPARTS(
                fcr.[client_referral_accepted_date_key] / 10000,
                (fcr.[client_referral_accepted_date_key] / 100) % 100,
                fcr.[client_referral_accepted_date_key] % 100
            )
        END                                                                AS [Referral Accepted Date],
        CASE
            WHEN fcr.[client_referral_discharge_date_key] IS NULL
                OR fcr.[client_referral_discharge_date_key] = 0
            THEN NULL
            ELSE DATEFROMPARTS(
                fcr.[client_referral_discharge_date_key] / 10000,
                (fcr.[client_referral_discharge_date_key] / 100) % 100,
                fcr.[client_referral_discharge_date_key] % 100
            )
        END                                                                AS [Referral Discharge Date]
    FROM [edw].[vw_fact_client_referral] AS fcr
        INNER JOIN [edw].[vw_dim_client_referral] AS cr
            ON fcr.[dim_client_referral_key] = cr.[dim_client_referral_key]
        INNER JOIN [edw].[vw_dim_client] AS c
            ON fcr.[dim_client_key] = c.[dim_client_key]
        INNER JOIN [edw].[vw_dim_client_team] AS ct
            ON fcr.[dim_client_team_key] = ct.[dim_client_team_key]
        INNER JOIN [edw].[vw_dim_service] AS s
            ON ct.[dim_service_key] = s.[dim_service_key]
    WHERE
        fcr.[DWHDMLOperation] <> 'D'
        AND cr.[client_referral_status] <> 'Declined'
        AND cr.[client_referral_status] <> 'Pending'
        AND cr.[client_referral_type] = 'InboundReferral'
        AND s.[service_type_name] = 'Emergency Housing Service'
        AND ct.[client_team_name] NOT LIKE '%f/up%'
),

-- Property lookup for City, Program, Sub Program
Property AS (
    SELECT
        [property_id]                                                      AS [Property ID],
        [property_suburb]                                                   AS [City],
        [property_program]                                                 AS [Program],
        [property_sub_program]                                             AS [Sub Program]
    FROM [edw].[dim_property]
    WHERE [DWHIsCurrent] = 1
        AND [DWHDMLOperation] <> 'D'
        AND [property_id] IS NOT NULL
),

-- 1. MatchedJoin: Date overlap match with 3-day tolerance (Verified Match)
MatchedJoin AS (
    SELECT
        t.[Property Tenancy ID],
        t.[Tenancy Name],
        t.[Tenancy Tangata Whaiora ID],
        t.[Tenancy Start Date],
        t.[Tenancy Vacated Date],
        t.[Tenancy Manager],
        t.[Property ID],
        r.[Referral Tangata Whaiora ID],
        r.[Referrer Name],
        r.[Referral Accepted Date],
        r.[Referral Discharge Date],
        r.[Referral Status],
        r.[Referral Accepted Reason],
        r.[Referral Discharge Reason],
        r.[Referral Received Date],
        'Verified Match' AS [Match Quality]
    FROM Tenancy t
        INNER JOIN Referral r
            ON t.[Tenancy Tangata Whaiora ID] = r.[Referral Tangata Whaiora ID]
    WHERE t.[Tenancy Tangata Whaiora ID] IS NOT NULL
        AND r.[Referral Accepted Date] >= DATEADD(DAY, -3, t.[Tenancy Start Date])
        AND (
            r.[Referral Discharge Date] <= DATEADD(DAY, 3, t.[Tenancy Vacated Date])
            OR t.[Tenancy Vacated Date] IS NULL
        )
),

-- Identify tenancies already matched in MatchedJoin
MatchedTenancies AS (
    SELECT DISTINCT [Property Tenancy ID] FROM MatchedJoin
),

-- 2. PreExistingJoin: Unmatched tenancies with general date overlap (Pre-existing Referral)
PreExistingJoin AS (
    SELECT
        t.[Property Tenancy ID],
        t.[Tenancy Name],
        t.[Tenancy Tangata Whaiora ID],
        t.[Tenancy Start Date],
        t.[Tenancy Vacated Date],
        t.[Tenancy Manager],
        t.[Property ID],
        r.[Referral Tangata Whaiora ID],
        r.[Referrer Name],
        r.[Referral Accepted Date],
        r.[Referral Discharge Date],
        r.[Referral Status],
        r.[Referral Accepted Reason],
        r.[Referral Discharge Reason],
        r.[Referral Received Date],
        'Pre-existing Referral' AS [Match Quality]
    FROM Tenancy t
        INNER JOIN Referral r
            ON t.[Tenancy Tangata Whaiora ID] = r.[Referral Tangata Whaiora ID]
    WHERE t.[Tenancy Tangata Whaiora ID] IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM MatchedTenancies m WHERE m.[Property Tenancy ID] = t.[Property Tenancy ID])
        AND r.[Referral Accepted Date] <= COALESCE(t.[Tenancy Vacated Date], '9999-12-31')
        AND (r.[Referral Discharge Date] >= t.[Tenancy Start Date] OR r.[Referral Discharge Date] IS NULL)
),

-- Identify tenancies matched in PreExisting
PreExistingTenancies AS (
    SELECT DISTINCT [Property Tenancy ID] FROM PreExistingJoin
),

-- 3. NoOverlapTenancies: Client has referrals but none overlap
NoOverlapTenancies AS (
    SELECT
        t.[Property Tenancy ID],
        t.[Tenancy Name],
        t.[Tenancy Tangata Whaiora ID],
        t.[Tenancy Start Date],
        t.[Tenancy Vacated Date],
        t.[Tenancy Manager],
        t.[Property ID],
        CAST(NULL AS BIGINT)       AS [Referral Tangata Whaiora ID],
        CAST(NULL AS NVARCHAR(500)) AS [Referrer Name],
        CAST(NULL AS DATE)         AS [Referral Accepted Date],
        CAST(NULL AS DATE)         AS [Referral Discharge Date],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Status],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Accepted Reason],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Discharge Reason],
        CAST(NULL AS DATE)         AS [Referral Received Date],
        'No Overlapping Referral'  AS [Match Quality]
    FROM Tenancy t
    WHERE t.[Tenancy Tangata Whaiora ID] IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM MatchedTenancies m WHERE m.[Property Tenancy ID] = t.[Property Tenancy ID])
        AND NOT EXISTS (SELECT 1 FROM PreExistingTenancies p WHERE p.[Property Tenancy ID] = t.[Property Tenancy ID])
        AND EXISTS (SELECT 1 FROM Referral r WHERE r.[Referral Tangata Whaiora ID] = t.[Tenancy Tangata Whaiora ID])
),

-- 4. NoReferralTenancies: Client has no referrals at all
NoReferralTenancies AS (
    SELECT
        t.[Property Tenancy ID],
        t.[Tenancy Name],
        t.[Tenancy Tangata Whaiora ID],
        t.[Tenancy Start Date],
        t.[Tenancy Vacated Date],
        t.[Tenancy Manager],
        t.[Property ID],
        CAST(NULL AS BIGINT)       AS [Referral Tangata Whaiora ID],
        CAST(NULL AS NVARCHAR(500)) AS [Referrer Name],
        CAST(NULL AS DATE)         AS [Referral Accepted Date],
        CAST(NULL AS DATE)         AS [Referral Discharge Date],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Status],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Accepted Reason],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Discharge Reason],
        CAST(NULL AS DATE)         AS [Referral Received Date],
        'No Matching Referral'     AS [Match Quality]
    FROM Tenancy t
    WHERE t.[Tenancy Tangata Whaiora ID] IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM MatchedTenancies m WHERE m.[Property Tenancy ID] = t.[Property Tenancy ID])
        AND NOT EXISTS (SELECT 1 FROM PreExistingTenancies p WHERE p.[Property Tenancy ID] = t.[Property Tenancy ID])
        AND NOT EXISTS (SELECT 1 FROM Referral r WHERE r.[Referral Tangata Whaiora ID] = t.[Tenancy Tangata Whaiora ID])
),

-- 5. BlankIDRecords: Tenancies with blank Tangata Whaiora ID
BlankIDRecords AS (
    SELECT
        t.[Property Tenancy ID],
        t.[Tenancy Name],
        t.[Tenancy Tangata Whaiora ID],
        t.[Tenancy Start Date],
        t.[Tenancy Vacated Date],
        t.[Tenancy Manager],
        t.[Property ID],
        CAST(NULL AS BIGINT)       AS [Referral Tangata Whaiora ID],
        CAST(NULL AS NVARCHAR(500)) AS [Referrer Name],
        CAST(NULL AS DATE)         AS [Referral Accepted Date],
        CAST(NULL AS DATE)         AS [Referral Discharge Date],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Status],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Accepted Reason],
        CAST(NULL AS NVARCHAR(500)) AS [Referral Discharge Reason],
        CAST(NULL AS DATE)         AS [Referral Received Date],
        'Missing Client ID'        AS [Match Quality]
    FROM Tenancy t
    WHERE t.[Tenancy Tangata Whaiora ID] IS NULL
),

-- UNION all categories
Combined AS (
    SELECT * FROM MatchedJoin
    UNION ALL
    SELECT * FROM PreExistingJoin
    UNION ALL
    SELECT * FROM NoOverlapTenancies
    UNION ALL
    SELECT * FROM NoReferralTenancies
    UNION ALL
    SELECT * FROM BlankIDRecords
)

SELECT
    c.[Property Tenancy ID],
    c.[Tenancy Name],
    c.[Tenancy Tangata Whaiora ID],
    c.[Tenancy Start Date],
    c.[Tenancy Vacated Date],
    c.[Tenancy Manager],
    c.[Referral Tangata Whaiora ID],
    c.[Referrer Name],
    c.[Referral Accepted Date],
    c.[Referral Discharge Date],
    c.[Referral Status],
    c.[Referral Accepted Reason],
    c.[Referral Discharge Reason],
    c.[Referral Received Date],
    DATEDIFF(DAY, c.[Tenancy Start Date], c.[Referral Accepted Date])      AS [Start Gap Days],
    DATEDIFF(DAY, c.[Referral Discharge Date], c.[Tenancy Vacated Date])   AS [End Gap Days],
    c.[Match Quality],
    p.[City],
    p.[Program],
    p.[Sub Program]
FROM Combined c
    LEFT JOIN Property p
        ON c.[Property ID] = p.[Property ID];

/*
 * DAX Calculated Column:
 *
 * Vacated Audit Filter =
 *     IF(ISBLANK('Tenancy Referral Audit V2'[Tenancy Vacated Date]),
 *        DATE(2999, 12, 31),
 *        'Tenancy Referral Audit V2'[Tenancy Vacated Date])
 *
 * SQL equivalent: COALESCE([Tenancy Vacated Date], '2999-12-31')
 */
```

---

## Transformation Notes

1. **Cascading match logic**: The five UNION branches are evaluated in priority order. Each subsequent branch excludes tenancies already matched in higher-priority branches using NOT EXISTS against the matched sets.

2. **Verified Match vs Pre-existing**: Verified Match uses the strict 3-day tolerance window (same as the bridge table). Pre-existing Referral uses a broader overlap check -- the referral accepted date must be before the tenancy end, and the referral discharge date must be after the tenancy start (or be NULL).

3. **Gap day calculations**: `Start Gap Days` = days from Tenancy Start to Referral Accepted. `End Gap Days` = days from Referral Discharge to Tenancy Vacated. These help analysts assess temporal alignment quality.

4. **Property enrichment**: City, Program, and Sub Program are joined from the Property dimension via Property ID for geographic and programme filtering.

5. **Vacated Audit Filter**: The DAX calculated column replaces NULL vacated dates with 2999-12-31 for slicer/filter purposes, ensuring current tenancies can be included or excluded in date-based filters.

---

## Relationships

This table has **no relationships** to other tables in the model. It is a standalone audit/diagnostic table used for data quality analysis and operational review.

---

## Related Measures

This table is used directly in audit report pages for:

- Reviewing match quality distribution across the tenancy portfolio
- Identifying tenancies with missing client IDs or unlinked referrals
- Analysing gap days to assess data consistency between property and referral systems
- Filtering by City, Program, and Sub Program for targeted investigations
