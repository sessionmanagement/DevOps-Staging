Rebuild index and re-do statistics

```sql


DECLARE @Index_Build_Offline_Flag BIT = CASE WHEN 'True' = 'True' THEN 1 ELSE 0 END 
,@schema VARCHAR(200) = 'edw'
,@table_name VARCHAR(200) = 'fact_client_account_activity'
,@index_name VARCHAR(200) = 'PK__edw_fact_client_account_activity'
,@SQL_rebuild_index NVARCHAR(200)
,@SQL_update_stats NVARCHAR(200)
,@index_rebuild_start_datetime DATETIME
,@index_rebuild_end_datetime DATETIME

-- create index rebuild script
SET @SQL_rebuild_index  = N'ALTER INDEX '+quotename(@index_name)
+' ON [' + @schema + '].[' + @table_name + '] REBUILD WITH (ONLINE = '
+ CASE WHEN @Index_Build_Offline_Flag = 0 THEN 'ON' ELSE 'OFF' END 
+ ')';

-- get rebuild start datetime
SELECT @index_rebuild_start_datetime = GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' 

-- run index rebuild
EXEC sp_executesql @SQL_rebuild_index;


SET @SQL_update_stats  = N'UPDATE STATISTICS '
+' [' + @schema + '].[' + @table_name + '] ' + quotename(@index_name) + ' WITH FULLSCAN '

Print @SQL_update_stats
EXEC sp_executesql @SQL_rebuild_index;



-- get rebuild end datetime
SELECT @index_rebuild_end_datetime = GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' 

-- get index fragmention after rebuild
SELECT @SQL_rebuild_index AS SQL_rebuild_index
,@SQL_update_stats as SQL_update_statistics
,@index_rebuild_start_datetime AS index_rebuild_start_datetime
,@index_rebuild_end_datetime AS index_rebuild_end_datetime
,indexstats.avg_fragmentation_in_percent
,indexstats.page_count
FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id]
AND indexstats.index_id = dbindexes.index_id

WHERE indexstats.database_id = db_id()
AND dbschemas.[name] = @schema
AND dbtables.[name] = @table_name
AND dbindexes.[name] = @index_name

```