
create procedure [edw].[Updateedwfact_webexpenses] 
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

/***************************************************************************
NAME:     [edw].[Updateedwfact_webexpenses] ]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-16-12    Malhar Badheka		Initial version
1.1		 2025-16-12    Malhar Badheka		Dim columns added and prefix changed to DWH.
1.2		 2025-01-21    Malhar Badheka		changes to variable to source system


****************************************************************************/
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'webexpenses.claims';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_webexpenses];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_webexpenses];

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
		 [expense_key] nvarchar(62) not null
		,[user_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_webexpenses]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_webexpenses]
			(
				 [expense_key] 
				,[dim_webexpense_key] 
				,[claim_number] 
				,[dim_claimant_employee_key] 
				,[user_id] 
				,[expense_date] 
				,[expense_date_key] 
				,[posted_on] 
				,[posted_on_key] 
				,[upload_date] 
				,[upload_date_key] 
				,[amount] 
				,[base_amount] 
				,[exchange_rate] 
				,[billing_amount] 
				,[cc_exchange_rate] 
				,[dim_approver_employee_key] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[expense_key] 
				,src.[dim_webexpense_key] 
				,src.[claim_number] 
				,src.[dim_claimant_employee_key] 
				,src.[user_id] 
				,src.[expense_date] 
				,src.[expense_date_key] 
				,src.[posted_on] 
				,src.[posted_on_key] 
				,src.[upload_date] 
				,src.[upload_date_key] 
				,src.[amount] 
				,src.[base_amount] 
				,src.[exchange_rate] 
				,src.[billing_amount] 
				,src.[cc_exchange_rate] 
				,src.[dim_approver_employee_key] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_webexpenses] as src;
		end else begin
			merge into [edw].[fact_webexpenses] as trg
			using 
			(
				select
				 src.[expense_key] 
				,src.[dim_webexpense_key] 
				,src.[claim_number] 
				,src.[dim_claimant_employee_key] 
				,src.[user_id] 
				,src.[expense_date] 
				,src.[expense_date_key] 
				,src.[posted_on] 
				,src.[posted_on_key] 
				,src.[upload_date] 
				,src.[upload_date_key] 
				,src.[amount] 
				,src.[base_amount] 
				,src.[exchange_rate] 
				,src.[billing_amount] 
				,src.[cc_exchange_rate] 
				,src.[dim_approver_employee_key] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_webexpenses] as src
			) as src on (src.[expense_key] = trg.[expense_key] collate database_default and src.[user_id] = trg.[user_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_webexpense_key], src.[claim_number], src.[dim_claimant_employee_key], src.[expense_date], src.[expense_date_key], src.[posted_on], src.[posted_on_key], src.[upload_date], src.[upload_date_key], src.[amount], src.[base_amount], src.[exchange_rate], src.[billing_amount], src.[cc_exchange_rate], src.[dim_approver_employee_key], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_webexpense_key], trg.[claim_number], trg.[dim_claimant_employee_key], trg.[expense_date], trg.[expense_date_key], trg.[posted_on], trg.[posted_on_key], trg.[upload_date], trg.[upload_date_key], trg.[amount], trg.[base_amount], trg.[exchange_rate], trg.[billing_amount], trg.[cc_exchange_rate], trg.[dim_approver_employee_key], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [expense_key] 
					,[dim_webexpense_key] 
					,[claim_number] 
					,[dim_claimant_employee_key] 
					,[user_id] 
					,[expense_date] 
					,[expense_date_key] 
					,[posted_on] 
					,[posted_on_key] 
					,[upload_date] 
					,[upload_date_key] 
					,[amount] 
					,[base_amount] 
					,[exchange_rate] 
					,[billing_amount] 
					,[cc_exchange_rate] 
					,[dim_approver_employee_key] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[expense_key] 
					,src.[dim_webexpense_key] 
					,src.[claim_number] 
					,src.[dim_claimant_employee_key] 
					,src.[user_id] 
					,src.[expense_date] 
					,src.[expense_date_key] 
					,src.[posted_on] 
					,src.[posted_on_key] 
					,src.[upload_date] 
					,src.[upload_date_key] 
					,src.[amount] 
					,src.[base_amount] 
					,src.[exchange_rate] 
					,src.[billing_amount] 
					,src.[cc_exchange_rate] 
					,src.[dim_approver_employee_key] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[expense_key],inserted.[expense_key]), coalesce(src.[user_id],inserted.[user_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_webexpenses]
			(
				 [expense_key] 
				,[dim_webexpense_key] 
				,[claim_number] 
				,[dim_claimant_employee_key] 
				,[user_id] 
				,[expense_date] 
				,[expense_date_key] 
				,[posted_on] 
				,[posted_on_key] 
				,[upload_date] 
				,[upload_date_key] 
				,[amount] 
				,[base_amount] 
				,[exchange_rate] 
				,[billing_amount] 
				,[cc_exchange_rate] 
				,[dim_approver_employee_key] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[expense_key] 
				,src.[dim_webexpense_key] 
				,src.[claim_number] 
				,src.[dim_claimant_employee_key] 
				,src.[user_id] 
				,src.[expense_date] 
				,src.[expense_date_key] 
				,src.[posted_on] 
				,src.[posted_on_key] 
				,src.[upload_date] 
				,src.[upload_date_key] 
				,src.[amount] 
				,src.[base_amount] 
				,src.[exchange_rate] 
				,src.[billing_amount] 
				,src.[cc_exchange_rate] 
				,src.[dim_approver_employee_key] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_webexpenses] as src on src.[expense_key] = base.[expense_key] collate database_default and src.[user_id] = base.[user_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[expense_key] 
				,tbl.[dim_webexpense_key] 
				,tbl.[claim_number] 
				,tbl.[dim_claimant_employee_key] 
				,tbl.[user_id] 
				,tbl.[expense_date] 
				,tbl.[expense_date_key] 
				,tbl.[posted_on] 
				,tbl.[posted_on_key] 
				,tbl.[upload_date] 
				,tbl.[upload_date_key] 
				,tbl.[amount] 
				,tbl.[base_amount] 
				,tbl.[exchange_rate] 
				,tbl.[billing_amount] 
				,tbl.[cc_exchange_rate] 
				,tbl.[dim_approver_employee_key] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_webexpenses] as tbl on tbl.[expense_key] = base.[expense_key] collate database_default and tbl.[user_id] = base.[user_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_webexpenses] as src on src.[expense_key] = base.[expense_key] collate database_default and src.[user_id] = base.[user_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[expense_key] is null and src.[user_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_webexpenses]
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