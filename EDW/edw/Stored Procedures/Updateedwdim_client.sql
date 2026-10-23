
CREATE PROCEDURE [edw].[Updateedwdim_client] @pBatchID INT
	,@pIndexRebuildThreshold INT
	,@pOutputParamsAsDataset INT = 0
	,@pErrorRecords INT = NULL OUTPUT
	,@pInsertRecords INT = NULL OUTPUT
	,@pUpdateRecords INT = NULL OUTPUT
	,@pDeleteRecords INT = NULL OUTPUT
	,@pCompleted INT = NULL OUTPUT
	,@pTargetRecords INT = NULL OUTPUT
	,@pErrorMessage VARCHAR(MAX) = NULL OUTPUT
AS

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_client] 
 Author		
 Created		
 Purpose		
	
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

 REVISIONS:
 Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
 1.0		?				?					Initial creation of stored procedure
 1.1		2023-08-23		Glenn McLeod		Altered to stop 0 record [DWHEffectiveTo] from being update
 1.11	2023-08-24		Glenn McLeod		Updated table/column names
 1.12	2023-09-08		Glenn McLeod		Added merge filter to prevent historic records getting updated.
											Removed incorrect calculation for flag date fields, logic is now in [staging].[insert_staging_dim_client].
											Updated original record to set [DWHEffectiveFrom] value to '1 January 1900', some fact tables were not linking correctly
 1.2		2023-09-25		Glenn McLeod		Add -1 record of for Unknown and updated 0 record to be N/A
 1.2		2024-02-22		Glenn McLeod		User Story 7161: removed incorrectly named flag columns and moved the updated logic into view [edw].[vw_dim_client]
 1.3		2024-11-12		Greg Nuthall		Added ethnicity fields
 1.4        2026-03-10      Greg Nuthall		Changed so it adds 'D' records by comparing the system date @SystemEffectiveTo --@SystemDefaultEffectiveTo
 **********************************************************************************************************/

BEGIN
	SET NOCOUNT ON;
	SET XACT_ABORT ON;

	-- Variables
	DECLARE @batchID INT = @pBatchID;
	DECLARE @SourceSystem NVARCHAR(120) = '[ETL].[dim_client]';
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

	IF (object_id('tempdb..#SummaryOfChanges') IS NOT NULL)
		DROP TABLE #SummaryOfChanges;

	CREATE TABLE #SummaryOfChanges (
		[dim_client_unique_key] VARCHAR(200) NOT NULL
		,[MergeAction] VARCHAR(10)
		);

	BEGIN TRANSACTION;

	BEGIN TRY
		IF (
				NOT EXISTS (
					SELECT 1
					FROM [edw].[dim_client]
					WHERE dim_client_key <= 0
					)
				)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_client] ON

			INSERT INTO [edw].[dim_client] (
				[dim_client_key]
				,[company_id]
				,[dim_client_unique_key]
				,[client_id]
				,[client_display_name]
				,[client_first_name]
				,[client_middle_name]
				,[client_last_name]
				,[client_preferred_name]
				,[client_created_date]
				,[client_status_is_active]
				,primary_ethnicity_id
				,secondary_ethnicity_id
				,tertiary_ethnicity_id
				,fourth_ethnicity_id
				,primary_iwi_id
				,secondary_iwi_id
				,tertiary_iwi_id
				,fourth_iwi_id
				,priority_ethnicity_id

				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				)
			VALUES 
				(
				0
				,0
				,'N/A'
				,0
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'29991231'
				,'N/A'
				,99999
				,null
				,null
				,null
				,99999
				,null
				,null
				,null
				,99999
				,'[edw].[dim_client]'
				,0
				,'I'
				,@SystemDefaultEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				),
				(
				-1
				,-1
				,'Unknown'
				,-1
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'29991231'
				,'Unknown'
				,99999
				,null
				,null
				,null
				,99999
				,null
				,null
				,null
				,99999
				,'[edw].[dim_client]'
				,0
				,'I'
				,@SystemDefaultEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				)

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_client] OFF
		END

		-- Do not run if there are no records in source
		SELECT @stagedRecords = count(1)
		FROM [Staging].[ODSETLdim_client];

		IF (@stagedRecords = 0)
		BEGIN
			SELECT @targetRecords = count(1)
			FROM [edw].[dim_client];

			-- Select success details
			SELECT @pErrorRecords = 0
				,@pInsertRecords = 0
				,@pUpdateRecords = 0
				,@pDeleteRecords = 0
				,@pCompleted = 1
				,@pTargetRecords = @targetRecords

			IF (@pOutputParamsAsDataset = 1)
			BEGIN
				-- Select return parameters as a dataset
				SELECT @pErrorRecords AS ErrorRecords
					,@pInsertRecords AS InsertRecords
					,@pUpdateRecords AS UpdateRecords
					,@pDeleteRecords AS DeleteRecords
					,@pCompleted AS Completed
					,@targetRecords AS TargetRecords
					,@pErrorMessage AS ErrorMessage;
			END;

			RETURN;
		END;

		IF (
				NOT EXISTS (
					SELECT TOP (1) 1
					FROM [edw].[dim_client]
					WHERE dim_client_key > 0
					)
				)
		BEGIN
			-- There are no records in the target; insert all
			INSERT INTO [edw].[dim_client] (
				[company_id]
				,[dim_client_unique_key]
				,[client_id]
				,[client_display_name]
				,[client_first_name]
				,[client_middle_name]
				,[client_last_name]
				,[client_preferred_name]
				,[client_nhi_number]
				,[client_created_date]
				,[client_address_missing_flag]
				,[client_address_missing_flag_date]
				,[client_address_name]
				,[client_address_line1]
				,[client_address_line2]
				,[client_address_line3]
				,[client_address_suburb]
				,[client_address_town_or_city]
				,[client_address_post_code]
				,[client_contact_phone_missing_flag]
				,[client_contact_phone_missing_flag_date]
				,[client_contact_home_phone]
				,[client_contact_work_phone]
				,[client_contact_mobile_phone]
				,[client_contact_fax]
				,[client_contact_pager]
				,[client_contact_other]
				--,[client_emergency_contact_flag]
				,[client_emergency_contact_phone]
				,[client_email]
				,[client_primary_iwi]
				,[client_primary_region]
				,[client_primary_waka_iwi_unknown_flag]
				,[client_primary_ethnicity]
				,[client_secondary_iwi]
				,[client_secondary_region]
				,[client_secondary_waka_iwi_unknown_flag]
				,[client_secondary_ethnicity]
				,[client_tertiary_iwi]
				,[client_tertiary_region]
				,[client_tertiary_waka_iwi_unknown_flag]
				,[client_tertiary_ethnicity]
				,[client_maori_flag]
				,[client_pasifika_flag]
				,[client_ethnicity_group]
				,[client_gender]
				,[client_date_of_birth]
				,[client_date_of_death]
				,[client_age_years]
				,[client_smoking_status]
				,[client_smoking_cigarettes_per_day]
				,[client_smoking_assessment_date]
				,[client_legal_status_missing_flag]
				,[client_legal_status]
				--,[client_mental_health_condition_flag]
				,[client_mental_health_condition]
				--,[client_physical_health_condition_flag]
				,[client_physical_condition]
				--,[client_substance_use_flag]
				,[client_substance_condition]
				,[client_smoking_status_missing_flag]
				,[client_smoking_advice_flag]
				,[client_smoking_cessation_referral_flag]
				,[client_primhd_review_missing_flag]
				,[client_primhd_review_overdue_flag]
				,[client_primhd_review_due_soon_flag]
				,[client_primhd_review_current_flag]
				,[client_gp_only_missing_flag]
				,[client_gp_registration_missing_flag]
				,[client_residency_status]
				,[client_status_is_active]
				,[client_status_is_active_date]
				,[client_smoking_last_assessment_flag]
				,primary_ethnicity_id
				,secondary_ethnicity_id
				,tertiary_ethnicity_id
				,fourth_ethnicity_id
				,primary_iwi_id
				,secondary_iwi_id
				,tertiary_iwi_id
				,fourth_iwi_id
				,priority_ethnicity_id
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				)
			SELECT src.[company_id]
				,src.[dim_client_unique_key]
				,src.[client_id]
				,src.[client_display_name]
				,src.[client_first_name]
				,src.[client_middle_name]
				,src.[client_last_name]
				,src.[client_preferred_name]
				,src.[client_nhi_number]
				,src.[client_created_date]
				,src.[client_address_missing_flag]
				--,CONVERT(datetime,'1 January 1900')
				,src.[client_address_missing_flag_date]
				,src.[client_address_name]
				,src.[client_address_line1]
				,src.[client_address_line2]
				,src.[client_address_line3]
				,src.[client_address_suburb]
				,src.[client_address_town_or_city]
				,src.[client_address_post_code]
				,src.[client_contact_phone_missing_flag]
				--,CONVERT(datetime,'1 January 1900')
				,src.[client_contact_phone_missing_flag_date]
				,src.[client_contact_home_phone]
				,src.[client_contact_work_phone]
				,src.[client_contact_mobile_phone]
				,src.[client_contact_fax]
				,src.[client_contact_pager]
				,src.[client_contact_other]
				--,src.[client_emergency_contact_flag]
				,src.[client_emergency_contact_phone]
				,src.[client_email]
				,src.[client_primary_iwi]
				,src.[client_primary_region]
				,src.[client_primary_waka_iwi_unknown_flag]
				,src.[client_primary_ethnicity]
				,src.[client_secondary_iwi]
				,src.[client_secondary_region]
				,src.[client_secondary_waka_iwi_unknown_flag]
				,src.[client_secondary_ethnicity]
				,src.[client_tertiary_iwi]
				,src.[client_tertiary_region]
				,src.[client_tertiary_waka_iwi_unknown_flag]
				,src.[client_tertiary_ethnicity]
				,src.[client_maori_flag]
				,src.[client_pasifika_flag]
				,src.[client_ethnicity_group]
				,src.[client_gender]
				,src.[client_date_of_birth]
				,src.[client_date_of_death]
				,src.[client_age_years]
				,src.[client_smoking_status]
				,src.[client_smoking_cigarettes_per_day]
				,src.[client_smoking_assessment_date]
				,src.[client_legal_status_missing_flag]
				,src.[client_legal_status]
				--,src.[client_mental_health_condition_flag]
				,src.[client_mental_health_condition]
				--,src.[client_physical_health_condition_flag]
				,src.[client_physical_condition]
				--,src.[client_substance_use_flag]
				,src.[client_substance_condition]
				,src.[client_smoking_status_missing_flag]
				,src.[client_smoking_advice_flag]
				,src.[client_smoking_cessation_referral_flag]
				,src.[client_primhd_review_missing_flag]
				,src.[client_primhd_review_overdue_flag]
				,src.[client_primhd_review_due_soon_flag]
				,src.[client_primhd_review_current_flag]
				,src.[client_gp_only_missing_flag]
				,src.[client_gp_registration_missing_flag]
				,src.[client_residency_status]
				,src.[client_status_is_active]
				-- ,CONVERT(datetime,'1 January 1900')
				,src.[client_status_is_active_date]
				,src.[client_smoking_last_assessment_flag]
				,src.primary_ethnicity_id
				,src.secondary_ethnicity_id
				,src.tertiary_ethnicity_id
				,src.fourth_ethnicity_id
				,src.primary_iwi_id
				,src.secondary_iwi_id
				,src.tertiary_iwi_id
				,src.fourth_iwi_id
				,src.priority_ethnicity_id
				,@BatchID AS [DWHBatchId]
				,@SystemDefaultEffectiveFrom AS [DWHEffectiveFrom]
				,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
				,'I' AS [DWHDMLOperation]
				,1 AS [DWHIsCurrent]
				,@SourceSystem AS [DWHSourceSystem]
			FROM [Staging].[ODSETLdim_client] AS src;
		END
		ELSE
		BEGIN
			MERGE INTO [edw].[dim_client] AS trg
			USING (
				SELECT src.[company_id]
					,src.[dim_client_unique_key]
					,src.[client_id]
					,src.[client_display_name]
					,src.[client_first_name]
					,src.[client_middle_name]
					,src.[client_last_name]
					,src.[client_preferred_name]
					,src.[client_nhi_number]
					,src.[client_created_date]
					,src.[client_address_missing_flag]
					,src.[client_address_missing_flag_date]
					--,CONVERT(datetime,'1 January 1900') as [client_address_missing_flag_date]
					,src.[client_address_name]
					,src.[client_address_line1]
					,src.[client_address_line2]
					,src.[client_address_line3]
					,src.[client_address_suburb]
					,src.[client_address_town_or_city]
					,src.[client_address_post_code]
					,src.[client_contact_phone_missing_flag]
					,src.[client_contact_phone_missing_flag_date]
					--,CONVERT(datetime,'1 January 1900') as [client_contact_phone_missing_flag_date]
					,src.[client_contact_home_phone]
					,src.[client_contact_work_phone]
					,src.[client_contact_mobile_phone]
					,src.[client_contact_fax]
					,src.[client_contact_pager]
					,src.[client_contact_other]
					--,src.[client_emergency_contact_flag]
					,src.[client_emergency_contact_phone]
					,src.[client_email]
					,src.[client_primary_iwi]
					,src.[client_primary_region]
					,src.[client_primary_waka_iwi_unknown_flag]
					,src.[client_primary_ethnicity]
					,src.[client_secondary_iwi]
					,src.[client_secondary_region]
					,src.[client_secondary_waka_iwi_unknown_flag]
					,src.[client_secondary_ethnicity]
					,src.[client_tertiary_iwi]
					,src.[client_tertiary_region]
					,src.[client_tertiary_waka_iwi_unknown_flag]
					,src.[client_tertiary_ethnicity]
					,src.[client_maori_flag]
					,src.[client_pasifika_flag]
					,src.[client_ethnicity_group]
					,src.[client_gender]
					,src.[client_date_of_birth]
					,src.[client_date_of_death]
					,src.[client_age_years]
					,src.[client_smoking_status]
					,src.[client_smoking_cigarettes_per_day]
					,src.[client_smoking_assessment_date]
					,src.[client_legal_status_missing_flag]
					,src.[client_legal_status]
					--,src.[client_mental_health_condition_flag]
					,src.[client_mental_health_condition]
					--,src.[client_physical_health_condition_flag]
					,src.[client_physical_condition]
					--,src.[client_substance_use_flag]
					,src.[client_substance_condition]
					,src.[client_smoking_status_missing_flag]
					,src.[client_smoking_advice_flag]
					,src.[client_smoking_cessation_referral_flag]
					,src.[client_primhd_review_missing_flag]
					,src.[client_primhd_review_overdue_flag]
					,src.[client_primhd_review_due_soon_flag]
					,src.[client_primhd_review_current_flag]
					,src.[client_gp_only_missing_flag]
					,src.[client_gp_registration_missing_flag]
					,src.[client_residency_status]
					,src.[client_status_is_active]
					,src.[client_status_is_active_date]
					--,CONVERT(datetime,'1 January 1900') as [client_status_is_active_date]
					,src.[client_smoking_last_assessment_flag]
					,src.primary_ethnicity_id
					,src.secondary_ethnicity_id
					,src.tertiary_ethnicity_id
					,src.fourth_ethnicity_id
					,src.primary_iwi_id
					,src.secondary_iwi_id
					,src.tertiary_iwi_id
					,src.fourth_iwi_id
					,src.priority_ethnicity_id
					,@BatchID AS [DWHBatchId]
					,convert(DATETIME, '1 January 1900') AS [DWHEffectiveFrom]
					,convert(DATETIME, '31 December 2999 23:59:59') AS [DWHEffectiveTo]
					,'I' AS [DWHDMLOperation]
					,1 AS [DWHIsCurrent]
					,@SourceSystem AS [DWHSourceSystem]
				FROM [Staging].[ODSETLdim_client] AS src
				) AS src
				ON (
						src.[dim_client_unique_key] = trg.[dim_client_unique_key] collate database_default
						AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
						) -- Retire existing records

			WHEN MATCHED
				AND EXISTS (
					SELECT src.[company_id]
						,src.[dim_client_unique_key]
						,src.[client_id]
						,src.[client_display_name]
						,src.[client_first_name]
						,src.[client_middle_name]
						,src.[client_last_name]
						,src.[client_preferred_name]
						,src.[client_nhi_number]
						,src.[client_created_date]
						,src.[client_address_missing_flag]
						,src.[client_address_missing_flag_date]
						,src.[client_address_name]
						,src.[client_address_line1]
						,src.[client_address_line2]
						,src.[client_address_line3]
						,src.[client_address_suburb]
						,src.[client_address_town_or_city]
						,src.[client_address_post_code]
						,src.[client_contact_phone_missing_flag]
						,src.[client_contact_phone_missing_flag_date]
						,src.[client_contact_home_phone]
						,src.[client_contact_work_phone]
						,src.[client_contact_mobile_phone]
						,src.[client_contact_fax]
						,src.[client_contact_pager]
						,src.[client_contact_other]
						--,src.[client_emergency_contact_flag]
						,src.[client_emergency_contact_phone]
						,src.[client_email]
						,src.[client_primary_iwi]
						,src.[client_primary_region]
						,src.[client_primary_waka_iwi_unknown_flag]
						,src.[client_primary_ethnicity]
						,src.[client_secondary_iwi]
						,src.[client_secondary_region]
						,src.[client_secondary_waka_iwi_unknown_flag]
						,src.[client_secondary_ethnicity]
						,src.[client_tertiary_iwi]
						,src.[client_tertiary_region]
						,src.[client_tertiary_waka_iwi_unknown_flag]
						,src.[client_tertiary_ethnicity]
						,src.[client_maori_flag]
						,src.[client_pasifika_flag]
						,src.[client_ethnicity_group]
						,src.[client_gender]
						,src.[client_date_of_birth]
						,src.[client_date_of_death]
						,src.[client_age_years]
						,src.[client_smoking_status]
						,src.[client_smoking_cigarettes_per_day]
						,src.[client_smoking_assessment_date]
						,src.[client_legal_status_missing_flag]
						,src.[client_legal_status]
						--,src.[client_mental_health_condition_flag]
						,src.[client_mental_health_condition]
						--,src.[client_physical_health_condition_flag]
						,src.[client_physical_condition]
						--,src.[client_substance_use_flag]
						,src.[client_substance_condition]
						,src.[client_smoking_status_missing_flag]
						,src.[client_smoking_advice_flag]
						,src.[client_smoking_cessation_referral_flag]
						,src.[client_primhd_review_missing_flag]
						,src.[client_primhd_review_overdue_flag]
						,src.[client_primhd_review_due_soon_flag]
						,src.[client_primhd_review_current_flag]
						,src.[client_gp_only_missing_flag]
						,src.[client_gp_registration_missing_flag]
						,src.[client_residency_status]
						,src.[client_status_is_active]
						,src.[client_status_is_active_date]
						,src.[client_smoking_last_assessment_flag]
						,src.primary_ethnicity_id
						,src.secondary_ethnicity_id
						,src.tertiary_ethnicity_id
						,src.fourth_ethnicity_id
						,src.primary_iwi_id
						,src.secondary_iwi_id
						,src.tertiary_iwi_id
						,src.fourth_iwi_id
						,src.priority_ethnicity_id
						,CASE 
							WHEN trg.[DWHDMLOperation] = 'D'
								THEN 'U'
							ELSE 'X'
							END
					
					EXCEPT
					
					SELECT trg.[company_id]
						,trg.[dim_client_unique_key]
						,trg.[client_id]
						,trg.[client_display_name]
						,trg.[client_first_name]
						,trg.[client_middle_name]
						,trg.[client_last_name]
						,trg.[client_preferred_name]
						,trg.[client_nhi_number]
						,trg.[client_created_date]
						,trg.[client_address_missing_flag]
						,trg.[client_address_missing_flag_date]
						,trg.[client_address_name]
						,trg.[client_address_line1]
						,trg.[client_address_line2]
						,trg.[client_address_line3]
						,trg.[client_address_suburb]
						,trg.[client_address_town_or_city]
						,trg.[client_address_post_code]
						,trg.[client_contact_phone_missing_flag]
						,trg.[client_contact_phone_missing_flag_date]
						,trg.[client_contact_home_phone]
						,trg.[client_contact_work_phone]
						,trg.[client_contact_mobile_phone]
						,trg.[client_contact_fax]
						,trg.[client_contact_pager]
						,trg.[client_contact_other]
						--,trg.[client_emergency_contact_flag]
						,trg.[client_emergency_contact_phone]
						,trg.[client_email]
						,trg.[client_primary_iwi]
						,trg.[client_primary_region]
						,trg.[client_primary_waka_iwi_unknown_flag]
						,trg.[client_primary_ethnicity]
						,trg.[client_secondary_iwi]
						,trg.[client_secondary_region]
						,trg.[client_secondary_waka_iwi_unknown_flag]
						,trg.[client_secondary_ethnicity]
						,trg.[client_tertiary_iwi]
						,trg.[client_tertiary_region]
						,trg.[client_tertiary_waka_iwi_unknown_flag]
						,trg.[client_tertiary_ethnicity]
						,trg.[client_maori_flag]
						,trg.[client_pasifika_flag]
						,trg.[client_ethnicity_group]
						,trg.[client_gender]
						,trg.[client_date_of_birth]
						,trg.[client_date_of_death]
						,trg.[client_age_years]
						,trg.[client_smoking_status]
						,trg.[client_smoking_cigarettes_per_day]
						,trg.[client_smoking_assessment_date]
						,trg.[client_legal_status_missing_flag]
						,trg.[client_legal_status]
						--,trg.[client_mental_health_condition_flag]
						,trg.[client_mental_health_condition]
						--,trg.[client_physical_health_condition_flag]
						,trg.[client_physical_condition]
						--,trg.[client_substance_use_flag]
						,trg.[client_substance_condition]
						,trg.[client_smoking_status_missing_flag]
						,trg.[client_smoking_advice_flag]
						,trg.[client_smoking_cessation_referral_flag]
						,trg.[client_primhd_review_missing_flag]
						,trg.[client_primhd_review_overdue_flag]
						,trg.[client_primhd_review_due_soon_flag]
						,trg.[client_primhd_review_current_flag]
						,trg.[client_gp_only_missing_flag]
						,trg.[client_gp_registration_missing_flag]
						,trg.[client_residency_status]
						,trg.[client_status_is_active]
						,trg.[client_status_is_active_date]
						,trg.[client_smoking_last_assessment_flag]
						,trg.primary_ethnicity_id
						,trg.secondary_ethnicity_id
						,trg.tertiary_ethnicity_id
						,trg.fourth_ethnicity_id
						,trg.primary_iwi_id
						,trg.secondary_iwi_id
						,trg.tertiary_iwi_id
						,trg.fourth_iwi_id
						,trg.priority_ethnicity_id
						,'X'
					)
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0
						-- Soft delete missing records
			WHEN NOT MATCHED BY source
				AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
				AND trg.[DWHDMLOperation] <> 'D'
				AND trg.[dim_client_key] > 0
				THEN
					UPDATE
					SET [DWHEffectiveTo] = @SystemEffectiveTo
						,[DWHIsCurrent] = 0
						-- Insert new records
			WHEN NOT MATCHED BY target
				THEN
					INSERT (
						[company_id]
						,[dim_client_unique_key]
						,[client_id]
						,[client_display_name]
						,[client_first_name]
						,[client_middle_name]
						,[client_last_name]
						,[client_preferred_name]
						,[client_nhi_number]
						,[client_created_date]
						,[client_address_missing_flag]
						,[client_address_missing_flag_date]
						,[client_address_name]
						,[client_address_line1]
						,[client_address_line2]
						,[client_address_line3]
						,[client_address_suburb]
						,[client_address_town_or_city]
						,[client_address_post_code]
						,[client_contact_phone_missing_flag]
						,[client_contact_phone_missing_flag_date]
						,[client_contact_home_phone]
						,[client_contact_work_phone]
						,[client_contact_mobile_phone]
						,[client_contact_fax]
						,[client_contact_pager]
						,[client_contact_other]
						--,[client_emergency_contact_flag]
						,[client_emergency_contact_phone]
						,[client_email]
						,[client_primary_iwi]
						,[client_primary_region]
						,[client_primary_waka_iwi_unknown_flag]
						,[client_primary_ethnicity]
						,[client_secondary_iwi]
						,[client_secondary_region]
						,[client_secondary_waka_iwi_unknown_flag]
						,[client_secondary_ethnicity]
						,[client_tertiary_iwi]
						,[client_tertiary_region]
						,[client_tertiary_waka_iwi_unknown_flag]
						,[client_tertiary_ethnicity]
						,[client_maori_flag]
						,[client_pasifika_flag]
						,[client_ethnicity_group]
						,[client_gender]
						,[client_date_of_birth]
						,[client_date_of_death]
						,[client_age_years]
						,[client_smoking_status]
						,[client_smoking_cigarettes_per_day]
						,[client_smoking_assessment_date]
						,[client_legal_status_missing_flag]
						,[client_legal_status]
						--,[client_mental_health_condition_flag]
						,[client_mental_health_condition]
						--,[client_physical_health_condition_flag]
						,[client_physical_condition]
						--,[client_substance_use_flag]
						,[client_substance_condition]
						,[client_smoking_status_missing_flag]
						,[client_smoking_advice_flag]
						,[client_smoking_cessation_referral_flag]
						,[client_primhd_review_missing_flag]
						,[client_primhd_review_overdue_flag]
						,[client_primhd_review_due_soon_flag]
						,[client_primhd_review_current_flag]
						,[client_gp_only_missing_flag]
						,[client_gp_registration_missing_flag]
						,[client_residency_status]
						,[client_status_is_active]
						,[client_status_is_active_date]
						,[client_smoking_last_assessment_flag]
						,primary_ethnicity_id
						,secondary_ethnicity_id
						,tertiary_ethnicity_id
						,fourth_ethnicity_id
						,primary_iwi_id
						,secondary_iwi_id
						,tertiary_iwi_id
						,fourth_iwi_id
						,priority_ethnicity_id
						,[DWHSourceSystem]
						,[DWHBatchId]
						,[DWHDMLOperation]
						,[DWHEffectiveFrom]
						,[DWHEffectiveTo]
						,[DWHIsCurrent]
						)
					VALUES (
						src.[company_id]
						,src.[dim_client_unique_key]
						,src.[client_id]
						,src.[client_display_name]
						,src.[client_first_name]
						,src.[client_middle_name]
						,src.[client_last_name]
						,src.[client_preferred_name]
						,src.[client_nhi_number]
						,src.[client_created_date]
						,src.[client_address_missing_flag]
						--,CONVERT(datetime,'1 January 1900')
						,src.[client_address_missing_flag_date]
						,src.[client_address_name]
						,src.[client_address_line1]
						,src.[client_address_line2]
						,src.[client_address_line3]
						,src.[client_address_suburb]
						,src.[client_address_town_or_city]
						,src.[client_address_post_code]
						,src.[client_contact_phone_missing_flag]
						--,CONVERT(datetime,'1 January 1900')
						,src.[client_contact_phone_missing_flag_date]
						,src.[client_contact_home_phone]
						,src.[client_contact_work_phone]
						,src.[client_contact_mobile_phone]
						,src.[client_contact_fax]
						,src.[client_contact_pager]
						,src.[client_contact_other]
						--,src.[client_emergency_contact_flag]
						,src.[client_emergency_contact_phone]
						,src.[client_email]
						,src.[client_primary_iwi]
						,src.[client_primary_region]
						,src.[client_primary_waka_iwi_unknown_flag]
						,src.[client_primary_ethnicity]
						,src.[client_secondary_iwi]
						,src.[client_secondary_region]
						,src.[client_secondary_waka_iwi_unknown_flag]
						,src.[client_secondary_ethnicity]
						,src.[client_tertiary_iwi]
						,src.[client_tertiary_region]
						,src.[client_tertiary_waka_iwi_unknown_flag]
						,src.[client_tertiary_ethnicity]
						,src.[client_maori_flag]
						,src.[client_pasifika_flag]
						,src.[client_ethnicity_group]
						,src.[client_gender]
						,src.[client_date_of_birth]
						,src.[client_date_of_death]
						,src.[client_age_years]
						,src.[client_smoking_status]
						,src.[client_smoking_cigarettes_per_day]
						,src.[client_smoking_assessment_date]
						,src.[client_legal_status_missing_flag]
						,src.[client_legal_status]
						--,src.[client_mental_health_condition_flag]
						,src.[client_mental_health_condition]
						--,src.[client_physical_health_condition_flag]
						,src.[client_physical_condition]
						--,src.[client_substance_use_flag]
						,src.[client_substance_condition]
						,src.[client_smoking_status_missing_flag]
						,src.[client_smoking_advice_flag]
						,src.[client_smoking_cessation_referral_flag]
						,src.[client_primhd_review_missing_flag]
						,src.[client_primhd_review_overdue_flag]
						,src.[client_primhd_review_due_soon_flag]
						,src.[client_primhd_review_current_flag]
						,src.[client_gp_only_missing_flag]
						,src.[client_gp_registration_missing_flag]
						,src.[client_residency_status]
						,src.[client_status_is_active]
						--,CONVERT(datetime,'1 January 1900')
						,src.[client_status_is_active_date]
						,src.[client_smoking_last_assessment_flag]
						,src.primary_ethnicity_id
						,src.secondary_ethnicity_id
						,src.tertiary_ethnicity_id
						,src.fourth_ethnicity_id
						,src.primary_iwi_id
						,src.secondary_iwi_id
						,src.tertiary_iwi_id
						,src.fourth_iwi_id
						,src.priority_ethnicity_id
						,src.[DWHSourceSystem]
						,src.[DWHBatchId]
						,src.[DWHDMLOperation]
						,@SystemDefaultEffectiveFrom --src.[DWHEffectiveFrom]
						,src.[DWHEffectiveTo]
						,src.[DWHIsCurrent]
						)
			OUTPUT coalesce(src.[dim_client_unique_key], inserted.[dim_client_unique_key])
				,$ACTION AS [MergeAction]
			INTO #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			INSERT INTO [edw].[dim_client] (
				[company_id]
				,[dim_client_unique_key]
				,[client_id]
				,[client_display_name]
				,[client_first_name]
				,[client_middle_name]
				,[client_last_name]
				,[client_preferred_name]
				,[client_nhi_number]
				,[client_created_date]
				,[client_address_missing_flag]
				,[client_address_missing_flag_date]
				,[client_address_name]
				,[client_address_line1]
				,[client_address_line2]
				,[client_address_line3]
				,[client_address_suburb]
				,[client_address_town_or_city]
				,[client_address_post_code]
				,[client_contact_phone_missing_flag]
				,[client_contact_phone_missing_flag_date]
				,[client_contact_home_phone]
				,[client_contact_work_phone]
				,[client_contact_mobile_phone]
				,[client_contact_fax]
				,[client_contact_pager]
				,[client_contact_other]
				--,[client_emergency_contact_flag]
				,[client_emergency_contact_phone]
				,[client_email]
				,[client_primary_iwi]
				,[client_primary_region]
				,[client_primary_waka_iwi_unknown_flag]
				,[client_primary_ethnicity]
				,[client_secondary_iwi]
				,[client_secondary_region]
				,[client_secondary_waka_iwi_unknown_flag]
				,[client_secondary_ethnicity]
				,[client_tertiary_iwi]
				,[client_tertiary_region]
				,[client_tertiary_waka_iwi_unknown_flag]
				,[client_tertiary_ethnicity]
				,[client_maori_flag]
				,[client_pasifika_flag]
				,[client_ethnicity_group]
				,[client_gender]
				,[client_date_of_birth]
				,[client_date_of_death]
				,[client_age_years]
				,[client_smoking_status]
				,[client_smoking_cigarettes_per_day]
				,[client_smoking_assessment_date]
				,[client_legal_status_missing_flag]
				,[client_legal_status]
				--,[client_mental_health_condition_flag]
				,[client_mental_health_condition]
				--,[client_physical_health_condition_flag]
				,[client_physical_condition]
				--,[client_substance_use_flag]
				,[client_substance_condition]
				,[client_smoking_status_missing_flag]
				,[client_smoking_advice_flag]
				,[client_smoking_cessation_referral_flag]
				,[client_primhd_review_missing_flag]
				,[client_primhd_review_overdue_flag]
				,[client_primhd_review_due_soon_flag]
				,[client_primhd_review_current_flag]
				,[client_gp_only_missing_flag]
				,[client_gp_registration_missing_flag]
				,[client_residency_status]
				,[client_status_is_active]
				,[client_status_is_active_date]
				,[client_smoking_last_assessment_flag]
				,primary_ethnicity_id
				,secondary_ethnicity_id
				,tertiary_ethnicity_id
				,fourth_ethnicity_id
				,primary_iwi_id
				,secondary_iwi_id
				,tertiary_iwi_id
				,fourth_iwi_id
				,priority_ethnicity_id
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
				)
			SELECT src.[company_id]
				,src.[dim_client_unique_key]
				,src.[client_id]
				,src.[client_display_name]
				,src.[client_first_name]
				,src.[client_middle_name]
				,src.[client_last_name]
				,src.[client_preferred_name]
				,src.[client_nhi_number]
				,src.[client_created_date]
				,src.[client_address_missing_flag]
				--,@systemCurrentDate
				,src.[client_address_missing_flag_date]
				,src.[client_address_name]
				,src.[client_address_line1]
				,src.[client_address_line2]
				,src.[client_address_line3]
				,src.[client_address_suburb]
				,src.[client_address_town_or_city]
				,src.[client_address_post_code]
				,src.[client_contact_phone_missing_flag]
				--,@systemCurrentDate
				,src.[client_contact_phone_missing_flag_date]
				,src.[client_contact_home_phone]
				,src.[client_contact_work_phone]
				,src.[client_contact_mobile_phone]
				,src.[client_contact_fax]
				,src.[client_contact_pager]
				,src.[client_contact_other]
				--,src.[client_emergency_contact_flag]
				,src.[client_emergency_contact_phone]
				,src.[client_email]
				,src.[client_primary_iwi]
				,src.[client_primary_region]
				,src.[client_primary_waka_iwi_unknown_flag]
				,src.[client_primary_ethnicity]
				,src.[client_secondary_iwi]
				,src.[client_secondary_region]
				,src.[client_secondary_waka_iwi_unknown_flag]
				,src.[client_secondary_ethnicity]
				,src.[client_tertiary_iwi]
				,src.[client_tertiary_region]
				,src.[client_tertiary_waka_iwi_unknown_flag]
				,src.[client_tertiary_ethnicity]
				,src.[client_maori_flag]
				,src.[client_pasifika_flag]
				,src.[client_ethnicity_group]
				,src.[client_gender]
				,src.[client_date_of_birth]
				,src.[client_date_of_death]
				,src.[client_age_years]
				,src.[client_smoking_status]
				,src.[client_smoking_cigarettes_per_day]
				,src.[client_smoking_assessment_date]
				,src.[client_legal_status_missing_flag]
				,src.[client_legal_status]
				--,src.[client_mental_health_condition_flag]
				,src.[client_mental_health_condition]
				--,src.[client_physical_health_condition_flag]
				,src.[client_physical_condition]
				--,src.[client_substance_use_flag]
				,src.[client_substance_condition]
				,src.[client_smoking_status_missing_flag]
				,src.[client_smoking_advice_flag]
				,src.[client_smoking_cessation_referral_flag]
				,src.[client_primhd_review_missing_flag]
				,src.[client_primhd_review_overdue_flag]
				,src.[client_primhd_review_due_soon_flag]
				,src.[client_primhd_review_current_flag]
				,src.[client_gp_only_missing_flag]
				,src.[client_gp_registration_missing_flag]
				,src.[client_residency_status]
				,src.[client_status_is_active]
				,src.[client_status_is_active_date]
				--,@systemCurrentDate
				,src.[client_smoking_last_assessment_flag]
				,src.primary_ethnicity_id
				,src.secondary_ethnicity_id
				,src.tertiary_ethnicity_id
				,src.fourth_ethnicity_id
				,src.primary_iwi_id
				,src.secondary_iwi_id
				,src.tertiary_iwi_id
				,src.fourth_iwi_id
				,src.priority_ethnicity_id
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_client]'
				,'U'
			FROM #SummaryOfChanges AS base
			INNER JOIN [staging].[ODSETLdim_client] AS src ON src.[dim_client_unique_key] = base.[dim_client_unique_key] collate database_default
			WHERE base.[MergeAction] = 'UPDATE'
			
			UNION ALL
			
			SELECT tbl.[company_id]
				,tbl.[dim_client_unique_key]
				,tbl.[client_id]
				,tbl.[client_display_name]
				,tbl.[client_first_name]
				,tbl.[client_middle_name]
				,tbl.[client_last_name]
				,tbl.[client_preferred_name]
				,tbl.[client_nhi_number]
				,tbl.[client_created_date]
				,tbl.[client_address_missing_flag]
				--,@systemCurrentDate
				,tbl.[client_address_missing_flag_date]
				,tbl.[client_address_name]
				,tbl.[client_address_line1]
				,tbl.[client_address_line2]
				,tbl.[client_address_line3]
				,tbl.[client_address_suburb]
				,tbl.[client_address_town_or_city]
				,tbl.[client_address_post_code]
				,tbl.[client_contact_phone_missing_flag]
				--,@systemCurrentDate
				,tbl.[client_contact_phone_missing_flag_date]
				,tbl.[client_contact_home_phone]
				,tbl.[client_contact_work_phone]
				,tbl.[client_contact_mobile_phone]
				,tbl.[client_contact_fax]
				,tbl.[client_contact_pager]
				,tbl.[client_contact_other]
				--,tbl.[client_emergency_contact_flag]
				,tbl.[client_emergency_contact_phone]
				,tbl.[client_email]
				,tbl.[client_primary_iwi]
				,tbl.[client_primary_region]
				,tbl.[client_primary_waka_iwi_unknown_flag]
				,tbl.[client_primary_ethnicity]
				,tbl.[client_secondary_iwi]
				,tbl.[client_secondary_region]
				,tbl.[client_secondary_waka_iwi_unknown_flag]
				,tbl.[client_secondary_ethnicity]
				,tbl.[client_tertiary_iwi]
				,tbl.[client_tertiary_region]
				,tbl.[client_tertiary_waka_iwi_unknown_flag]
				,tbl.[client_tertiary_ethnicity]
				,tbl.[client_maori_flag]
				,tbl.[client_pasifika_flag]
				,tbl.[client_ethnicity_group]
				,tbl.[client_gender]
				,tbl.[client_date_of_birth]
				,tbl.[client_date_of_death]
				,tbl.[client_age_years]
				,tbl.[client_smoking_status]
				,tbl.[client_smoking_cigarettes_per_day]
				,tbl.[client_smoking_assessment_date]
				,tbl.[client_legal_status_missing_flag]
				,tbl.[client_legal_status]
				--,tbl.[client_mental_health_condition_flag]
				,tbl.[client_mental_health_condition]
				--,tbl.[client_physical_health_condition_flag]
				,tbl.[client_physical_condition]
				--,tbl.[client_substance_use_flag]
				,tbl.[client_substance_condition]
				,tbl.[client_smoking_status_missing_flag]
				,tbl.[client_smoking_advice_flag]
				,tbl.[client_smoking_cessation_referral_flag]
				,tbl.[client_primhd_review_missing_flag]
				,tbl.[client_primhd_review_overdue_flag]
				,tbl.[client_primhd_review_due_soon_flag]
				,tbl.[client_primhd_review_current_flag]
				,tbl.[client_gp_only_missing_flag]
				,tbl.[client_gp_registration_missing_flag]
				,tbl.[client_residency_status]
				,tbl.[client_status_is_active]
				--,@systemCurrentDate
				,tbl.[client_status_is_active_date]
				,tbl.[client_smoking_last_assessment_flag]
				,tbl.primary_ethnicity_id
				,tbl.secondary_ethnicity_id
				,tbl.tertiary_ethnicity_id
				,tbl.fourth_ethnicity_id
				,tbl.primary_iwi_id
				,tbl.secondary_iwi_id
				,tbl.tertiary_iwi_id
				,tbl.fourth_iwi_id
				,tbl.priority_ethnicity_id
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_client]'
				,'D'
			FROM #SummaryOfChanges AS base
			INNER JOIN [edw].[dim_client] AS tbl ON tbl.[dim_client_unique_key] = base.[dim_client_unique_key] collate database_default
				AND tbl.[DWHEffectiveTo] = @SystemEffectiveTo --@SystemDefaultEffectiveTo
			LEFT JOIN [staging].[ODSETLdim_client] AS src ON src.[dim_client_unique_key] = base.[dim_client_unique_key]
			WHERE base.[MergeAction] = 'UPDATE'
				AND src.[dim_client_unique_key] IS NULL;

		END;

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
		FROM [edw].[dim_client]
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
		BEGIN
			-- Select return parameters as a dataset
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
	BEGIN
		-- Select return parameters as a dataset
		SELECT @pErrorRecords AS ErrorRecords
			,@pInsertRecords AS InsertRecords
			,@pUpdateRecords AS UpdateRecords
			,@pDeleteRecords AS DeleteRecords
			,@pCompleted AS Completed
			,@targetRecords AS TargetRecords
			,@pErrorMessage AS ErrorMessage;
	END;
END;