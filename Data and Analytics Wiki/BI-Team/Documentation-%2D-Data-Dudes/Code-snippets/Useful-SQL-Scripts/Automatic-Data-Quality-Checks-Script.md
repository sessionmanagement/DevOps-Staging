## Overview
This script performs automated data quality checks on specified SQL Server tables. It analyzes column metadata and generates comprehensive quality metrics based on data types.

## Features
- Accepts comma-separated list of table names with optional schemas
- Creates temporary tables for metadata and results processing
- Performs automated cleanup of temporary objects
- Generates type-specific quality checks based on column data types
- Provides consolidated results in a structured format

## Usage Instructions
1. Update the `@TableList` variable with your target tables
2. Execute the script in SSMS or any T-SQL environment
3. Review the `#DataQualityResults` output

## Script Content

```sql
/********************************************************************************************
    Script Name:    Automatic Data Quality Checks
    Description:    Runs a set of data-quality checks on one or more specified tables.
                    - Accepts a comma-separated list of table names with optional schemas.
                    - Creates and uses temporary tables to hold intermediate metadata and results.
                    - Drops temporary tables at the start and end for cleanup.
                    - Iterates through each column in each specified table to perform
                      data-quality checks based on the data type.
                    - Returns a consolidated result set with data-quality findings.
    Instructions:
        1. Update the @TableList variable to your actual tables, e.g. 'edw.dim_service, edw.fact_employee_leave'.
        2. Run the script in SSMS or any T-SQL environment.
        3. Review the #DataQualityResults output for your data-quality summary.
    Author:         Mike Gencic
    Date:           2025-01-07
********************************************************************************************/

--USE DatabaseName;  -- Optional: specify database context
--GO

--------------------------------------------
-- 1. Cleanup existing temp tables (if any)
--------------------------------------------
IF OBJECT_ID('tempdb..#TempTableList') IS NOT NULL
    DROP TABLE #TempTableList;

IF OBJECT_ID('tempdb..#ColumnMeta') IS NOT NULL
    DROP TABLE #ColumnMeta;

IF OBJECT_ID('tempdb..#DataQualityResults') IS NOT NULL
    DROP TABLE #DataQualityResults;

--------------------------------------------
-- 2. Declare and set input parameters
--------------------------------------------
DECLARE @TableList VARCHAR(MAX) = 'edw.dim_company, edw.dim_service';
-- Example: 'edw.dim_company, edw.dim_service, edw.fact_employee_leave'

--------------------------------------------
-- 3. Parse the comma-separated table list
--    and insert into a temp table
--------------------------------------------
SELECT
    CAST(NULL AS VARCHAR(128)) AS [SchemaName],
    CAST(NULL AS VARCHAR(128)) AS [TableName]
INTO #TempTableList
WHERE 1 = 0;

;WITH TableListCTE AS
(
    SELECT 
        LTRIM(RTRIM(value)) AS FullTableName
    FROM STRING_SPLIT(@TableList, ',')
)
INSERT INTO #TempTableList ([SchemaName], [TableName])
SELECT 
    CASE 
        WHEN CHARINDEX('.', FullTableName) > 0 
        THEN LEFT(FullTableName, CHARINDEX('.', FullTableName) - 1)
        ELSE 'dbo'
    END AS SchemaName,
    CASE 
        WHEN CHARINDEX('.', FullTableName) > 0 
        THEN RIGHT(FullTableName, LEN(FullTableName) - CHARINDEX('.', FullTableName))
        ELSE FullTableName
    END AS TableName
FROM TableListCTE;

--------------------------------------------
-- 4. Prepare a temp table to store 
--    column metadata for each iterated table
--------------------------------------------
SELECT
    CAST(NULL AS VARCHAR(128)) AS [SchemaName],
    CAST(NULL AS VARCHAR(128)) AS [TableName],
    CAST(NULL AS VARCHAR(128)) AS [ColumnName],
    CAST(NULL AS VARCHAR(50))  AS [DataType],
    CAST(NULL AS INT)          AS [MaxLength],
    CAST(NULL AS INT)          AS [Precision],
    CAST(NULL AS INT)          AS [Scale],
    CAST(NULL AS BIT)          AS [IsNullable],
    CAST(NULL AS BIT)          AS [IsNumeric],
    CAST(NULL AS BIT)          AS [IsDate],
    CAST(NULL AS BIT)          AS [IsString]
INTO #ColumnMeta
WHERE 1=0;

--------------------------------------------
-- 5. Insert column metadata using sys.columns
--    and sys.types for each table
--------------------------------------------
DECLARE @schemaName VARCHAR(128),
        @tableName  VARCHAR(128);

DECLARE curTables CURSOR FOR
    SELECT SchemaName, TableName
    FROM #TempTableList;

OPEN curTables;
FETCH NEXT FROM curTables INTO @schemaName, @tableName;

WHILE @@FETCH_STATUS = 0
BEGIN
    INSERT INTO #ColumnMeta ([SchemaName], [TableName], [ColumnName], [DataType],
                             [MaxLength], [Precision], [Scale], [IsNullable],
                             [IsNumeric], [IsDate], [IsString])
    SELECT
        SCHEMA_NAME(t.schema_id)        AS [SchemaName],
        t.name                          AS [TableName],
        c.name                          AS [ColumnName],
        sty.name                        AS [DataType],
        c.max_length                    AS [MaxLength],
        c.precision                     AS [Precision],
        c.scale                         AS [Scale],
        c.is_nullable                   AS [IsNullable],
        CASE WHEN sty.name IN (
              'tinyint','smallint','int','bigint',
              'decimal','numeric','float','real','money','smallmoney'
             ) THEN 1 ELSE 0 END        AS [IsNumeric],
        CASE WHEN sty.name IN (
              'date','datetime','datetime2','smalldatetime','datetimeoffset','time'
             ) THEN 1 ELSE 0 END        AS [IsDate],
        CASE WHEN sty.name IN (
              'char','nchar','varchar','nvarchar','text','ntext'
             ) THEN 1 ELSE 0 END        AS [IsString]
    FROM sys.tables t
    INNER JOIN sys.columns c ON t.object_id = c.object_id
    INNER JOIN sys.types sty ON c.user_type_id = sty.user_type_id
    WHERE SCHEMA_NAME(t.schema_id) = @schemaName
      AND t.name = @tableName;

    FETCH NEXT FROM curTables INTO @schemaName, @tableName;
END;

CLOSE curTables;
DEALLOCATE curTables;

--------------------------------------------
-- 6. Prepare a temp table for results
--------------------------------------------
SELECT
    CAST(NULL AS VARCHAR(128)) AS [SchemaName],
    CAST(NULL AS VARCHAR(128)) AS [TableName],
    CAST(NULL AS VARCHAR(128)) AS [ColumnName],
    CAST(NULL AS VARCHAR(50))  AS [DataType],
    CAST(NULL AS VARCHAR(50))  AS [CheckType],
    CAST(NULL AS VARCHAR(100)) AS [CheckResult]
INTO #DataQualityResults
WHERE 1=0;

--------------------------------------------
-- 7. Dynamically build and run queries
--    to perform data-quality checks
--------------------------------------------
DECLARE @columnName   VARCHAR(128),
        @dataType     VARCHAR(50),
        @isNumeric    BIT,
        @isDate       BIT,
        @isString     BIT,
        @checkSQL     NVARCHAR(MAX),
        @fullTableName VARCHAR(300);

DECLARE curColumns CURSOR FOR
    SELECT [SchemaName], [TableName], [ColumnName],
           [DataType], [IsNumeric], [IsDate], [IsString]
    FROM #ColumnMeta
    ORDER BY [SchemaName], [TableName], [ColumnName];

OPEN curColumns;
FETCH NEXT FROM curColumns
 INTO @schemaName, @tableName, @columnName,
      @dataType, @isNumeric, @isDate, @isString;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @fullTableName = QUOTENAME(@schemaName) + '.' + QUOTENAME(@tableName);

    /***************************************************************
     * Common checks for ALL columns:
     *   - NULL Count
     *   - Distinct Count
     *   - Total Row Count
     ***************************************************************/
    SET @checkSQL = N'
        INSERT INTO #DataQualityResults
        SELECT 
            ''' + @schemaName + ''',
            ''' + @tableName + ''',
            ''' + @columnName + ''',
            ''' + @dataType + ''',
            ''NULL Count'',
            CAST(SUM(CASE WHEN [' + @columnName + '] IS NULL THEN 1 ELSE 0 END) AS VARCHAR(100))
        FROM ' + @fullTableName + ';
        
        INSERT INTO #DataQualityResults
        SELECT 
            ''' + @schemaName + ''',
            ''' + @tableName + ''',
            ''' + @columnName + ''',
            ''' + @dataType + ''',
            ''Distinct Count'',
            CAST(COUNT(DISTINCT [' + @columnName + ']) AS VARCHAR(100))
        FROM ' + @fullTableName + ';

        INSERT INTO #DataQualityResults
        SELECT 
            ''' + @schemaName + ''',
            ''' + @tableName + ''',
            ''' + @columnName + ''',
            ''' + @dataType + ''',
            ''Total Rows'',
            CAST(COUNT(1) AS VARCHAR(100))
        FROM ' + @fullTableName + ';
    ';
    EXEC sys.sp_executesql @checkSQL;

    /***************************************************************
     * (Optional) Duplicate check:
     *   - How many rows appear more than once (for that column)?
     ***************************************************************/
    SET @checkSQL = N'
        INSERT INTO #DataQualityResults
        SELECT 
            ''' + @schemaName + ''',
            ''' + @tableName + ''',
            ''' + @columnName + ''',
            ''' + @dataType + ''',
            ''Duplicate Rows'',
            CAST(SUM(DupCount - 1) AS VARCHAR(100))
        FROM
        (
            SELECT COUNT(1) AS DupCount
            FROM ' + @fullTableName + '
            GROUP BY [' + @columnName + ']
            HAVING COUNT(1) > 1
        ) AS T;
    ';
    EXEC sys.sp_executesql @checkSQL;

    /***************************************************************
     * Numeric-specific checks:
     *   - Min, Max, Avg, StdDev
     *   - Negative values count
     *   - Zero values count
     ***************************************************************/
    IF @isNumeric = 1
    BEGIN
        SET @checkSQL = N'
            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Min Value'',
                CAST(MIN([' + @columnName + ']) AS VARCHAR(100))
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL;

            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Max Value'',
                CAST(MAX([' + @columnName + ']) AS VARCHAR(100))
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL;

            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Average Value'',
                CAST(AVG([' + @columnName + ']) AS VARCHAR(100))
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL;

            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''StdDev Value'',
                CAST(STDEV([' + @columnName + ']) AS VARCHAR(100))
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL;

            INSERT INTO #DataQualityResults
            SELECT
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Negative Values Count'',
                CAST(SUM(CASE WHEN [' + @columnName + '] < 0 THEN 1 ELSE 0 END) AS VARCHAR(100))
            FROM ' + @fullTableName + ';

            INSERT INTO #DataQualityResults
            SELECT
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Zero Values Count'',
                CAST(SUM(CASE WHEN [' + @columnName + '] = 0 THEN 1 ELSE 0 END) AS VARCHAR(100))
            FROM ' + @fullTableName + ';
        ';
        EXEC sys.sp_executesql @checkSQL;
    END;

    /***************************************************************
     * Date/Datetime-specific checks:
     *   - Min date, Max date
     *   - Future dates count
     ***************************************************************/
    IF @isDate = 1
    BEGIN
        SET @checkSQL = N'
            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Min Date'',
                CONVERT(VARCHAR(30), MIN([' + @columnName + ']), 121)
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL;

            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Max Date'',
                CONVERT(VARCHAR(30), MAX([' + @columnName + ']), 121)
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL;

            INSERT INTO #DataQualityResults
            SELECT
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Future Dates Count'',
                CAST(SUM(CASE WHEN [' + @columnName + '] > GETDATE() THEN 1 ELSE 0 END) AS VARCHAR(100))
            FROM ' + @fullTableName + ';
        ';
        EXEC sys.sp_executesql @checkSQL;
    END;

    /***************************************************************
     * String-specific checks:
     *   - Min length, Max length
     *   - Blank string count
     *   - Optional: Special character check (example pattern)
     ***************************************************************/
    IF @isString = 1
    BEGIN
        SET @checkSQL = N'
            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Min Length'',
                CAST(MIN(LEN([' + @columnName + '])) AS VARCHAR(100))
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL AND [' + @columnName + '] <> '''';

            INSERT INTO #DataQualityResults
            SELECT 
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Max Length'',
                CAST(MAX(LEN([' + @columnName + '])) AS VARCHAR(100))
            FROM ' + @fullTableName + '
            WHERE [' + @columnName + '] IS NOT NULL AND [' + @columnName + '] <> '''';

            INSERT INTO #DataQualityResults
            SELECT
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Blank String Count'',
                CAST(SUM(CASE WHEN [' + @columnName + '] = '''' THEN 1 ELSE 0 END) AS VARCHAR(100))
            FROM ' + @fullTableName + ';

            -- Optional: Example check for special characters (regex-like pattern)
            -- This uses a simple pattern checking with LIKE.
            -- Adjust the pattern as needed for your definition of "special characters."
            INSERT INTO #DataQualityResults
            SELECT
                ''' + @schemaName + ''',
                ''' + @tableName + ''',
                ''' + @columnName + ''',
                ''' + @dataType + ''',
                ''Special Char Count'',
                CAST(SUM(CASE WHEN [' + @columnName + '] LIKE ''%[^0-9A-Za-z ]%'' THEN 1 ELSE 0 END) AS VARCHAR(100))
            FROM ' + @fullTableName + ';
        ';
        EXEC sys.sp_executesql @checkSQL;
    END;

    FETCH NEXT FROM curColumns
     INTO @schemaName, @tableName, @columnName,
          @dataType, @isNumeric, @isDate, @isString;
END;

CLOSE curColumns;
DEALLOCATE curColumns;

--------------------------------------------
-- 8. Return final data-quality results
--------------------------------------------
SELECT 
    SchemaName,
    TableName,
    ColumnName,
    DataType,
    CheckType,
    CheckResult
FROM #DataQualityResults
ORDER BY SchemaName, TableName, ColumnName, CheckType;

--------------------------------------------
-- 9. Cleanup temporary tables
--------------------------------------------
DROP TABLE #TempTableList;
DROP TABLE #ColumnMeta;
DROP TABLE #DataQualityResults;
GO

```

## Output Format
The script generates a result set with the following columns:
- SchemaName: Database schema name
- TableName: Table name
- ColumnName: Column name
- DataType: SQL Server data type
- CheckType: Type of quality check performed
- CheckResult: Result of the quality check

## Check Types by Data Type

### Common Checks (All Columns)
- NULL Count
- Distinct Count
- Total Rows
- Duplicate Rows

### Numeric Columns
- Min Value
- Max Value
- Average Value
- StdDev Value
- Negative Values Count
- Zero Values Count

### Date Columns
- Min Date
- Max Date
- Future Dates Count

### String Columns
- Min Length
- Max Length
- Blank String Count
- Special Character Count

## Notes
- The script uses temporary tables, ensure adequate TempDB space
- Customize special character patterns as needed
- Add additional checks based on your specific requirements
- Consider performance impact on large tables