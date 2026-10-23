## Introduction

This wiki provides comprehensive guidance on creating Power BI semantic models for the Business Intelligence (BI) team at Emerge Aotearoa. It is designed to help both new and experienced team members understand our practices and ensure consistency in our work.

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

Example (Tangata Whaiora Dataset):
- Fact tables: 
  - Fact Tangata Whaiora Referral
  - Fact Tangata Whaiora Activity Breakdown
  - Fact Tangata Whaiora PRIMHD Review
- Dimension tables:
  - Dim Tangata Whaiora
  - Dim Tangata Whaiora Team
  - Dim Service
  - Dim Date (and various role-playing date dimensions)
</details>

## Step-by-Step Guide to Creating a Semantic Model

### 1. Data Acquisition and Preparation

<details>
<summary><b>Connecting to Data Sources</b></summary>

1. Open Power BI Desktop
2. Click on 'Get Data' and select your data source (e.g., SQL Server, Excel, CSV)
3. Enter the necessary connection details
4. Select the tables you want to import
5. Choose between Import or DirectQuery mode based on your requirements

**Best Practice:** Use Import mode for smaller datasets and when you need to leverage Power BI's in-memory processing. Use DirectQuery for large datasets or when you need real-time data.
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
        replaceClient = Text.Replace(columnName, "client_", "Tangata_Whaiora_"),
        replaceUnderscore = Text.Replace(replaceClient, "_", " "),
        capitaliseWords = Text.Proper(replaceUnderscore),
        capitaliseID = Text.Replace(capitaliseWords, "Id", "ID"),
        capitaliseKEY = Text.Replace(capitaliseID, "Key", "KEY")
    in
        capitaliseKEY
```

4. Create date tables if needed

**Best Practice:** Document your M code transformations clearly, especially for complex operations. Use comments to explain the purpose of each step.
</details>

### 2. Building the Data Model

<details>
<summary><b>Creating Relationships</b></summary>

1. Go to the 'Model' view in Power BI Desktop
2. Identify common fields between tables (usually key columns)
3. Drag and drop to create relationships between tables
4. Set cardinality (e.g., Many-to-One) and cross-filter direction

**Best Practice:** Ensure all fact tables are connected to relevant dimension tables. Use bi-directional filtering sparingly and only when necessary.
</details>

<details>
<summary><b>Implementing a Star Schema</b></summary>

1. Identify your fact tables (contain numerical data for analysis)
2. Import relevant dimension tables to provide context for the facts
3. Ensure each dimension table has a unique identifier (key)
4. Connect fact tables to dimension tables using these keys

**Best Practice:** Keep your star schema as simple as possible. Avoid unnecessary complexity by limiting the number of tables and relationships.
</details>

<details>
<summary><b>Creating Date Dimensions</b></summary>

1. Create a base date table using DAX or M code
2. Add columns for various date attributes (year, month, quarter, etc.)
3. Create relationships between fact tables and the date dimension
4. For multiple date fields, create role-playing dimensions

**Example:**
```
Dim TW Activity Start Date = 
    CALENDAR(DATE(2000,1,1), DATE(2050,12,31))
```

**Best Practice:** Create a comprehensive date table that includes all possible dates your data might contain, plus some buffer. Include fiscal year calculations if relevant to your organization.
</details>

### 3. Creating Measures and Calculated Columns

<details>
<summary><b>Writing DAX Measures</b></summary>

1. Go to the 'Data' view in Power BI Desktop
2. Click 'New Measure' and enter your DAX formula
3. Use clear, descriptive names for your measures
4. Format measures appropriately (e.g., percentage, currency)

**Example:**
```
Tangata Whaiora Count = 
COUNTROWS ( 'Dim Tangata Whaiora' )
```

**Best Practice:** Create measures in a dedicated 'Measures' table for better organization. Use variables in complex DAX formulas to improve readability and performance.
</details>

<details>
<summary><b>Creating Calculated Columns</b></summary>

1. In the 'Data' view, select the relevant table
2. Click 'New Column' and enter your DAX formula
3. Use calculated columns for static calculations that don't need to be recalculated for every query

**Best Practice:** Use calculated columns sparingly, as they increase the model size and processing time. Prefer measures when possible, especially for calculations that may change based on user selections.
</details>

### 4. Implementing Security and Optimizations

<details>
<summary><b>Row-Level Security (RLS)</b></summary>

1. Create roles in the 'Modeling' tab
2. Define filters for each role using DAX
3. Test the roles using 'View as Roles'

**Best Practice:** Keep RLS rules as simple as possible. Complex rules can impact performance and are harder to maintain.
</details>

<details>
<summary><b>Performance Optimization</b></summary>

1. Use Vertipaq Analyzer to identify large tables and columns
2. Remove unnecessary columns and rows
3. Use integers for keys instead of strings where possible
4. Implement appropriate data types (e.g., don't use text for numerical data)
5. Use Power Query to perform complex transformations instead of DAX
6. Regularly use Performance Analyzer to identify slow-loading visuals
7. Consider using aggregations for very large fact tables

**Best Practice:** Regularly review and optimize your model as it grows. Monitor query performance and user feedback to identify areas for improvement.
</details>

## Best Practices and Tips

<details>
<summary><b>General Best Practices</b></summary>

- Keep the model as simple as possible while meeting business requirements
- Use consistent naming conventions across all elements of the model
- Regularly review and optimize performance
- Document all aspects of the model, including data sources, transformations, and key measures
- Implement appropriate security measures, including row-level security where necessary
- Use parameters for flexibility in data source connections and key variables
- Regularly validate the model against source data to ensure accuracy
- Use the ApplyNamingConventions function in Power Query to bulk rename columns consistently
- Set up email alerts for refresh failures to bItasks@emergeaotearoa.org.nz
- Use Microsoft Purview for managing data lineage
</details>

<details>
<summary><b>DAX Tips</b></summary>

- Use variables to break down complex calculations and improve readability
- Leverage Time Intelligence functions for date-related calculations
- Use CALCULATE function to modify filter context
- Be mindful of filter propagation in your model
- Use DAX Studio for advanced query analysis and optimization
</details>

<details>
<summary><b>M Code (Power Query) Tips</b></summary>

- Perform as much data cleaning and transformation in Power Query as possible
- Use custom functions for repetitive transformations
- Leverage parameters for flexible and reusable queries
- Document complex transformations with comments
- Use error handling in your M code to make it more robust
</details>

## Testing and Validation

<details>
<summary><b>Testing Process</b></summary>

Before releasing a new semantic model, perform the following tests:

1. Data Reconciliation Testing
   - Compare data between EDW and the semantic model
   - Check row counts between corresponding tables
   - Verify ABS values of relevant columns

2. Referential Integrity Testing
   - Ensure all foreign keys in fact tables have corresponding primary keys in dimension tables
   - Check for orphaned records

3. Fact-Dimension Integrity Testing
   - Verify that fact table granularity matches dimension keys
   - Check for any many-to-many relationships that should be many-to-one

4. Data Quality Testing
   - Check for null values in important fields
   - Verify date ranges are as expected
   - Ensure numerical fields are within expected ranges

Document all test results and address any discrepancies before release.
</details>

## Version Control and Change Management

<details>
<summary><b>Version Control Process</b></summary>

1. Use Git for version control of Power BI files
2. Implement a branching strategy for development and production versions
3. Maintain a versioning table within the semantic model:
   - Create this table in Power Query
   - Include columns for:
     - Version number
     - Change description
     - Who made the change
     - User story number that initiated the change
   - Update this table with each significant change to the model

4. Use Power BI Desktop's dataset versioning feature as an additional backup
</details>

## Monitoring and Maintenance

<details>
<summary><b>Setting Up Alerts</b></summary>

1. Configure all semantic models to send email alerts to bItasks@emergeaotearoa.org.nz in case of refresh failures
2. The assigned Bug Master for each sprint is responsible for monitoring these alerts
</details>

<details>
<summary><b>Data Lineage</b></summary>

Use Microsoft Purview for managing and documenting data lineage in your semantic models. This helps in:

1. Understanding data flow from source to consumption
2. Impact analysis when making changes to data sources or model structure
3. Ensuring compliance with data governance policies
4. Facilitating audits and data quality assessments

Regularly update the data lineage information in Purview as your semantic model evolves.
</details>

## Need Help?

This wiki provides an overview of how our BI team creates and manages Power BI semantic models. If you have any questions about the process, need clarification on our practices, or have suggestions for improvement, please don't hesitate to seek assistance.