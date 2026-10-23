
CREATE VIEW [edw].[vw_dim_client_team]
AS
SELECT d.dim_client_team_key
	,d.company_id
	,d.dim_service_Key
	,d.dim_client_team_unique_key
	,d.service_id
	,d.client_team_id
	,d.client_team_name
	,d.client_team_description
	,d.client_team_function
	,d.client_team_is_accommodation_based
	,d.dim_client_team_start_date
	,d.dim_client_team_end_date
	,d.client_team_bed_number
	,d.client_team_is_allocated_support
	,d.client_team_is_employment_team
	,d.client_team_status
	,d.client_team_area as dim_client_team_area
	,d.client_team_parent_area
	,d.client_team_grand_parent_area
	,d.DWHSourceSystem
	,d.DWHBatchId
	,d.DWHDMLOperation
	,d.DWHModifiedOn
	,d.DWHCreatedAt
	,d.client_team_primhd_exclusion_flag
FROM [edw].[dim_client_team] d