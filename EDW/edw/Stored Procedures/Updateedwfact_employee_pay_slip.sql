
create procedure [edw].[Updateedwfact_employee_pay_slip] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as

/***************************************************************************
NAME:     [edw].[Updateedwfact_employee_pay_slip]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-12    Pankaj Bhatt		Initial version

****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'Datapay.pay_slips';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_pay_slip];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_pay_slip];

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
		if( not exists (select top(1) 1 from [edw].[fact_employee_pay_slip]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_pay_slip]
			(
				 [dim_employee_pay_slip_key]
				,[dim_company_key_pay_packet_id_key]
				,[dim_employee_key]
				,[dim_company_key]
				,[dim_pay_run_date_key]
				,[dim_pay_period_start_date_key]
				,[dim_pay_period_end_date_key]
				,[pay_packet_id] 
				,[employee_id] 
				,[gross_total_amount] 
				,[deduction_total_amount] 
				,[net_total_amount] 
				,[pay_run_date] 
				,[pay_period_start_date] 
				,[pay_period_end_date] 
				,[company_code] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_employee_pay_slip_key]
				,src.[dim_company_key_pay_packet_id_key]
				,src.[dim_employee_key]
				,src.[dim_company_key]
				,src.[dim_pay_run_date_key]
				,src.[dim_pay_period_start_date_key]
				,src.[dim_pay_period_end_date_key]
				,src.[pay_packet_id] 
				,src.[employee_id] 
				,src.[gross_total_amount] 
				,src.[deduction_total_amount] 
				,src.[net_total_amount] 
				,src.[pay_run_date] 
				,src.[pay_period_start_date] 
				,src.[pay_period_end_date] 
				,src.[company_code] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_pay_slip] as src;
		end else begin
			merge into [edw].[fact_employee_pay_slip] as trg
			using 
			(
				select
				 src.[dim_employee_pay_slip_key]
				,src.[dim_company_key_pay_packet_id_key]
				,src.[dim_employee_key]
				,src.[dim_company_key]
				,src.[dim_pay_run_date_key]
				,src.[dim_pay_period_start_date_key]
				,src.[dim_pay_period_end_date_key]
				,src.[pay_packet_id] 
				,src.[employee_id] 
				,src.[gross_total_amount] 
				,src.[deduction_total_amount] 
				,src.[net_total_amount] 
				,src.[pay_run_date] 
				,src.[pay_period_start_date] 
				,src.[pay_period_end_date] 
				,src.[company_code] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_pay_slip] as src
			) as src on (src.[pay_packet_id] = trg.[pay_packet_id] and src.[employee_id] = trg.[employee_id] and src.[company_code] = trg.[company_code])			-- Retire existing records
			when matched and exists 
			( 
				select  src.[dim_employee_pay_slip_key], src.[dim_company_key_pay_packet_id_key], src.[dim_employee_key], src.[dim_company_key], src.[dim_pay_run_date_key], src.[dim_pay_period_start_date_key], src.[dim_pay_period_end_date_key], src.[gross_total_amount], src.[deduction_total_amount], src.[net_total_amount], src.[pay_run_date], src.[pay_period_start_date], src.[pay_period_end_date]
				except
				select  trg.[dim_employee_pay_slip_key], trg.[dim_company_key_pay_packet_id_key], trg.[dim_employee_key], trg.[dim_company_key], trg.[dim_pay_run_date_key], trg.[dim_pay_period_start_date_key], trg.[dim_pay_period_end_date_key], trg.[gross_total_amount], trg.[deduction_total_amount], trg.[net_total_amount], trg.[pay_run_date], trg.[pay_period_start_date], trg.[pay_period_end_date]
			) then  update set 
				 [dim_employee_pay_slip_key] = src.[dim_employee_pay_slip_key]
				,[dim_company_key_pay_packet_id_key] = src.[dim_company_key_pay_packet_id_key]
				,[dim_employee_key] = src.[dim_employee_key]
				,[dim_company_key] = src.[dim_company_key]
				,[dim_pay_run_date_key] = src.[dim_pay_run_date_key]
				,[dim_pay_period_start_date_key] = src.[dim_pay_period_start_date_key]
				,[dim_pay_period_end_date_key] = src.[dim_pay_period_end_date_key]
				,[pay_packet_id] = src.[pay_packet_id]
				,[employee_id] = src.[employee_id]
				,[gross_total_amount] = src.[gross_total_amount]
				,[deduction_total_amount] = src.[deduction_total_amount]
				,[net_total_amount] = src.[net_total_amount]
				,[pay_run_date] = src.[pay_run_date]
				,[pay_period_start_date] = src.[pay_period_start_date]
				,[pay_period_end_date] = src.[pay_period_end_date]
				,[company_code] = src.[company_code]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_employee_pay_slip_key]
					,[dim_company_key_pay_packet_id_key]
					,[dim_employee_key]
					,[dim_company_key]
					,[dim_pay_run_date_key]
					,[dim_pay_period_start_date_key]
					,[dim_pay_period_end_date_key]
					,[pay_packet_id] 
					,[employee_id] 
					,[gross_total_amount] 
					,[deduction_total_amount] 
					,[net_total_amount] 
					,[pay_run_date] 
					,[pay_period_start_date] 
					,[pay_period_end_date] 
					,[company_code] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_employee_pay_slip_key]
					,src.[dim_company_key_pay_packet_id_key]
					,src.[dim_employee_key]
					,src.[dim_company_key]
					,src.[dim_pay_run_date_key]
					,src.[dim_pay_period_start_date_key]
					,src.[dim_pay_period_end_date_key]
					,src.[pay_packet_id] 
					,src.[employee_id] 
					,src.[gross_total_amount] 
					,src.[deduction_total_amount] 
					,src.[net_total_amount] 
					,src.[pay_run_date] 
					,src.[pay_period_start_date] 
					,src.[pay_period_end_date] 
					,src.[company_code] 
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
		from [edw].[fact_employee_pay_slip];

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