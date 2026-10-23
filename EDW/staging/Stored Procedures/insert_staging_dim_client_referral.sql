


CREATE PROC [staging].[insert_staging_dim_client_referral]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_referral]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of stored procedure
1.1		2023-08-08	  Glenn McLeod			Updated to use table Framework table names 
1.11	2023-08-22	  Glenn McLeod			Rename source tables
1.12	2023-08-25	  Glenn McLeod			Updated table/column names
1.2		2023-09-25	  Glenn McLeod			Renamed destination column from [dim_company_key] to [company_id]
1.3		2024-02-22	  Glenn McLeod			7161: Added new column [client_referral_status]
1.31	2024-03-04	  Glenn McLeod			User Story 7207: added multiple columns
1.32	2024-03-22	  Glenn McLeod			Bug 7255: Rename client_referral_code to client_referrer_code
1.4     2024-05-21    Greg Nuthall			User Story 7528 and 7531: dim_client_referral - referral_reason_comments, client_referral_pending_reason and code to be added 


****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_referral]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_referral] (
	[client_referral_id]
    ,[dim_client_referral_unique_key]
	,[company_id]
    ,[client_id]
    ,[client_team_id]
    ,[client_referral_type]
    ,[client_referrer_name]
    ,[client_referral_source_id]
    ,[client_referral_discharge_reason]
    ,[client_referral_accepted_reason]
    ,[client_referral_waitlist_reason]
    ,[client_referral_declined_reason]
	,[client_referral_pending_reason]
    ,[client_status_is_active]
	,[client_referral_status]
	,[client_referral_discharge_reason_code]
	,[client_referral_accepted_reason_code]
	,[client_referral_waitlist_reason_code]
	,[client_referral_declined_reason_code]
	,[client_referral_pending_reason_code]
	,[client_referrer_code]
	,[client_referral_discharge_comment]
	,[client_referral_accepted_comment]
	,[client_referral_waitlist_comment]
	,[client_referral_declined_comment]
	,[client_referral_pending_comment]

   )
   select
	src.[client_referral_id]
	,Cast(src.[client_referral_id] as nvarchar)+'_'+Cast(src.[client_id] as nvarchar)+'_'+ CAST(src.[company_key] as nvarchar)
	,src.[company_key]
    ,src.[client_id]
    ,src.[client_team_id]
    ,src.[client_referral_type]
    ,src.[client_referrer_name]
    ,src.[source_referral_id]
    ,src.[client_referral_discharge_reason]
    ,src.[client_referral_accepted_reason]
    ,src.[client_referral_waitlist_reason]
    ,src.[client_referral_declined_reason]
	,src.[client_referral_pending_reason]
    ,src.[client_status_is_active]
	,src.[client_referral_status]
	,src.[client_referral_discharge_reason_code]
	,src.[client_referral_accepted_reason_code]
	,src.[client_referral_waitlist_reason_code]
	,src.[client_referral_declined_reason_code]
	,src.[client_referral_pending_reason_code]
	,src.[client_referrer_code]
	,src.[client_referral_discharge_comment]
	,src.[client_referral_accepted_comment]
	,src.[client_referral_waitlist_comment]
	,src.[client_referral_declined_comment]
	,src.[client_referral_pending_comment]
from [Landing].[edw_dim_client_referral] as src