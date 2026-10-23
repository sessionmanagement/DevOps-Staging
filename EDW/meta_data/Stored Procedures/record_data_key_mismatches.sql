CREATE   procedure [meta_data].[record_data_key_mismatches]

as

begin

	declare @tablename nvarchar(255)
	declare @columnname nvarchar(255)
	declare @sql nvarchar(max)
	declare @schemaname nvarchar(255)
	declare @columnlist as nvarchar(max)


	create table #WithDMLOperation
	(tablename nvarchar(255))

	Insert into #WithDMLOperation
	select t.name as tablename

	from sys.tables t
	inner join sys.schemas s on t.schema_id = s.schema_id
	inner join sys.columns c on t.object_id = c.object_id
	inner join sys.types ty on c.user_type_id = ty.user_type_id
	where c.name like 'DWHDMLOperation'
	and s.name = 'edw'

	Group by t.name 



	create table #results (
		schemaname nvarchar(255),
		tablename nvarchar(255),
		columnname nvarchar(255),
		queryused nvarchar(400),
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
		and t.name in (Select tablename from #WithDMLOperation)
		--and t.name not in ('fact_finance_general_ledger')

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
					where ' + @columnname + ' = -1 and DWHDMLOperation <> ''' + 'D' + '''';

		insert into #results (
			schemaname,
			tablename,
			columnname,
			keycount
			)
		exec sp_executesql @sql;

		Update #results Set queryused =  @sql where tablename = @tablename and columnname = @columnname
		
		fetch next
		from tablecursor
		into @schemaname,
			@tablename,
			@columnname
	end

	close tablecursor

	deallocate tablecursor



	declare tablecursor2 cursor
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
		and t.name not in (Select tablename from #WithDMLOperation)
		--and t.name not in ('fact_finance_general_ledger')

	open tablecursor2

	fetch next
	from tablecursor2
	into @schemaname,
		@tablename,
		@columnname

	while @@fetch_status = 0
	begin
		set @sql = 'select ''' + @schemaname + ''' as schemaname, ''' + @tablename + ''' as tablename, ''' + @columnname + ''' as columnname, count(*) as keycount 
					from ' + @schemaname + '.' + @tablename + ' 
					where ' + @columnname + ' = -1 '

		insert into #results (
			schemaname,
			tablename,
			columnname,
			keycount
			)
		exec sp_executesql @sql

		Update #results Set queryused =  @sql where tablename = @tablename and columnname = @columnname

		fetch next
		from tablecursor2
		into @schemaname,
			@tablename,
			@columnname
	end

	close tablecursor2

	deallocate tablecursor2


	--Insert into meta_data.mismatches ([schema_name]
	--									,table_name
	--									,column_name
	--									,mismatches_count
	--									,mismatches_date)


	Select SchemaName as [schema_name]
	, TableName as table_name
	, ColumnName as column_name
	, KeyCount as mismatches_count
	,dateadd(mi, DATEPART(tz, (CAST('2021-01-01' AS DATETIMEOFFSET) AT TIME ZONE 'New Zealand Standard Time')), getdate()) as mismatches_date
	, queryused
	
	from #Results
	where not (TableName like '%dim%' and KeyCount = 1)

	--drop table #Results

	--drop table #WithDMLOperation

end