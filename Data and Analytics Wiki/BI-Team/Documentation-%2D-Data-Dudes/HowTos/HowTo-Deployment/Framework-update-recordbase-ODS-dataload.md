<details>
<summary><b>
01 - Meta data discovery for the new dataset
</summary>

Open synapse analytics for development and open the metadata discovery for RBEAL (or RBMNB) pipeline.
Add trigger with only name of the table you are getting. Make sure you only enter the table name when running the Metadata Discovery for RBEAL or Metadata Discovery for RBMNB

Example -  
**ContainerFilter** = dl (Schema name in source system)  
**TableFilter** = FactActivity (Table name)


![image.png](/.attachments/image-6bdde5c7-f299-4d60-9f24-61b5e281ff1c.png)

</details>
<br/>

<details>
<summary><b>
02) Enter the current dataloadid into the following query and generate the stored procedures to update the framework dataload. 
</b></summary>

``` SQL

Declare @DataLoadID as int = (Select DataLoadID from BIML.DataLoad where TargetTableName like '%table_name_here%')


	Select 
	SourceDataSource AS SourceName, 
	TargetDataSource AS TargetName, 
	SourceTableName AS TargetTableName, 
	'EXEC [BIML].[UpdateLoadFieldsFromSystemFields] 
	@pDataLoadId = '+ CAST(DataLoadId AS VARCHAR(10)) + ', 
	@pSourceDataSource = N''' + SourceDataSource +''', 
	@pSourceDataObject = N'''+SourceTableName + ''', 
	@pSourceDataObjectType = NULL, 
	@pTargetDataSource = N'''+TargetDataSource + ''', 
	@pTargetDataObject = NULL'  + CHAR(10) + CHAR(10) AS SQL_Rebuild_Load_Fields 
	,'EXEC	[BIML].[UpdateSourceQuery] 
	@pDataLoadId = ' + CAST(DataLoadId AS VARCHAR(10)) + ', 
	@pTargetSubSystem = N''ADF'', 
	@pOverwriteExisting = 1' AS  SQL_Recreate_Source_Query 

	FROM [BIML].[DataLoadDetail] 
	WHERE DataLoadId = @DataLoadID
	ORDER BY DataLoadId DESC 


```

</details>
<br/>


<details>
<summary><b>
03) Run the generated queries to generate the fields and then the source query
</b></summary>

``` SQL


EXEC [BIML].[UpdateLoadFieldsFromSystemFields]    @pDataLoadId = ???
	,    @pSourceDataSource = N'RBEAL'
	,    @pSourceDataObject = N'[dl].[FactPersonalPlan]'
	,    @pSourceDataObjectType = NULL
	,    @pTargetDataSource = N'ODS'
	,    @pTargetDataObject = NULL  


	EXEC [BIML].[UpdateSourceQuery]    
	@pDataLoadId = ???
	,    @pTargetSubSystem = N'ADF'
	,    @pOverwriteExisting = 1


```

</details>
<br/>

