# Tenancy Referral Audit

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
| **Power BI Table Name** | `Tenancy Referral Audit` |
| **Source** | DAX Calculated Table |
| **Query Group** | (root) |
| **Row Description** | One row per tenancy (or tenancy-referral pair for matched records), classified by Match Quality |
| **Column Count** | 19 + 1 DAX calculated column |
| **Overall Classification** | :red_circle: Sensitive |

This is the original (simpler) audit table that links tenancies to referrals based solely on matching Tangata Whaiora ID -- **without date-overlap filtering**. It uses a CROSSJOIN on client ID only, then classifies each tenancy into three categories:

1. **Matched** -- Client ID matches between tenancy and referral
2. **No Matching Referral** -- Client ID exists but no referral found
3. **Missing Client ID** -- Tenancy has no Tangata Whaiora ID

This table has been superseded by [Tenancy Referral Audit V2](calc-Tenancy-Referral-Audit-V2) which adds date-overlap logic and finer-grained Match Quality categories.

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
| 6 | Referral Tangata Whaiora ID | int64 | Yes | :red_circle: Sensitive | Client ID from referral record |
| 7 | Referrer Name | string | No | :red_circle: Sensitive | Name of the referring person/organisation |
| 8 | Referral Accepted Date | date | No | :green_circle: Public | Date referral was accepted |
| 9 | Referral Discharge Date | date | No | :green_circle: Public | Date referral was discharged |
| 10 | Referral Status | string | No | :green_circle: Public | Current status of the referral |
| 11 | Start Gap Days | int64 | No | :green_circle: Public | Days between Tenancy Start Date and Referral Accepted Date |
| 12 | End Gap Days | int64 | No | :green_circle: Public | Days between Referral Discharge Date and Tenancy Vacated Date |
| 13 | Match Quality | string | No | :green_circle: Public | Classification: Matched, No Matching Referral, or Missing Client ID |
| 14 | Property ID | string | Yes | :green_circle: Public | Property identifier (GUID) |
| 15 | Tenancy Manager | string | No | :red_circle: Sensitive | Property manager name |
| 16 | City | string | No | :green_circle: Public | Property suburb/city from Property dimension |
| 17 | Program | string | No | :green_circle: Public | Property program from Property dimension |
| 18 | Sub Program | string | No | :green_circle: Public | Property sub-program from Property dimension |
| 19 | Vacated Audit Filter | date | No | :green_circle: Public | **DAX calculated column**: `IF(ISBLANK([Tenancy Vacated Date]), DATE(2999,12,31), [Tenancy Vacated Date])` |

---

## Source SQL

The following SQL is a documentation equivalent of the DAX calculated table logic. In Power BI, this table is computed at refresh time using DAX CROSSJOIN + FILTER.

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

-- 1. Matched: Simple client ID join (no date filtering)
Matched AS (
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
        'Matched' AS [Match Quality]
    FROM Tenancy t
        INNER JOIN Referral r
            ON t.[Tenancy Tangata Whaiora ID] = r.[Referral Tangata Whaiora ID]
    WHERE t.[Tenancy Tangata Whaiora ID] IS NOT NULL
),

-- Identify matched tenancies
MatchedTenancies AS (
    SELECT DISTINCT [Property Tenancy ID] FROM Matched
),

-- 2. Unmatched: ID exists but no referral found
Unmatched AS (
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
        'No Matching Referral'     AS [Match Quality]
    FROM Tenancy t
    WHERE t.[Tenancy Tangata Whaiora ID] IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM MatchedTenancies m WHERE m.[Property Tenancy ID] = t.[Property Tenancy ID])
),

-- 3. BlankID: Tenancies with blank Tangata Whaiora ID
BlankID AS (
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
        'Missing Client ID'        AS [Match Quality]
    FROM Tenancy t
    WHERE t.[Tenancy Tangata Whaiora ID] IS NULL
),

-- UNION all categories
Combined AS (
    SELECT * FROM Matched
    UNION ALL
    SELECT * FROM Unmatched
    UNION ALL
    SELECT * FROM BlankID
)

SELECT
    c.[Property Tenancy ID],
    c.[Tenancy Name],
    c.[Tenancy Tangata Whaiora ID],
    c.[Tenancy Start Date],
    c.[Tenancy Vacated Date],
    c.[Referral Tangata Whaiora ID],
    c.[Referrer Name],
    c.[Referral Accepted Date],
    c.[Referral Discharge Date],
    c.[Referral Status],
    DATEDIFF(DAY, c.[Tenancy Start Date], c.[Referral Accepted Date])      AS [Start Gap Days],
    DATEDIFF(DAY, c.[Referral Discharge Date], c.[Tenancy Vacated Date])   AS [End Gap Days],
    c.[Match Quality],
    c.[Property ID],
    c.[Tenancy Manager],
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
 *     IF(ISBLANK('Tenancy Referral Audit'[Tenancy Vacated Date]),
 *        DATE(2999, 12, 31),
 *        'Tenancy Referral Audit'[Tenancy Vacated Date])
 *
 * SQL equivalent: COALESCE([Tenancy Vacated Date], '2999-12-31')
 */
```

---

## Transformation Notes

1. **Simple client ID matching**: Unlike V2, this table joins tenancies to referrals purely on Tangata Whaiora ID without any date-overlap filtering. This can produce many-to-many results when a client has multiple referrals.

2. **Three-category classification**: Match Quality is simpler than V2 -- only Matched, No Matching Referral, and Missing Client ID.

3. **Gap day calculations**: Same as V2. `Start Gap Days` = days from Tenancy Start to Referral Accepted. `End Gap Days` = days from Referral Discharge to Tenancy Vacated.

4. **Property enrichment**: City, Program, and Sub Program joined from the Property dimension via Property ID.

5. **Vacated Audit Filter**: DAX calculated column replacing NULL vacated dates with 2999-12-31 for filtering purposes.

6. **Superseded by V2**: This table is retained for backward compatibility. The V2 table provides more granular match classifications including Pre-existing Referral and No Overlapping Referral categories.

---

## Relationships

This table has **no relationships** to other tables in the model. It is a standalone audit/diagnostic table.

---

## Related Measures

This table is used directly in audit report pages. No dedicated measures reference this table -- it is consumed via visual-level filters and direct column references in report pages.
