Compare Two Source Tables Dataset
=================================

This wiki describes how to **use** the Power BI dataset named **"Compare Two Source Tables"**. This dataset uses pre-configured Power Query scripts to compare two source tables representing an "old" and a "new" version and identifies row-level and column-level differences.
[Compare Two Source Tables.pbix](https://emergeaotearoaltd.sharepoint.com/:u:/r/sites/OPS_ITServices/Shared%20Documents/Data%20and%20Analytics/_New%20Structure/Data%20Quality/Testing%20Datasets/Compare%20Two%20Source%20Tables.pbix?csf=1&web=1&e=E5QbQK)

> **Note:** Examples provided use illustrative key columns (e.g., `sort_index`, `short_code`) and a sample table (`dim_company`). You should adapt these examples to match your specific data sources and keys.

[[_TOC_]]

* * *

Purpose
-------

When working with two tables that represent the same data but from different sources or timeframes, common questions arise:
*   **Which rows** are missing between the two tables?
*   **Which columns** differ within matching rows?
The **"Compare Two Source Tables"** dataset helps you:
*   Identify row-level differences (optional).
*   Conduct a detailed column-by-column comparison of matching rows.

* * *

Dataset Overview
----------------

The dataset includes the following queries:
1.  **Source Table (OLD)**
    *   Imports data from the "old" source table (e.g., `dim_company`).
2.  **Source Table (NEW)**
    *   Imports data from the "new" source table (e.g., `dim_company_new`).
3.  **Detailed_ColumnByColumn_Comparison**
    *   Performs a _full outer join_ based on specified key columns.
    *   Displays columns from both tables side-by-side with indicators for differences.
    *   Includes an **`ExistenceStatus`** column indicating if a row appears **only in OLD**, **only in NEW**, or **in BOTH**.
4.  **DetailedDifferences_SimpleView**
    *   Provides a flattened view, showing each difference as a separate row.
    *   Format: `[KeyColumns, ColumnName, NewValue, OldValue]`.
Refreshing the dataset automatically updates these comparisons.

* * *

Key Columns (Example)
---------------------

In the example provided, the key columns are:
*   **`sort_index`**
*   **`short_code`**
Rows sharing the same `(sort_index, short_code)` values in both tables are matched for comparison. Rows without matches are flagged as missing.

> **Important:** Replace these keys with the columns that uniquely identify your data (e.g., `ID`, `Code`).

* * *

Queries Explanation
-------------------

### 1. Source Table (OLD)

Connects to your older data source:

    let
        Source = Sql.Database("YourServerName", "YourDatabaseName"),
        OldData = Source{[Schema="ETL", Item="dim_company"]}[Data]
    in
        OldData
    

### 2. Source Table (NEW)

Connects to your newer or alternative data source:

    let
        Source = Sql.Database("YourServerName", "YourDatabaseName"),
        NewData = Source{[Schema="ETL", Item="dim_company_new"]}[Data]
    in
        NewData
    

### 3. Detailed_ColumnByColumn_Comparison

*   Performs a **full outer join** on key columns to include _all rows_.
*   Expands old columns with suffixes (e.g., `_Old`).
*   Identifies column-level differences per row.
*   **Adds** an `ExistenceStatus` column indicating if the row exists **only in OLD**, **only in NEW**, or **in BOTH**.
    *   A row is considered “only in OLD” if all of the “new” columns are null, “only in NEW” if all of the “old” columns are null, or “in BOTH” otherwise.

> **Note:** If the query filters out rows where there are **no** column differences, you won’t see rows that match perfectly in both tables. Remove or modify the filter step if you want to see those “identical” rows.

### 4. DetailedDifferences_SimpleView

*   Converts column-level differences into individual rows.
*   Clearly identifies each difference: `[sort_index, short_code, ColumnName, NewValue, OldValue]`.

* * *

Comparison Process
------------------

### Step 1: Refresh Data

*   Refreshing fetches the latest data from both **OLD** and **NEW** tables.

### Step 2: Full Outer Join

*   Matches rows based on keys (e.g., `(sort_index, short_code)`).
*   Unmatched rows will have `null` values on one side.

### Step 3: Column-Level Comparison

*   Each column is compared (`NewValue <> OldValue`).
*   Differences are captured in a dedicated column (`Differences` or `WhichColumnsDiffer`).
*   Rows missing entirely in one table are considered different for all columns.
*   The **`ExistenceStatus`** column also indicates _where_ each row exists: only in OLD, only in NEW, or both.

### Step 4: Flatten Results

*   `DetailedDifferences_SimpleView` lists each column-level difference as a separate row for clarity.

* * *

Using Comparison Results
------------------------

### Power BI Desktop

*   **Data View:** Inspect differences through `DetailedDifferences_SimpleView` or `Detailed_ColumnByColumn_Comparison`.
*   **Report View:** Visualize differences using tables or matrices.

### Filtering Differences

*   Apply filters or slicers on `ColumnName` to pinpoint specific changes (e.g., `company_name`, `region`).

### Identifying Missing Rows

*   Rows appearing only in **OLD** or **NEW** are fully marked as different (`null` on missing side).
*   Use `ExistenceStatus` to see if a row is exclusively in one table or present in both.

> **Tip:** You can export the difference results as CSV or Excel files for sharing with other teams.

* * *

FAQ and Next Steps
------------------

**Q: How do I modify key columns for my data?**  
A: Replace `{"sort_index", "short_code"}` in the Power Query script with your actual key columns (e.g., `{"ID"}` or `{"CompanyID", "ClientID"}`).
**Q: Can I do only row-level comparisons?**  
A: Yes. Use **LeftAnti** merges to find rows existing in one table but not the other. Ideal if you only need presence/absence comparisons.
**Q: Do the `_Old` columns appear in final reports?**  
A: They exist in comparison queries but can be hidden in report views. Primarily for debugging or detailed analysis.
**Q: Are there performance considerations?**  
A: For large tables, consider filtering or pushing difference logic into data sources (e.g., T-SQL `EXCEPT`).
**Q: How do I recognize if a row doesn't exist in the other table?**  
A: Look for rows where all columns from the opposite side are `null`. In the detailed comparisons, these rows appear with every column flagged as different. If you want them isolated, a LeftAnti or RightAnti join can show only those missing rows.
**Q: Can I see a simple example of a difference row?**  
A: For a key `(sort_index = 10, short_code = "ABC")` in the _DetailedDifferences_SimpleView_, you might see `ColumnName = "company_name"`, `NewValue = "XYZ Co"`, `OldValue = "ZZZ Corp"`. This indicates “company_name” changed between the two versions for that key.
**Q: What if I want to see rows that match perfectly in both tables?**  
A: By default, the example scripts filter out rows with no differences. You can remove or comment out that filter step to show rows that have no changed columns (i.e., identical rows).

### Recommended Next Steps

1.  **Review** existing dataset queries: `Source Table (OLD)`, `Source Table (NEW)`, `Detailed_ColumnByColumn_Comparison`, `DetailedDifferences_SimpleView`.
2.  **Customize** key columns, table references, or filters based on your scenario.
3.  **Refresh** the dataset to review updated differences.
4.  **Visualize or Export** differences to support analysis and communication.
With **"Compare Two Source Tables"**, you gain a repeatable and systematic approach to identifying differences between datasets. Adjust queries according to your needs and maintain a clear view of changes in your data sources.