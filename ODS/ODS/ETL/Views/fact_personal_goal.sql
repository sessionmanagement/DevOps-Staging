
CREATE VIEW [ETL].[fact_personal_goal]
AS
SELECT 1 AS company_key
	,FG.[GoalID] AS personal_goal_id
	,FGA.[GoalActionID] AS personal_goal_action_id
	,FG.[ReferralID] AS referral_id
	,FG.[PersonID] AS client_id
	,FGAOU.[EntityID] AS user_id
	,DU.UserEmployeeNumber AS user_employee_number
	,FG.[PersonalPlanID] AS personal_plan_id
	,FG.[OldGoalID] AS old_personal_goal_id
	,FPP.[PersonalPlanTitle] AS personal_plan_goal
	,FG.[GoalTitle] AS personal_goal_title
	,FGLS.GoalLookupStatusId AS personal_goal_status_id
	,FGA.[GoalActionDescription] AS personal_goal_action_description
	,FGA.[GoalActionStatusID] AS personal_goal_action_status_id
	,FG.[GoalCreatedDate] AS personal_goal_created_date
	,FPP.[PersonalPlanStartDate] AS personal_plan_start_date
	,FPP.[PersonalPlanEndDate] AS personal_plan_end_date
	,FG.[GoalStartDate] AS personal_goal_start_date
	,FG.[GoalDueDate] AS personal_goal_due_date
	,FGA.[GoalActionDueDate] AS personal_goal_action_due_date
	,FGA.[GoalActionCompletedDate] AS personal_goal_action_completed_date
	,FG.[GoalCloseCompletedDate] AS personal_goal_close_completed_date
	,FG.[GoalCloseNotCompletedDate] AS personal_goal_close_not_completed_date
	,Coalesce(FG.[GoalCloseNotCompletedDate], FG.[GoalCloseCompletedDate]) AS personal_goal_close_date
	,CASE 
		WHEN fg.GoalCloseCompletedDate IS NOT NULL
			THEN 1
		ELSE 0
		END AS personal_goal_completed_status
FROM [RBEAL].[dlFactGoal] FG
LEFT JOIN rbeal.dlFactGoalAction FGA ON FG.GoalID = fga.GoalID
LEFT JOIN (
	SELECT TOP 1 [EntityID]
		,GoalActionID
		,GoalActionOwnerEntityType
	FROM RBEAL.dlFactGoalActionOwner
	WHERE GoalActionOwnerEntityType = 'User'
	ORDER BY [GoalActionOwnerCreatedDate] DESC
	) AS FGAOU ON FGA.GoalActionID = FGAOU.GoalActionID
LEFT JOIN RBEAL.dlDimUser DU ON FGAOU.EntityID = DU.UserID
	AND FGAOU.GoalActionOwnerEntityType = 'User'
LEFT JOIN RBEAL.dlFactPersonalPlan FPP ON FG.PersonalPlanID = FPP.PersonalPlanID
LEFT JOIN (
	SELECT TOP 1 GoalLookupStatusId
		,GoalId
	FROM RBEAL.dlFactGoalLookupStatus
	ORDER BY GoalLookupStatusStartDate DESC
		,GoalLookupStatusCreatedDate DESC
	) AS FGLS ON FG.GoalID = FGLS.GoalId

UNION

SELECT 5 AS company_key
	,FG.[GoalID] AS personal_goal_id
	,FGA.[GoalActionID] AS personal_goal_action_id
	,FG.[ReferralID] AS referral_id
	,FG.[PersonID] AS client_id
	,FGAOU.[EntityID] AS user_id
	,DU.UserEmployeeNumber AS user_employee_number
	,FG.[PersonalPlanID] AS personal_plan_id
	,FG.[OldGoalID] AS old_personal_goal_id
	,FPP.[PersonalPlanTitle] AS personal_plan_goal
	,FG.[GoalTitle] AS personal_goal_title
	,FGLS.GoalLookupStatusId AS personal_goal_status_id
	,FGA.[GoalActionDescription] AS personal_goal_action_description
	,FGA.[GoalActionStatusID] AS personal_goal_action_status_id
	,FG.[GoalCreatedDate] AS personal_goal_created_date
	,FPP.[PersonalPlanStartDate] AS personal_plan_start_date
	,FPP.[PersonalPlanEndDate] AS personal_plan_end_date
	,FG.[GoalStartDate] AS personal_goal_start_date
	,FG.[GoalDueDate] AS personal_goal_due_date
	,FGA.[GoalActionDueDate] AS personal_goal_action_due_date
	,FGA.[GoalActionCompletedDate] AS personal_goal_action_completed_date
	,FG.[GoalCloseCompletedDate] AS personal_goal_close_completed_date
	,FG.[GoalCloseNotCompletedDate] AS personal_goal_close_not_completed_date
	,Coalesce(FG.[GoalCloseNotCompletedDate], FG.[GoalCloseCompletedDate]) AS personal_goal_close_date
	,CASE 
		WHEN fg.GoalCloseCompletedDate IS NOT NULL
			THEN 1
		ELSE 0
		END AS personal_goal_completed_status
FROM [RBMNB].[dlFactGoal] FG
LEFT JOIN RBMNB.dlFactGoalAction FGA ON FG.GoalID = fga.GoalID
LEFT JOIN (
	SELECT TOP 1 [EntityID]
		,GoalActionID
		,GoalActionOwnerEntityType
	FROM RBMNB.dlFactGoalActionOwner
	WHERE GoalActionOwnerEntityType = 'User'
	ORDER BY [GoalActionOwnerCreatedDate] DESC
	) AS FGAOU ON FGA.GoalActionID = FGAOU.GoalActionID
LEFT JOIN RBMNB.dlDimUser DU ON FGAOU.EntityID = DU.UserID
	AND FGAOU.GoalActionOwnerEntityType = 'User'
LEFT JOIN RBMNB.dlFactPersonalPlan FPP ON FG.PersonalPlanID = FPP.PersonalPlanID
LEFT JOIN (
	SELECT TOP 1 GoalLookupStatusId
		,GoalId
	FROM RBMNB.dlFactGoalLookupStatus
	ORDER BY GoalLookupStatusStartDate DESC
		,GoalLookupStatusCreatedDate DESC
	) AS FGLS ON FG.GoalID = FGLS.GoalId

