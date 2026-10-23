
CREATE procedure [edw].[Updateedwfact_property_arrears_transaction] 
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
	declare @SourceSystem nvarchar(120) = '[ETL].[fact_property_arrears_transaction]';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_property_arrears_transaction];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_property_arrears_transaction];

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
		 [transaction_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_property_arrears_transaction]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_property_arrears_transaction]
			(
				 [transaction_id] 
				,dim_property_arrears_arrangement_key
				,dim_property_key 
				,dim_property_tenancy_key
				,dim_property_program_key
				,[property_arrears_arrangement_id] 
				,[property_tenancy_id] 
				,[property_id] 
				,[property_program_id] 
				,[property_subprogram_id] 
				,[transaction_detail_id] 
				,[transaction_number] 
				,[transaction_name] 
				,[transaction_description] 
				,[transaction_date] 
				,[transaction_date_id] 
				,[arrear_amount] 
				,[paid_amount] 
				,[state_label] 
				,[status_label] 
				,[owner_id] 
				,[created_datetime] 
				,[modified_datetime] 
				,[is_delete_flag] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[transaction_id] 
				,src.dim_property_arrears_arrangement_key
				,src.dim_property_key 
				,src.dim_property_tenancy_key
				,src.dim_property_program_key
				,src.[property_arrears_arrangement_id] 
				,src.[property_tenancy_id] 
				,src.[property_id] 
				,src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[transaction_detail_id] 
				,src.[transaction_number] 
				,src.[transaction_name] 
				,src.[transaction_description] 
				,src.[transaction_date] 
				,src.[transaction_date_id] 
				,src.[arrear_amount] 
				,src.[paid_amount] 
				,src.[state_label] 
				,src.[status_label] 
				,src.[owner_id] 
				,src.[created_datetime] 
				,src.[modified_datetime] 
				,src.[is_delete_flag] 
				,@BatchID as [DWHbatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_property_arrears_transaction] as src;
		end else begin
			merge into [edw].[fact_property_arrears_transaction] as trg
			using 
			(
				select
				 src.[transaction_id] 
				,src.dim_property_arrears_arrangement_key
				,src.dim_property_key 
				,src.dim_property_tenancy_key
				,src.dim_property_program_key
				,src.[property_arrears_arrangement_id] 
				,src.[property_tenancy_id] 
				,src.[property_id] 
				,src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[transaction_detail_id] 
				,src.[transaction_number] 
				,src.[transaction_name] 
				,src.[transaction_description] 
				,src.[transaction_date] 
				,src.[transaction_date_id] 
				,src.[arrear_amount] 
				,src.[paid_amount] 
				,src.[state_label] 
				,src.[status_label] 
				,src.[owner_id] 
				,src.[created_datetime] 
				,src.[modified_datetime] 
				,src.[is_delete_flag] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_property_arrears_transaction] as src
			) as src on (src.[transaction_id] = trg.[transaction_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select  src.[property_arrears_arrangement_id], src.[property_tenancy_id], src.[property_id], src.[property_program_id], src.[property_subprogram_id], src.[transaction_detail_id], src.[transaction_number], src.[transaction_name], src.[transaction_description], src.[transaction_date], src.[transaction_date_id], src.[arrear_amount], src.[paid_amount], src.[state_label], src.[status_label], src.[owner_id], src.[created_datetime], src.[modified_datetime], src.[is_delete_flag], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[property_arrears_arrangement_id], trg.[property_tenancy_id], trg.[property_id], trg.[property_program_id], trg.[property_subprogram_id], trg.[transaction_detail_id], trg.[transaction_number], trg.[transaction_name], trg.[transaction_description], trg.[transaction_date], trg.[transaction_date_id], trg.[arrear_amount], trg.[paid_amount], trg.[state_label], trg.[status_label], trg.[owner_id], trg.[created_datetime], trg.[modified_datetime], trg.[is_delete_flag], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [transaction_id]
					 ,dim_property_arrears_arrangement_key
					 ,dim_property_key 
				     ,dim_property_tenancy_key
				     ,dim_property_program_key
  				    ,[property_arrears_arrangement_id] 
					,[property_tenancy_id] 
					,[property_id] 
					,[property_program_id] 
					,[property_subprogram_id] 
					,[transaction_detail_id] 
					,[transaction_number] 
					,[transaction_name] 
					,[transaction_description] 
					,[transaction_date] 
					,[transaction_date_id] 
					,[arrear_amount] 
					,[paid_amount] 
					,[state_label] 
					,[status_label] 
					,[owner_id] 
					,[created_datetime] 
					,[modified_datetime] 
					,[is_delete_flag] 
					,[DWHbatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[transaction_id]
					,src.dim_property_arrears_arrangement_key
					,src.dim_property_key 
					,src.dim_property_tenancy_key
					,src.dim_property_program_key
					,src.[property_arrears_arrangement_id] 
					,src.[property_tenancy_id] 
					,src.[property_id] 
					,src.[property_program_id] 
					,src.[property_subprogram_id] 
					,src.[transaction_detail_id] 
					,src.[transaction_number] 
					,src.[transaction_name] 
					,src.[transaction_description] 
					,src.[transaction_date] 
					,src.[transaction_date_id] 
					,src.[arrear_amount] 
					,src.[paid_amount] 
					,src.[state_label] 
					,src.[status_label] 
					,src.[owner_id] 
					,src.[created_datetime] 
					,src.[modified_datetime] 
					,src.[is_delete_flag] 
					,src.[DWHbatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[transaction_id],inserted.[transaction_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_property_arrears_transaction]
			(
				 [transaction_id] 
				,dim_property_arrears_arrangement_key
				,dim_property_key 
				,dim_property_tenancy_key
				,dim_property_program_key
				,[property_arrears_arrangement_id] 
				,[property_tenancy_id] 
				,[property_id] 
				,[property_program_id] 
				,[property_subprogram_id] 
				,[transaction_detail_id] 
				,[transaction_number] 
				,[transaction_name] 
				,[transaction_description] 
				,[transaction_date] 
				,[transaction_date_id] 
				,[arrear_amount] 
				,[paid_amount] 
				,[state_label] 
				,[status_label] 
				,[owner_id] 
				,[created_datetime] 
				,[modified_datetime] 
				,[is_delete_flag] 
				,[DWHbatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[transaction_id] 
				,src.dim_property_arrears_arrangement_key
				,src.dim_property_key 
				,src.dim_property_tenancy_key
				,src.dim_property_program_key
				,src.[property_arrears_arrangement_id] 
				,src.[property_tenancy_id] 
				,src.[property_id] 
				,src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[transaction_detail_id] 
				,src.[transaction_number] 
				,src.[transaction_name] 
				,src.[transaction_description] 
				,src.[transaction_date] 
				,src.[transaction_date_id] 
				,src.[arrear_amount] 
				,src.[paid_amount] 
				,src.[state_label] 
				,src.[status_label] 
				,src.[owner_id] 
				,src.[created_datetime] 
				,src.[modified_datetime] 
				,src.[is_delete_flag] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_property_arrears_transaction]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_property_arrears_transaction] as src on src.[transaction_id] = base.[transaction_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[transaction_id] 
				,tbl.dim_property_arrears_arrangement_key
				,tbl.dim_property_key 
				,tbl.dim_property_tenancy_key
				,tbl.dim_property_program_key
				,tbl.[property_arrears_arrangement_id] 
				,tbl.[property_tenancy_id] 
				,tbl.[property_id] 
				,tbl.[property_program_id] 
				,tbl.[property_subprogram_id] 
				,tbl.[transaction_detail_id] 
				,tbl.[transaction_number] 
				,tbl.[transaction_name] 
				,tbl.[transaction_description] 
				,tbl.[transaction_date] 
				,tbl.[transaction_date_id] 
				,tbl.[arrear_amount] 
				,tbl.[paid_amount] 
				,tbl.[state_label] 
				,tbl.[status_label] 
				,tbl.[owner_id] 
				,tbl.[created_datetime] 
				,tbl.[modified_datetime] 
				,tbl.[is_delete_flag] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_property_arrears_transaction]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_property_arrears_transaction] as tbl on tbl.[transaction_id] = base.[transaction_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_property_arrears_transaction] as src on src.[transaction_id] = base.[transaction_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[transaction_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHbatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHbatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHbatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_property_arrears_transaction]
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