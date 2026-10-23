###Introduction
If there are duplicate rows in invalid data in one of the ODS main parquet files then you can use the following process to remove or modify the data.

###Context
Context1: SQL server management studio ODS database (synapseausdev-ondemand.sql.azuresynapse.net)
Context2: Microsoft Azure storage explorer \Local\Programs\Microsoft Azure Storage Explorer\StorageExplorer.exe
<br/>

<details>
<summary><b>01 Take a copy of the current main parquet file using Microsoft Azure storage explorer</b> Select the directory and navigate to the synapse data storage, navigate to the file location of the folder you want to copy<br/>
</summary>

![image.png](/.attachments/image-2b97255f-bfc5-4af7-8195-e074911763c9.png)

</details>
<br/>
<details>


<summary><b>02 Create a new table using the create SQL</b> <br/>
</summary>

``` SQL
create external table [Datapay].[leave_balances_no_duplicates]  
with (location = 'Temp/leave_balances/no_duplicates' ,  
data_source = [data],  
file_format = [parquet] ) 
```
</details>

<br/>


<details>
<summary><b>03 Renamed the current main folder main_old in  \\ODS\{data source}\\{table name}\</b> <br/>
</summary>
 



</details>
<br/>
<details>
<summary><b>04 Copied the new duplicate free folder to [\\ODS\Datapay\leave_balances] </b> <br/>
</summary>
<br/>
Copied the new duplicate free folder to [\\ODS\{data source}\\{table name}]


</details>
<br/>

<details>
<summary><b>05 Rename the new folder to main </b> <br/>
</summary>
<br/>
Renamed the folder to main [\\ODS\{data source}\\{table name}\]


</details>



