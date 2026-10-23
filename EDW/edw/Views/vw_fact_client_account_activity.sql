

CREATE view [edw].[vw_fact_client_account_activity]

/**********************************************************************************************************
 View		 [edw].[vw_fact_client_account_activity]
 Author		 Glenn McLeod
 Created	 2023-08-22
 Purpose	 Current records view for fact_client_account_activity
 Notes		 Returns client_account_activity with history			
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		?			  ?						Initial creation of view
1.1		2023-08-22	  Glenn McLeod			Rename source tables
1.2     2026-09-10    Greg Nuthall          Removed PII data columns
**********************************************************************************************************/

as

select [fact_client_account_activity_key]
      ,[fact_client_account_activity_id]
      ,[dim_client_team_key]
      ,[dim_service_key]
      ,[dim_company_key]
      ,dim_participated_employee_key
	  ,dim_created_employee_key
      ,[client_account_activity_id]
      ,'' as [client_account_activity_location]
      ,[client_account_activity_subject]
      ,'' as [client_account_activity_description_html]
      ,'' as [client_account_activity_description_raw]
      ,[client_account_activity_start_date]
      ,[client_account_activity_end_date]
	  ,cast(convert(nvarchar(8), [client_account_activity_start_date], 112) as Int) as client_account_activity_start_date_key
	  ,cast(convert(nvarchar(8), [client_account_activity_end_date], 112) as Int) as client_account_activity_end_date_key
      ,[client_account_activity_type_id]
      ,[client_account_activity_classification_id]
      ,[client_account_activity_created_date]
      ,[client_account_activity_created_user_id]
      ,'' as [client_account_activity_udf1]
      ,'' as [client_account_activity_udf2]
      ,'' as [client_account_activity_udf3]
      ,'' as [client_account_activity_udf4]
      ,'' as [client_account_activity_udf5]
      ,'' as [client_account_activity_other_participants]
      ,[client_team_id]
      ,[client_account_activity_audience_size]
      ,[client_account_activity_classification_text]
      ,[client_account_activity_type_text]
      ,'' as [client_account_name]
      ,[primary_contact_id]
      ,[participated_employee_id]
	  ,[created_employee_id]
      ,[DWHBatchId]
      ,[DWHEffectiveFrom]
      ,[DWHEffectiveTo]
      ,[DWHDMLOperation]
      ,[DWHIsCurrent]
      ,[DWHSourceSystem]
  FROM [edw].[fact_client_account_activity]