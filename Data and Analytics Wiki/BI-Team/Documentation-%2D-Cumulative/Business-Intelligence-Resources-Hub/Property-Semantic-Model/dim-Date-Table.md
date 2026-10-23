# Date Table

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
| **Power BI Table Name** | Date Table |
| **Source** | `edw.vw_dim_date` |
| **Query Group** | Dim Date |
| **Row Description** | Each row represents a single calendar date |
| **Column Count** | 10 |
| **Overall Classification** | Public |

The Date Table is a shared calendar dimension providing date attributes for all date-based filtering and analysis in the model. It is filtered to dates from 1 January 2000 onwards and trimmed to 10 essential columns for performance. Unlike other dimensions, it does not have explicit model relationships; instead, it is used via Date Table slicers referenced in many DAX measures across the model.

---

## Data Classification

Per the **Emerge Aotearoa Data Classification & Handling Policy**, columns are classified:

| Level | Description | Examples in this table |
|-------|-------------|----------------------|
| :green_circle: **Public** | Non-sensitive reference data | All columns -- Calendar Date, Year, Month, Quarter, day names, flags |
| :yellow_circle: **In-Confidence** | N/A | N/A |
| :red_circle: **Sensitive** | N/A | N/A |

---

## Column Reference

| # | Column Name | Data Type | Visibility | Classification | Description |
|---|------------|-----------|------------|----------------|-------------|
| 1 | Dim Date KEY | int64 | Visible | :green_circle: Public | Surrogate key (YYYYMMDD format) |
| 2 | Calendar Date | date | Visible | :green_circle: Public | The calendar date (isKey, format d/mm/yyyy) |
| 3 | Calendar Day Name Short | string | Visible | :green_circle: Public | Abbreviated day name (Mon, Tue, etc.) |
| 4 | Calendar Month Num | int64 | Visible | :green_circle: Public | Month number (1-12) |
| 5 | Calendar Month Name Short | string | Visible | :green_circle: Public | Abbreviated month name (Jan, Feb, etc.) |
| 6 | Calendar Year Month | string | Visible | :green_circle: Public | Year-month string (e.g. 2025-01) |
| 7 | Calendar Quarter Num | string | Visible | :green_circle: Public | Quarter number (1-4) |
| 8 | Calendar Year | int64 | Visible | :green_circle: Public | Four-digit calendar year |
| 9 | Weekend Flag | int64 | Visible | :green_circle: Public | 1 = weekend day, 0 = weekday |
| 10 | Weekday Flag | int64 | Visible | :green_circle: Public | 1 = weekday, 0 = weekend |

---

## Source SQL

```sql
SELECT
    [dim_date_key]                AS [Dim Date KEY],
    [calendar_date]               AS [Calendar Date],
    [calendar_day_name_short]     AS [Calendar Day Name Short],
    [calendar_month_num]          AS [Calendar Month Num],
    [calendar_month_name_short]   AS [Calendar Month Name Short],
    [calendar_year_month]         AS [Calendar Year Month],
    [calendar_quarter_num]        AS [Calendar Quarter Num],
    [calendar_year]               AS [Calendar Year],
    [weekend_flag]                AS [Weekend Flag],
    [weekday_flag]                AS [Weekday Flag]
FROM [edw].[vw_dim_date]
WHERE [calendar_date] >= '2000-01-01';
```

---

## Transformation Notes

- **fnApplyNamingConventions**: Replaces underscores with spaces, applies proper case. Capitalises ID, KEY, DWH.
- **Filters**:
  - `calendar_date >= '2000-01-01'` (excludes dates before year 2000)
- **DWH columns removed**: All DWH audit columns stripped in M query
- **Column selection**: Only 10 essential columns selected from the full date dimension view for performance

---

## Relationships

The Date Table does not have explicit relationships defined in the model. It is used as a disconnected slicer table, with measures referencing it via DAX patterns such as:

```dax
VAR SelectedDate = SELECTEDVALUE('Date Table'[Calendar Date])
...
```

This pattern allows the Date Table to drive filtering across multiple fact tables without requiring direct relationships to each one.

---

## Related Measures

| Measure | Folder | Description |
|---------|--------|-------------|
| Selected Date | (various) | Returns the currently selected Calendar Date from slicer |
| Selected Month | (various) | Returns the Calendar Month Name Short for the selected date |
| Selected Year | (various) | Returns the Calendar Year for the selected date |
| Is Weekday Filter | (various) | Used in measures to filter to weekdays only |
