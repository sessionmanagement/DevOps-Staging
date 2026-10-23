This template outlines the key tasks involved in setting up an EDW with Azure Synapse Analytics

EDW Development Tasks Template

<details>
<summary><b>
01 - Create Source view in the source DB
</summary>
It’s expected that the main source will be the ODS, in this instance the view would be created on the 'etl' schema in the ODS DB. 
Note: to be efficient it’s important to get this source query right from the start, any schema changes to this query will result in a large amount of rework down the track. 
</details>
<br/>

<details>
<summary><b>
02 - Metadata scan of source view: 
</summary>

The metadata scan step populates the Framework DB with metadata from the source query. 

Open the synapse workspace and locate the '01_Metadata Discovery from ODS' pipeline 

Trigger the pipeline and update the TableFilter variable with the name of the new source query: 
A screenshot of a computer
</details>
<br/>

<details>
<summary><b>
03 Here is a description of what is automatically generated 
</summary>
At the end of the Metadata Scan, the following tables should be populated with the metadata from the new source view: 

``` SQL
Select * from Metadata.DataObject 
Select * from Metadata.DataObjectField 
Select * from Metadata.DataObjectKey 
Select * from Metadata.DataObjectKeyField 
```

</details>
<br/>

 
<details>
<summary><b>
04 - Configure framework load: 
</summary>
Once the metadata has been populated in the Framework we can configure the load against the new feed. 
The following configurations will enable the Framework to generate the initial tables and stored procedures required to load the new feed as well as provide the metadata used to drive the load process through the Synapse data pipelines. 

``` SQL
EXEC	[BIML].[ConfigureDataObjectLoad] 
			@pSourceDataSource = 'ODS',
			@pSourceDataObject = 'etl.your_view_name',
			@pTargetDataSource = 'EDW',
			@pTargetDataObject = 'edw.your_view_name',
			@pLoadPhase = '200 Facts' or '201 Facts' or '101 Dimensions' or '102 Dimensions' or '103 Dimensions',
			@pIsSourceSchemaRetained = 0,
			@pIsSourceDataSourceRetained = 1,
			@pPattern = 'ODS',
			@pLoadType = 'ODSFLLMRGIRV' or 'ODSINCHWTMRG'
```

 </details>
<br/>

<details>
<summary><b>
05 - What has been created
</summary>
<br/>
This procedure creates the core load records, the most important consideration when running this procedure is what load type you require, the two load types currently being used in the EDW are: 

- 'ODSINCHWTMRG' -- ODS: Incremental by highwater row-versioned merged 
- 'ODSFLLMRGIRV' -- ODS: Full row-versioned merged 

A full list of available load types can be found in the [BIML].[DataLoadType] table in the Framework DB, but it’s suggested that you do not deviate from the two load types listed above unless you have a specific reason to do so. 

 </details>
<br/> 

<details>
<summary><b>
06 - Configure the dataload keys
</summary>
<br/>

``` SQL
EXEC	[BIML].[ConfigureDataLoadKeys] 
			@pSourceDataSource = 'ODS',
			@pSourceDataObject = 'etl.your_view_name',
			@pTargetDataSource = 'EDW',
			@pKeyName = 'your_view_name',
			@pIsNatural = 1,
			@pIsBusiness = 1,
			@pKeyFieldMapping = 'uniquekey=uniquekey'  
```

This procedure configures the fields used to uniquely identify a record in the source query, these fields are used to: 

Generate the initial merge query used in the update stored procedure. 

Create the unique index on the landing table to enable the automated removal of rows with duplicate key values. 

NOTE: if the column names used in this configuration do not match exactly the field names in the source query then the update stored procedure will not be generated in step 4. 

  </details>
<br/> 

<details>
<summary><b>
07 Configure the dataload
</summary>
<br/>
[BIML].[ConfigureDataLoadIncremental] 
This procedure is used to identify the source filed that is used as the high water mark for the incremental load process. 

  </details>
<br/> 

<details>
<summary><b>
08 Results of the dataload configuration
</summary>
<br/>
Note: the results of running the three stored procedures can be found in these Framework tables: 

``` SQL
Select * from [BIML].[DataLoad] where DataloadID = ?
Select * from [BIML].[DataLoadField]  where DataloadID = ?
Select * from [BIML].[DataLoadIncremental]  where DataloadID = ?
Select * from [BIML].[DataLoadKeyFields]  where DataloadID = ?
```
 
  </details>
<br/> 
 

 
<details>
<summary><b>
09 Create EDW tables/stored procedures for the load configured in the previous step: 
</summary>
<br/>


Open the synapse workspace and locate the ‘'02_Create Database Objects EDW' pipeline. 

Trigger the pipeline and update the DataLoadID variable with the ID of the newly configured load, the DataLoadID can be obtained from the [BIML].[DataLoad] table: 


Description automatically generated 
  </details>
<br/> 
 

 
<details>
<summary><b>
10 After running the Create Database Objects pipeline, the following items should have been generated in the EDW: 
</summary>
<br/>
 
- Landing table - landing.edw_....
- Unique index on the landing table
- Staging table - staging.ODSETL....
- Master table - edw.....
- Staging stored procedure - staging.insert_staging....
- Update master stored procedure - edw.Updateedw....
- edw view of the master table edw.vw_.....

</details>
<br/>
 
 
<details>
<summary><b>
11 Update stored procedures/ and staging/master tables where required. 
</summary>
<br/>


The generated tables and stored procedures are just the default starting point for the EDW load, you will need to update these items to align with the business requirements.  

  </details>
<br/>

Use the following devops feature / user stories to track and document the development 

#8489