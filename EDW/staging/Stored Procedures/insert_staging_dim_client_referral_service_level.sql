CREATE PROC [staging].[insert_staging_dim_client_referral_service_level]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_referral_service_level]
PURPOSE:  
NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-05-29    Greg Nuthall		Initial version
1.1		 2025-06-30	   Greg Nuthall		Added effective_date and changed to get just the latest record per referral
1.2		 2025-07-02    Greg Nuthall		Added missing join clause to client company_id
1.3      2025-10-09    Stefen Hasselberg Added filter on the client referral join to exclude deleted referrals
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_referral_service_level]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_referral_service_level] (
	 [client_referral_service_level_id] 
	,[company_id] 
	,[client_id] 
	,dim_client_key
	,dim_client_referral_key
	,[client_referral_id] 
	,[service_level_code] 
	,[service_level] 
	,[effective_date]
	,[service_level_group]
	)
SELECT
	 src.[client_referral_service_level_id] 
	,src.[company_id] 
	,src.[client_id]
	,isnull(c.dim_client_key, case when isnull(src.[client_id],0) = 0 then 0 else -1 end) as dim_client_key
	,isnull(cr.dim_client_referral_key, case when isnull(src.[client_referral_id],0) = 0 then 0 else -1 end) as dim_client_referral_key
	,src.[client_referral_id] 
	,src.[service_level_code] 
	,src.[service_level] 
	,src.[effective_date]
	,src.[service_level_group]
from [Landing].[edw_dim_client_referral_service_level] src
left outer join edw.dim_client_referral cr 
	on src.client_referral_id = cr.client_referral_id and cr.DWHDMLOperation <> 'D'  -- make sure we don't include deleted client referrals
left outer join edw.dim_client c 
	on src.client_id = c.client_id and c.DWHIsCurrent = 1
	and cr.company_id = c.company_id