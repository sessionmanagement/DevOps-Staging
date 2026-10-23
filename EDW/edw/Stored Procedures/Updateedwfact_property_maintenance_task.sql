












/**********************************************************************************************************
Procedure	[edw].[Updateedwfact_property_maintenance_task]
Purpose	
		
Notes: Call By	EDW Pipeline '30_Load_From_ODS'

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024/07/04	  Glenn McLeod			Initial version


**********************************************************************************************************/



CREATE procedure [edw].[Updateedwfact_property_maintenance_task] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT,
	@pErrorMessage varchar(MAX) = null OUTPUT

as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_property_maintenance_task]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_property_maintenance_task];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_property_maintenance_task];

		-- Select success details
		select
			 @pErrorRecords = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted = 1
			,@pTargetRecords = @targetRecords;	

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;

		return;
	end;

	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_property_maintenance_task]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_property_maintenance_task]
			(
				 [property_maintenance_task_id] 
				,[property_maintenance_id] 
				,[dim_property_maintenance_key]
				,[dim_property_key]
				,[dim_property_detail_key]
				,[dim_property_healthy_homes_key]
				,[dim_property_tenancy_key]
				,[dim_property_program_key]
				,[dim_property_maintenace_type_key]
				,[property_id] 
				,[property_maintenance_type_id] 
				,[property_program_id] 
				,[property_subprogram_id] 
				,[property_tenancy_id] 
				--,[property_maintenace_type_id] 
				,[property_tenancy_type_id] 
				,[property_maintenance_task_acknowledgment_date_key] 
				,[property_maintenance_task_acknowledgment_end_date_key] 
				,[property_maintenance_task_actual_completion_date_key] 
				,[property_maintenance_task_contractor_work_completion_date_key] 
				,[property_maintenance_task_expected_completion_date_key] 
				,[property_maintenance_task_expected_onsite_date_key] 
				,[property_maintenance_task_total_capped_amount_date_key] 
				,[property_maintenance_task_web_expenses_amount_date_key] 
				,[property_maintenance_assets_installation_date_key] 
				,[property_maintenance_task_contractor_status_date_key] 
				,[property_maintenance_task_icode] 
				,[property_maintenance_task_information_code_name] 
				,[property_maintenance_task_location_code] 
				,[property_maintenance_task_location_name] 
				,[property_maintenance_task_work_task_name] 
				,[property_maintenance_task_area_seq] 
				,[property_maintenance_task_assets_name] 
				,[property_maintenance_contract_service_name] 
				,[property_maintenance_task_comments] 
				,[property_maintenance_task_information_code_detail_name] 
				,[property_maintenance_task_maintenance_code] 
				,[property_maintenance_task_maintenance_type_name] 
				,[property_maintenance_task_amount] 
				,[property_maintenance_task_created_datetime] 
				,[property_maintenance_task_modified_datetime] 
				,[property_maintenance_task_is_delete_flag] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)

			select
				 src.[property_maintenance_task_id] 
				,src.[property_maintenance_id] 
				,isnull(dpm.[dim_property_maintenance_key], CASE WHEN src.property_maintenance_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_maintenance_key]
				,isnull(dp.[dim_property_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_key]
				,isnull(dpd.[dim_property_detail_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_detail_key]
				,isnull(dphh.[dim_property_healthy_homes_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_healthy_homes_key]
				,isnull(dpt.[dim_property_tenancy_key], CASE WHEN src.property_tenancy_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_tenancy_key]
				,isnull(dpp.[dim_property_program_id], CASE WHEN src.[property_program_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_program_key]
				,isnull(dpmt.[dim_property_maintenace_type_id], CASE WHEN src.[property_maintenance_type_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_maintenace_type_key]
				,src.[property_id] 
				,src.[property_maintenance_type_id] 
				,src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[property_tenancy_id] 
				--,src.[property_maintenace_type_id] 
				,src.[property_tenancy_type_id] 
				,isnull(dtad.[dim_date_key], CASE WHEN src.property_maintenance_task_acknowledgment_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_acknowledgment_date_key]
				,isnull(dtaed.[dim_date_key], CASE WHEN src.property_maintenance_task_acknowledgment_end_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_acknowledgment_end_date_key]
				,isnull(dtacd.[dim_date_key], CASE WHEN src.property_maintenance_task_actual_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_actual_completion_date_key]
				,isnull(dtcwcd.[dim_date_key], CASE WHEN src.property_maintenance_task_contractor_work_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_contractor_work_completion_date_key]
				,isnull(dtecd.[dim_date_key], CASE WHEN src.property_maintenance_task_expected_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_expected_completion_date_key]
				,isnull(dteod.[dim_date_key], CASE WHEN src.property_maintenance_task_expected_onsite_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_expected_onsite_date_key]
				,isnull(dttcad.[dim_date_key], CASE WHEN src.property_maintenance_task_total_capped_amount_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_total_capped_amount_date_key]
				,isnull(dtwead.[dim_date_key], CASE WHEN src.property_maintenance_task_web_expenses_amount_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_web_expenses_amount_date_key]
				,isnull(daid.[dim_date_key], CASE WHEN src.property_maintenance_assets_installation_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_assets_installation_date_key]
				,isnull(dtcsd.[dim_date_key], CASE WHEN src.property_maintenance_task_contractor_status_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_contractor_status_date_key]
				--,src.[property_maintenance_task_acknowledgment_date_id] 
				--,src.[property_maintenance_task_acknowledgment_end_date_id] 
				--,src.[property_maintenance_task_actual_completion_date_id] 
				--,src.[property_maintenance_task_contractor_work_completion_date_id] 
				--,src.[property_maintenance_task_expected_completion_date_id] 
				--,src.[property_maintenance_task_expected_onsite_date_id] 
				--,src.[property_maintenance_task_total_capped_amount_date_id] 
				--,src.[property_maintenance_task_web_expenses_amount_date_id] 
				--,src.[property_maintenance_assets_installation_date_id] 
				--,src.[property_maintenance_task_contractor_status_date_id] 
				,src.[property_maintenance_task_icode] 
				,src.[property_maintenance_task_information_code_name] 
				,src.[property_maintenance_task_location_code] 
				,src.[property_maintenance_task_location_name] 
				,src.[property_maintenance_task_work_task_name] 
				,src.[property_maintenance_task_area_seq] 
				,src.[property_maintenance_task_assets_name] 
				,src.[property_maintenance_contract_service_name] 
				,src.[property_maintenance_task_comments] 
				,src.[property_maintenance_task_information_code_detail_name] 
				,src.[property_maintenance_task_maintenance_code] 
				,src.[property_maintenance_task_maintenance_type_name] 
				,src.[property_maintenance_task_amount] 
				,src.[property_maintenance_task_created_datetime] 
				,src.[property_maintenance_task_modified_datetime] 
				,src.[property_maintenance_task_is_delete_flag] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_property_maintenance_task] as src
				LEFT JOIN [edw].[dim_property_maintenance] dpm ON src.[property_maintenance_id] = dpm.[property_maintenance_id]
					AND dpm.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property] dp ON src.[property_id] = dp.[property_id]
					AND dp.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_detail] dpd ON src.[property_id] = dpd.[property_detail_id]
					AND dpd.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON src.[property_id] = dphh.[property_healthy_homes_id]
					AND dphh.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_tenancy] dpt ON src.[property_tenancy_id] =  dpt.[property_tenancy_id] 
					AND dpt.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_program] dpp ON src.[property_program_id] = dpp.[property_program_id] AND src.[property_subprogram_id] = dpp.[property_subprogram_id]
					AND dpp.[DWHIsCurrent] = 1
				LEFT JOIN [edw].[dim_property_maintenace_type] dpmt ON src.[property_maintenance_type_id] = dpmt.[property_maintenance_type_id]
					AND dpmt.[DWHIsCurrent] = 1
				LEFT JOIN [edw].[dim_date] dtad ON src.[property_maintenance_task_acknowledgment_date_id] = dtad.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtaed ON src.[property_maintenance_task_acknowledgment_end_date_id] = dtaed.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtacd ON src.[property_maintenance_task_actual_completion_date_id] = dtacd.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtcwcd ON src.[property_maintenance_task_contractor_work_completion_date_id] = dtcwcd.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtecd ON src.[property_maintenance_task_expected_completion_date_id] = dtecd.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dteod ON src.[property_maintenance_task_expected_onsite_date_id] = dteod.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dttcad ON src.[property_maintenance_task_total_capped_amount_date_id] = dttcad.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtwead ON src.[property_maintenance_task_web_expenses_amount_date_id] = dtwead.[dim_date_key]
				LEFT JOIN [edw].[dim_date] daid ON src.[property_maintenance_assets_installation_date_id] = daid.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtcsd ON src.[property_maintenance_task_contractor_status_date_id] = dtcsd.[dim_date_key]
			
			;
		end else begin
			merge into [edw].[fact_property_maintenance_task] as trg
			using 
			(
			select
				 src.[property_maintenance_task_id] 
				,src.[property_maintenance_id] 
				,isnull(dpm.[dim_property_maintenance_key], CASE WHEN src.property_maintenance_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_maintenance_key]
				,isnull(dp.[dim_property_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_key]
				,isnull(dpd.[dim_property_detail_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_detail_key]
				,isnull(dphh.[dim_property_healthy_homes_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_healthy_homes_key]
				,isnull(dpt.[dim_property_tenancy_key], CASE WHEN src.property_tenancy_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_tenancy_key]
				,isnull(dpp.[dim_property_program_id], CASE WHEN src.[property_program_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_program_key]
				,isnull(dpmt.[dim_property_maintenace_type_id], CASE WHEN src.[property_maintenance_type_id] IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_maintenace_type_key]
				,src.[property_id] 
				,src.[property_maintenance_type_id] 
				,src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[property_tenancy_id] 
				--,src.[property_maintenace_type_id] 
				,src.[property_tenancy_type_id] 
				,isnull(dtad.[dim_date_key], CASE WHEN src.property_maintenance_task_acknowledgment_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_acknowledgment_date_key]
				,isnull(dtaed.[dim_date_key], CASE WHEN src.property_maintenance_task_acknowledgment_end_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_acknowledgment_end_date_key]
				,isnull(dtacd.[dim_date_key], CASE WHEN src.property_maintenance_task_actual_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_actual_completion_date_key]
				,isnull(dtcwcd.[dim_date_key], CASE WHEN src.property_maintenance_task_contractor_work_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_contractor_work_completion_date_key]
				,isnull(dtecd.[dim_date_key], CASE WHEN src.property_maintenance_task_expected_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_expected_completion_date_key]
				,isnull(dteod.[dim_date_key], CASE WHEN src.property_maintenance_task_expected_onsite_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_expected_onsite_date_key]
				,isnull(dttcad.[dim_date_key], CASE WHEN src.property_maintenance_task_total_capped_amount_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_total_capped_amount_date_key]
				,isnull(dtwead.[dim_date_key], CASE WHEN src.property_maintenance_task_web_expenses_amount_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_web_expenses_amount_date_key]
				,isnull(daid.[dim_date_key], CASE WHEN src.property_maintenance_assets_installation_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_assets_installation_date_key]
				,isnull(dtcsd.[dim_date_key], CASE WHEN src.property_maintenance_task_contractor_status_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_maintenance_task_contractor_status_date_key]
				--,src.[property_maintenance_task_acknowledgment_date_id] 
				--,src.[property_maintenance_task_acknowledgment_end_date_id] 
				--,src.[property_maintenance_task_actual_completion_date_id] 
				--,src.[property_maintenance_task_contractor_work_completion_date_id] 
				--,src.[property_maintenance_task_expected_completion_date_id] 
				--,src.[property_maintenance_task_expected_onsite_date_id] 
				--,src.[property_maintenance_task_total_capped_amount_date_id] 
				--,src.[property_maintenance_task_web_expenses_amount_date_id] 
				--,src.[property_maintenance_assets_installation_date_id] 
				--,src.[property_maintenance_task_contractor_status_date_id] 
				,src.[property_maintenance_task_icode] 
				,src.[property_maintenance_task_information_code_name] 
				,src.[property_maintenance_task_location_code] 
				,src.[property_maintenance_task_location_name] 
				,src.[property_maintenance_task_work_task_name] 
				,src.[property_maintenance_task_area_seq] 
				,src.[property_maintenance_task_assets_name] 
				,src.[property_maintenance_contract_service_name] 
				,src.[property_maintenance_task_comments] 
				,src.[property_maintenance_task_information_code_detail_name] 
				,src.[property_maintenance_task_maintenance_code] 
				,src.[property_maintenance_task_maintenance_type_name] 
				,src.[property_maintenance_task_amount] 
				,src.[property_maintenance_task_created_datetime] 
				,src.[property_maintenance_task_modified_datetime] 
				,src.[property_maintenance_task_is_delete_flag] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_property_maintenance_task] as src
				LEFT JOIN [edw].[dim_property_maintenance] dpm ON src.[property_maintenance_id] = dpm.[property_maintenance_id]
					AND dpm.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property] dp ON src.[property_id] = dp.[property_id]
					AND dp.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_detail] dpd ON src.[property_id] = dpd.[property_detail_id]
					AND dpd.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON src.[property_id] = dphh.[property_healthy_homes_id]
					AND dphh.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_tenancy] dpt ON src.[property_tenancy_id] =  dpt.[property_tenancy_id] 
					AND dpt.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_program] dpp ON src.[property_program_id] = dpp.[property_program_id] AND src.[property_subprogram_id] = dpp.[property_subprogram_id]
					AND dpp.[DWHIsCurrent] = 1
				LEFT JOIN [edw].[dim_property_maintenace_type] dpmt ON src.[property_maintenance_type_id] = dpmt.[property_maintenance_type_id]
					AND dpmt.[DWHIsCurrent] = 1
				LEFT JOIN [edw].[dim_date] dtad ON src.[property_maintenance_task_acknowledgment_date_id] = dtad.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtaed ON src.[property_maintenance_task_acknowledgment_end_date_id] = dtaed.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtacd ON src.[property_maintenance_task_actual_completion_date_id] = dtacd.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtcwcd ON src.[property_maintenance_task_contractor_work_completion_date_id] = dtcwcd.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtecd ON src.[property_maintenance_task_expected_completion_date_id] = dtecd.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dteod ON src.[property_maintenance_task_expected_onsite_date_id] = dteod.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dttcad ON src.[property_maintenance_task_total_capped_amount_date_id] = dttcad.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtwead ON src.[property_maintenance_task_web_expenses_amount_date_id] = dtwead.[dim_date_key]
				LEFT JOIN [edw].[dim_date] daid ON src.[property_maintenance_assets_installation_date_id] = daid.[dim_date_key]
				LEFT JOIN [edw].[dim_date] dtcsd ON src.[property_maintenance_task_contractor_status_date_id] = dtcsd.[dim_date_key]

			) as src on (ISNULL(src.[property_maintenance_task_id],src.[property_maintenance_id]) = ISNULL(trg.[property_maintenance_task_id],trg.[property_maintenance_id]) and ISNULL(src.[property_maintenance_id],src.[property_maintenance_task_id]) = ISNULL(trg.[property_maintenance_id],trg.[property_maintenance_task_id]))			-- Retire existing records
				-- NOTE: [property_maintenance_task_id] or [property_maintenance_id] can be null so need to add a default value on join so that we are not comparing a NULL value
			when matched and exists 
			( 
				select src.[property_id], src.[property_maintenance_type_id], src.[property_program_id], src.[property_subprogram_id], src.[property_tenancy_id], src.[property_tenancy_type_id], src.[property_maintenance_task_acknowledgment_date_key], src.[property_maintenance_task_acknowledgment_end_date_key], src.[property_maintenance_task_actual_completion_date_key], src.[property_maintenance_task_contractor_work_completion_date_key], src.[property_maintenance_task_expected_completion_date_key], src.[property_maintenance_task_expected_onsite_date_key], src.[property_maintenance_task_total_capped_amount_date_key], src.[property_maintenance_task_web_expenses_amount_date_key], src.[property_maintenance_assets_installation_date_key], src.[property_maintenance_task_contractor_status_date_key], src.[property_maintenance_task_icode], src.[property_maintenance_task_information_code_name], src.[property_maintenance_task_location_code], src.[property_maintenance_task_location_name], src.[property_maintenance_task_work_task_name], src.[property_maintenance_task_area_seq], src.[property_maintenance_task_assets_name], src.[property_maintenance_contract_service_name], src.[property_maintenance_task_comments], src.[property_maintenance_task_information_code_detail_name], src.[property_maintenance_task_maintenance_code], src.[property_maintenance_task_maintenance_type_name], src.[property_maintenance_task_amount], src.[property_maintenance_task_created_datetime], src.[property_maintenance_task_is_delete_flag], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end--, src.[property_maintenance_task_modified_datetime]
				except
				select trg.[property_id], trg.[property_maintenance_type_id], trg.[property_program_id], trg.[property_subprogram_id], trg.[property_tenancy_id], trg.[property_tenancy_type_id], trg.[property_maintenance_task_acknowledgment_date_key], trg.[property_maintenance_task_acknowledgment_end_date_key], trg.[property_maintenance_task_actual_completion_date_key], trg.[property_maintenance_task_contractor_work_completion_date_key], trg.[property_maintenance_task_expected_completion_date_key], trg.[property_maintenance_task_expected_onsite_date_key], trg.[property_maintenance_task_total_capped_amount_date_key], trg.[property_maintenance_task_web_expenses_amount_date_key], trg.[property_maintenance_assets_installation_date_key], trg.[property_maintenance_task_contractor_status_date_key], trg.[property_maintenance_task_icode], trg.[property_maintenance_task_information_code_name], trg.[property_maintenance_task_location_code], trg.[property_maintenance_task_location_name], trg.[property_maintenance_task_work_task_name], trg.[property_maintenance_task_area_seq], trg.[property_maintenance_task_assets_name], trg.[property_maintenance_contract_service_name], trg.[property_maintenance_task_comments], trg.[property_maintenance_task_information_code_detail_name], trg.[property_maintenance_task_maintenance_code], trg.[property_maintenance_task_maintenance_type_name], trg.[property_maintenance_task_amount], trg.[property_maintenance_task_created_datetime], trg.[property_maintenance_task_is_delete_flag], 'X' --, trg.[property_maintenance_task_modified_datetime]

			) then  update set 
				 [property_maintenance_task_id] = src.[property_maintenance_task_id]
				,[property_maintenance_id] = src.[property_maintenance_id]
				,[dim_property_maintenance_key] = src.[dim_property_maintenance_key]
				,[dim_property_key] = src.[dim_property_key]
				,[dim_property_detail_key] = src.[dim_property_detail_key]
				,[dim_property_healthy_homes_key] = src.[dim_property_healthy_homes_key]
				,[dim_property_tenancy_key] = src.[dim_property_tenancy_key]
				,[dim_property_program_key] = src.[dim_property_program_key]
				,[dim_property_maintenace_type_key] = src.[dim_property_maintenace_type_key]
				,[property_id] = src.[property_id]
				,[property_maintenance_type_id] = src.[property_maintenance_type_id]
				,[property_program_id] = src.[property_program_id]
				,[property_subprogram_id] = src.[property_subprogram_id]
				,[property_tenancy_id] = src.[property_tenancy_id]
				--, [property_maintenace_type_id] = src.[property_maintenace_type_id]
				,[property_tenancy_type_id] = src.[property_tenancy_type_id]
				,[property_maintenance_task_acknowledgment_date_key] = src.[property_maintenance_task_acknowledgment_date_key]
				,[property_maintenance_task_acknowledgment_end_date_key] = src.[property_maintenance_task_acknowledgment_end_date_key]
				,[property_maintenance_task_actual_completion_date_key] = src.[property_maintenance_task_actual_completion_date_key]
				,[property_maintenance_task_contractor_work_completion_date_key] = src.[property_maintenance_task_contractor_work_completion_date_key]
				,[property_maintenance_task_expected_completion_date_key] = src.[property_maintenance_task_expected_completion_date_key]
				,[property_maintenance_task_expected_onsite_date_key] = src.[property_maintenance_task_expected_onsite_date_key]
				,[property_maintenance_task_total_capped_amount_date_key] = src.[property_maintenance_task_total_capped_amount_date_key]
				,[property_maintenance_task_web_expenses_amount_date_key] = src.[property_maintenance_task_web_expenses_amount_date_key]
				,[property_maintenance_assets_installation_date_key] = src.[property_maintenance_assets_installation_date_key]
				,[property_maintenance_task_contractor_status_date_key] = src.[property_maintenance_task_contractor_status_date_key]
				,[property_maintenance_task_icode] = src.[property_maintenance_task_icode]
				,[property_maintenance_task_information_code_name] = src.[property_maintenance_task_information_code_name]
				,[property_maintenance_task_location_code] = src.[property_maintenance_task_location_code]
				,[property_maintenance_task_location_name] = src.[property_maintenance_task_location_name]
				,[property_maintenance_task_work_task_name] = src.[property_maintenance_task_work_task_name]
				,[property_maintenance_task_area_seq] = src.[property_maintenance_task_area_seq]
				,[property_maintenance_task_assets_name] = src.[property_maintenance_task_assets_name]
				,[property_maintenance_contract_service_name] = src.[property_maintenance_contract_service_name]
				,[property_maintenance_task_comments] = src.[property_maintenance_task_comments]
				,[property_maintenance_task_information_code_detail_name] = src.[property_maintenance_task_information_code_detail_name]
				,[property_maintenance_task_maintenance_code] = src.[property_maintenance_task_maintenance_code]
				,[property_maintenance_task_maintenance_type_name] = src.[property_maintenance_task_maintenance_type_name]
				,[property_maintenance_task_amount] = src.[property_maintenance_task_amount]
				,[property_maintenance_task_created_datetime] = src.[property_maintenance_task_created_datetime]
				,[property_maintenance_task_modified_datetime] = src.[property_maintenance_task_modified_datetime]
				,[property_maintenance_task_is_delete_flag] = src.[property_maintenance_task_is_delete_flag]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D', [DWHBatchId] = @BatchID
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_maintenance_task_id] 
					,[property_maintenance_id] 
					,[dim_property_maintenance_key]
					,[dim_property_key]
					,[dim_property_detail_key]
					,[dim_property_healthy_homes_key]
					,[dim_property_tenancy_key]
					,[dim_property_program_key]
					,[dim_property_maintenace_type_key]
					,[property_id] 
					,[property_maintenance_type_id] 
					,[property_program_id] 
					,[property_subprogram_id] 
					,[property_tenancy_id] 
					--,[property_maintenace_type_id] 
					,[property_tenancy_type_id] 
					,[property_maintenance_task_acknowledgment_date_key] 
					,[property_maintenance_task_acknowledgment_end_date_key] 
					,[property_maintenance_task_actual_completion_date_key] 
					,[property_maintenance_task_contractor_work_completion_date_key] 
					,[property_maintenance_task_expected_completion_date_key] 
					,[property_maintenance_task_expected_onsite_date_key] 
					,[property_maintenance_task_total_capped_amount_date_key] 
					,[property_maintenance_task_web_expenses_amount_date_key] 
					,[property_maintenance_assets_installation_date_key] 
					,[property_maintenance_task_contractor_status_date_key] 
					,[property_maintenance_task_icode] 
					,[property_maintenance_task_information_code_name] 
					,[property_maintenance_task_location_code] 
					,[property_maintenance_task_location_name] 
					,[property_maintenance_task_work_task_name] 
					,[property_maintenance_task_area_seq] 
					,[property_maintenance_task_assets_name] 
					,[property_maintenance_contract_service_name] 
					,[property_maintenance_task_comments] 
					,[property_maintenance_task_information_code_detail_name] 
					,[property_maintenance_task_maintenance_code] 
					,[property_maintenance_task_maintenance_type_name] 
					,[property_maintenance_task_amount] 
					,[property_maintenance_task_created_datetime] 
					,[property_maintenance_task_modified_datetime] 
					,[property_maintenance_task_is_delete_flag] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_maintenance_task_id] 
					,src.[property_maintenance_id] 
					,src.[dim_property_maintenance_key]
					,src.[dim_property_key]
					,src.[dim_property_detail_key]
					,src.[dim_property_healthy_homes_key]
					,src.[dim_property_tenancy_key]
					,src.[dim_property_program_key]
					,src.[dim_property_maintenace_type_key]
					,src.[property_id] 
					,src.[property_maintenance_type_id] 
					,src.[property_program_id] 
					,src.[property_subprogram_id] 
					,src.[property_tenancy_id] 
					--,src.[property_maintenace_type_id] 
					,src.[property_tenancy_type_id] 
					,src.[property_maintenance_task_acknowledgment_date_key] 
					,src.[property_maintenance_task_acknowledgment_end_date_key] 
					,src.[property_maintenance_task_actual_completion_date_key] 
					,src.[property_maintenance_task_contractor_work_completion_date_key] 
					,src.[property_maintenance_task_expected_completion_date_key] 
					,src.[property_maintenance_task_expected_onsite_date_key] 
					,src.[property_maintenance_task_total_capped_amount_date_key] 
					,src.[property_maintenance_task_web_expenses_amount_date_key] 
					,src.[property_maintenance_assets_installation_date_key] 
					,src.[property_maintenance_task_contractor_status_date_key] 
					,src.[property_maintenance_task_icode] 
					,src.[property_maintenance_task_information_code_name] 
					,src.[property_maintenance_task_location_code] 
					,src.[property_maintenance_task_location_name] 
					,src.[property_maintenance_task_work_task_name] 
					,src.[property_maintenance_task_area_seq] 
					,src.[property_maintenance_task_assets_name] 
					,src.[property_maintenance_contract_service_name] 
					,src.[property_maintenance_task_comments] 
					,src.[property_maintenance_task_information_code_detail_name] 
					,src.[property_maintenance_task_maintenance_code] 
					,src.[property_maintenance_task_maintenance_type_name] 
					,src.[property_maintenance_task_amount] 
					,src.[property_maintenance_task_created_datetime] 
					,src.[property_maintenance_task_modified_datetime] 
					,src.[property_maintenance_task_is_delete_flag] 
					,src.[DWHBatchId] 
					,src.[DWHCreatedAt] 
					,src.[DWHModifiedOn] 
					,src.[DWHDMLOperation] 
					,src.[DWHSourceSystem] 
				);
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_property_maintenance_task];

		commit transaction;
	end try
	begin catch
		rollback transaction;

		set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
		set @pInsertRecords = @insertedRecords;
		set @pUpdateRecords = @updatedRecords;
		set @pDeleteRecords = @deletedRecords;
		set @pCompleted = 0;
		set @pTargetRecords = @targetRecords;
		set @pErrorMessage = ERROR_MESSAGE();

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords,
					@pErrorMessage as ErrorMessage;
		end;
		throw;
	end catch

	set @pErrorRecords = @stagedRecords - @insertedRecords - @updatedRecords - @deletedRecords;
	set @pInsertRecords = @insertedRecords;
	set @pUpdateRecords = @updatedRecords;
	set @pDeleteRecords = @deletedRecords;
	set @pCompleted = 1;
	set @pTargetRecords = @targetRecords;

	if (@pOutputParamsAsDataset = 1)
	begin
		-- Select return parameters as a dataset
		select @pErrorRecords	as ErrorRecords,
				@pInsertRecords as InsertRecords,
				@pUpdateRecords as UpdateRecords,
				@pDeleteRecords as DeleteRecords,
				@pCompleted		as Completed,
				@targetRecords	as TargetRecords,
				@pErrorMessage as ErrorMessage;
	end;
end;