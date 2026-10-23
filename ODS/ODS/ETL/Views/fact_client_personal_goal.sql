CREATE VIEW [ETL].[fact_client_personal_goal]
AS

--Version 1.1

--20240506 Modified (GN) user a CTE_lookup to get the correct employee_number via email and name

WITH

	CTE_EMPLOYEE_LOOKUP_RBEAL
	AS (
			Select du.UserID
			, max(h2.employeeNumber) as employeeNumber
		
			from RBEAL.dlDimUser du
			left outer join [IntelliHR].[people] hp on cast(du.UserEmployeeNumber as nvarchar) = cast(hp.employeeNumber as nvarchar)
			left outer join [IntelliHR].[people] h2 on Upper(trim(du.UserFirstName)) = Upper(trim(h2.firstName)) 
												   and Upper(trim( du.UserLastName)) = Upper(trim(h2.lastName)) 
			where isnull(hp.people_id,'') = ''
			and isnull(du.UserEmailAddress,'') <> ''
			and h2.ODSIsCurrent = 1
			group by du.UserID),

	CTE_EMPLOYEE_LOOKUP_RBMNB
	AS (	
			Select du.UserID
			, max(h2.employeeNumber) as employeeNumber
		
			from RBMNB.dlDimUser du
			left outer join [IntelliHR].[people] hp on cast(du.UserEmployeeNumber as nvarchar) = cast(hp.employeeNumber as nvarchar)
			left outer join [IntelliHR].[people] h2 on Upper(trim(du.UserFirstName)) = Upper(trim(h2.firstName)) 
												   and Upper(trim( du.UserLastName)) = Upper(trim(h2.lastName)) 
			where isnull(hp.people_id,'') = ''
			and isnull(du.UserEmailAddress,'') <> ''
			and h2.ODSIsCurrent = 1
			group by du.UserID)


SELECT 
	1 AS company_key
	,FG.[GoalID] AS personal_goal_id
	,FG.[ReferralID] AS referral_id
	,FG.[PersonID] AS client_id
	,FG.[PersonalPlanID] AS personal_plan_id
	,FG.[OldGoalID] AS old_personal_goal_id
	,FG.[GoalTitle] AS personal_goal_title
	,FG.GoalCreatedUserId AS goal_created_user_id  
	,FG.[GoalCreatedDate] AS personal_goal_created_date
	,FG.[GoalStartDate] AS personal_goal_start_date
	,FG.[GoalDueDate] AS personal_goal_due_date
	,FG.[GoalCloseCompletedDate] AS personal_goal_close_completed_date
	,FG.[GoalCloseNotCompletedDate] AS personal_goal_close_not_completed_date
	,Coalesce(FG.[GoalCloseNotCompletedDate], FG.[GoalCloseCompletedDate]) AS personal_goal_close_date
	,CASE 
		WHEN fg.GoalCloseCompletedDate IS NOT NULL
			THEN 1
		ELSE 0
		END AS personal_goal_completed_status
	,FGA.GoalActionCreatedDate AS personal_goal_action_created_date
	,FGA.GoalActionCreatedUserID AS goal_action_created_user_id
	,FGA.[GoalActionDescription] AS personal_goal_action_description
	,FGA.[GoalActionStatusID] AS personal_goal_action_status_id
	,FGA.[GoalActionID] AS personal_goal_action_id
	,FGA.[GoalActionDueDate] AS personal_goal_action_due_date
	,FGA.[GoalActionCompletedDate] AS personal_goal_action_completed_date
	,FPP.[PersonalPlanTitle] AS personal_plan_goal
	,FPP.[PersonalPlanStartDate] AS personal_plan_start_date
	,FPP.[PersonalPlanEndDate] AS personal_plan_end_date
	,isnull(el.employeeNumber,DU.UserEmployeeNumber) AS user_employee_number
	,FGAOU.[EntityID] AS user_id
	--,FGLS.GoalLookupStatusId AS personal_goal_status_id
	,FGLS.StatusId AS personal_goal_status_id
	,FG.CategoryID AS personal_goal_category_id
	,dgc.GoalCategoryValue	AS personal_goal_category
	,dgc.GoalCategoryText AS personal_goal_category_description
FROM [RBEAL].[dlFactGoal] AS FG
LEFT JOIN rbeal.dlFactGoalAction AS FGA ON FG.GoalID = fga.GoalID
LEFT JOIN (
	SELECT goalactionid
		,entityid
	FROM (
		SELECT row_number() OVER (
				PARTITION BY goalactionid ORDER BY goalactionid
					,goalactionownercreateddate DESC
				) AS count_goalowners
			,goalactionid
			,entityid
		FROM RBEAL.dlFactGoalActionOwner
		WHERE GoalActionOwnerEntityType = 'User'
		) AS data1
	WHERE count_goalowners = 1
	) AS FGAOU ON FGA.GoalActionID = FGAOU.GoalActionID
left join CTE_EMPLOYEE_LOOKUP_RBEAL el on FGAOU.EntityID = el.UserID
LEFT JOIN RBEAL.dlDimUser AS DU ON FGAOU.EntityID = DU.UserID
--and FGAOU.GoalActionOwnerEntityType='User'
LEFT JOIN RBEAL.dlFactPersonalPlan AS FPP ON FG.PersonalPlanID = FPP.PersonalPlanID
LEFT JOIN RBEAL.dlFactGoalLookupStatus AS FGLS ON FG.GoalID = FGLS.GoalId
	AND FGLS.GoalLookupStatusId = (
		SELECT MAX(FGLS1.GoalLookupStatusId)
		FROM RBEAL.dlFactGoalLookupStatus FGLS1
		WHERE fgls1.GoalId = FGLS.GoalId
		)
LEFT JOIN [RBEAL].[dlDimGoalCategory] dgc ON FG.[CategoryID] = dgc.[GoalCategoryID]

UNION

SELECT 
	5 AS company_key
	,FG.[GoalID] AS personal_goal_id
	,FG.[ReferralID] AS referral_id
	,FG.[PersonID] AS client_id
	,FG.[PersonalPlanID] AS personal_plan_id
	,FG.[OldGoalID] AS old_personal_goal_id
	,FG.[GoalTitle] AS personal_goal_title
	,FG.GoalCreatedUserId AS goal_created_user_id  
	,FG.[GoalCreatedDate] AS personal_goal_created_date
	,FG.[GoalStartDate] AS personal_goal_start_date
	,FG.[GoalDueDate] AS personal_goal_due_date
	,FG.[GoalCloseCompletedDate] AS personal_goal_close_completed_date
	,FG.[GoalCloseNotCompletedDate] AS personal_goal_close_not_completed_date
	,Coalesce(FG.[GoalCloseNotCompletedDate], FG.[GoalCloseCompletedDate]) AS personal_goal_close_date
	,CASE 
		WHEN fg.GoalCloseCompletedDate IS NOT NULL
			THEN 1
		ELSE 0
		END AS personal_goal_completed_status
	,FGA.GoalActionCreatedDate AS personal_goal_action_created_date
	,FGA.GoalActionCreatedUserID AS goal_action_created_user_id
	,FGA.[GoalActionDescription] AS personal_goal_action_description
	,FGA.[GoalActionStatusID] AS personal_goal_action_status_id
	,FGA.[GoalActionID] AS personal_goal_action_id
	,FGA.[GoalActionDueDate] AS personal_goal_action_due_date
	,FGA.[GoalActionCompletedDate] AS personal_goal_action_completed_date
	,FPP.[PersonalPlanTitle] AS personal_plan_goal
	,FPP.[PersonalPlanStartDate] AS personal_plan_start_date
	,FPP.[PersonalPlanEndDate] AS personal_plan_end_date
	,DU.UserEmployeeNumber AS user_employee_number
	,FGAOU.[EntityID] AS user_id
	--,FGLS.GoalLookupStatusId AS personal_goal_status_id
	,FGLS.StatusId AS personal_goal_status_id
	,FG.CategoryID AS personal_goal_category_id
	,dgc.GoalCategoryValue	AS personal_goal_category
	,dgc.GoalCategoryText AS personal_goal_category_description
FROM [RBMNB].[dlFactGoal] AS FG
LEFT JOIN RBMNB.dlFactGoalAction AS FGA ON FG.GoalID = fga.GoalID
LEFT JOIN (
	SELECT goalactionid
		,entityid
	FROM (
		SELECT row_number() OVER (
				PARTITION BY goalactionid ORDER BY goalactionid
					,goalactionownercreateddate DESC
				) AS count_goalowners
			,goalactionid
			,entityid
		FROM RBMNB.dlFactGoalActionOwner
		WHERE GoalActionOwnerEntityType = 'User'
		) AS data1
	WHERE count_goalowners = 1
	) AS FGAOU ON FGA.GoalActionID = FGAOU.GoalActionID
left join CTE_EMPLOYEE_LOOKUP_RBMNB el on FGAOU.EntityID = el.UserID
LEFT JOIN RBMNB.dlDimUser AS DU ON FGAOU.EntityID = DU.UserID
--and FGAOU.GoalActionOwnerEntityType='User'
LEFT JOIN RBMNB.dlFactPersonalPlan AS FPP ON FG.PersonalPlanID = FPP.PersonalPlanID
LEFT JOIN RBMNB.dlFactGoalLookupStatus AS FGLS ON FG.GoalID = FGLS.GoalId
	AND FGLS.GoalLookupStatusId = (
		SELECT MAX(FGLS1.GoalLookupStatusId)
		FROM RBMNB.dlFactGoalLookupStatus FGLS1
		WHERE fgls1.GoalId = FGLS.GoalId
		)
LEFT JOIN [RBEAL].[dlDimGoalCategory] dgc ON FG.[CategoryID] = dgc.[GoalCategoryID]

