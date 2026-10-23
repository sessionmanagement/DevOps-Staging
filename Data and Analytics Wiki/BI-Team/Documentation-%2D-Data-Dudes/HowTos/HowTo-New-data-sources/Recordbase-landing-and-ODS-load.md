Get data from the remote recordbase SQL server



<details>
<summary><b>
01 - Find out the exact table name in the recordbase SQL server
</summary>
Open SQL server<br/>
Open eal-sql01.database.windows.net
Open the Recordbase_EmergeAotearoa_Elite or Recordbase_MindAndBody_Elite database
Find the table you want to import - Note down the name and the key field


![image.png](/.attachments/image-2c499b2d-c24a-4677-a62f-65967d21832a.png)

</details>
<br/>

<details>
<summary><b>
02 - Meta data discovery for the new dataset
</summary>

Open synapse analytics for development and open the metadata discovery for RBEAL (or RBMNB) pipeline.
Add trigger with the name of the table you are getting (gained from step 01) 

Example - 
**ContainerFilter** = dl (Schema name in source system)
**TableFilter** = FactActivity (Table name)


![image.png](/.attachments/image-6bdde5c7-f299-4d60-9f24-61b5e281ff1c.png)

</details>
<br/>

<details>
<summary><b>
03 - Run the framework procedures to generate the metadata in the framework tables
</summary>

Open the dev framework SQL server database
Modify the following scrips to generate the new dataload

``` SQL
EXECUTE [BIML].[Configuredataobjectload]
  @pSourceDataSource = 'RBEAL',
  @pSourceDataObject = 'dl.dimAccount',
  @pTargetDataSource = 'ODS',
  @pLoadPhase = 'N/A',    -- for SSIS only for dependencies
  @pIsSourceSchemaRetained = 1, -- 0 is without schema name included when TargetTable is created
  @pIsSourceDataSourceRetained = 1,
--  @pLoadType = 'ODSFLLMRG_SVL';    -- do NOT use - as it has not been configured by Theta yet: ODS: Full non-versioned merged
  @pLoadType = 'ODSFLLINS_SVL';    -- ODS: Full row-versioned merged


EXECUTE [BIML].[Configuredataloadkeys]
  @pSourceDataSource = 'RBEAL',
  @pSourceDataObject = 'dl.dimAccount',
  @pTargetDataSource = 'ODS',
  @pKeyName = 'PK_dl_dimAccount_RBEAL',  -- this should be unique in the target db - that is why we need to prefix with schema name table name etc
  @pIsNatural = 1,
  @pIsBusiness = 1,
  @pKeyFieldMapping = 'AccountID=AccountID'
```
     

![image.png](/.attachments/image-634fbf9b-3745-42a6-a5e3-c8a97d4e578b.png)


</details>
<br/>


<details>
<summary><b>
04 - Look in the framework biml.dataload table to get the new dataloadID

</summary>



</details>

<br/>

<details>
<summary><b>
05 - Run the create database objects with the new dataloadid 
</summary>



</details>
