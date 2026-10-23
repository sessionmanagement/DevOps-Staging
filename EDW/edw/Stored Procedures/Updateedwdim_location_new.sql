

create procedure [edw].[Updateedwdim_location_new] 
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
NAME:     [edw].[Updateedwdim_location_new]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-03-13    Pankaj Bhatt		Initial version

****************************************************************************/


begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'intelliHR.locations';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_location_new];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_location_new];

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
		 [location_code] nvarchar(4000) null
		,[company_name] nvarchar(4000) null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
	
		-- insert N/A, Unknown records

		if( not exists (select top(1) 1 from [edw].[dim_location_new] where [dim_location_key] <= 0) )
			begin
			
			-- turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_location_new] ON

			insert into [edw].[dim_location_new]
			(
				 [dim_location_key]
				,[dim_location_code_company_key]
				,[dim_company_key]
				,[intelliHR_location_id]
				,[business_central_location_id]
				,[location_code]
				,[intelliHR_location_name]
				,[business_central_location_name]
				,[parent_location_id]
				,[parent_location_code]
				,[parent_location_name]
				,[last_modified_datetime]
				,[exists_in_intelliHR]
				,[exists_in_business_central]
				,[company_name]
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,[DWHSourceSystem] 
			)
			VALUES	(0,'N/A',0,'N/A','N/A','N/A','N/A','N/A','N/A','N/A','N/A','1900-01-01',0,0,'N/A',0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem),
			(-1,'Unknown',-1,'Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','Unknown','1900-01-01',-1,-1,'Unknown',0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem)
			 -- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_location_new] OFF
			end
			
	
		if( not exists (select top(1) 1 from [edw].[dim_location_new] where dim_location_key > 0) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_location_new]
			(
				 [dim_location_code_company_key]
				,[dim_company_key]
				,[intelliHR_location_id] 
				,[business_central_location_id] 
				,[location_code] 
				,[intelliHR_location_name] 
				,[business_central_location_name] 
				,[parent_location_id] 
				,[parent_location_code] 
				,[parent_location_name] 
				,[last_modified_datetime] 
				,[exists_in_intelliHR] 
				,[exists_in_business_central] 
				,[company_name] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_location_code_company_key]
				,src.[dim_company_key]
				,src.[intelliHR_location_id] 
				,src.[business_central_location_id] 
				,src.[location_code] 
				,src.[intelliHR_location_name] 
				,src.[business_central_location_name] 
				,src.[parent_location_id] 
				,src.[parent_location_code] 
				,src.[parent_location_name] 
				,src.[last_modified_datetime] 
				,src.[exists_in_intelliHR] 
				,src.[exists_in_business_central] 
				,src.[company_name] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_location_new] as src;
		end else begin
			merge into [edw].[dim_location_new] as trg
			using 
			(
				select
				 src.[dim_location_code_company_key]
				,src.[dim_company_key]
				,src.[intelliHR_location_id] 
				,src.[business_central_location_id] 
				,src.[location_code] 
				,src.[intelliHR_location_name] 
				,src.[business_central_location_name] 
				,src.[parent_location_id] 
				,src.[parent_location_code] 
				,src.[parent_location_name] 
				,src.[last_modified_datetime] 
				,src.[exists_in_intelliHR] 
				,src.[exists_in_business_central] 
				,src.[company_name] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_location_new] as src
			) as src on (src.[location_code] = trg.[location_code] collate database_default and isnull(src.[company_name],'DUMMY') = isnull(trg.[company_name],'DUMMY') collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_location_code_company_key], src.[dim_company_key], src.[intelliHR_location_id], src.[business_central_location_id], src.[intelliHR_location_name], src.[business_central_location_name], src.[parent_location_id], src.[parent_location_code], src.[parent_location_name], src.[last_modified_datetime], src.[exists_in_intelliHR], src.[exists_in_business_central], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_location_code_company_key], trg.[dim_company_key], trg.[intelliHR_location_id], trg.[business_central_location_id], trg.[intelliHR_location_name], trg.[business_central_location_name], trg.[parent_location_id], trg.[parent_location_code], trg.[parent_location_name], trg.[last_modified_datetime], trg.[exists_in_intelliHR], trg.[exists_in_business_central], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' and trg.dim_location_key > 0 then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_location_code_company_key]
					,[dim_company_key]
					,[intelliHR_location_id] 
					,[business_central_location_id] 
					,[location_code] 
					,[intelliHR_location_name] 
					,[business_central_location_name] 
					,[parent_location_id] 
					,[parent_location_code] 
					,[parent_location_name] 
					,[last_modified_datetime] 
					,[exists_in_intelliHR] 
					,[exists_in_business_central] 
					,[company_name] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_location_code_company_key]
					,src.[dim_company_key]
					,src.[intelliHR_location_id] 
					,src.[business_central_location_id] 
					,src.[location_code] 
					,src.[intelliHR_location_name] 
					,src.[business_central_location_name] 
					,src.[parent_location_id] 
					,src.[parent_location_code] 
					,src.[parent_location_name] 
					,src.[last_modified_datetime] 
					,src.[exists_in_intelliHR] 
					,src.[exists_in_business_central] 
					,src.[company_name] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[location_code],inserted.[location_code]), coalesce(isnull(src.[company_name],'DUMMY'),isnull(inserted.[company_name],'DUMMY')), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_location_new]
			(
				 [dim_location_code_company_key]
				,[dim_company_key]
				,[intelliHR_location_id] 
				,[business_central_location_id] 
				,[location_code] 
				,[intelliHR_location_name] 
				,[business_central_location_name] 
				,[parent_location_id] 
				,[parent_location_code] 
				,[parent_location_name] 
				,[last_modified_datetime] 
				,[exists_in_intelliHR] 
				,[exists_in_business_central] 
				,[company_name] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_location_code_company_key]
				,src.[dim_company_key]
				,src.[intelliHR_location_id] 
				,src.[business_central_location_id] 
				,src.[location_code] 
				,src.[intelliHR_location_name] 
				,src.[business_central_location_name] 
				,src.[parent_location_id] 
				,src.[parent_location_code] 
				,src.[parent_location_name] 
				,src.[last_modified_datetime] 
				,src.[exists_in_intelliHR] 
				,src.[exists_in_business_central] 
				,src.[company_name] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_location_new] as src on src.[location_code] = base.[location_code] collate database_default and isnull(src.[company_name],'DUMMY') = isnull(base.[company_name],'DUMMY') collate database_default
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[dim_location_code_company_key]
				,tbl.[dim_company_key]
				,tbl.[intelliHR_location_id] 
				,tbl.[business_central_location_id] 
				,tbl.[location_code] 
				,tbl.[intelliHR_location_name] 
				,tbl.[business_central_location_name] 
				,tbl.[parent_location_id] 
				,tbl.[parent_location_code] 
				,tbl.[parent_location_name] 
				,tbl.[last_modified_datetime] 
				,tbl.[exists_in_intelliHR] 
				,tbl.[exists_in_business_central] 
				,tbl.[company_name] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_location_new] as tbl on tbl.[location_code] = base.[location_code] collate database_default and isnull(tbl.[company_name],'DUMMY') = isnull(base.[company_name],'DUMMY') collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_location_new] as src on src.[location_code] = base.[location_code] collate database_default and isnull(src.[company_name],'DUMMY') = isnull(base.[company_name],'DUMMY') collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[location_code] is null and src.[company_name] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_location_new]
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