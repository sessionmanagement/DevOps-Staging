
CREATE   procedure [TapuiWaka].[UpdateTapuiWakaasset] 
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
	declare @SourceSystem nvarchar(120) = '[tapui_waka].[asset]';
	
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
	select @stagedRecords = count(1) from [Staging].[TapuiWaka_asset];

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
	set @targetRecords = (select count(1) from [Working].[TapuiWaka_asset]);

	-- On first pass / initial load only insert from landing, as existing data folders (main/working) will be empty
	if ( (@pMode = 'initial') or (@targetRecords = 0) )
	begin

		create external table [TapuiWaka].[asset]
			with (
				location = 'TapuiWaka/asset/main' ,
				data_source = [data],
				file_format = [parquet]
			) as 		
		select  src.[asset_id] ,src.[simple_id] ,src.[asset_entity_id] ,src.[qr_code] ,src.[on_road_speed_limit_override] ,src.[off_road_speed_limit] ,src.[snap_to_road] ,src.[start_date] ,src.[name] ,src.[description] ,src.[device_id] ,src.[device_label] ,src.[device_model_type] ,src.[device_model_type_id] ,src.[device_supports_trips] ,src.[default_operator_contact_id] ,src.[service_schedule_id] ,src.[time_usage_id] ,src.[service_contact_id] ,src.[is_owner] ,src.[is_update_allowed] ,src.[is_action_allowed] ,src.[is_history_allowed] ,src.[is_demo] ,src.[asset_nzta_subject_to_ruc] ,src.[asset_nzta_subject_to_ruc_hubo] ,src.[asset_nzta_wof_expiry_date] ,src.[asset_nzta_wof_type] ,src.[asset_nzta_license_expiry_date] ,src.[asset_nzta_fuel_type] ,src.[asset_nzta_ruc_expiry] ,src.[asset_nzta_ruc_expiry_date] ,src.[is_deleted] ,src.[last_changed] ,src.[type] ,src.[identifier] ,src.[serial_number] ,src.[class_id] ,src.[class] ,src.[make_id] ,src.[make] ,src.[model] ,src.[year] ,src.[primary_color] ,src.[asset_service_code] , CAST(1 AS int) as [ODSIsCurrent], @SystemEffectiveFrom as [ODSEffectiveFrom], @SystemDefaultEffectiveTo as [ODSEffectiveTo], CAST('I' AS varchar(1)) as [ODSDMLOperation], @batchID as [ODSBatchId], @SourceSystem as [ODSSourceSystem]
			from [Staging].[TapuiWaka_asset] src
		
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

		create external table [TapuiWaka].[asset]
			with (
				location = 'TapuiWaka/asset/main' ,
				data_source = [data],
				file_format = [parquet]
			)

		as 

		with cte_SummaryOfChanges as 
		(

			-- New in source, no record in target
			select  src.[asset_id] , 'New' as MergeType
			from [Staging].[TapuiWaka_asset] as src
				left outer join [Working].[TapuiWaka_asset] trg
				on src.[asset_id] = trg.[asset_id] and isnull(trg.[ODSIsCurrent], 0) = 1
			where  trg.[asset_id] is null

			union all

			-- Match, but current record in target is marked as soft delete
			select  src.[asset_id] ,  'NTD' as MergeType
			from [Staging].[TapuiWaka_asset] as src
			inner join [Working].[TapuiWaka_asset] trg
				on src.[asset_id] = trg.[asset_id]
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all

			-- Match, source data different from target data (following anything other than soft delete)
			select  src.[asset_id] , 'Chg' as MergeType
			from [Staging].[TapuiWaka_asset] as src
				inner join [Working].[TapuiWaka_asset] trg
				on src.[asset_id] = trg.[asset_id]
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and exists
				( 
					select src.[simple_id], src.[asset_entity_id], src.[qr_code], src.[on_road_speed_limit_override], src.[off_road_speed_limit], src.[snap_to_road], src.[start_date], src.[name], src.[description], src.[device_id], src.[device_label], src.[device_model_type], src.[device_model_type_id], src.[device_supports_trips], src.[default_operator_contact_id], src.[service_schedule_id], src.[time_usage_id], src.[service_contact_id], src.[is_owner], src.[is_update_allowed], src.[is_action_allowed], src.[is_history_allowed], src.[is_demo], src.[asset_nzta_subject_to_ruc], src.[asset_nzta_subject_to_ruc_hubo], src.[asset_nzta_wof_expiry_date], src.[asset_nzta_wof_type], src.[asset_nzta_license_expiry_date], src.[asset_nzta_fuel_type], src.[asset_nzta_ruc_expiry], src.[asset_nzta_ruc_expiry_date], src.[is_deleted], src.[type], src.[identifier], src.[serial_number], src.[class_id], src.[class], src.[make_id], src.[make], src.[model], src.[year], src.[primary_color] ,src.[asset_service_code], src.[asset_service_code] -- src.[last_changed],
					except
					select trg.[simple_id], trg.[asset_entity_id], trg.[qr_code], trg.[on_road_speed_limit_override], trg.[off_road_speed_limit], trg.[snap_to_road], trg.[start_date], trg.[name], trg.[description], trg.[device_id], trg.[device_label], trg.[device_model_type], trg.[device_model_type_id], trg.[device_supports_trips], trg.[default_operator_contact_id], trg.[service_schedule_id], trg.[time_usage_id], trg.[service_contact_id], trg.[is_owner], trg.[is_update_allowed], trg.[is_action_allowed], trg.[is_history_allowed], trg.[is_demo], trg.[asset_nzta_subject_to_ruc], trg.[asset_nzta_subject_to_ruc_hubo], trg.[asset_nzta_wof_expiry_date], trg.[asset_nzta_wof_type], trg.[asset_nzta_license_expiry_date], trg.[asset_nzta_fuel_type], trg.[asset_nzta_ruc_expiry], trg.[asset_nzta_ruc_expiry_date], trg.[is_deleted], trg.[type], trg.[identifier], trg.[serial_number], trg.[class_id], trg.[class], trg.[make_id], trg.[make], trg.[model], trg.[year], trg.[primary_color] ,trg.[asset_service_code], trg.[asset_service_code] -- trg.[last_changed],
				)

			union all
 
			-- Match, source data identical to target (following anything other than soft delete)
			select  src.[asset_id] , 'Non' as MergeType
			from [Staging].[TapuiWaka_asset] as src
				inner join [Working].[TapuiWaka_asset] trg
				on src.[asset_id] = trg.[asset_id]
			where   isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'
				and not exists
				( 
					select src.[simple_id], src.[asset_entity_id], src.[qr_code], src.[on_road_speed_limit_override], src.[off_road_speed_limit], src.[snap_to_road], src.[start_date], src.[name], src.[description], src.[device_id], src.[device_label], src.[device_model_type], src.[device_model_type_id], src.[device_supports_trips], src.[default_operator_contact_id], src.[service_schedule_id], src.[time_usage_id], src.[service_contact_id], src.[is_owner], src.[is_update_allowed], src.[is_action_allowed], src.[is_history_allowed], src.[is_demo], src.[asset_nzta_subject_to_ruc], src.[asset_nzta_subject_to_ruc_hubo], src.[asset_nzta_wof_expiry_date], src.[asset_nzta_wof_type], src.[asset_nzta_license_expiry_date], src.[asset_nzta_fuel_type], src.[asset_nzta_ruc_expiry], src.[asset_nzta_ruc_expiry_date], src.[is_deleted],  src.[type], src.[identifier], src.[serial_number], src.[class_id], src.[class], src.[make_id], src.[make], src.[model], src.[year], src.[primary_color] ,src.[asset_service_code], src.[asset_service_code] -- src.[last_changed],
					except
					select trg.[simple_id], trg.[asset_entity_id], trg.[qr_code], trg.[on_road_speed_limit_override], trg.[off_road_speed_limit], trg.[snap_to_road], trg.[start_date], trg.[name], trg.[description], trg.[device_id], trg.[device_label], trg.[device_model_type], trg.[device_model_type_id], trg.[device_supports_trips], trg.[default_operator_contact_id], trg.[service_schedule_id], trg.[time_usage_id], trg.[service_contact_id], trg.[is_owner], trg.[is_update_allowed], trg.[is_action_allowed], trg.[is_history_allowed], trg.[is_demo], trg.[asset_nzta_subject_to_ruc], trg.[asset_nzta_subject_to_ruc_hubo], trg.[asset_nzta_wof_expiry_date], trg.[asset_nzta_wof_type], trg.[asset_nzta_license_expiry_date], trg.[asset_nzta_fuel_type], trg.[asset_nzta_ruc_expiry], trg.[asset_nzta_ruc_expiry_date], trg.[is_deleted],  trg.[type], trg.[identifier], trg.[serial_number], trg.[class_id], trg.[class], trg.[make_id], trg.[make], trg.[model], trg.[year], trg.[primary_color] ,trg.[asset_service_code], trg.[asset_service_code] -- trg.[last_changed],
				)

			union all

			-- Record in Target, not Source - soft delete.  Ignore any existing soft deletes in target
			select  trg.[asset_id] , 'Del' as MergeType
			from [Staging].[TapuiWaka_asset] as src
				right outer join [Working].[TapuiWaka_asset] trg
				on src.[asset_id] = trg.[asset_id]
			where  src.[asset_id] is null
				and trg.[ODSIsCurrent] = 1 
				and isnull(trg.[ODSDMLOperation], 'X') != 'D'

			union all

			-- Previously soft deleted records that (still) dont exist in source
			select  trg.[asset_id] ,  'Non' as MergeType
			from [Staging].[TapuiWaka_asset] as src
				right outer join [Working].[TapuiWaka_asset] trg
					on src.[asset_id] = trg.[asset_id]
			where  src.[asset_id] is null    
				and isnull(trg.[ODSIsCurrent], 1) = 1
				and isnull(trg.[ODSDMLOperation], 'X') = 'D'

			union all


			-- Old versions of any row-versioned record
			select DISTINCT trg.[asset_id] , 'Old' as MergeType
			from [Working].[TapuiWaka_asset] trg
			where isnull(trg.[ODSIsCurrent], 0) = 0

		),

		cte_AllChanges as 
		(

			/* "INSERTS" - add new versions of records */

			-- New in source, either brand new or new following previous soft delete
			select  src.[asset_id] ,src.[simple_id] ,src.[asset_entity_id] ,src.[qr_code] ,src.[on_road_speed_limit_override] ,src.[off_road_speed_limit] ,src.[snap_to_road] ,src.[start_date] ,src.[name] ,src.[description] ,src.[device_id] ,src.[device_label] ,src.[device_model_type] ,src.[device_model_type_id] ,src.[device_supports_trips] ,src.[default_operator_contact_id] ,src.[service_schedule_id] ,src.[time_usage_id] ,src.[service_contact_id] ,src.[is_owner] ,src.[is_update_allowed] ,src.[is_action_allowed] ,src.[is_history_allowed] ,src.[is_demo] ,src.[asset_nzta_subject_to_ruc] ,src.[asset_nzta_subject_to_ruc_hubo] ,src.[asset_nzta_wof_expiry_date] ,src.[asset_nzta_wof_type] ,src.[asset_nzta_license_expiry_date] ,src.[asset_nzta_fuel_type] ,src.[asset_nzta_ruc_expiry] ,src.[asset_nzta_ruc_expiry_date] ,src.[is_deleted] ,src.[last_changed] ,src.[type] ,src.[identifier] ,src.[serial_number] ,src.[class_id] ,src.[class] ,src.[make_id] ,src.[make] ,src.[model] ,src.[year] ,src.[primary_color] ,src.[asset_service_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'I' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[TapuiWaka_asset] src
				inner join cte_SummaryOfChanges chg 
				   on src.[asset_id] = chg.[asset_id]
			where chg.MergeType IN ('New', 'NTD')
  
			union all

			-- "Soft delete" row version - i.e. record missing in source that was previously in target
			select  trg.[asset_id] ,trg.[simple_id] ,trg.[asset_entity_id] ,trg.[qr_code] ,trg.[on_road_speed_limit_override] ,trg.[off_road_speed_limit] ,trg.[snap_to_road] ,trg.[start_date] ,trg.[name] ,trg.[description] ,trg.[device_id] ,trg.[device_label] ,trg.[device_model_type] ,trg.[device_model_type_id] ,trg.[device_supports_trips] ,trg.[default_operator_contact_id] ,trg.[service_schedule_id] ,trg.[time_usage_id] ,trg.[service_contact_id] ,trg.[is_owner] ,trg.[is_update_allowed] ,trg.[is_action_allowed] ,trg.[is_history_allowed] ,trg.[is_demo] ,trg.[asset_nzta_subject_to_ruc] ,trg.[asset_nzta_subject_to_ruc_hubo] ,trg.[asset_nzta_wof_expiry_date] ,trg.[asset_nzta_wof_type] ,trg.[asset_nzta_license_expiry_date] ,trg.[asset_nzta_fuel_type] ,trg.[asset_nzta_ruc_expiry] ,trg.[asset_nzta_ruc_expiry_date] ,trg.[is_deleted] ,trg.[last_changed] ,trg.[type] ,trg.[identifier] ,trg.[serial_number] ,trg.[class_id] ,trg.[class] ,trg.[make_id] ,trg.[make] ,trg.[model] ,trg.[year] ,trg.[primary_color] ,trg.[asset_service_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'D' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Working].[TapuiWaka_asset] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[asset_id] = chg.[asset_id]
			where chg.MergeType IN ('Del')
				and trg.[ODSIsCurrent] = 1

			union all

			-- Match, source data different from target data - i.e. basic new version of record
			select  src.[asset_id] ,src.[simple_id] ,src.[asset_entity_id] ,src.[qr_code] ,src.[on_road_speed_limit_override] ,src.[off_road_speed_limit] ,src.[snap_to_road] ,src.[start_date] ,src.[name] ,src.[description] ,src.[device_id] ,src.[device_label] ,src.[device_model_type] ,src.[device_model_type_id] ,src.[device_supports_trips] ,src.[default_operator_contact_id] ,src.[service_schedule_id] ,src.[time_usage_id] ,src.[service_contact_id] ,src.[is_owner] ,src.[is_update_allowed] ,src.[is_action_allowed] ,src.[is_history_allowed] ,src.[is_demo] ,src.[asset_nzta_subject_to_ruc] ,src.[asset_nzta_subject_to_ruc_hubo] ,src.[asset_nzta_wof_expiry_date] ,src.[asset_nzta_wof_type] ,src.[asset_nzta_license_expiry_date] ,src.[asset_nzta_fuel_type] ,src.[asset_nzta_ruc_expiry] ,src.[asset_nzta_ruc_expiry_date] ,src.[is_deleted] ,src.[last_changed] ,src.[type] ,src.[identifier] ,src.[serial_number] ,src.[class_id] ,src.[class] ,src.[make_id] ,src.[make] ,src.[model] ,src.[year] ,src.[primary_color] ,src.[asset_service_code] 
					, 1 as [ODSIsCurrent], null as [ODSEffectiveFrom], null as [ODSEffectiveTo], 'U' as [ODSDMLOperation], null as [ODSBatchId], null as [ODSSourceSystem]
			from [Staging].[TapuiWaka_asset] src
				inner join cte_SummaryOfChanges chg 
					on src.[asset_id] = chg.[asset_id]
			where chg.MergeType = 'Chg'

			union all

			/* "UPDATES" - expire old versions of records that have been newly updated or deleted.  Set system flags accordingly. */

			-- Expire old versions of records that have had new version added
			select  trg.[asset_id] ,trg.[simple_id] ,trg.[asset_entity_id] ,trg.[qr_code] ,trg.[on_road_speed_limit_override] ,trg.[off_road_speed_limit] ,trg.[snap_to_road] ,trg.[start_date] ,trg.[name] ,trg.[description] ,trg.[device_id] ,trg.[device_label] ,trg.[device_model_type] ,trg.[device_model_type_id] ,trg.[device_supports_trips] ,trg.[default_operator_contact_id] ,trg.[service_schedule_id] ,trg.[time_usage_id] ,trg.[service_contact_id] ,trg.[is_owner] ,trg.[is_update_allowed] ,trg.[is_action_allowed] ,trg.[is_history_allowed] ,trg.[is_demo] ,trg.[asset_nzta_subject_to_ruc] ,trg.[asset_nzta_subject_to_ruc_hubo] ,trg.[asset_nzta_wof_expiry_date] ,trg.[asset_nzta_wof_type] ,trg.[asset_nzta_license_expiry_date] ,trg.[asset_nzta_fuel_type] ,trg.[asset_nzta_ruc_expiry] ,trg.[asset_nzta_ruc_expiry_date] ,trg.[is_deleted] ,trg.[last_changed] ,trg.[type] ,trg.[identifier] ,trg.[serial_number] ,trg.[class_id] ,trg.[class] ,trg.[make_id] ,trg.[make] ,trg.[model] ,trg.[year] ,trg.[primary_color] ,trg.[asset_service_code] 
					, 0 as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], null as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[TapuiWaka_asset] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[asset_id] = chg.[asset_id]
			where chg.MergeType IN ('Chg', 'Del', 'NTD')
				and trg.[ODSIsCurrent] = 1

			union all

			/*  "UNCHANGED" - copy across all records that have not otherwise been changed */

			-- Match, source data different from target data, or soft delete - expire old versions of records
			select  trg.[asset_id] ,trg.[simple_id] ,trg.[asset_entity_id] ,trg.[qr_code] ,trg.[on_road_speed_limit_override] ,trg.[off_road_speed_limit] ,trg.[snap_to_road] ,trg.[start_date] ,trg.[name] ,trg.[description] ,trg.[device_id] ,trg.[device_label] ,trg.[device_model_type] ,trg.[device_model_type_id] ,trg.[device_supports_trips] ,trg.[default_operator_contact_id] ,trg.[service_schedule_id] ,trg.[time_usage_id] ,trg.[service_contact_id] ,trg.[is_owner] ,trg.[is_update_allowed] ,trg.[is_action_allowed] ,trg.[is_history_allowed] ,trg.[is_demo] ,trg.[asset_nzta_subject_to_ruc] ,trg.[asset_nzta_subject_to_ruc_hubo] ,trg.[asset_nzta_wof_expiry_date] ,trg.[asset_nzta_wof_type] ,trg.[asset_nzta_license_expiry_date] ,trg.[asset_nzta_fuel_type] ,trg.[asset_nzta_ruc_expiry] ,trg.[asset_nzta_ruc_expiry_date] ,trg.[is_deleted] ,trg.[last_changed] ,trg.[type] ,trg.[identifier] ,trg.[serial_number] ,trg.[class_id] ,trg.[class] ,trg.[make_id] ,trg.[make] ,trg.[model] ,trg.[year] ,trg.[primary_color] ,trg.[asset_service_code] 
					, trg.[ODSIsCurrent] as [ODSIsCurrent], trg.[ODSEffectiveFrom] as [ODSEffectiveFrom], trg.[ODSEffectiveTo] as [ODSEffectiveTo], trg.[ODSDMLOperation] as [ODSDMLOperation], trg.[ODSBatchId] as [ODSBatchId], trg.[ODSSourceSystem] as [ODSSourceSystem]
			from [Working].[TapuiWaka_asset] trg
				inner join cte_SummaryOfChanges chg 
					on trg.[asset_id] = chg.[asset_id]
			where (chg.MergeType = 'Old' and trg.[ODSIsCurrent] != 1) or (chg.MergeType = 'Non' and trg.[ODSIsCurrent] = 1)

		)

		select  src.[asset_id] ,src.[simple_id] ,src.[asset_entity_id] ,src.[qr_code] ,src.[on_road_speed_limit_override] ,src.[off_road_speed_limit] ,src.[snap_to_road] ,src.[start_date] ,src.[name] ,src.[description] ,src.[device_id] ,src.[device_label] ,src.[device_model_type] ,src.[device_model_type_id] ,src.[device_supports_trips] ,src.[default_operator_contact_id] ,src.[service_schedule_id] ,src.[time_usage_id] ,src.[service_contact_id] ,src.[is_owner] ,src.[is_update_allowed] ,src.[is_action_allowed] ,src.[is_history_allowed] ,src.[is_demo] ,src.[asset_nzta_subject_to_ruc] ,src.[asset_nzta_subject_to_ruc_hubo] ,src.[asset_nzta_wof_expiry_date] ,src.[asset_nzta_wof_type] ,src.[asset_nzta_license_expiry_date] ,src.[asset_nzta_fuel_type] ,src.[asset_nzta_ruc_expiry] ,src.[asset_nzta_ruc_expiry_date] ,src.[is_deleted] ,src.[last_changed] ,src.[type] ,src.[identifier] ,src.[serial_number] ,src.[class_id] ,src.[class] ,src.[make_id] ,src.[make] ,src.[model] ,src.[year] ,src.[primary_color] ,src.[asset_service_code] , 
			CAST(isnull(ODSIsCurrent, 1) AS int) as ODSIsCurrent, 
			isnull(ODSEffectiveFrom, @SystemEffectiveFrom) as ODSEffectiveFrom, 
			isnull(ODSEffectiveTo, case ODSIsCurrent when 1 then @SystemDefaultEffectiveTo else @SystemEffectiveTo end) as ODSEffectiveTo, 
			CAST(isnull([ODSDMLOperation], 'I') AS varchar(1)) as [ODSDMLOperation], 
			isnull(ODSBatchId, @batchId) as ODSBatchId, 
			isnull(ODSSourceSystem, @SourceSystem) as ODSSourceSystem
		from cte_AllChanges as src;

		set @insertedRecords = (select count(1) from [TapuiWaka].[asset] 
									where [ODSDMLOperation] = 'I' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @updatedRecords = (select count(1) from [TapuiWaka].[asset] 
									where [ODSDMLOperation] = 'U' 
										and [ODSIsCurrent] = 1
										and [ODSBatchId] = @batchId);
		set @deletedRecords = (select count(1) from [TapuiWaka].[asset] 
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