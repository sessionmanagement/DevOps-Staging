###Introduction
The following points to watch out for when doing the EDW deploy to production.

###Context
Context: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse Data Platform
<br/>


<b>01 - Need to make sure there is no key field defined as NVARCHAR(Max) this will fail ETL deployment

<b>02 - BIT datatype not supported by Synapse so need to cast/convert to INT

<b>03 - If you reduce the size of a column will fail ETL deployment. You will have to do this in a Pre-dacpac query.

<b>04 - Removing columns will fail ETL deployment. You will have to do this in a Pre-dacpac query.

<b>05 - You cannot re-name a column - the EDW deploy will fail, do this in a Pre-dacpac query

<b>06 -  Make sure your merge keys are unique, otherwise the pipeline will fail on day 2

See here for how to do a pre-dacpac query 

[Deploy pre dacpac queries](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/140/Deploy-pre-dacpac-queries)
