








CREATE VIEW [ETL].[dim_client_personal_goal_action_status]
AS
SELECT 1 AS company_key
	,[GoalActionStatusID] AS personal_goal_action_status_id
	,[GoalActionStatusCode] AS personal_goal_action_status_code
	,[GoalActionStatusText] AS personal_goal_action_status_text
	,CAST([GoalActionStatusIsCompletedStatus] AS bit) AS personal_goal_action_status_is_completed_status
	,CAST([GoalActionStatusIsCancelledStatus] AS bit)  AS personal_goal_action_status_is_cancelled_status
	,[GoalActionStatusSortIndex] AS personal_goal_action_status_sort_index
FROM [RBEAL].[dlDimGoalActionStatus]

UNION

SELECT DISTINCT 5 AS company_key
	,[GoalActionStatusID] AS personal_goal_action_status_id
	,[GoalActionStatusCode] AS personal_goal_action_status_code
	,[GoalActionStatusText] AS personal_goal_action_status_text
	,CAST([GoalActionStatusIsCompletedStatus] AS bit)  AS personal_goal_action_status_is_completed_status
	,CAST([GoalActionStatusIsCancelledStatus] AS bit)  AS personal_goal_action_status_is_cancelled_status
	,[GoalActionStatusSortIndex] AS personal_goal_action_status_sort_index
FROM [RBMNB].[dlDimGoalActionStatus]

