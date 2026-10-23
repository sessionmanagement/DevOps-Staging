
CREATE  PROC [staging].[insert_staging_fact_client_activity_breakdown]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_activity_breakdown]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-08    ?				Initial version
1.11	 2023-08-22	   Glenn McLeod		Rename source tables
1.12	 2023-08-29	   Glenn McLeod		Updated table/column names
1.2		 2023-09-25	   Glenn McLeod		Renamed destination column from [dim_company_key] to [company_id]
1.21	 2024-03-25	   Glenn McLeod		Bug 7270: Added [client_activity_breakdown_created_date]
1.3      2024-07-30	   Greg Nuthall     7271 Added new field [client_activity_whanau_involvement]
1.4		 2024-09-10	   Greg Nuthall		Use the mapping (reference.edw_lookup) to link mapped employees
1.5		 2024-09-18	   Greg Nuthall		8881/8626 Added user employee number to unique key and added 3 new columns
1.6		 2025-01-07	   Greg Nuthall     Join with reference table cast as nvarchar to deal with non numeric employee id's
1.7		 2026-03-26    Greg Nuthall	    Added two descriptions and renamed client_activity_name to client_activity_type_name 
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_activity_breakdown]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_activity_breakdown] (
	  [client_activity_breakdown_id]
      ,[client_activity_id]
      ,[fact_client_activity_breakdown_unique_key]
      ,[company_id]
      ,[client_parent_activity_id]
      ,[client_referral_id]
      ,[client_id]
      ,[client_activity_user_id]
	  ,[user_employee_number]
      ,[client_team_id]
      ,[client_activity_breakdown_type_id]
      ,[client_activity_type_code]
	  ,[client_activity_type_name]
	  ,[client_activity_type_description]
	  ,[client_activity_classification_code]
	  ,[client_activity_classification_name]
	  ,[client_activity_classification_description]
      ,[client_activity_created_date]
      ,[client_activity_start_date]
      ,[client_activity_end_date]
	  ,[client_activity_breakdown_created_date]
      ,[client_activity_duration]
	  ,[client_activity_whanau_involvement]
	  ,client_group_activity_id
	  ,client_activity_subject
	  ,client_activity_description

   )
   select
	   src.[client_activity_breakdown_id]
      ,src.[client_activity_id]
      , cast(isnull(src.[client_activity_breakdown_id],0) as nvarchar) + '_'
		  + cast(isnull(src.[client_activity_id],'') as nvarchar) + '_'
		  + cast(isnull(src.[client_referral_id],0) as nvarchar) + '_'
		  + cast(isnull(src.[client_id],0) as nvarchar) + '_'
		  + cast(isnull(src.[client_activity_breakdown_type_id],0) as nvarchar) + '_'
		  + cast([company_key] as nvarchar) + '_'
		  + cast(isnull(src.[client_activity_user_id],'') as nvarchar) 
	  as fact_client_activity_breakdown_unique_key
      ,src.[company_key]
      ,src.[client_parent_activity_id]
      ,src.[client_referral_id]
      ,src.[client_id]
      ,src.[client_activity_user_id]
	  ,isnull(elk.Output_Value, src.[user_employee_number]) as user_employee_number
      ,src.[client_team_id]
      ,src.[client_activity_breakdown_type_id]
      ,src.[client_activity_type_code]
	  ,src.[client_activity_type_name]
	  ,src.[client_activity_type_description]
	  ,src.[client_activity_classification_code]
	  ,src.[client_activity_classification_name]
	  ,src.[client_activity_classification_description]
      ,src.[client_activity_created_date]
      ,src.[client_activity_start_date]
      ,src.[client_activity_end_date]
	  ,src.[client_activity_breakdown_created_date]
      ,src.[client_activity_duration]
	  ,src.[client_activity_whanau_involvement]
	  ,src.client_group_activity_id
	  ,src.client_activity_subject
	  ,src.client_activity_description

	from [Landing].[edw_fact_client_activity_breakdown] as src
	left join reference.edw_lookup elk on cast(src.[user_employee_number] as nvarchar) = cast(elk.Input_Value as nvarchar) 
	and elk.Category = 'dim_employee.employee_id'