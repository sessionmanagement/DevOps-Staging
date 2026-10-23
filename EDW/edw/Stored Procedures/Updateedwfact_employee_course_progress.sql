

CREATE procedure [edw].[Updateedwfact_employee_course_progress] 

/*********************************************************************************************************************
NAME:     [Updateedwfact_employee_course_progress]
PURPOSE:  

NOTES: Fact was configured as SCD2 so that [DWHIsCurrent] can be used to filter for current employee_course_progress balances

REVISIONS:
Version	Date		   Author			Description
-------	------------  ---------------	--------------------------
1.0		2024-07-19    Manish Singh		Initial version
1.1		2024-09-03    Manish Singh		Updated merge logic to do the following:
											Treat none key fields as SCD1 updates
											Set [DWHIsCurrent] = 0 for records no longer in feed, DWHIsCurrent = 1 represents what was available in the last load
1.2     2024-09-16	  Manish Singh		Add [employee_course_completion_grade] column as part of composite key
1.3     2024-10-29    Manish Singh		Add [is_course_linked_to_certification_flag] columns in ETL flow 
1.5     2024-11-18    Manish Singh		Adding [employee_primary_company_name] in stored proc
1.6		2025-03-03	  Greg Nuthall		Change to exception clause to avoid inserting duplicates by removing DWHIsCurrent and just check if the business data exisits
1.7		2026-01-27	  Malhar badheka	Changes to @pTargetRecords statement currently wrong value there 

*************************************************************************************************************************/

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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_employee_course_progress]';
	
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
-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_course_progress];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_course_progress];

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
		 [fact_employee_course_progress_id] bigint null,
		 [employee_course_progress_user_id] [nvarchar](100) NULL,
	     [employee_course_enrolled_date] [datetime] NOT NULL,
	     [employee_course_started_date] [datetime] NOT NULL,
	     [employee_course_completion_grade] [int] NULL,
         [MergeAction] varchar(10)
	);
	begin transaction;

	begin try
   if( not exists (select top(1) 1 from [edw].[fact_employee_course_progress]) )
    begin
        -- There are no records in the target; insert all
        insert into [edw].[fact_employee_course_progress]
        (
             fact_employee_course_progress_id
            ,dim_employee_key 
            ,dim_course_key
            ,dim_service_key
            ,dim_business_unit_hierarchy_key
            ,[employee_course_progress_user_id] 
            ,[employee_course_id] 
            ,[employee_organisation_id] 
			,[employee_primary_company_name]
            ,[employee_position_id] 
            ,[employee_course_enrolled_date] 
            ,[employee_course_started_date] 
            ,[employee_course_completed_date] 
            ,[employee_course_completion_percentage] 
            ,[employee_course_renewal_status] 
            ,[employee_course_due_date] 
            ,[employee_position_name] 
            ,[is_course_delivered_face_to_face_flag] 
            ,[employee_course_completion_history_previous_completion] 
            ,[employee_course_completion_grade] 
			,[is_course_core_training_flag] 
			,[is_course_linked_to_certification_flag]
            ,[DWHBatchId] 
            ,[DWHEffectiveFrom] 
            ,[DWHEffectiveTo] 
            ,[DWHDMLOperation] 
            ,[DWHIsCurrent] 
            ,[DWHSourceSystem] 
        )
        select
            src.[fact_employee_course_progress_id] 
            ,src.dim_employee_key 
            ,src.[dim_course_key]
            ,src.dim_service_key
            ,src.dim_business_unit_hierarchy_key
            ,src.[employee_course_progress_user_id] 
            ,src.[employee_course_id] 
            ,src.[employee_organisation_id] 
			,src.[employee_primary_company_name]
            ,src.[employee_position_id] 
            ,src.[employee_course_enrolled_date] 
            ,src.[employee_course_started_date] 
            ,src.[employee_course_completed_date] 
            ,src.[employee_course_completion_percentage] 
            ,src.[employee_course_renewal_status] 
            ,src.[employee_course_due_date] 
            ,src.[employee_position_name] 
            ,src.[is_course_delivered_face_to_face_flag] 
            ,src.[employee_course_completion_history_previous_completion] 
            ,src.[employee_course_completion_grade] 
			,src.[is_course_core_training_flag] 
			,src.[is_course_linked_to_certification_flag]
            ,@BatchID as [DWHBatchId]
            ,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
            ,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
            ,'I' as [DWHDMLOperation]
            ,1 as [DWHIsCurrent]
            ,@SourceSystem as [DWHSourceSystem]
        from [Staging].[ODSETLfact_employee_course_progress] as src;
		end else begin
        merge into [edw].[fact_employee_course_progress] as trg
        using 
        (
			select
			src.[fact_employee_course_progress_id] 
			,src.dim_employee_key 
			,src.[dim_course_key]
			,src.dim_service_key
			,src.dim_business_unit_hierarchy_key
			,src.[employee_course_progress_user_id] 
			,src.[employee_course_id] 
			,src.[employee_organisation_id] 
			,src.[employee_primary_company_name]
			,src.[employee_position_id] 
			,src.[employee_course_enrolled_date] 
			,src.[employee_course_started_date] 
			,src.[employee_course_completed_date] 
			,src.[employee_course_completion_percentage] 
			,src.[employee_course_renewal_status] 
			,src.[employee_course_due_date] 
			,src.[employee_position_name] 
			,src.[is_course_delivered_face_to_face_flag] 
			,src.[employee_course_completion_history_previous_completion] 
			,src.[employee_course_completion_grade] 
			,src.[is_course_core_training_flag] 
			,src.[is_course_linked_to_certification_flag]
			,@BatchID as [DWHBatchId]
			,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
			,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
			,'I' as [DWHDMLOperation]
			,1 as [DWHIsCurrent]
			,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_course_progress] as src
        ) as src on (src.[fact_employee_course_progress_id] = trg.[fact_employee_course_progress_id] 
					and src.[employee_course_progress_user_id]=trg.[employee_course_progress_user_id]
					and src.[employee_course_enrolled_date]=trg.[employee_course_enrolled_date]
					and src.[employee_course_started_date]=trg.[employee_course_started_date] 
					and isnull(src.[employee_course_completion_grade],-999)=isnull(trg.[employee_course_completion_grade],-999)
					and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)   		
			
			---- update existing records
			when matched and exists
			( 
					select src.[employee_course_progress_user_id] 
					,src.[employee_course_id] 
					,isnull(src.[employee_organisation_id],'XXXQQQ')
					,isnull(src.[employee_primary_company_name],'XXXQQQ')
					,isnull(src.[employee_position_id],-999) 
					,src.[employee_course_enrolled_date] 
					,src.[employee_course_started_date] 
					,src.[employee_course_completed_date] 
					,src.[employee_course_completion_percentage] 
					,src.[employee_course_renewal_status] 
					,src.[employee_course_due_date] 
					,isnull(src.[employee_position_name],'XXXQQQ') 
					,src.[is_course_delivered_face_to_face_flag] 
					,src.[employee_course_completion_history_previous_completion] 
					,isnull(src.[employee_course_completion_grade],-999) 
					,src.[is_course_core_training_flag]
					,src.[is_course_linked_to_certification_flag]
					--, src.[DWHIsCurrent]--, case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
					select trg.[employee_course_progress_user_id]
					,trg.[employee_course_id]
					,isnull(trg.[employee_organisation_id],'XXXQQQ') 
					,isnull(trg.[employee_primary_company_name],'XXXQQQ') 
					,isnull(trg.[employee_position_id],-999) 
					,trg.[employee_course_enrolled_date]
					,trg.[employee_course_started_date]
					,trg.[employee_course_completed_date]
					,trg.[employee_course_completion_percentage]
					,trg.[employee_course_renewal_status]
					,trg.[employee_course_due_date]
					,isnull(trg.[employee_position_name],'XXXQQQ') 
					,trg.[is_course_delivered_face_to_face_flag]
					,trg.[employee_course_completion_history_previous_completion]
					,isnull(trg.[employee_course_completion_grade],-999) 
					,trg.[is_course_core_training_flag]
					,trg.[is_course_linked_to_certification_flag] 
					--,trg.[DWHIsCurrent]--, 'X'
			)
			then  update set 
				[employee_course_progress_user_id] = src.[employee_course_progress_user_id],
				[employee_course_id] = src.[employee_course_id],
				[employee_organisation_id] = src.[employee_organisation_id],
				[employee_primary_company_name]=src.[employee_primary_company_name],
				[employee_position_id] = src.[employee_position_id],
				[employee_course_enrolled_date] = src.[employee_course_enrolled_date],
				[employee_course_started_date] = src.[employee_course_started_date],
				[employee_course_completed_date] = src.[employee_course_completed_date],
				[employee_course_completion_percentage] = src.[employee_course_completion_percentage],
				[employee_course_renewal_status] = src.[employee_course_renewal_status],
				[employee_course_due_date] = src.[employee_course_due_date],
				[employee_position_name] = src.[employee_position_name],
				[is_course_delivered_face_to_face_flag] = src.[is_course_delivered_face_to_face_flag],
				[employee_course_completion_history_previous_completion] = src.[employee_course_completion_history_previous_completion],
				[employee_course_completion_grade] = src.[employee_course_completion_grade],
				[is_course_core_training_flag] = src.[is_course_core_training_flag],
				[is_course_linked_to_certification_flag]=src.[is_course_linked_to_certification_flag]
				,[DWHIsCurrent] = 1
				,[DWHSourceSystem] = @SourceSystem
				,[DWHEffectiveTo] = @SystemDefaultEffectiveTo
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = 'U'


			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @systemCurrentDate, [DWHIsCurrent] = 0, [DWHBatchId] = @BatchID
			-- Insert new records
			when not matched by target then 
				insert 
				(
					fact_employee_course_progress_id
					,dim_employee_key 
					,dim_course_key
					,dim_service_key
					,dim_business_unit_hierarchy_key
					,[employee_course_progress_user_id] 
					,[employee_course_id] 
					,[employee_organisation_id]
					,[employee_primary_company_name]
					,[employee_position_id] 
					,[employee_course_enrolled_date] 
					,[employee_course_started_date] 
					,[employee_course_completed_date] 
					,[employee_course_completion_percentage] 
					,[employee_course_renewal_status] 
					,[employee_course_due_date] 
					,[employee_position_name] 
					,[is_course_delivered_face_to_face_flag] 
					,[employee_course_completion_history_previous_completion] 
					,[employee_course_completion_grade] 
					,[is_course_core_training_flag] 
					,[is_course_linked_to_certification_flag]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					src.[fact_employee_course_progress_id] 
					,src.dim_employee_key
					,src.[dim_course_key]
					,src.dim_service_key
					,src.dim_business_unit_hierarchy_key
					,src.[employee_course_progress_user_id] 
					,src.[employee_course_id] 
					,src.[employee_organisation_id] 
					,src.[employee_primary_company_name]
					,src.[employee_position_id] 
					,src.[employee_course_enrolled_date] 
					,src.[employee_course_started_date] 
					,src.[employee_course_completed_date] 
					,src.[employee_course_completion_percentage] 
					,src.[employee_course_renewal_status] 
					,src.[employee_course_due_date] 
					,src.[employee_position_name] 
					,src.[is_course_delivered_face_to_face_flag] 
					,src.[employee_course_completion_history_previous_completion] 
					,src.[employee_course_completion_grade] 
					,src.[is_course_core_training_flag] 
					,src.[is_course_linked_to_certification_flag]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
        output  coalesce(src.[fact_employee_course_progress_id],inserted.[fact_employee_course_progress_id]),
		coalesce(src.[employee_course_progress_user_id],inserted.[employee_course_progress_user_id]),
		coalesce(src.[employee_course_enrolled_date],inserted.[employee_course_enrolled_date]),
		coalesce(src.[employee_course_started_date],inserted.[employee_course_started_date]),
		coalesce(src.[employee_course_completion_grade],inserted.[employee_course_completion_grade]),$action As [MergeAction] into #SummaryOfChanges;


		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum(case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_course_progress]
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