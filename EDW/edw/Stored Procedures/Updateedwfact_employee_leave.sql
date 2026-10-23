






/***************************************************************************
NAME:     [edw].[Updateedwfact_employee_leave] 
PURPOSE:  

NOTES: Fact was configured as SCD2 so that [DWHIsCurrent] can be used to filter for current leave balances

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-01-19    Glenn McLeod		Initial version
1.1		 2024-02-01    Glenn McLeod		Updated merge logic to do the following:
											Treat none key fields as SCD1 updates
											Set [DWHIsCurrent] = 0 for records no longer in feed, DWHIsCurrent = 1 represents what was available in the last load


****************************************************************************/


CREATE procedure [edw].[Updateedwfact_employee_leave] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_employee_leave]';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_leave];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_leave];

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
		 [datapay_company_id] nvarchar(50) null
		,[employee_id] int null
		,[leave_type_id] nvarchar(50) null
		,[employee_leave_effective_date_key] nvarchar(4000) null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_employee_leave]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_leave]
			(
				[dim_company_key]
				,[dim_business_unit_hierarchy_key]
				,[dim_employee_key]
				,[dim_leave_type_key]
				,[dim_ethnicity_key]
				,[dim_payroll_category_key]
				,[employee_leave_effective_date_key]
				,[employee_leave_anniversary_date_key]
				,[datapay_company_id]
				,[employee_id]
				,[leave_type_id]
				,[ethnicity_id]
				,[business_unit_id]
				,[employee_leave_unit]
				,[employee_leave_entitlement]
				,[employee_leave_accrual]
				,[employee_leave_taken]
				,[employee_leave_balance]
				,[employee_leave_entitlement_hours]
				,[employee_leave_accrual_hours]
				,[employee_leave_taken_hours]
				,[employee_leave_balance_hours]
				,[employee_leave_next_entitlement_hours]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select

				src.dim_company_key
				,src.[dim_business_unit_hierarchy_key]
				,src.[dim_employee_key]
				,src.[dim_leave_type_key]
				,src.[dim_ethnicity_key]
				,src.[dim_payroll_category_key]
				,src.[employee_leave_effective_date_key] 
				,src.[employee_leave_anniversary_date_key] 
				,src.[datapay_company_id] 
				,src.[employee_id] 
				,src.[leave_type_id] 
				,src.[ethnicity_id] 
				,src.business_unit_id
				,src.[employee_leave_unit] 
				,src.[employee_leave_entitlement] 
				,src.[employee_leave_accrual] 
				,src.[employee_leave_taken] 
				,src.[employee_leave_balance] 
				,src.[employee_leave_entitlement_hours] 
				,src.[employee_leave_accrual_hours] 
				,src.[employee_leave_taken_hours] 
				,src.[employee_leave_balance_hours] 
				,src.[employee_leave_next_entitlement_hours] 
				,@BatchID as [DWHBatchId]
				--,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,@SystemEffectiveFrom as [DWHEffectiveFrom]
				,@SystemDefaultEffectiveTo as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_leave] as src
			;


		end else begin
			merge into [edw].[fact_employee_leave] as trg
			using 
			(
				select
				src.dim_company_key
				,src.[dim_business_unit_hierarchy_key]
				,src.[dim_employee_key]
				,src.[dim_leave_type_key]
				,src.[dim_ethnicity_key]
				,src.[dim_payroll_category_key]
				,src.[employee_leave_effective_date_key] 
				,src.[employee_leave_anniversary_date_key] 
				,src.[datapay_company_id] 
				,src.[employee_id] 
				,src.[leave_type_id] 
				,src.[ethnicity_id] 
				,src.business_unit_id
				,src.[employee_leave_unit] 
				,src.[employee_leave_entitlement] 
				,src.[employee_leave_accrual] 
				,src.[employee_leave_taken] 
				,src.[employee_leave_balance] 
				,src.[employee_leave_entitlement_hours] 
				,src.[employee_leave_accrual_hours] 
				,src.[employee_leave_taken_hours] 
				,src.[employee_leave_balance_hours] 
				,src.[employee_leave_next_entitlement_hours] 
				,@BatchID as [DWHBatchId]
				--,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,@SystemEffectiveFrom as [DWHEffectiveFrom]
				,@SystemDefaultEffectiveTo as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_leave] as src

			) as src on (
				src.[datapay_company_id] = trg.[datapay_company_id]  and src.[employee_id] = trg.[employee_id] and src.[leave_type_id] = trg.[leave_type_id]  and src.[employee_leave_effective_date_key] = trg.[employee_leave_effective_date_key] --and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
					)			
			
			---- update existing records
			when matched and exists
			( 
				select src.[ethnicity_id], src.[employee_leave_anniversary_date_key], src.[business_unit_id], src.[employee_leave_unit], src.[employee_leave_entitlement], src.[employee_leave_accrual], src.[employee_leave_taken], src.[employee_leave_balance], src.[employee_leave_entitlement_hours], src.[employee_leave_accrual_hours], src.[employee_leave_taken_hours], src.[employee_leave_balance_hours], src.[employee_leave_next_entitlement_hours], src.[DWHIsCurrent]--, case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[ethnicity_id], trg.[employee_leave_anniversary_date_key], trg.[business_unit_id], trg.[employee_leave_unit], trg.[employee_leave_entitlement], trg.[employee_leave_accrual], trg.[employee_leave_taken], trg.[employee_leave_balance], trg.[employee_leave_entitlement_hours], trg.[employee_leave_accrual_hours], trg.[employee_leave_taken_hours], trg.[employee_leave_balance_hours], trg.[employee_leave_next_entitlement_hours], trg.[DWHIsCurrent]--, 'X'
			)
			then  update set 
			[ethnicity_id] = src.[ethnicity_id]
			, [employee_leave_anniversary_date_key] =  src.[employee_leave_anniversary_date_key]
			, [business_unit_id] =  src.[business_unit_id]
			, [employee_leave_unit] =  src.[employee_leave_unit]
			, [employee_leave_entitlement] =  src.[employee_leave_entitlement]
			, [employee_leave_accrual] =  src.[employee_leave_accrual]
			, [employee_leave_taken] =  src.[employee_leave_taken]
			, [employee_leave_balance] =  src.[employee_leave_balance]
			, [employee_leave_entitlement_hours] =  src.[employee_leave_entitlement_hours]
			, [employee_leave_accrual_hours] =  src.[employee_leave_accrual_hours]
			, [employee_leave_taken_hours] =  src.[employee_leave_taken_hours]
			, [employee_leave_balance_hours] =  src.[employee_leave_balance_hours]
			, [employee_leave_next_entitlement_hours] =  src.[employee_leave_next_entitlement_hours]
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
					[dim_company_key]
					,[dim_business_unit_hierarchy_key]
					,[dim_employee_key]
					,[dim_leave_type_key]
					,[dim_ethnicity_key]
					,[dim_payroll_category_key]
					,[employee_leave_effective_date_key]
					,[employee_leave_anniversary_date_key]
					,[datapay_company_id]
					,[employee_id]
					,[leave_type_id]
					,[ethnicity_id]
					,[business_unit_id]
					,[employee_leave_unit]
					,[employee_leave_entitlement]
					,[employee_leave_accrual]
					,[employee_leave_taken]
					,[employee_leave_balance]
					,[employee_leave_entitlement_hours]
					,[employee_leave_accrual_hours]
					,[employee_leave_taken_hours]
					,[employee_leave_balance_hours]
					,[employee_leave_next_entitlement_hours]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					src.[dim_company_key]
					,src.[dim_business_unit_hierarchy_key]
					,src.[dim_employee_key]
					,src.[dim_leave_type_key]
					,src.[dim_ethnicity_key]
					,src.[dim_payroll_category_key]
					,src.[employee_leave_effective_date_key]
					,src.[employee_leave_anniversary_date_key]
					,src.[datapay_company_id]
					,src.[employee_id]
					,src.[leave_type_id]
					,src.[ethnicity_id]
					,src.[business_unit_id]
					,src.[employee_leave_unit]
					,src.[employee_leave_entitlement]
					,src.[employee_leave_accrual]
					,src.[employee_leave_taken]
					,src.[employee_leave_balance]
					,src.[employee_leave_entitlement_hours]
					,src.[employee_leave_accrual_hours]
					,src.[employee_leave_taken_hours]
					,src.[employee_leave_balance_hours]
					,src.[employee_leave_next_entitlement_hours]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[datapay_company_id],inserted.[datapay_company_id]), coalesce(src.[employee_id],inserted.[employee_id]), coalesce(src.[leave_type_id],inserted.[leave_type_id]), coalesce(src.[employee_leave_effective_date_key],inserted.[employee_leave_effective_date_key]), $action As [MergeAction] into #SummaryOfChanges;



		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_employee_leave]
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