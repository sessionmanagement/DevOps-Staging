create   procedure [meta_data].[build_business_matrix]

as

begin

if object_id('tempdb..#results') is not null drop table #results;

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
		and t.name like 'fact%'
		and c.name like 'dim%'
		and c.name not like '%date_key'
		and c.name not like '%time_key'
		and t.name not like '%bkp%'
		
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
					where 1 = 1'

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

	Update #results Set ColumnName = replace(ColumnName,'_key','')


	--Generate a matrix
	Select @ColumnList = (Select STRING_AGG(isnull(T1.ColumnName,''), ',') from (Select Distinct ColumnName from #Results where KeyCount >= 1 ) T1)

	SET @SQL = 'Select * from (SELECT TableName as table_name, ColumnName as column_name, case when KeyCount >=1 then 1 else 0 end as matching_rows FROM #Results ) T2 pivot (sum(matching_rows) for column_name in ('
	Set @SQL = @SQL + substring(@ColumnList,0,len(@ColumnList)-1) + '))p'
	exec sp_executesql @SQL
	

	--Reverse rows and columns
	--Select @ColumnList = (Select STRING_AGG(isnull(T1.TableName,''), ',') from (Select Distinct TableName from #Results where KeyCount >= 1 ) T1)
	--SET @SQL = 'Select * from (SELECT TableName as table_name, ColumnName as column_name, case when KeyCount >=1 then 1 else 0 end as matching_rows FROM #Results ) T2 pivot (sum(matching_rows) for table_name in ('
	--Set @SQL = @SQL + substring(@ColumnList,0,len(@ColumnList)-1) + '))p'
	--exec sp_executesql @SQL


end