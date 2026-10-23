



/**********************************************************************************************************
 Procedure	[edw].[Updateedwfact_employee_certification_progress]
 Author		
 Created		
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 Parameter(s)  None 
 =========================================================================================================
NAME:     [edw].[Updateedwfact_employee_certification_progress] 
PURPOSE:  

NOTES: Fact was configured as SCD2 so that [DWHIsCurrent] can be used to filter for current leave balances

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-19    Manish Singh		Initial version
1.1		 2024-09-02    Manish Singh		Updated merge logic to do the following:
											Treat none key fields as SCD1 updates
											Set [DWHIsCurrent] = 0 for records no longer in feed, DWHIsCurrent = 1 represents what was available in the last load
1.2       2024-09-03   Manish Singh       Adjust key logic to eliminate duplicate in merge statement 
1.3       2024-10-10   Manish Singh		Added assigned date column in script 
1.4       2024-11-5    Manish singh      Added assigned date as Bussiness key
1.5       2024-11-18   Manish Singh			Adding [employee_primary_company_name] in stored proc
1.6       2025-02-27   Manish Singh		Changing Business key logic by removing due_date column from list

**********************************************************************************************************/




CREATE procedure [edw].[Updateedwfact_employee_certification_progress] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_employee_certification_progress]';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_certification_progress];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_certification_progress];

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
		 [fact_employee_certification_progress_id] bigint null,
		 [employee_certification_progress_user_id] NVARCHAR(MAX) NULL,
--         [employee_certification_due_date] date,
--		 [employee_certification_assigned_date] date
		[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_certification_progress]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_certification_progress]
			(
	   [fact_employee_certification_progress_id] 
	   ,dim_employee_key
	   ,dim_service_key
	   ,dim_business_unit_hierarchy_key
	   ,dim_certification_key
      ,[employee_organisation_id]
	  ,[employee_primary_company_name]
      ,[employee_position_id]
      ,[employee_certification_progress_user_id]
      ,[employee_course_set_id]
      ,[employee_certification_status]
      ,[is_recertification]
      ,[is_unassigned_to_employee_flag]
	   ,[employee_certification_assigned_date]
      ,[employee_certification_due_date]
      ,[employee_certification_expiry_date]
      ,[employee_certification_window_opens_date]
      ,[employee_certification_completed_date]
      ,[employee_certification_renewal_status]
      ,[employee_certification_completion_history_link]
      ,[employee_certification_id]
      ,[employee_certification_completed_history_date]
      ,[employee_context_level]
      ,[employee_certification_path]
      ,[employee_certification_depth]
      ,[employee_parent_certification_id]
      ,[employee_position_name]
      ,[is_cerification_delivered_face_to_face_flag]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
SELECT src.[fact_employee_certification_progress_id], 
       src.dim_employee_key, 
       src.dim_service_key, 
       src.dim_business_unit_hierarchy_key, 
       src.dim_certification_key, 
       src.[employee_organisation_id],
	   src.[employee_primary_company_name],
       src.[employee_position_id], 
       src.[employee_certification_progress_user_id], 
       src.[employee_course_set_id], 
       src.[employee_certification_status], 
       src.[is_recertification], 
       src.[is_unassigned_to_employee_flag], 
	   src.[employee_certification_assigned_date],
       src.[employee_certification_due_date], 
       src.[employee_certification_expiry_date], 
       src.[employee_certification_window_opens_date], 
       src.[employee_certification_completed_date], 
       src.[employee_certification_renewal_status], 
       src.[employee_certification_completion_history_link], 
       src.[employee_certification_id], 
       src.[employee_certification_completed_history_date], 
       src.[employee_context_level], 
       src.[employee_certification_path], 
       src.[employee_certification_depth], 
       src.[employee_parent_certification_id], 
       src.[employee_position_name], 
       src.[is_cerification_delivered_face_to_face_flag]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_certification_progress] as src;
		end else begin
			merge into [edw].[fact_employee_certification_progress] as trg
			using 
			(
				select
       src.[fact_employee_certification_progress_id], 
       src.dim_employee_key, 
       src.dim_service_key, 
       src.dim_business_unit_hierarchy_key, 
       src.dim_certification_key, 
       src.[employee_organisation_id], 
	    src.[employee_primary_company_name],
       src.[employee_position_id], 
       src.[employee_certification_progress_user_id], 
       src.[employee_course_set_id], 
       src.[employee_certification_status], 
       src.[is_recertification], 
       src.[is_unassigned_to_employee_flag], 
	   src.[employee_certification_assigned_date],
       src.[employee_certification_due_date], 
       src.[employee_certification_expiry_date], 
       src.[employee_certification_window_opens_date], 
       src.[employee_certification_completed_date], 
       src.[employee_certification_renewal_status], 
       src.[employee_certification_completion_history_link], 
       src.[employee_certification_id], 
       src.[employee_certification_completed_history_date], 
       src.[employee_context_level], 
       src.[employee_certification_path], 
       src.[employee_certification_depth], 
       src.[employee_parent_certification_id], 
       src.[employee_position_name], 
       src.[is_cerification_delivered_face_to_face_flag]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_certification_progress] as src
			) as src on (src.[fact_employee_certification_progress_id] = trg.[fact_employee_certification_progress_id] AND src.[employee_certification_progress_user_id] = trg.[employee_certification_progress_user_id] COLLATE DATABASE_DEFAULT
			--AND src.[employee_certification_due_date]=trg.[employee_certification_due_date] 
			--AND src.[employee_certification_assigned_date]=trg.[employee_certification_assigned_date] 
			AND trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[employee_organisation_id], src.[employee_position_id], src.[employee_certification_progress_user_id], src.[employee_course_set_id], src.[employee_certification_status], src.[employee_certification_path], src.[is_unassigned_to_employee_flag], src.[employee_certification_due_date], src.[employee_certification_expiry_date], src.[employee_certification_window_opens_date], src.[employee_certification_completed_date], src.[employee_certification_renewal_status], src.[employee_certification_completion_history_link], src.[employee_certification_id], src.[employee_certification_completed_history_date], src.[employee_context_level], src.[employee_certification_path], src.[employee_certification_depth], src.[employee_parent_certification_id], src.[employee_position_name], src.[is_cerification_delivered_face_to_face_flag], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[employee_organisation_id], trg.[employee_position_id], trg.[employee_certification_progress_user_id], trg.[employee_course_set_id], trg.[employee_certification_status], trg.[employee_certification_path], trg.[is_unassigned_to_employee_flag], trg.[employee_certification_due_date], trg.[employee_certification_expiry_date], trg.[employee_certification_window_opens_date], trg.[employee_certification_completed_date], trg.[employee_certification_renewal_status], trg.[employee_certification_completion_history_link], trg.[employee_certification_id], trg.[employee_certification_completed_history_date], trg.[employee_context_level], trg.[employee_certification_path], trg.[employee_certification_depth], trg.[employee_parent_certification_id], trg.[employee_position_name], trg.[is_cerification_delivered_face_to_face_flag], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
[fact_employee_certification_progress_id], 
dim_employee_key, 
dim_service_key, 
dim_business_unit_hierarchy_key, 
dim_certification_key, 
[employee_organisation_id], 
[employee_primary_company_name],
[employee_position_id], 
[employee_certification_progress_user_id], 
[employee_course_set_id], 
[employee_certification_status], 
[is_recertification], 
[is_unassigned_to_employee_flag], 
[employee_certification_assigned_date],
[employee_certification_due_date], 
[employee_certification_expiry_date], 
[employee_certification_window_opens_date], 
[employee_certification_completed_date], 
[employee_certification_renewal_status], 
[employee_certification_completion_history_link], 
[employee_certification_id], 
[employee_certification_completed_history_date], 
[employee_context_level], 
[employee_certification_path], 
[employee_certification_depth], 
[employee_parent_certification_id], 
[employee_position_name], 
[is_cerification_delivered_face_to_face_flag]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
 src.[fact_employee_certification_progress_id], 
       src.dim_employee_key, 
       src.dim_service_key, 
       src.dim_business_unit_hierarchy_key, 
       src.dim_certification_key, 
       src.[employee_organisation_id], 
	    src.[employee_primary_company_name],
       src.[employee_position_id], 
       src.[employee_certification_progress_user_id], 
       src.[employee_course_set_id], 
       src.[employee_certification_status], 
       src.[is_recertification], 
       src.[is_unassigned_to_employee_flag], 
	   src.[employee_certification_assigned_date],
       src.[employee_certification_due_date], 
       src.[employee_certification_expiry_date], 
       src.[employee_certification_window_opens_date], 
       src.[employee_certification_completed_date], 
       src.[employee_certification_renewal_status], 
       src.[employee_certification_completion_history_link], 
       src.[employee_certification_id], 
       src.[employee_certification_completed_history_date], 
       src.[employee_context_level], 
       src.[employee_certification_path], 
       src.[employee_certification_depth], 
       src.[employee_parent_certification_id], 
       src.[employee_position_name], 
       src.[is_cerification_delivered_face_to_face_flag]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[fact_employee_certification_progress_id],inserted.[fact_employee_certification_progress_id]),
			        COALESCE(src.[employee_certification_progress_user_id], inserted.[employee_certification_progress_user_id]),
			      -- COALESCE(src.[employee_certification_due_date],inserted.[employee_certification_due_date]),
				  -- COALESCE(src.[employee_certification_assigned_date],inserted.[employee_certification_assigned_date]),
				  $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_employee_certification_progress]
			(
[fact_employee_certification_progress_id], 
dim_employee_key, 
dim_service_key, 
dim_business_unit_hierarchy_key, 
dim_certification_key, 
[employee_organisation_id], 
[employee_primary_company_name],
[employee_position_id], 
[employee_certification_progress_user_id], 
[employee_course_set_id], 
[employee_certification_status], 
[is_recertification], 
[is_unassigned_to_employee_flag], 
 [employee_certification_assigned_date],
[employee_certification_due_date], 
[employee_certification_expiry_date], 
[employee_certification_window_opens_date], 
[employee_certification_completed_date], 
[employee_certification_renewal_status], 
[employee_certification_completion_history_link], 
[employee_certification_id], 
[employee_certification_completed_history_date], 
[employee_context_level], 
[employee_certification_path], 
[employee_certification_depth], 
[employee_parent_certification_id], 
[employee_position_name], 
[is_cerification_delivered_face_to_face_flag]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
 src.[fact_employee_certification_progress_id], 
       src.dim_employee_key, 
       src.dim_service_key, 
       src.dim_business_unit_hierarchy_key, 
       src.dim_certification_key, 
       src.[employee_organisation_id],
	    src.[employee_primary_company_name],
       src.[employee_position_id], 
       src.[employee_certification_progress_user_id], 
       src.[employee_course_set_id], 
       src.[employee_certification_status], 
       src.[is_recertification], 
       src.[is_unassigned_to_employee_flag],
	   src.[employee_certification_assigned_date],
       src.[employee_certification_due_date], 
       src.[employee_certification_expiry_date], 
       src.[employee_certification_window_opens_date], 
       src.[employee_certification_completed_date], 
       src.[employee_certification_renewal_status], 
       src.[employee_certification_completion_history_link], 
       src.[employee_certification_id], 
       src.[employee_certification_completed_history_date], 
       src.[employee_context_level], 
       src.[employee_certification_path], 
       src.[employee_certification_depth], 
       src.[employee_parent_certification_id], 
       src.[employee_position_name], 
       src.[is_cerification_delivered_face_to_face_flag]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_employee_certification_progress]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_employee_certification_progress] as src on 
			src.[fact_employee_certification_progress_id] = base.[fact_employee_certification_progress_id]
			AND src.[employee_certification_progress_user_id] = base.[employee_certification_progress_user_id] COLLATE DATABASE_DEFAULT
			--AND src.[employee_certification_due_date]=base.[employee_certification_due_date] 
			--AND src.[employee_certification_assigned_date]=base.[employee_certification_assigned_date]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
tbl.[fact_employee_certification_progress_id], 
tbl.dim_employee_key, 
tbl.dim_service_key, 
tbl.dim_business_unit_hierarchy_key, 
tbl.dim_certification_key, 
tbl.[employee_organisation_id],
tbl.[employee_primary_company_name],
tbl.[employee_position_id], 
tbl.[employee_certification_progress_user_id], 
tbl.[employee_course_set_id], 
tbl.[employee_certification_status], 
tbl.[is_recertification], 
tbl.[is_unassigned_to_employee_flag], 
tbl.[employee_certification_assigned_date],
tbl.[employee_certification_due_date], 
tbl.[employee_certification_expiry_date], 
tbl.[employee_certification_window_opens_date], 
tbl.[employee_certification_completed_date], 
tbl.[employee_certification_renewal_status], 
tbl.[employee_certification_completion_history_link], 
tbl.[employee_certification_id], 
tbl.[employee_certification_completed_history_date], 
tbl.[employee_context_level], 
tbl.[employee_certification_path], 
tbl.[employee_certification_depth], 
tbl.[employee_parent_certification_id], 
tbl.[employee_position_name], 
tbl.[is_cerification_delivered_face_to_face_flag]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_employee_certification_progress]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_employee_certification_progress] as tbl on tbl.[fact_employee_certification_progress_id] = base.[fact_employee_certification_progress_id]
			AND tbl.[employee_certification_progress_user_id] = base.[employee_certification_progress_user_id]
			--AND tbl.[employee_certification_due_date]=base.[employee_certification_due_date] 
			and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_employee_certification_progress] as src on src.[fact_employee_certification_progress_id] = base.[fact_employee_certification_progress_id]
			AND src.[employee_certification_progress_user_id] = base.[employee_certification_progress_user_id] COLLATE DATABASE_DEFAULT
			--AND src.[employee_certification_due_date]=base.[employee_certification_due_date]  
			--AND src.[employee_certification_assigned_date]=base.[employee_certification_assigned_date]
			where base.[MergeAction] = 'UPDATE'
			and  src.[fact_employee_certification_progress_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_certification_progress]
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