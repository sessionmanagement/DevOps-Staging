CREATE PROC [staging].[insert_staging_dim_powerbi_activity_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_powerbi_activity_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-25    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_powerbi_activity_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_powerbi_activity_type] (
	 [activity] 	,[activity_group] 	,[activity_description] 	,[activity_notes] 
	)
SELECT
	 [activity] 	,[activity_group] 	,[activity_description] 	,[activity_notes] 
from [Landing].[edw_dim_powerbi_activity_type]