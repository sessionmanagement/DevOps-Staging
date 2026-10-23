


create procedure [edw].[Updateedwfact_employee_incident] 
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
NAME:     [edw].[Updateedwfact_employee_incident] 
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-01-23    Pankaj Bhatt		Initial version
****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'EcoPortal.incident_investigations';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_employee_incident];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_employee_incident];

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
		if( not exists (select top(1) 1 from [edw].[fact_employee_incident]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_employee_incident]
			(
				 [dim_employee_incident_key]
				,[dim_employee_incident_id_key]
				,[dim_client_incident_company_key_incident_id_key]
				,[dim_client_incident_key]				
				,[dim_incident_date_key]
				,[dim_incident_reported_date_key]
				,[dim_investigation_start_date_key]
				,[dim_investigation_end_date_key]
				,[dim_incident_close_out_date_key]
				,[incident_id] 
				,[incident_date] 
				,[incident_reported_date] 
				,[investigation_start_date] 
				,[investigation_end_date] 
				,[incident_close_out_date] 
				,[actual_severity_gauge_score] 
				,[ongoing_risk_gauge_score] 
				,[number_of_times_incident_occurred] 
				,[incident_recordbase_detail]
				,[client_incident_id]
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_employee_incident_key]
				,src.[dim_employee_incident_id_key]
				,src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_client_incident_key]
				,src.[dim_incident_date_key]
				,src.[dim_incident_reported_date_key]
				,src.[dim_investigation_start_date_key]
				,src.[dim_investigation_end_date_key]
				,src.[dim_incident_close_out_date_key]
				,src.[incident_id] 
				,src.[incident_date] 
				,src.[incident_reported_date] 
				,src.[investigation_start_date] 
				,src.[investigation_end_date] 
				,src.[incident_close_out_date] 
				,src.[actual_severity_gauge_score] 
				,src.[ongoing_risk_gauge_score] 
				,src.[number_of_times_incident_occurred] 
				,src.[incident_recordbase_detail]
				,src.[client_incident_id]
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_employee_incident] as src;
		end else begin
			merge into [edw].[fact_employee_incident] as trg
			using 
			(
				select
				 src.[dim_employee_incident_key]
				,src.[dim_employee_incident_id_key]
				,src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_client_incident_key]
				,src.[dim_incident_date_key]
				,src.[dim_incident_reported_date_key]
				,src.[dim_investigation_start_date_key]
				,src.[dim_investigation_end_date_key]
				,src.[dim_incident_close_out_date_key]
				,src.[incident_id] 
				,src.[incident_date] 
				,src.[incident_reported_date] 
				,src.[investigation_start_date] 
				,src.[investigation_end_date] 
				,src.[incident_close_out_date] 
				,src.[actual_severity_gauge_score] 
				,src.[ongoing_risk_gauge_score] 
				,src.[number_of_times_incident_occurred] 
				,src.[incident_recordbase_detail]
				,src.[client_incident_id]
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_employee_incident] as src
			) as src on (src.[incident_id] = trg.[incident_id] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_employee_incident_key], src.[dim_employee_incident_id_key], src.[dim_client_incident_company_key_incident_id_key], src.[dim_client_incident_key], src.[dim_incident_date_key], src.[dim_incident_reported_date_key], src.[dim_investigation_start_date_key], src.[dim_investigation_end_date_key], src.[dim_incident_close_out_date_key], src.[incident_date], src.[incident_reported_date], src.[investigation_start_date], src.[investigation_end_date], src.[incident_close_out_date], src.[actual_severity_gauge_score], src.[ongoing_risk_gauge_score], src.[number_of_times_incident_occurred], src.[incident_recordbase_detail], src.[client_incident_id]
				except
				select trg.[dim_employee_incident_key], trg.[dim_employee_incident_id_key], trg.[dim_client_incident_company_key_incident_id_key], trg.[dim_client_incident_key], trg.[dim_incident_date_key], trg.[dim_incident_reported_date_key], trg.[dim_investigation_start_date_key], trg.[dim_investigation_end_date_key], trg.[dim_incident_close_out_date_key], trg.[incident_date], trg.[incident_reported_date], trg.[investigation_start_date], trg.[investigation_end_date], trg.[incident_close_out_date], trg.[actual_severity_gauge_score], trg.[ongoing_risk_gauge_score], trg.[number_of_times_incident_occurred], trg.[incident_recordbase_detail], trg.[client_incident_id]
			) then  update set
				  [dim_employee_incident_key] = src.[dim_employee_incident_key]
				, [dim_employee_incident_id_key] = src.[dim_employee_incident_id_key]
				, [dim_client_incident_company_key_incident_id_key] = src.[dim_client_incident_company_key_incident_id_key]
				, [dim_client_incident_key] = src.[dim_client_incident_key]
				, [dim_incident_date_key] = src.[dim_incident_date_key]
				, [dim_incident_reported_date_key] = src.[dim_incident_reported_date_key]
				, [dim_investigation_start_date_key] = src.[dim_investigation_start_date_key]
				, [dim_investigation_end_date_key] = src.[dim_investigation_end_date_key]
				, [dim_incident_close_out_date_key] = src.[dim_incident_close_out_date_key]
				, [incident_id] = src.[incident_id]
				, [incident_date] = src.[incident_date]
				, [incident_reported_date] = src.[incident_reported_date]
				, [investigation_start_date] = src.[investigation_start_date]
				, [investigation_end_date] = src.[investigation_end_date]
				, [incident_close_out_date] = src.[incident_close_out_date]
				, [actual_severity_gauge_score] = src.[actual_severity_gauge_score]
				, [ongoing_risk_gauge_score] = src.[ongoing_risk_gauge_score]
				, [number_of_times_incident_occurred] = src.[number_of_times_incident_occurred]
				, [incident_recordbase_detail] = src.[incident_recordbase_detail]
				, [client_incident_id] = src.[client_incident_id]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_employee_incident_key]
					,[dim_employee_incident_id_key]
					,[dim_client_incident_company_key_incident_id_key]
					,[dim_client_incident_key]
					,[dim_incident_date_key]
					,[dim_incident_reported_date_key]
					,[dim_investigation_start_date_key]
					,[dim_investigation_end_date_key]
					,[dim_incident_close_out_date_key]
					,[incident_id] 
					,[incident_date] 
					,[incident_reported_date] 
					,[investigation_start_date] 
					,[investigation_end_date] 
					,[incident_close_out_date] 
					,[actual_severity_gauge_score] 
					,[ongoing_risk_gauge_score] 
					,[number_of_times_incident_occurred] 
					,[incident_recordbase_detail]
					,[client_incident_id]
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_employee_incident_key]
					,src.[dim_employee_incident_id_key]
					,src.[dim_client_incident_company_key_incident_id_key]
					,src.[dim_client_incident_key]
					,src.[dim_incident_date_key]
					,src.[dim_incident_reported_date_key]
					,src.[dim_investigation_start_date_key]
					,src.[dim_investigation_end_date_key]
					,src.[dim_incident_close_out_date_key]
					,src.[incident_id] 
					,src.[incident_date] 
					,src.[incident_reported_date] 
					,src.[investigation_start_date] 
					,src.[investigation_end_date] 
					,src.[incident_close_out_date] 
					,src.[actual_severity_gauge_score] 
					,src.[ongoing_risk_gauge_score] 
					,src.[number_of_times_incident_occurred] 
					,src.[incident_recordbase_detail]
					,src.[client_incident_id]
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
		from [edw].[fact_employee_incident];

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