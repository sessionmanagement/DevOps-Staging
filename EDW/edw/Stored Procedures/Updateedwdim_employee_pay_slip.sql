


CREATE procedure [edw].[Updateedwdim_employee_pay_slip] 
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
as 
/***************************************************************************
NAME:     [edw].[Updateedwdim_employee_pay_slip]
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

	declare @SystemEffectiveFrom datetime = @systemCurrentDate;
	declare @SystemEffectiveTo datetime = dateadd(second,-1,@SystemEffectiveFrom);
	declare @SystemDefaultEffectiveFrom datetime = '1 January 1900';
	declare @SystemDefaultEffectiveTo datetime = '31 December 2999 23:59:59';

	-- Do not run if there are no records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_employee_pay_slip];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_employee_pay_slip];

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
		 [pay_packet_id] int null
		,[company_code] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
	
	
		-- insert N/A, Unknown records

		if( not exists (select top(1) 1 from [edw].[dim_employee_pay_slip] where dim_employee_pay_slip_key <= 0) )
		begin
			-- turn the identity insert on 
		   SET IDENTITY_INSERT [edw].[dim_employee_pay_slip] ON
		   
			insert into [edw].[dim_employee_pay_slip]
			(
					[dim_employee_pay_slip_key]					
				   ,[dim_company_key_pay_packet_id_key]
				   ,[dim_company_key]
				   ,[pay_packet_id]
				   ,[pay_packet_type]
				   ,[pay_run_date]
				   ,[pay_period_start_date]
				   ,[pay_period_end_date]
				   ,[company_code]
				   ,[DWHBatchId]
				   ,[DWHEffectiveFrom]
				   ,[DWHEffectiveTo]
				   ,[DWHDMLOperation]
				   ,[DWHIsCurrent]
				   ,[DWHSourceSystem] 
			)
			VALUES	(0,0,0,0,'N/A','1900-01-01','1900-01-01','1900-01-01',0,0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem),
			(-1,-1,-1,-1,'Unknown','1900-01-01','1900-01-01','1900-01-01',-1,0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem)
			 -- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_employee_pay_slip] OFF
		end
	
	
		if( not exists (select top(1) 1 from [edw].[dim_employee_pay_slip] where dim_employee_pay_slip_key > 0) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_employee_pay_slip]
			(
				 [dim_company_key_pay_packet_id_key]
				,[dim_company_key]
				,[pay_packet_id] 
				,[pay_packet_type] 
				,[pay_run_date] 
				,[pay_period_start_date] 
				,[pay_period_end_date]
				,[company_code]
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_company_key_pay_packet_id_key]
				,src.[dim_company_key]
				,src.[pay_packet_id] 
				,src.[pay_packet_type] 
				,src.[pay_run_date] 
				,src.[pay_period_start_date] 
				,src.[pay_period_end_date]
				,src.[company_code]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_employee_pay_slip] as src;
		end else begin
			merge into [edw].[dim_employee_pay_slip] as trg
			using 
			(
				select
				src.[dim_company_key_pay_packet_id_key]
				,src.[dim_company_key]
				,src.[pay_packet_id] 
				,src.[pay_packet_type] 
				,src.[pay_run_date] 
				,src.[pay_period_start_date] 
				,src.[pay_period_end_date]
				,src.[company_code]
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_employee_pay_slip] as src
			) as src on (src.[pay_packet_id] = trg.[pay_packet_id] and src.[company_code] = trg.[company_code] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_company_key_pay_packet_id_key], src.[dim_company_key], src.[pay_packet_type], src.[pay_run_date], src.[pay_period_start_date], src.[pay_period_end_date], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_company_key_pay_packet_id_key], trg.[dim_company_key], trg.[pay_packet_type], trg.[pay_run_date], trg.[pay_period_start_date], trg.[pay_period_end_date], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' and trg.dim_employee_pay_slip_key > 0 then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_company_key_pay_packet_id_key]
					,[dim_company_key]
					,[pay_packet_id] 
					,[pay_packet_type] 
					,[pay_run_date] 
					,[pay_period_start_date] 
					,[pay_period_end_date]
					,[company_code]
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_company_key_pay_packet_id_key]
					,src.[dim_company_key]
					,src.[pay_packet_id] 
					,src.[pay_packet_type] 
					,src.[pay_run_date] 
					,src.[pay_period_start_date] 
					,src.[pay_period_end_date]
					,src.[company_code]
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[pay_packet_id],inserted.[pay_packet_id]), coalesce(src.[company_code],inserted.[company_code]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_employee_pay_slip]
			(
				 [dim_company_key_pay_packet_id_key]
				,[dim_company_key]
				,[pay_packet_id] 
				,[pay_packet_type] 
				,[pay_run_date] 
				,[pay_period_start_date] 
				,[pay_period_end_date]
				,[company_code]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_company_key_pay_packet_id_key]
				,src.[dim_company_key]
				,src.[pay_packet_id] 
				,src.[pay_packet_type] 
				,src.[pay_run_date] 
				,src.[pay_period_start_date] 
				,src.[pay_period_end_date]
				,src.[company_code]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_employee_pay_slip]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_employee_pay_slip] as src on src.[pay_packet_id] = base.[pay_packet_id] and src.[company_code] = base.[company_code]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[dim_company_key_pay_packet_id_key]
				,tbl.[dim_company_key]
				,tbl.[pay_packet_id] 
				,tbl.[pay_packet_type] 
				,tbl.[pay_run_date] 
				,tbl.[pay_period_start_date] 
				,tbl.[pay_period_end_date]
				,tbl.[company_code]
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_employee_pay_slip]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_employee_pay_slip] as tbl on tbl.[pay_packet_id] = base.[pay_packet_id] and tbl.[company_code] = base.[company_code] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_employee_pay_slip] as src on src.[pay_packet_id] = base.[pay_packet_id] and src.[company_code] = base.[company_code]
			where base.[MergeAction] = 'UPDATE'
			and  src.[pay_packet_id] is null and src.[company_code] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_employee_pay_slip]
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