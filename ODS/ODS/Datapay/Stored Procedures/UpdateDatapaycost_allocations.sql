
CREATE procedure [Datapay].[UpdateDatapaycost_allocations] 
	
/**********************************************************************************************************
 Procedure	[Datapay].[UpdateDatapaycost_allocations] 
 Author		
 Created		
 Purpose	This procedure moves data from staging to main . 
 =========================================================================================================

REVISIONS:
Version	 Date			Author					Description
-------	------------	------------------		--------------------------
1.0		?				?						Initial creation of stored procedure
1.1		2023-08-26		Greg Nuthall			Grouped final selection to avoid duplicates
**********************************************************************************************************/	

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
	declare @SourceSystem nvarchar(120) = '[datapay].[cost_allocations]';
	
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
	select @stagedRecords = count(1) from [Staging].[Datapay_cost_allocations];

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
	set @targetRecords = (select count(1) from [Working].[Datapay_cost_allocations]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [Datapay].[cost_allocations]
			with (
				location = 'Datapay/cost_allocations/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[employee_code] ,src.[first_name] ,src.[last_name] ,src.[home_costing_percentage] ,src.[home_cost_box_division] ,src.[home_cost_box_division_code] ,src.[home_cost_box_cost_centre] ,src.[home_cost_box_cost_centre_code] ,src.[home_cost_box_department] ,src.[home_cost_box_department_code] ,src.[home_cost_box_sub_department] ,src.[home_cost_box_sub_department_code] ,src.[net_home_cost_box_division] ,src.[net_home_cost_box_division_code] ,src.[net_home_cost_box_cost_centre] ,src.[net_home_cost_box_cost_centre_code] ,src.[net_home_cost_box_department] ,src.[net_home_cost_box_department_code] ,src.[net_home_cost_box_sub_department] ,src.[net_home_cost_box_sub_department_code] , CAST(1 AS int) as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], CAST('I' AS varchar(1)) as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[Datapay_cost_allocations] src
		
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

		create external table [Datapay].[cost_allocations]
			with (
				location = 'Datapay/cost_allocations/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[employee_code] 
			,src.[net_home_cost_box_sub_department_code] , 'New' as MergeType
			from [Staging].[Datapay_cost_allocations] as src
				left outer join [Working].[Datapay_cost_allocations] trg
				on src.[employee_code] = trg.[employee_code] and src.[net_home_cost_box_sub_department_code] = trg.[net_home_cost_box_sub_department_code] collate database_default and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[employee_code] is null and trg.[net_home_cost_box_sub_department_code] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[employee_code] 
			,src.[net_home_cost_box_sub_department_code] ,  'NTD' as MergeType
			from [Staging].[Datapay_cost_allocations] as src
			inner join [Working].[Datapay_cost_allocations] trg
				on src.[employee_code] = trg.[employee_code] and src.[net_home_cost_box_sub_department_code] = trg.[net_home_cost_box_sub_department_code] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[employee_code] 
			,src.[net_home_cost_box_sub_department_code] , 'Chg' as MergeType
			from [Staging].[Datapay_cost_allocations] as src
				inner join [Working].[Datapay_cost_allocations] trg
				on src.[employee_code] = trg.[employee_code] and src.[net_home_cost_box_sub_department_code] = trg.[net_home_cost_box_sub_department_code] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[first_name], src.[last_name], src.[home_costing_percentage], src.[home_cost_box_division], src.[home_cost_box_division_code], src.[home_cost_box_cost_centre], src.[home_cost_box_cost_centre_code], src.[home_cost_box_department], src.[home_cost_box_department_code], src.[home_cost_box_sub_department], src.[home_cost_box_sub_department_code], src.[net_home_cost_box_division], src.[net_home_cost_box_division_code], src.[net_home_cost_box_cost_centre], src.[net_home_cost_box_cost_centre_code], src.[net_home_cost_box_department], src.[net_home_cost_box_department_code], src.[net_home_cost_box_sub_department]
					except
					select trg.[first_name], trg.[last_name], trg.[home_costing_percentage], trg.[home_cost_box_division], trg.[home_cost_box_division_code], trg.[home_cost_box_cost_centre], trg.[home_cost_box_cost_centre_code], trg.[home_cost_box_department], trg.[home_cost_box_department_code], trg.[home_cost_box_sub_department], trg.[home_cost_box_sub_department_code], trg.[net_home_cost_box_division], trg.[net_home_cost_box_division_code], trg.[net_home_cost_box_cost_centre], trg.[net_home_cost_box_cost_centre_code], trg.[net_home_cost_box_department], trg.[net_home_cost_box_department_code], trg.[net_home_cost_box_sub_department]
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[employee_code] 
			,src.[net_home_cost_box_sub_department_code] , 'Non' as MergeType
			from [Staging].[Datapay_cost_allocations] as src
				inner join [Working].[Datapay_cost_allocations] trg
				on src.[employee_code] = trg.[employee_code] and src.[net_home_cost_box_sub_department_code] = trg.[net_home_cost_box_sub_department_code] collate database_default
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[first_name], src.[last_name], src.[home_costing_percentage], src.[home_cost_box_division], src.[home_cost_box_division_code], src.[home_cost_box_cost_centre], src.[home_cost_box_cost_centre_code], src.[home_cost_box_department], src.[home_cost_box_department_code], src.[home_cost_box_sub_department], src.[home_cost_box_sub_department_code], src.[net_home_cost_box_division], src.[net_home_cost_box_division_code], src.[net_home_cost_box_cost_centre], src.[net_home_cost_box_cost_centre_code], src.[net_home_cost_box_department], src.[net_home_cost_box_department_code], src.[net_home_cost_box_sub_department]
					except
					select trg.[first_name], trg.[last_name], trg.[home_costing_percentage], trg.[home_cost_box_division], trg.[home_cost_box_division_code], trg.[home_cost_box_cost_centre], trg.[home_cost_box_cost_centre_code], trg.[home_cost_box_department], trg.[home_cost_box_department_code], trg.[home_cost_box_sub_department], trg.[home_cost_box_sub_department_code], trg.[net_home_cost_box_division], trg.[net_home_cost_box_division_code], trg.[net_home_cost_box_cost_centre], trg.[net_home_cost_box_cost_centre_code], trg.[net_home_cost_box_department], trg.[net_home_cost_box_department_code], trg.[net_home_cost_box_sub_department]
				)

			union all

			-- Record in Target, not Source - soft delete.  Ignore any existing soft deletes in target
			select  trg.[employee_code] 
			,trg.[net_home_cost_box_sub_department_code] , 'Del' as MergeType
			from [Staging].[Datapay_cost_allocations] as src
				right outer join [Working].[Datapay_cost_allocations] trg
				on src.[employee_code] = trg.[employee_code] and src.[net_home_cost_box_sub_department_code] = trg.[net_home_cost_box_sub_department_code] collate database_default
			where  src.[employee_code] is null and src.[net_home_cost_box_sub_department_code] is null
				and trg.[ODSIsCurrent] = 1 
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'

			union all

			-- Previously soft deleted records that (still) dont exist in source
			select  src.[employee_code] 
			,src.[net_home_cost_box_sub_department_code] ,  'Non' as MergeType
			from [Staging].[Datapay_cost_allocations] as src
				right outer join [Working].[Datapay_cost_allocations] trg
					on src.[employee_code] = trg.[employee_code] and src.[net_home_cost_box_sub_department_code] = trg.[net_home_cost_box_sub_department_code] collate database_default
			where  src.[employee_code] is null and src.[net_home_cost_box_sub_department_code] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all


			-- Old versions of any row-versioned record
			select DISTINCT trg.[employee_code] 
			,trg.[net_home_cost_box_sub_department_code] , 'Old' as MergeType
			from [Working].[Datapay_cost_allocations] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0

		),

		cte_AllChanges as 
		(

			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[employee_code] ,src.[first_name] ,src.[last_name] ,src.[home_costing_percentage] ,src.[home_cost_box_division] ,src.[home_cost_box_division_code] ,src.[home_cost_box_cost_centre] ,src.[home_cost_box_cost_centre_code] ,src.[home_cost_box_department] ,src.[home_cost_box_department_code] ,src.[home_cost_box_sub_department] ,src.[home_cost_box_sub_department_code] ,src.[net_home_cost_box_division] ,src.[net_home_cost_box_division_code] ,src.[net_home_cost_box_cost_centre] ,src.[net_home_cost_box_cost_centre_code] ,src.[net_home_cost_box_department] ,src.[net_home_cost_box_department_code] ,src.[net_home_cost_box_sub_department] ,src.[net_home_cost_box_sub_department_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[Datapay_cost_allocations] src
				inner join cte_SummaryOfChanges chg 
				   on src.[employee_code] = chg.[employee_code] and src.[net_home_cost_box_sub_department_code] = chg.[net_home_cost_box_sub_department_code] collate database_default
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
			select  trg.[employee_code] ,trg.[first_name] ,trg.[last_name] ,trg.[home_costing_percentage] ,trg.[home_cost_box_division] ,trg.[home_cost_box_division_code] ,trg.[home_cost_box_cost_centre] ,trg.[home_cost_box_cost_centre_code] ,trg.[home_cost_box_department] ,trg.[home_cost_box_department_code] ,trg.[home_cost_box_sub_department] ,trg.[home_cost_box_sub_department_code] ,trg.[net_home_cost_box_division] ,trg.[net_home_cost_box_division_code] ,trg.[net_home_cost_box_cost_centre] ,trg.[net_home_cost_box_cost_centre_code] ,trg.[net_home_cost_box_department] ,trg.[net_home_cost_box_department_code] ,trg.[net_home_cost_box_sub_department] ,trg.[net_home_cost_box_sub_department_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Working].[Datapay_cost_allocations] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[employee_code] = chg.[employee_code] and trg.[net_home_cost_box_sub_department_code] = chg.[net_home_cost_box_sub_department_code] collate database_default
			where chg.MergeType IN ('Del')
				and trg.[ODSIsCurrent] = 1

			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[employee_code] ,src.[first_name] ,src.[last_name] ,src.[home_costing_percentage] ,src.[home_cost_box_division] ,src.[home_cost_box_division_code] ,src.[home_cost_box_cost_centre] ,src.[home_cost_box_cost_centre_code] ,src.[home_cost_box_department] ,src.[home_cost_box_department_code] ,src.[home_cost_box_sub_department] ,src.[home_cost_box_sub_department_code] ,src.[net_home_cost_box_division] ,src.[net_home_cost_box_division_code] ,src.[net_home_cost_box_cost_centre] ,src.[net_home_cost_box_cost_centre_code] ,src.[net_home_cost_box_department] ,src.[net_home_cost_box_department_code] ,src.[net_home_cost_box_sub_department] ,src.[net_home_cost_box_sub_department_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[Datapay_cost_allocations] src
				inner join cte_SummaryOfChanges chg 
					on src.[employee_code] = chg.[employee_code] and src.[net_home_cost_box_sub_department_code] = chg.[net_home_cost_box_sub_department_code] collate database_default
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[employee_code] ,trg.[first_name] ,trg.[last_name] ,trg.[home_costing_percentage] ,trg.[home_cost_box_division] ,trg.[home_cost_box_division_code] ,trg.[home_cost_box_cost_centre] ,trg.[home_cost_box_cost_centre_code] ,trg.[home_cost_box_department] ,trg.[home_cost_box_department_code] ,trg.[home_cost_box_sub_department] ,trg.[home_cost_box_sub_department_code] ,trg.[net_home_cost_box_division] ,trg.[net_home_cost_box_division_code] ,trg.[net_home_cost_box_cost_centre] ,trg.[net_home_cost_box_cost_centre_code] ,trg.[net_home_cost_box_department] ,trg.[net_home_cost_box_department_code] ,trg.[net_home_cost_box_sub_department] ,trg.[net_home_cost_box_sub_department_code] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[Datapay_cost_allocations] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[employee_code] = chg.[employee_code] and trg.[net_home_cost_box_sub_department_code] = chg.[net_home_cost_box_sub_department_code] collate database_default
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[employee_code] ,trg.[first_name] ,trg.[last_name] ,trg.[home_costing_percentage] ,trg.[home_cost_box_division] ,trg.[home_cost_box_division_code] ,trg.[home_cost_box_cost_centre] ,trg.[home_cost_box_cost_centre_code] ,trg.[home_cost_box_department] ,trg.[home_cost_box_department_code] ,trg.[home_cost_box_sub_department] ,trg.[home_cost_box_sub_department_code] ,trg.[net_home_cost_box_division] ,trg.[net_home_cost_box_division_code] ,trg.[net_home_cost_box_cost_centre] ,trg.[net_home_cost_box_cost_centre_code] ,trg.[net_home_cost_box_department] ,trg.[net_home_cost_box_department_code] ,trg.[net_home_cost_box_sub_department] ,trg.[net_home_cost_box_sub_department_code] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[Datapay_cost_allocations] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[employee_code] = chg.[employee_code] and trg.[net_home_cost_box_sub_department_code] = chg.[net_home_cost_box_sub_department_code] collate database_default
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[employee_code] ,src.[first_name] ,src.[last_name] 
		--,src.[home_costing_percentage] 
		,max(src.[home_costing_percentage]) as [home_costing_percentage]
		,src.[home_cost_box_division] 
		,src.[home_cost_box_division_code] 
		,src.[home_cost_box_cost_centre] 
		,src.[home_cost_box_cost_centre_code] 
		,src.[home_cost_box_department] 
		,src.[home_cost_box_department_code] 
		,src.[home_cost_box_sub_department] 
		,src.[home_cost_box_sub_department_code] 
		,src.[net_home_cost_box_division] 
		,src.[net_home_cost_box_division_code] 
		,src.[net_home_cost_box_cost_centre] 
		,src.[net_home_cost_box_cost_centre_code] 
		,src.[net_home_cost_box_department] 
		,src.[net_home_cost_box_department_code] 
		,src.[net_home_cost_box_sub_department] 
		,src.[net_home_cost_box_sub_department_code] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) as ODSIsCurrent, 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)) as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src

		group by src.[employee_code] ,src.[first_name] ,src.[last_name] 
		,src.[home_cost_box_division] 
		,src.[home_cost_box_division_code] 
		,src.[home_cost_box_cost_centre] 
		,src.[home_cost_box_cost_centre_code] 
		,src.[home_cost_box_department] 
		,src.[home_cost_box_department_code] 
		,src.[home_cost_box_sub_department] 
		,src.[home_cost_box_sub_department_code] 
		,src.[net_home_cost_box_division] 
		,src.[net_home_cost_box_division_code] 
		,src.[net_home_cost_box_cost_centre] 
		,src.[net_home_cost_box_cost_centre_code] 
		,src.[net_home_cost_box_department] 
		,src.[net_home_cost_box_department_code] 
		,src.[net_home_cost_box_sub_department] 
		,src.[net_home_cost_box_sub_department_code] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) , 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) ,
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) , 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)), 
			isnull(ODSBatchId, @batchId) , 
			isnull(ODSSourceSystem, @SourceSystem) ;


		set @insertedRecords = (select count(1) from [Datapay].[cost_allocations] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [Datapay].[cost_allocations] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [Datapay].[cost_allocations] 
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