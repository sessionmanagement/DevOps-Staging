


CREATE PROC [staging].[insert_staging_dim_client_person_relationship]

AS

/***************************************************************************
 name :     [staging].[insert_staging_dim_client_person_relationship]
 Author		Greg Nuthall
 Created	2024/06/10	
 Purpose	Build the edw.dim_client_person_relationship table   

NOTES:  Call By EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0	     2024/06/10	   Greg Nuthall		Initial creation of stored procedure
1.1		 2024-09-10	   Greg Nuthall		Use the mapping (reference.edw_lookup) to link mapped employees

****************************************************************************/

--  clear the staging table before loading
	TRUNCATE TABLE [Staging].[ODSETLdim_client_person_relationship]

-- insert data from landing table into staging table
	INSERT INTO [Staging].[ODSETLdim_client_person_relationship] (
			[company_id],
			[client_person_relationship_id],
			[client_person_relationship_unique_key],
			[client_id],
			[client_responsible_user_id],
			[client_first_name],
			[client_last_name],
			[client_team_id],
			[client_team_name],
			[client_relationship_type],
			[client_referral_type],
			[client_person_relationship_start_date],
			[client_person_relationship_end_date],
			[client_person_relationship_detail],
			[client_person_relationship_user_id],
			[client_person_relationship_created_date],
			[client_referral_id],
			[client_relationship_is_primary_caseworker],
			[user_employee_number],
			[client_referral_status_type_description] ,
			[client_referral_status_type_code] ,
			[client_referral_status_type_group] ,
			[client_referral_caseworker],
			[client_relationship_type_text],
			[client_relationship_type_value]
	   )

	   select
	   src.[company_id],
			src.[client_person_relationship_id],
			src.[client_person_relationship_unique_key],
			src.[client_id],
			src.[client_responsible_user_id],
			src.[client_first_name],
			src.[client_last_name],
			src.[client_team_id],
			src.[client_team_name],
			src.[client_relationship_type],
			src.[client_referral_type],
			src.[client_person_relationship_start_date],
			src.[client_person_relationship_end_date],
			src.[client_person_relationship_detail],
			src.[client_person_relationship_user_id],
			src.[client_person_relationship_created_date],
			src.[client_referral_id],
			src.[client_relationship_is_primary_caseworker],
			isnull(elk.Output_Value, src.[user_employee_number]) as user_employee_number,
			src.[client_referral_status_type_description] ,
			src.[client_referral_status_type_code] ,
			src.[client_referral_status_type_group] ,
			src.[client_referral_caseworker],
			src.[client_relationship_type_text],
			src.[client_relationship_type_value]

		--, Cast(src.[client_referral_id] as nvarchar)+'_'+Cast(src.[client_id] as nvarchar)+'_'+Cast(isnull(src.[client_responsible_user_id],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_start_date],0) as nvarchar)+'_'+Cast(isnull(src.[client_person_relationship_end_date],0) as nvarchar)+'_'+ cast(src.[company_key] as nvarchar)
		--,DATEDIFF(DAY,src.client_referral_accepted_date,src.client_referral_discharge_date)
		--,DATEDIFF(DAY,convert(date,CONVERT(varchar(10),src.client_referral_accepted_date,101)),convert(date,CONVERT(varchar(10),src.client_referral_discharge_date,101)))

		from [Landing].[edw_dim_client_person_relationship] as src
		left join reference.edw_lookup elk on src.[user_employee_number] = elk.Input_Value 
			and elk.Category = 'dim_employee.employee_id'


