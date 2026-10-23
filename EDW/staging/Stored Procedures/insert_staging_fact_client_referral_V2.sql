
CREATE PROC [staging].[insert_staging_fact_client_referral_V2]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_referral_V2]
PURPOSE:  

NOTES:  Call By EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-06-10	   Greg Nuthall		Initial creation of stored procedure
1.1		 2024-09-10	   Greg Nuthall		Use the mapping (reference.edw_lookup) to link mapped employees
1.2		 2025-05-02    Greg Nuthall		Added case worker

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_referral_V2]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_referral_V2] (
	   [client_referral_id]
      ,[client_id]
      ,[client_referral_responsible_user_id]
	  ,[is_case_worker_flag]
      ,[client_team_id]
      ,[fact_client_referral_unique_key]
      ,[company_id]
      ,[user_employee_number]
      ,[client_referral_person_relationship_start_date_key]
      ,[client_referral_person_relationship_end_date_key]
      ,[client_referral_received_date_key]
      ,[client_referral_created_date_key]
      ,[client_referral_end_date_key]
      ,[client_referral_discharge_date_key]
      ,[client_referral_accepted_date_key]
      ,[client_referral_waitlist_date_key]
      ,[client_referral_decline_date_key]
      ,[client_referral_bed_nights]
      ,[client_referral_hospital_nights]
	  ,[client_referral_absence]
	  ,[client_referral_pending_date_key]
   )
   select
		src.[client_referral_id]
		,src.[client_id]
		,src.[client_responsible_user_id]
		,src.[is_case_worker_flag]
		,src.[client_team_id]
		--, Cast(src.[client_referral_id] as nvarchar)+'_'+Cast(src.[client_id] as nvarchar)+'_'+Cast(isnull(src.[client_responsible_user_id],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_start_date],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_end_date],0) as nvarchar)+'_'+ cast(src.[company_key] as nvarchar)
		--, Cast(src.[client_referral_id] as nvarchar)+'_'+Cast(src.[client_id] as nvarchar)+'_'+Cast(isnull(src.[client_responsible_user_id],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_start_date],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_end_date],0) as nvarchar)+'_'+ cast(src.[company_key] as nvarchar)
		,Cast(src.[client_referral_id] as nvarchar)+'_'+ cast(src.[company_key] as nvarchar)
		,src.[company_key]
		,isnull(elk.Output_Value, src.[user_employee_number]) as user_employee_number
		,src.[client_person_relationship_start_date]
		,src.[client_person_relationship_end_date]
		,src.[client_referral_received_date]
		,src.[client_referral_created_date]
		,src.[client_referral_end_date]
		,src.[client_referral_discharge_date]
		,src.[client_referral_accepted_date]
		,src.[client_referral_waitlist_date]
		,src.[client_referral_decline_date]
		--,DATEDIFF(DAY,src.client_referral_accepted_date,src.client_referral_discharge_date)
		,DATEDIFF(DAY,convert(date,CONVERT(varchar(10),src.client_referral_accepted_date,101)),convert(date,CONVERT(varchar(10),src.client_referral_discharge_date,101)))
		,src.[client_hospital_nights]
		,src.[client_absence]
		,src.client_referral_pending_date
	from [Landing].[edw_fact_client_referral_V2] as src
	left join reference.edw_lookup elk on cast(src.[user_employee_number] as nvarchar) = Cast(elk.Input_Value as nvarchar)
					and elk.Category = 'dim_employee.employee_id'