###Introduction

This wiki is a brief guide when you find recordbase data has not been updated

###Context
Context1: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
Context2: SQL server management studio (eal-sql01.database.windows.net )
<br/>


<details>
<summary><b>01 Check the ODS pipelines ran OK <br/>
</summary>

![image.png](/.attachments/image-6dddd3b9-a743-4a7b-a59c-6f2038702f83.png)

</details>
<br/>


<details>
<summary><b>02 Check the EDW pipelines ran OK <br/>
</summary>

</details>
<br/>

<details>
<summary><b>03 Open the recordbase database <br/>
</summary>

![image.png](/.attachments/image-3acbff9a-6120-4f46-8716-0187c0ec989d.png)

</details>
<br/>


<details>
<summary><b>04 Check recordbase extracts took place <br/>
</summary>

Check the extract 


```sql

SELECT [ID]
      ,[ExtractIsIncremental]
      ,[ExtractDate]
      ,[ExtractStartTime]
      ,[StageEndTime]
      ,[LoadEndTime]
      ,[TransformEndTime]
  FROM [extract].[ExtractHistory]

  order by [ExtractDate] desc, [ExtractStartTime] 

```

</details>
<br/>


