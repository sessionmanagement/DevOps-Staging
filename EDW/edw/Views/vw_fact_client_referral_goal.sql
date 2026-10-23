
CREATE VIEW [edw].[vw_fact_client_referral_goal]
AS

SELECT f.[fact_client_referral_goal_key]
      ,f.[fact_client_referral_goal_unique_key]
      ,f.[dim_company_key]
      ,f.[dim_client_key]
	  ,f.dim_client_referral_key
	  ,isnull(dc.[dim_client_key], CASE 
			WHEN f.client_id IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_client_key_latest]
      ,f.[client_referral_goal_id]
      ,f.[client_id]
      ,f.[client_referral_goal_title]
      ,f.[client_referral_goal_start_date_key]
      ,f.[client_referral_goal_end_date_key]
      ,f.[client_referral_goal_created_date_key]
      ,f.[client_referral_goal_created_user_id]
	  ,f.client_referral_goal_review_cycle 
	  ,f.client_referral_goal_next_review_date_key
	  ,f.client_referral_id
      ,f.[DWHSourceSystem]
      ,f.[DWHBatchId]
      ,f.[DWHDMLOperation]
      ,f.[DWHModifiedOn]
      ,f.[DWHCreatedAt]
  FROM [edw].[fact_client_referral_goal] f
  LEFT JOIN [edw].[dim_client] dc ON f.client_id = dc.client_id
	AND f.dim_company_key = dc.[company_id]
	AND dc.DWHIsCurrent = 1