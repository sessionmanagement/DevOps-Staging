###Introduction
After you have developed the additions or changes to the EDW dev database this is how you move it to test. Do the following steps

###Context
Context1: SQL server management studio EDW database (sql-dev-aue-svc-datawarehouse-01.database.windows.net)
Context2: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
<br/>

<details>
<summary><b>01 Create a new branch</b> with the user story name and description as the title in the synapse data platform devops for EDW. <br/>
</summary>

![image.png](/.attachments/image-9ab11fc4-17a8-4f3f-b67f-75d3e5f767e8.png)

</details>
<br/>
<details>
<summary><b>02 Open visual studio,</b> open your EDW database project (if you do not have one you can clone a version of main How to link here).<br/></summary>

![image.png](/.attachments/image-ad73da0b-0cc1-4acf-b89a-4c6214135cfa.png)
</details>
<br/>
<details>
<summary><b>03 Select the new branch and do a database compare. NOTE You can limit the types of database objects by selecting them. When changing an index on the landing table make sure you select index's and unique keys in they types of database objects to compare.</b> with the dev datawarehouse database.
</summary>

</details>
<br/>
<details>
<summary><b>04 Select the tables, views and stored procedures</b> you have developed. An update the branch with your changes. Make sure you remove the security changes.<br/>
</summary>

![image.png](/.attachments/image-fcf4ef67-2df0-45b3-97b2-c58bb032b72f.png)
</details>
<br/>
<details>
<summary><b>05 Commit All and push</b> the changes to the branch in Devops.
</summary>
</details>
<br/>
<details>
<summary><b>06 Open the branch in devops</b> EDW and create a pull request from the branch to main, ask for code review and pull request from a colleague so they can approve it.</summary>
</details>
<br/>
<details>
<summary><b>07 Wait for the pipeline to finish and then create a pull request</b> from main to test. It should pick up your changes but check it does not pick up changes from other branches.</summary>
</details>
<br/>
<details>
<summary><b>08 Self approve</b> this when the pipeline is build to enable the pipeline deploy (to test).</summary>
</details>
<br/>


[Refer to the full document here](https://emergeaotearoaltd.sharepoint.com/:w:/r/sites/DRCollaboration/Shared%20Documents/General/Deployment%20Process/Emerge%20Aotearoa%20-%20SOP%20-%20Data%20Platform%20Deployment.docx?d=w24789cea6e644966a82ad5bb8b350b14&csf=1&web=1&e=GszZb1)





