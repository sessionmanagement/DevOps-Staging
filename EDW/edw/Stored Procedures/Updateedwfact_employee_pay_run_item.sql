

CREATE procedure [edw].[Updateedwfact_employee_pay_run_item] 
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
NAME:     [edw].[Updateedwfact_employee_pay_run_item]
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
	declare @SourceSystem nvarchar(120) = 'Datapay.pay_run_report';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	truncate table [edw].[fact_employee_pay_run_item];

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_pay_run_item];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_pay_run_item];

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
		
		-- Re-insert all records
		insert into [edw].[fact_employee_pay_run_item]
		(
				 [dim_employee_pay_run_key]
				,[dim_company_key_pay_run_id_key]

				,[dim_employee_key]
				,[dim_company_key]

				,[dim_employee_pay_component_key]
				,[dim_company_key_pay_component_key]

				,[dim_pay_period_start_date_key]
				,[dim_pay_period_end_date_key]

				,[pay_run_id] 
				,[employee_id] 
				,[pay_component_code] 
				,[pay_component_name] 
				,[pay_component_category] 
				,[pay_period_start_date] 
				,[pay_period_end_date] 
				,[hours_amount] 
				,[total_amount] 
				,[division_code] 
				,[cost_centre_code] 
				,[department_code] 
				,[sub_department_code] 
				,[department] 
				,[sub_department] 
				,[remuneration_type] 
				,[work_class] 
				,[work_type] 
				,[company_code] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHSourceSystem] 
		)
		select
				 src.[dim_employee_pay_run_key]
				,src.[dim_company_key_pay_run_id_key]

				,src.[dim_employee_key]
				,src.[dim_company_key]

				,src.[dim_employee_pay_component_key]
				,src.[dim_company_key_pay_component_key]

				,src.[dim_pay_period_start_date_key]
				,src.[dim_pay_period_end_date_key]

				,src.[pay_run_id] 
				,src.[employee_id] 
				,src.[pay_component_code] 
				,src.[pay_component_name] 
				,src.[pay_component_category] 
				,src.[pay_period_start_date] 
				,src.[pay_period_end_date] 
				,src.[hours_amount] 
				,src.[total_amount] 
				,src.[division_code] 
				,src.[cost_centre_code] 
				,src.[department_code] 
				,src.[sub_department_code] 
				,src.[department] 
				,src.[sub_department] 
				,src.[remuneration_type] 
				,src.[work_class] 
				,src.[work_type] 
				,src.[company_code] 
				,@BatchID as [EDWBatchId]
				,getdate() as [EDWCreatedAt]
				,@SourceSystem as [EDWSourceSystem]
		from [Staging].[ODSETLfact_employee_pay_run_item] as src;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = 0
		from [edw].[fact_employee_pay_run_item];

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