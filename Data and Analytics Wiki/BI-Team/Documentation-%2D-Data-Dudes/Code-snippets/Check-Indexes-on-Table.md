to see what columns are being use to create a index on a table you can use the following SQL Query

```
SELECT 
    i.name AS IndexName,
    OBJECT_NAME(ic.object_id) AS TableName,
    c.name AS ColumnName,
    ic.index_column_id,
    ic.is_included_column
FROM 
    sys.indexes i
INNER JOIN 
    sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN 
    sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE 
    OBJECT_NAME(ic.object_id) = 'YourTableName'
ORDER BY 
    i.name, ic.index_column_id;
```