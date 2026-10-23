
create procedure [edw].[Updateedwfact_employee_kpi_commentary] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_employee_kpi_commentary]';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	truncate table [edw].[fact_employee_kpi_commentary];

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_kpi_commentary];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_kpi_commentary];

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
		insert into [edw].[fact_employee_kpi_commentary]
		(           dim_kpi_key,
	 dim_company_key,
	 dim_employee_key,
	 dim_service_key,
				 [response_id] 
				,[measure_selected] 
				,[commentary] 
				,[company_id] 
				,[service_id] 
				,[kpi_id] 
				,[responder] 
				,[submitted_date] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHSourceSystem] 
		)
		select      src.dim_kpi_key,
	 src.dim_company_key,
	 src.dim_employee_key,
	 src.dim_service_key,
				 src.[response_id] 
				,src.[measure_selected] 
				,src.[commentary] 
				,src.[company_id] 
				,src.[service_id] 
				,src.[kpi_id] 
				,src.[responder] 
				,src.[submitted_date] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,@SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLfact_employee_kpi_commentary] as src;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = 0
		from [edw].[fact_employee_kpi_commentary];

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