


CREATE VIEW [edw].[vw_dim_client_person_relationship]
AS

/**********************************************************************************************************
 View	    [edw].[vw_dim_client_person_relationship] 
 Author		Greg Nuthall
 Created	2024/06/10	
 Purpose	Build the edw.vw_dim_client_person_relationship view 
 **********************************************************************************************************/

SELECT f.[dim_client_person_relationship_key]
      ,f.[dim_client_person_relationship_id]
      ,f.[dim_company_key]
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
      ,f.[client_id]
      ,f.[client_responsible_user_id]
      ,f.[client_first_name]
      ,f.[client_last_name]
      ,f.[client_team_id]
      ,f.[client_team_name]
      ,f.[client_relationship_type]
      ,f.[client_referral_type]
      ,f.[client_person_relationship_start_date]
      ,f.[client_person_relationship_end_date]
      ,f.[client_person_relationship_detail]
      ,f.[client_person_relationship_user_id]
      ,f.[client_person_relationship_created_date]
      ,f.[client_referral_id]
      ,f.[client_relationship_is_primary_caseworker]
      ,f.[user_employee_number]
      ,f.[client_referral_status_type_description]
      ,f.[client_referral_status_type_code]
      ,f.[client_referral_status_type_group]
      ,f.[client_referral_caseworker]
      ,f.[client_relationship_type_text]
      ,f.[client_relationship_type_value]
      ,f.[DWHSourceSystem]
      ,f.[DWHBatchId]
      ,f.[DWHDMLOperation]
      ,f.[DWHModifiedOn]
      ,f.[DWHCreatedAt]

  FROM [edw].[dim_client_person_relationship] f
  LEFT JOIN [edw].[dim_client] dc ON f.[client_id] = dc.[client_id]
		AND f.[dim_company_key] = dc.[company_id]
		AND dc.[DWHIsCurrent] = 1