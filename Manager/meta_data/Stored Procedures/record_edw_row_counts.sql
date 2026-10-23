
CREATE   procedure [meta_data].[record_edw_row_counts]

as

begin


	--insert into meta_data.row_count ([schema_name], table_name, row_count, row_count_date)

	--select sc.name as schemaname
	-- ,ta.name tablename
	-- ,sum(pa.rows) rowcnt
	-- ,getdate() as dateofcount
	-- from sys.tables ta
	-- inner join sys.partitions pa
	-- on pa.object_id = ta.object_id
	-- inner join sys.schemas sc
	-- on ta.schema_id = sc.schema_id
	-- where ta.is_ms_shipped = 0 and pa.index_id in (1,0)
	-- and sc.name = 'edw'
	-- group by sc.name,ta.name
	-- order by sc.name,ta.name


	 select sc.name as schemaname
	 ,ta.name tablename
	 ,sum(pa.rows) rowcnt
	 ,getdate() as dateofcount
	 from sys.tables ta
	 inner join sys.partitions pa
	 on pa.object_id = ta.object_id
	 inner join sys.schemas sc
	 on ta.schema_id = sc.schema_id
	 where ta.is_ms_shipped = 0 and pa.index_id in (1,0)
	 and sc.name = 'edw'
	 group by sc.name,ta.name
	 order by sc.name,ta.name


end;