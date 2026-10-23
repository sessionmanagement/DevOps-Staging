CREATE procedure [IntelliHR].[UpdateIntelliHRskill_disciplines] 
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
	declare @SourceSystem nvarchar(120) = '[intellihr].[skill_disciplines]';
	
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
	select @stagedRecords = count(1) from [Staging].[IntelliHR_skill_disciplines];

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
	set @targetRecords = (select count(1) from [Working].[IntelliHR_skill_disciplines]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [IntelliHR].[skill_disciplines]
			with (
				location = 'IntelliHR/skill_disciplines/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[skill_disciplines_id] ,src.[name] ,src.[skill_id] ,src.[skill_name] , CAST(1 AS int) as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], CAST('I' AS varchar(1)) as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[IntelliHR_skill_disciplines] src
		
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

		create external table [IntelliHR].[skill_disciplines]
			with (
				location = 'IntelliHR/skill_disciplines/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[skill_disciplines_id] 
,src.[skill_id] 
,src.[skill_name] , 'New' as MergeType
			from [Staging].[IntelliHR_skill_disciplines] as src
				left outer join [Working].[IntelliHR_skill_disciplines] trg
				on src.[skill_disciplines_id] = trg.[skill_disciplines_id] collate database_default and src.[skill_id] = trg.[skill_id] collate database_default and src.[skill_name] = trg.[skill_name] collate database_default and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[skill_disciplines_id] is null and trg.[skill_id] is null and trg.[skill_name] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[skill_disciplines_id] 
,src.[skill_id] 
,src.[skill_name] ,  'NTD' as MergeType
			from [Staging].[IntelliHR_skill_disciplines] as src
			inner join [Working].[IntelliHR_skill_disciplines] trg
				on src.[skill_disciplines_id] = trg.[skill_disciplines_id] collate database_default and src.[skill_id] = trg.[skill_id] collate database_default and src.[skill_name] = trg.[skill_name] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[skill_disciplines_id] 
,src.[skill_id] 
,src.[skill_name] , 'Chg' as MergeType
			from [Staging].[IntelliHR_skill_disciplines] as src
				inner join [Working].[IntelliHR_skill_disciplines] trg
				on src.[skill_disciplines_id] = trg.[skill_disciplines_id] collate database_default and src.[skill_id] = trg.[skill_id] collate database_default and src.[skill_name] = trg.[skill_name] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[name]
					except
					select trg.[name]
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[skill_disciplines_id] 
,src.[skill_id] 
,src.[skill_name] , 'Non' as MergeType
			from [Staging].[IntelliHR_skill_disciplines] as src
				inner join [Working].[IntelliHR_skill_disciplines] trg
				on src.[skill_disciplines_id] = trg.[skill_disciplines_id] collate database_default and src.[skill_id] = trg.[skill_id] collate database_default and src.[skill_name] = trg.[skill_name] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[name]
					except
					select trg.[name]
				)

			union all

			-- Record in Target, not Source - soft delete.  Ignore any existing soft deletes in target
			select  trg.[skill_disciplines_id] 
,trg.[skill_id] 
,trg.[skill_name] , 'Del' as MergeType
			from [Staging].[IntelliHR_skill_disciplines] as src
				right outer join [Working].[IntelliHR_skill_disciplines] trg
				on src.[skill_disciplines_id] = trg.[skill_disciplines_id] collate database_default and src.[skill_id] = trg.[skill_id] collate database_default and src.[skill_name] = trg.[skill_name] collate database_default
			where  src.[skill_disciplines_id] is null and src.[skill_id] is null and src.[skill_name] is null
				and trg.[ODSIsCurrent] = 1 
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'

			union all

			-- Previously soft deleted records that (still) dont exist in source
			select  src.[skill_disciplines_id] 
,src.[skill_id] 
,src.[skill_name] ,  'Non' as MergeType
			from [Staging].[IntelliHR_skill_disciplines] as src
				right outer join [Working].[IntelliHR_skill_disciplines] trg
					on src.[skill_disciplines_id] = trg.[skill_disciplines_id] collate database_default and src.[skill_id] = trg.[skill_id] collate database_default and src.[skill_name] = trg.[skill_name] collate database_default
			where  src.[skill_disciplines_id] is null and src.[skill_id] is null and src.[skill_name] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all


			-- Old versions of any row-versioned record
			select DISTINCT trg.[skill_disciplines_id] 
,trg.[skill_id] 
,trg.[skill_name] , 'Old' as MergeType
			from [Working].[IntelliHR_skill_disciplines] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0

		),

		cte_AllChanges as 
		(

			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[skill_disciplines_id] ,src.[name] ,src.[skill_id] ,src.[skill_name] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[IntelliHR_skill_disciplines] src
				inner join cte_SummaryOfChanges chg 
				   on src.[skill_disciplines_id] = chg.[skill_disciplines_id] collate database_default and src.[skill_id] = chg.[skill_id] collate database_default and src.[skill_name] = chg.[skill_name] collate database_default
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
			select  trg.[skill_disciplines_id] ,trg.[name] ,trg.[skill_id] ,trg.[skill_name] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Working].[IntelliHR_skill_disciplines] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[skill_disciplines_id] = chg.[skill_disciplines_id] collate database_default and trg.[skill_id] = chg.[skill_id] collate database_default and trg.[skill_name] = chg.[skill_name] collate database_default
			where chg.MergeType IN ('Del')
				and trg.[ODSIsCurrent] = 1

			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[skill_disciplines_id] ,src.[name] ,src.[skill_id] ,src.[skill_name] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[IntelliHR_skill_disciplines] src
				inner join cte_SummaryOfChanges chg 
					on src.[skill_disciplines_id] = chg.[skill_disciplines_id] collate database_default and src.[skill_id] = chg.[skill_id] collate database_default and src.[skill_name] = chg.[skill_name] collate database_default
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[skill_disciplines_id] ,trg.[name] ,trg.[skill_id] ,trg.[skill_name] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[IntelliHR_skill_disciplines] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[skill_disciplines_id] = chg.[skill_disciplines_id] collate database_default and trg.[skill_id] = chg.[skill_id] collate database_default and trg.[skill_name] = chg.[skill_name] collate database_default
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[skill_disciplines_id] ,trg.[name] ,trg.[skill_id] ,trg.[skill_name] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], null as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[IntelliHR_skill_disciplines] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[skill_disciplines_id] = chg.[skill_disciplines_id] collate database_default and trg.[skill_id] = chg.[skill_id] collate database_default and trg.[skill_name] = chg.[skill_name] collate database_default
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[skill_disciplines_id] ,src.[name] ,src.[skill_id] ,src.[skill_name] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) as ODSIsCurrent, 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)) as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src;

		set @insertedRecords = (select count(1) from [IntelliHR].[skill_disciplines] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [IntelliHR].[skill_disciplines] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [IntelliHR].[skill_disciplines] 
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