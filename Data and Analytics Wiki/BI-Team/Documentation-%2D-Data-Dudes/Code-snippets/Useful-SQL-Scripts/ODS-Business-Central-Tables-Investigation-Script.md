# Business Central Tables Investigation Script

## Purpose
Script to investigate datetime2 columns in problematic BC tables in ODS that cannot be queried.

## Configuration Options

### Tables to Check
Modify the IN clause in the CTE:
```sql
AND t.name IN (
    'vendorLedgerEntries',
    'fixedAssets',
    'faLedgerEntries',
    'faDepreciationBooks',
    'customers',
    'customerLedgerEntries',
    'bankAccountLedgerEntries'
)
```

### Data Type to Check
```sql
AND ty.name = 'datetime2'  -- Change to desired type, e.g., 'decimal', 'varchar'
```

### Schema
```sql
WHERE t.schema_id = SCHEMA_ID('BusinessCentral')  -- Change to desired schema
```

## Investigation Script
```sql
DECLARE @DynSQL NVARCHAR(MAX);

WITH AllCheckedColumns
AS (
	SELECT TableName = t.name,
		ColumnName = c.name
	FROM sys.tables t
	INNER JOIN sys.columns c ON t.object_id = c.object_id
	INNER JOIN sys.types ty ON c.user_type_id = ty.user_type_id
	WHERE t.schema_id = SCHEMA_ID('BusinessCentral')
		AND t.is_external = 1
		AND ty.name = 'datetime2'
		AND t.name IN (
			'vendorLedgerEntries',
			'fixedAssets',
			'faLedgerEntries',
			'faDepreciationBooks',
			'customers',
			'customerLedgerEntries',
			'bankAccountLedgerEntries'
			)
	)
SELECT @DynSQL = (
		SELECT N'PRINT ''---- Checking [' + TableName + '].[' + ColumnName + '] ----'';' + CHAR(13) + CHAR(10) + N'BEGIN TRY
			SELECT
				''' + TableName + ''' AS [TableName],
				COUNT_BIG([' + ColumnName + ']) AS [' + ColumnName + ' Row Count]
			FROM [BusinessCentral].[' + TableName + ']
			WHERE [' + ColumnName + '] IS NOT NULL;

			PRINT ''PASS: [' + TableName + '].[' + ColumnName + '] has no parsing issues.'';
		END TRY
		BEGIN CATCH
			PRINT ''FAIL: [' + TableName + '].[' + ColumnName + '] => '' + ERROR_MESSAGE();
		END CATCH;
		'
		FROM AllCheckedColumns
		FOR XML PATH(''),
			TYPE
		).value('.', 'NVARCHAR(MAX)');

-- Optional: Uncomment to see the generated script before actually running it
-- PRINT @DynSQL;
EXEC sp_executesql @DynSQL;
```

## Common Data Types Reference
- `datetime2` - Date and time with fractional seconds
- `decimal` - Exact numeric values
- `varchar` - Variable-length string data
- `nvarchar` - Unicode variable-length string data
- `int` - Integer values
- `bigint` - Large integer values
- `bit` - Boolean values (0 or 1)
- `float` - Approximate numeric values
- `money` - Monetary values
- `date` - Date values only
- `time` - Time values only

## Output Format
- Table and column being checked
- For successful checks: Row count of non-null values + "PASS" message
- For failed checks: "FAIL" message with specific error details

## Quick Troubleshooting
1. Verify table existence in specified schema
2. Check table name spelling
3. Verify data type exists in tables
4. Check data source accessibility for external tables