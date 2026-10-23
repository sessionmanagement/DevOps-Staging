

CREATE procedure [edw].[Updateedwfact_employee_on_call_log] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'sharepoint on_call_log';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_on_call_log];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_on_call_log];

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
					@targetRecords	as TargetRecords;
		end;

		return;
	end;

	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_on_call_log]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_on_call_log]
			(    [dim_region_key] 
	            ,[dim_service_key] 
	            ,[dim_employee_key] 
	            ,[dim_employee_escalated_to_key]
	            ,[dim_employee_on_call_key] 
				,[dim_call_date_key]
				,[on_call_id] 
				,[call_date_time] 
				,[region_id] 
				,[region_original_name] 
				,[service_id] 
				,[service_original_name] 
				,[category_id] 
				,[category_name] 
				,[call_received_from] 
				,[extra_time] 
				,[incident_report_required] 
				,[escalated_to_another_tier] 
				,[employee_escalated_to_id] 
				,[shift_covered] 
				,[hours_covered] 
				,[event_status] 
				,[employee_on_call_id] 
				,[travel_time] 
				,[over_96_hours] 
				,[shift_covered_kaimahi] 
				,[created_date_time] 
				,[call_duration]
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_region_key] 
	            ,src.[dim_service_key] 
	            ,src.[dim_employee_key] 
	            ,src.[dim_employee_escalated_to_key]
	            ,src.[dim_employee_on_call_key] 
				,src.[dim_call_date_key]
				,src.[on_call_id] 
				,src.[call_date_time] 
				,src.[region_id] 
				,src.[region_original_name] 
				,src.[service_id] 
				,src.[service_original_name] 
				,src.[category_id] 
				,src.[category_name] 
				,src.[call_received_from] 
				,src.[extra_time] 
				,src.[incident_report_required] 
				,src.[escalated_to_another_tier] 
				,src.[employee_escalated_to_id] 
				,src.[shift_covered] 
				,src.[hours_covered] 
				,src.[event_status] 
				,src.[employee_on_call_id] 
				,src.[travel_time] 
				,src.[over_96_hours] 
				,src.[shift_covered_kaimahi] 
				,src.[created_date_time]
				,src.[call_duration]
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_on_call_log] as src;
		end else begin
			merge into [edw].[fact_employee_on_call_log] as trg
			using 
			(
				select
				src.[dim_region_key] 
	            ,src.[dim_service_key] 
	            ,src.[dim_employee_key] 
	            ,src.[dim_employee_escalated_to_key]
	            ,src.[dim_employee_on_call_key] 
				,src.[dim_call_date_key]
				,src.[on_call_id] 
				,src.[call_date_time] 
				,src.[region_id] 
				,src.[region_original_name] 
				,src.[service_id] 
				,src.[service_original_name] 
				,src.[category_id] 
				,src.[category_name] 
				,src.[call_received_from] 
				,src.[extra_time] 
				,src.[incident_report_required] 
				,src.[escalated_to_another_tier] 
				,src.[employee_escalated_to_id] 
				,src.[shift_covered] 
				,src.[hours_covered] 
				,src.[event_status] 
				,src.[employee_on_call_id] 
				,src.[travel_time] 
				,src.[over_96_hours] 
				,src.[shift_covered_kaimahi] 
				,src.[created_date_time]
				,src.[call_duration]
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_on_call_log] as src
			) as src on (src.[on_call_id] = trg.[on_call_id])			-- Retire existing records
			when matched and exists 
			( 
				select src.[call_date_time], src.[region_id], src.[region_original_name], src.[service_id], src.[service_original_name], src.[category_id], src.[category_name], src.[call_received_from], src.[extra_time], src.[incident_report_required], src.[escalated_to_another_tier], src.[employee_escalated_to_id],  src.[shift_covered], src.[hours_covered], src.[event_status], src.[employee_on_call_id], src.[travel_time], src.[over_96_hours], src.[shift_covered_kaimahi], src.[created_date_time],src.[call_duration]
				except
				select trg.[call_date_time], trg.[region_id], trg.[region_original_name], trg.[service_id], trg.[service_original_name], trg.[category_id], trg.[category_name], trg.[call_received_from], trg.[extra_time], trg.[incident_report_required], trg.[escalated_to_another_tier], trg.[employee_escalated_to_id],  trg.[shift_covered], trg.[hours_covered], trg.[event_status], trg.[employee_on_call_id], trg.[travel_time], trg.[over_96_hours], trg.[shift_covered_kaimahi], trg.[created_date_time],trg.[call_duration]
			) then  update set 
				 [on_call_id] = src.[on_call_id]
				, [call_date_time] = src.[call_date_time]
				, [region_id] = src.[region_id]
				, [region_original_name] = src.[region_original_name]
				, [service_id] = src.[service_id]
				, [service_original_name] = src.[service_original_name]
				, [category_id] = src.[category_id]
				, [category_name] = src.[category_name]
				, [call_received_from] = src.[call_received_from]
				, [extra_time] = src.[extra_time]
				, [incident_report_required] = src.[incident_report_required]
				, [escalated_to_another_tier] = src.[escalated_to_another_tier]
				, [employee_escalated_to_id] = src.[employee_escalated_to_id]
				, [shift_covered] = src.[shift_covered]
				, [hours_covered] = src.[hours_covered]
				, [event_status] = src.[event_status]
				, [employee_on_call_id] = src.[employee_on_call_id]
				, [travel_time] = src.[travel_time]
				, [over_96_hours] = src.[over_96_hours]
				, [shift_covered_kaimahi] = src.[shift_covered_kaimahi]
				, [created_date_time] = src.[created_date_time]
				, [call_duration] = src.[call_duration]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
					([dim_region_key] 
					,[dim_service_key] 
					,[dim_employee_key] 
					,[dim_employee_escalated_to_key]
					,[dim_employee_on_call_key] 
					,[dim_call_date_key]
					,[on_call_id] 
					,[call_date_time] 
					,[region_id] 
					,[region_original_name] 
					,[service_id] 
					,[service_original_name] 
					,[category_id] 
					,[category_name] 
					,[call_received_from] 
					,[extra_time] 
					,[incident_report_required] 
					,[escalated_to_another_tier] 
					,[employee_escalated_to_id] 
					,[shift_covered] 
					,[hours_covered] 
					,[event_status] 
					,[employee_on_call_id] 
					,[travel_time] 
					,[over_96_hours] 
					,[shift_covered_kaimahi] 
					,[created_date_time]
					,[call_duration]
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
					(src.[dim_region_key] 
					,src.[dim_service_key] 
					,src.[dim_employee_key] 
					,src.[dim_employee_escalated_to_key]
					,src.[dim_employee_on_call_key] 
					,src.[dim_call_date_key]
					,src.[on_call_id] 
					,src.[call_date_time] 
					,src.[region_id] 
					,src.[region_original_name] 
					,src.[service_id] 
					,src.[service_original_name] 
					,src.[category_id] 
					,src.[category_name] 
					,src.[call_received_from] 
					,src.[extra_time] 
					,src.[incident_report_required] 
					,src.[escalated_to_another_tier] 
					,src.[employee_escalated_to_id] 
					,src.[shift_covered] 
					,src.[hours_covered] 
					,src.[event_status] 
					,src.[employee_on_call_id] 
					,src.[travel_time] 
					,src.[over_96_hours] 
					,src.[shift_covered_kaimahi] 
					,src.[created_date_time] 
					,src.[call_duration]
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
		from [edw].[fact_employee_on_call_log];

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

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords;
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
				@targetRecords	as TargetRecords;
	end;
end;