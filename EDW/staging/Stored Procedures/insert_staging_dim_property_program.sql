CREATE PROC [staging].[insert_staging_dim_property_program]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_property_program]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-12-12    ?				Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_property_program]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_property_program] (
	 [property_program_id] 	,[property_subprogram_id] 	,[property_program_name] 	,[property_program_owner_name] 	,[property_subprogram_name] 	,[property_subprogram_property_transaction_types] 	,[property_subprogram_state] 	,[property_subprogram_status] 	,[property_market_rent_ignore_flag] 	,[property_subprogram_owning_business_unit_name] 	,[property_subprogram_owning_team_name] 	,[property_subprogram_owning_user_name] 	,[property_subprogram_owner_name] 	,[property_subprogram_created_by_user_name] 	,[property_subprogram_modified_by_user_name] 	,[property_subprogram_modified_on_date] 	,[property_subprogram_version_number] 	,[property_subprogram_code] 	,[property_subprogram_deleted_flag] 	,[synapse_link_sink_modified_on] 
	)
SELECT
	 [property_program_id] 	,[property_subprogram_id] 	,[property_program_name] 	,[property_program_owner_name] 	,[property_subprogram_name] 	,[property_subprogram_property_transaction_types] 	,[property_subprogram_state] 	,[property_subprogram_status] 	,[property_market_rent_ignore_flag] 	,[property_subprogram_owning_business_unit_name] 	,[property_subprogram_owning_team_name] 	,[property_subprogram_owning_user_name] 	,[property_subprogram_owner_name] 	,[property_subprogram_created_by_user_name] 	,[property_subprogram_modified_by_user_name] 	,[property_subprogram_modified_on_date] 	,[property_subprogram_version_number] 	,[property_subprogram_code] 	,[property_subprogram_deleted_flag] 	,[synapse_link_sink_modified_on] 
from [Landing].[edw_dim_property_program]