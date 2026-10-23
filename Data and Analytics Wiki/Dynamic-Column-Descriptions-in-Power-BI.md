Technical Documentation: Dynamic Column Descriptions in Power BI
================================================================

Proof of Concept
----------------

* * *

Overview
--------

This POC demonstrates how to automatically synchronize SQL Server column documentation (extended properties) with Power BI, providing:
*   Dynamic column descriptions that update on refresh
*   User-friendly column names derived from SQL metadata
*   Zero manual maintenance after initial setup

* * *

Technical Architecture
----------------------

::: mermaid
graph LR
    A[SQL Extended Properties] --> B[SQL View]
    B --> C[Power BI Metadata Table]
    C --> D[Renaming Function]
    D --> E[User-Friendly Tables]
:::

* * *

Implementation
--------------

### 1. SQL Setup - Extended Properties

Store column descriptions as SQL Server extended properties:

    -- Add column description
    EXEC sp_addextendedproperty 
        @name = N'MS_Description',
        @value = N'Unique system-generated identifier for each client',
        @level0type = N'SCHEMA', @level0name = N'dq',
        @level1type = N'TABLE',  @level1name = N'desc_test_clients',
        @level2type = N'COLUMN', @level2name = N'client_id';
    

### 2. SQL View - Expose Metadata

Create a view to query extended properties:

    CREATE OR ALTER VIEW dq.vw_column_descriptions
    AS
    SELECT 
        s.name AS SchemaName,
        t.name AS TableName,
        c.name AS ColumnName,
        CONCAT(s.name, ' ', t.name) AS PowerBITableName,
        c.column_id AS ColumnOrdinal,
        TYPE_NAME(c.user_type_id) AS DataType,
        CAST(ep.value AS NVARCHAR(MAX)) AS Description,
        GETDATE() AS MetadataRefreshDate
    FROM sys.tables t
        INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
        INNER JOIN sys.columns c ON t.object_id = c.object_id
        LEFT JOIN sys.extended_properties ep 
            ON ep.major_id = t.object_id 
            AND ep.minor_id = c.column_id
            AND ep.name = 'MS_Description'
    WHERE s.name = 'dq' AND t.name LIKE 'desc_test_%';
    

### 3. Power BI - Import Metadata

Import the view as a Power BI table:

    let
        Source = Sql.Database("server", "database"),
        MetadataView = Source{[Schema="dq",Item="vw_column_descriptions"]}[Data]
    in
        MetadataView
    

### 4. Power Query Function - Dynamic Renaming

Create a function to rename columns based on descriptions:

    // fn_RenameColumnsWithDescriptions
    (SourceTable as table, PowerBITableName as text) as table =>
    let
        Metadata = #"Column Descriptions Metadata",
        TableMetadata = Table.SelectRows(Metadata, each 
            [PowerBITableName] = PowerBITableName),
        
        OriginalColumns = Table.ColumnNames(SourceTable),
        
        RenameList = List.Transform(OriginalColumns, (colName) =>
            let
                DescriptionRow = Table.SelectRows(TableMetadata, 
                    each [ColumnName] = colName),
                Description = if Table.RowCount(DescriptionRow) > 0 
                    then DescriptionRow{0}[Description]
                    else null,
                CleanedName = if Description <> null
                    then Text.Start(Description, 50)
                    else colName
            in
                {colName, CleanedName}
        ),
        
        RenamedTable = Table.RenameColumns(SourceTable, RenameList)
    in
        RenamedTable
    

### 5. Apply Renaming to Tables

Create user-friendly versions of tables:

    // Clients (Descriptive Names)
    let
        Source = #"dq desc_test_clients",
        RenamedColumns = fn_RenameColumnsWithDescriptions(
            Source, "dq desc_test_clients")
    in
        RenamedColumns
* * *
 ## Project Structure
```
Column Descriptions POC/
├── SQL Scripts/
│   ├── SQL Tables                       # Create tables with extended properties
│   └── vw_column_descriptions.sql      # View to expose descriptions
│
└── Power BI Model/
    ├── Column Descriptions Metadata     # Imported metadata table
    ├── fn_RenameColumnsWithDescriptions # Renaming function
    └── Renamed Tables/
        ├── Clients (Descriptive Names)
        ├── Outcomes (Descriptive Names)
        └── Services (Descriptive Names)
```