Use the below SQL Script to drop object in the ODS.  Change the schema name and the table you want to remove from the ODS

```
DECLARE @schema_name nvarchar(250) = 'kpi'
DECLARE @table_name nvarchar(250) = 'target_definitions'

select
	'IF OBJECT_ID(N''' + CONCAT(SCHEMA_NAME(schema_id),'.',name) + ''', N''U'') IS NOT NULL  
			DROP EXTERNAL TABLE ' + CONCAT(SCHEMA_NAME(schema_id),'.',name) as sql
	,SCHEMA_NAME(schema_id)
	, CONCAT(SCHEMA_NAME(schema_id),'.',name) as table_name
	,* 
	from sys.tables as t
	where ((SCHEMA_NAME(schema_id) = 'landing' and name like '' + @schema_name  + '%') 
			OR (SCHEMA_NAME(schema_id) = 'staging' and name like '' + @schema_name  + '%')
			OR (SCHEMA_NAME(schema_id) = 'working' and name like '' + @schema_name  + '%')
			OR SCHEMA_NAME(schema_id) = @schema_name
			)
			and name like '%' + @table_name + ''
	order by SCHEMA_NAME(schema_id)


SELECT
'IF OBJECT_ID(N''' + CONCAT(SCHEMA_NAME(schema_id),'.',name) + ''', N''P'') IS NOT NULL  
			DROP PROCEDURE ' + CONCAT(SCHEMA_NAME(schema_id),'.',name) as sql
	, CONCAT(SCHEMA_NAME(schema_id),'.',name) as procedure_name
	, * 
from sys.procedures as p
	where (SCHEMA_NAME(schema_id) = @schema_name
	or name like '%' + LOWER(@table_name)   + '%')
	and OBJECT_NAME(object_id) like '%' + @table_name 

select
'IF OBJECT_ID(N''' + CONCAT(SCHEMA_NAME(schema_id),'.',name) + ''', N''V'') IS NOT NULL  
			DROP VIEW ' + CONCAT(SCHEMA_NAME(schema_id),'.',name) as sql
	, CONCAT(SCHEMA_NAME(schema_id),'.',name) as view_name
	, * 
	from sys.views as v
	where (SCHEMA_NAME(schema_id) = @schema_name
	or name like '%' + @schema_name + '%')
	and OBJECT_NAME(object_id) like '%' + @table_name 

	order by SCHEMA_NAME(schema_id), name
```