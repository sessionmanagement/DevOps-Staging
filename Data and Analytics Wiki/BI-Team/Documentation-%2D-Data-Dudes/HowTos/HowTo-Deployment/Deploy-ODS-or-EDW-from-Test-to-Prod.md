###Introduction
Once you have pushed your changes to test and tested the results then this is how you move it to production.

###Context
Context: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform

<br/>
<details>
<summary><b>01 Select the devops area ODS or EDW and Create a new pull request <br/>
</summary>

![image.png](/.attachments/image-f9fd853e-9659-42cc-af9c-914707c2c36a.png)

</details>
<br/>



<details>
<summary><b>02 Fill out the details of the pull request <br/>
</summary>

![image.png](/.attachments/image-ee92d661-9833-4405-a3ce-4c1be055c787.png)

</details>
<br/>

<details>
<summary><b>03 Make sure the files are the files / changes you expect <br/>
</summary>

![image.png](/.attachments/image-4ed926e7-5f51-42f7-ba1d-9294e789c9c0.png)

</details>
<br/>


<details>
<summary><b>04 Click create <br/>
</summary>
</details>
<br/>

<details>
<summary><b>05 Wait for the build to complete  <br/>
</summary>

![image.png](/.attachments/image-ebf934a9-bf13-48ce-aab7-88a4d5391499.png)

</details>
<br/>

<details>
<summary><b>06 If you are deploying new ODS tables make sure the directories are set up  <br/>
</summary>

![image.png](/.attachments/image-2d3c1fbd-4799-4cba-a425-3aabaabd0e79.png)

</details>
<br/>


Get @<546F55A8-D69B-6281-90D0-D7BCF50677CA> or @<9DA15D0A-1A80-68D4-858C-4AD8B5C0218F>  to approve and the final deployment will occur.

<details>
<summary><b>07 Wait for the deploy to complete  <br/>
</summary>

![image.png](/.attachments/image-e5edbae2-8c2e-4007-8e96-c7d8631cd953.png)

</details>
<br/>


<summary><b>08 Things to watch out for  <br/>
</summary>

- You cannot reduce the data size of any column - the EDW deploy will fail, do this in a Pre-dacpac query
- You cannot re-name a column - the EDW deploy will fail, do this in a Pre-dacpac query
- Removing columns the EDW deploy will fail, do this in a Pre-dacpac query
- Need to make sure there is no key field defined as NVARCHAR(Max) the EDW deploy will fail
- BIT datatype not supported by Synapse so need to cast/convert to INT
- Make sure your merge keys are unique, otherwise the pipeline will fail on day 2

<br/>

[Look here for things to look out for when deploying to production](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/37/EDW-deployment-things-to-consider)
