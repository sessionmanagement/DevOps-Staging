
CREATE PROC [staging].[insert_staging_fact_client_referral]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_client_referral]
PURPOSE:  

NOTES:  Call By EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2023-08-09    ?				Initial version
1.1		 2023-08-22	   Glenn McLeod		Rename source tables
1.11	 2023-08-29	   Glenn McLeod		Updated table/column names
1.2		 2023-09-25	   Glenn McLeod		Renamed destination column from [dim_company_key] to [company_id]
1.21	 2024-03-04	   Glenn McLeod		User Story 7207: added [client_referral_pending_date_key]
1.3		 2024-09-10	   Greg Nuthall		Use the mapping (reference.edw_lookup) to link mapped employees

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_client_referral]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_client_referral] (
	   [client_referral_id]
      ,[client_id]
      ,[client_referral_responsible_user_id]
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
		,src.[client_team_id]
		, Cast(src.[client_referral_id] as nvarchar)+'_'+Cast(src.[client_id] as nvarchar)+'_'+Cast(isnull(src.[client_responsible_user_id],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_start_date],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_end_date],0) as nvarchar)+'_'+ cast(src.[company_key] as nvarchar)
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
from [Landing].[edw_fact_client_referral] as src
left join reference.edw_lookup elk on cast(src.[user_employee_number] as nvarchar) = Cast(elk.Input_Value as nvarchar)
				and elk.Category = 'dim_employee.employee_id'