###Introduction
This document is the procedure to use once the Dataload has been set up in the Dev environment and you wish to move the dataload to Test and then production.

###Context
Context1: SQL server management studio framework DB (sql-dev-aus-svc-fk-01.database.windows.net) 
Context2: Azure Devops Synapse Data Platform https://dev.azure.com/EmergeAotearoa/Synapse%20Data%20Platform
<br/>

<details>
<summary><b>01) Get the DataloadID from Framework database in the source (usually dev framework DB).</b></summary>
<br/>
- Open sql-dev-aus-svc-fk-01.database.windows.net in SQL server management studio.<br/>
- Open the Framework Database.<br/>

``` SQL
Select DataloadID from biml.dataload where targettablename like 'The name of your development 
  table';
```
     
</details>
<br/>
<details>


<summary><b>
02) Enable the config migration in the source framework
</b></summary>

<br/>Set EnableConfigMigration = 1<br/>
``` SQL
Update biml.DataLoad Set EnableConfigMigration = 1 where DataloadID = ?
```
</details>
<br/>

<details>
<summary><b>
03)  Run the configs migration pipeline
</b></summary>

![image.png](/.attachments/image-f2a47cc6-5976-475e-9bad-573d79ba2839.png)

</details>
<br/>

<details>
<summary><b>
04)  You can see the progress of the pipeline here
</b></summary>

![image.png](/.attachments/image-1f1c6b62-9996-483a-b575-f4e707650394.png)

</details>
<br/>


<details>
<summary><b>
05)  Set ADMIN_ConfirmedToMerge = 1 in the destination framework database
</b></summary>

<br/>Set ADMIN_ConfirmedToMerge = 1<br/>
``` SQL
Update Deploy.DataLoadMigration_Master Set ADMIN_ConfirmedToMerge = 1 where DataloadID = ?
```
</details>
<br/>
<details>


<summary><b>
06) Execute the merge stored procedure in the destination framework
</b></summary>

``` SQL
Exec deploy.MergeFrameworkConfigs
```

</details>
<br/>
<details>
<summary><b>
07) Tidy up, set the EnableConfigMigration = 0 on the source framework
</b></summary>

<br/>Set EnableConfigMigration = 0<br/>
``` SQL
Update biml.DataLoad Set EnableConfigMigration = 0 where DataloadID = ?
```
</details>
<br/>

<details>
<summary><b>
08) Here is a script for Multiple framework deployments 
</b></summary>

<br/>Set EnableConfigMigration = 0<br/>
``` SQL

-- ============================================================-- HELPER QUERY — run on source framework DB to find DataloadIDs:-- ============================================================/****************************SELECT DataloadID, TargetTableNameFROM   biml.DataLoadORDER BY Dataloadid DESC

****************************/-- ============================================================-- ============================================================
-- CONFIGURATION — update this value before running-- ============================================================
DECLARE @DataloadIDs NVARCHAR(MAX) = '794,795,796,797';   -- <-- REPLACE with your DataloadIDs-- ============================================================-- Internal setup — do not change below this line-- ============================================================
DECLARE @IDs TABLE (RowNum INT IDENTITY(1,1), DataloadID INT);
DECLARE @MaxRow  INT;
DECLARE @Row     INT = 1;
DECLARE @id      INT;
DECLARE @line    NVARCHAR(500);

INSERT INTO @IDs (DataloadID)SELECT CAST(TRIM(value) AS INT)
FROM   STRING_SPLIT(@DataloadIDs, ',')
WHERE  TRIM(value) <> '';

SET @MaxRow = @@ROWCOUNT;
IF @MaxRow = 0BEGIN    
PRINT 'ERROR: No DataloadIDs were provided. Please set @DataloadIDs and re-run.';
    RETURN;END;-- [A] SOURCE SCRIPTPRINT '';
PRINT '-- [A] SOURCE SCRIPT';PRINT '--     Run on SOURCE/DEV framework DB';PRINT '--     Step 2: Enable config migration';PRINT '-- ===============================================================================================';PRINT '';SET @Row = 1;WHILE @Row <= @MaxRowBEGIN    SELECT @id = DataloadID FROM @IDs WHERE RowNum = @Row;    SET @line = 'Update biml.DataLoad Set EnableConfigMigration = 1 where DataloadID = '                + CAST(@id AS NVARCHAR(10)) + ';';    PRINT @line;    SET @Row += 1;END;PRINT '';PRINT '-- ===============================================================================================';-- [B] TARGET SCRIPTPRINT '-- [B] TARGET SCRIPT';PRINT '-- ===============================================================================================';PRINT '';SET @Row = 1;WHILE @Row <= @MaxRowBEGIN    SELECT @id = DataloadID FROM @IDs WHERE RowNum = @Row;    SET @line = 'Update Deploy.DataLoadMigration_Master Set ADMIN_ConfirmedToMerge = 1 where DataloadID = '                + CAST(@id AS NVARCHAR(10)) + ';';    PRINT @line;    SET @Row += 1;END;PRINT 'GO';PRINT '';PRINT 'Exec deploy.MergeFrameworkConfigs';PRINT 'GO';PRINT '';PRINT '-- ===============================================================================================';-- [C] CLEANUP SCRIPT [SOURCE_SYSTEM]PRINT '-- [C] CLEANUP SCRIPT';PRINT '-- ===============================================================================================';PRINT '';SET @Row = 1;WHILE @Row <= @MaxRowBEGIN    SELECT @id = DataloadID FROM @IDs WHERE RowNum = @Row;    SET @line = 'Update biml.DataLoad Set EnableConfigMigration = 0 where DataloadID = '                + CAST(@id AS NVARCHAR(10)) + ';';    PRINT @line;    SET @Row += 1;END;PRINT '';PRINT '';PRINT '-- ===============================================================================================';PRINT '-- End of generated scripts'
```
</details>
<br/>

**Flow chart**

::: mermaid
graph TD

A[<font size=2>Get dataloadid from framework <br/>sql-dev-aus-svc-fk-01.database.windows.net] --> B(<font size=2>Set the EnableConfigMigration = 1: <br/> <font size=2>Update DataLoad Set EnableConfigMigration = 1 where DataloadID = ?) 
B -->|<font size=2>Check dataload is enabled| C{<font size=2>Run the configs migration}
C -->|<font size=2>Select Test| D[<font size=2>To promote from dev to test]
C -->|<font size=2>Select Main| E[<font size=2>For testing from dev to dev]
C -->|<font size=2>Select Production| F[<font size=2>To promote from test to production]
D -->|<font size=2>complete| G(<font size=2>Check the config has worked - look at the deploy tables to check)
E -->|<font size=2>complete| G
F -->|<font size=2>complete| G
G -->H(<font size=2>Set ADMIN_ConfirmedToMerge = 1 : <br/> Update Deploy.DataLoadMigration_Master Set ADMIN_ConfirmedToMerge = 1 where DataloadID = ? )
H -->I(<font size=2>Execute the merge stored procedure <br/>  exec deploy.MergeFrameworkConfigs)
I -->J(<font size=2>Clean up by setting the EnableConfigMigration = 0 <br/> Update DataLoad Set EnableConfigMigration = 1 where DataloadID = ?) 

style A stroke:#333,font-size:2pt
style B stroke:#333,font-size:2pt
style C stroke:#333,font-size:2pt
style D stroke:#333,font-size:2pt
style E stroke:#333,font-size:2pt
style F stroke:#333,font-size:2pt
style G stroke:#333,font-size:2pt
:::

