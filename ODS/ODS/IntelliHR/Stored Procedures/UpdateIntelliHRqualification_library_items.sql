create procedure [IntelliHR].[UpdateIntelliHRqualification_library_items] 
	@pBatchID int,
	@pMode varchar(10) = 'Full'
as begin
	set nocount on;
	set xact_abort on;

	declare @pErrorRecords		int;
	declare @pInsertRecords		int;
	declare @pUpdateRecords		int;
	declare @pDeleteRecords		int;
	declare @pCompleted			int;
	declare @pTargetRecords		int;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[intellihr].[qualification_library_items]';
	
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


	-- Check if there are records in the source table
	select @stagedRecords = count(1) from [Staging].[IntelliHR_qualification_library_items];

	-- Do not run if there are no records in source
	if( @stagedRecords = 0 )
	begin
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				null			as TargetRecords;
		return;
	end;


	-- Check if there are records in the target table
	set @targetRecords = (select count(1) from [Working].[IntelliHR_qualification_library_items]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [IntelliHR].[qualification_library_items]
			with (
				location = 'IntelliHR/qualification_library_items/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[qualification_library_items_id] ,src.[name] ,src.[qualification_type_id] ,src.[qualification_type_name] ,src.[qualification_expiry_type] ,src.[qualification_registration_number_visibility_type] ,src.[qualification_attachment_requirement_type] ,src.[expiry_warning_period] ,src.[send_expiry_warning] ,src.[qualification_instance_usage_count] ,src.[job_requirement_group_usage_count] ,src.[job_requirement_usage_count] , 1 as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], 'I' as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[IntelliHR_qualification_library_items] src
		
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				@stagedRecords	as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				1				as Completed,
				@stagedRecords	as TargetRecords;

		return;

	end;

	begin try

		create external table [IntelliHR].[qualification_library_items]
			with (
				location = 'IntelliHR/qualification_library_items/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[qualification_library_items_id] , 'New' as MergeType
			from [Staging].[IntelliHR_qualification_library_items] as src
				left outer join [Working].[IntelliHR_qualification_library_items] trg
				on src.[qualification_library_items_id] = trg.[qualification_library_items_id] collate database_default and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[qualification_library_items_id] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[qualification_library_items_id] ,  'NTD' as MergeType
			from [Staging].[IntelliHR_qualification_library_items] as src
			inner join [Working].[IntelliHR_qualification_library_items] trg
				on src.[qualification_library_items_id] = trg.[qualification_library_items_id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[qualification_library_items_id] , 'Chg' as MergeType
			from [Staging].[IntelliHR_qualification_library_items] as src
				inner join [Working].[IntelliHR_qualification_library_items] trg
				on src.[qualification_library_items_id] = trg.[qualification_library_items_id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[name], src.[qualification_type_id], src.[qualification_type_name], src.[qualification_expiry_type], src.[qualification_registration_number_visibility_type], src.[qualification_attachment_requirement_type], src.[expiry_warning_period], src.[send_expiry_warning], src.[qualification_instance_usage_count], src.[job_requirement_group_usage_count], src.[job_requirement_usage_count]
					except
					select trg.[name], trg.[qualification_type_id], trg.[qualification_type_name], trg.[qualification_expiry_type], trg.[qualification_registration_number_visibility_type], trg.[qualification_attachment_requirement_type], trg.[expiry_warning_period], trg.[send_expiry_warning], trg.[qualification_instance_usage_count], trg.[job_requirement_group_usage_count], trg.[job_requirement_usage_count]
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[qualification_library_items_id] , 'Non' as MergeType
			from [Staging].[IntelliHR_qualification_library_items] as src
				inner join [Working].[IntelliHR_qualification_library_items] trg
				on src.[qualification_library_items_id] = trg.[qualification_library_items_id] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[name], src.[qualification_type_id], src.[qualification_type_name], src.[qualification_expiry_type], src.[qualification_registration_number_visibility_type], src.[qualification_attachment_requirement_type], src.[expiry_warning_period], src.[send_expiry_warning], src.[qualification_instance_usage_count], src.[job_requirement_group_usage_count], src.[job_requirement_usage_count]
					except
					select trg.[name], trg.[qualification_type_id], trg.[qualification_type_name], trg.[qualification_expiry_type], trg.[qualification_registration_number_visibility_type], trg.[qualification_attachment_requirement_type], trg.[expiry_warning_period], trg.[send_expiry_warning], trg.[qualification_instance_usage_count], trg.[job_requirement_group_usage_count], trg.[job_requirement_usage_count]
				)

			union all

			-- Record in Target, not Source - soft delete.  Ignore any existing soft deletes in target
			select  trg.[qualification_library_items_id] , 'Del' as MergeType
			from [Staging].[IntelliHR_qualification_library_items] as src
				right outer join [Working].[IntelliHR_qualification_library_items] trg
				on src.[qualification_library_items_id] = trg.[qualification_library_items_id] collate database_default
			where  src.[qualification_library_items_id] is null
				and trg.[ODSIsCurrent] = 1 
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'

			union all

			-- Previously soft deleted records that (still) dont exist in source
			select  src.[qualification_library_items_id] ,  'Non' as MergeType
			from [Staging].[IntelliHR_qualification_library_items] as src
				right outer join [Working].[IntelliHR_qualification_library_items] trg
					on src.[qualification_library_items_id] = trg.[qualification_library_items_id] collate database_default
			where  src.[qualification_library_items_id] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all


			-- Old versions of any row-versioned record
			select DISTINCT trg.[qualification_library_items_id] , 'Old' as MergeType
			from [Working].[IntelliHR_qualification_library_items] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0

		),

		cte_AllChanges as 
		(

			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[qualification_library_items_id] ,src.[name] ,src.[qualification_type_id] ,src.[qualification_type_name] ,src.[qualification_expiry_type] ,src.[qualification_registration_number_visibility_type] ,src.[qualification_attachment_requirement_type] ,src.[expiry_warning_period] ,src.[send_expiry_warning] ,src.[qualification_instance_usage_count] ,src.[job_requirement_group_usage_count] ,src.[job_requirement_usage_count] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[IntelliHR_qualification_library_items] src
				inner join cte_SummaryOfChanges chg 
				   on src.[qualification_library_items_id] = chg.[qualification_library_items_id] collate database_default
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
			select  trg.[qualification_library_items_id] ,trg.[name] ,trg.[qualification_type_id] ,trg.[qualification_type_name] ,trg.[qualification_expiry_type] ,trg.[qualification_registration_number_visibility_type] ,trg.[qualification_attachment_requirement_type] ,trg.[expiry_warning_period] ,trg.[send_expiry_warning] ,trg.[qualification_instance_usage_count] ,trg.[job_requirement_group_usage_count] ,trg.[job_requirement_usage_count] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Working].[IntelliHR_qualification_library_items] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[qualification_library_items_id] = chg.[qualification_library_items_id] collate database_default
			where chg.MergeType IN ('Del')
				and trg.[ODSIsCurrent] = 1

			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[qualification_library_items_id] ,src.[name] ,src.[qualification_type_id] ,src.[qualification_type_name] ,src.[qualification_expiry_type] ,src.[qualification_registration_number_visibility_type] ,src.[qualification_attachment_requirement_type] ,src.[expiry_warning_period] ,src.[send_expiry_warning] ,src.[qualification_instance_usage_count] ,src.[job_requirement_group_usage_count] ,src.[job_requirement_usage_count] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[IntelliHR_qualification_library_items] src
				inner join cte_SummaryOfChanges chg 
					on src.[qualification_library_items_id] = chg.[qualification_library_items_id] collate database_default
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[qualification_library_items_id] ,trg.[name] ,trg.[qualification_type_id] ,trg.[qualification_type_name] ,trg.[qualification_expiry_type] ,trg.[qualification_registration_number_visibility_type] ,trg.[qualification_attachment_requirement_type] ,trg.[expiry_warning_period] ,trg.[send_expiry_warning] ,trg.[qualification_instance_usage_count] ,trg.[job_requirement_group_usage_count] ,trg.[job_requirement_usage_count] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[IntelliHR_qualification_library_items] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[qualification_library_items_id] = chg.[qualification_library_items_id] collate database_default
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[qualification_library_items_id] ,trg.[name] ,trg.[qualification_type_id] ,trg.[qualification_type_name] ,trg.[qualification_expiry_type] ,trg.[qualification_registration_number_visibility_type] ,trg.[qualification_attachment_requirement_type] ,trg.[expiry_warning_period] ,trg.[send_expiry_warning] ,trg.[qualification_instance_usage_count] ,trg.[job_requirement_group_usage_count] ,trg.[job_requirement_usage_count] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[IntelliHR_qualification_library_items] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[qualification_library_items_id] = chg.[qualification_library_items_id] collate database_default
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[qualification_library_items_id] ,src.[name] ,src.[qualification_type_id] ,src.[qualification_type_name] ,src.[qualification_expiry_type] ,src.[qualification_registration_number_visibility_type] ,src.[qualification_attachment_requirement_type] ,src.[expiry_warning_period] ,src.[send_expiry_warning] ,src.[qualification_instance_usage_count] ,src.[job_requirement_group_usage_count] ,src.[job_requirement_usage_count] , 
			isnull(ODSIsCurrent, 1) as ODSIsCurrent, 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			isnull([ODSDMLOperation], 'I') as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src;

		set @insertedRecords = (select count(1) from [IntelliHR].[qualification_library_items] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [IntelliHR].[qualification_library_items] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [IntelliHR].[qualification_library_items] 
									where [ODSDMLOperation] = 'D' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);

		-- Select return parameters as a dataset
		select	0					as ErrorRecords,
				@insertedRecords	as InsertRecords,
				@updatedRecords		as UpdateRecords,
				@deletedRecords		as DeleteRecords,
				1					as Completed,
				@targetRecords		as TargetRecords;

		return;
	end try
	begin catch
		-- Select return parameters as a dataset
		select	0				as ErrorRecords,
				0				as InsertRecords,
				0				as UpdateRecords,
				0				as DeleteRecords,
				0				as Completed,
				0				as TargetRecords;

		throw;
	end catch

end;