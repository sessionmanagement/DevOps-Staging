/** =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-12-11\3	  Glenn McLeod			Initial version
1.3        2025-05-06     Manish Singh   Changed Prefix of Audit columns from EDW to DWH


**********************************************************************************************************/

CREATE procedure [edw].[Updateedwdim_property_maintenace_type] 
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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_property_maintenace_type]';

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
	if( object_id( 'tempdb..#SummaryOfChanges') is not null ) drop table #SummaryOfChanges;
	create table #SummaryOfChanges
	(	
			 [property_maintenance_type_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try



	IF (
		NOT EXISTS (
			SELECT 1
			FROM [edw].[dim_property_maintenace_type]
			WHERE dim_property_maintenace_type_id <= 0
			)
		)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_property_maintenace_type] ON

			INSERT INTO [edw].[dim_property_maintenace_type] (
				dim_property_maintenace_type_id
				,property_maintenance_type_id
				,property_maintenance_type_account_code
				,property_maintenance_type
				,property_maintenance_type_code
				,property_maintenance_service_agreement_priority
				,property_maintenance_priority
				,property_maintenance_owner_recovery_flag
				,property_maintenance_service_agreement_flag
				,property_maintenance_tenant_liable_flag
				,property_maintenance_account_type
				,property_maintenance_deleted_flag
				,synapse_link_sink_modified_on
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				)
			VALUES (
				0
				,NULL
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,NULL
				,NULL
				,NULL
				,'N/A'
				,NULL
				,convert(DATETIME, ' 1 January 1900 ')
				,@SourceSystem
				,0
				,'I'
				,convert(DATETIME, ' 1 January 1900 ')
				,@SystemDefaultEffectiveTo
				,1
				)
				,(
				-1
				,NULL
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,NULL
				,NULL
				,NULL
				,'Unknown'
				,NULL
				,convert(DATETIME, ' 1 January 1900 ')
				,@SourceSystem
				,0
				,'I'
				,convert(DATETIME, ' 1 January 1900 ')
				,@SystemDefaultEffectiveTo
				,1
				)
				
			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_property_maintenace_type] OFF
	
		END



		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLdim_property_maintenace_type];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[dim_property_maintenace_type];
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
						@targetRecords	as TargetRecords,
						@pErrorMessage as ErrorMessage;
			end;

			commit transaction;
			return;
		end;

		if( not exists (select top(1) 1 from [edw].[dim_property_maintenace_type]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_property_maintenace_type]
			(
				 [property_maintenance_type_id] 
				,[property_maintenance_type_account_code] 
				,[property_maintenance_type] 
				,[property_maintenance_type_code] 
				,[property_maintenance_service_agreement_priority] 
				,[property_maintenance_priority] 
				,[property_maintenance_owner_recovery_flag] 
				,[property_maintenance_service_agreement_flag] 
				,[property_maintenance_tenant_liable_flag] 
				,[property_maintenance_account_type] 
				,[property_maintenance_deleted_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[property_maintenance_type_id] 
				,src.[property_maintenance_type_account_code] 
				,src.[property_maintenance_type] 
				,src.[property_maintenance_type_code] 
				,src.[property_maintenance_service_agreement_priority] 
				,src.[property_maintenance_priority] 
				,src.[property_maintenance_owner_recovery_flag] 
				,src.[property_maintenance_service_agreement_flag] 
				,src.[property_maintenance_tenant_liable_flag] 
				,src.[property_maintenance_account_type] 
				,src.[property_maintenance_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_property_maintenace_type] as src;
		end else begin
			-- Fetch the current high-water maximum values
			declare @synapse_link_sink_modified_on datetime2(7) = null;

			execute [edw].[GetHighwaterForedwdim_property_maintenace_type] @synapse_link_sink_modified_on output;

			merge into [edw].[dim_property_maintenace_type] as trg
			using 
			(
				select
				 src.[property_maintenance_type_id] 
				,src.[property_maintenance_type_account_code] 
				,src.[property_maintenance_type] 
				,src.[property_maintenance_type_code] 
				,src.[property_maintenance_service_agreement_priority] 
				,src.[property_maintenance_priority] 
				,src.[property_maintenance_owner_recovery_flag] 
				,src.[property_maintenance_service_agreement_flag] 
				,src.[property_maintenance_tenant_liable_flag] 
				,src.[property_maintenance_account_type] 
				,src.[property_maintenance_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_property_maintenace_type] as src
			) as src on (src.[property_maintenance_type_id] = trg.[property_maintenance_type_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[property_maintenance_type_account_code], src.[property_maintenance_type], src.[property_maintenance_type_code], src.[property_maintenance_service_agreement_priority], src.[property_maintenance_priority], src.[property_maintenance_owner_recovery_flag], src.[property_maintenance_service_agreement_flag], src.[property_maintenance_tenant_liable_flag], src.[property_maintenance_account_type], src.[property_maintenance_deleted_flag], src.[synapse_link_sink_modified_on], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[property_maintenance_type_account_code], trg.[property_maintenance_type], trg.[property_maintenance_type_code], trg.[property_maintenance_service_agreement_priority], trg.[property_maintenance_priority], trg.[property_maintenance_owner_recovery_flag], trg.[property_maintenance_service_agreement_flag], trg.[property_maintenance_tenant_liable_flag], trg.[property_maintenance_account_type], trg.[property_maintenance_deleted_flag], trg.[synapse_link_sink_modified_on], 'X'
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.dim_property_maintenace_type_id > 0
			and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo 
			and trg.[DWHDMLOperation] <> 'D' 
			and trg.[synapse_link_sink_modified_on] > @synapse_link_sink_modified_on then 
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_maintenance_type_id] 
					,[property_maintenance_type_account_code] 
					,[property_maintenance_type] 
					,[property_maintenance_type_code] 
					,[property_maintenance_service_agreement_priority] 
					,[property_maintenance_priority] 
					,[property_maintenance_owner_recovery_flag] 
					,[property_maintenance_service_agreement_flag] 
					,[property_maintenance_tenant_liable_flag] 
					,[property_maintenance_account_type] 
					,[property_maintenance_deleted_flag] 
					,[synapse_link_sink_modified_on] 
					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(
					 src.[property_maintenance_type_id] 
					,src.[property_maintenance_type_account_code] 
					,src.[property_maintenance_type] 
					,src.[property_maintenance_type_code] 
					,src.[property_maintenance_service_agreement_priority] 
					,src.[property_maintenance_priority] 
					,src.[property_maintenance_owner_recovery_flag] 
					,src.[property_maintenance_service_agreement_flag] 
					,src.[property_maintenance_tenant_liable_flag] 
					,src.[property_maintenance_account_type] 
					,src.[property_maintenance_deleted_flag] 
					,src.[synapse_link_sink_modified_on] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_maintenance_type_id],inserted.[property_maintenance_type_id]), $action As [MergeAction] into #SummaryOfChanges;
		
			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_property_maintenace_type]
			(
				 [property_maintenance_type_id] 
				,[property_maintenance_type_account_code] 
				,[property_maintenance_type] 
				,[property_maintenance_type_code] 
				,[property_maintenance_service_agreement_priority] 
				,[property_maintenance_priority] 
				,[property_maintenance_owner_recovery_flag] 
				,[property_maintenance_service_agreement_flag] 
				,[property_maintenance_tenant_liable_flag] 
				,[property_maintenance_account_type] 
				,[property_maintenance_deleted_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[property_maintenance_type_id] 
				,src.[property_maintenance_type_account_code] 
				,src.[property_maintenance_type] 
				,src.[property_maintenance_type_code] 
				,src.[property_maintenance_service_agreement_priority] 
				,src.[property_maintenance_priority] 
				,src.[property_maintenance_owner_recovery_flag] 
				,src.[property_maintenance_service_agreement_flag] 
				,src.[property_maintenance_tenant_liable_flag] 
				,src.[property_maintenance_account_type] 
				,src.[property_maintenance_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_maintenace_type]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_property_maintenace_type] as src on src.[property_maintenance_type_id] = base.[property_maintenance_type_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[property_maintenance_type_id] 
				,tbl.[property_maintenance_type_account_code] 
				,tbl.[property_maintenance_type] 
				,tbl.[property_maintenance_type_code] 
				,tbl.[property_maintenance_service_agreement_priority] 
				,tbl.[property_maintenance_priority] 
				,tbl.[property_maintenance_owner_recovery_flag] 
				,tbl.[property_maintenance_service_agreement_flag] 
				,tbl.[property_maintenance_tenant_liable_flag] 
				,tbl.[property_maintenance_account_type] 
				,tbl.[property_maintenance_deleted_flag] 
				,tbl.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_maintenace_type]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_property_maintenace_type] as tbl on tbl.[property_maintenance_type_id] = base.[property_maintenance_type_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_property_maintenace_type] as src on src.[property_maintenance_type_id] = base.[property_maintenance_type_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[property_maintenance_type_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_property_maintenace_type]
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