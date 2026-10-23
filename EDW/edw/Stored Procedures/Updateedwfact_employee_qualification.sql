
CREATE procedure [edw].[Updateedwfact_employee_qualification] 

/***************************************************************************
NAME:     [staging].[insert_staging_fact_employee_qualification]
PURPOSE:  Used to build the edw.fact_employee_qualification table

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-07-27    Greg Nuthall		Initial version
1.1      2026-09-18    Malhar Badheka   Added employee_qualification_requirement_flag
****************************************************************************/

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
	declare @SourceSystem nvarchar(120) = 'IntelliHR.qualification_instances';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_qualification];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_qualification];

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
		 [qualification_instance_id] nvarchar(36) null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_qualification]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_qualification]
			(
				 [qualification_instance_id] 
				,[dim_employee_key]
				,[dim_service_key]
				,[dim_company_key]
				,[dim_employee_qualification_library_key]
				,[dim_employee_qualification_type_key]
				,[expiry_date] 
				,[issue_date] 
				,[issuing_organisation] 
				,[notes] 
				,[employee_id] 
				,[service_name] 
				,[company_name]
				,[person_link] 
				,[qualification_status] 
				,[employee_qualification_library_id] 
				,[employee_qualification_requirement_flag] 
				,[employee_qualification_type_id] 
				,[qualification_library_item_link] 
				,[registration_number] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[qualification_instance_id] 
				,src.[dim_employee_key]
				,src.[dim_service_key]
				,src.[dim_company_key]
				,src.[dim_employee_qualification_library_key]
				,src.[dim_employee_qualification_type_key]
				,src.[expiry_date] 
				,src.[issue_date] 
				,src.[issuing_organisation] 
				,src.[notes] 
				,src.[employee_id] 
				,src.[service_name] 
				,src.[company_name]
				,src.[person_link] 
				,src.[qualification_status] 
				,src.[employee_qualification_library_id] 
				,src.[employee_qualification_requirement_flag] 
				,src.[employee_qualification_type_id] 
				,src.[qualification_library_item_link] 
				,src.[registration_number] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_qualification] as src;
		end else begin
			merge into [edw].[fact_employee_qualification] as trg
			using 
			(
				select
				 src.[qualification_instance_id] 
				,src.[dim_employee_key]
				,src.[dim_service_key]
				,src.[dim_company_key]
				,src.[dim_employee_qualification_library_key]
				,src.[dim_employee_qualification_type_key]
				,src.[expiry_date] 
				,src.[issue_date] 
				,src.[issuing_organisation] 
				,src.[notes] 
				,src.[employee_id] 
				,src.[service_name] 
				,src.[company_name] 
				,src.[person_link] 
				,src.[qualification_status] 
				,src.[employee_qualification_library_id] 
				,src.[employee_qualification_requirement_flag] 
				,src.[employee_qualification_type_id] 
				,src.[qualification_library_item_link] 
				,src.[registration_number] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_qualification] as src
			) as src on (src.[qualification_instance_id] = trg.[qualification_instance_id] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[expiry_date], src.[issue_date], src.[issuing_organisation], src.[notes], src.[employee_id], src.[service_name], src.company_name, src.[person_link], src.[qualification_status], src.[employee_qualification_library_id], src.[employee_qualification_requirement_flag], src.[employee_qualification_type_id], src.[qualification_library_item_link], src.[registration_number], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[expiry_date], trg.[issue_date], trg.[issuing_organisation], trg.[notes], trg.[employee_id], trg.[service_name], trg.company_name, trg.[person_link], trg.[qualification_status], trg.[employee_qualification_library_id], trg.[employee_qualification_requirement_flag], trg.[employee_qualification_type_id], trg.[qualification_library_item_link], trg.[registration_number], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [qualification_instance_id] 
					,[dim_employee_key]
					,[dim_service_key]
					,[dim_company_key]
					,[dim_employee_qualification_library_key]
					,[dim_employee_qualification_type_key]
					,[expiry_date] 
					,[issue_date] 
					,[issuing_organisation] 
					,[notes] 
					,[employee_id] 
					,[service_name] 
					,[company_name]
					,[person_link] 
					,[qualification_status] 
					,[employee_qualification_library_id] 
					,[employee_qualification_requirement_flag] 
					,[employee_qualification_type_id] 
					,[qualification_library_item_link] 
					,[registration_number] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[qualification_instance_id] 
					,src.[dim_employee_key]
					,src.[dim_service_key]
					,src.[dim_company_key]
					,src.[dim_employee_qualification_library_key]
					,src.[dim_employee_qualification_type_key]
					,src.[expiry_date] 
					,src.[issue_date] 
					,src.[issuing_organisation] 
					,src.[notes] 
					,src.[employee_id] 
					,src.[service_name] 
					,src.[company_name]
					,src.[person_link] 
					,src.[qualification_status] 
					,src.[employee_qualification_library_id] 
					,src.[employee_qualification_requirement_flag] 
					,src.[employee_qualification_type_id] 
					,src.[qualification_library_item_link] 
					,src.[registration_number] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[qualification_instance_id],inserted.[qualification_instance_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_employee_qualification]
			(
				 [qualification_instance_id] 
				,[dim_employee_key]
				,[dim_service_key]
				,[dim_company_key]
				,[dim_employee_qualification_library_key]
				,[dim_employee_qualification_type_key]
				,[expiry_date] 
				,[issue_date] 
				,[issuing_organisation] 
				,[notes] 
				,[employee_id] 
				,[service_name] 
				,[company_name] 
				,[person_link] 
				,[qualification_status] 
				,[employee_qualification_library_id] 
				,[employee_qualification_requirement_flag] 
				,[employee_qualification_type_id] 
				,[qualification_library_item_link] 
				,[registration_number] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[qualification_instance_id] 
				,src.[dim_employee_key]
				,src.[dim_service_key]
				,src.[dim_company_key]
				,src.[dim_employee_qualification_library_key]
				,src.[dim_employee_qualification_type_key]
				,src.[expiry_date] 
				,src.[issue_date] 
				,src.[issuing_organisation] 
				,src.[notes] 
				,src.[employee_id] 
				,src.[service_name] 
				,src.[company_name]
				,src.[person_link] 
				,src.[qualification_status] 
				,src.[employee_qualification_library_id] 
				,src.[employee_qualification_requirement_flag] 
				,src.[employee_qualification_type_id] 
				,src.[qualification_library_item_link] 
				,src.[registration_number] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_employee_qualification] as src on src.[qualification_instance_id] = base.[qualification_instance_id] collate database_default
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[qualification_instance_id] 
				,tbl.[dim_employee_key]
				,tbl.[dim_service_key]
				,tbl.[dim_company_key]
				,tbl.[dim_employee_qualification_library_key]
				,tbl.[dim_employee_qualification_type_key]
				,tbl.[expiry_date] 
				,tbl.[issue_date] 
				,tbl.[issuing_organisation] 
				,tbl.[notes] 
				,tbl.[employee_id] 
				,tbl.[service_name] 
				,tbl.[company_name]
				,tbl.[person_link] 
				,tbl.[qualification_status] 
				,tbl.[employee_qualification_library_id] 
				,tbl.[employee_qualification_requirement_flag] 
				,tbl.[employee_qualification_type_id] 
				,tbl.[qualification_library_item_link] 
				,tbl.[registration_number] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_employee_qualification] as tbl on tbl.[qualification_instance_id] = base.[qualification_instance_id] collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_employee_qualification] as src on src.[qualification_instance_id] = base.[qualification_instance_id] collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[qualification_instance_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_qualification]
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