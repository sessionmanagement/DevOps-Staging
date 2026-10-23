



CREATE PROC [staging].[insert_staging_dim_client_personal_goal_action_status]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_client_personal_goal_action_status]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 ?			   ?				Initial version
1.1		 2023-08-08	   Glenn McLeod		Updated to use table Framework table names 
1.11	 2023-08-22	   Glenn McLeod		Rename source tables
1.12	 2023-08-25	   Glenn McLeod		Updated table/column names
1.2		 2023-09-25	   Glenn McLeod		Renamed destination column from [dim_company_key] to [company_id]

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_client_personal_goal_action_status]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_client_personal_goal_action_status] 
   (
	   [personal_goal_action_status_id]
      ,[company_id]
      ,[dim_client_personal_goal_action_status_unique_key]
      ,[personal_goal_action_status_code]
      ,[personal_goal_action_status_text]
      ,[personal_goal_action_status_is_completed_status]
      ,[personal_goal_action_status_is_cancelled_status]
      ,[personal_goal_action_status_sort_index]
   )
   select
	   src.[personal_goal_action_status_id]
      ,src.[company_key]
      ,cast(src.[personal_goal_action_status_id] as nvarchar)+'_'+ CAST(src.[company_key] as varchar)
      ,src.[personal_goal_action_status_code]
      ,src.[personal_goal_action_status_text]
      ,src.[personal_goal_action_status_is_completed_status]
      ,src.[personal_goal_action_status_is_cancelled_status]
      ,src.[personal_goal_action_status_sort_index]
from [Landing].[edw_dim_client_personal_goal_action_status] as src