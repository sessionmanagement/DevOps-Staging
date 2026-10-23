###Introduction
After you have developed the additions or changes to the ODS dev database this is how you move it to test.

###Context
Context1: SQL server management studio ODS database (synapseausdev-ondemand.sql.azuresynapse.net)
Context2: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
<br/>

<details>
<summary><b>01 Do your changes in the ODS Dev database </b> adding a created/modified line to the SQL code description<br/>
</summary>

![image.png](/.attachments/image-db2d0da2-37c4-4085-a5ef-fdc8a51c7fb4.png)
</details>
<br/>
<details>
<summary><b>02 Create a new branch</b> with the user story name and description as the title in the synapse data platform devops for EDW. <br/>
</summary>

![image.png](/.attachments/image-725462c8-8461-4c7c-945e-ff7d35417951.png)

</details>
<br/>
<details>
<summary><b>03 Open visual studio,</b> open your ODS database project (if you do not have one you can clone a version of main How to link here).<br/></summary>

![image.png](/.attachments/image-ad73da0b-0cc1-4acf-b89a-4c6214135cfa.png)

</details>
<br/>
<details>
<summary><b>04 Select the new branch and do a database compare</b> with the dev datawarehouse database. 
</summary>

</details>
<br/>
<details>
<summary><b>05 Select the tables, views and stored procedures</b> you have developed. An update the branch with your changes. Make sure you remove the security changes.<br/>
</summary>

![image.png](/.attachments/image-fcf4ef67-2df0-45b3-97b2-c58bb032b72f.png)
</details>
<br/>
<details>
<summary><b>06 Commit All and push</b> the changes to the branch in Devops. Fill in the comments with the user story number and name
</summary>

![image.png](/.attachments/image-8db3c93a-76e5-4cfd-b3f8-d7f745b9a787.png)
</details>
<br/>
<details>
<summary><b>07 Open the branch in devops</b> ODS and create a pull request from the branch to main, ask for code review and pull request from a colleague so they can approve it.
</summary>

![image.png](/.attachments/image-f3e3887c-6232-4b34-bd1e-d9e71d7f5287.png)

</details>
<br/>
<details>
<summary><b>08 Wait for the pipeline to finish and then create a pull request</b> from main to test. It should pick up your changes but check it does not pick up changes from other branches.</summary>

![image.png](/.attachments/image-41e940f1-ae50-4129-9b6c-636063bb84c5.png)

</details>
<br/>
<details>
<summary><b>09 Self approve</b> this when the pipeline is build to enable the pipeline deploy (to test).</summary>
Once it has finished it should look like this

![image.png](/.attachments/image-81896044-0532-4911-842a-db438501fe07.png)

</details>
<br/>

[Refer to the full document here ](https://emergeaotearoaltd.sharepoint.com/:w:/r/sites/DRCollaboration/_layouts/15/Doc.aspx?sourcedoc=%7BE13562DD-66F9-4040-9475-D9E60851CE2E%7D&file=ODS_EDW_SQL_Server_Deployment_Process.docx&action=default&mobileredirect=true)

NOTE: When deploying Zavanti views you will need to change the openrowset location from dev to test and production

![image.png](/.attachments/image-2cc248ae-eac2-4542-95e1-075f47d36839.png)





