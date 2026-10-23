
1) Create a branch in the dev datafactory

![image.png](/.attachments/image-e516473c-2908-451b-8b1f-d437f6c28f20.png)

2) Do your changes to the branch

3) Create a pull request in datafactory to push the changes to main

4) In Devops datalanding Pipelines Run the ADF Data Landing Deployment (to main)

![image.png](/.attachments/image-73da0e75-2c16-4012-bd0f-227383ff4b92.png)

5) From the Azure devops data landing pipeline releases section create a new release, deselect production (or not for a production) release

![image.png](/.attachments/image-b089b159-4cfa-4275-a402-5f5ecb68b934.png)

6) Run the release

It should now appear in test / production data factory

 
