This document details the database design standards for the datawarehouse EDW

### Overview

This page outlines the naming conventions for our Kimball-style data warehouse. Adhering to these guidelines ensures consistency, clarity, and ease of use across our data warehouse environment.


<details>
<summary><b>
01 - General Principles
</b></summary>

- Use descriptive, business-oriented names that are meaningful to users
- Maintain consistency across the entire data warehouse
- Avoid abbreviations and acronyms unless widely understood
- Use singular forms rather than plural (e.g., "user" not "users")
- Separate words with underscores
- Avoid spaces and special characters in object names

</details>
<br/>


<details>
<summary><b>
02 - Table Naming
</b></summary>

| Rule | Example |
|------|---------|
| Prefix fact tables with "fact_" | fact_client_referral |
| Prefix dimension tables with "dim_" | dim_client |
| Use singular nouns for table names | dim_client (not dim_clients) |
| Use lower case for table names | dim_client (not dim_Clients) |


</details>
<br/>

<details>
<summary><b>
03 - Column Naming
</b></summary>


- Use descriptive names that clearly indicate the content
- Avoid verbose and overly descriptive names
- Use "dim_<Name>_key for primary keys in dimension tables
- Use "dim_<Name>_key for foreign keys in fact tables that match the primary key in the dim table
- Use "id" for business keys in dimension tables
- Use "id" for business keys in fact tables
- Use the _flag suffix for binary yes / no fields
- Avoid redundant use of the table name where it does not add to the description

Examples:
- dim_service_key (in dim_service)
- dim_service_key (in fact_client_referral)
- service_id (in dim_service)
- service_id (in fact_client_referral)

</details>
<br/>


<details>
<summary><b>
04 - Standard Columns Naming Conventions
</b></summary>
<br/>


SCD2 tables

| Name of column | Column reason | Example |
|-------------|--------|---------|
|  DWHBatchId|The ID of the dataload batch|114570|
|  DWHSourceSystem|Where the data came from|[edw].[dim_employee]|
|  DWHDMLOperation|DML operation indicator|U|
|  DWHEffectiveFrom|The effective date of the record |2023-12-21 18:16:15.310|
|  DWHEffectiveTo|The expiry date of the record  |2999-12-31 23:59:59.000|
|  DWHIsCurrent|If the record is the current version (used with business keys)|1|



SCD1 or fact tables

| Name of column | Column reason | Example |
|-------------|--------|---------|
|  DWHSourceSystem|Where the data came from|[edw].[dim_employee]|
|  DWHBatchId|The ID of the dataload batch|114570|
|  DWHDMLOperation|DML operation indicator|U|
|  DWHModifiedOn|When the record was loaded into the database |2023-12-21 18:16:15.310|
|  DWHCreatedAt|When the record was created in the source system |2023-12-21 18:16:15.310|
 

</details>
<br/>


<details>
<summary><b>
05 - Naming Specific Objects
</b></summary>

| Object Type | Prefix | Example |
|-------------|--------|---------|
| Views | vw_ | vw_customer_sales |
| Stored procedures | insert_ or update_ or get_ | updatedwdim_service |
</details>
<br/>

<details>
<summary><b>
06 - Avoiding Conflicts
</b></summary>

- Do not use SQL reserved keywords as identifiers
- If a reserved word must be used, append an underscore (e.g., count_)
</details>
<br/>

<details>
<summary><b>
07 - Date time fields
</b></summary>

- All dates should be NZ time and converted from UTC time
--This should be between the EDW landing and the EDW staging tables

</details>
<br/>

<details>
<summary><b>
08 - Consistency
</b></summary>

- Maintain consistent naming across all BI tools and semantic layers
- Use the same name for the same concept across all tables and reports
  e.g. do not use user_employee_number but use employee_id because it 
  is used elsewhere in the database as employee_id

</details>
<br/>

<details>
<summary><b>
09 - Best Practices
</b></summary>

- Use this wiki!
- Document and share these conventions with all team members
- Regularly review and update naming conventions as needed
- Conduct periodic audits to ensure compliance with naming standards
</details>
<br/>

<details>
<summary><b>
10 - Related Links
</b></summary>

- [Building a Data Warehouse — Naming Conventions | by Guilherme Banhudo | Medium](https://gbanhudo.medium.com/data-lakehouse-warehouse-naming-conventions-d5adef6fbbe2)

</details>
<br/>

**Note**: This document should be reviewed and updated regularly to ensure it remains relevant and aligned with our data warehouse strategy.
