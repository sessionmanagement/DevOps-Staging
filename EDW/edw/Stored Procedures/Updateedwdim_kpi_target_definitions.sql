
CREATE procedure [edw].[Updateedwdim_kpi_target_definitions] 
	
/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_employee] 
 Author		Greg Nuthall	
 Created	14-04-2025	
 Purpose	Service target definitions table from the Organisational Performance Sharepoint
			site added to the EDW so that analyst can build kpi's with service specific targets. 
			
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date			Author					Description
-------	------------	------------------		--------------------------
1.0		14-04-2025		Greg Nuthall			Initial creation of stored procedure
1.1     2025-05-06      Manish Singh            Changed Prefix of Audit columns from EDW to DWH
1.2     2025-05-26	    Greg Nuthall		    Add new column outcome_tool_review 
**********************************************************************************************************/

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
	declare @SourceSystem nvarchar(120) = 'Sharepoint target definitions';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	declare @SystemEffectiveFrom datetime = @systemCurrentDate;
	declare @SystemEffectiveTo datetime = dateadd(second,-1,@SystemEffectiveFrom);
	declare @SystemDefaultEffectiveFrom datetime = '1 January 1900';
	declare @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';

	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_kpi_target_definitions];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_kpi_target_definitions];

		-- Select success details
		select
			 @pErrorRecords = 0
			,@pInsertRecords = 0
			,@pUpdateRecords = 0
			,@pDeleteRecords = 0
			,@pCompleted = 1
			,@pTargetRecords = @targetRecords	

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

	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
		 [target_definition_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[dim_kpi_target_definitions]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_kpi_target_definitions]
			(
				 [target_definition_id] 
				,[dim_service_key]
				,[dim_service_type_key]
				,[service_id] 
				,[service_code] 
				,[service_name] 
				,[service_type] 
				,[service_type_id]
				,[region] 
				,[temp_region] 
				,[district] 
				,[bed_nights] 
				,[caseload] 
				,[fully_staffed_fte] 
				,[support_hours] 
				,[programmes_delivered] 
				,[service_action_plan_link] 
				,[bed_nights_applies] 
				,[fully_staffed_applies] 
				,[support_hours_applies] 
				,[prog_delivered_target_applies] 
				,[caseload_target_applies] 
				,[goal_planning_applies]
				,[outcome_tool_review]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[target_definition_id] 
				,src.[dim_service_key]
				,src.[dim_service_type_key]
				,src.[service_id] 
				,src.[service_code] 
				,src.[service_name] 
				,src.[service_type] 
				,src.[service_type_id]
				,src.[region] 
				,src.[temp_region] 
				,src.[district] 
				,src.[bed_nights] 
				,src.[caseload] 
				,src.[fully_staffed_fte] 
				,src.[support_hours] 
				,src.[programmes_delivered] 
				,src.[service_action_plan_link] 
				,src.[bed_nights_applies] 
				,src.[fully_staffed_applies] 
				,src.[support_hours_applies] 
				,src.[prog_delivered_target_applies] 
				,src.[caseload_target_applies] 
				,src.[goal_planning_applies]
				,src.[outcome_tool_review]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_kpi_target_definitions] as src;
		end else begin
			merge into [edw].[dim_kpi_target_definitions] as trg
			using 
			(
				select
				 src.[target_definition_id] 
				,src.[dim_service_key]
				,src.[dim_service_type_key]
				,src.[service_id] 
				,src.[service_code] 
				,src.[service_name] 
				,src.[service_type] 
				,src.[service_type_id]
				,src.[region] 
				,src.[temp_region] 
				,src.[district] 
				,src.[bed_nights] 
				,src.[caseload] 
				,src.[fully_staffed_fte] 
				,src.[support_hours] 
				,src.[programmes_delivered] 
				,src.[service_action_plan_link] 
				,src.[bed_nights_applies] 
				,src.[fully_staffed_applies] 
				,src.[support_hours_applies] 
				,src.[prog_delivered_target_applies] 
				,src.[caseload_target_applies]
				,src.[goal_planning_applies]
				,src.[outcome_tool_review]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_kpi_target_definitions] as src
			) as src on (src.[target_definition_id] = trg.[target_definition_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[service_id], src.[service_code], src.[service_name], src.[service_type], src.[service_type_id], src.[region], src.[temp_region], src.[district], src.[bed_nights], src.[caseload], src.[fully_staffed_fte], src.[support_hours], src.[programmes_delivered], src.[service_action_plan_link], src.[bed_nights_applies], src.[fully_staffed_applies], src.[support_hours_applies], src.[prog_delivered_target_applies], src.[caseload_target_applies], src.[goal_planning_applies], src.[outcome_tool_review], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[service_id], trg.[service_code], trg.[service_name], trg.[service_type], trg.[service_type_id], trg.[region], trg.[temp_region], trg.[district], trg.[bed_nights], trg.[caseload], trg.[fully_staffed_fte], trg.[support_hours], trg.[programmes_delivered], trg.[service_action_plan_link], trg.[bed_nights_applies], trg.[fully_staffed_applies], trg.[support_hours_applies], trg.[prog_delivered_target_applies], trg.[caseload_target_applies], trg.[goal_planning_applies], trg.[outcome_tool_review], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [target_definition_id]
					,[dim_service_key]
					,[dim_service_type_key]
					,[service_id] 
					,[service_code] 
					,[service_name] 
					,[service_type] 
					,[service_type_id]
					,[region] 
					,[temp_region] 
					,[district] 
					,[bed_nights] 
					,[caseload] 
					,[fully_staffed_fte] 
					,[support_hours] 
					,[programmes_delivered] 
					,[service_action_plan_link] 
					,[bed_nights_applies] 
					,[fully_staffed_applies] 
					,[support_hours_applies] 
					,[prog_delivered_target_applies] 
					,[caseload_target_applies] 
					,[goal_planning_applies]
					,[outcome_tool_review]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[target_definition_id]
					,src.[dim_service_key]
					,src.[dim_service_type_key]
					,src.[service_id] 
					,src.[service_code] 
					,src.[service_name] 
					,src.[service_type] 
					,src.[service_type_id]
					,src.[region] 
					,src.[temp_region] 
					,src.[district] 
					,src.[bed_nights] 
					,src.[caseload] 
					,src.[fully_staffed_fte] 
					,src.[support_hours] 
					,src.[programmes_delivered] 
					,src.[service_action_plan_link] 
					,src.[bed_nights_applies] 
					,src.[fully_staffed_applies] 
					,src.[support_hours_applies] 
					,src.[prog_delivered_target_applies] 
					,src.[caseload_target_applies] 
					,src.[goal_planning_applies]
					,src.[outcome_tool_review]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[target_definition_id],inserted.[target_definition_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_kpi_target_definitions]
			(
				 [target_definition_id] 
				,[dim_service_key]
				,[dim_service_type_key]
				,[service_id] 
				,[service_code] 
				,[service_name] 
				,[service_type] 
				,[service_type_id]
				,[region] 
				,[temp_region] 
				,[district] 
				,[bed_nights] 
				,[caseload] 
				,[fully_staffed_fte] 
				,[support_hours] 
				,[programmes_delivered] 
				,[service_action_plan_link] 
				,[bed_nights_applies] 
				,[fully_staffed_applies] 
				,[support_hours_applies] 
				,[prog_delivered_target_applies] 
				,[caseload_target_applies] 
				,[goal_planning_applies]
				,[outcome_tool_review]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[target_definition_id]
				,src.[dim_service_key]
				,src.[dim_service_type_key]
				,src.[service_id] 
				,src.[service_code] 
				,src.[service_name] 
				,src.[service_type] 
				,src.[service_type_id]
				,src.[region] 
				,src.[temp_region] 
				,src.[district] 
				,src.[bed_nights] 
				,src.[caseload] 
				,src.[fully_staffed_fte] 
				,src.[support_hours] 
				,src.[programmes_delivered] 
				,src.[service_action_plan_link] 
				,src.[bed_nights_applies] 
				,src.[fully_staffed_applies] 
				,src.[support_hours_applies] 
				,src.[prog_delivered_target_applies] 
				,src.[caseload_target_applies] 
				,src.[goal_planning_applies]
				,src.[outcome_tool_review]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Sharepoint target definitions'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_kpi_target_definitions] as src on src.[target_definition_id] = base.[target_definition_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[target_definition_id] 
				,tbl.[dim_service_key]
				,tbl.[dim_service_type_key]
				,tbl.[service_id] 
				,tbl.[service_code] 
				,tbl.[service_name] 
				,tbl.[service_type] 
				,tbl.[service_type_id]
				,tbl.[region] 
				,tbl.[temp_region] 
				,tbl.[district] 
				,tbl.[bed_nights] 
				,tbl.[caseload] 
				,tbl.[fully_staffed_fte] 
				,tbl.[support_hours] 
				,tbl.[programmes_delivered] 
				,tbl.[service_action_plan_link] 
				,tbl.[bed_nights_applies] 
				,tbl.[fully_staffed_applies] 
				,tbl.[support_hours_applies] 
				,tbl.[prog_delivered_target_applies] 
				,tbl.[caseload_target_applies]
				,tbl.[goal_planning_applies]
				,tbl.[outcome_tool_review]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Sharepoint target definitions'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_kpi_target_definitions] as tbl on tbl.[target_definition_id] = base.[target_definition_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_kpi_target_definitions] as src on src.[target_definition_id] = base.[target_definition_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[target_definition_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_kpi_target_definitions]
		where [DWHEffectiveTo] = @SystemDefaultEffectiveTo;

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