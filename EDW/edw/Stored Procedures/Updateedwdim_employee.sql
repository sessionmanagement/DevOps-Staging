

CREATE PROCEDURE [edw].[Updateedwdim_employee] @pBatchID INT

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_employee] 
 Author		
 Created		
 Purpose	This dim table consolidates employee data from multiple HR and payroll systems (IntelliHR, RecordBase, Datapay
			,EmpLive) into a unified employee dataset. 
			
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date			Author					Description
-------	------------	------------------		--------------------------
1.0		?				?						Initial creation of stored procedure
1.1		2023-08-23		Glenn McLeod			Altered to stop 0 record [DWHEffectiveTo] from being update
1.11	2023-08-25		Glenn McLeod			Updated table/column names
1.2		2023-09-25		Glenn McLeod			Add -1 record of for Unknown and updated 0 record to be N/A
1.3		2023-11-27		Glenn McLeod			Added [employee_job_name]
2.0		2024-11-08		Greg Nuthall			Added new dim ethnicity keys
2.1		2024-12-09		Greg Nuthall			Added employee_full_time_equivalent
2.2		2024-12-09		Greg Nuthall			Added Job status (different from employment status for people with more than 1 job)
												Removed blank columns
2.3		2025-01-06		Greg Nuthall			Put back source system
2.4		2025-01-08		Greg Nuthall			Remove age and age group to avoid SCD2 new rows, it will be added to the view 
2.5		2025-08-25		Greg Nuthall			Hapu affiliation link fix em-->ha
2.6     2025/12/03      Greg Nuthall		    Added extended leave type 2
2.7	    2026/07/07      Malhar Badheka		    Added employee_profile_system_id
2.8     2026-10-20		Greg Nuthall			Added employee_employment_condition
**********************************************************************************************************/

	,@pIndexRebuildThreshold INT = 0
	,@pOutputParamsAsDataset INT = 0
	,@pErrorRecords INT = NULL OUTPUT
	,@pInsertRecords INT = NULL OUTPUT
	,@pUpdateRecords INT = NULL OUTPUT
	,@pDeleteRecords INT = NULL OUTPUT
	,@pCompleted INT = NULL OUTPUT
	,@pTargetRecords INT = NULL OUTPUT
	,@pErrorMessage VARCHAR(MAX) = NULL OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Variables   
	DECLARE @batchID INT = @pBatchID;
	--DECLARE @SourceSystem NVARCHAR(120) = 'IntelliHR.people, Datapay.employees, RBEAL/MNB dlDimUser, EmpLive.employees';
	DECLARE @stagedRecords INT = 0;
	DECLARE @targetRecords INT = 0;
	DECLARE @insertedRecords INT = 0;
	DECLARE @updatedRecords INT = 0;
	DECLARE @deletedRecords INT = 0;
	DECLARE @systemCurrentDate DATETIME = getdate();
	DECLARE @SystemEffectiveFrom DATETIME = @systemCurrentDate;
	DECLARE @SystemEffectiveTo DATETIME = dateadd(second, - 1, @SystemEffectiveFrom);
	DECLARE @SystemDefaultEffectiveFrom DATETIME = '1 January 1900';
	DECLARE @SystemDefaultEffectiveTo DATETIME = '31 December 2999 23:59:59';

	BEGIN TRANSACTION;

	BEGIN TRY

	-- Do not run if there are records in source
	SELECT @stagedRecords = count(1)
	FROM [staging].[ODSETLdim_employee];

	IF (@stagedRecords = 0)
	BEGIN
		SELECT @targetRecords = count(1)
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		FROM [edw].[dim_employee];

		-- Select success details   
		SELECT @pErrorRecords = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted = 1
			,@pTargetRecords = @targetRecords;

		IF (@pOutputParamsAsDataset = 1)
		BEGIN -- Select return parameters as a dataset  
			SELECT @pErrorRecords AS ErrorRecords
				,@pInsertRecords AS InsertRecords
				,@pUpdateRecords AS UpdateRecords
				,@pDeleteRecords AS DeleteRecords
				,@pCompleted AS Completed
				,@targetRecords AS TargetRecords;
		END;

		RETURN;
	END;

	IF NOT EXISTS (
			SELECT dim_employee_key
			FROM [edw].[dim_employee] WHERE [employee_id] <= 0
			)
	BEGIN
		 --turn the identity insert on 
		 --SET IDENTITY_INSERT [edw].[dim_employee] ON

		INSERT INTO [edw].[dim_employee] (primary_ethnicity_id
				,secondary_ethnicity_id
				,tertiary_ethnicity_id
				,fourth_ethnicity_id
				,primary_iwi_id
				,identified_ethnicity_id 
				,[employee_id]
				,[employee_name]
				,[employee_first_name]
				,[employee_middle_name]
				,[employee_last_name]
				,[employee_title]
				,[employee_preferred_name]
				,[employee_employment_status]
				,[employee_gender]
				,[employee_previous_gender]
				,[employee_previous_gender_valid_to_date]
				,[employee_company_name]
				,[employee_job_name]
				,[employee_full_time_equivalent]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
			)
		VALUES (99999
			,99999
			,99999
			,99999
			,99999
			,99999
			,0
			,'N/A'
			,'N/A'
			,'N/A'
			,'N/A'
			,'N/A'
			,'N/A'
			,'N/A'
			,'N/A'
			,'N/A'
			,convert(DATETIME, '31 December 2999 23:59:59')
			,'N/A'
			,'N/A'
			,null
			,'[Manual]'
			,0
			,'I'
			,@SystemDefaultEffectiveFrom
			,@SystemDefaultEffectiveTo
			,1
			),
			(99999
			,99999
			,99999
			,99999
			,99999
			,99999
			,-1
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,'Unknown'
			,convert(DATETIME, '31 December 2999 23:59:59')
			,'Unknown'
			,'Unknown'
			, null
			,'[Manual]'
			,0
			,'I'
			,@SystemDefaultEffectiveFrom
			,@SystemDefaultEffectiveTo
			,1
			)

			-- turn the identity insert off
			--SET IDENTITY_INSERT [edw].[dim_employee] OFF
	END

	--

	IF (object_id('tempdb..#SummaryOfChanges') IS NOT NULL)
		DROP TABLE #SummaryOfChanges;

	CREATE TABLE #SummaryOfChanges (
		[employee_id] INT NOT NULL
		,[MergeAction] VARCHAR(10)
		);


	IF (
			NOT EXISTS (
				SELECT TOP (1) 1
				FROM [edw].[dim_employee]
				WHERE dim_employee_key > 0
				)
			)
		BEGIN -- There are no records in the target; insert all
			INSERT INTO [edw].[dim_employee] (
				 primary_ethnicity_id
				,secondary_ethnicity_id
				,tertiary_ethnicity_id
				,fourth_ethnicity_id
				,primary_iwi_id
				,identified_ethnicity_id 
				,[employee_id]
				,[employee_name]
				,[employee_first_name]
				,[employee_middle_name]
				,[employee_last_name]
				,[employee_title]
				,[employee_preferred_name]
				,[employee_employment_status]
				,[employee_nhi_number]
				,[employee_profile_system_id]
				,[employee_workrights_name]
				,[employee_workrights_country]
				,[employee_workrights_expiration_date]
				,[employee_employment_condition] 
				,[employee_primary_email_address]
				,[employee_primary_email_address_ispersonal]
				,[employee_primary_phone_number]
				,[employee_primary_phone_number_fullnumber]
				,[employee_primary_phone_number_ispersonal]
				,[employee_city_value]
				,[employee_address_Type]
				,[employee_full_address]
				,[employee_street_value]
				,[employee_suburb_value]
				,[employee_postcode_value]
				,[employee_is_primary_address_flag]
				,[employee_emergency_contact_name]
				,[employee_next_of_whanau_relationship]
				,[employee_next_of_whanau_phone]
				,[employee_next_of_whanau_email]
				,[employee_company_start_date]
				,[employee_start_date]
				,[employee_company_end_date]
				,[employee_end_date]
				,[employee_position_start_date]
				,[employee_gender]
				,[employee_previous_gender]
				,[employee_previous_gender_valid_to_date]
				,[employee_date_of_birth]
				--,[employee_age_in_year]
				--,[employee_age_group]
				,[employee_longevity]
				,[employee_termination_date]
				,[employee_long_service_recognition_date]
				,[employee_work_type]
				,[employee_work_class]
				,[employee_ethnicity]
				,[employee_pay_grade_name]
				,[employee_remuneration_annual_package]
				,[employee_remuneration_base_annual_salary]
				,[employee_remuneration_base_hourly_rate]
				,[employee_remuneration_schedule_currency]
				,[employee_remuneration_hours_per_cycle]
				,[employee_remuneration_pay_cycle]
				,[employee_remuneration_hourly_package]
				,[employee_leaving_date]
				,[employee_leaving_reason]
				,[employee_leaving_turnover_type]
				,[employee_exemption_granted]
				--,[employee_date_booster_required]
				,[employee_nationality]
				,[employee_company_name]
				,[employee_concurrent_job]
				,[employee_identified_ethnicity]
				--,[employee_date_of_second_vaccination]
				,[employee_hapu_affilitation]
				,[employee_ot_vetting]
				,[employee_preferred_last_name]
				,[employee_annual_practising_cert_expiry_date]
				,[employee_exception_police_vetting_expiry]
				,[employee_mask_exemption]
				,[employee_vaccine_status]
				,[employee_smoking_status]
				,[employee_people_manager_job_status]
				,[employee_people_manager_Job_name]
				,[employee_people_manager_name]
				,[employee_people_manager_id]
				,[employee_ird_number]
				,[employee_job_status]
				,[employee_is_primary_Job_flag]
				,extended_leave_type_name
				,extended_leave_start_date
				,extended_leave_end_date
				,[employee_full_time_equivalent]
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[employee_job_name]
				)
			SELECT em.ethnicity_1 as primary_ethnicity_id
				,em.ethnicity_2 as secondary_ethnicity_id
				,em.ethnicity_3 as tertiary_ethnicity_id
				,em.ethnicity_4 as fourth_ethnicity_id
				,ha.ethnicity_1 as primary_iwi_id
				,pe.ethnicity_1 as identified_ethnicity_id 
				,src.[employee_id]
				,src.[employee_name]
				,src.[employee_first_name]
				,src.[employee_middle_name]
				,src.[employee_last_name]
				,src.[employee_title]
				,src.[employee_preferred_name]
				,src.[employee_employment_status]
				,src.[employee_nhi_number]
				,src.[employee_profile_system_id]
				,src.[employee_workrights_name]
				,src.[employee_workrights_country]
				,src.[employee_workrights_expiration_date]
				,src.[employee_employment_condition] 
				,src.[employee_primary_email_address]
				,src.[employee_primary_email_address_ispersonal]
				,src.[employee_primary_phone_number]
				,src.[employee_primary_phone_number_fullnumber]
				,src.[employee_primary_phone_number_ispersonal]
				,src.[employee_city_value]
				,src.[employee_address_Type]
				,src.[employee_full_address]
				,src.[employee_street_value]
				,src.[employee_suburb_value]
				,src.[employee_postcode_value]
				,src.[employee_is_primary_address_flag]
				,src.[employee_emergency_contact_name]
				,src.[employee_next_of_whanau_relationship]
				,src.[employee_next_of_whanau_phone]
				,src.[employee_next_of_whanau_email]
				,src.[employee_company_start_date]
				,src.[employee_start_date]
				,src.[employee_company_end_date]
				,src.[employee_end_date]
				,src.[employee_position_start_date]
				,src.[employee_gender]
				,src.[employee_gender] AS [employee_previous_gender]
				,convert(DATETIME, '31 December 2999 23:59:59') AS [employee_previous_gender_valid_to_date]
				,src.[employee_date_of_birth]
				--,src.[employee_age_in_year]
				--,src.[employee_age_group]
				,src.[employee_longevity]
				,src.[employee_termination_date]
				,src.[employee_long_service_recognition_date]
				,src.[employee_work_type]
				,src.[employee_work_class]
				,src.[employee_ethnicity]
				,src.[employee_pay_grade_name]
				,src.[employee_remuneration_annual_package]
				,src.[employee_remuneration_base_annual_salary]
				,src.[employee_remuneration_base_hourly_rate]
				,src.[employee_remuneration_schedule_currency]
				,src.[employee_remuneration_hours_per_cycle]
				,src.[employee_remuneration_pay_cycle]
				,src.[employee_remuneration_hourly_package]
				,src.[employee_leaving_date]
				,src.[employee_leaving_reason]
				,src.[employee_leaving_turnover_type]
				,src.[employee_exemption_granted]
				--,src.[employee_date_booster_required]
				,src.[employee_nationality]
				,src.[employee_company_name]
				,src.[employee_concurrent_job]
				,src.[employee_identified_ethnicity]
				--,src.[employee_date_of_second_vaccination]
				,src.[employee_hapu_affilitation]
				,src.[employee_ot_vetting]
				,src.[employee_preferred_last_name]
				,src.[employee_annual_practising_cert_expiry_date]
				,src.[employee_exception_police_vetting_expiry]
				,src.[employee_mask_exemption]
				,src.[employee_vaccine_status]
				,src.[employee_smoking_status]
				,src.[employee_people_manager_job_status]
				,src.[employee_people_manager_Job_name]
				,src.[employee_people_manager_name]
				,src.[employee_people_manager_id]
				,src.[employee_ird_number]
				,src.[employee_job_status]
				,src.[employee_is_primary_Job_flag]
				,src.extended_leave_type_name
				,src.extended_leave_start_date
				,src.extended_leave_end_date
				,src.[employee_full_time_equivalent]
				,src.system_data_source
				--,@SourceSystem AS [DWHSourceSystem]
				,@BatchID AS [DWHBatchId]
				,'I' AS [DWHDMLOperation]
				,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
				,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,1 AS [DWHIsCurrent]
				,src.[employee_job_name]
			FROM [staging].[ODSETLdim_employee] AS src
			left outer join reference.edw_ethnicity_mapping em on replace(replace(src.[employee_ethnicity],nchar(257),'a'),nchar(228),'a') = em.Input_Value and em.Category = 'Ethnicity'
			left outer join reference.edw_ethnicity_mapping ha on replace(replace(src.[employee_hapu_affilitation],nchar(257),'a'),nchar(228),'a') = ha.Input_Value and ha.Category = 'maori_iwi'
			left outer join reference.edw_ethnicity_mapping pe on replace(replace(src.[employee_identified_ethnicity],nchar(257),'a'),nchar(228),'a') = pe.Input_Value and pe.Category = 'Ethnicity'
			;
		END
		ELSE
		BEGIN
			MERGE INTO [edw].[dim_employee] AS trg
			USING (
				SELECT em.ethnicity_1 as primary_ethnicity_id
					,em.ethnicity_2 as secondary_ethnicity_id
					,em.ethnicity_3 as tertiary_ethnicity_id
					,em.ethnicity_4 as fourth_ethnicity_id
					,ha.ethnicity_1 as primary_iwi_id
					,pe.ethnicity_1 as identified_ethnicity_id 
					,src.[employee_id]
					,src.[employee_name]
					,src.[employee_first_name]
					,src.[employee_middle_name]
					,src.[employee_last_name]
					,src.[employee_title]
					,src.[employee_preferred_name]
					,src.[employee_employment_status]
					,src.[employee_nhi_number]
					,src.[employee_profile_system_id]
					,src.[employee_workrights_name]
					,src.[employee_smoking_status]
					,src.[employee_people_manager_job_status]
					,src.[employee_people_manager_Job_name]
					,src.[employee_people_manager_name]
					,src.[employee_people_manager_id]
					,src.[employee_workrights_country]
					,src.[employee_workrights_expiration_date]
					,src.[employee_employment_condition] 
					,src.[employee_primary_email_address]
					,src.[employee_primary_email_address_ispersonal]
					,src.[employee_primary_phone_number]
					,src.[employee_primary_phone_number_fullnumber]
					,src.[employee_primary_phone_number_ispersonal]
					,src.[employee_city_value]
					,src.[employee_address_Type]
					,src.[employee_full_address]
					,src.[employee_street_value]
					,src.[employee_suburb_value]
					,src.[employee_postcode_value]
					,src.[employee_is_primary_address_flag]
					,src.[employee_gender]
					--,src.[employee_age_in_year]
					--,src.[employee_age_group]
					,src.[employee_work_type]
					,src.[employee_work_class]
					,src.[employee_ethnicity]
					,src.[employee_pay_grade_name]
					,src.[employee_remuneration_annual_package]
					,src.[employee_remuneration_base_annual_salary]
					,src.[employee_remuneration_base_hourly_rate]
					,src.[employee_remuneration_schedule_currency]
					,src.[employee_remuneration_hours_per_cycle]
					,src.[employee_remuneration_pay_cycle]
					,src.[employee_remuneration_hourly_package]
					,src.[employee_nationality]
					,src.[employee_company_name]
					,src.[employee_concurrent_job]
					,src.[employee_identified_ethnicity]
					,src.[employee_hapu_affilitation]
					,src.[employee_preferred_last_name]
					,src.[employee_ird_number]
					,src.[employee_job_status]
					,src.[employee_is_primary_Job_flag]
					,src.[employee_full_time_equivalent]
					,src.extended_leave_type_name
					,src.extended_leave_start_date
					,src.extended_leave_end_date
					,src.system_data_source
					--,@SourceSystem AS [DWHSourceSystem]
					,@BatchID AS [DWHBatchId]
					,'I' AS [DWHDMLOperation]
					,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
					,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
					,1 AS [DWHIsCurrent]
					,src.[employee_job_name]
				FROM [staging].[ODSETLdim_employee] AS src
				left outer join reference.edw_ethnicity_mapping em on replace(replace(src.[employee_ethnicity],nchar(257),'a'),nchar(228),'a') = em.Input_Value and em.Category = 'Ethnicity'
				left outer join reference.edw_ethnicity_mapping ha on replace(replace(src.[employee_hapu_affilitation],nchar(257),'a'),nchar(228),'a') = ha.Input_Value and ha.Category = 'maori_iwi'
				left outer join reference.edw_ethnicity_mapping pe on replace(replace(src.[employee_identified_ethnicity],nchar(257),'a'),nchar(228),'a') = pe.Input_Value and pe.Category = 'Ethnicity'
				) AS src
				ON (
						src.[employee_id] = trg.[employee_id]
						AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
						) -- Retire existing records
			WHEN MATCHED
				AND EXISTS (
					SELECT src.primary_ethnicity_id
						,src.secondary_ethnicity_id
						,src.tertiary_ethnicity_id
						,src.fourth_ethnicity_id
						,src.primary_iwi_id
						,src.identified_ethnicity_id 
						,src.[employee_name]
						,src.[employee_first_name]
						,src.[employee_middle_name]
						,src.[employee_last_name]
						,src.[employee_title]
						,src.[employee_preferred_name]
						,src.[employee_employment_status]
						,src.[employee_nhi_number]
						,src.[employee_profile_system_id]
						,src.[employee_workrights_name]
						,src.[employee_smoking_status]
						,src.[employee_people_manager_job_status]
						,src.[employee_people_manager_Job_name]
						,src.[employee_people_manager_name]
						,src.[employee_people_manager_id]
						,src.[employee_workrights_country]
						,src.[employee_workrights_expiration_date]
						,src.[employee_employment_condition] 
						,src.[employee_primary_email_address]
						,src.[employee_primary_email_address_ispersonal]
						,src.[employee_primary_phone_number]
						,src.[employee_primary_phone_number_fullnumber]
						,src.[employee_primary_phone_number_ispersonal]
						,src.[employee_city_value]
						,src.[employee_address_Type]
						,src.[employee_full_address]
						,src.[employee_street_value]
						,src.[employee_suburb_value]
						,src.[employee_postcode_value]
						,src.[employee_is_primary_address_flag]
						,src.[employee_gender]
						--,src.[employee_age_in_year]
						--,src.[employee_age_group]
						,src.[employee_work_type]
						,src.[employee_work_class]
						,src.[employee_ethnicity]
						,src.[employee_pay_grade_name]
						,src.[employee_remuneration_annual_package]
						,src.[employee_remuneration_base_annual_salary]
						,src.[employee_remuneration_base_hourly_rate]
						,src.[employee_remuneration_schedule_currency]
						,src.[employee_remuneration_hours_per_cycle]
						,src.[employee_remuneration_pay_cycle]
						,src.[employee_remuneration_hourly_package]
						,src.[employee_nationality]
						,src.[employee_company_name]
						,src.[employee_concurrent_job]
						,src.[employee_identified_ethnicity]
						,src.[employee_hapu_affilitation]
						,src.[employee_preferred_last_name]
						,src.[employee_ird_number]
						,src.[employee_job_status]
						,src.[employee_is_primary_Job_flag]
						,src.extended_leave_type_name
						,src.extended_leave_start_date
						,src.extended_leave_end_date
						,src.[employee_full_time_equivalent]
						
						,CASE 
							WHEN trg.[DWHDMLOperation] = 'D'
								THEN 'U'
							ELSE 'X'
							END
						,src.[employee_job_name]
											
					EXCEPT
					
					SELECT trg.primary_ethnicity_id
						,trg.secondary_ethnicity_id
						,trg.tertiary_ethnicity_id
						,trg.fourth_ethnicity_id
						,trg.primary_iwi_id
						,trg.identified_ethnicity_id 
						,trg.[employee_name]
						,trg.[employee_first_name]
						,trg.[employee_middle_name]
						,trg.[employee_last_name]
						,trg.[employee_title]
						,trg.[employee_preferred_name]
						,trg.[employee_employment_status]
						,trg.[employee_nhi_number]
						,trg.[employee_profile_system_id]
						,trg.[employee_workrights_name]
						,trg.[employee_smoking_status]
						,trg.[employee_people_manager_job_status]
						,trg.[employee_people_manager_Job_name]
						,trg.[employee_people_manager_name]
						,trg.[employee_people_manager_id]
						,trg.[employee_workrights_country]
						,trg.[employee_workrights_expiration_date]
						,trg.[employee_employment_condition] 
						,trg.[employee_primary_email_address]
						,trg.[employee_primary_email_address_ispersonal]
						,trg.[employee_primary_phone_number]
						,trg.[employee_primary_phone_number_fullnumber]
						,trg.[employee_primary_phone_number_ispersonal]
						,trg.[employee_city_value]
						,trg.[employee_address_Type]
						,trg.[employee_full_address]
						,trg.[employee_street_value]
						,trg.[employee_suburb_value]
						,trg.[employee_postcode_value]
						,trg.[employee_is_primary_address_flag]
						,trg.[employee_gender]
						--,trg.[employee_age_in_year]
						--,trg.[employee_age_group]
						,trg.[employee_work_type]
						,trg.[employee_work_class]
						,trg.[employee_ethnicity]
						,trg.[employee_pay_grade_name]
						,trg.[employee_remuneration_annual_package]
						,trg.[employee_remuneration_base_annual_salary]
						,trg.[employee_remuneration_base_hourly_rate]
						,trg.[employee_remuneration_schedule_currency]
						,trg.[employee_remuneration_hours_per_cycle]
						,trg.[employee_remuneration_pay_cycle]
						,trg.[employee_remuneration_hourly_package]
						,trg.[employee_nationality]
						,trg.[employee_company_name]
						,trg.[employee_concurrent_job]
						,trg.[employee_identified_ethnicity]
						,trg.[employee_hapu_affilitation]
						,trg.[employee_preferred_last_name]
						,trg.[employee_ird_number]
						,trg.[employee_job_status]
						,trg.[employee_is_primary_Job_flag]
						,trg.extended_leave_type_name
						,trg.extended_leave_start_date
						,trg.extended_leave_end_date
						,trg.[employee_full_time_equivalent]
						,'X'
						,trg.[employee_job_name]
					)
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0 -- Soft delete missing records    
			WHEN NOT MATCHED BY source
				AND trg.dim_employee_key > 0
				AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
				AND trg.[DWHDMLOperation] <> 'D'
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0 -- Insert new records   
			WHEN NOT MATCHED BY target
				THEN
					INSERT (primary_ethnicity_id
						,secondary_ethnicity_id
						,tertiary_ethnicity_id
						,fourth_ethnicity_id
						,primary_iwi_id
						,identified_ethnicity_id 
						,[employee_id]
						,[employee_name]
						,[employee_first_name]
						,[employee_middle_name]
						,[employee_last_name]
						,[employee_title]
						,[employee_preferred_name]
						,[employee_employment_status]
						,[employee_nhi_number]
						,[employee_profile_system_id]
						,[employee_workrights_name]
						,[employee_smoking_status]
						,[employee_people_manager_job_status]
						,[employee_people_manager_Job_name]
						,[employee_people_manager_name]
						,[employee_people_manager_id]
						,[employee_workrights_country]
						,[employee_workrights_expiration_date]
						,[employee_employment_condition] 
						,[employee_primary_email_address]
						,[employee_primary_email_address_ispersonal]
						,[employee_primary_phone_number]
						,[employee_primary_phone_number_fullnumber]
						,[employee_primary_phone_number_ispersonal]
						,[employee_city_value]
						,[employee_address_Type]
						,[employee_full_address]
						,[employee_street_value]
						,[employee_suburb_value]
						,[employee_postcode_value]
						,[employee_is_primary_address_flag]
						,[employee_gender]
						--,[employee_age_in_year]
						--,[employee_age_group]
						,[employee_work_type]
						,[employee_work_class]
						,[employee_ethnicity]
						,[employee_pay_grade_name]
						,[employee_remuneration_annual_package]
						,[employee_remuneration_base_annual_salary]
						,[employee_remuneration_base_hourly_rate]
						,[employee_remuneration_schedule_currency]
						,[employee_remuneration_hours_per_cycle]
						,[employee_remuneration_pay_cycle]
						,[employee_remuneration_hourly_package]
						,[employee_nationality]
						,[employee_company_name]
						,[employee_concurrent_job]
						,[employee_identified_ethnicity]
						,[employee_hapu_affilitation]
						,[employee_preferred_last_name]
						,[employee_ird_number]
						,[employee_job_status]
						,[employee_is_primary_Job_flag]
						,extended_leave_type_name
						,extended_leave_start_date
						,extended_leave_end_date
						,[employee_full_time_equivalent]
						,[DWHSourceSystem]
						,[DWHBatchId]
						,[DWHDMLOperation]
						,[DWHEffectiveFrom]
						,[DWHEffectiveTo]
						,[DWHIsCurrent]
						,[employee_job_name]
						)
					VALUES (src.primary_ethnicity_id
						,src.secondary_ethnicity_id
						,src.tertiary_ethnicity_id
						,src.fourth_ethnicity_id
						,src.primary_iwi_id
						,src.identified_ethnicity_id
						,src.[employee_id]
						,src.[employee_name]
						,src.[employee_first_name]
						,src.[employee_middle_name]
						,src.[employee_last_name]
						,src.[employee_title]
						,src.[employee_preferred_name]
						,src.[employee_employment_status]
						,src.[employee_nhi_number]
						,src.[employee_profile_system_id]
						,src.[employee_workrights_name]
						,src.[employee_smoking_status]
						,src.[employee_people_manager_job_status]
						,src.[employee_people_manager_Job_name]
						,src.[employee_people_manager_name]
						,src.[employee_people_manager_id]
						,src.[employee_workrights_country]
						,src.[employee_workrights_expiration_date]
						,src.[employee_employment_condition] 
						,src.[employee_primary_email_address]
						,src.[employee_primary_email_address_ispersonal]
						,src.[employee_primary_phone_number]
						,src.[employee_primary_phone_number_fullnumber]
						,src.[employee_primary_phone_number_ispersonal]
						,src.[employee_city_value]
						,src.[employee_address_Type]
						,src.[employee_full_address]
						,src.[employee_street_value]
						,src.[employee_suburb_value]
						,src.[employee_postcode_value]
						,src.[employee_is_primary_address_flag]
						,src.[employee_gender]
						--,src.[employee_age_in_year]
						--,src.[employee_age_group]
						,src.[employee_work_type]
						,src.[employee_work_class]
						,src.[employee_ethnicity]
						,src.[employee_pay_grade_name]
						,src.[employee_remuneration_annual_package]
						,src.[employee_remuneration_base_annual_salary]
						,src.[employee_remuneration_base_hourly_rate]
						,src.[employee_remuneration_schedule_currency]
						,src.[employee_remuneration_hours_per_cycle]
						,src.[employee_remuneration_pay_cycle]
						,src.[employee_remuneration_hourly_package]
						,src.[employee_nationality]
						,src.[employee_company_name]
						,src.[employee_concurrent_job]
						,src.[employee_identified_ethnicity]
						,src.[employee_hapu_affilitation]
						,src.[employee_preferred_last_name]
						,src.[employee_ird_number]
						,src.[employee_job_status]
						,src.[employee_is_primary_Job_flag]
						,src.extended_leave_type_name
						,src.extended_leave_start_date
						,src.extended_leave_end_date
						,src.[employee_full_time_equivalent]
						
						,src.system_data_source
						--,src.[DWHSourceSystem]
						,src.[DWHBatchId]
						,src.[DWHDMLOperation]
						,src.[DWHEffectiveFrom]
						,src.[DWHEffectiveTo]
						,src.[DWHIsCurrent]
						,src.[employee_job_name]
						)
			OUTPUT coalesce(src.[employee_id], inserted.[employee_id])
				,$ACTION AS [MergeAction]
			INTO #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)    
			INSERT INTO [edw].[dim_employee] 
				(primary_ethnicity_id
				,secondary_ethnicity_id
				,tertiary_ethnicity_id
				,fourth_ethnicity_id
				,primary_iwi_id
				,identified_ethnicity_id
				,[employee_id]
				,[employee_name]
				,[employee_first_name]
				,[employee_middle_name]
				,[employee_last_name]
				,[employee_title]
				,[employee_preferred_name]
				,[employee_employment_status]
				,[employee_nhi_number]
				,[employee_profile_system_id]
				,[employee_workrights_name]
				,[employee_smoking_status]
				,[employee_people_manager_job_status]
				,[employee_people_manager_Job_name]
				,[employee_people_manager_name]
				,[employee_people_manager_id]
				,[employee_workrights_country]
				,[employee_workrights_expiration_date]
				,[employee_employment_condition] 
				,[employee_primary_email_address]
				,[employee_primary_email_address_ispersonal]
				,[employee_primary_phone_number]
				,[employee_primary_phone_number_fullnumber]
				,[employee_primary_phone_number_ispersonal]
				,[employee_city_value]
				,[employee_address_Type]
				,[employee_full_address]
				,[employee_street_value]
				,[employee_suburb_value]
				,[employee_postcode_value]
				,[employee_is_primary_address_flag]
				,[employee_gender]
				--,[employee_age_in_year]
				--,[employee_age_group]
				,[employee_work_type]
				,[employee_work_class]
				,[employee_ethnicity]
				,[employee_pay_grade_name]
				,[employee_remuneration_annual_package]
				,[employee_remuneration_base_annual_salary]
				,[employee_remuneration_base_hourly_rate]
				,[employee_remuneration_schedule_currency]
				,[employee_remuneration_hours_per_cycle]
				,[employee_remuneration_pay_cycle]
				,[employee_remuneration_hourly_package]
				,[employee_nationality]
				,[employee_company_name]
				,[employee_concurrent_job]
				,[employee_identified_ethnicity]
				,[employee_hapu_affilitation]
				,[employee_preferred_last_name]
				,[employee_ird_number]
				,[employee_job_status]
				,[employee_is_primary_Job_flag]
				,extended_leave_type_name
				,extended_leave_start_date
				,extended_leave_end_date
				,[employee_full_time_equivalent]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
				,[employee_job_name]
				)
			SELECT em.ethnicity_1 as primary_ethnicity_id
				,em.ethnicity_2 as secondary_ethnicity_id
				,em.ethnicity_3 as tertiary_ethnicity_id
				,em.ethnicity_4 as fourth_ethnicity_id
				,ha.ethnicity_1 as primary_iwi_id
				,pe.ethnicity_1 as identified_ethnicity_id
				,src.[employee_id]
				,src.[employee_name]
				,src.[employee_first_name]
				,src.[employee_middle_name]
				,src.[employee_last_name]
				,src.[employee_title]
				,src.[employee_preferred_name]
				,src.[employee_employment_status]
				,src.[employee_nhi_number]
				,src.[employee_profile_system_id]
				,src.[employee_workrights_name]
				,src.[employee_smoking_status]
				--,NULL as [employee_previous_gender]
				--,Null as [employee_previous_gender_valid_to_date]
				,src.[employee_people_manager_job_status]
				,src.[employee_people_manager_Job_name]
				,src.[employee_people_manager_name]
				,src.[employee_people_manager_id]
				,src.[employee_workrights_country]
				,src.[employee_workrights_expiration_date]
				,src.[employee_employment_condition] 
				,src.[employee_primary_email_address]
				,src.[employee_primary_email_address_ispersonal]
				,src.[employee_primary_phone_number]
				,src.[employee_primary_phone_number_fullnumber]
				,src.[employee_primary_phone_number_ispersonal]
				,src.[employee_city_value]
				,src.[employee_address_Type]
				,src.[employee_full_address]
				,src.[employee_street_value]
				,src.[employee_suburb_value]
				,src.[employee_postcode_value]
				,src.[employee_is_primary_address_flag]
				,src.[employee_gender]
				--,src.[employee_age_in_year]
				--,src.[employee_age_group]
				,src.[employee_work_type]
				,src.[employee_work_class]
				,src.[employee_ethnicity]
				,src.[employee_pay_grade_name]
				,src.[employee_remuneration_annual_package]
				,src.[employee_remuneration_base_annual_salary]
				,src.[employee_remuneration_base_hourly_rate]
				,src.[employee_remuneration_schedule_currency]
				,src.[employee_remuneration_hours_per_cycle]
				,src.[employee_remuneration_pay_cycle]
				,src.[employee_remuneration_hourly_package]
				,src.[employee_nationality]
				,src.[employee_company_name]
				,src.[employee_concurrent_job]
				,src.[employee_identified_ethnicity]
				,src.[employee_hapu_affilitation]
				,src.[employee_preferred_last_name]
				,src.[employee_ird_number]
				,src.[employee_job_status]
				,src.[employee_is_primary_Job_flag]
				,src.extended_leave_type_name
				,src.extended_leave_start_date
				,src.extended_leave_end_date
				,src.[employee_full_time_equivalent]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				--,'[staging].[ODSETLdim_employee]'
				,src.system_data_source
				,'U'
				,src.[employee_job_name]
			FROM #SummaryOfChanges AS base
			INNER JOIN [staging].[ODSETLdim_employee] AS src ON src.[employee_id] = base.[employee_id]
			left outer join reference.edw_ethnicity_mapping em on replace(replace(src.[employee_ethnicity],nchar(257),'a'),nchar(228),'a') = em.Input_Value and em.Category = 'Ethnicity'
			left outer join reference.edw_ethnicity_mapping ha on replace(replace(src.[employee_hapu_affilitation],nchar(257),'a'),nchar(228),'a') = ha.Input_Value and ha.Category = 'maori_iwi'
			left outer join reference.edw_ethnicity_mapping pe on replace(replace(src.[employee_identified_ethnicity],nchar(257),'a'),nchar(228),'a') = pe.Input_Value and pe.Category = 'Ethnicity'


			WHERE base.[MergeAction] = 'UPDATE'
				AND base.[employee_id] <> 0
			
			UNION ALL
			
			SELECT tbl.primary_ethnicity_id
				,tbl.secondary_ethnicity_id
				,tbl.tertiary_ethnicity_id
				,tbl.fourth_ethnicity_id
				,tbl.primary_iwi_id
				,tbl.identified_ethnicity_id
				,tbl.[employee_id]
				,tbl.[employee_name]
				,tbl.[employee_first_name]
				,tbl.[employee_middle_name]
				,tbl.[employee_last_name]
				,tbl.[employee_title]
				,tbl.[employee_preferred_name]
				,tbl.[employee_employment_status]
				,tbl.[employee_nhi_number]
				,tbl.[employee_profile_system_id]
				,tbl.[employee_workrights_name]
				,tbl.[employee_smoking_status]
				--,tbl.[employee_previous_gender]
				--,tbl.[employee_previous_gender_valid_to_date]
				,tbl.[employee_people_manager_job_status]
				,tbl.[employee_people_manager_Job_name]
				,tbl.[employee_people_manager_name]
				,tbl.[employee_people_manager_id]
				,tbl.[employee_workrights_country]
				,tbl.[employee_workrights_expiration_date]
				,tbl.[employee_employment_condition] 
				,tbl.[employee_primary_email_address]
				,tbl.[employee_primary_email_address_ispersonal]
				,tbl.[employee_primary_phone_number]
				,tbl.[employee_primary_phone_number_fullnumber]
				,tbl.[employee_primary_phone_number_ispersonal]
				,tbl.[employee_city_value]
				,tbl.[employee_address_Type]
				,tbl.[employee_full_address]
				,tbl.[employee_street_value]
				,tbl.[employee_suburb_value]
				,tbl.[employee_postcode_value]
				,tbl.[employee_is_primary_address_flag]
				,tbl.[employee_gender]
				--,tbl.[employee_age_in_year]
				--,tbl.[employee_age_group]
				,tbl.[employee_work_type]
				,tbl.[employee_work_class]
				,tbl.[employee_ethnicity]
				,tbl.[employee_pay_grade_name]
				,tbl.[employee_remuneration_annual_package]
				,tbl.[employee_remuneration_base_annual_salary]
				,tbl.[employee_remuneration_base_hourly_rate]
				,tbl.[employee_remuneration_schedule_currency]
				,tbl.[employee_remuneration_hours_per_cycle]
				,tbl.[employee_remuneration_pay_cycle]
				,tbl.[employee_remuneration_hourly_package]
				,tbl.[employee_nationality]
				,tbl.[employee_company_name]
				,tbl.[employee_concurrent_job]
				,tbl.[employee_identified_ethnicity]
				,tbl.[employee_hapu_affilitation]
				,tbl.[employee_preferred_last_name]
				,tbl.[employee_ird_number]
				,tbl.[employee_job_status]
				,tbl.[employee_is_primary_Job_flag]
				,tbl.extended_leave_type_name
				,tbl.extended_leave_start_date
				,tbl.extended_leave_end_date
				,tbl.[employee_full_time_equivalent]
				
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				--,'[staging].[ODSETLdim_employee]'
				,tbl.DWHSourceSystem
				,'D'
				,tbl.[employee_job_name]
			FROM #SummaryOfChanges AS base
			INNER JOIN [edw].[dim_employee] AS tbl ON tbl.[employee_id] = base.[employee_id]
				AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			LEFT JOIN [staging].[ODSETLdim_employee] AS src ON src.[employee_id] = base.[employee_id]
			WHERE base.[MergeAction] = 'UPDATE'
				AND base.[employee_id] <> 0
				AND src.[employee_id] IS NULL;
		END;


		---Apply SCD Type 1 change in Dimension table 
		UPDATE dim
			SET primary_ethnicity_id = em.ethnicity_1
			,secondary_ethnicity_id = em.ethnicity_2
			,tertiary_ethnicity_id = em.ethnicity_3
			,fourth_ethnicity_id = em.ethnicity_4
			,primary_iwi_id = ha.ethnicity_1
			,identified_ethnicity_id = pe.ethnicity_1
			,[employee_emergency_contact_name] = stg.[employee_emergency_contact_name]
			,[employee_next_of_whanau_relationship] = stg.[employee_next_of_whanau_relationship]
			,[employee_next_of_whanau_phone] = stg.[employee_next_of_whanau_phone]
			,[employee_next_of_whanau_email] = stg.[employee_next_of_whanau_email]
			,[employee_company_start_date] = stg.[employee_company_start_date]
			,[employee_start_date] = stg.[employee_start_date]
			,[employee_company_end_date] = stg.[employee_company_end_date]
			,[employee_end_date] = stg.[employee_end_date]
			,[employee_position_start_date] = stg.[employee_position_start_date]
			,[employee_annual_practising_cert_expiry_date] = stg.[employee_annual_practising_cert_expiry_date]
			,[employee_exception_police_vetting_expiry] = stg.[employee_exception_police_vetting_expiry]
			,[employee_date_of_birth] = stg.[employee_date_of_birth]
			,[employee_longevity] = stg.[employee_longevity]
			,[employee_termination_date] = stg.[employee_termination_date]
			,[employee_long_service_recognition_date] = stg.[employee_long_service_recognition_date]
			,[employee_leaving_date] = stg.[employee_leaving_date]
			,[employee_leaving_reason] = stg.[employee_leaving_reason]
			,[employee_leaving_turnover_type] = stg.[employee_leaving_turnover_type]
			,[employee_exemption_granted] = stg.[employee_exemption_granted]
			,[employee_employment_condition] = stg.[employee_employment_condition] 
			--[employee_date_booster_required]=stg.[employee_date_booster_required],
			--[employee_date_of_second_vaccination]=stg.[employee_date_of_second_vaccination],
			,[employee_ot_vetting] = stg.[employee_ot_vetting]
			,[employee_mask_exemption] = stg.[employee_mask_exemption]
			,[employee_vaccine_status] = stg.[employee_vaccine_status]
			,[employee_ird_number] = stg.[employee_ird_number]
			,[employee_job_status] = stg.[employee_job_status]
			,[employee_full_time_equivalent]=stg.[employee_full_time_equivalent]
			,[employee_job_name] = stg.[employee_job_name]
			,extended_leave_type_name = stg.extended_leave_type_name
			,extended_leave_start_date = stg.extended_leave_start_date
			,extended_leave_end_date = stg.extended_leave_end_date
			,employee_profile_system_id = stg.employee_profile_system_id

			
		FROM [staging].[ODSETLdim_employee] AS stg
		JOIN [edw].[dim_employee] dim ON dim.[employee_id] = stg.[employee_id]
		left outer join reference.edw_ethnicity_mapping em on replace(replace(stg.[employee_ethnicity],nchar(257),'a'),nchar(228),'a') = em.Input_Value and em.Category = 'Ethnicity'
		left outer join reference.edw_ethnicity_mapping ha on replace(replace(stg.[employee_hapu_affilitation],nchar(257),'a'),nchar(228),'a') = ha.Input_Value and ha.Category = 'maori_iwi'
		left outer join reference.edw_ethnicity_mapping pe on replace(replace(stg.[employee_identified_ethnicity],nchar(257),'a'),nchar(228),'a') = pe.Input_Value and pe.Category = 'Ethnicity'
		WHERE dim.[DWHIsCurrent] = 1

		---Apply SCD Type 3 change in Dimension table 
		IF (object_id('tempdb..#scdtype3') IS NOT NULL)
			DROP TABLE #scdtype3;

		CREATE TABLE #scdtype3 (
			dim_employee_key INT NOT NULL
			,employee_id INT NOT NULL
			,employee_previous_gender NVARCHAR(100)
			,employee_current_gender NVARCHAR(100)
			,DWHEffectiveFrom DATETIME2
			,DWHEffectiveTo DATETIME2
			,DWHIsCurrent CHAR
			);

		INSERT INTO #scdtype3
		SELECT dim_employee_key
			,dim.employee_id
			,dim.employee_gender AS employee_previous_gender
			,stg.employee_gender AS employee_current_gender
			,dim.[DWHEffectiveFrom]
			,dim.[DWHEffectiveTo]
			,dim.[DWHIsCurrent]
		FROM [edw].[dim_employee] AS dim
		INNER JOIN [staging].[ODSETLdim_employee] AS stg ON dim.[employee_id] = stg.[employee_id]
		WHERE isnull(dim.[employee_gender], '') <> isnull(stg.[employee_gender], '')

		UPDATE dim
		SET dim.[employee_gender] = stg.[employee_gender]
			,dim.employee_previous_gender = stg.[employee_gender]
			,dim.[employee_previous_gender_valid_to_date] = convert(DATETIME2, '31 December 2999 23:59:59')
		FROM [edw].[dim_employee] AS dim
		INNER JOIN [edw].[dim_employee] AS stg ON (dim.[employee_id] = stg.[employee_id])
		WHERE isnull(dim.[employee_gender], '') <> isnull(stg.[employee_previous_gender], '')
			AND stg.DWHIsCurrent = 1

		UPDATE dim
		SET dim.[employee_gender] = stg.[employee_current_gender]
			,dim.employee_previous_gender = stg.employee_previous_gender
			,dim.[employee_previous_gender_valid_to_date] = DATEADD(day, - 1, CAST(GETDATE() AS DATETIME2))
		FROM [edw].[dim_employee] AS dim
		INNER JOIN #scdtype3 AS stg ON (dim.[employee_id] = stg.[employee_id])
		WHERE dim.DWHIsCurrent <> 1

		UPDATE dim
		SET dim.[employee_gender] = stg.[employee_current_gender]
			,dim.employee_previous_gender = stg.[employee_current_gender]
			,dim.[employee_previous_gender_valid_to_date] = convert(DATETIME2, '31 December 2999 23:59:59')
		FROM [edw].[dim_employee] AS dim
		INNER JOIN #scdtype3 AS stg ON (dim.[employee_id] = stg.[employee_id])
		WHERE dim.DWHIsCurrent = 1


		-- Get process counts  
		SELECT @targetRecords = count(1)
			,@insertedRecords = sum(CASE 
					WHEN [DWHDMLOperation] = 'I'
						AND [DWHBatchId] = @BatchID
						THEN 1
					ELSE 0
					END)
			,@updatedRecords = isnull(@updatedRecords, 0) + sum(CASE 
					WHEN [DWHDMLOperation] = 'U'
						AND [DWHBatchId] = @BatchID
						THEN 1
					ELSE 0
					END)
			,@deletedRecords = sum(CASE 
					WHEN [DWHDMLOperation] = 'D'
						AND [DWHBatchId] = @BatchID
						THEN 1
					ELSE 0
					END)
		FROM [edw].[dim_employee]
		WHERE [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

		COMMIT TRANSACTION;
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION;

		SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		SET @pInsertRecords = @insertedRecords;
		SET @pUpdateRecords = @updatedRecords;
		SET @pDeleteRecords = @deletedRecords;
		SET @pCompleted = 0;
		SET @pTargetRecords = @targetRecords;
		SET @pErrorMessage = ERROR_MESSAGE();

		IF (@pOutputParamsAsDataset = 1)
		BEGIN -- Select return parameters as a dataset   
			SELECT @pErrorRecords AS ErrorRecords
				,@pInsertRecords AS InsertRecords
				,@pUpdateRecords AS UpdateRecords
				,@pDeleteRecords AS DeleteRecords
				,@pCompleted AS Completed
				,@targetRecords AS TargetRecords
				,@pErrorMessage AS ErrorMessage;
		END;

		throw;
	END CATCH

	SET @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
	SET @pInsertRecords = @insertedRecords;
	SET @pUpdateRecords = @updatedRecords;
	SET @pDeleteRecords = @deletedRecords;
	SET @pCompleted = 1;
	SET @pTargetRecords = @targetRecords;

	IF (@pOutputParamsAsDataset = 1)
	BEGIN -- Select return parameters as a dataset
		SELECT @pErrorRecords AS ErrorRecords
			,@pInsertRecords AS InsertRecords
			,@pUpdateRecords AS UpdateRecords
			,@pDeleteRecords AS DeleteRecords
			,@pCompleted AS Completed
			,@targetRecords AS TargetRecords
			,@pErrorMessage AS ErrorMessage;
	END;
END;