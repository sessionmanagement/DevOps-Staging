
create procedure [edw].[Updateedwfact_employee_pay_slip_item] 
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
NAME:     [edw].[Updateedwfact_employee_pay_slip_item]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-02-16    Pankaj Bhatt		Initial version

****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'Datapay.pay_slips_gross/pay_slips_deductions/pay_slips_net';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_pay_slip_item];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_pay_slip_item];

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
		if( not exists (select top(1) 1 from [edw].[fact_employee_pay_slip_item]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_pay_slip_item]
			(
				 [dim_employee_pay_slip_key]
				,[dim_company_key_pay_packet_id_key]
				,[dim_employee_key]
				,[dim_company_key]
				,[pay_packet_id] 
				,[pay_packet_row_id] 
				,[employee_id] 
				,[item_type] 
				,[item_amount] 
				,[item_type_detail] 
				,[item_summary] 
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
				,src.[pay_packet_id] 
				,src.[pay_packet_row_id] 
				,src.[employee_id] 
				,src.[item_type] 
				,src.[item_amount] 
				,src.[item_type_detail] 
				,src.[item_summary] 
				,src.[company_code] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_pay_slip_item] as src;
		end else begin
			merge into [edw].[fact_employee_pay_slip_item] as trg
			using 
			(
				select
				 src.[dim_employee_pay_slip_key]
				,src.[dim_company_key_pay_packet_id_key]
				,src.[dim_employee_key]
				,src.[dim_company_key]
				,src.[pay_packet_id] 
				,src.[pay_packet_row_id] 
				,src.[employee_id] 
				,src.[item_type] 
				,src.[item_amount] 
				,src.[item_type_detail] 
				,src.[item_summary] 
				,src.[company_code] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_pay_slip_item] as src
			) as src on (src.[pay_packet_id] = trg.[pay_packet_id] and src.[pay_packet_row_id] = trg.[pay_packet_row_id] collate database_default and src.[employee_id] = trg.[employee_id] and src.[company_code] = trg.[company_code])			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_employee_pay_slip_key], src.[dim_company_key_pay_packet_id_key], src.[dim_employee_key], src.[dim_company_key], src.[item_type], src.[item_amount], src.[item_type_detail], src.[item_summary]
				except
				select trg.[dim_employee_pay_slip_key], trg.[dim_company_key_pay_packet_id_key], trg.[dim_employee_key], trg.[dim_company_key], trg.[item_type], trg.[item_amount], trg.[item_type_detail], trg.[item_summary]
			) then  update set 
				  [dim_employee_pay_slip_key] = src.[dim_employee_pay_slip_key]
				, [dim_company_key_pay_packet_id_key] = src.[dim_company_key_pay_packet_id_key]
				, [dim_employee_key] = src.[dim_employee_key]
				, [dim_company_key] = src.[dim_company_key]
				, [pay_packet_id] = src.[pay_packet_id]
				, [pay_packet_row_id] = src.[pay_packet_row_id]
				, [employee_id] = src.[employee_id]
				, [item_type] = src.[item_type]
				, [item_amount] = src.[item_amount]
				, [item_type_detail] = src.[item_type_detail]
				, [item_summary] = src.[item_summary]
				, [company_code] = src.[company_code]
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
					,[pay_packet_id] 
					,[pay_packet_row_id] 
					,[employee_id] 
					,[item_type] 
					,[item_amount] 
					,[item_type_detail] 
					,[item_summary] 
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
					,src.[pay_packet_id] 
					,src.[pay_packet_row_id] 
					,src.[employee_id] 
					,src.[item_type] 
					,src.[item_amount] 
					,src.[item_type_detail] 
					,src.[item_summary] 
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
		from [edw].[fact_employee_pay_slip_item];

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