This template outlines the key tasks involved in setting up an ODS with Azure Synapse Analytics

ODS Development Tasks Template

<details>
<summary><b>
01 - Initial Framework Setup for New Source
</summary>
- Establish the foundational framework for integrating a new data source.<br/>
- Define standard protocols and procedures.
</details>
<br/>

<details>
<summary><b>02 - Discover Metadata
</summary>
- Identify and document the metadata associated with the new source.<br/>
- Analyze data types, relationships, and constraints.
</details>
<br/>

<details>
<summary><b>03 - Configure dataload pattern
</summary>
Configure the framework to handle data ingestion and processing.


Either build a new framework 

[New dataload](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/122/New-dataload)

or

[Update existing dataload](https://emergeaotearoaltd.sharepoint.com/:u:/r/sites/DRCollaboration/Shared%20Documents/General/BI-Engineering/Code%20Snippets/SQL/Update_Exisiting_Framework_SP.sql?csf=1&web=1&e=26dqdf)

</details>
<br/>

<details>
<summary><b>04 - Create ODS SQL Objects and Storage Accounts
</summary>
Set up Azure Synapse Analytics to manage data workflows.
Design and implement data pipelines for efficient data movement.
</details>
<br/>

<details>
<summary><b>05 - Configure ODS pipeline
</summary>
Create a dedicated workspace in Azure Synapse for the new data source.
Configure access controls and resource allocation.
</details>
<br/>

<details>
<summary><b>06 - Unit testing</b>
</summary>
Develop and execute unit tests to validate individual components.
Address any issues or bugs identified during testing.
</details>
<br/>

<details>
<summary><b>07 - Create trigger in main to schedule data load</b>
</summary>
Implement triggers to automate the data loading process.
Schedule and monitor data load operations.
</details>
<br/>

<details>
<summary><b>08 - Deploy to test</b>
</summary>
Deploy all necessary Synapse and framework objects to test.

[Deploy-ODS-from-dev-to-main](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/120/Deploy-ODS-from-dev-to-main)

</details>
<br/>

<details>
<summary><b>09 - Deploy to prod</b>
</summary>
Deploy all necessary Synapse and framework objects to production.

[Deploy-ODS-or-EDW-from-Test-to-Prod](https://dev.azure.com/EmergeAotearoa/Data%20and%20Analytics/_wiki/wikis/Data-and-Analytics.wiki/131/Deploy-ODS-or-EDW-from-Test-to-Prod)


</details>
<br/>

Use the following devops feature / user stories to track and document the development 

#8489