

CREATE PROC [staging].[insert_staging_fact_client_personal_goal]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_personal_goal]
PURPOSE:  

NOTES:  Call By EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-09    ?				Initial version
1.1		 2023-08-22	   Glenn McLeod		Rename source tables
1.11	 2023-08-29	   Glenn McLeod		Updated table/column names
											Updated dates to date keys
											Added client_user_employee_number to insert
											Removed none numeric employee numbers
1.2		2023-09-25	  Glenn McLeod		Renamed [dim_company_key] to [company_id]
1.21	2024-03-04	  Glenn McLeod		User Story 7207: added personal_goal_category/personal_goal_category_description
1.22	2024-03-07	  Glenn McLeod		User Story 7207: added multiple fields
1.3		2024-09-10	  Greg Nuthall		Use the mapping (reference.edw_lookup) to link mapped employees


****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_personal_goal]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_personal_goal] (
	 	[company_id]
      ,[fact_client_personal_goal_unique_key]
      ,[client_personal_goal_id]
      ,[client_personal_goal_action_id]
      ,[client_referral_id]
      ,[client_id]
      ,[client_user_id]
      ,[client_personal_plan_id]
      ,[client_old_personal_goal_id]
      ,[client_personal_plan_goal]
      ,[client_personal_goal_title]
      ,[client_personal_goal_status_id]
      ,[client_personal_goal_action_description]
      ,[client_personal_goal_action_status_id]
      ,[client_personal_goal_created_date_key]
      ,[client_personal_plan_start_date_key]
      ,[client_personal_plan_end_date_key]
      ,[client_personal_goal_start_date_key]
      ,[client_personal_goal_due_date_key]
      ,[client_personal_goal_action_due_date_key]
      ,[client_personal_goal_action_completed_date_key]
      ,[client_personal_goal_close_completed_date_key]
      ,[client_personal_goal_close_not_completed_date_key]
      ,[client_personal_goal_close_date_key]
      ,[client_personal_goal_completed_status]
	  ,[client_user_employee_number]
	  ,[client_personal_goal_category]
	  ,[client_personal_goal_category_description]
	  ,[goal_created_user_id] 
	  ,[client_personal_goal_action_created_date_key] 
	  ,[goal_action_created_user_id] 
	  ,[client_personal_goal_category_id] 
   )
   select
		src.[company_key] -- this is actually an id not a key
		,cast(src.[personal_goal_id] as nvarchar)+'_'+cast(ISNULL(src.personal_goal_action_id,0) as nvarchar)+'_'+cast(ISNULL(src.referral_id,0) as nvarchar)+'_'+cast(src.client_id as nvarchar)+'_'+cast(src.[company_key] as nvarchar)
		,src.[personal_goal_id]
		,src.[personal_goal_action_id]
		,src.[referral_id]
		,src.[client_id]
		,src.[user_id]
		,src.[personal_plan_id]
		,src.[old_personal_goal_id]
		,src.[personal_plan_goal]
		,src.[personal_goal_title]
		,src.[personal_goal_status_id]
		,src.[personal_goal_action_description]
		,src.[personal_goal_action_status_id]
		,CONVERT(VARCHAR(10), src.[personal_goal_created_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_plan_start_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_plan_end_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_goal_start_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_goal_due_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_goal_action_due_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_goal_action_completed_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_goal_close_completed_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_goal_close_not_completed_date], 112)
		,CONVERT(VARCHAR(10), src.[personal_goal_close_date], 112)
		--,src.[personal_goal_created_date]
		--,src.[personal_plan_start_date]
		--,src.[personal_plan_end_date]
		--,src.[personal_goal_start_date]
		--,src.[personal_goal_due_date]
		--,src.[personal_goal_action_due_date]
		--,src.[personal_goal_action_completed_date]
		--,src.[personal_goal_close_completed_date]
		--,src.[personal_goal_close_not_completed_date]
		--,src.[personal_goal_close_date]
		,src.[personal_goal_completed_status]
		,CASE WHEN ISNUMERIC(isnull(elk.Output_Value,src.user_employee_number)) = 1 THEN isnull(elk.Output_Value,src.user_employee_number) ELSE NULL END AS user_employee_number
		,[personal_goal_category]
		,[personal_goal_category_description]
		,goal_created_user_id
		,CONVERT(VARCHAR(10), personal_goal_action_created_date, 112)
		,goal_action_created_user_id
		,personal_goal_category_id
	from [Landing].[edw_fact_client_personal_goal] as src
	left join reference.edw_lookup elk on cast(src.[user_employee_number] as nvarchar) = Cast(elk.Input_Value as nvarchar)
				and elk.Category = 'dim_employee.employee_id'