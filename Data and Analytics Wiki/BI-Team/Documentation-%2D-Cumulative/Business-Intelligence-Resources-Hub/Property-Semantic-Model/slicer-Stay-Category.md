# Stay Category

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
| **Power BI Table Name** | `Stay Category` |
| **Source** | DAX DATATABLE (hardcoded values) |
| **Query Group** | (root) |
| **Row Description** | One row per length-of-stay category band |
| **Column Count** | 4 |
| **Overall Classification** | :green_circle: Public |

This is a disconnected slicer table containing four hardcoded rows that define length-of-stay bands measured in weeks. It is used as a report slicer to filter tenure duration analysis without having a direct relationship to any other table.

| Category | Weeks Range |
|----------|-------------|
| Short | 0 - 12 weeks |
| Medium | 13 - 52 weeks |
| Long | 53 - 104 weeks |
| Ultra-Long | 105 - 999 weeks |

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
| 1 | Category | string | No | :green_circle: Public | Display label for the stay band (Short, Medium, Long, Ultra-Long) |
| 2 | Sort Order | int64 | No | :green_circle: Public | Numeric sort order (1-4) |
| 3 | Min Weeks | int64 | No | :green_circle: Public | Lower bound of the week range (inclusive) |
| 4 | Max Weeks | int64 | No | :green_circle: Public | Upper bound of the week range (inclusive) |

---

## Source SQL

In Power BI this is a DAX `DATATABLE`. The SQL equivalent is provided for documentation purposes.

```sql
SELECT [Category], [Sort Order], [Min Weeks], [Max Weeks]
FROM (VALUES
    ('Short',      1,   0,  12),
    ('Medium',     2,  13,  52),
    ('Long',       3,  53, 104),
    ('Ultra-Long', 4, 105, 999)
) AS v([Category], [Sort Order], [Min Weeks], [Max Weeks]);
```

The equivalent DAX is:

```dax
Stay Category =
DATATABLE(
    "Category", STRING,
    "Sort Order", INTEGER,
    "Min Weeks", INTEGER,
    "Max Weeks", INTEGER,
    {
        { "Short",      1,   0,  12 },
        { "Medium",     2,  13,  52 },
        { "Long",       3,  53, 104 },
        { "Ultra-Long", 4, 105, 999 }
    }
)
```

---

## Transformation Notes

1. **Disconnected slicer pattern**: This table has no relationships in the model. Measures reference it using `SELECTEDVALUE` or `VALUES` to read the slicer selection and apply filtering logic dynamically.

2. **Week bands**: The bands are contiguous (12 to 13, 52 to 53, 104 to 105) with no gaps. The upper bound of 999 weeks for Ultra-Long effectively captures all tenancies longer than 2 years.

3. **Sort Order**: Used to ensure correct visual ordering in slicers (Sort By Column on the Category field).

---

## Relationships

This table has **no relationships** to other tables in the model. It is a disconnected slicer table.

---

## Related Measures

| Measure | Description |
|---------|-------------|
| TH Avg Exit Time by Stay (Weeks) | Calculates average exit time filtered by the selected Stay Category band using Min Weeks and Max Weeks values |

The measure reads `SELECTEDVALUE('Stay Category'[Min Weeks])` and `SELECTEDVALUE('Stay Category'[Max Weeks])` to dynamically filter tenancy duration into the selected band before calculating the average.
