###Introduction

This wiki is a brief guide to predac pack queries used to do deployments that would otherwise cause a failure of the EDW deployment. There are instances where scripts are required to be run before the dacpac changes are deployed. In order to get around this issue, a custom process has been created in the deployment pipeline YAML script, this custom step will run SQL scripts before the dacpac deployment is kicked off (before step 1 is even run). 

###Context
Context1: SQL server management studio (sql-dev-aus-svc-fk-01.database.windows.net )
Context2: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
<br/>

<details>
<summary><b>01 Get a copy of the target DB schema <br/>
</summary>
<br/>
</details>
<br/>

<details>
<summary><b>02 Compare the target schema to the DB solution  <br/>
</summary>
<br/>

![image.png](/.attachments/image-58ba8736-eec6-4773-aeaf-72b797522eba.png)

</details>
<br/>

<details>
<summary><b>03 Create update scripts based on any differences found   <br/>
</summary>
<br/>

![image.png](/.attachments/image-30fff03a-bba6-4691-9fe3-e0a5551426ef.png)

</details>
<br/>

<details>
<summary><b>04 Run the pre-deployment script   <br/>
</summary>
<br/>

![image.png](/.attachments/image-fe888d82-e0a1-41a5-b214-fb09e21e2828.png)

</details>
<br/>


<details>
<summary><b>05 Run deployment scripts created in step 3. <br/>
</summary>
<br/>
 
 
In order to trigger these pre-dacpac deployment scripts, they need to be placed in the ‘Predacpac_deployment_scripts’ root folder on the EDW solution. 
Once placed inside that root folder, the YAML script will locate each SQL file and loop through them one at a time. 

NOTE: these scripts should be wrapped in a check to ensure that the change is not already implemented; for example, if the script is going to drop a column, it should first check that the column still exists: 

``` SQL
IF EXISTS ( SELECT 1 
FROM sys.columns 
WHERE Name = N'client_physical_health_condition_flag' 
AND Object_ID = Object_ID(N'edw.dim_client') 
) 
BEGIN 
ALTER TABLE edw.dim_client 
DROP COLUMN client_physical_health_condition_flag; 
END 
``` 

Including this check will help avoid problems if the deployment process needs to be run multiple times. 
Continuing with the drop column example, if the column is dropped via the script on the original run, it would fail on the second run if the SQL did not include a check to execute only if the column still exists

</details>
<br/>

<details>
<summary><b>06 Commit the changes to the branch and push them back to git hub <br/>
</summary>
<br/>

</details>
<br/>

<details>
<summary><b>07 Continue the deployment process as per normal EDW deployments <br/>
</summary>
<br/>

</details>
<br/>


<details>
<summary><b>08 
After the deployment you must remove the predac pac deployment script
 make sure you move them to archive folder and set the build property to None <br/>

</summary>

![image.png](/.attachments/image-364b7db7-6b8c-4de5-a9c5-6d68df121c1b.png)

</details>
<br/>


This approach allows the SQL scripts to be included in the DB solution and thus included in the peer review step required as part of the merge into the ‘main’ branch. When you have finished and the scripts are one off scripts be sure to move them into the archive folder.



