
CREATE VIEW [edw].[vw_fact_client_referral]
AS
SELECT
	f.[fact_client_referral_key]
	,f.[fact_client_referral_unique_key]
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
	,f.[client_referral_id]
	,f.[client_referral_responsible_user_id]
	,f.[is_case_worker_flag]
	,f.[user_employee_number]
	,f.[client_team_id]
	,f.[client_referral_person_relationship_start_date_key]
	,f.[client_referral_person_relationship_end_date_key]
	,f.[client_referral_received_date_key]
	,f.[client_referral_created_date_key]
	,f.[client_referral_end_date_key]
	,f.[client_referral_pending_date_key]
	,f.[client_referral_discharge_date_key]
	,f.[client_referral_accepted_date_key]
	,f.[client_referral_waitlist_date_key]
	,f.[client_referral_decline_date_key]
	,f.[client_referral_bed_nights]
	,f.[client_referral_hospital_nights]
	,f.[client_referral_absence]
	,f.[DWHSourceSystem]
	,f.[DWHBatchId]
	,f.[DWHDMLOperation]
	,f.[DWHModifiedOn]
	,f.[DWHCreatedAt]
FROM [edw].[fact_client_referral_V2] f
LEFT JOIN [edw].[dim_client] dc ON f.client_id = dc.client_id
	AND f.dim_company_key = dc.[company_id]
	AND dc.DWHIsCurrent = 1