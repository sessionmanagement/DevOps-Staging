Run this script to get the list of defragmented indexes

```sql

SELECT S.name AS 'Schema_Name'
,T.name AS 'Table_Name',I.name AS 'Index_Name'
,DDIPS.avg_fragmentation_in_percent
,DDIPS.page_count
,COALESCE(CASE WHEN DDIPS.avg_fragmentation_in_percent >= 30 AND DDIPS.page_count >= 1000 THEN 'Rebuild' ELSE NULL END
,CASE WHEN DDIPS.avg_fragmentation_in_percent >= 5 AND DDIPS.page_count >= 10 THEN 'Reorganise' ELSE NULL END,'Ignore' ) AS IndexOptimizeType

FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS DDIPS
INNER JOIN sys.tables T ON T.object_id = DDIPS.object_id
INNER JOIN sys.schemas S ON T.schema_id = S.schema_id
INNER JOIN sys.indexes I ON I.object_id = DDIPS.object_id
AND DDIPS.index_id = I.index_id
WHERE DDIPS.database_id = DB_ID()AND I.name IS NOT NULL
AND (DDIPS.avg_fragmentation_in_percent >= LEAST(5,30))
AND (DDIPS.page_count >= LEAST(10,1000))AND (S.name = '' OR '' = '')
AND (I.name LIKE '%%' OR '' = '')
AND (T.name LIKE '%%' OR '' = '')
and S.name like '%EDW%'
ORDER BY DDIPS.avg_fragmentation_in_percent DESC


```