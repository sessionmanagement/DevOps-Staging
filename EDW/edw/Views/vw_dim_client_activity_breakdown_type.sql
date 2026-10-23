
CREATE VIEW [edw].[vw_dim_client_activity_breakdown_type]
AS
SELECT dim_client_activity_breakdown_type_key
	,client_activity_breakdown_type_id
	,dim_client_activity_breakdown_type_unique_key
	,company_id
	,team_configuration_name
	,client_activity_breakdown_type_code
	,client_activity_breakdown_type_name
	,client_parent_activity_breakdown_type
	,client_parent_activity_breakdown_type_name
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHModifiedOn
	,DWHCreatedAt
FROM [edw].[dim_client_activity_breakdown_type]