Overview
--------

This Data Factory orchestrates the copying of data from the Production environment to the Test environment for Data Platform. It automates the transfer of files between Azure Data Lake Storage accounts and supports copying the Enterprise Data Warehouse (EDW) Azure SQL Database from production to test.

Architecture
------------

*   **Resource Group:** rg-test-aus-svc-datareporting
*   **Location:** Australia Southeast
*   **Integration Runtime:** Managed, 8 cores, General compute, used for all linked services and data flows.
*   **Linked Services:**
    *   **ls_ODS_PROD:** Connects to the production ADLS Gen2 storage account.
    *   **ls_ODS_TEST:** Connects to the test ADLS Gen2 storage account.
    *   **ls_ASQL_Datawarehouse:** Connects to the test Azure SQL Data Warehouse using managed identity.
    *   **ls_ASQL_Framework:** Connects to the production Azure SQL Database (Framework).

Pipelines
---------

### 1. Run Data Copy Pipelines

Orchestrates the overall data copy process. It conditionally triggers:
*   **ODS Data Copy** (files)
*   **EDW Database Copy**

### 2. 1_List Datasources

Looks up enabled data sources from the Framework database and iterates through each to trigger directory listing and file copy.

### 3. 2_List Directories

Lists folders in the source ADLS account for each data source, filters for folders, and triggers file copy for each.

### 4. 3_Copy Files

Checks if the target directory exists in the source. If it does:
*   Deletes the corresponding directory in the destination.
*   Copies files from source to destination, preserving hierarchy.
*   Logs copy activity to the test storage account.

### 5. Copy EDW Database

Automates copying the EDW database from production to test:
*   Drops the target test database if it exists.
*   Waits until the database is dropped.
*   Copies the production database to test.
*   Waits until the copy is online.
*   Scales the test database down to S1.
*   Cleans up Purview event sessions and credentials.
*   Drops and recreates users and roles as needed.

Datasets
--------

*   **ds_ADLS_ODS_Source:** Binary dataset for source ADLS Gen2 (production).
*   **ds_ADLS_ODS_Dest:** Binary dataset for destination ADLS Gen2 (test).
*   **ds_ASQL_Datawarehouse:** Azure SQL Table dataset for the data warehouse.
*   **ds_ASQL_Framework:** Azure SQL Table dataset for the Framework database.

Usage
-----

*   **File Copy:** The factory copies all folders and files from the production ADLS account to the test ADLS account, excluding certain data sources.
*   **Database Copy:** The factory can clone the EDW database from production to test, including user and role setup.
*   **Execution:** The main pipeline (`Run Data Copy Pipelines`) can be triggered manually or scheduled. Parameters allow selective execution of ODS data copy and/or EDW database copy.

Example Workflow
----------------

1.  Trigger `Run Data Copy Pipelines`.
2.  If ODS data copy is enabled, it lists all data sources and copies files for each.
3.  If EDW database copy is enabled, it clones the production database to test and configures users/roles.

Example
----
To copy just the ODS Data you can start the pipeline by the running the trigger, and changing the Copy_ODS_Data value to 1

![image.png](/.attachments/image-8b8e4af8-e62a-430e-ae65-27d69f3eca49.png)

To Copy just the EDW Production Data Warehouse you can start the pipeline by running the trigger and changing the Copy_EDW_Database value to 1

![image.png](/.attachments/image-2108793c-4ddd-4f87-8111-af0661236d36.png)

If you want to copy a specific ODS Dataset like, Akoranga or IntelliHR then in the trigger setting changed the Copy_ODS_Data to 1 and specific the Datasource name.  this must match what is stored in the Framework
You can ran this query to get a list of Datasources from the framework
```
SELECT [DataSourceName]

      ,[DataSourceDescription]

      ,[IsEnabled]

      ,[CreatedAt]

      ,[CreatedBy]

      ,[EffectiveFrom]

      ,[EffectiveTo]

  FROM [Metadata].[DataSource]

```

![image.png](/.attachments/image-5405a0cb-f16a-4426-916d-63dd898b53c1.png)


Notes
-----

*   All connections use managed identity for secure authentication.
*   Logging is enabled for copy activities.
*   The architecture supports parallel and batched operations for efficient data movement.