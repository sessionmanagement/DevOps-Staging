
###Introduction

This is a brief guide to restoring a SQL database in Microsoft Azure

###Context
Context1: Azure [Home - Microsoft Azure](https://portal.azure.com/?feature.msaljs=true#home) 
<br/>

<details>
<summary><b>01 Log on to Microsoft Azure <br/>
</summary>

![image.png](/.attachments/image-8d5adf78-197f-49fc-affc-fcc223d0b3f3.png)

<br/>
</details>
<br/>


<details>
<summary><b>02 Open SQL databases and select the database you want to restore from the list <br/>
</summary>

1) Production DWH = sqldb-prod-datawarehouse-01 (sql-prod-aus-svc-datawarehouse-01/sqldb-prod-datawarehouse-01)
2) Production Framework = Framework (sql-prod-aus-svc-fk-01/Framework)
3) Production Datalanding = sqldb-prod-entprod-01 (sql-prod-aue-svc-datalanding/sqldb-prod-entprod-01)
4) Production Recordbase EAL = Recordbase_EmergeAotearoa_Elite (eal-sql01/Recordbase_EmergeAotearoa_Elite)
5) Production Recordbase M&B Recordbase_MindAndBody_Elite (eal-sql01/Recordbase_MindAndBody_Elite)


<br/>
</details>
<br/>

<details>
<summary><b>03 Select restore at the top of the page <br/>
</summary>

![image.png](/.attachments/image-7a3952bc-7dd6-4a07-869f-00fff9859b01.png)
<br/>
</details>
<br/>


<details>
<summary><b>04 select a point in time (Back to the last viable database) <br/>
</summary>

![image.png](/.attachments/image-3ce25a95-2635-4fe8-97ab-f0f7a1bed4b4.png)

<br/>
</details>
<br/>


<details>
<summary><b>05 select the database name and configure the database configuration Compute speed etc <br/>
</summary>

![image.png](/.attachments/image-bb10e96e-107f-480e-802e-ea95b01e9849.png)
<br/>
</details>
<br/>


<details>
<summary><b>06 Click review and create and click create <br/>
</summary>

![image.png](/.attachments/image-095b7707-e29b-4c41-a7f3-78d2b8693889.png)
<br/>
</details>
<br/>








