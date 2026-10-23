
###Introduction
This is how to reload data from business central into data landing. The data can be loaded back to any day (It works by getting the latest record of any transaction) so it will not disrupt the ODS because the BC rest API will only return the latest version of any transaction. EntryNo and company will make up a unique value.

###Context
Context: [Microsoft Azure storage accounts in the Prod environment (note this will require your admin account)  (from synapseausdev)][Storage accounts - Microsoft Azure] (https://portal.azure.com/?feature.msaljs=true#browse/Microsoft.Storage%2FStorageAccounts)
<br/>

<details>
<summary><b>
01 Open the current folder load and take a backup by renaming todays folder
</summary>

Open microsoft azure storage accounts filter by prod / test / dev and find the stdprodaussvcdatalanding1 file location

Open the datalake storage

Navigate to business central / YYYY / MM / DD 

Rename the latest folder 

![image.png](/.attachments/image-22b1c351-932d-4d9a-853d-584f633d2e25.png)


</details>
<br/>


<details>
<summary><b>
02 Set the configuration timestamp to the historical date you want to run
</summary>

Open microsoft azure storage accounts filter by prod / test / dev and find the stdprodaussvcdatalanding1 file location

Open the datalake storage

Navigate to configuration / business central / timestamp.json file

Edit the date


![image.png](/.attachments/image-ed8b1c2e-6041-481c-ba97-19afea8437e4.png)

</details>
<br/>


<details>
<summary><b>
03 Open data factory in the environment you want to load and open the business central extract master
</summary>

Open data factory

Select the pencil icon

Open Business Central pipeline folder

select the business central extract master

![image.png](/.attachments/image-c5ef3bfd-2ac4-4f82-bf7d-2e302436b659.png)

</details>
<br/>


<details>
<summary><b>
04 Select trigger and enter any filters you want, click Ok to start the pipeline
</summary>

Click the trigger button

NOTE: This may slow business central down so you must warn the finance team 

![image.png](/.attachments/image-07d6f035-86fb-4dc8-abe3-e63df2b8135a.png)

</details>
<br/>

<details>
<summary><b>
05 Compare the data in the ODS and the datalanding with the following scripts
</summary>
<br/>

Example of ODS totals

``` SQL
select count(*)
,sum(isnull(amount,0))
,sum(abs(isnull(amount,0)))

from BusinessCentral.glEntries  g

where g.Company_Name = 'Emerge_Aotearoa_Limited'
and entryNo in (4652017,4652018,4652019,4652020,4652021,4652022,4652023,4652024)

```



Example of EDW totals

``` SQL
select count(*)
,sum(isnull(finance_general_ledger_amount,0))
,sum(abs(isnull(finance_general_ledger_amount,0)))

from edw.fact_finance_general_ledger g

where g.finance_general_ledger_company_name = 'Emerge Aotearoa Limited'
and fact_finance_general_ledger_row_key in (4652017,4652018,4652019,4652020,4652021,4652022,4652023,4652024)

```

</details>
<br/>






  
