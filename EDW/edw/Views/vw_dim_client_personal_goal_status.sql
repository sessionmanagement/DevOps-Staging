
CREATE VIEW [edw].[vw_dim_client_personal_goal_status]
AS
SELECT dim_client_personal_goal_status_key
	,company_id
	,dim_client_personal_goal_status_unique_key
	,personal_goal_status_type_id
	,personal_goal_status_type_value
	,personal_goal_status_type_text
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHModifiedOn
	,DWHCreatedAt
FROM [edw].[dim_client_personal_goal_status]