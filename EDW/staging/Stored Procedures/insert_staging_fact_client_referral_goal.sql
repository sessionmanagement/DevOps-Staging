






CREATE PROC [staging].[insert_staging_fact_client_referral_goal]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_referral_goal]
PURPOSE:  

NOTES:  Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-09    ?				Initial version
1.1		 2023-08-22	   Glenn McLeod		Rename source tables
1.11	 2023-08-30	   Glenn McLeod		Updated table/column names
1.2		 2023-09-25	   Glenn McLeod		Renamed destination column from [dim_company_key] to [company_id]
1.21	 2024-03-08	   Glenn McLeod		User Story 7207: added multiple columns
1.23	 2025-02-27	  Greg Nuthall		User Story 9746 Added client_referral_id and dim key

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_referral_goal]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_referral_goal] (
	   [company_id]
      ,[fact_client_referral_goal_unique_key]
      ,[client_referral_goal_id]
      ,[client_id]
      ,[client_referral_goal_title]
      ,[client_referral_goal_start_date_key]
      ,[client_referral_goal_end_date_key]
      ,[client_referral_goal_created_date_key]
      ,[client_referral_goal_created_user_id]
	  ,[client_referral_goal_review_cycle]
	  ,[client_referral_goal_next_review_date_key]
	  ,client_referral_id
   )
   select
		[company_key]
		,cast(src.referral_goal_id as nvarchar)+'_'+ cast([company_key] as nvarchar)
		,src.[referral_goal_id]
		,src.[client_id]
		,src.[referral_goal_title]
		,CONVERT(VARCHAR(10), src.[referral_goal_start_date], 112)
		,CONVERT(VARCHAR(10), src.[referral_goal_end_date], 112)
		,CONVERT(VARCHAR(10), src.[referral_goal_created_date], 112)
		,src.[referral_goal_created_user_id]
		,src.[referral_goal_review_cycle]
		,CONVERT(VARCHAR(10),src.[referral_goal_next_review_date], 112)
		,client_referral_id
from [Landing].[edw_fact_client_referral_goal] as src