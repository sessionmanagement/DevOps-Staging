


CREATE VIEW [edw].[vw_fact_client_personal_goal] 

as

SELECT f.[fact_client_personal_goal_key],
       f.[fact_client_personal_goal_unique_key],
       f.[dim_company_key],
       f.[dim_employee_key],
       f.[dim_client_key],
       ISNULL(dc.[dim_client_key], CASE WHEN f.client_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_client_key_latest],
       f.[dim_client_referral_key],
       f.[dim_client_personal_goal_action_status_key],
       f.[dim_client_personal_goal_status_key],
       f.[fact_client_referral_goal_key],
       f.[client_personal_goal_id],
       f.[client_personal_goal_action_id],
       f.[client_referral_id],
       f.[client_id],
       f.[client_user_id],
       f.client_user_employee_number,
       --f.[employee_id], -- Renamed column as employee_id,
       f.[client_personal_plan_id],
       f.[client_old_personal_goal_id],
       '' as [client_personal_plan_goal],
       '' as [client_personal_goal_title],
       f.[client_personal_goal_status_id],
       f.[client_personal_goal_category_id],
       '' as [client_personal_goal_action_description],
       f.[goal_created_user_id],
       f.[client_personal_goal_action_status_id],
       f.[client_personal_goal_created_date_key],
       f.[client_personal_plan_start_date_key],
       f.[client_personal_plan_end_date_key],
       f.[client_personal_goal_start_date_key],
       f.[client_personal_goal_due_date_key],
       f.[goal_action_created_user_id],
       f.[client_personal_goal_action_created_date_key],
       f.[client_personal_goal_action_due_date_key],
       f.[client_personal_goal_action_completed_date_key],
       f.[client_personal_goal_close_completed_date_key],
       f.[client_personal_goal_close_not_completed_date_key],
       f.[client_personal_goal_close_date_key],
       f.[client_personal_goal_completed_status],
       f.[client_personal_goal_category],
       f.[client_personal_goal_category_description],
       f.[DWHSourceSystem],
       f.[DWHBatchId],
       f.[DWHDMLOperation],
       f.[DWHModifiedOn],
       f.[DWHCreatedAt]
  FROM edw.fact_client_personal_goal f
  LEFT JOIN edw.dim_client dc ON f.client_id = dc.client_id
    AND f.dim_company_key = dc.[company_id]
    AND dc.DWHIsCurrent = 1;