
###Introduction

This wiki is a brief guide to predac pack queries used to do deployments that would otherwise cause a failure of the EDW deployment. Once you have deployed and run the pre-dacpac you will need to remove it.

###Context
Context1: SQL server management studio (sql-dev-aus-svc-fk-01.database.windows.net )
Context2: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
<br/>

<details>
<summary><b>01 Move the predac pac script to the archive folder <br/>
</summary>

![image.png](/.attachments/image-3c2cdec4-12e6-4f17-ae77-179117d2c04b.png)

<br/>
</details>
<br/>

<br/>

<details>
<summary><b>02 Set the build property on the script to None <br/>
</summary>

![image.png](/.attachments/image-fa789d82-0a23-41a0-b598-e1ddfc0d5a95.png)
<br/>
</details>


