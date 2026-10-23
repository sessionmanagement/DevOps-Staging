

CREATE view [edw].[vw_fact_client_activity_breakdown]
as

     select f.[fact_client_activity_breakdown_key]
      ,f.[dim_company_key]
      ,f.[dim_client_activity_breakdown_type_key]
      ,f.[dim_employee_key]
      ,f.[dim_client_key]
	  ,isnull(dc.[dim_client_key], CASE 
			WHEN f.client_id IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_client_key_latest]
      ,f.[dim_client_referral_key]
      ,f.[dim_client_team_key]
      ,f.[dim_service_key]
      ,f.[fact_client_activity_breakdown_unique_key]
      ,f.[client_activity_breakdown_id]
      ,f.[client_activity_id]
      ,f.[client_parent_activity_id]
      ,f.[client_referral_id]
      ,f.[client_id]
      ,f.[client_activity_user_id]
      ,f.[user_employee_number]
      ,f.[client_team_id]
      ,f.[client_activity_breakdown_type_id]
      ,f.[client_activity_type_code]
	  ,f.[client_activity_type_name]
	  ,f.[client_activity_type_description]
	  ,f.[client_activity_classification_code]
	  ,f.[client_activity_classification_name]
	  ,f.[client_activity_classification_description]
      
	  ,f.[client_activity_created_date] as client_activity_created_datetime
      ,f.[client_activity_start_date] as client_activity_start_datetime
      ,f.[client_activity_end_date] as client_activity_end_datetime
	  ,f.[client_activity_breakdown_created_date] as client_activity_breakdown_created_datetime

	  ,cast(convert(nvarchar(8), f.[client_activity_created_date], 112) as Int) as client_activity_created_date_key
	  ,cast(convert(nvarchar(8), f.[client_activity_start_date], 112) as Int) as client_activity_start_date_key
	  ,cast(convert(nvarchar(8), f.[client_activity_end_date], 112) as Int) as client_activity_end_date_key
	  ,cast(convert(nvarchar(8), f.[client_activity_breakdown_created_date], 112) as Int) as client_activity_breakdown_created_date_key

      ,f.[client_activity_duration]
	  ,f.[client_activity_whanau_involvement]
	  ,f.client_group_activity_id
	  ,f.client_activity_subject
	  ,f.client_activity_description
      ,f.[DWHSourceSystem]
      ,f.[DWHBatchId]
      ,f.[DWHDMLOperation]
      ,f.[DWHModifiedOn]
      ,f.[DWHCreatedAt]
	
	from [edw].[fact_client_activity_breakdown] f
	left join [edw].[dim_client] dc ON f.client_id = dc.client_id
	and f.dim_company_key = dc.[company_id]
	and dc.DWHIsCurrent = 1