
###Introduction
Framework discovery and deployment process for existing pipelines (kpi_snapshot_kaimahi, kpi_snapshot_service, kpi_snapshot_property, kpi_snapshot_referral)

###Context
Context1:Synapse Analytics Integration (note this will require your admin account) :[Synapse Analytics Integration](https://web.azuresynapse.net/en/home?workspace=%2Fsubscriptions%2F3ad070fe-7936-4060-a09c-338ac9352378%2FresourceGroups%2Frg-dev-aus-svc-datareporting%2Fproviders%2FMicrosoft.Synapse%2Fworkspaces%2Fsynapseausdev)
Context2: SQL server management studio (sql-dev-aus-svc-fk-01.database.windows.net )
<br/>
<details>

<summary><b>
01) Run the metadata discovery pipeline before you run this script generator (01_Metadata Discovery from ODS) for the relevant table filter i.e. kpi_snapshot_kaimahi
</b></summary>
<br/>

![image.png](/.attachments/image-6947333c-4384-4660-a676-e4722ab884d0.png)

</details>
<br/>


<details>
<summary><b>
02) Open SQL server in the relevant framework (Dev, Test or Prod). 
</b></summary>
<br/> <br/>

</details>
<br/>

<details>
<summary><b>
03) Enter the current dataloadid into the following query and generate the stored procedures to update the framework dataload. 
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



NOTE: if you find the above query does not return any results then check there is a record in biml.dataloaddetail. If not and you have run the metadata discovery then try to reload the dataloaddetail with this stored procedure: 

``` SQL
exec [BIML].[UpdateLoadFieldsDetail] @pDataLoadId = ?
```
</details>
<br/>


<details>
<summary><b>
04) or run the following script and then run the ODS pipeline create database objects 
</b></summary>
<br/> 

[Drop objects in ODS - Overview](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/218/Drop-objects-in-ODS)

![image.png](/.attachments/image-ebfaaf6c-22e6-4370-89ec-cf93455d3382.png)

</details>
<br/>