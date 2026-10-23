# Database Schema Explorer

Queries SQL Server system views to extract metadata about tables, views, and columns.

## Base Query
```sql
SELECT 
    s.name AS Schema_Name,
    o.name AS Object_Name, 
    o.type_desc AS Object_Type,
    c.name AS Column_Name,
    t.name AS Data_Type,
    c.max_length AS Max_Length
FROM 
    sys.columns c
JOIN 
    sys.objects o 
ON 
    c.object_id = o.object_id
JOIN
    sys.types t
ON
    c.system_type_id = t.system_type_id
JOIN
    sys.schemas s
ON
    o.schema_id = s.schema_id
WHERE 
    o.type IN ('U', 'V')  -- U for tables, V for views
    AND s.name LIKE '%%'  -- Search Term for schema name
    AND o.name LIKE '%%'  -- Search Term for table/view name
    AND c.name LIKE '%%'  -- Search Term for column name
    --AND c.name COLLATE Latin1_General_BIN LIKE '%[A-Z]%' -- Checks for capital letter in column name
ORDER BY 
    s.name,
    o.name, 
    c.column_id;
```

## Filters

Schema filter:
```sql
AND s.name LIKE 'dbo%'
```

Object filter:
```sql
AND o.name LIKE 'Customer%'
```

Column filter:
```sql
AND c.name LIKE '%Id%'
```

Capital letter check:
```sql
AND c.name COLLATE Latin1_General_BIN LIKE '%[A-Z]%'
```

## Object Types
- U: Tables
- V: Views

## System Views Used
- sys.columns
- sys.objects
- sys.types
- sys.schemas