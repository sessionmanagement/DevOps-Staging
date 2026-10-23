###Introduction
This document is the procedure to use once the Dataload has been set up in the Dev environment and you wish to move the dataload to Test and then production.

###Context
Context1: SQL server management studio framework DB (sql-dev-aus-svc-fk-01.database.windows.net) 
Context2: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse%20Data%20Platform
<br/>

<details>
<summary><b>01) Get the DataloadID from Framework database in the source (usually dev framework DB).</b></summary>
<br/>
- Open sql-dev-aus-svc-fk-01.database.windows.net in SQL server management studio.<br/>
- Open the Framework Database.<br/>

``` SQL

EXEC	[BIML].[DeleteDataObjectLoad]
		@pSourceDataSource = NULL,
		@pSourceDataObject = N'etl.fact_client_relationship',
		@pSourceDataObjectType = NULL,
		@pTargetDataSource = NULL,
		@pTargetDataObject = N'edw.fact_client_relationship',
		@pDataLoadId = 738,
		@pDeleteUserDefinedQuery = NULL



```
     
</details>
<br/>



GO