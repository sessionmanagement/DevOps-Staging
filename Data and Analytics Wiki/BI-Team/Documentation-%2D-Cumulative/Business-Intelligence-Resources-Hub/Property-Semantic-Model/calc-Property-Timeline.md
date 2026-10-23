# Property Timeline

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
| **Power BI Table Name** | `Property Timeline` |
| **Source** | DAX Calculated Table |
| **Query Group** | (root) |
| **Row Description** | One row per void or tenancy interval for a property, ordered chronologically |
| **Column Count** | 13 (11 base + 2 DAX calculated columns) |
| **Overall Classification** | :green_circle: Public |

This calculated table builds a chronological timeline of void and tenancy intervals for each property. It UNIONs void checklist records with tenancy records and applies property lifecycle clamping using the Acquired Date and Confirmed Disposal Date from the Property dimension.

The timeline enables analysis of property utilisation patterns -- how long properties are void between tenancies, total occupied vs vacant days, and gap identification.

### Construction Logic

1. **Voids**: Sourced from `fact_property_void_checklist`, excluding PROV category and "Void Category Change" status. Interval Start is clamped to Acquired Date. Interval End uses the Property Is Ready date or Confirmed Disposal Date.
2. **VoidsFixed**: For the latest open void per property (no end date), sets Interval End to TODAY().
3. **Tenancies**: Sourced from `dim_property_tenancy`. Interval Start clamped to Acquired Date. Interval End uses Vacated Date, or Confirmed Disposal Date, or TODAY().
4. **UNION** of voids and tenancies with Days Interval calculated as DATEDIFF.

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
| 1 | Record Type | string | No | :green_circle: Public | "Void" or "Tenancy" |
| 2 | Property ID | string | Yes | :green_circle: Public | Property identifier (GUID) |
| 3 | Interval Start Date | date | No | :green_circle: Public | Start of the void or tenancy interval (clamped to Acquired Date) |
| 4 | Interval End Date | date | No | :green_circle: Public | End of the interval (clamped to lifecycle boundaries) |
| 5 | Void Category | string | No | :green_circle: Public | Void category (NULL for tenancy records) |
| 6 | Void Status | string | No | :green_circle: Public | Void status (NULL for tenancy records) |
| 7 | Void Comments | string | No | :green_circle: Public | Void comments (NULL for tenancy records) |
| 8 | Tenancy Name | string | No | :green_circle: Public | Tenancy name (NULL for void records) |
| 9 | Tenancy Status | string | No | :green_circle: Public | Tenancy opportunity status (NULL for void records) |
| 10 | Void Checklist ID | string | Yes | :green_circle: Public | Void checklist identifier (NULL for tenancy records) |
| 11 | Days Interval | int64 | No | :green_circle: Public | DATEDIFF(DAY, Interval Start Date, Interval End Date) |
| 12 | Days Between Intervals | int64 | No | :green_circle: Public | **DAX calculated column**: Gap days to the next interval for the same property |
| 13 | Reverse Row Num | int64 | No | :green_circle: Public | **DAX calculated column**: Reverse chronological row number per property |

---

## Source SQL

The following SQL is a documentation equivalent of the DAX calculated table logic. In Power BI, this table is computed at refresh time using DAX UNION + ADDCOLUMNS.

```sql
-- Property lookup for Acquired Date and Confirmed Disposal Date
WITH Property AS (
    SELECT
        [property_id]                                                      AS [Property ID],
        CAST([property_acquired_date] AS DATE)                             AS [Acquired Date],
        CAST([property_confirmed_disposal_date] AS DATE)                   AS [Confirmed Disposal Date]
    FROM [edw].[dim_property]
    WHERE [DWHIsCurrent] = 1
        AND [DWHDMLOperation] <> 'D'
        AND [property_id] IS NOT NULL
),

-- _Voids: Void checklist records excluding PROV category and "Void Category Change" status
-- Interval Start = COALESCE(Date Tenancy Terminated, Created On) clamped to Acquired Date
-- Interval End = COALESCE(Property Is Ready date, Confirmed Disposal Date)
Voids AS (
    SELECT
        'Void'                                                             AS [Record Type],
        vc.[property_id]                                                   AS [Property ID],
        CASE
            WHEN COALESCE(CAST(vc.[date_tenancy_terminated] AS DATE),
                          CAST(vc.[created_on] AS DATE))
                 < p.[Acquired Date]
            THEN p.[Acquired Date]
            ELSE COALESCE(CAST(vc.[date_tenancy_terminated] AS DATE),
                          CAST(vc.[created_on] AS DATE))
        END                                                                AS [Interval Start Date],
        COALESCE(CAST(vc.[property_is_ready_date] AS DATE),
                 p.[Confirmed Disposal Date])                              AS [Interval End Date],
        vc.[void_category]                                                 AS [Void Category],
        vc.[void_status]                                                   AS [Void Status],
        vc.[void_comments]                                                 AS [Void Comments],
        CAST(NULL AS NVARCHAR(500))                                        AS [Tenancy Name],
        CAST(NULL AS NVARCHAR(500))                                        AS [Tenancy Status],
        vc.[void_checklist_id]                                             AS [Void Checklist ID]
    FROM [edw].[fact_property_void_checklist] vc
        INNER JOIN Property p
            ON vc.[property_id] = p.[Property ID]
    WHERE vc.[DWHIsCurrent] = 1
        AND vc.[DWHDMLOperation] <> 'D'
        AND vc.[void_category] <> 'PROV'
        AND vc.[void_status] <> 'Void Category Change'
),

-- _VoidsFixed: For the latest open void per property (no end date, no later voids),
-- set Interval End = TODAY()
VoidsFixed AS (
    SELECT
        v.[Record Type],
        v.[Property ID],
        v.[Interval Start Date],
        CASE
            WHEN v.[Interval End Date] IS NULL
                AND v.[Interval Start Date] = (
                    SELECT MAX(v2.[Interval Start Date])
                    FROM Voids v2
                    WHERE v2.[Property ID] = v.[Property ID]
                      AND v2.[Interval End Date] IS NULL
                )
            THEN CAST(GETDATE() AS DATE)
            ELSE v.[Interval End Date]
        END                                                                AS [Interval End Date],
        v.[Void Category],
        v.[Void Status],
        v.[Void Comments],
        v.[Tenancy Name],
        v.[Tenancy Status],
        v.[Void Checklist ID]
    FROM Voids v
),

-- _Tenancies: Tenancy records with lifecycle clamping
-- Interval Start = MAX(Tenancy Start Date, Acquired Date)
-- Interval End = COALESCE(Vacated Date, Confirmed Disposal Date, TODAY())
Tenancies AS (
    SELECT
        'Tenancy'                                                          AS [Record Type],
        t.[property_id]                                                    AS [Property ID],
        CASE
            WHEN CAST(t.[property_tenancy_tenancy_start_date] AS DATE) < p.[Acquired Date]
            THEN p.[Acquired Date]
            ELSE CAST(t.[property_tenancy_tenancy_start_date] AS DATE)
        END                                                                AS [Interval Start Date],
        COALESCE(CAST(t.[property_tenancy_vacated_date] AS DATE),
                 p.[Confirmed Disposal Date],
                 CAST(GETDATE() AS DATE))                                  AS [Interval End Date],
        CAST(NULL AS NVARCHAR(500))                                        AS [Void Category],
        CAST(NULL AS NVARCHAR(500))                                        AS [Void Status],
        CAST(NULL AS NVARCHAR(500))                                        AS [Void Comments],
        t.[property_tenancy_tenancy_name]                                  AS [Tenancy Name],
        t.[property_tenant_opportunity_status]                             AS [Tenancy Status],
        CAST(NULL AS NVARCHAR(500))                                        AS [Void Checklist ID]
    FROM [edw].[dim_property_tenancy] t
        INNER JOIN Property p
            ON t.[property_id] = p.[Property ID]
    WHERE t.[DWHIsCurrent] = 1
        AND t.[DWHDMLOperation] <> 'D'
        AND t.[property_tenancy_id] IS NOT NULL
        AND t.[property_tenant_opportunity_status] <> 'Cancelled'
),

-- UNION voids and tenancies
Combined AS (
    SELECT * FROM VoidsFixed
    UNION ALL
    SELECT * FROM Tenancies
)

SELECT
    c.[Record Type],
    c.[Property ID],
    c.[Interval Start Date],
    c.[Interval End Date],
    c.[Void Category],
    c.[Void Status],
    c.[Void Comments],
    c.[Tenancy Name],
    c.[Tenancy Status],
    c.[Void Checklist ID],
    DATEDIFF(DAY, c.[Interval Start Date], c.[Interval End Date])          AS [Days Interval]
FROM Combined c;

/*
 * DAX Calculated Columns (computed at model level, not in SQL):
 *
 * Days Between Intervals =
 *     VAR CurrentProperty = 'Property Timeline'[Property ID]
 *     VAR CurrentEndDate = 'Property Timeline'[Interval End Date]
 *     VAR NextStartDate =
 *         CALCULATE(
 *             MIN('Property Timeline'[Interval Start Date]),
 *             FILTER(ALL('Property Timeline'),
 *                 'Property Timeline'[Property ID] = CurrentProperty
 *                 && 'Property Timeline'[Interval Start Date] > CurrentEndDate))
 *     RETURN DATEDIFF(CurrentEndDate, NextStartDate, DAY)
 *
 * SQL equivalent (approximate):
 *     DATEDIFF(DAY, [Interval End Date],
 *         LEAD([Interval Start Date]) OVER (
 *             PARTITION BY [Property ID]
 *             ORDER BY [Interval Start Date]))
 *
 * Reverse Row Num =
 *     VAR CurrentProperty = 'Property Timeline'[Property ID]
 *     VAR TotalRows =
 *         CALCULATE(COUNTROWS('Property Timeline'),
 *             FILTER(ALL('Property Timeline'),
 *                 'Property Timeline'[Property ID] = CurrentProperty))
 *     VAR CurrentRank =
 *         RANKX(FILTER(ALL('Property Timeline'),
 *             'Property Timeline'[Property ID] = CurrentProperty),
 *             'Property Timeline'[Interval Start Date], , ASC, DENSE)
 *     RETURN TotalRows - CurrentRank + 1
 *
 * SQL equivalent (approximate):
 *     ROW_NUMBER() OVER (
 *         PARTITION BY [Property ID]
 *         ORDER BY [Interval Start Date] DESC)
 */
```

---

## Transformation Notes

1. **Lifecycle clamping**: All interval start dates are clamped to the property Acquired Date. This prevents timeline records from appearing before the property entered the portfolio.

2. **Open void handling**: The VoidsFixed CTE identifies the latest open void per property (no Interval End Date and no later voids) and sets its end to TODAY(). Other open voids remain with NULL end dates.

3. **Tenancy end date fallback**: Tenancies without a Vacated Date use the Confirmed Disposal Date, then TODAY() as fallback. This ensures current tenancies have a defined interval for duration calculations.

4. **Exclusions**: PROV (provisional) void category and "Void Category Change" status records are excluded as they represent administrative transitions, not actual void periods.

5. **Days Between Intervals**: DAX calculated column that finds the gap between the current interval's end and the next interval's start for the same property. Useful for identifying untracked gaps in the timeline.

6. **Reverse Row Num**: DAX calculated column providing a reverse chronological rank per property. Row 1 = most recent interval, enabling "latest N intervals" filtering.

---

## Relationships

| Direction | Related Table | Key Column | Cardinality | Active |
|-----------|--------------|------------|-------------|--------|
| From (Many) | Property | Property ID | Many-to-One | Yes |

The Property Timeline table has a many-to-one relationship to the Property dimension via Property ID, enabling property-level attributes (city, program, sub-program) to flow into timeline analysis.

---

## Related Measures

Key measures in the **01. Property Portfolio\Timeline** display folder:

| Measure | Description |
|---------|-------------|
| Timeline Total Void Days | Sum of Days Interval where Record Type = "Void" |
| Timeline Total Tenancy Days | Sum of Days Interval where Record Type = "Tenancy" |
| Timeline Avg Void Days | Average of Days Interval where Record Type = "Void" |
| Timeline Avg Gap Days | Average of Days Between Intervals |
| Timeline Void Days (Period) | Void days within the selected date period |
| Timeline Tenancy Days (Period) | Tenancy days within the selected date period |
