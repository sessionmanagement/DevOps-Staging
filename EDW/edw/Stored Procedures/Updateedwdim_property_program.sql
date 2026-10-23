


/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property_program]
 Author		
 Created		
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
	
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2023-12-13	  Glenn McLeod			Initial version
1.3        2025-05-06     Manish Singh   Changed Prefix of Audit columns from EDW to DWH


**********************************************************************************************************/


CREATE procedure [edw].[Updateedwdim_property_program] 
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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_property_program]';

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
			 [property_subprogram_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try


		IF (
		NOT EXISTS (
			SELECT 1
			FROM [edw].[dim_property_program]
			WHERE dim_property_program_id <= 0
			)
		)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_property_program] ON

			INSERT INTO [edw].[dim_property_program] (
				dim_property_program_id
				,property_program_id
				,property_subprogram_id
				,property_program_name
				,property_program_owner_name
				,property_subprogram_name
				,property_subprogram_property_transaction_types
				,property_subprogram_state
				,property_subprogram_status
				,property_market_rent_ignore_flag
				,property_subprogram_owning_business_unit_name
				,property_subprogram_owning_team_name
				,property_subprogram_owning_user_name
				,property_subprogram_owner_name
				,property_subprogram_created_by_user_name
				,property_subprogram_modified_by_user_name
				,property_subprogram_modified_on_date
				,property_subprogram_version_number
				,property_subprogram_code
				,property_subprogram_deleted_flag
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
				,NULL
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,NULL
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
				,'N/A'
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
				,NULL
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,NULL
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,'Unknown'
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
			SET IDENTITY_INSERT [edw].[dim_property_program] OFF
		END


		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLdim_property_program];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[dim_property_program];
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

		if( not exists (select top(1) 1 from [edw].[dim_property_program]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_property_program]
			(
				 [property_program_id] 
				,[property_subprogram_id] 
				,[property_program_name] 
				,[property_program_owner_name] 
				,[property_subprogram_name] 
				,[property_subprogram_property_transaction_types] 
				,[property_subprogram_state] 
				,[property_subprogram_status] 
				,[property_market_rent_ignore_flag] 
				,[property_subprogram_owning_business_unit_name] 
				,[property_subprogram_owning_team_name] 
				,[property_subprogram_owning_user_name] 
				,[property_subprogram_owner_name] 
				,[property_subprogram_created_by_user_name] 
				,[property_subprogram_modified_by_user_name] 
				,[property_subprogram_modified_on_date] 
				,[property_subprogram_version_number] 
				,[property_subprogram_code] 
				,[property_subprogram_deleted_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[property_program_name] 
				,src.[property_program_owner_name] 
				,src.[property_subprogram_name] 
				,src.[property_subprogram_property_transaction_types] 
				,src.[property_subprogram_state] 
				,src.[property_subprogram_status] 
				,src.[property_market_rent_ignore_flag] 
				,src.[property_subprogram_owning_business_unit_name] 
				,src.[property_subprogram_owning_team_name] 
				,src.[property_subprogram_owning_user_name] 
				,src.[property_subprogram_owner_name] 
				,src.[property_subprogram_created_by_user_name] 
				,src.[property_subprogram_modified_by_user_name] 
				,src.[property_subprogram_modified_on_date] 
				,src.[property_subprogram_version_number] 
				,src.[property_subprogram_code] 
				,src.[property_subprogram_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_property_program] as src;
		end else begin
			-- Fetch the current high-water maximum values
			declare @synapse_link_sink_modified_on datetime2(7) = null;

			execute [edw].[GetHighwaterForedwdim_property_program] @synapse_link_sink_modified_on output;

			merge into [edw].[dim_property_program] as trg
			using 
			(
				select
				 src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[property_program_name] 
				,src.[property_program_owner_name] 
				,src.[property_subprogram_name] 
				,src.[property_subprogram_property_transaction_types] 
				,src.[property_subprogram_state] 
				,src.[property_subprogram_status] 
				,src.[property_market_rent_ignore_flag] 
				,src.[property_subprogram_owning_business_unit_name] 
				,src.[property_subprogram_owning_team_name] 
				,src.[property_subprogram_owning_user_name] 
				,src.[property_subprogram_owner_name] 
				,src.[property_subprogram_created_by_user_name] 
				,src.[property_subprogram_modified_by_user_name] 
				,src.[property_subprogram_modified_on_date] 
				,src.[property_subprogram_version_number] 
				,src.[property_subprogram_code] 
				,src.[property_subprogram_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_property_program] as src
			) as src on (src.[property_subprogram_id] = trg.[property_subprogram_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[property_program_id], src.[property_program_name], src.[property_program_owner_name], src.[property_subprogram_name], src.[property_subprogram_property_transaction_types], src.[property_subprogram_state], src.[property_subprogram_status], src.[property_market_rent_ignore_flag], src.[property_subprogram_owning_business_unit_name], src.[property_subprogram_owning_team_name], src.[property_subprogram_owning_user_name], src.[property_subprogram_owner_name], src.[property_subprogram_created_by_user_name], src.[property_subprogram_modified_by_user_name], src.[property_subprogram_modified_on_date], src.[property_subprogram_version_number], src.[property_subprogram_code], src.[property_subprogram_deleted_flag], src.[synapse_link_sink_modified_on], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[property_program_id], trg.[property_program_name], trg.[property_program_owner_name], trg.[property_subprogram_name], trg.[property_subprogram_property_transaction_types], trg.[property_subprogram_state], trg.[property_subprogram_status], trg.[property_market_rent_ignore_flag], trg.[property_subprogram_owning_business_unit_name], trg.[property_subprogram_owning_team_name], trg.[property_subprogram_owning_user_name], trg.[property_subprogram_owner_name], trg.[property_subprogram_created_by_user_name], trg.[property_subprogram_modified_by_user_name], trg.[property_subprogram_modified_on_date], trg.[property_subprogram_version_number], trg.[property_subprogram_code], trg.[property_subprogram_deleted_flag], trg.[synapse_link_sink_modified_on], 'X'
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.dim_property_program_id > 0
			and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo 
			and trg.[DWHDMLOperation] <> 'D' 
			and trg.[synapse_link_sink_modified_on] > @synapse_link_sink_modified_on then 
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_program_id] 
					,[property_subprogram_id] 
					,[property_program_name] 
					,[property_program_owner_name] 
					,[property_subprogram_name] 
					,[property_subprogram_property_transaction_types] 
					,[property_subprogram_state] 
					,[property_subprogram_status] 
					,[property_market_rent_ignore_flag] 
					,[property_subprogram_owning_business_unit_name] 
					,[property_subprogram_owning_team_name] 
					,[property_subprogram_owning_user_name] 
					,[property_subprogram_owner_name] 
					,[property_subprogram_created_by_user_name] 
					,[property_subprogram_modified_by_user_name] 
					,[property_subprogram_modified_on_date] 
					,[property_subprogram_version_number] 
					,[property_subprogram_code] 
					,[property_subprogram_deleted_flag] 
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
					 src.[property_program_id] 
					,src.[property_subprogram_id] 
					,src.[property_program_name] 
					,src.[property_program_owner_name] 
					,src.[property_subprogram_name] 
					,src.[property_subprogram_property_transaction_types] 
					,src.[property_subprogram_state] 
					,src.[property_subprogram_status] 
					,src.[property_market_rent_ignore_flag] 
					,src.[property_subprogram_owning_business_unit_name] 
					,src.[property_subprogram_owning_team_name] 
					,src.[property_subprogram_owning_user_name] 
					,src.[property_subprogram_owner_name] 
					,src.[property_subprogram_created_by_user_name] 
					,src.[property_subprogram_modified_by_user_name] 
					,src.[property_subprogram_modified_on_date] 
					,src.[property_subprogram_version_number] 
					,src.[property_subprogram_code] 
					,src.[property_subprogram_deleted_flag] 
					,src.[synapse_link_sink_modified_on] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_subprogram_id],inserted.[property_subprogram_id]), $action As [MergeAction] into #SummaryOfChanges;
		
			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_property_program]
			(
				 [property_program_id] 
				,[property_subprogram_id] 
				,[property_program_name] 
				,[property_program_owner_name] 
				,[property_subprogram_name] 
				,[property_subprogram_property_transaction_types] 
				,[property_subprogram_state] 
				,[property_subprogram_status] 
				,[property_market_rent_ignore_flag] 
				,[property_subprogram_owning_business_unit_name] 
				,[property_subprogram_owning_team_name] 
				,[property_subprogram_owning_user_name] 
				,[property_subprogram_owner_name] 
				,[property_subprogram_created_by_user_name] 
				,[property_subprogram_modified_by_user_name] 
				,[property_subprogram_modified_on_date] 
				,[property_subprogram_version_number] 
				,[property_subprogram_code] 
				,[property_subprogram_deleted_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[property_program_id] 
				,src.[property_subprogram_id] 
				,src.[property_program_name] 
				,src.[property_program_owner_name] 
				,src.[property_subprogram_name] 
				,src.[property_subprogram_property_transaction_types] 
				,src.[property_subprogram_state] 
				,src.[property_subprogram_status] 
				,src.[property_market_rent_ignore_flag] 
				,src.[property_subprogram_owning_business_unit_name] 
				,src.[property_subprogram_owning_team_name] 
				,src.[property_subprogram_owning_user_name] 
				,src.[property_subprogram_owner_name] 
				,src.[property_subprogram_created_by_user_name] 
				,src.[property_subprogram_modified_by_user_name] 
				,src.[property_subprogram_modified_on_date] 
				,src.[property_subprogram_version_number] 
				,src.[property_subprogram_code] 
				,src.[property_subprogram_deleted_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_program]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_property_program] as src on src.[property_subprogram_id] = base.[property_subprogram_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[property_program_id] 
				,tbl.[property_subprogram_id] 
				,tbl.[property_program_name] 
				,tbl.[property_program_owner_name] 
				,tbl.[property_subprogram_name] 
				,tbl.[property_subprogram_property_transaction_types] 
				,tbl.[property_subprogram_state] 
				,tbl.[property_subprogram_status] 
				,tbl.[property_market_rent_ignore_flag] 
				,tbl.[property_subprogram_owning_business_unit_name] 
				,tbl.[property_subprogram_owning_team_name] 
				,tbl.[property_subprogram_owning_user_name] 
				,tbl.[property_subprogram_owner_name] 
				,tbl.[property_subprogram_created_by_user_name] 
				,tbl.[property_subprogram_modified_by_user_name] 
				,tbl.[property_subprogram_modified_on_date] 
				,tbl.[property_subprogram_version_number] 
				,tbl.[property_subprogram_code] 
				,tbl.[property_subprogram_deleted_flag] 
				,tbl.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_program]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_property_program] as tbl on tbl.[property_subprogram_id] = base.[property_subprogram_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_property_program] as src on src.[property_subprogram_id] = base.[property_subprogram_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[property_subprogram_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_property_program]
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