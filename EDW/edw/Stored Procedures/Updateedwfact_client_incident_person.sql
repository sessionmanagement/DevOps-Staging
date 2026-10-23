

CREATE procedure [edw].[Updateedwfact_client_incident_person] 
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
	declare @SourceSystem nvarchar(120) = 'rbeal/rbmnb dlFactIncidentPerson';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_client_incident_person];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_client_incident_person];

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
		 [dim_company_key] int not null
		,[incident_id] int null
		,[client_id] int null
		,[incident_client_entity_type] nvarchar(50) null
		,[incident_client_role] nvarchar(150) null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_client_incident_person]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_client_incident_person]
			(
				 dim_client_incident_company_key_incident_id_key
				,[dim_company_key]
				,[dim_client_incident_key]
				,[dim_client_key]
				,[incident_id] 
				,[client_id] 
				,[incident_client_entity_type] 
				,[incident_client_role] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_company_key]
				,src.[dim_client_incident_key]
				,src.[dim_client_key]
				,src.[incident_id] 
				,src.[client_id] 
				,src.[incident_client_entity_type] 
				,src.[incident_client_role] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_client_incident_person] as src;
		end else begin
			merge into [edw].[fact_client_incident_person] as trg
			using 
			(
				select
				 src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_company_key]
				,src.[dim_client_incident_key]
				,src.[dim_client_key]
				,src.[incident_id] 
				,src.[client_id] 
				,src.[incident_client_entity_type] 
				,src.[incident_client_role] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_client_incident_person] as src
			) as src on (src.[dim_company_key] = trg.[dim_company_key] and src.[incident_id] = trg.[incident_id] and src.[client_id] = trg.[client_id] and src.[incident_client_entity_type] = trg.[incident_client_entity_type] collate database_default and src.[incident_client_role] = trg.[incident_client_role] collate database_default and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_client_incident_company_key_incident_id_key], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_client_incident_company_key_incident_id_key], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_client_incident_company_key_incident_id_key]
					,[dim_company_key]
					,[dim_client_incident_key]
					,[dim_client_key]
					,[incident_id] 
					,[client_id] 
					,[incident_client_entity_type] 
					,[incident_client_role] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[dim_client_incident_company_key_incident_id_key]
					,src.[dim_company_key]
					,src.[dim_client_incident_key]
					,src.[dim_client_key]
					,src.[incident_id] 
					,src.[client_id] 
					,src.[incident_client_entity_type] 
					,src.[incident_client_role] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[dim_company_key],inserted.[dim_company_key]), coalesce(src.[incident_id],inserted.[incident_id]), coalesce(src.[client_id],inserted.[client_id]), coalesce(src.[incident_client_entity_type],inserted.[incident_client_entity_type]), coalesce(src.[incident_client_role],inserted.[incident_client_role]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[fact_client_incident_person]
			(
				 [dim_client_incident_company_key_incident_id_key]
				,[dim_company_key]
				,[dim_client_incident_key]
				,[dim_client_key] 
				,[incident_id] 
				,[client_id] 
				,[incident_client_entity_type] 
				,[incident_client_role] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[dim_client_incident_company_key_incident_id_key]
				,src.[dim_company_key]
				,src.[dim_client_incident_key]
				,src.[dim_client_key] 
				,src.[incident_id] 
				,src.[client_id] 
				,src.[incident_client_entity_type] 
				,src.[incident_client_role] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_client_incident_person]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLfact_client_incident_person] as src on src.[dim_company_key] = base.[dim_company_key] and src.[incident_id] = base.[incident_id] and src.[client_id] = base.[client_id] and src.[incident_client_entity_type] = base.[incident_client_entity_type] collate database_default and src.[incident_client_role] = base.[incident_client_role] collate database_default
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[dim_client_incident_company_key_incident_id_key]
				,tbl.[dim_company_key]
				,tbl.[dim_client_incident_key]
				,tbl.[dim_client_key] 
				,tbl.[incident_id] 
				,tbl.[client_id] 
				,tbl.[incident_client_entity_type] 
				,tbl.[incident_client_role] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLfact_client_incident_person]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[fact_client_incident_person] as tbl on tbl.[dim_company_key] = base.[dim_company_key] and tbl.[incident_id] = base.[incident_id] and tbl.[client_id] = base.[client_id] and tbl.[incident_client_entity_type] = base.[incident_client_entity_type] collate database_default and tbl.[incident_client_role] = base.[incident_client_role] collate database_default and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLfact_client_incident_person] as src on src.[dim_company_key] = base.[dim_company_key] and src.[incident_id] = base.[incident_id] and src.[client_id] = base.[client_id] and src.[incident_client_entity_type] = base.[incident_client_entity_type] collate database_default and src.[incident_client_role] = base.[incident_client_role] collate database_default
			where base.[MergeAction] = 'UPDATE'
			and  src.[dim_company_key] is null and src.[incident_id] is null and src.[client_id] is null and src.[incident_client_entity_type] is null and src.[incident_client_role] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_client_incident_person]
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