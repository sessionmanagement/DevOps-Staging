create procedure [TapuiWaka].[UpdateTapuiWakaasset_trip] 
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
	declare @SourceSystem nvarchar(120) = '[tapui_waka].[asset_trip]';
	
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
	select @stagedRecords = count(1) from [Staging].[TapuiWaka_asset_trip];

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
	set @targetRecords = (select count(1) from [Working].[TapuiWaka_asset_trip]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [TapuiWaka].[asset_trip]
			with (
				location = 'TapuiWaka/asset_trip/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[asset_trip_id] ,src.[asset_id] ,src.[is_processed] ,src.[version] ,src.[start_timestamp] ,src.[start_point_latitude] ,src.[start_point_longitude] ,src.[start_address] ,src.[end_timestamp] ,src.[end_point_latitude] ,src.[end_point_longitude] ,src.[end_address] ,src.[is_towed] ,src.[operator_id] ,src.[operator] ,src.[distance_meters] ,src.[distance_meters_offroad] ,src.[average_speed] ,src.[max_speed] ,src.[num_polls] ,src.[on_road_within_speed_limit] ,src.[on_road_over_speed_limit_band1] ,src.[on_road_over_speed_limit_band2] ,src.[on_road_over_speed_limit_band3] ,src.[on_road_over_speed_limit_band4] ,src.[on_road_over_speed_limit_band5] ,src.[offroad_within_speed_limit] ,src.[offroad_over_speed_limit_band1] ,src.[offroad_over_speed_limit_band2] ,src.[offroad_over_speed_limit_band3] ,src.[offroad_over_speed_limit_band4] ,src.[offroad_over_speed_limit_band5] ,src.[has_note] , CAST(1 AS int) as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], CAST('I' AS varchar(1)) as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[TapuiWaka_asset_trip] src
		
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

		create external table [TapuiWaka].[asset_trip]
			with (
				location = 'TapuiWaka/asset_trip/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[asset_trip_id] ,src.[asset_id] , 'New' as MergeType
			from [Staging].[TapuiWaka_asset_trip] as src
				left outer join [Working].[TapuiWaka_asset_trip] trg
				on src.[asset_trip_id] = trg.[asset_trip_id] and src.[asset_id] = trg.[asset_id] and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[asset_trip_id] is null and trg.[asset_id] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[asset_trip_id] ,src.[asset_id] ,  'NTD' as MergeType
			from [Staging].[TapuiWaka_asset_trip] as src
			inner join [Working].[TapuiWaka_asset_trip] trg
				on src.[asset_trip_id] = trg.[asset_trip_id] and src.[asset_id] = trg.[asset_id]
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[asset_trip_id] ,src.[asset_id] , 'Chg' as MergeType
			from [Staging].[TapuiWaka_asset_trip] as src
				inner join [Working].[TapuiWaka_asset_trip] trg
				on src.[asset_trip_id] = trg.[asset_trip_id] and src.[asset_id] = trg.[asset_id]
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[is_processed], src.[version], src.[start_timestamp], src.[start_point_latitude], src.[start_point_longitude], src.[start_address], src.[end_timestamp], src.[end_point_latitude], src.[end_point_longitude], src.[end_address], src.[is_towed], src.[operator_id], src.[operator], src.[distance_meters], src.[distance_meters_offroad], src.[average_speed], src.[max_speed], src.[num_polls], src.[on_road_within_speed_limit], src.[on_road_over_speed_limit_band1], src.[on_road_over_speed_limit_band2], src.[on_road_over_speed_limit_band3], src.[on_road_over_speed_limit_band4], src.[on_road_over_speed_limit_band5], src.[offroad_within_speed_limit], src.[offroad_over_speed_limit_band1], src.[offroad_over_speed_limit_band2], src.[offroad_over_speed_limit_band3], src.[offroad_over_speed_limit_band4], src.[offroad_over_speed_limit_band5], src.[has_note]
					except
					select trg.[is_processed], trg.[version], trg.[start_timestamp], trg.[start_point_latitude], trg.[start_point_longitude], trg.[start_address], trg.[end_timestamp], trg.[end_point_latitude], trg.[end_point_longitude], trg.[end_address], trg.[is_towed], trg.[operator_id], trg.[operator], trg.[distance_meters], trg.[distance_meters_offroad], trg.[average_speed], trg.[max_speed], trg.[num_polls], trg.[on_road_within_speed_limit], trg.[on_road_over_speed_limit_band1], trg.[on_road_over_speed_limit_band2], trg.[on_road_over_speed_limit_band3], trg.[on_road_over_speed_limit_band4], trg.[on_road_over_speed_limit_band5], trg.[offroad_within_speed_limit], trg.[offroad_over_speed_limit_band1], trg.[offroad_over_speed_limit_band2], trg.[offroad_over_speed_limit_band3], trg.[offroad_over_speed_limit_band4], trg.[offroad_over_speed_limit_band5], trg.[has_note]
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[asset_trip_id] ,src.[asset_id] , 'Non' as MergeType
			from [Staging].[TapuiWaka_asset_trip] as src
				inner join [Working].[TapuiWaka_asset_trip] trg
				on src.[asset_trip_id] = trg.[asset_trip_id] and src.[asset_id] = trg.[asset_id]
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[is_processed], src.[version], src.[start_timestamp], src.[start_point_latitude], src.[start_point_longitude], src.[start_address], src.[end_timestamp], src.[end_point_latitude], src.[end_point_longitude], src.[end_address], src.[is_towed], src.[operator_id], src.[operator], src.[distance_meters], src.[distance_meters_offroad], src.[average_speed], src.[max_speed], src.[num_polls], src.[on_road_within_speed_limit], src.[on_road_over_speed_limit_band1], src.[on_road_over_speed_limit_band2], src.[on_road_over_speed_limit_band3], src.[on_road_over_speed_limit_band4], src.[on_road_over_speed_limit_band5], src.[offroad_within_speed_limit], src.[offroad_over_speed_limit_band1], src.[offroad_over_speed_limit_band2], src.[offroad_over_speed_limit_band3], src.[offroad_over_speed_limit_band4], src.[offroad_over_speed_limit_band5], src.[has_note]
					except
					select trg.[is_processed], trg.[version], trg.[start_timestamp], trg.[start_point_latitude], trg.[start_point_longitude], trg.[start_address], trg.[end_timestamp], trg.[end_point_latitude], trg.[end_point_longitude], trg.[end_address], trg.[is_towed], trg.[operator_id], trg.[operator], trg.[distance_meters], trg.[distance_meters_offroad], trg.[average_speed], trg.[max_speed], trg.[num_polls], trg.[on_road_within_speed_limit], trg.[on_road_over_speed_limit_band1], trg.[on_road_over_speed_limit_band2], trg.[on_road_over_speed_limit_band3], trg.[on_road_over_speed_limit_band4], trg.[on_road_over_speed_limit_band5], trg.[offroad_within_speed_limit], trg.[offroad_over_speed_limit_band1], trg.[offroad_over_speed_limit_band2], trg.[offroad_over_speed_limit_band3], trg.[offroad_over_speed_limit_band4], trg.[offroad_over_speed_limit_band5], trg.[has_note]
				)

			union all

			-- Current Record in Target, but not in Source
			-- NOTE - currently no handling of soft deletes for incremental, this is only
			-- copying across unchanged records
			select  trg.[asset_trip_id] ,trg.[asset_id] , 'Non' as MergeType
			from [Staging].[TapuiWaka_asset_trip] as src
				right outer join [Working].[TapuiWaka_asset_trip] trg
				on src.[asset_trip_id] = trg.[asset_trip_id] and src.[asset_id] = trg.[asset_id]
			where  src.[asset_trip_id] is null and src.[asset_id] is null and trg.[ODSIsCurrent] = 1

			union all

			-- Old versions of any row-versioned record
			select  DISTINCT  trg.[asset_trip_id] ,trg.[asset_id] , 'Old' as MergeType
			from [Working].[TapuiWaka_asset_trip] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0														

		),

		cte_AllChanges as 
		(
		
			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[asset_trip_id] ,src.[asset_id] ,src.[is_processed] ,src.[version] ,src.[start_timestamp] ,src.[start_point_latitude] ,src.[start_point_longitude] ,src.[start_address] ,src.[end_timestamp] ,src.[end_point_latitude] ,src.[end_point_longitude] ,src.[end_address] ,src.[is_towed] ,src.[operator_id] ,src.[operator] ,src.[distance_meters] ,src.[distance_meters_offroad] ,src.[average_speed] ,src.[max_speed] ,src.[num_polls] ,src.[on_road_within_speed_limit] ,src.[on_road_over_speed_limit_band1] ,src.[on_road_over_speed_limit_band2] ,src.[on_road_over_speed_limit_band3] ,src.[on_road_over_speed_limit_band4] ,src.[on_road_over_speed_limit_band5] ,src.[offroad_within_speed_limit] ,src.[offroad_over_speed_limit_band1] ,src.[offroad_over_speed_limit_band2] ,src.[offroad_over_speed_limit_band3] ,src.[offroad_over_speed_limit_band4] ,src.[offroad_over_speed_limit_band5] ,src.[has_note] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[TapuiWaka_asset_trip] src
				inner join cte_SummaryOfChanges chg 
				   on src.[asset_trip_id] = chg.[asset_trip_id] and src.[asset_id] = chg.[asset_id]
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
--			select  trg.[asset_trip_id] ,trg.[asset_id] ,trg.[is_processed] ,trg.[version] ,trg.[start_timestamp] ,trg.[start_point_latitude] ,trg.[start_point_longitude] ,trg.[start_address] ,trg.[end_timestamp] ,trg.[end_point_latitude] ,trg.[end_point_longitude] ,trg.[end_address] ,trg.[is_towed] ,trg.[operator_id] ,trg.[operator] ,trg.[distance_meters] ,trg.[distance_meters_offroad] ,trg.[average_speed] ,trg.[max_speed] ,trg.[num_polls] ,trg.[on_road_within_speed_limit] ,trg.[on_road_over_speed_limit_band1] ,trg.[on_road_over_speed_limit_band2] ,trg.[on_road_over_speed_limit_band3] ,trg.[on_road_over_speed_limit_band4] ,trg.[on_road_over_speed_limit_band5] ,trg.[offroad_within_speed_limit] ,trg.[offroad_over_speed_limit_band1] ,trg.[offroad_over_speed_limit_band2] ,trg.[offroad_over_speed_limit_band3] ,trg.[offroad_over_speed_limit_band4] ,trg.[offroad_over_speed_limit_band5] ,trg.[has_note] 
--					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
--			from [Working].[TapuiWaka_asset_trip] trg
--				inner join cte_SummaryOfChanges chg 
--					on trg.[asset_trip_id] = chg.[asset_trip_id] and trg.[asset_id] = chg.[asset_id]
--			where chg.MergeType IN ('Del')
--				and trg.[ODSIsCurrent] = 1
--
--			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[asset_trip_id] ,src.[asset_id] ,src.[is_processed] ,src.[version] ,src.[start_timestamp] ,src.[start_point_latitude] ,src.[start_point_longitude] ,src.[start_address] ,src.[end_timestamp] ,src.[end_point_latitude] ,src.[end_point_longitude] ,src.[end_address] ,src.[is_towed] ,src.[operator_id] ,src.[operator] ,src.[distance_meters] ,src.[distance_meters_offroad] ,src.[average_speed] ,src.[max_speed] ,src.[num_polls] ,src.[on_road_within_speed_limit] ,src.[on_road_over_speed_limit_band1] ,src.[on_road_over_speed_limit_band2] ,src.[on_road_over_speed_limit_band3] ,src.[on_road_over_speed_limit_band4] ,src.[on_road_over_speed_limit_band5] ,src.[offroad_within_speed_limit] ,src.[offroad_over_speed_limit_band1] ,src.[offroad_over_speed_limit_band2] ,src.[offroad_over_speed_limit_band3] ,src.[offroad_over_speed_limit_band4] ,src.[offroad_over_speed_limit_band5] ,src.[has_note] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[TapuiWaka_asset_trip] src
									  
				inner join cte_SummaryOfChanges chg 
					on src.[asset_trip_id] = chg.[asset_trip_id] and src.[asset_id] = chg.[asset_id]
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[asset_trip_id] ,trg.[asset_id] ,trg.[is_processed] ,trg.[version] ,trg.[start_timestamp] ,trg.[start_point_latitude] ,trg.[start_point_longitude] ,trg.[start_address] ,trg.[end_timestamp] ,trg.[end_point_latitude] ,trg.[end_point_longitude] ,trg.[end_address] ,trg.[is_towed] ,trg.[operator_id] ,trg.[operator] ,trg.[distance_meters] ,trg.[distance_meters_offroad] ,trg.[average_speed] ,trg.[max_speed] ,trg.[num_polls] ,trg.[on_road_within_speed_limit] ,trg.[on_road_over_speed_limit_band1] ,trg.[on_road_over_speed_limit_band2] ,trg.[on_road_over_speed_limit_band3] ,trg.[on_road_over_speed_limit_band4] ,trg.[on_road_over_speed_limit_band5] ,trg.[offroad_within_speed_limit] ,trg.[offroad_over_speed_limit_band1] ,trg.[offroad_over_speed_limit_band2] ,trg.[offroad_over_speed_limit_band3] ,trg.[offroad_over_speed_limit_band4] ,trg.[offroad_over_speed_limit_band5] ,trg.[has_note] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[TapuiWaka_asset_trip] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[asset_trip_id] = chg.[asset_trip_id] and trg.[asset_id] = chg.[asset_id]
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[asset_trip_id] ,trg.[asset_id] ,trg.[is_processed] ,trg.[version] ,trg.[start_timestamp] ,trg.[start_point_latitude] ,trg.[start_point_longitude] ,trg.[start_address] ,trg.[end_timestamp] ,trg.[end_point_latitude] ,trg.[end_point_longitude] ,trg.[end_address] ,trg.[is_towed] ,trg.[operator_id] ,trg.[operator] ,trg.[distance_meters] ,trg.[distance_meters_offroad] ,trg.[average_speed] ,trg.[max_speed] ,trg.[num_polls] ,trg.[on_road_within_speed_limit] ,trg.[on_road_over_speed_limit_band1] ,trg.[on_road_over_speed_limit_band2] ,trg.[on_road_over_speed_limit_band3] ,trg.[on_road_over_speed_limit_band4] ,trg.[on_road_over_speed_limit_band5] ,trg.[offroad_within_speed_limit] ,trg.[offroad_over_speed_limit_band1] ,trg.[offroad_over_speed_limit_band2] ,trg.[offroad_over_speed_limit_band3] ,trg.[offroad_over_speed_limit_band4] ,trg.[offroad_over_speed_limit_band5] ,trg.[has_note] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], null as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[TapuiWaka_asset_trip] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[asset_trip_id] = chg.[asset_trip_id] and trg.[asset_id] = chg.[asset_id]
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[asset_trip_id] ,src.[asset_id] ,src.[is_processed] ,src.[version] ,src.[start_timestamp] ,src.[start_point_latitude] ,src.[start_point_longitude] ,src.[start_address] ,src.[end_timestamp] ,src.[end_point_latitude] ,src.[end_point_longitude] ,src.[end_address] ,src.[is_towed] ,src.[operator_id] ,src.[operator] ,src.[distance_meters] ,src.[distance_meters_offroad] ,src.[average_speed] ,src.[max_speed] ,src.[num_polls] ,src.[on_road_within_speed_limit] ,src.[on_road_over_speed_limit_band1] ,src.[on_road_over_speed_limit_band2] ,src.[on_road_over_speed_limit_band3] ,src.[on_road_over_speed_limit_band4] ,src.[on_road_over_speed_limit_band5] ,src.[offroad_within_speed_limit] ,src.[offroad_over_speed_limit_band1] ,src.[offroad_over_speed_limit_band2] ,src.[offroad_over_speed_limit_band3] ,src.[offroad_over_speed_limit_band4] ,src.[offroad_over_speed_limit_band5] ,src.[has_note] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) as ODSIsCurrent, 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)) as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src;

		set @insertedRecords = (select count(1) from [TapuiWaka].[asset_trip] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [TapuiWaka].[asset_trip] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [TapuiWaka].[asset_trip] 
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