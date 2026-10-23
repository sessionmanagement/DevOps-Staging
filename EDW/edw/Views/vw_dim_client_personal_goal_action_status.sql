
CREATE VIEW [edw].[vw_dim_client_personal_goal_action_status]
AS
SELECT dim_client_personal_goal_action_status_key
	,company_id
	,dim_client_personal_goal_action_status_unique_key
	,personal_goal_action_status_id
	,personal_goal_action_status_code
	,personal_goal_action_status_text
	,personal_goal_action_status_is_completed_status
	,personal_goal_action_status_is_cancelled_status
	,personal_goal_action_status_sort_index
	,DWHSourceSystem
	,DWHBatchId
	,DWHDMLOperation
	,DWHModifiedOn
	,DWHCreatedAt
FROM [edw].[dim_client_personal_goal_action_status]