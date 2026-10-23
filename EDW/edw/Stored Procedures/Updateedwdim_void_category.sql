CREATE procedure [edw].[Updateedwdim_void_category] 
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
	declare @SourceSystem nvarchar(120) = 'Zavanti.vw_zav_voidcategory';
	
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
	select @stagedRecords = count(1) from [Staging].[ODSETLdim_void_category];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[dim_void_category];

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
		 [void_category_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;

	begin try
		IF (
		NOT EXISTS (
			SELECT 1
			FROM [edw].[dim_void_category]
			WHERE dim_void_category_key <= 0
			)
		)
		BEGIN
			-- turn the identity insert on 
			SET IDENTITY_INSERT [edw].[dim_void_category] ON

			INSERT INTO [edw].[dim_void_category] (
				[dim_void_category_key]
				,[void_category_id]
				,void_category_state_code 
				,void_category_status_code
				,void_category_code
				,void_category_name
				,void_category_description
				,void_category_comments 
				,[DWHSourceSystem]
				,[DWHBatchId]
				,[DWHDMLOperation]
				,[DWHIsCurrent]
				,DWHEffectiveFrom
				,DWHEffectiveTo
				)
			VALUES (
				0
				,null
				,0
				,0
				,0
				,'N/A'
				,'N/A'
				,'N/A'
				,@SourceSystem
				,0
				,'I'
				,1
				,@SystemDefaultEffectiveFrom
				,@SystemDefaultEffectiveTo
				)
				,(
				- 1
				,null
				,-1
				,-1
				,-1
				,'Unknown'
				,'Unknown'
				,'Unknown'
				,@SourceSystem
				,0
				,'I'
				,1
				,@SystemDefaultEffectiveFrom
				,@SystemDefaultEffectiveTo
				)

			-- turn the identity insert off
			SET IDENTITY_INSERT [edw].[dim_void_category] OFF
		END
		
		
		
		
		
		if( not exists (select top(1) 1 from [edw].[dim_void_category]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_void_category]
			(		void_category_id
				    ,void_category_state_code
					,void_category_status_code
					,void_category_code
					,void_category_target_group
					,owning_user_id
					,owner_id
					,overridden_created_on
					,owner_id_name
					,owner_id_yomi_name
					,owning_business_unit_name
					,time_zone_rule_version_number
					,utc_conversion_timezone_code
					,version_number
					,void_category_comments
					,void_category_days_vacant_kpi
					,void_category_days_void_kpi
					,void_category_description
					,void_category_name
					,void_category_total_days_kpi
					,void_category_is_delete_flag

				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
					src.void_category_id
				    ,src.void_category_state_code
					,src.void_category_status_code
					,src.void_category_code
					,src.void_category_target_group
					,src.owning_user_id
					,src.owner_id
					,src.overridden_created_on
					,src.owner_id_name
					,src.owner_id_yomi_name
					,src.owning_business_unit_name
					,src.time_zone_rule_version_number
					,src.utc_conversion_timezone_code
					,src.version_number
					,src.void_category_comments
					,src.void_category_days_vacant_kpi
					,src.void_category_days_void_kpi
					,src.void_category_description
					,src.void_category_name
					,src.void_category_total_days_kpi
					,src.void_category_is_delete_flag
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_void_category] as src;
		end else begin
			merge into [edw].[dim_void_category] as trg
			using 
			(
				select
					src.void_category_id
				    ,src.void_category_state_code
					,src.void_category_status_code
					,src.void_category_code
					,src.void_category_target_group
					,src.owning_user_id
					,src.owner_id
					,src.overridden_created_on
					,src.owner_id_name
					,src.owner_id_yomi_name
					,src.owning_business_unit_name
					,src.time_zone_rule_version_number
					,src.utc_conversion_timezone_code
					,src.version_number
					,src.void_category_comments
					,src.void_category_days_vacant_kpi
					,src.void_category_days_void_kpi
					,src.void_category_description
					,src.void_category_name
					,src.void_category_total_days_kpi
					,src.void_category_is_delete_flag
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_void_category] as src
			) as src on (src.[void_category_id] = trg.[void_category_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[void_category_state_code], src.[void_category_status_code], src.[void_category_code], src.[void_category_target_group],  src.[owning_user_id],  src.[owner_id], src.[overridden_created_on], src.[owner_id_name],  src.[owner_id_yomi_name], src.[owning_business_unit_name], src.[time_zone_rule_version_number], src.[utc_conversion_timezone_code], src.[version_number], src.[void_category_comments], src.[void_category_days_vacant_kpi], src.[void_category_days_void_kpi], src.[void_category_description], src.[void_category_name], src.[void_category_total_days_kpi], src.[void_category_is_delete_flag], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[void_category_state_code], trg.[void_category_status_code], trg.[void_category_code], trg.[void_category_target_group],  trg.[owning_user_id],  trg.[owner_id], trg.[overridden_created_on], trg.[owner_id_name],  trg.[owner_id_yomi_name], trg.[owning_business_unit_name], trg.[time_zone_rule_version_number], trg.[utc_conversion_timezone_code], trg.[version_number], trg.[void_category_comments], trg.[void_category_days_vacant_kpi], trg.[void_category_days_void_kpi], trg.[void_category_description], trg.[void_category_name], trg.[void_category_total_days_kpi], trg.[void_category_is_delete_flag], 'X'
			) then  update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Soft delete missing records
			when not matched by source and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo and trg.[DWHDMLOperation] <> 'D' then update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 void_category_id
				    ,void_category_state_code
					,void_category_status_code
					,void_category_code
					,void_category_target_group
					,owning_user_id
					,owner_id
					,overridden_created_on
					,owner_id_name
					,owner_id_yomi_name
					,owning_business_unit_name
					,time_zone_rule_version_number
					,utc_conversion_timezone_code
					,version_number
					,void_category_comments
					,void_category_days_vacant_kpi
					,void_category_days_void_kpi
					,void_category_description
					,void_category_name
					,void_category_total_days_kpi
					,void_category_is_delete_flag

					,[DWHBatchId] 
					,[DWHEffectiveFrom] 
					,[DWHEffectiveTo] 
					,[DWHDMLOperation] 
					,[DWHIsCurrent] 
					,[DWHSourceSystem] 
				)
				values
				(	src.void_category_id
				    ,src.void_category_state_code
					,src.void_category_status_code
					,src.void_category_code
					,src.void_category_target_group
					,src.owning_user_id
					,src.owner_id
					,src.overridden_created_on
					,src.owner_id_name
					,src.owner_id_yomi_name
					,src.owning_business_unit_name
					,src.time_zone_rule_version_number
					,src.utc_conversion_timezone_code
					,src.version_number
					,src.void_category_comments
					,src.void_category_days_vacant_kpi
					,src.void_category_days_void_kpi
					,src.void_category_description
					,src.void_category_name
					,src.void_category_total_days_kpi
					,src.void_category_is_delete_flag
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[void_category_id],inserted.[void_category_id]), $action As [MergeAction] into #SummaryOfChanges;

			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_void_category]
			(
					void_category_id
				    ,void_category_state_code
					,void_category_status_code
					,void_category_code
					,void_category_target_group
					,owning_user_id
					,owner_id
					,overridden_created_on
					,owner_id_name
					,owner_id_yomi_name
					,owning_business_unit_name
					,time_zone_rule_version_number
					,utc_conversion_timezone_code
					,version_number
					,void_category_comments
					,void_category_days_vacant_kpi
					,void_category_days_void_kpi
					,void_category_description
					,void_category_name
					,void_category_total_days_kpi
					,void_category_is_delete_flag
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select  src.void_category_id
				    ,src.void_category_state_code
					,src.void_category_status_code
					,src.void_category_code
					,src.void_category_target_group
					,src.owning_user_id
					,src.owner_id
					,src.overridden_created_on
					,src.owner_id_name
					,src.owner_id_yomi_name
					,src.owning_business_unit_name
					,src.time_zone_rule_version_number
					,src.utc_conversion_timezone_code
					,src.version_number
					,src.void_category_comments
					,src.void_category_days_vacant_kpi
					,src.void_category_days_void_kpi
					,src.void_category_description
					,src.void_category_name
					,src.void_category_total_days_kpi
					,src.void_category_is_delete_flag
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.vw_zav_voidcategory'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_void_category] as src on src.[void_category_id] = base.[void_category_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select tbl.void_category_id
				    ,tbl.void_category_state_code
					,tbl.void_category_status_code
					,tbl.void_category_code
					,tbl.void_category_target_group
					,tbl.owning_user_id
					,tbl.owner_id
					,tbl.overridden_created_on
					,tbl.owner_id_name
					,tbl.owner_id_yomi_name
					,tbl.owning_business_unit_name
					,tbl.time_zone_rule_version_number
					,tbl.utc_conversion_timezone_code
					,tbl.version_number
					,tbl.void_category_comments
					,tbl.void_category_days_vacant_kpi
					,tbl.void_category_days_void_kpi
					,tbl.void_category_description
					,tbl.void_category_name
					,tbl.void_category_total_days_kpi
					,tbl.void_category_is_delete_flag
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'Zavanti.vw_zav_voidcategory'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_void_category] as tbl on tbl.[void_category_id] = base.[void_category_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_void_category] as src on src.[void_category_id] = base.[void_category_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[void_category_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_void_category]
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