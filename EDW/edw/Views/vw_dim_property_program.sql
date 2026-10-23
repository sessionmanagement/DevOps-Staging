


CREATE VIEW [edw].[vw_dim_property_program]
AS
SELECT dim_property_program_id
	,property_program_id
	,property_subprogram_id
	,property_program_name
	,property_program_owner_name
	,property_subprogram_name
	,property_subprogram_property_transaction_types
	,property_subprogram_state
	,property_subprogram_status
	,property_market_rent_ignore_flag
	,property_subprogram_owning_business_unit_name
	,property_subprogram_owning_team_name
	,property_subprogram_owning_user_name
	,property_subprogram_owner_name
	,property_subprogram_created_by_user_name
	,property_subprogram_modified_by_user_name
	,property_subprogram_modified_on_date
	,property_subprogram_version_number
	,property_subprogram_code
	,property_subprogram_deleted_flag
	,synapse_link_sink_modified_on
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
FROM [edw].[dim_property_program]