CREATE PROC [staging].[insert_staging_dim_client_interaction_type]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_interaction_type]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-08-05    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_interaction_type]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_interaction_type] (
	 [company_key] 	,[client_interaction_type_id] 	,[client_interaction_type_code] 	,[client_interaction_type_name] 	,[client_parent_interaction_type_code] 	,[client_parent_interaction_type_name] 
	)
SELECT
	 [company_key] 	,[client_interaction_type_id] 	,[client_interaction_type_code] 	,[client_interaction_type_name] 	,[client_parent_interaction_type_code] 	,[client_parent_interaction_type_name] 
from [Landing].[edw_dim_client_interaction_type]
GO

