
CREATE procedure [edw].[Updateedwdim_outcome_indicator] 
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
	declare @SourceSystem nvarchar(120) = 'sharepoint outcome list';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_outcome_indicator];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_outcome_indicator];

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
		 [indicator_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[dim_outcome_indicator]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_outcome_indicator]
			(
				 [indicator_id] 
				,[indicator] 
				,[specific_outcome_id] 
				,[priority_outcome_id] 
				,[wellbeing_domain_id] 
				,[priority_outcome] 
				,[specific_outcome] 
				,[relates_to_outcome] 
				,[wellbeing_domain] 
				,[data_type] 
				,[measure_type] 
				,[indicator_description] 
				,[indicator_definition_status] 
				,[relates_to] 
				,[measure_logic] 
				,[enrolled_teams_or_services] 
				,[enrolled_sub_programme_id] 
				,[enrolled_sub_programme_value] 
				,[considerations] 
				,[delivery_phasing] 
				,[datasource_1] 
				,[datasource_2] 
				,[datasource_3] 
				,[leading_sign] 
				,[trailing_sign] 
				,[rounding_dp] 
				,[description_positive] 
				,[qualifier_text] 
				,[qualifier_text_part2] 
				,[qualifier_number_logic] 
				,[example_of_this_reported] 
				,[include_in_macroview] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[indicator_id] 
				,src.[indicator] 
				,src.[specific_outcome_id] 
				,src.[priority_outcome_id] 
				,src.[wellbeing_domain_id] 
				,src.[priority_outcome] 
				,src.[specific_outcome] 
				,src.[relates_to_outcome] 
				,src.[wellbeing_domain] 
				,src.[data_type] 
				,src.[measure_type] 
				,src.[indicator_description] 
				,src.[indicator_definition_status] 
				,src.[relates_to] 
				,src.[measure_logic] 
				,src.[enrolled_teams_or_services] 
				,src.[enrolled_sub_programme_id] 
				,src.[enrolled_sub_programme_value] 
				,src.[considerations] 
				,src.[delivery_phasing] 
				,src.[datasource_1] 
				,src.[datasource_2] 
				,src.[datasource_3] 
				,src.[leading_sign] 
				,src.[trailing_sign] 
				,src.[rounding_dp] 
				,src.[description_positive] 
				,src.[qualifier_text] 
				,src.[qualifier_text_part2] 
				,src.[qualifier_number_logic] 
				,src.[example_of_this_reported] 
				,src.[include_in_macroview] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_outcome_indicator] as src;
		end else begin
			merge into [edw].[dim_outcome_indicator] as trg
			using 
			(
				select
				 src.[indicator_id] 
				,src.[indicator] 
				,src.[specific_outcome_id] 
				,src.[priority_outcome_id] 
				,src.[wellbeing_domain_id] 
				,src.[priority_outcome] 
				,src.[specific_outcome] 
				,src.[relates_to_outcome] 
				,src.[wellbeing_domain] 
				,src.[data_type] 
				,src.[measure_type] 
				,src.[indicator_description] 
				,src.[indicator_definition_status] 
				,src.[relates_to] 
				,src.[measure_logic] 
				,src.[enrolled_teams_or_services] 
				,src.[enrolled_sub_programme_id] 
				,src.[enrolled_sub_programme_value] 
				,src.[considerations] 
				,src.[delivery_phasing] 
				,src.[datasource_1] 
				,src.[datasource_2] 
				,src.[datasource_3] 
				,src.[leading_sign] 
				,src.[trailing_sign] 
				,src.[rounding_dp] 
				,src.[description_positive] 
				,src.[qualifier_text] 
				,src.[qualifier_text_part2] 
				,src.[qualifier_number_logic] 
				,src.[example_of_this_reported] 
				,src.[include_in_macroview] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_outcome_indicator] as src
			) as src on (src.[indicator_id] = trg.[indicator_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[indicator], src.[specific_outcome_id], src.[priority_outcome_id], src.[wellbeing_domain_id], src.[priority_outcome], src.[specific_outcome], src.[relates_to_outcome], src.[wellbeing_domain], src.[data_type], src.[measure_type], src.[indicator_description], src.[indicator_definition_status], src.[relates_to], src.[measure_logic], src.[enrolled_teams_or_services], src.[enrolled_sub_programme_id], src.[enrolled_sub_programme_value], src.[considerations], src.[delivery_phasing], src.[datasource_1], src.[datasource_2], src.[datasource_3], src.[leading_sign], src.[trailing_sign], src.[rounding_dp], src.[description_positive], src.[qualifier_text], src.[qualifier_text_part2], src.[qualifier_number_logic], src.[example_of_this_reported], src.[include_in_macroview], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[indicator], trg.[specific_outcome_id], trg.[priority_outcome_id], trg.[wellbeing_domain_id], trg.[priority_outcome], trg.[specific_outcome], trg.[relates_to_outcome], trg.[wellbeing_domain], trg.[data_type], trg.[measure_type], trg.[indicator_description], trg.[indicator_definition_status], trg.[relates_to], trg.[measure_logic], trg.[enrolled_teams_or_services], trg.[enrolled_sub_programme_id], trg.[enrolled_sub_programme_value], trg.[considerations], trg.[delivery_phasing], trg.[datasource_1], trg.[datasource_2], trg.[datasource_3], trg.[leading_sign], trg.[trailing_sign], trg.[rounding_dp], trg.[description_positive], trg.[qualifier_text], trg.[qualifier_text_part2], trg.[qualifier_number_logic], trg.[example_of_this_reported], trg.[include_in_macroview], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [indicator_id] 
					,[indicator] 
					,[specific_outcome_id] 
					,[priority_outcome_id] 
					,[wellbeing_domain_id] 
					,[priority_outcome] 
					,[specific_outcome] 
					,[relates_to_outcome] 
					,[wellbeing_domain] 
					,[data_type] 
					,[measure_type] 
					,[indicator_description] 
					,[indicator_definition_status] 
					,[relates_to] 
					,[measure_logic] 
					,[enrolled_teams_or_services] 
					,[enrolled_sub_programme_id] 
					,[enrolled_sub_programme_value] 
					,[considerations] 
					,[delivery_phasing] 
					,[datasource_1] 
					,[datasource_2] 
					,[datasource_3] 
					,[leading_sign] 
					,[trailing_sign] 
					,[rounding_dp] 
					,[description_positive] 
					,[qualifier_text] 
					,[qualifier_text_part2] 
					,[qualifier_number_logic] 
					,[example_of_this_reported] 
					,[include_in_macroview] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[indicator_id] 
					,src.[indicator] 
					,src.[specific_outcome_id] 
					,src.[priority_outcome_id] 
					,src.[wellbeing_domain_id] 
					,src.[priority_outcome] 
					,src.[specific_outcome] 
					,src.[relates_to_outcome] 
					,src.[wellbeing_domain] 
					,src.[data_type] 
					,src.[measure_type] 
					,src.[indicator_description] 
					,src.[indicator_definition_status] 
					,src.[relates_to] 
					,src.[measure_logic] 
					,src.[enrolled_teams_or_services] 
					,src.[enrolled_sub_programme_id] 
					,src.[enrolled_sub_programme_value] 
					,src.[considerations] 
					,src.[delivery_phasing] 
					,src.[datasource_1] 
					,src.[datasource_2] 
					,src.[datasource_3] 
					,src.[leading_sign] 
					,src.[trailing_sign] 
					,src.[rounding_dp] 
					,src.[description_positive] 
					,src.[qualifier_text] 
					,src.[qualifier_text_part2] 
					,src.[qualifier_number_logic] 
					,src.[example_of_this_reported] 
					,src.[include_in_macroview] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[indicator_id],inserted.[indicator_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_outcome_indicator]
			(
				 [indicator_id] 
				,[indicator] 
				,[specific_outcome_id] 
				,[priority_outcome_id] 
				,[wellbeing_domain_id] 
				,[priority_outcome] 
				,[specific_outcome] 
				,[relates_to_outcome] 
				,[wellbeing_domain] 
				,[data_type] 
				,[measure_type] 
				,[indicator_description] 
				,[indicator_definition_status] 
				,[relates_to] 
				,[measure_logic] 
				,[enrolled_teams_or_services] 
				,[enrolled_sub_programme_id] 
				,[enrolled_sub_programme_value] 
				,[considerations] 
				,[delivery_phasing] 
				,[datasource_1] 
				,[datasource_2] 
				,[datasource_3] 
				,[leading_sign] 
				,[trailing_sign] 
				,[rounding_dp] 
				,[description_positive] 
				,[qualifier_text] 
				,[qualifier_text_part2] 
				,[qualifier_number_logic] 
				,[example_of_this_reported] 
				,[include_in_macroview] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[indicator_id] 
				,src.[indicator] 
				,src.[specific_outcome_id] 
				,src.[priority_outcome_id] 
				,src.[wellbeing_domain_id] 
				,src.[priority_outcome] 
				,src.[specific_outcome] 
				,src.[relates_to_outcome] 
				,src.[wellbeing_domain] 
				,src.[data_type] 
				,src.[measure_type] 
				,src.[indicator_description] 
				,src.[indicator_definition_status] 
				,src.[relates_to] 
				,src.[measure_logic] 
				,src.[enrolled_teams_or_services] 
				,src.[enrolled_sub_programme_id] 
				,src.[enrolled_sub_programme_value] 
				,src.[considerations] 
				,src.[delivery_phasing] 
				,src.[datasource_1] 
				,src.[datasource_2] 
				,src.[datasource_3] 
				,src.[leading_sign] 
				,src.[trailing_sign] 
				,src.[rounding_dp] 
				,src.[description_positive] 
				,src.[qualifier_text] 
				,src.[qualifier_text_part2] 
				,src.[qualifier_number_logic] 
				,src.[example_of_this_reported] 
				,src.[include_in_macroview] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'sharepoint outcome list'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_outcome_indicator] as src on src.[indicator_id] = base.[indicator_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[indicator_id] 
				,tbl.[indicator] 
				,tbl.[specific_outcome_id] 
				,tbl.[priority_outcome_id] 
				,tbl.[wellbeing_domain_id] 
				,tbl.[priority_outcome] 
				,tbl.[specific_outcome] 
				,tbl.[relates_to_outcome] 
				,tbl.[wellbeing_domain] 
				,tbl.[data_type] 
				,tbl.[measure_type] 
				,tbl.[indicator_description] 
				,tbl.[indicator_definition_status] 
				,tbl.[relates_to] 
				,tbl.[measure_logic] 
				,tbl.[enrolled_teams_or_services] 
				,tbl.[enrolled_sub_programme_id] 
				,tbl.[enrolled_sub_programme_value] 
				,tbl.[considerations] 
				,tbl.[delivery_phasing] 
				,tbl.[datasource_1] 
				,tbl.[datasource_2] 
				,tbl.[datasource_3] 
				,tbl.[leading_sign] 
				,tbl.[trailing_sign] 
				,tbl.[rounding_dp] 
				,tbl.[description_positive] 
				,tbl.[qualifier_text] 
				,tbl.[qualifier_text_part2] 
				,tbl.[qualifier_number_logic] 
				,tbl.[example_of_this_reported] 
				,tbl.[include_in_macroview] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'sharepoint outcome list'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_outcome_indicator] as tbl on tbl.[indicator_id] = base.[indicator_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_outcome_indicator] as src on src.[indicator_id] = base.[indicator_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[indicator_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_outcome_indicator]
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