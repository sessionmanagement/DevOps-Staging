





CREATE procedure [edw].[Updateedwdim_client_incident_severity] 
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
NAME:     [edw].[Updateedwdim_client_incident_severity]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025-11-06    ?				Initial version
1.1		 2025-11-07    Pankaj Bhatt		Updated to include dim_company_key and DWH prefix
1.2		 2026-01-12	   Pankaj Bhatt		added composite key

****************************************************************************/

begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'rbeal/rbmnb dlDimIncidentSeverity';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_client_incident_severity];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_client_incident_severity];

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
		,[incident_severity_id] int null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try

	-- insert N/A, Unknown records

	if( not exists (select top(1) 1 from [edw].[dim_client_incident_severity] where dim_client_incident_severity_key <= 0) )
		begin
			-- turn the identity insert on 
		   SET IDENTITY_INSERT [edw].[dim_client_incident_severity] ON

			insert into [edw].[dim_client_incident_severity]
			(
				 dim_client_incident_severity_key
				,dim_client_incident_company_key_severity_id_key
				,[dim_company_key] 
				,[incident_severity_id] 
				,[incident_severity_value] 
				,[incident_severity_text] 
				,[is_incident_severity_active] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			VALUES	(0,0,0,0,'N/A','N/A',0,0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem),
			(-1,-1,-1,-1,'Unknown','Unknown',-1,0,@SystemDefaultEffectiveFrom,@SystemDefaultEffectiveTo,'I',1,@SourceSystem)
			 -- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_client_incident_severity] OFF
		end

		if( not exists (select top(1) 1 from [edw].[dim_client_incident_severity] where dim_client_incident_severity_key > 0) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_client_incident_severity]
			(
				 [dim_client_incident_company_key_severity_id_key]
				,[dim_company_key] 
				,[incident_severity_id] 
				,[incident_severity_value] 
				,[incident_severity_text] 
				,[is_incident_severity_active] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[company_key_severity_id]
				,src.[company_key] 
				,src.[incident_severity_id] 
				,src.[incident_severity_value] 
				,src.[incident_severity_text] 
				,src.[is_incident_severity_active] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_client_incident_severity] as src;
		end else begin
			merge into [edw].[dim_client_incident_severity] as trg
			using 
			(
				select
				 src.company_key_severity_id
				,src.[company_key] 
				,src.[incident_severity_id] 
				,src.[incident_severity_value] 
				,src.[incident_severity_text] 
				,src.[is_incident_severity_active] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_client_incident_severity] as src
			) as src on (src.[company_key] = trg.[dim_company_key] and src.[incident_severity_id] = trg.[incident_severity_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.company_key_severity_id, src.[incident_severity_value], src.[incident_severity_text], src.[is_incident_severity_active], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[dim_client_incident_company_key_severity_id_key], trg.[incident_severity_value], trg.[incident_severity_text], trg.[is_incident_severity_active], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' and trg.dim_client_incident_severity_key > 0 then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_client_incident_company_key_severity_id_key]
					,[dim_company_key] 
					,[incident_severity_id] 
					,[incident_severity_value] 
					,[incident_severity_text] 
					,[is_incident_severity_active] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					src.company_key_severity_id
					,src.[company_key] 
					,src.[incident_severity_id] 
					,src.[incident_severity_value] 
					,src.[incident_severity_text] 
					,src.[is_incident_severity_active] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[company_key],inserted.[dim_company_key]), coalesce(src.[incident_severity_id],inserted.[incident_severity_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_client_incident_severity]
			(
				 [dim_client_incident_company_key_severity_id_key]					
				,[dim_company_key] 
				,[incident_severity_id] 
				,[incident_severity_value] 
				,[incident_severity_text] 
				,[is_incident_severity_active] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[company_key_severity_id]
				,src.[company_key] 
				,src.[incident_severity_id] 
				,src.[incident_severity_value] 
				,src.[incident_severity_text] 
				,src.[is_incident_severity_active] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_client_incident_severity] as src on src.[company_key] = base.[dim_company_key] and src.[incident_severity_id] = base.[incident_severity_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				tbl.dim_client_incident_company_key_severity_id_key
				,tbl.[dim_company_key] 
				,tbl.[incident_severity_id] 
				,tbl.[incident_severity_value] 
				,tbl.[incident_severity_text] 
				,tbl.[is_incident_severity_active] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,@SourceSystem
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_client_incident_severity] as tbl on tbl.[dim_company_key] = base.[dim_company_key] and tbl.[incident_severity_id] = base.[incident_severity_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_client_incident_severity] as src on src.[company_key] = base.[dim_company_key] and src.[incident_severity_id] = base.[incident_severity_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[company_key] is null and src.[incident_severity_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_client_incident_severity]
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