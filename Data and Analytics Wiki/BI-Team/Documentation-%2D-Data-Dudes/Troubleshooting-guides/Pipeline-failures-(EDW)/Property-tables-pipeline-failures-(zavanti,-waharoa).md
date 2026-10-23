###Introduction

Occasionally the EDW pipelines updating property dims or facts may not load due to a reading error when it uses the ETL view

###Context
Context1: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
Context2: SQL server management studio (synapseausprod-ondemand.sql.azuresynapse.net ) 
                             database: [dataverse_production_unq4700e6c14e7940f8b4bd16591871c]
Context3: SQL server management studio (eal-sql01.database.windows.net )
<br/>


<details>
<summary><b>01 It usually means the underlying table is being updated in the dataverse environment <br/>
</summary>


</details>
<br/>


<details>
<summary><b>02 You might have got the following error from the pipeline failure <br/>
</summary>

'Cannot bulk load because the file "https://stprodaussvcwaharoa01.dfs.core.windows.net/dataverse-production-unq4700e6c14e7940f8b4bd16591871c/opportunity/2024.csv" is incomplete or could not be read. Operating system error code 12(The access code is invalid.).

</details>
<br/>


<details>
<summary><b>03 You can check the underlying table to see if there have been any updates while the pipeline was running <br/>
</summary>

Log on to the synapseausprod-ondemand.sql.azuresynapse.net server and starting a new query in 
[dataverse_production_unq4700e6c14e7940f8b4bd16591871c]

``` SQL

SELECT [Id]
      ,[SinkCreatedOn]
      ,[SinkModifiedOn]
      ,[modifiedby]
      ,[modifiedby_entitytype]
      ,[modifiedonbehalfby]
      ,[modifiedonbehalfby_entitytype]
      
  FROM [dbo].[opportunity]

 where sinkmodifiedOn >= dateAdd(hour,-2,getdate())

```

</details>
<br/>


<details>
<summary><b>04 Solution is to just re-run the pipeline, hopefully when the underlying tables are not being updated <br/>
</summary>

 1) re-run the failed pipeline
 2) re-run the dependant semantic models and data sets


</details>
<br/>











