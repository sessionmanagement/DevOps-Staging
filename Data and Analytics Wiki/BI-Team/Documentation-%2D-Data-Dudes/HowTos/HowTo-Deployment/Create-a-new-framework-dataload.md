

###Introduction
Framework discovery and deployment process for new pipelines.

###Context
Context1:Synapse Analytics Integration (note this will require your admin account) :[Synapse Analytics Integration](https://web.azuresynapse.net/en/home?workspace=%2Fsubscriptions%2F3ad070fe-7936-4060-a09c-338ac9352378%2FresourceGroups%2Frg-dev-aus-svc-datareporting%2Fproviders%2FMicrosoft.Synapse%2Fworkspaces%2Fsynapseausdev)
Context2: SQL server management studio (sql-dev-aus-svc-fk-01.database.windows.net )
<br/>

<details>
<summary><b>
00) Create New Data source for Metadata discovery
</b></summary>
<br/>

``` SQL
--  Here is a example script which you need to execute inside Framework Database. 
--  this script will be used to create DataSource row inside Framework table which later will be useful in metadata synapse pipeline to execute [Metadata].[GetMetadataQueries] 

USE [Framework]
GO

DECLARE @RC int
DECLARE @pDataSource nvarchar(120)
DECLARE @pDataSourcePrefix nvarchar(5)
DECLARE @pDataSourceType nvarchar(250)
DECLARE @pDescription nvarchar(1000)
DECLARE @pDataSourceDefaultSchemaName nvarchar(250)
DECLARE @pDataSourceTemporarySchemaName nvarchar(250)
DECLARE @pDataSourceDefaultExecuteRole nvarchar(120)
DECLARE @pIsTargetCompressed bit
DECLARE @pIsEnabled bit
DECLARE @pDataSourceId int

-- TODO: Set parameter values here.
SET @pDataSource = 'WebExpenses'
SET @pDataSourcePrefix = 'WBEX'
SET @pDataSourceDefaultSchemaName = 'webexpenses'
SET @pDataSourceType = 'Synapse Serverless'
SET @pDescription = 'Data Source: Expenses API'

EXECUTE @RC = [Metadata].[CreateDataSource] 
   @pDataSource
  ,@pDataSourcePrefix
  ,@pDataSourceType
  ,@pDescription
  ,@pDataSourceDefaultSchemaName
  ,@pDataSourceTemporarySchemaName
  ,@pDataSourceDefaultExecuteRole
  ,@pIsTargetCompressed
  ,@pIsEnabled
  ,@pDataSourceId OUTPUT
GO


EXECUTE  Metadata.CreateDataSource 
    @pDataSource = 'WebExpenses'
  , @pDataSourcePrefix = 'WBEX'
  , @pDataSourceType = 'Synapse Serverless' 
  , @pDescription='Data Source: Expenses API'
  , @pDataSourceDefaultSchemaName='webexpenses'
  , @pDataSourceTemporarySchemaName='staging'
  , @pIsEnabled=1
```

</details>

<details>
<summary><b>
01) Run the metadata discovery pipeline before you run this script generator (01_Metadata Discovery from ODS) for the relevant table filter i.e. fact_client_referral
</b></summary>
<br/>

![image.png](/.attachments/image-7643df38-4a6d-4494-8fdd-7b8c5fa7a5c6.png)

</details>
<br/>

<details>
<summary><b>
02) Enter the table name into the pipeline trigger (Without the schema i.e. 'Fact_Client_Referral') 
</b></summary>
<br/>

</details>
<br/>

<details>
<summary><b>
03) Open SQL server in the relevant framework (Dev, Test or Prod). 
</b></summary>
<br/> <br/>

</details>
<br/>

<details>
<summary><b>
04) Open the framework file in the framework database. 
</b></summary>
<br/> <br/>

![image.png](/.attachments/image-28adea0e-a945-44dc-8608-49d98104bff4.png)

</details>
<br/>

<details>
<summary><b>
05) Change all the View_Table_Name_Here to the name of your table. 
</b></summary>

``` SQL

--You need to run the metadata discovery pipeline before you run this script generator (01_Metadata Discovery from ODS)
--Enter the table name into the pipeline trigger (Without the schema i.e. 'Fact_Client_Referral')
--Make sure you change all the fact_client_person_relationship to the name of your table

--

EXEC	[BIML].[ConfigureDataObjectLoad] 
			@pSourceDataSource = 'ODS',  --See DataSourceDetail
			@pSourceDataObject = 'etl.fact_client_activity_breakdown',
			@pTargetDataSource = 'EDW',
			@pTargetDataObject = 'edw.fact_client_activity_breakdown',
			@pLoadPhase = '200 Facts',  --select * from biml.DataLoadPhase 
			@pIsSourceSchemaRetained = 0,
			@pIsSourceDataSourceRetained = 1,
			@pPattern = 'ODS',
			@pLoadType = 'ODSFLLINS_SVL'  --ODSFLLMRGIRV -- select * from biml.DataLoadType

-- configure merge key
EXEC	[BIML].[ConfigureDataLoadKeys] 
			@pSourceDataSource = 'ODS',
			@pSourceDataObject = 'etl.fact_client_activity_breakdown',
			@pTargetDataSource = 'EDW',
			@pKeyName = 'fact_client_activity_breakdown',
			@pIsNatural = 1,
			@pIsBusiness = 1,
			@pKeyFieldMapping = 'client_referral_id=client_referral_id;client_id=client_id;client_responsible_user_id=client_responsible_user_id;client_person_relationship_start_date=client_person_relationship_start_date;client_person_relationship_end_date=client_person_relationship_end_date'    

-- update default target table name
UPDATE u
	SET [TargetTableName] = 'edw.fact_client_activity_breakdown'
FROM [BIML].[DataLoad] u
	WHERE TargetTableName = 'ODS.fact_client_activity_breakdown'
	


or for a source table

EXEC	[BIML].[ConfigureDataObjectLoad] 
			@pSourceDataSource = 'RBEAL',  --See DataSourceDetail
			@pSourceDataObject = 'dl.DimRole',
			@pTargetDataSource = 'ODS',
			@pTargetDataObject = 'RBEAL.dlDimRole',
			@pLoadPhase = 'N/A',  --DataLoadPhase 
			@pIsSourceSchemaRetained = 0,
			@pIsSourceDataSourceRetained = 1,
			@pPattern = 'ODS',    --See DataLoadType
			@pLoadType = 'ODSFLLINS_SVL'

-- configure merge key
EXEC	[BIML].[ConfigureDataLoadKeys] 
			@pSourceDataSource = 'RBEAL',
			@pSourceDataObject = 'dl.DimRole',
			@pTargetDataSource = 'ODS',
			@pKeyName = 'RoleID',
			@pIsNatural = 1,
			@pIsBusiness = 1,
			@pKeyFieldMapping = 'RoleID=RoleID'    


```

</details>
<br/>

<details>
<summary><b>
06) Run the procedures, they will generate some scripts to update the framework data with the changes to the framework tables.  
</b></summary>


 
``` SQL

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
WHERE DataLoadId = ?  
ORDER BY DataLoadId DESC 

```
</details>
<br/>


<details>
<summary><b>
07) Helper query for multiple dataload id 
</b></summary>



``` SQL

-- ============================================================
-- HELPER QUERY — run on source framework DB to find DataloadIDs:
-- ============================================================
/****************************

SELECT DataloadID, TargetTableName
FROM   biml.DataLoad
ORDER BY Dataloadid DESC

****************************/
-- ============================================================

-- ============================================================
-- CONFIGURATION — update this value before running
-- ============================================================
DECLARE @DataloadIDs NVARCHAR(MAX) = '794,795,796,797';   -- <-- REPLACE with your DataloadIDs

-- ============================================================
-- Internal setup — do not change below this line
-- ============================================================
DECLARE @IDs TABLE (RowNum INT IDENTITY(1,1), DataloadID INT);
DECLARE @MaxRow  INT;
DECLARE @Row     INT = 1;
DECLARE @id      INT;
DECLARE @line    NVARCHAR(500);

INSERT INTO @IDs (DataloadID)
SELECT CAST(TRIM(value) AS INT)
FROM   STRING_SPLIT(@DataloadIDs, ',')
WHERE  TRIM(value) <> '';

SET @MaxRow = @@ROWCOUNT;

IF @MaxRow = 0
BEGIN
    PRINT 'ERROR: No DataloadIDs were provided. Please set @DataloadIDs and re-run.';
    RETURN;
END;

-- [A] SOURCE SCRIPT


PRINT '';

PRINT '-- [A] SOURCE SCRIPT';
PRINT '--     Run on SOURCE/DEV framework DB';
PRINT '--     Step 2: Enable config migration';
PRINT '-- ===============================================================================================';
PRINT '';

SET @Row = 1;
WHILE @Row <= @MaxRow
BEGIN
    SELECT @id = DataloadID FROM @IDs WHERE RowNum = @Row;
    SET @line = 'Update biml.DataLoad Set EnableConfigMigration = 1 where DataloadID = '
                + CAST(@id AS NVARCHAR(10)) + ';';
    PRINT @line;
    SET @Row += 1;
END;
PRINT '';
PRINT '-- ===============================================================================================';


-- [B] TARGET SCRIPT

PRINT '-- [B] TARGET SCRIPT';

PRINT '-- ===============================================================================================';
PRINT '';

SET @Row = 1;
WHILE @Row <= @MaxRow
BEGIN
    SELECT @id = DataloadID FROM @IDs WHERE RowNum = @Row;
    SET @line = 'Update Deploy.DataLoadMigration_Master Set ADMIN_ConfirmedToMerge = 1 where DataloadID = '
                + CAST(@id AS NVARCHAR(10)) + ';';
    PRINT @line;
    SET @Row += 1;
END;
PRINT 'GO';
PRINT '';
PRINT 'Exec deploy.MergeFrameworkConfigs';
PRINT 'GO';
PRINT '';
PRINT '-- ===============================================================================================';


-- [C] CLEANUP SCRIPT [SOURCE_SYSTEM]

PRINT '-- [C] CLEANUP SCRIPT';
PRINT '-- ===============================================================================================';
PRINT '';

SET @Row = 1;
WHILE @Row <= @MaxRow
BEGIN
    SELECT @id = DataloadID FROM @IDs WHERE RowNum = @Row;
    SET @line = 'Update biml.DataLoad Set EnableConfigMigration = 0 where DataloadID = '
                + CAST(@id AS NVARCHAR(10)) + ';';
    PRINT @line;
    SET @Row += 1;
END;

PRINT '';
PRINT '';
PRINT '-- ===============================================================================================';

PRINT '-- End of generated scripts';
 
 
```


</details>
<br/>