








/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_property_inspection]
 Author		
 Created		
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-07-04	  Glenn McLeod			Initial version


**********************************************************************************************************/


CREATE procedure [edw].[Updateedwfact_property_inspection] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_property_inspection]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();
	begin transaction;
	begin try
	
	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_property_inspection];
	if( @stagedRecords = 0 )
	begin
		select 
			 @targetRecords = count(1) 
		from [edw].[fact_property_inspection];

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

			commit transaction;
		return;
	end;
		if( not exists (select top(1) 1 from [edw].[fact_property_inspection]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_property_inspection]
			(
				 [property_inspection_id] 

				,dim_property_key
				,dim_property_detail_key
				,dim_property_healthy_homes_key
				,dim_property_tenancy_key
				,dim_property_maintenance_key
				,[property_id] 
				,[property_tenancy_id] 
				,[property_maintenance_id] 
				,[property_inspection_code] 
				,[property_inspection_name] 
				--,[property_inspection_date_id] 
				--,[property_inspection_scheduled_date_id] 
				--,[property_inspection_scheduled_time_id] 
				--,[property_inspection_completion_date_id] 
				--,[property_inspection_scheduled_end_time_id] 
				--,[property_inspection_next_routine_inspection_date_id] 
				,property_inspection_date_key
				,property_inspection_scheduled_date_key
				,property_inspection_scheduled_time_key
				,property_inspection_completion_date_key
				,property_inspection_scheduled_end_time_key
				,property_inspection_next_routine_inspection_date_key
				,[property_inspection_summary] 
				,[property_inspection_inspected_by] 
				,[property_inspection_category] 
				,[property_inspection_type] 
				,[property_inspection_maintenance_summary] 
				,[property_inspection_state] 
				,[property_inspection_status] 
				,[property_inspection_tenant_present_flag] 
				,[property_inspection_cancel_inspection_flag] 
				,[property_inspection_ignore_plugin_validate_flag] 
				,[property_inspection_tenant_confirmed_condition_flag] 
				,[property_inspection_owning_business_unit_name] 
				,[property_inspection_client] 
				,[property_inspection_property] 
				,[property_inspection_property_manager] 
				,[property_inspection_tenancy_manager] 
				,[property_inspection_tenant] 
				,[property_inspection_owner_name] 
				,[property_inspection_other_issue_comments] 
				,[property_inspection_chintaro_id] 
				,[property_inspection_comments] 
				,[property_inspection_relative_url] 
				,[property_inspection_suggested_improvements] 
				,[property_inspection_created_datetime] 
				,[property_inspection_modified_datetime] 
				,[property_inspection_is_delete_flag] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)

			select
				 src.[property_inspection_id] 
				,isnull(dp.[dim_property_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_key]
				,isnull(dpd.[dim_property_detail_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_detail_key]
				,isnull(dphh.[dim_property_healthy_homes_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_healthy_homes_key]
				,isnull(dpt.[dim_property_tenancy_key], CASE WHEN src.property_tenancy_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_tenancy_key]
				,isnull(dpm.[dim_property_maintenance_key], CASE WHEN src.property_maintenance_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_maintenance_key]
				,src.[property_id] 
				,src.[property_tenancy_id] 
				,src.[property_maintenance_id] 
				,src.[property_inspection_code] 
				,src.[property_inspection_name] 
				--,src.[property_inspection_date_id] 
				--,src.[property_inspection_scheduled_date_id] 
				--,src.[property_inspection_scheduled_time_id] 
				--,src.[property_inspection_completion_date_id] 
				--,src.[property_inspection_scheduled_end_time_id] 
				--,src.[property_inspection_next_routine_inspection_date_id] 
				,isnull(did.[dim_date_key], CASE WHEN src.property_inspection_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_date_key]
				,isnull(disd.[dim_date_key], CASE WHEN src.property_inspection_scheduled_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_scheduled_date_key]
				,isnull(tsit.[dim_time_key], CASE WHEN src.property_inspection_scheduled_time_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_scheduled_time_key]
				,isnull(dscd.[dim_date_key], CASE WHEN src.property_inspection_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_completion_date_key]
				,isnull(tset.[dim_time_key], CASE WHEN src.property_inspection_scheduled_end_time_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_scheduled_end_time_key]
				,isnull(drid.[dim_date_key], CASE WHEN src.property_inspection_next_routine_inspection_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_next_routine_inspection_date_key]
				,src.[property_inspection_summary] 
				,src.[property_inspection_inspected_by] 
				,src.[property_inspection_category] 
				,src.[property_inspection_type] 
				,src.[property_inspection_maintenance_summary] 
				,src.[property_inspection_state] 
				,src.[property_inspection_status] 
				,src.[property_inspection_tenant_present_flag] 
				,src.[property_inspection_cancel_inspection_flag] 
				,src.[property_inspection_ignore_plugin_validate_flag] 
				,src.[property_inspection_tenant_confirmed_condition_flag] 
				,src.[property_inspection_owning_business_unit_name] 
				,src.[property_inspection_client] 
				,src.[property_inspection_property] 
				,src.[property_inspection_property_manager] 
				,src.[property_inspection_tenancy_manager] 
				,src.[property_inspection_tenant] 
				,src.[property_inspection_owner_name] 
				,src.[property_inspection_other_issue_comments] 
				,src.[property_inspection_chintaro_id] 
				,src.[property_inspection_comments] 
				,src.[property_inspection_relative_url] 
				,src.[property_inspection_suggested_improvements] 
				,src.[property_inspection_created_datetime] 
				,src.[property_inspection_modified_datetime] 
				,src.[property_inspection_is_delete_flag] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_property_inspection] as src
				LEFT JOIN [edw].[dim_property] dp ON src.[property_id] = dp.[property_id]
					AND dp.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_detail] dpd ON src.[property_id] = dpd.[property_detail_id]
					AND dpd.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON src.[property_id] = dphh.[property_healthy_homes_id]
					AND dphh.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_tenancy] dpt ON src.[property_tenancy_id] =  dpt.[property_tenancy_id] 
					AND dpt.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_maintenance] dpm ON src.[property_maintenance_id] = dpm.[property_maintenance_id]
					AND dpm.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_date] did ON src.[property_inspection_date_id] = did.[dim_date_key]
				LEFT JOIN [edw].[dim_date] disd ON src.[property_inspection_scheduled_date_id] = disd.[dim_date_key]
				LEFT JOIN [edw].[dim_time] tsit ON src.[property_inspection_scheduled_time_id] = tsit.[dim_time_key]
				LEFT JOIN [edw].[dim_date] dscd ON src.[property_inspection_completion_date_id] = dscd.[dim_date_key]
				LEFT JOIN [edw].[dim_time] tset ON src.[property_inspection_scheduled_end_time_id] = tset.[dim_time_key]
				LEFT JOIN [edw].[dim_date] drid ON src.[property_inspection_next_routine_inspection_date_id] = drid.[dim_date_key]
			
			;
		end else begin

			merge into [edw].[fact_property_inspection] as trg
			using 
			(
				select
					 src.[property_inspection_id] 
					,isnull(dp.[dim_property_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_key]
					,isnull(dpd.[dim_property_detail_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_detail_key]
					,isnull(dphh.[dim_property_healthy_homes_key], CASE WHEN src.property_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_healthy_homes_key]
					,isnull(dpt.[dim_property_tenancy_key], CASE WHEN src.property_tenancy_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_tenancy_key]
					,isnull(dpm.[dim_property_maintenance_key], CASE WHEN src.property_maintenance_id IS NOT NULL THEN -1 ELSE 0 END) AS [dim_property_maintenance_key]
					,src.[property_id] 
					,src.[property_tenancy_id] 
					,src.[property_maintenance_id] 
					,src.[property_inspection_code] 
					,src.[property_inspection_name] 
					--,src.[property_inspection_date_id] 
					--,src.[property_inspection_scheduled_date_id] 
					--,src.[property_inspection_scheduled_time_id] 
					--,src.[property_inspection_completion_date_id] 
					--,src.[property_inspection_scheduled_end_time_id] 
					--,src.[property_inspection_next_routine_inspection_date_id] 
					,isnull(did.[dim_date_key], CASE WHEN src.property_inspection_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_date_key]
					,isnull(disd.[dim_date_key], CASE WHEN src.property_inspection_scheduled_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_scheduled_date_key]
					,isnull(tsit.[dim_time_key], CASE WHEN src.property_inspection_scheduled_time_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_scheduled_time_key]
					,isnull(dscd.[dim_date_key], CASE WHEN src.property_inspection_completion_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_completion_date_key]
					,isnull(tset.[dim_time_key], CASE WHEN src.property_inspection_scheduled_end_time_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_scheduled_end_time_key]
					,isnull(drid.[dim_date_key], CASE WHEN src.property_inspection_next_routine_inspection_date_id IS NOT NULL THEN -1 ELSE 0 END) AS [property_inspection_next_routine_inspection_date_key]
					,src.[property_inspection_summary] 
					,src.[property_inspection_inspected_by] 
					,src.[property_inspection_category] 
					,src.[property_inspection_type] 
					,src.[property_inspection_maintenance_summary] 
					,src.[property_inspection_state] 
					,src.[property_inspection_status] 
					,src.[property_inspection_tenant_present_flag] 
					,src.[property_inspection_cancel_inspection_flag] 
					,src.[property_inspection_ignore_plugin_validate_flag] 
					,src.[property_inspection_tenant_confirmed_condition_flag] 
					,src.[property_inspection_owning_business_unit_name] 
					,src.[property_inspection_client] 
					,src.[property_inspection_property] 
					,src.[property_inspection_property_manager] 
					,src.[property_inspection_tenancy_manager] 
					,src.[property_inspection_tenant] 
					,src.[property_inspection_owner_name] 
					,src.[property_inspection_other_issue_comments] 
					,src.[property_inspection_chintaro_id] 
					,src.[property_inspection_comments] 
					,src.[property_inspection_relative_url] 
					,src.[property_inspection_suggested_improvements] 
					,src.[property_inspection_created_datetime] 
					,src.[property_inspection_modified_datetime] 
					,src.[property_inspection_is_delete_flag] 
					,@BatchID as [DWHBatchId]
					,getdate() as [DWHCreatedAt]
					,getdate() as [DWHModifiedOn]
					,'I' as [DWHDMLOperation]
					,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_property_inspection] as src
				LEFT JOIN [edw].[dim_property] dp ON src.[property_id] = dp.[property_id]
					AND dp.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_detail] dpd ON src.[property_id] = dpd.[property_detail_id]
					AND dpd.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON src.[property_id] = dphh.[property_healthy_homes_id]
					AND dphh.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_tenancy] dpt ON src.[property_tenancy_id] =  dpt.[property_tenancy_id] 
					AND dpt.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_property_maintenance] dpm ON src.[property_maintenance_id] = dpm.[property_maintenance_id]
					AND dpm.DWHIsCurrent = 1
				LEFT JOIN [edw].[dim_date] did ON src.[property_inspection_date_id] = did.[dim_date_key]
				LEFT JOIN [edw].[dim_date] disd ON src.[property_inspection_scheduled_date_id] = disd.[dim_date_key]
				LEFT JOIN [edw].[dim_time] tsit ON src.[property_inspection_scheduled_time_id] = tsit.[dim_time_key]
				LEFT JOIN [edw].[dim_date] dscd ON src.[property_inspection_completion_date_id] = dscd.[dim_date_key]
				LEFT JOIN [edw].[dim_time] tset ON src.[property_inspection_scheduled_end_time_id] = tset.[dim_time_key]
				LEFT JOIN [edw].[dim_date] drid ON src.[property_inspection_next_routine_inspection_date_id] = drid.[dim_date_key]
			) as src on (src.[property_inspection_id] = trg.[property_inspection_id])			-- Retire existing records
			when matched and exists 
			( 
				select src.[property_id], src.[property_tenancy_id], src.[property_maintenance_id], src.[property_inspection_code], src.[property_inspection_name], src.[property_inspection_date_key], src.[property_inspection_scheduled_date_key], src.[property_inspection_scheduled_time_key], src.[property_inspection_completion_date_key], src.[property_inspection_scheduled_end_time_key], src.[property_inspection_next_routine_inspection_date_key], src.[property_inspection_summary], src.[property_inspection_inspected_by], src.[property_inspection_category], src.[property_inspection_type], src.[property_inspection_maintenance_summary], src.[property_inspection_state], src.[property_inspection_status], src.[property_inspection_tenant_present_flag], src.[property_inspection_cancel_inspection_flag], src.[property_inspection_ignore_plugin_validate_flag], src.[property_inspection_tenant_confirmed_condition_flag], src.[property_inspection_owning_business_unit_name], src.[property_inspection_client], src.[property_inspection_property], src.[property_inspection_property_manager], src.[property_inspection_tenancy_manager], src.[property_inspection_tenant], src.[property_inspection_owner_name], src.[property_inspection_other_issue_comments], src.[property_inspection_chintaro_id], src.[property_inspection_comments], src.[property_inspection_relative_url], src.[property_inspection_suggested_improvements], src.[property_inspection_created_datetime], src.[property_inspection_is_delete_flag], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end--, src.[property_inspection_modified_datetime]
				except
				select trg.[property_id], trg.[property_tenancy_id], trg.[property_maintenance_id], trg.[property_inspection_code], trg.[property_inspection_name], trg.[property_inspection_date_key], trg.[property_inspection_scheduled_date_key], trg.[property_inspection_scheduled_time_key], trg.[property_inspection_completion_date_key], trg.[property_inspection_scheduled_end_time_key], trg.[property_inspection_next_routine_inspection_date_key], trg.[property_inspection_summary], trg.[property_inspection_inspected_by], trg.[property_inspection_category], trg.[property_inspection_type], trg.[property_inspection_maintenance_summary], trg.[property_inspection_state], trg.[property_inspection_status], trg.[property_inspection_tenant_present_flag], trg.[property_inspection_cancel_inspection_flag], trg.[property_inspection_ignore_plugin_validate_flag], trg.[property_inspection_tenant_confirmed_condition_flag], trg.[property_inspection_owning_business_unit_name], trg.[property_inspection_client], trg.[property_inspection_property], trg.[property_inspection_property_manager], trg.[property_inspection_tenancy_manager], trg.[property_inspection_tenant], trg.[property_inspection_owner_name], trg.[property_inspection_other_issue_comments], trg.[property_inspection_chintaro_id], trg.[property_inspection_comments], trg.[property_inspection_relative_url], trg.[property_inspection_suggested_improvements], trg.[property_inspection_created_datetime], trg.[property_inspection_is_delete_flag], 'X' --, trg.[property_inspection_modified_datetime]
			) then  update set 
				 [property_inspection_id] = src.[property_inspection_id]
				,[dim_property_key] = src.[dim_property_key]
				,[dim_property_detail_key] = src.[dim_property_detail_key]
				,[dim_property_healthy_homes_key] = src.[dim_property_healthy_homes_key]
				,[dim_property_tenancy_key] = src.[dim_property_tenancy_key]
				,[dim_property_maintenance_key] = src.[dim_property_maintenance_key]
				,[property_id] = src.[property_id]
				,[property_tenancy_id] = src.[property_tenancy_id]
				,[property_maintenance_id] = src.[property_maintenance_id]
				,[property_inspection_code] = src.[property_inspection_code]
				,[property_inspection_name] = src.[property_inspection_name]
				,[property_inspection_date_key] = src.[property_inspection_date_key]
				,[property_inspection_scheduled_date_key] = src.[property_inspection_scheduled_date_key]
				,[property_inspection_scheduled_time_key] = src.[property_inspection_scheduled_time_key]
				,[property_inspection_completion_date_key] = src.[property_inspection_completion_date_key]
				,[property_inspection_scheduled_end_time_key] = src.[property_inspection_scheduled_end_time_key]
				,[property_inspection_next_routine_inspection_date_key] = src.[property_inspection_next_routine_inspection_date_key]
				,[property_inspection_summary] = src.[property_inspection_summary]
				,[property_inspection_inspected_by] = src.[property_inspection_inspected_by]
				,[property_inspection_category] = src.[property_inspection_category]
				,[property_inspection_type] = src.[property_inspection_type]
				,[property_inspection_maintenance_summary] = src.[property_inspection_maintenance_summary]
				,[property_inspection_state] = src.[property_inspection_state]
				,[property_inspection_status] = src.[property_inspection_status]
				,[property_inspection_tenant_present_flag] = src.[property_inspection_tenant_present_flag]
				,[property_inspection_cancel_inspection_flag] = src.[property_inspection_cancel_inspection_flag]
				,[property_inspection_ignore_plugin_validate_flag] = src.[property_inspection_ignore_plugin_validate_flag]
				,[property_inspection_tenant_confirmed_condition_flag] = src.[property_inspection_tenant_confirmed_condition_flag]
				,[property_inspection_owning_business_unit_name] = src.[property_inspection_owning_business_unit_name]
				,[property_inspection_client] = src.[property_inspection_client]
				,[property_inspection_property] = src.[property_inspection_property]
				,[property_inspection_property_manager] = src.[property_inspection_property_manager]
				,[property_inspection_tenancy_manager] = src.[property_inspection_tenancy_manager]
				,[property_inspection_tenant] = src.[property_inspection_tenant]
				,[property_inspection_owner_name] = src.[property_inspection_owner_name]
				,[property_inspection_other_issue_comments] = src.[property_inspection_other_issue_comments]
				,[property_inspection_chintaro_id] = src.[property_inspection_chintaro_id]
				,[property_inspection_comments] = src.[property_inspection_comments]
				,[property_inspection_relative_url] = src.[property_inspection_relative_url]
				,[property_inspection_suggested_improvements] = src.[property_inspection_suggested_improvements]
				,[property_inspection_created_datetime] = src.[property_inspection_created_datetime]
				,[property_inspection_modified_datetime] = src.[property_inspection_modified_datetime]
				,[property_inspection_is_delete_flag] = src.[property_inspection_is_delete_flag]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D',[DWHBatchId] = @BatchID

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_inspection_id] 
					,dim_property_key
					,dim_property_detail_key
					,dim_property_healthy_homes_key
					,dim_property_tenancy_key
					,dim_property_maintenance_key
					,[property_id] 
					,[property_tenancy_id] 
					,[property_maintenance_id] 
					,[property_inspection_code] 
					,[property_inspection_name] 
					--,[property_inspection_date_id] 
					--,[property_inspection_scheduled_date_id] 
					--,[property_inspection_scheduled_time_id] 
					--,[property_inspection_completion_date_id] 
					--,[property_inspection_scheduled_end_time_id] 
					--,[property_inspection_next_routine_inspection_date_id] 
					,property_inspection_date_key
					,property_inspection_scheduled_date_key
					,property_inspection_scheduled_time_key
					,property_inspection_completion_date_key
					,property_inspection_scheduled_end_time_key
					,property_inspection_next_routine_inspection_date_key
					,[property_inspection_summary] 
					,[property_inspection_inspected_by] 
					,[property_inspection_category] 
					,[property_inspection_type] 
					,[property_inspection_maintenance_summary] 
					,[property_inspection_state] 
					,[property_inspection_status] 
					,[property_inspection_tenant_present_flag] 
					,[property_inspection_cancel_inspection_flag] 
					,[property_inspection_ignore_plugin_validate_flag] 
					,[property_inspection_tenant_confirmed_condition_flag] 
					,[property_inspection_owning_business_unit_name] 
					,[property_inspection_client] 
					,[property_inspection_property] 
					,[property_inspection_property_manager] 
					,[property_inspection_tenancy_manager] 
					,[property_inspection_tenant] 
					,[property_inspection_owner_name] 
					,[property_inspection_other_issue_comments] 
					,[property_inspection_chintaro_id] 
					,[property_inspection_comments] 
					,[property_inspection_relative_url] 
					,[property_inspection_suggested_improvements] 
					,[property_inspection_created_datetime] 
					,[property_inspection_modified_datetime] 
					,[property_inspection_is_delete_flag] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_inspection_id] 
					,src.dim_property_key
					,src.dim_property_detail_key
					,src.dim_property_healthy_homes_key
					,src.dim_property_tenancy_key
					,src.dim_property_maintenance_key
					,src.[property_id] 
					,src.[property_tenancy_id] 
					,src.[property_maintenance_id] 
					,src.[property_inspection_code] 
					,src.[property_inspection_name] 
					--,src.[property_inspection_date_id] 
					--,src.[property_inspection_scheduled_date_id] 
					--,src.[property_inspection_scheduled_time_id] 
					--,src.[property_inspection_completion_date_id] 
					--,src.[property_inspection_scheduled_end_time_id] 
					--,src.[property_inspection_next_routine_inspection_date_id] 
					,property_inspection_date_key
					,property_inspection_scheduled_date_key
					,property_inspection_scheduled_time_key
					,property_inspection_completion_date_key
					,property_inspection_scheduled_end_time_key
					,property_inspection_next_routine_inspection_date_key
					,src.[property_inspection_summary] 
					,src.[property_inspection_inspected_by] 
					,src.[property_inspection_category] 
					,src.[property_inspection_type] 
					,src.[property_inspection_maintenance_summary] 
					,src.[property_inspection_state] 
					,src.[property_inspection_status] 
					,src.[property_inspection_tenant_present_flag] 
					,src.[property_inspection_cancel_inspection_flag] 
					,src.[property_inspection_ignore_plugin_validate_flag] 
					,src.[property_inspection_tenant_confirmed_condition_flag] 
					,src.[property_inspection_owning_business_unit_name] 
					,src.[property_inspection_client] 
					,src.[property_inspection_property] 
					,src.[property_inspection_property_manager] 
					,src.[property_inspection_tenancy_manager] 
					,src.[property_inspection_tenant] 
					,src.[property_inspection_owner_name] 
					,src.[property_inspection_other_issue_comments] 
					,src.[property_inspection_chintaro_id] 
					,src.[property_inspection_comments] 
					,src.[property_inspection_relative_url] 
					,src.[property_inspection_suggested_improvements] 
					,src.[property_inspection_created_datetime] 
					,src.[property_inspection_modified_datetime] 
					,src.[property_inspection_is_delete_flag] 
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
		from [edw].[fact_property_inspection];

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