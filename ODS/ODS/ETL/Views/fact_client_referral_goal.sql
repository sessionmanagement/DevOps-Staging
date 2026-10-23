

CREATE    VIEW [ETL].[fact_client_referral_goal]

as

SELECT 1 AS company_key
	,[PersonalPlanID] AS referral_goal_id
	,[PersonID] AS client_id
	,[PersonalPlanTitle] AS referral_goal_title
	,[PersonalPlanStartDate] AS referral_goal_start_date
	,[PersonalPlanEndDate] AS referral_goal_end_date
	,[PersonalPlanCreatedDate] AS referral_goal_created_date
	,[PersonalPlanCreatedUserID] AS referral_goal_created_user_id
	--,PersonalPlanNextReviewDate
	,PersonalPlanNextReviewDate AS referral_goal_next_review_date
	,PersonalPlanReviewCycle AS referral_goal_review_cycle
	,ReferralID as client_referral_id
FROM [RBEAL].[dlFactPersonalPlan]

UNION

SELECT 5 AS company_key
	,[PersonalPlanID] AS referral_goal_id
	,[PersonID] AS client_id
	,[PersonalPlanTitle] AS referral_goal_title
	,[PersonalPlanStartDate] AS referral_goal_start_date
	,[PersonalPlanEndDate] AS referral_goal_end_date
	,[PersonalPlanCreatedDate] AS referral_goal_created_date
	,[PersonalPlanCreatedUserID] AS referral_goal_created_user_id
	--,PersonalPlanNextReviewDate
	,PersonalPlanNextReviewDate AS referral_goal_next_review_date
	,PersonalPlanReviewCycle AS referral_goal_review_cycle 
	,ReferralID as client_referral_id
FROM [RBMNB].[dlFactPersonalPlan]

