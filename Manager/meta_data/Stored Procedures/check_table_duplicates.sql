
CREATE   procedure [meta_data].[check_table_duplicates]

as

--Cycles through the tables in the edw and looks for duplicates, groups by all no system columns

begin

	declare @tablename nvarchar(255)
	declare @columnnames nvarchar(max)
	declare @sql nvarchar(max)
	declare @schemaname nvarchar(255)
	--declare @columnlist as nvarchar(max)

	create table #Duplicate_Results (
		[schema_name] nvarchar(20)
		,table_name nvarchar(100)
		,duplicate_count int
		,check_date datetime
		)

	declare tablecursor cursor
	for
		select s.name as schemaname,
		t.name as tablename,
		string_agg(cast(c.name as nvarchar(max)),',') as columnnames
	
	from sys.tables t
	inner join sys.schemas s on t.schema_id = s.schema_id
	inner join sys.columns c on t.object_id = c.object_id
	inner join sys.types ty on c.user_type_id = ty.user_type_id
	where s.name = 'edw'
	and left(c.name,3) <> 'DWH'
	and left(c.name,3) <> 'EDW'
	and c.name <> 'am.pm'

	--and t.name not like '%property%'

	group by s.name, t.name

	open tablecursor

	fetch next
	from tablecursor
	into @schemaname,
		@tablename,
		@columnnames

	while @@fetch_status = 0
	begin

		--SET @SQL = '
		--SELECT ''' + @schemaname + '''' + ' as schemaname,' + '''' + @TableName + ''' as tablename, COUNT(*) AS duplicatecount
		--,getdate() as check_date 
		--FROM ' + @schemaname + '.' + @TableName + '
		--GROUP BY ' + @columnnames + '
		--HAVING COUNT(*) > 1'
		
		SET @SQL = 'select schemaname, tablename, count(duplicatecount), max(check_date) from (
		SELECT ''' + @schemaname + '''' + ' as schemaname,' + '''' + @TableName + ''' as tablename, COUNT(*) AS duplicatecount
		,getdate() as check_date 
		FROM ' + @schemaname + '.' + @TableName + '
		GROUP BY ' + @columnnames + '
		HAVING COUNT(*) > 1 ) T1

		group by schemaname, tablename'

		--only insert if there are rows
		Insert into #Duplicate_Results 
		([schema_name]
		,table_name
		,duplicate_count
		,check_date	)
		
		exec sp_executesql @SQL

		print @SQL
		--EXEC sp_executesql @SQL

		fetch next
		from tablecursor
		into @schemaname,
			@tablename,
			@columnnames
	end

	--insert into meta_data.duplicate_check ([schema_name],table_name,duplicate_count,check_date)
	--select [schema_name],table_name,duplicate_count,check_date from #Duplicate_Results

	select [schema_name],table_name,duplicate_count,check_date from #Duplicate_Results

	close tablecursor

	deallocate tablecursor

end