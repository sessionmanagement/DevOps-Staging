###Introduction
After you have developed the additions or changes to the synapse pipeline this is how you move it to test.

###Context
Context: [Azure Synapse Studio in the Dev environment (note this will require your admin account)  (from synapseausdev)](https://web.azuresynapse.net/en/home?workspace=%2Fsubscriptions%2F3ad070fe-7936-4060-a09c-338ac9352378%2FresourceGroups%2Frg-dev-aus-svc-datareporting%2Fproviders%2FMicrosoft.Synapse%2Fworkspaces%2Fsynapseausdev)
<br/>

<details>
<summary><b>01 Open the Synapse dev environment and create a new branch from main <br/>
</summary>
<br/>
When starting a new piece of work you need to create a new branch base off main.  There should be no development done on the main branch. The name of the branch should be “9999_Description_of_Branch” where 9999 is the number of the user story. Do your changes in synapse pipeline make sure you commit the changes when finished 

![image.png](/.attachments/image-a2fb6ab2-c7f4-4b4a-8234-c78e42e396f4.png)

![image.png](/.attachments/image-e08e46ec-71d4-44b9-a748-b7393da55cde.png)

</details>
<br/>


<details>
<summary><b>02 Trigger the change in debug mode or trigger mode to check the process runs OK. <br/>
</summary>
<br/>
 
![image.png](/.attachments/image-59161d14-16e9-4ee9-a881-ab51e4c67ba0.png)

![image.png](/.attachments/image-f3d199af-305a-44e9-bed4-85fb9763db9b.png)

</details>

  
<details>
<summary><b>03 When you have successfully tested you pipeline modifications you can push your changes back to the main branch by doing a “pull request”  <br/>
</summary>
<br/>
 
Once you have completed the work you then need to raise a pull request so that it can be merge back into main branch

</details>
<br/>




<details>
<summary><b>04 Deploy your changes back to the main branch.    <br/>
</summary>
<br/>
 

Once you have completed the work you then need to raise a pull request so that it can be merge back into main branch  

When raising a pull request, it will go through the following requirements.  

- The pipeline must be able to build successful.  
- Peer review must be completed.   
- Pull request must be linked to Work Item in Devops Board  

Once the pull request has been completed then the work will be merged into the main branch this will trigger a deployment to dev environment for the ODS and deployment to Test environment for ODS and EDW  


</details>
<br/>

 

Once the work has been tested and ready for deployment to production it needs to be added to the list of items to be released.

  

  

  