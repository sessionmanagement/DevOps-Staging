
###Introduction

This wiki is a brief guide when you find recordbase data has not been updated

###Context
Context1: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
Context2: SQL server management studio (eal-sql01.database.windows.net )
<br/>


<details>
<summary><b>01 Problem found in one of the ODS pipelines Emplive API Load - single table where it failed with the following error: <br/>
</summary>

 Error Code=UserErrorFileNotFound,'Type=Microsoft.DataTransfer.Common.Shared.HybridDeliveryException,Message=ADLS Gen2 operation failed for: Operation returned an invalid status code 'NotFound'. Account: 'stprodaussvcsyn'. FileSystem: 'ods'. Path: 'EmpliveAPI/leave_requests/working'. ErrorCode: 'PathNotFound'. Message: 'The specified path does not exist.' 

</details>
<br/>


<details>
<summary><b>02 Defensive programming to solve it <br/>
</summary>


This was because there were duplicate rows from the datalanding and hence the working file could no longer be read.

The solution to get it up and running was to put some defensive SQL in the [EmpliveAPI].[leave_requests] table as follows

</details>
<br/>


<details>
<summary><b>03 Defensive code <br/>
</summary>

``` SQL

create external table [EmpliveAPI].[leave_requests]
   with (
    location = 'EmpliveAPI/leave_requests/main' ,
    data_source = [data],
    file_format = [parquet]
   ) as   

   WITH CTE AS (SELECT
    [leave_request_id], 
    [employee_id], 
    [start_date_time], 
    [end_date_time], 
    [default_leave_type], 
    [status], 
    [ODSSourceSystem], 
    [ODSBatchId], 
    [ODSDMLOperation], 
    [ODSEffectiveFrom], 
    [ODSEffectiveTo], 
    [ODSIsCurrent] ,
    ROW_NUMBER() OVER ( PARTITION BY  [leave_request_id],  [employee_id],  [start_date_time],  [end_date_time],  [default_leave_type],  [status],  [ODSSourceSystem],  [ODSBatchId],  [ODSDMLOperation],  [ODSEffectiveFrom],  [ODSEffectiveTo],  [ODSIsCurrent] order by ODSEffectiveFrom desc) as row_num
    from [working].[EmpliveAPI_leave_requests]
    )

   select 
   [leave_request_id], 
    [employee_id], 
    [start_date_time], 
    [end_date_time], 
    [default_leave_type], 
    [status], 
    [ODSSourceSystem], 
    [ODSBatchId], 
    [ODSDMLOperation], 
    [ODSEffectiveFrom], 
    [ODSEffectiveTo], 
    [ODSIsCurrent] 
   from CTE where row_num = 1
   order by start_date_time

```

</details>
<br/>
