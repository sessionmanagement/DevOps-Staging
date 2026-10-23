This script identifies orphaned foreign keys in fact tables by checking against their corresponding dimension tables.

## Script Details

```sql
-------------------------------------------------------------------------------
-- 1. Clean up from previous runs
-------------------------------------------------------------------------------
IF OBJECT_ID('tempdb..#KeyCheckResults', 'U') IS NOT NULL
	DROP TABLE #KeyCheckResults;

IF OBJECT_ID('tempdb..#DimTables', 'U') IS NOT NULL
	DROP TABLE #DimTables;

-------------------------------------------------------------------------------
-- 2. Create a temp table for final results
-------------------------------------------------------------------------------
CREATE TABLE #KeyCheckResults (
	DimensionTable SYSNAME,
	DimensionKeyColumn SYSNAME,
	FactTable SYSNAME,
	FactKeyColumn SYSNAME,
	OrphanedKey NVARCHAR(200), -- each unique missing key
	OrphanedCount BIGINT -- how many fact rows reference that key
	);

-------------------------------------------------------------------------------
-- 3. Declare which Dim table you to test (optional).
--    If you leave this empty or specify a table that does not exist,
--    the script will pick all edw.dim_ tables.
-------------------------------------------------------------------------------
DECLARE @RequestedDimTable SYSNAME = N'edw.dim_employee';-- <--- CHANGE or leave blank

-------------------------------------------------------------------------------
-- 4. Build a list (#DimTables) of dimension tables to process:
--       - If @RequestedDimTable is valid, use that alone.
--       - Otherwise, pick all [edw].[dim_*].
-------------------------------------------------------------------------------
CREATE TABLE #DimTables (DimTableName SYSNAME NOT NULL);

IF (
		@RequestedDimTable IS NOT NULL
		AND OBJECT_ID(@RequestedDimTable) IS NOT NULL
		)
BEGIN
	INSERT INTO #DimTables (DimTableName)
	SELECT @RequestedDimTable;
END
ELSE
BEGIN
	INSERT INTO #DimTables (DimTableName)
	SELECT s.name + N'.' + t.name
	FROM sys.tables t
	INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
	WHERE s.name = 'edw'
		AND t.name LIKE 'dim_%';
END

-------------------------------------------------------------------------------
-- 5. Script will loop over each dimension in #DimTables, find its PK, then do
--    the orphan-check across all fact tables, capturing each unique orphaned key.
-------------------------------------------------------------------------------
DECLARE @CurrentDimTable SYSNAME;
DECLARE @DimKeyColumn SYSNAME;
DECLARE @sql NVARCHAR(MAX);

DECLARE DimCursor CURSOR LOCAL FAST_FORWARD
FOR
SELECT DimTableName
FROM #DimTables
ORDER BY DimTableName;

OPEN DimCursor;

FETCH NEXT
FROM DimCursor
INTO @CurrentDimTable;

WHILE @@FETCH_STATUS = 0
BEGIN
	---------------------------------------------------------------------------
	-- 5a) Detect the dimension's PK column. If none found, skip.
	---------------------------------------------------------------------------
	WITH DimPK
	AS (
		SELECT c.name AS ColumnName
		FROM sys.indexes i
		INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id
			AND i.index_id = ic.index_id
		INNER JOIN sys.columns c ON ic.object_id = c.object_id
			AND c.column_id = ic.column_id
		WHERE i.is_primary_key = 1
			AND i.object_id = OBJECT_ID(@CurrentDimTable)
		)
	SELECT @DimKeyColumn = ColumnName
	FROM DimPK;

	IF @DimKeyColumn IS NULL
	BEGIN
		PRINT 'No PK column found in ' + @CurrentDimTable + '. Skipping.';

		FETCH NEXT
		FROM DimCursor
		INTO @CurrentDimTable;

		CONTINUE;
	END;
			---------------------------------------------------------------------------
			-- 5b) For each Fact table that has a column = @DimKeyColumn, do an orphan check
			--     capturing every unique orphaned key. GROUP BY the key to get the row count.
			---------------------------------------------------------------------------
			;

	WITH CandidateFacts
	AS (
		SELECT t.name AS FactTableName,
			c.name AS FactColumnName,
			ROW_NUMBER() OVER (
				ORDER BY t.name
				) AS rn
		FROM sys.tables t
		INNER JOIN sys.columns c ON t.object_id = c.object_id
		WHERE t.schema_id = SCHEMA_ID('edw')
			AND t.name LIKE 'fact_%'
			AND c.name = @DimKeyColumn
		)
	SELECT @sql = STUFF((
				SELECT CHAR(13) + CHAR(10) + '-- For FactTable=' + QUOTENAME(cf.FactTableName) + '
                INSERT INTO #KeyCheckResults
                (
                    DimensionTable,
                    DimensionKeyColumn,
                    FactTable,
                    FactKeyColumn,
                    OrphanedKey,
                    OrphanedCount
                )
                SELECT
                     ''' + @CurrentDimTable + ''' AS DimensionTable
                    ,''' + @DimKeyColumn + '''    AS DimensionKeyColumn
                    ,''' + cf.FactTableName + ''' AS FactTable
                    ,''' + cf.FactColumnName + ''' AS FactKeyColumn
                    ,CAST(F.' + QUOTENAME(cf.FactColumnName) + ' AS NVARCHAR(200)) AS OrphanedKey
                    ,COUNT(*) AS OrphanedCount
                FROM [edw].' + cf.FactTableName + ' F
                     LEFT JOIN ' + @CurrentDimTable + ' D
                        ON F.' + QUOTENAME(cf.FactColumnName) + ' = D.' + QUOTENAME(@DimKeyColumn) + 
					'
                WHERE D.' + QUOTENAME(@DimKeyColumn) + ' IS NULL
                GROUP BY CAST(F.' + QUOTENAME(cf.FactColumnName) + ' AS NVARCHAR(200));
                '
				FROM CandidateFacts cf
				ORDER BY cf.rn
				FOR XML PATH(''),
					TYPE
				).value('.', 'NVARCHAR(MAX)'), 1, 2, '');

	IF @sql IS NOT NULL
		AND LEN(@sql) > 0
	BEGIN
		BEGIN TRY
			EXEC sys.sp_executesql @sql,
				N'';
		END TRY

		BEGIN CATCH
			PRINT 'Error in dynamic SQL execution for ' + @CurrentDimTable + ': ' + ERROR_MESSAGE();
		END CATCH;
	END
	ELSE
	BEGIN
		PRINT 'No fact tables found referencing key "' + @DimKeyColumn + '" for ' + @CurrentDimTable + '.';
	END

	FETCH NEXT
	FROM DimCursor
	INTO @CurrentDimTable;
END

CLOSE DimCursor;

DEALLOCATE DimCursor;

-------------------------------------------------------------------------------
-- 6. Display all results
-------------------------------------------------------------------------------
SELECT *
FROM #KeyCheckResults
ORDER BY OrphanedCount DESC,
	DimensionTable,
	FactTable,
	OrphanedKey;
```

## Script Purpose

This script performs the following tasks:

1. Cleans up any existing temporary tables from previous runs
2. Creates a temporary table to store the results
3. Allows for checking a specific dimension table or all dimension tables
4. Builds a list of dimension tables to process
5. Loops through each dimension table to:
   - Detect the primary key column
   - Check for orphaned keys in fact tables
6. Displays the results ordered by the number of orphaned records

## Usage

1. Set the `@RequestedDimTable` variable to a specific dimension table name, or leave it blank to check all dimension tables
2. Execute the script
3. Review the results in the final SELECT statement

The results will show any orphaned foreign keys in fact tables, along with the count of how many fact records reference each orphaned key.