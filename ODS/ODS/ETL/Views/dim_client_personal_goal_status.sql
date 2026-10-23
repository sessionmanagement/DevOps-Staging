





CREATE VIEW [ETL].[dim_client_personal_goal_status]
AS
SELECT 1 AS company_key
	,[GoalStatusTypeID] AS personal_goal_status_type_id
	,[GoalStatusTypeValue] AS personal_goal_status_type_value
	,[GoalStatusTypeText] AS personal_goal_status_type_text
FROM [RBEAL].[dlDimGoalStatusType]

UNION

SELECT DISTINCT 5 AS company_key
	,[GoalStatusTypeID] AS personal_goal_status_type_id
	,[GoalStatusTypeValue] AS personal_goal_status_type_value
	,[GoalStatusTypeText] AS personal_goal_status_type_text
FROM [RBMNB].[dlDimGoalStatusType]
