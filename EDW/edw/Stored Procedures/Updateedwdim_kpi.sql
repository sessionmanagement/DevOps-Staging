CREATE   procedure [edw].[Updateedwdim_kpi] 

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_kpi] 
 Author		Manish Singh
		
				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================

REVISIONS:
Version	Date		  Author			    Description
-------	------------  ------------------	--------------------------
1.0			  ?		  Manish Singh			Initial creation of stored procedure
1.1			  ?								Added two new fields sim_title,additional_reporting
1.2		18/07/2025    Greg Nuthall			Changed to compare nulls to ensure all changes are loaded
1.3		05/09/2025    Greg Nuthall			User Story 11130: Added relevant_bu column
1.4		2026-08-20    Greg Nuthall			User Story 14335: Added additional_report_name column
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
	declare @SourceSystem nvarchar(120) = 'sharepoint measures table';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_kpi];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_kpi];

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
		 [kpi_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[dim_kpi]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_kpi]
			(
				 [kpi_id] 
				,[gap_analysis_notes] 
				,[gap_analysis_status] 
				,[kpi_target_green] 
				,[kpi_g_sign] 
				,[kpi_g_value] 
				,[kpi_ru_g_sign] 
				,[kpi_ru_g_value] 
				,[kpi_target_amber] 
				,[kpi_a_sign] 
				,[kpi_a_value] 
				,[kpi_ru_a_sign] 
				,[kpi_ru_a_value] 
				,[kpi_target_rollup_amber] 
				,[kpi_target_rollup_green] 
				,[related_kpi_outcome_lookup_value] 
				,[related_outcome] 
				,[sfa_rollup_area] 
				,[sfa_rollup_areas_strategic_focus_area] 
				,[sfa_rollup_areas_lookup_value] 
				,[specific_measure] 
				,[status] 
				,[what_is_measured] 
				,[call_to_action]
				,[sim_title]
				,[additional_reporting]
				,[additional_report_name]
				,[relevant_bu]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[kpi_id] 
				,src.[gap_analysis_notes] 
				,src.[gap_analysis_status] 
				,src.[kpi_target_green] 
				,src.[kpi_g_sign] 
				,src.[kpi_g_value] 
				,src.[kpi_ru_g_sign] 
				,src.[kpi_ru_g_value] 
				,src.[kpi_target_amber] 
				,src.[kpi_a_sign] 
				,src.[kpi_a_value] 
				,src.[kpi_ru_a_sign] 
				,src.[kpi_ru_a_value] 
				,src.[kpi_target_rollup_amber] 
				,src.[kpi_target_rollup_green] 
				,src.[related_kpi_outcome_lookup_value] 
				,src.[related_outcome] 
				,src.[sfa_rollup_area] 
				,src.[sfa_rollup_areas_strategic_focus_area] 
				,src.[sfa_rollup_areas_lookup_value] 
				,src.[specific_measure] 
				,src.[status] 
				,src.[what_is_measured] 
				,src.[call_to_action] 
				,src.[sim_title]
				,src.[additional_reporting]
				,src.[additional_report_name]
				,src.[relevant_bu]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_kpi] as src;
		end else begin
			merge into [edw].[dim_kpi] as trg
			using 
			(
				select
				 src.[kpi_id] 
				,src.[gap_analysis_notes] 
				,src.[gap_analysis_status] 
				,src.[kpi_target_green] 
				,src.[kpi_g_sign] 
				,src.[kpi_g_value] 
				,src.[kpi_ru_g_sign] 
				,src.[kpi_ru_g_value] 
				,src.[kpi_target_amber] 
				,src.[kpi_a_sign] 
				,src.[kpi_a_value] 
				,src.[kpi_ru_a_sign] 
				,src.[kpi_ru_a_value] 
				,src.[kpi_target_rollup_amber] 
				,src.[kpi_target_rollup_green] 
				,src.[related_kpi_outcome_lookup_value] 
				,src.[related_outcome] 
				,src.[sfa_rollup_area] 
				,src.[sfa_rollup_areas_strategic_focus_area] 
				,src.[sfa_rollup_areas_lookup_value] 
				,src.[specific_measure] 
				,src.[status] 
				,src.[what_is_measured] 
				,src.[call_to_action] 
				,src.[sim_title]
				,src.[additional_reporting]
				,src.[additional_report_name]
				,src.[relevant_bu]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_kpi] as src
			) as src on (src.[kpi_id] = trg.[kpi_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				SELECT isnull(src.[gap_analysis_notes],'')
					,isnull(src.[gap_analysis_status],'')
					,isnull(src.[kpi_target_green],'')
					,isnull(src.[kpi_g_sign],'')
					,src.[kpi_g_value]
					,isnull(src.[kpi_ru_g_sign],'')
					,src.[kpi_ru_g_value]
					,isnull(src.[kpi_target_amber],'')
					,isnull(src.[kpi_a_sign],'')
					,src.[kpi_a_value]
					,isnull(src.[kpi_ru_a_sign],'')
					,src.[kpi_ru_a_value]
					,isnull(src.[kpi_target_rollup_amber],'')
					,isnull(src.[kpi_target_rollup_green],'')
					,isnull(src.[related_kpi_outcome_lookup_value],'')
					,isnull(src.[related_outcome],'')
					,isnull(src.[sfa_rollup_area],'')
					,isnull(src.[sfa_rollup_areas_strategic_focus_area],'')
					,src.[sfa_rollup_areas_lookup_value]
					,src.[specific_measure]
					,isnull(src.[status],'')
					,isnull(src.[what_is_measured],'')
					,isnull(src.[call_to_action],'')
					,isnull(src.[sim_title],'')
					,isnull(src.[additional_reporting] ,'')
					,isnull(src.[additional_report_name] ,'')
					,isnull(src.[relevant_bu],'')
					,CASE 
						WHEN trg.[DWHDMLOperation] = 'D'
							THEN 'U'
						ELSE 'X'
						END

				EXCEPT

				SELECT isnull(trg.[gap_analysis_notes],'')
					,isnull(trg.[gap_analysis_status],'')
					,isnull(trg.[kpi_target_green],'')
					,isnull(trg.[kpi_g_sign],'')
					,trg.[kpi_g_value]
					,isnull(trg.[kpi_ru_g_sign],'')
					,trg.[kpi_ru_g_value]
					,isnull(trg.[kpi_target_amber],'')
					,isnull(trg.[kpi_a_sign],'')
					,trg.[kpi_a_value]
					,isnull(trg.[kpi_ru_a_sign],'')
					,trg.[kpi_ru_a_value]
					,isnull(trg.[kpi_target_rollup_amber],'')
					,isnull(trg.[kpi_target_rollup_green],'')
					,isnull(trg.[related_kpi_outcome_lookup_value],'')
					,isnull(trg.[related_outcome],'')
					,isnull(trg.[sfa_rollup_area],'')
					,isnull(trg.[sfa_rollup_areas_strategic_focus_area],'')
					,trg.[sfa_rollup_areas_lookup_value]
					,trg.[specific_measure]
					,isnull(trg.[status],'')
					,isnull(trg.[what_is_measured],'')
					,isnull(trg.[call_to_action],'')
					,isnull(trg.[sim_title],'')
					,isnull(trg.[additional_reporting] ,'')
					,isnull(trg.[additional_report_name] ,'')
					,isnull(trg.[relevant_bu],'')
					,'X'
	) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [kpi_id] 
					,[gap_analysis_notes] 
					,[gap_analysis_status] 
					,[kpi_target_green] 
					,[kpi_g_sign] 
					,[kpi_g_value] 
					,[kpi_ru_g_sign] 
					,[kpi_ru_g_value] 
					,[kpi_target_amber] 
					,[kpi_a_sign] 
					,[kpi_a_value] 
					,[kpi_ru_a_sign] 
					,[kpi_ru_a_value] 
					,[kpi_target_rollup_amber] 
					,[kpi_target_rollup_green] 
					,[related_kpi_outcome_lookup_value] 
					,[related_outcome] 
					,[sfa_rollup_area] 
					,[sfa_rollup_areas_strategic_focus_area] 
					,[sfa_rollup_areas_lookup_value] 
					,[specific_measure] 
					,[status] 
					,[what_is_measured] 
					,[call_to_action] 
					,[sim_title]
					,[additional_reporting]
					,[additional_report_name]
					,[relevant_bu]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[kpi_id] 
					,src.[gap_analysis_notes] 
					,src.[gap_analysis_status] 
					,src.[kpi_target_green] 
					,src.[kpi_g_sign] 
					,src.[kpi_g_value] 
					,src.[kpi_ru_g_sign] 
					,src.[kpi_ru_g_value] 
					,src.[kpi_target_amber] 
					,src.[kpi_a_sign] 
					,src.[kpi_a_value] 
					,src.[kpi_ru_a_sign] 
					,src.[kpi_ru_a_value] 
					,src.[kpi_target_rollup_amber] 
					,src.[kpi_target_rollup_green] 
					,src.[related_kpi_outcome_lookup_value] 
					,src.[related_outcome] 
					,src.[sfa_rollup_area] 
					,src.[sfa_rollup_areas_strategic_focus_area] 
					,src.[sfa_rollup_areas_lookup_value] 
					,src.[specific_measure] 
					,src.[status] 
					,src.[what_is_measured] 
					,src.[call_to_action] 
					,src.[sim_title]
					,src.[additional_reporting]
					,src.[additional_report_name]
					,src.[relevant_bu]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[kpi_id],inserted.[kpi_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_kpi]
			(
				 [kpi_id] 
				,[gap_analysis_notes] 
				,[gap_analysis_status] 
				,[kpi_target_green] 
				,[kpi_g_sign] 
				,[kpi_g_value] 
				,[kpi_ru_g_sign] 
				,[kpi_ru_g_value] 
				,[kpi_target_amber] 
				,[kpi_a_sign] 
				,[kpi_a_value] 
				,[kpi_ru_a_sign] 
				,[kpi_ru_a_value] 
				,[kpi_target_rollup_amber] 
				,[kpi_target_rollup_green] 
				,[related_kpi_outcome_lookup_value] 
				,[related_outcome] 
				,[sfa_rollup_area] 
				,[sfa_rollup_areas_strategic_focus_area] 
				,[sfa_rollup_areas_lookup_value] 
				,[specific_measure] 
				,[status] 
				,[what_is_measured] 
				,[call_to_action] 
				,[sim_title]
				,[additional_reporting]
				,[additional_report_name]
				,[relevant_bu]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[kpi_id] 
				,src.[gap_analysis_notes] 
				,src.[gap_analysis_status] 
				,src.[kpi_target_green] 
				,src.[kpi_g_sign] 
				,src.[kpi_g_value] 
				,src.[kpi_ru_g_sign] 
				,src.[kpi_ru_g_value] 
				,src.[kpi_target_amber] 
				,src.[kpi_a_sign] 
				,src.[kpi_a_value] 
				,src.[kpi_ru_a_sign] 
				,src.[kpi_ru_a_value] 
				,src.[kpi_target_rollup_amber] 
				,src.[kpi_target_rollup_green] 
				,src.[related_kpi_outcome_lookup_value] 
				,src.[related_outcome] 
				,src.[sfa_rollup_area] 
				,src.[sfa_rollup_areas_strategic_focus_area] 
				,src.[sfa_rollup_areas_lookup_value] 
				,src.[specific_measure] 
				,src.[status] 
				,src.[what_is_measured] 
				,src.[call_to_action]
				,src.[sim_title]
				,src.[additional_reporting]
				,src.[additional_report_name]
				,src.[relevant_bu]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_kpi]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_kpi] as src on src.[kpi_id] = base.[kpi_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[kpi_id] 
				,tbl.[gap_analysis_notes] 
				,tbl.[gap_analysis_status] 
				,tbl.[kpi_target_green] 
				,tbl.[kpi_g_sign] 
				,tbl.[kpi_g_value] 
				,tbl.[kpi_ru_g_sign] 
				,tbl.[kpi_ru_g_value] 
				,tbl.[kpi_target_amber] 
				,tbl.[kpi_a_sign] 
				,tbl.[kpi_a_value] 
				,tbl.[kpi_ru_a_sign] 
				,tbl.[kpi_ru_a_value] 
				,tbl.[kpi_target_rollup_amber] 
				,tbl.[kpi_target_rollup_green] 
				,tbl.[related_kpi_outcome_lookup_value] 
				,tbl.[related_outcome] 
				,tbl.[sfa_rollup_area] 
				,tbl.[sfa_rollup_areas_strategic_focus_area] 
				,tbl.[sfa_rollup_areas_lookup_value] 
				,tbl.[specific_measure] 
				,tbl.[status] 
				,tbl.[what_is_measured] 
				,tbl.[call_to_action] 
				,tbl.[sim_title]
				,tbl.[additional_reporting]
				,tbl.[additional_report_name]
				,tbl.[relevant_bu]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_kpi]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_kpi] as tbl on tbl.[kpi_id] = base.[kpi_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_kpi] as src on src.[kpi_id] = base.[kpi_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[kpi_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_kpi]
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