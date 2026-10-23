Before and after you re-run the pipelines you should check for duplicates in the framework logoverview table


Run in the production framework the following to check the data load row counts and see if they are all as expected


`select *
from etl.LogOverview
where LastUpdateDate >= (current date - 5)
and SourceSystem = 'datapay'
order by TableName, LastUpdateDate desc`


You can see in this example when some duplication occurred after the pipeline was run manually twice on the 29th June 2026 UTC time

![Image](https://dev.azure.com/EmergeAotearoa/65252fa2-b0e0-4546-9010-874c07feb574/_apis/wit/attachments/0be80d18-4692-4d66-9710-266deb3bab2e?fileName=image.png)


You can see here when the pipeline was run twice manually and this is how the duplicates occurred

![Image](https://dev.azure.com/EmergeAotearoa/65252fa2-b0e0-4546-9010-874c07feb574/_apis/wit/attachments/4872bb35-4ba1-4a1a-a5db-a4f8acdadc36?fileName=image.png)