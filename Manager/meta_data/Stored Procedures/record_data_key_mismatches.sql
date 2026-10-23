
CREATE   procedure [meta_data].[record_data_key_mismatches]

/***********************************************************************************************************************
NAME:     [meta_data].[record_data_key_mismatches]
PURPOSE:  Calculate the number of invalid links with dim_keys (mismatches) -1's


REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-10-10	  Greg Nuthall			Initial creation of stored procedure
1.1     2025-03-11    Greg Nuthall			Changed to be a source not fill table
1.2		2025-10-17    Greg Nuthall			Added clause to remove dim table legtimate rows
1.3		2025-12-04    Greg Nuthall			Converted to NZ time
**************************************************************************************************************************/


as

begin

	declare @tablename nvarchar(255)
	declare @columnname nvarchar(255)
	declare @sql nvarchar(max)
	declare @schemaname nvarchar(255)
	declare @columnlist as nvarchar(max)


	create table #results (
		schemaname nvarchar(255),
		tablename nvarchar(255),
		columnname nvarchar(255),
		keycount int
		)

	declare tablecursor cursor
	for
	select s.name as schemaname,
		t.name as tablename,
		c.name as columnname
	from sys.tables t
	inner join sys.schemas s on t.schema_id = s.schema_id
	inner join sys.columns c on t.object_id = c.object_id
	inner join sys.types ty on c.user_type_id = ty.user_type_id
	where c.name like '%_key'
		and ty.name in (
			'int',
			'bigint',
			'smallint',
			'tinyint'
			)
		and s.name = 'edw'
		and t.name not like '%_bkp%'

	open tablecursor

	fetch next
	from tablecursor
	into @schemaname,
		@tablename,
		@columnname

	while @@fetch_status = 0
	begin
		set @sql = 'select ''' + @schemaname + ''' as schemaname, ''' + @tablename + ''' as tablename, ''' + @columnname + ''' as columnname, count(*) as keycount 
					from ' + @schemaname + '.' + @tablename + ' 
					where ' + @columnname + ' = -1'

		insert into #results (
			schemaname,
			tablename,
			columnname,
			keycount
			)
		exec sp_executesql @sql

		fetch next
		from tablecursor
		into @schemaname,
			@tablename,
			@columnname
	end

	close tablecursor

	deallocate tablecursor

	--Insert into meta_data.mismatches ([schema_name]
	--									,table_name
	--									,column_name
	--									,mismatches_count
	--									,mismatches_date)
	
	--Remove count of -1 records for dim tables (They are legitimate) 
	Update #Results Set KeyCount = isnull(KeyCount,0) - 1
	where TableName like 'dim_%'
	and isnull(KeyCount,0) >= 1



	Select SchemaName as [schema_name]
	, TableName as table_name
	, ColumnName as column_name
	, KeyCount as mismatches_count
	--, getDate() as mismatches_date 
	,dateadd(mi, DATEPART(tz, (CAST('2021-01-01' AS DATETIMEOFFSET) AT TIME ZONE 'New Zealand Standard Time')), getdate()) as mismatches_date
	from #Results


end