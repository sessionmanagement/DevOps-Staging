Script Explanation
------------------

1.  **Parameters**:
    *   `@ViewSchemaName` and `@ViewName` identify which ETL view we want to analyze.
        
2.  **Collect References**:
    *   We use `sys.sql_expression_dependencies` to find object IDs that the ETL view references.
        
    *   We filter out any that are `NULL` or that do not belong to a user view.
        
3.  **Generate CREATE OR ALTER Scripts**:
    *   We join back to `sys.views` and `sys.schemas` to retrieve each referenced view’s metadata.
        
    *   We build a full “CREATE OR ALTER VIEW … AS …” script by concatenating `OBJECT_DEFINITION(view.object_id)`.


```
--------------------------------------------------------------------------------
-- This script finds source views used by any ETL views matching a given name pattern,
-- then generates CREATE OR ALTER statements for those source views, ensuring each
-- source view appears only once in the final list.
--------------------------------------------------------------------------------

--USE YourDatabaseName;  -- <== Change to your database if needed
--GO

--==============================================================================
-- 1. Parameters
--==============================================================================
DECLARE @ETLSchemaName   SYSNAME     = N'ETL';   -- ETL schema name
DECLARE @ViewNamePattern NVARCHAR(128) = N'%_property_%';  
    -- e.g. '%dim_property_%' to filter ETL views whose names contain "dim_property"
    -- Adjust the LIKE pattern as needed

--==============================================================================
-- 2. Identify all ETL Views that match the pattern
--==============================================================================
;WITH ReferencingViews AS
(
    SELECT v.object_id AS referencing_id
    FROM sys.views AS v
    INNER JOIN sys.schemas AS s
        ON v.schema_id = s.schema_id
    WHERE s.name = @ETLSchemaName
      AND v.name LIKE @ViewNamePattern
),
--==============================================================================
-- 3. Gather *unique* referenced objects for all matching ETL views
--==============================================================================
DirectReferences AS
(
    SELECT DISTINCT sed.referenced_id
    FROM ReferencingViews AS rv
    INNER JOIN sys.sql_expression_dependencies AS sed
        ON sed.referencing_id = rv.referencing_id
    WHERE sed.referenced_id IS NOT NULL
)
--==============================================================================
-- 4. Generate CREATE OR ALTER statements for the *unique* source views
--==============================================================================
SELECT
    'CREATE OR ALTER VIEW [' + s.name + '].[' + v.name + '] ' + CHAR(13) + CHAR(10)
  + 'AS' + CHAR(13) + CHAR(10)
  + OBJECT_DEFINITION(v.object_id) + CHAR(13) + CHAR(10)
  + 'GO' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) AS CreateViewStatement
FROM DirectReferences AS dr
INNER JOIN sys.views AS v
    ON dr.referenced_id = v.object_id
INNER JOIN sys.schemas AS s
    ON v.schema_id = s.schema_id
ORDER BY v.name;
GO
```
