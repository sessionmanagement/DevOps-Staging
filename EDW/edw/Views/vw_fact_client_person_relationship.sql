
CREATE VIEW [edw].[vw_fact_client_person_relationship]

/***************************************************************************
 name :     [edw].[vw_fact_client_person_relationship]
 Author		Greg Nuthall
 Created	2024/06/10	
 Purpose	Build the edw.fact_client_person_relationship table 

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of view
1.1     2026-09-10    Greg Nuthall          Removed PII data columns
**********************************************************************************************************/

AS

SELECT f.[fact_client_person_relationship_key]
      ,f.[fact_client_person_relationship_id]
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
      ,'' as [client_first_name]
      ,'' as [client_last_name]
      ,f.[client_team_id]
      ,f.[client_team_name]
      ,f.[client_relationship_type]
      ,f.[client_relationship_type_id]
      ,'' as [client_referral_type]
      ,f.[client_person_relationship_start_date]
      ,f.[client_person_relationship_end_date]
      ,f.[client_person_relationship_detail]
      ,f.[client_person_relationship_user_id]
      ,f.[client_person_relationship_created_date]
      ,f.[client_referral_id]
      ,null as [client_relationship_is_primary_caseworker]
      ,f.[DWHSourceSystem]
      ,f.[DWHBatchId]
      ,f.[DWHDMLOperation]
      ,f.[DWHModifiedOn]
      ,f.[DWHCreatedAt]
      ,f.[client_referral_pending_date_key]
  FROM [edw].[fact_client_person_relationship] f
  LEFT JOIN [edw].[dim_client] dc ON f.client_id = dc.client_id
	AND f.dim_company_key = dc.[company_id]
	AND dc.DWHIsCurrent = 1