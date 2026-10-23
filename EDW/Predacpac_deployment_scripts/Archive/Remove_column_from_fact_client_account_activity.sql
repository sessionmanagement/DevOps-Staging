
/*
 Pre-Deployment Script Template							
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.	
 Use SQLCMD syntax to include a file in the pre-deployment script.			
 Example:      :r .\myfile.sql								
 Use SQLCMD syntax to reference a variable in the pre-deployment script.		
 Example:      :setvar TableName MyTable							
               SELECT * FROM [$(TableName)]					
--------------------------------------------------------------------------------------
 Purpose: Remove client_account_id column from fact_client_account_activity tables
          across all three data flow layers (edw, landing, staging)
--------------------------------------------------------------------------------------
*/

-- edw.fact_client_account_activity
IF EXISTS(SELECT * FROM sys.columns 
          WHERE name='client_account_id' 
          AND object_id = OBJECT_ID('edw.fact_client_account_activity'))
ALTER TABLE edw.fact_client_account_activity DROP COLUMN client_account_id
GO

-- landing.edw_fact_client_account_activity
IF EXISTS(SELECT * FROM sys.columns 
          WHERE name='client_account_id' 
          AND object_id = OBJECT_ID('landing.edw_fact_client_account_activity'))
ALTER TABLE landing.edw_fact_client_account_activity DROP COLUMN client_account_id
GO

-- staging.ODSETLfact_client_account_activity
IF EXISTS(SELECT * FROM sys.columns 
          WHERE name='client_account_id' 
          AND object_id = OBJECT_ID('staging.ODSETLfact_client_account_activity'))
ALTER TABLE staging.ODSETLfact_client_account_activity DROP COLUMN client_account_id
GO