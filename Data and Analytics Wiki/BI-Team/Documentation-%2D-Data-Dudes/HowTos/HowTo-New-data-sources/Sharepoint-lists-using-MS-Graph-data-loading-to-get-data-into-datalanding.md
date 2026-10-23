To use ms graph you can explore the sharepoint lists by uisng the following explorer

[Graph Explorer | Try Microsoft Graph APIs - Microsoft Graph](https://developer.microsoft.com/en-us/graph/graph-explorer)

Go to the sharepoint list you want and modify it like this to get the site_id and list_id


https://emergeaotearoaltd.sharepoint.com/sites/PRJ_OutcomesWorkstream/Lists/

convert it to:

https://graph.microsoft.com/v1.0/sites/emergeaotearoaltd.sharepoint.com:/sites/PRJ_OutcomesWorkstream:/Lists

or a list of the columns

https://graph.microsoft.com/v1.0/sites/emergeaotearoaltd.sharepoint.com:/sites/OrganisationalPerformance:/Lists/e40f82b0-4664-4b93-b9c2-5ed737e450ad/columns

## NOTE: Ensure you add the ":" after sharepoint and after the site name e.g. sharepoint.com:

example: 

"https://graph.microsoft.com/v1.0/sites/emergeaotearoaltd.sharepoint.com:/sites/PRJ_OutcomesWorkstream:/Lists"


![image.png](/.attachments/image-b3c53ebf-3a1a-4da9-8408-66de3425691e.png)



Site_id is here

![image.png](/.attachments/image-2649d1cd-6876-41fa-aac5-a6176592724f.png)


List Id is here

![image.png](/.attachments/image-2adbf8bb-c879-409d-a126-ad0a6506a11b.png)
