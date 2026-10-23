/***************************************************************************
NAME:     [edw].[Updateedwfact_employee_hours_worked] 
PURPOSE:  

NOTES: Fact was configured as SCD2 so that [DWHIsCurrent] can be used to filter for current leave balances

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-02-19    Manish Singh		Initial version
1.1		 2024-01-23	   Greg Nuthall		Added fact_hours_worked_role column
1.2		 2026-06-02	   Malhar Badheka	Added CTE to remove duplicates 

****************************************************************************/

CREATE procedure [edw].[Updateedwfact_employee_hours_worked] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_employee_hours_worked]';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_hours_worked];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_hours_worked];

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
		 [time_sheet_entry_id] nvarchar(36) null
		,[fact_hours_worked_company_name] nvarchar(255) null
		,[fact_hours_worked_payroll_category_id] nvarchar(36) null
		,[fact_hours_worked_employee_number] nvarchar(20) null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_hours_worked]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_hours_worked]
			(    
			      dim_company_key,
	             [dim_employee_key],
	             [dim_ethnicity_key],
	             [dim_payroll_category_key],
	              dim_leave_type_key,
	             [dim_shift_start_date_key] ,
	             [dim_shift_end_date_key] ,
	             [dim_shift_start_time_key],
	             [dim_shift_end_time_key],
				 [time_sheet_entry_id] 
				,[fact_hours_worked_company_name] 
				,[fact_hours_worked_payroll_category_id] 
				,[fact_hours_worked_employee_number] 
				,[fact_hours_worked_leave_type_name] 
				,[fact_hours_worked_emplive_service_id] 
				,[fact_hours_worked_concatenated_ethnicity_id] 
				,[fact_hours_worked_total_duration] 
				,[fact_hours_worked_approval_status]
				,fact_hours_worked_role
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
			      src.[dim_company_key],
	             src.[dim_employee_key],
	             src.[dim_ethnicity_key],
	             src.[dim_payroll_category_key],
	              src.[dim_leave_type_key],
	             src.[dim_shift_start_date_key] ,
	             src.[dim_shift_end_date_key] ,
	             src.[dim_shift_start_time_key],
	             src.[dim_shift_end_time_key],
				 src.[time_sheet_entry_id] 
				,src.[fact_hours_worked_company_name] 
				,src.[fact_hours_worked_payroll_category_id] 
				,src.[fact_hours_worked_employee_number] 
				,src.[fact_hours_worked_leave_type_name] 
				,src.[fact_hours_worked_emplive_service_id] 
				,src.[fact_hours_worked_concatenated_ethnicity_id] 
				,src.[fact_hours_worked_total_duration] 
				,src.[fact_hours_worked_approval_status] 
				,fact_hours_worked_role
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_hours_worked] as src;
		end else begin
			WITH removeduplicate as (
				 SELECT src.[dim_company_key],
	             src.[dim_employee_key],
	             src.[dim_ethnicity_key],
	             src.[dim_payroll_category_key],
	             src.[dim_leave_type_key],
	             src.[dim_shift_start_date_key] ,
	             src.[dim_shift_end_date_key] ,
	             src.[dim_shift_start_time_key],
	             src.[dim_shift_end_time_key],
				 src.[time_sheet_entry_id] 
				,src.[fact_hours_worked_company_name] 
				,src.[fact_hours_worked_payroll_category_id] 
				,src.[fact_hours_worked_employee_number] 
				,src.[fact_hours_worked_leave_type_name] 
				,src.[fact_hours_worked_emplive_service_id] 
				,src.[fact_hours_worked_concatenated_ethnicity_id] 
				,src.[fact_hours_worked_total_duration] 
				,src.[fact_hours_worked_approval_status] 
				,src.fact_hours_worked_role
				,@BatchID as [DWHBatchId]
				--,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				--,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,@SystemEffectiveFrom as [DWHEffectiveFrom]
				,@SystemDefaultEffectiveTo as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				,ROW_NUMBER() OVER ( PARTITION BY src.[time_sheet_entry_id], src.[fact_hours_worked_company_name], src.[fact_hours_worked_payroll_category_id], src.[fact_hours_worked_employee_number] 
										ORDER BY (SELECT NULL) 	) AS RowNum
				from [Staging].[ODSETLfact_employee_hours_worked] as src
			)
			merge into [edw].[fact_employee_hours_worked] as trg
			using 
			(
				select * 
				from removeduplicate 
				where RowNum = 1 -- removes duplicates 
			) as src on (src.[time_sheet_entry_id] = trg.[time_sheet_entry_id] collate database_default and src.[fact_hours_worked_company_name] = trg.[fact_hours_worked_company_name] collate database_default and src.[fact_hours_worked_payroll_category_id] = trg.[fact_hours_worked_payroll_category_id] collate database_default and src.[fact_hours_worked_employee_number] = trg.[fact_hours_worked_employee_number] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Update existing records
			when matched and exists 
			( 
				select src.[fact_hours_worked_leave_type_name], src.[fact_hours_worked_emplive_service_id], src.[fact_hours_worked_concatenated_ethnicity_id], src.[fact_hours_worked_total_duration], src.[fact_hours_worked_approval_status]--, case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[fact_hours_worked_leave_type_name], trg.[fact_hours_worked_emplive_service_id], trg.[fact_hours_worked_concatenated_ethnicity_id], trg.[fact_hours_worked_total_duration], trg.[fact_hours_worked_approval_status]--, 'X'
			) 
			then  
			update set 
			
				[fact_hours_worked_company_name] = src.[fact_hours_worked_company_name] 
				,[fact_hours_worked_payroll_category_id]=src.[fact_hours_worked_payroll_category_id] 
				,[fact_hours_worked_employee_number]=src.[fact_hours_worked_employee_number] 
				,[fact_hours_worked_leave_type_name]=src.[fact_hours_worked_leave_type_name] 
				,[fact_hours_worked_emplive_service_id]=src.[fact_hours_worked_emplive_service_id] 
				,[fact_hours_worked_concatenated_ethnicity_id] =src.[fact_hours_worked_concatenated_ethnicity_id] 
				,[fact_hours_worked_total_duration] =src.[fact_hours_worked_total_duration] 
				,[fact_hours_worked_approval_status]=src.[fact_hours_worked_approval_status]
				,fact_hours_worked_role = src.fact_hours_worked_role
				,[DWHIsCurrent] = 1
				,[DWHSourceSystem] = @SourceSystem
				,[DWHEffectiveTo] = @SystemDefaultEffectiveTo
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = 'U'
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
			      dim_company_key,
	             [dim_employee_key],
	             [dim_ethnicity_key],
	             [dim_payroll_category_key],
	              dim_leave_type_key,
	             [dim_shift_start_date_key] ,
	             [dim_shift_end_date_key] ,
	             [dim_shift_start_time_key],
	             [dim_shift_end_time_key],
				 [time_sheet_entry_id] 
				,[fact_hours_worked_company_name] 
				,[fact_hours_worked_payroll_category_id] 
				,[fact_hours_worked_employee_number] 
				,[fact_hours_worked_leave_type_name] 
				,[fact_hours_worked_emplive_service_id] 
				,[fact_hours_worked_concatenated_ethnicity_id] 
				,[fact_hours_worked_total_duration] 
				,[fact_hours_worked_approval_status] 
				,fact_hours_worked_role
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
				 src.[dim_company_key],
	             src.[dim_employee_key],
	             src.[dim_ethnicity_key],
	             src.[dim_payroll_category_key],
	              src.[dim_leave_type_key],
	             src.[dim_shift_start_date_key] ,
	             src.[dim_shift_end_date_key] ,
	             src.[dim_shift_start_time_key],
	             src.[dim_shift_end_time_key],
				 src.[time_sheet_entry_id] 
				,src.[fact_hours_worked_company_name] 
				,src.[fact_hours_worked_payroll_category_id] 
				,src.[fact_hours_worked_employee_number] 
				,src.[fact_hours_worked_leave_type_name] 
				,src.[fact_hours_worked_emplive_service_id] 
				,src.[fact_hours_worked_concatenated_ethnicity_id] 
				,src.[fact_hours_worked_total_duration] 
				,src.[fact_hours_worked_approval_status]
				,src.fact_hours_worked_role
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[time_sheet_entry_id],inserted.[time_sheet_entry_id]), coalesce(src.[fact_hours_worked_company_name],inserted.[fact_hours_worked_company_name]), coalesce(src.[fact_hours_worked_payroll_category_id],inserted.[fact_hours_worked_payroll_category_id]), coalesce(src.[fact_hours_worked_employee_number],inserted.[fact_hours_worked_employee_number]), $action As [MergeAction] into #SummaryOfChanges;

		end;
		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_hours_worked]
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