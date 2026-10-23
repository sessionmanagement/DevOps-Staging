
CREATE VIEW [edw].[vw_dim_client_referral]

/**********************************************************************************************************
 View      [edw].[vw_dim_client_referral] 
 Purpose   Build the edw.vw_dim_client_referral view 

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-06-10	   Greg Nuthall			Initial creation of stored procedure
1.1     2026-09-10     Greg Nuthall         Removed PII data columns
 **********************************************************************************************************/


AS
SELECT d.dim_client_referral_key
	,d.client_referral_id
	,d.dim_client_referral_unique_key
	,d.company_id
	,d.client_id
	,d.client_team_id
	,d.client_referral_type
	,'' as client_referrer_code
	,d.client_referrer_name
	,d.client_referral_source_id
	,d.client_referral_discharge_reason
	,d.client_referral_accepted_reason
	,d.client_referral_waitlist_reason
	,d.client_referral_declined_reason
	,'' as client_referral_pending_reason
	,d.client_referral_discharge_reason_code
	,d.client_referral_accepted_reason_code
	,d.client_referral_waitlist_reason_code
	,d.client_referral_declined_reason_code
	,d.client_referral_pending_reason_code
	,d.client_status_is_active
	,d.client_referral_status
	,'' as client_referral_discharge_comment
	,'' as client_referral_accepted_comment
	,'' as client_referral_waitlist_comment
	,'' as client_referral_declined_comment
	,'' as client_referral_pending_comment
	,d.DWHSourceSystem
	,d.DWHBatchId
	,d.DWHDMLOperation
	,d.DWHModifiedOn
	,d.DWHCreatedAt
FROM [edw].[dim_client_referral] as d