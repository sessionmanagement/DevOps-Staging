# Power BI Semantic Model Creation Guide

## Introduction

This wiki provides comprehensive guidance on creating Power BI semantic models for our Business Intelligence (BI) team. It is designed to help both new and experienced team members understand our practices and ensure consistency in our work.

## Overview of Semantic Model Structure

<details>
<summary><b>What is a Semantic Model?</b></summary>

A semantic model in Power BI is a structured representation of data that defines relationships, calculations, and structures used for analysis. It serves as a bridge between raw data and meaningful business insights.

Key components of a semantic model include:
- Fact tables: Contain quantitative data for analysis
- Dimension tables: Provide context and attributes for the fact data
- Relationships: Connect tables based on common fields
- Measures: Pre-calculated formulas for consistent analysis
- Calculated columns: Derived fields based on existing data
</details>

<details>
<summary><b>Star Schema Structure</b></summary>

Our semantic models typically follow a star schema structure, which is optimized for analytical queries and reporting.

Key components:
- Fact tables: Central tables containing numerical data for analysis
- Dimension tables: Surrounding tables providing context for the facts
- Relationships: Connect fact tables to dimension tables
- Measures: Pre-calculated metrics for analysis
</details>

## Step-by-Step Guide to Creating a Semantic Model

### 1. Data Acquisition and Preparation

<details>
<summary><b>Connecting to Data Sources</b></summary>

1. Open Power BI Desktop
2. Click on 'Get Data' and select your data source (e.g., SQL Server)
3. Enter the necessary connection details:
   - Server: sql-prod-aus-svc-datawarehouse-01.database.windows.net (our main EDW server)
   - Database: sqldb-prod-datawarehouse-01
4. Select the tables you want to import
5. Choose Import mode

**Best Practice:** Use Import mode for datasets to leverage Power BI's in-memory processing.
</details>

<details>
<summary><b>Data Transformation (M Code)</b></summary>

1. After importing data, click on 'Transform Data' to open Power Query Editor
2. Apply necessary transformations:
   - Rename columns for clarity
   - Remove unnecessary columns
   - Change data types as needed
   - Create calculated columns
   - Filter rows (e.g., exclude deleted records)
3. Apply naming conventions consistently using the ApplyNamingConventions function:

```
ApplyNamingConventions = (columnName as text) as text =>
    let
        replaceUnderscore = Text.Replace(columnName, "_", " "),
        capitaliseWords = Text.Proper(replaceUnderscore),
        capitaliseID = Text.Replace(capitaliseWords, "Id", "ID"),
        capitaliseKEY = Text.Replace(capitaliseID, "Key", "KEY")
    in
        capitaliseKEY
```

4. Create date tables if needed

**Best Practice:** Document your M code transformations clearly, especially for complex operations. Use comments to explain the purpose of each step.
</details>

<details>
<summary><b>Adding and Converting Date Columns</b></summary>

An important transformation in our process is adding new date columns based on date keys, which are used with role-playing dates. This transformation is typically done on Fact tables. Here's the M code example:

```
#"Added and Converted Date Columns" = List.Accumulate(
    List.Select(Table.ColumnNames(#"Previous Step"), each Text.EndsWith(_, " Date KEY")),
    #"Previous Step",
    (state, columnName) =>
        Table.AddColumn(
            state,
            Text.BeforeDelimiter(columnName, " KEY"),
            each
                if Record.Field(_, columnName) <> null then
                    let
                        dateValue = Text.From(Record.Field(_, columnName)),
                        yearPart = Text.Start(dateValue, 4),
                        monthPart = Text.Middle(dateValue, 4, 2),
                        dayPart = Text.End(dateValue, 2),
                        formattedDate = yearPart & "-" & monthPart & "-" & dayPart
                    in
                        if Text.Length(dateValue) = 8 then
                            Date.FromText(formattedDate)
                        else
                            null
                else
                    null,
            type date
        )
)
```

This transformation does the following:

1. Identifies all columns in the table that end with " Date KEY".
2. For each identified column, it adds a new column with the same name minus the " KEY" suffix.
3. The new column converts the date key (which is in the format YYYYMMDD) into a proper date format.
4. If the date key is null or invalid, the new column will contain a null value.

This transformation allows us to work with actual date values alongside the date keys, facilitating easier date-based analysis and reporting.
</details>

### 2. Building the Data Model

<details>
<summary><b>Creating Relationships</b></summary>

1. Go to the 'Model' view in Power BI Desktop
2. Identify common fields between tables (usually key columns)
3. Drag and drop to create relationships between tables
4. Set cardinality (e.g., Many-to-One) and cross-filter direction
5. Disable automatic relationship creation:
   - Go to File > Options and settings > Options
   - Under 'Current File', select 'Data Load'
   - Uncheck 'Auto detect new relationships after data is loaded'

**Best Practice:** Ensure all fact tables are connected to relevant dimension tables. Use bi-directional filtering sparingly and only when necessary.
</details>

<details>
<summary><b>Implementing a Star Schema</b></summary>

1. Identify your fact tables (contain numerical data for analysis)
2. Create dimension tables to provide context for the facts
3. Ensure each dimension table has a unique identifier (key)
4. Connect fact tables to dimension tables using these keys

**Best Practice:** Keep your star schema as simple as possible. Avoid unnecessary complexity by limiting the number of tables and relationships.
</details>

<details>
<summary><b>Creating Date Dimensions</b></summary>

For our date dimensions, we use our comprehensive Dim Date table from the EDW. This table provides a wide range of date-related attributes that can be used for various types of time-based analysis. Here's how to set it up:

1. Import the Dim Date table from the EDW using the following query:
   ```sql
   SELECT * FROM [edw].[vw_dim_date]
   ```

2. After importing, you'll have access to a rich set of date attributes, including:
   - Calendar date, day, week, month, quarter, and year information
   - Financial year information
   - Holiday flags
   - Current date, month, and year flags
   - Previous year flags
   - Trading day information
   - And many more

3. Create relationships between your fact tables and this Dim Date table, typically using the `dim_date_key` column.

4. For role-playing dates (multiple date fields in fact tables):
   - Create a reference of the Dim Date table for each role-playing date
   - Rename the columns in each referenced table to give end users meaningful date fields based on the specific role (e.g., "Order Date", "Ship Date")
   - Use the ApplyNamingConventions function to bulk rename columns in these referenced tables, ensuring consistent naming

5. Create additional relationships between your fact tables and these role-playing date tables.

6. Use DAX time intelligence functions in combination with these date tables for time-based calculations.

**Best Practice:** Leverage the extensive attributes in the Dim Date table to create rich time-based analyses and avoid recreating date logic in your models. This centralized date dimension ensures consistency across all your reports and analyses.
</details>

### 3. Creating Measures and Calculated Columns

<details>
<summary><b>Organizing DAX Measures</b></summary>

Proper organization of DAX measures is crucial for maintaining a clean and efficient semantic model. Here are some best practices:

1. Create a dedicated 'Measures' table:
   - In the 'Model' view, click 'New Table'
   - Name it 'Measures Table'
   - This table will only contain measures, no data

2. Organize measures into folders:
   - Right-click on a measure and select 'Display Folder'
   - Create a logical folder structure (e.g., by business area or metric type)

3. Use a consistent naming convention for measures:
   - Start with the metric name (e.g., "Revenue", "Profit")
   - Include any relevant qualifiers (e.g., "YTD", "Previous Year")
   - Example: "Revenue YTD", "Profit Previous Year"

4. Add descriptions to measures:
   - Right-click on a measure and select 'Properties'
   - Fill in the 'Description' field with clear, concise information about the measure's purpose and calculation

5. Use variables in complex DAX formulas to improve readability and performance

Example of measure folder structure:

![Measure folder structure](/.attachments/image-c3d125ad-62b0-4fd1-a5b8-195702606d7c.png)

By following these organization practices, you'll create a more manageable and user-friendly semantic model.
</details>

<details>
<summary><b>Creating Calculated Columns</b></summary>

**Best Practice:** Use calculated columns sparingly, as they increase the model size and processing time. Prefer measures when possible, especially for calculations that may change based on user selections.
</details>

### 4. Implementing Security and Optimizations

<details>
<summary><b>Row-Level Security (RLS)</b></summary>

1. Create roles in the 'Modeling' tab
2. Define filters for each role using DAX
3. Test the roles using 'View as Roles'

**Example RLS implementation:**
```
[User Principal Name] = USERPRINCIPALNAME()
```

This formula allows for RLS based on the user's email and a Dim Service key.

![RLS implementation](/.attachments/image-9acc412f-e640-4d8e-822f-261fc8e9a76c.png)

![RLS implementation continued](/.attachments/image-e2b6937e-d0d9-46f9-a93c-abff9cf42d27.png)

**Best Practice:** Keep RLS rules as simple as possible. Complex rules can impact performance and are harder to maintain.
</details>

<details>
<summary><b>Additional Access for Row-Level Security</b></summary>

In addition to our standard RLS implementation, we have a system for granting additional access:

1. We maintain a SharePoint list that contains information about additional access granted to users.
2. This list includes details such as:
   - The requester's email
   - The email of the person to be impersonated (granted additional access)
   - The expiry date of the additional access
   - The reason for the access
   - Approval details (approver's email and approval date)
3. This SharePoint list is processed and filtered to include only current, non-expired entries for the specific report (e.g., "Finance Reporting").
4. The processed data from this list is then joined to our main EDW RLS table.

This system allows for flexible, time-limited extensions of access rights, which can be easily managed and audited through the SharePoint list.
</details>

<details>
<summary><b>Performance Optimization</b></summary>

1. Remove unnecessary columns and rows
2. Use integers for keys instead of strings where possible
3. Implement appropriate data types (e.g., don't use text for numerical data)
4. Use Power Query to perform complex transformations instead of DAX
5. Regularly use Performance Analyzer to identify slow-loading visuals
6. Consider using aggregations for very large fact tables

**Best Practice:** Regularly review and optimize your model as it grows. Monitor query performance and user feedback to identify areas for improvement.
</details>

### Dataset Template

<details>
<summary><b>ChangeLog Table Example</b></summary>

We use a dataset template that includes all the basic components for a quick start:

- ChangeLog table
- Column renaming function
- Other standard components

The ChangeLog table is particularly important for version control. Here's an example of how it's structured:

```
let
    // Define the table schema without the ChangeID column
    InitialTable = #table(
        {"Version", "Change Date", "Changed By", "User Story ID", "Description"},
        {
            {
                "1.0.0", /* Version */
                #date(2024, 6, 27),  /* Date */
                "Thijs B",  /* Changed By */
                "#7164",  /* User Story */
                "Initial release of EDW Finance Dataset"  /* Description */
            },
            {
                "1.0.1", /* Version */
                #date(2024, 7, 02),  /* Date */
                "Thijs B",  /* Changed By */
                "#8133",  /* User Story */
                "Remove close income statement from GL data"  /* Description */
            },
            {
                "1.1.0", /* Version */
                #date(2024, 7, 03),  /* Date */
                "Mike G",  /* Changed By */
                "#8148",  /* User Story */
                "Converted relationships between Dim Service to Fact Tables as a Many to Many on service ID instead of slowly changing service key"  /* Description */
            }
        }
    ),
    // Add an Index column to generate incremental numbers
    TableWithIndex = Table.AddIndexColumn(InitialTable, "Change ID", 1, 1, Int64.Type),
    // Reorder the columns to place ChangeID first
    ReorderedColumns = Table.ReorderColumns(TableWithIndex, {"Change ID", "Version", "Change Date", "Changed By", "User Story ID", "Description"})
in
    ReorderedColumns
```
</details>

### Testing and Validation

For detailed information on our testing process, please refer to our [Testing and sign-off process](/BI-Team/Documentation-%2D-Analysts/Testing-and-Sign%2DOff-process).

### Setting Up Refresh Schedules

<details>
<summary><b>Refresh Schedule Information</b></summary>

After publishing the semantic model to production:

1. Navigate to the workspace containing your published dataset
2. Click on the dataset and select 'Schedule refresh'
3. Set up the refresh schedule according to our standard:
   - Frequency: Daily
   - Time Window: Start after 6:30 AM, with the latest start time no later than 7:30 AM
4. Save the refresh schedule

**Best Practice:** Ensure all refresh schedules fall within the specified time window to align with our organizational standards.
</details>

## Need Help?

This wiki provides an overview of how our BI team creates and manages Power BI semantic models. If you have any questions about the process, need clarification on our practices, or have suggestions for improvement, please don't hesitate to seek assistance.