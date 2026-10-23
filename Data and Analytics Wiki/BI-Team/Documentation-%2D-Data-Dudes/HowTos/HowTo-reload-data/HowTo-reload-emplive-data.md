###Introduction
This is how to reload data from emplive into data landing. Sometimes there is a delay in creating the files and the pipelines will have to be re-run

###Context
Context: [Microsoft data factory] Prod adf-prod-aus-datalanding-01 environment (note this will require your admin account)
[adf-prod-aus-datalanding-01 - Azure Data Factory](https://adf.azure.com/en/home?factory=%2Fsubscriptions%2F77487d95-363d-446e-ab12-d17f50cba6ec%2FresourceGroups%2Frg-prod-aus-svc-datalanding%2Fproviders%2FMicrosoft.DataFactory%2Ffactories%2Fadf-prod-aus-datalanding-01)
<br/>

<details>
<summary><b>
01 Open Microsoft data factory (azure data factories page) --> adf-prod-aus-datalanding-01 then Launch Studio
</summary>

![image.png](/.attachments/image-c3085ada-8eb3-4989-aaf9-0e4771b743f0.png)

</details>

<br/>


<details>
<summary><b>
02 Open the pipeline tab and select the Emplive master pipeline, select trigger now to run the extract from Datapay
</summary>

Note: You should run all the tables to ensure the data is in sequence.



</details>

<br/>

<details>
<summary><b>
03 Select the monitor tab to watch the progress of the pipeline run
</summary>



</details>


<br/>