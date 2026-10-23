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
*/

-- Rename property_tenant_primary_tenant_flag to property_tenant_head_of_household_flag
-- Work Item: #12555
-- Tables: edw.fact_property_tenant, staging.ODSETLfact_property_tenant, landing.edw_fact_property_tenant

-- edw
IF EXISTS (SELECT 1
           FROM sys.columns c
           INNER JOIN sys.tables t ON c.object_id = t.object_id
           INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
           WHERE s.name = 'edw'
             AND t.name = 'fact_property_tenant'
             AND c.name = 'property_tenant_primary_tenant_flag')
    EXEC sp_rename 'edw.fact_property_tenant.property_tenant_primary_tenant_flag',
                   'property_tenant_head_of_household_flag', 'COLUMN';
GO

-- staging
IF EXISTS (SELECT 1
           FROM sys.columns c
           INNER JOIN sys.tables t ON c.object_id = t.object_id
           INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
           WHERE s.name = 'staging'
             AND t.name = 'ODSETLfact_property_tenant'
             AND c.name = 'property_tenant_primary_tenant_flag')
    EXEC sp_rename 'staging.ODSETLfact_property_tenant.property_tenant_primary_tenant_flag',
                   'property_tenant_head_of_household_flag', 'COLUMN';
GO

-- landing
IF EXISTS (SELECT 1
           FROM sys.columns c
           INNER JOIN sys.tables t ON c.object_id = t.object_id
           INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
           WHERE s.name = 'landing'
             AND t.name = 'edw_fact_property_tenant'
             AND c.name = 'property_tenant_primary_tenant_flag')
    EXEC sp_rename 'landing.edw_fact_property_tenant.property_tenant_primary_tenant_flag',
                   'property_tenant_head_of_household_flag', 'COLUMN';
GO