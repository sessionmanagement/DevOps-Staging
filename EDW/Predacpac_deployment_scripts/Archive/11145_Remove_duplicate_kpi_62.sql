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

PRINT 'Removing duplicate KPI view [edw].[kpi_property_62_property_status_is_occupied]...';

-- Check if the duplicate view exists and drop it
IF EXISTS (
    SELECT 1 
    FROM INFORMATION_SCHEMA.VIEWS 
    WHERE TABLE_SCHEMA = 'edw' 
      AND TABLE_NAME = 'kpi_property_62_property_status_is_occupied'
)
BEGIN
    PRINT 'Dropping duplicate view [edw].[kpi_property_62_property_status_is_occupied]';
    
    DROP VIEW [edw].[kpi_property_62_property_status_is_occupied];
    
    PRINT '? Successfully removed duplicate view [edw].[kpi_property_62_property_status_is_occupied]';
END
ELSE
BEGIN
    PRINT '? View [edw].[kpi_property_62_property_status_is_occupied] does not exist - no action required';
END

PRINT '';
PRINT '=============================================================================';
PRINT 'DUPLICATE VIEW REMOVAL COMPLETE';
PRINT 'Bug #11145: Resolved duplicate KPI views in EDW';
PRINT 'Next Steps:';
PRINT '1. Verify the correct view exists with proper naming convention';
PRINT '2. Update any dependent views or procedures if necessary';
PRINT '3. Test KPI reporting to ensure no functionality is broken';
PRINT '=============================================================================';