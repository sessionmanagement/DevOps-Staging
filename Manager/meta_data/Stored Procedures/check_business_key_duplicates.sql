
CREATE   procedure [meta_data].[check_business_key_duplicates]

as

--Cycles through the dim tables in the edw and looks for duplicates business keys
--Uses the meta_data.table_business_id to get the relevant columns becasue of inconsistient naming and dual business keys

begin

	declare @schemaname nvarchar(255)
	declare @tablename nvarchar(255)
	declare @business_id nvarchar(100)
	declare @company_id nvarchar(100)
	declare @is_current_column as nvarchar(100)
	declare @dml_operation_column  as nvarchar(100)
	declare @sql nvarchar(max)
	declare @where_clause nvarchar(200)

	--declare @columnlist as nvarchar(max)

	create table #Duplicate_Results (
		[schema_name] nvarchar(20)
		,table_name nvarchar(100)
		,business_id nvarchar(100)
		,company_id nvarchar(100)
		,duplicate_count int
		,check_date datetime
		)

	declare tablecursor cursor
	for
		select [schema_name],table_name,business_id,company_id,is_current_column, dml_operation_column 
		from meta_data.table_business_id

	open tablecursor

	fetch next
	from tablecursor
	into @schemaname
		,@tablename
		,@business_id
		,@company_id
		,@is_current_column
		,@dml_operation_column

	while @@fetch_status = 0
	begin

		if isnull(@is_current_column,'') <> '' and isnull(@dml_operation_column,'') = ''
			 set @where_clause = 'where ' + @is_current_column + ' = 1 '

		if isnull(@is_current_column,'') <> '' and isnull(@dml_operation_column,'') <> ''
			 set @where_clause = 'where ' + @is_current_column + ' = 1 and ' + @dml_operation_column + '<>' + '''' + 'D' + ''''

		if isnull(@is_current_column,'') = '' and isnull(@dml_operation_column,'') <> ''
			 set @where_clause = 'where ' + @dml_operation_column + '<>' + '''' + 'D' + ''''

		if isnull(@business_id,'') <> '' and isnull(@company_id,'') = ''
		
			SET @SQL = 'select ' + '''' + @schemaname+ '''' + ',' + ''''+ @tablename + '''' + ',
			' + @business_id + ',null as company_id'  
			+ ' ,COUNT(*) AS duplicatecount, getdate() as Check_date
			from ' + @schemaname + '.' + @TableName + ' '
			+ @where_clause + '			
			group by ' + @business_id  + '
			having count(*) > 1 '

		if  isnull(@business_id,'') <> '' and isnull(@company_id,'') <> ''
		
			SET @SQL = 'select ' + '''' + @schemaname+ '''' + ',' + ''''+ @tablename + '''' + ',
			' + @business_id + ' as business_id,'  + @company_id + ' as company_id' 
			+ ' ,COUNT(*) AS duplicatecount, getdate() as Check_date
			from ' + @schemaname + '.' + @TableName + ' '
			+ @where_clause + ' 
			group by ' + @business_id + ',' + @company_id
			+ '	having count(*) > 1 '

		insert into #Duplicate_Results ([schema_name]
		,table_name
		,business_id
		,company_id
		,duplicate_count
		,check_date)

		exec sp_executesql @SQL

		print @SQL
		--EXEC sp_executesql @SQL

		fetch next
		from tablecursor
		into @schemaname
		,@tablename
		,@business_id
		,@company_id
		,@is_current_column
		,@dml_operation_column

	end

	close tablecursor
	deallocate tablecursor

	--insert into meta_data.duplicate_check ([schema_name],table_name,business_id,company_id,duplicate_count,check_date)
	--select [schema_name],table_name,business_id,company_id,duplicate_count,check_date from #Duplicate_Results

	select [schema_name],table_name,business_id,company_id,duplicate_count,check_date from #Duplicate_Results

end