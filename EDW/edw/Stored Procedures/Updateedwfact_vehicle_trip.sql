
CREATE procedure [edw].[Updateedwfact_vehicle_trip] 
	@pBatchID int, 
	@pIndexRebuildThreshold int,
	@pOutputParamsAsDataset int = 0,
	@pErrorRecords int = null OUTPUT, 
	@pInsertRecords int = null OUTPUT, 
	@pUpdateRecords int = null OUTPUT, 
	@pDeleteRecords int = null OUTPUT,
	@pCompleted int = null OUTPUT,
	@pTargetRecords int = null OUTPUT 
as

/***************************************************************************
NAME:     [edw].[Updateedwfact_vehicle_trip] 
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2026-05-19    Pankaj Bhatt		Initial version

****************************************************************************/


begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = 'TapuiWaka.asset_trip';
	
	declare @stagedRecords int = 0;
	declare @targetRecords int = 0;
	
	declare @insertedRecords int = 0;
	declare @updatedRecords int = 0;
	declare @deletedRecords int = 0;
	
	declare @systemCurrentDate datetime = getdate();

	-- Do not run if there are records in source
	select @stagedRecords = count(1) from [Staging].[ODSETLfact_vehicle_trip];
	if( @stagedRecords = 0 )
	begin
		select @targetRecords = count(1) from [edw].[fact_vehicle_trip];

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
					@targetRecords	as TargetRecords;
		end;

		return;
	end;

	begin transaction;

	begin try
		if( not exists (select top(1) 1 from [edw].[fact_vehicle_trip]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[fact_vehicle_trip]
			(
				[dim_vehicle_key]
				,[dim_employee_key]
				,[vehicle_trip_id] 
				,[vehicle_id] 
				,[employee_id]
				,[is_processed] 
				,[version] 
				,[start_timestamp] 
				,[start_point_latitude] 
				,[start_point_longitude] 
				,[start_address] 
				,[end_timestamp] 
				,[end_point_latitude] 
				,[end_point_longitude] 
				,[end_address] 
				,[is_towed] 
				,[driver_full_name] 
				,[driver_email_address] 
				,[distance_meters] 
				,[distance_meters_offroad] 
				,[average_speed] 
				,[max_speed] 
				,[num_polls] 
				,[on_road_within_speed_limit] 
				,[on_road_over_speed_limit_band1] 
				,[on_road_over_speed_limit_band2] 
				,[on_road_over_speed_limit_band3] 
				,[on_road_over_speed_limit_band4] 
				,[on_road_over_speed_limit_band5] 
				,[offroad_within_speed_limit] 
				,[offroad_over_speed_limit_band1] 
				,[offroad_over_speed_limit_band2] 
				,[offroad_over_speed_limit_band3] 
				,[offroad_over_speed_limit_band4] 
				,[offroad_over_speed_limit_band5] 
				,[DWHBatchId] 
				,[DWHCreatedAt] 
				,[DWHModifiedOn] 
				,[DWHDMLOperation] 
				,[DWHSourceSystem] 
			)
			select
				
				src.[dim_vehicle_key]
				,src.[dim_employee_key]
				,src.[vehicle_trip_id] 
				,src.[vehicle_id] 
				,src.[employee_id]
				,src.[is_processed] 
				,src.[version] 
				,src.[start_timestamp] 
				,src.[start_point_latitude] 
				,src.[start_point_longitude] 
				,src.[start_address] 
				,src.[end_timestamp] 
				,src.[end_point_latitude] 
				,src.[end_point_longitude] 
				,src.[end_address] 
				,src.[is_towed] 
				,src.[driver_full_name] 
				,src.[driver_email_address] 
				,src.[distance_meters] 
				,src.[distance_meters_offroad] 
				,src.[average_speed] 
				,src.[max_speed] 
				,src.[num_polls] 
				,src.[on_road_within_speed_limit] 
				,src.[on_road_over_speed_limit_band1] 
				,src.[on_road_over_speed_limit_band2] 
				,src.[on_road_over_speed_limit_band3] 
				,src.[on_road_over_speed_limit_band4] 
				,src.[on_road_over_speed_limit_band5] 
				,src.[offroad_within_speed_limit] 
				,src.[offroad_over_speed_limit_band1] 
				,src.[offroad_over_speed_limit_band2] 
				,src.[offroad_over_speed_limit_band3] 
				,src.[offroad_over_speed_limit_band4] 
				,src.[offroad_over_speed_limit_band5] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLfact_vehicle_trip] as src;
		end else begin
			merge into [edw].[fact_vehicle_trip] as trg
			using 
			(
				select
				src.[dim_vehicle_key]
				,src.[dim_employee_key]
				,src.[vehicle_trip_id] 
				,src.[vehicle_id]
				,src.[employee_id]				
				,src.[is_processed] 
				,src.[version] 
				,src.[start_timestamp] 
				,src.[start_point_latitude] 
				,src.[start_point_longitude] 
				,src.[start_address] 
				,src.[end_timestamp] 
				,src.[end_point_latitude] 
				,src.[end_point_longitude] 
				,src.[end_address] 
				,src.[is_towed] 
				,src.[driver_full_name] 
				,src.[driver_email_address] 
				,src.[distance_meters] 
				,src.[distance_meters_offroad] 
				,src.[average_speed] 
				,src.[max_speed] 
				,src.[num_polls] 
				,src.[on_road_within_speed_limit] 
				,src.[on_road_over_speed_limit_band1] 
				,src.[on_road_over_speed_limit_band2] 
				,src.[on_road_over_speed_limit_band3] 
				,src.[on_road_over_speed_limit_band4] 
				,src.[on_road_over_speed_limit_band5] 
				,src.[offroad_within_speed_limit] 
				,src.[offroad_over_speed_limit_band1] 
				,src.[offroad_over_speed_limit_band2] 
				,src.[offroad_over_speed_limit_band3] 
				,src.[offroad_over_speed_limit_band4] 
				,src.[offroad_over_speed_limit_band5] 
				,@BatchID as [DWHBatchId]
				,getdate() as [DWHCreatedAt]
				,getdate() as [DWHModifiedOn]
				,'I' as [DWHDMLOperation]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLfact_vehicle_trip] as src
			) as src on (src.[vehicle_trip_id] = trg.[vehicle_trip_id] collate database_default)			-- Retire existing records
			when matched and exists 
			( 
				select src.[dim_vehicle_key], src.[dim_employee_key], src.[vehicle_id], src.[employee_id], src.[is_processed], src.[version], src.[start_timestamp], src.[start_point_latitude], src.[start_point_longitude], src.[start_address], src.[end_timestamp], src.[end_point_latitude], src.[end_point_longitude], src.[end_address], src.[is_towed], src.[driver_full_name], src.[driver_email_address], src.[distance_meters], src.[distance_meters_offroad], src.[average_speed], src.[max_speed], src.[num_polls], src.[on_road_within_speed_limit], src.[on_road_over_speed_limit_band1], src.[on_road_over_speed_limit_band2], src.[on_road_over_speed_limit_band3], src.[on_road_over_speed_limit_band4], src.[on_road_over_speed_limit_band5], src.[offroad_within_speed_limit], src.[offroad_over_speed_limit_band1], src.[offroad_over_speed_limit_band2], src.[offroad_over_speed_limit_band3], src.[offroad_over_speed_limit_band4], src.[offroad_over_speed_limit_band5]
				except
				select trg.[dim_vehicle_key], trg.[dim_employee_key], trg.[vehicle_id], trg.[employee_id], trg.[is_processed], trg.[version], trg.[start_timestamp], trg.[start_point_latitude], trg.[start_point_longitude], trg.[start_address], trg.[end_timestamp], trg.[end_point_latitude], trg.[end_point_longitude], trg.[end_address], trg.[is_towed], trg.[driver_full_name], trg.[driver_email_address], trg.[distance_meters], trg.[distance_meters_offroad], trg.[average_speed], trg.[max_speed], trg.[num_polls], trg.[on_road_within_speed_limit], trg.[on_road_over_speed_limit_band1], trg.[on_road_over_speed_limit_band2], trg.[on_road_over_speed_limit_band3], trg.[on_road_over_speed_limit_band4], trg.[on_road_over_speed_limit_band5], trg.[offroad_within_speed_limit], trg.[offroad_over_speed_limit_band1], trg.[offroad_over_speed_limit_band2], trg.[offroad_over_speed_limit_band3], trg.[offroad_over_speed_limit_band4], trg.[offroad_over_speed_limit_band5]
			) then  update set 
				[dim_vehicle_key] = src.[dim_vehicle_key]
				, [dim_employee_key] = src.[dim_employee_key]
				, [vehicle_trip_id] = src.[vehicle_trip_id]
				, [vehicle_id] = src.[vehicle_id]
				, [employee_id] = src.[employee_id]
				, [is_processed] = src.[is_processed]
				, [version] = src.[version]
				, [start_timestamp] = src.[start_timestamp]
				, [start_point_latitude] = src.[start_point_latitude]
				, [start_point_longitude] = src.[start_point_longitude]
				, [start_address] = src.[start_address]
				, [end_timestamp] = src.[end_timestamp]
				, [end_point_latitude] = src.[end_point_latitude]
				, [end_point_longitude] = src.[end_point_longitude]
				, [end_address] = src.[end_address]
				, [is_towed] = src.[is_towed]
				, [driver_full_name] = src.[driver_full_name]
				, [driver_email_address] = src.[driver_email_address]
				, [distance_meters] = src.[distance_meters]
				, [distance_meters_offroad] = src.[distance_meters_offroad]
				, [average_speed] = src.[average_speed]
				, [max_speed] = src.[max_speed]
				, [num_polls] = src.[num_polls]
				, [on_road_within_speed_limit] = src.[on_road_within_speed_limit]
				, [on_road_over_speed_limit_band1] = src.[on_road_over_speed_limit_band1]
				, [on_road_over_speed_limit_band2] = src.[on_road_over_speed_limit_band2]
				, [on_road_over_speed_limit_band3] = src.[on_road_over_speed_limit_band3]
				, [on_road_over_speed_limit_band4] = src.[on_road_over_speed_limit_band4]
				, [on_road_over_speed_limit_band5] = src.[on_road_over_speed_limit_band5]
				, [offroad_within_speed_limit] = src.[offroad_within_speed_limit]
				, [offroad_over_speed_limit_band1] = src.[offroad_over_speed_limit_band1]
				, [offroad_over_speed_limit_band2] = src.[offroad_over_speed_limit_band2]
				, [offroad_over_speed_limit_band3] = src.[offroad_over_speed_limit_band3]
				, [offroad_over_speed_limit_band4] = src.[offroad_over_speed_limit_band4]
				, [offroad_over_speed_limit_band5] = src.[offroad_over_speed_limit_band5]
				,[DWHModifiedOn] = @systemCurrentDate
				,[DWHBatchId] = @BatchID
				,[DWHDMLOperation] = isnull(nullif(src.[DWHDMLOperation],'I'),'U')
			-- Soft delete missing records
			when not matched by source and trg.[DWHDMLOperation] <> 'D' then update set [DWHModifiedOn] = @systemCurrentDate, [DWHDMLOperation] = 'D'
			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [dim_vehicle_key]
					,[dim_employee_key]
					,[vehicle_trip_id] 
					,[vehicle_id]
					,[employee_id]					
					,[is_processed] 
					,[version] 
					,[start_timestamp] 
					,[start_point_latitude] 
					,[start_point_longitude] 
					,[start_address] 
					,[end_timestamp] 
					,[end_point_latitude] 
					,[end_point_longitude] 
					,[end_address] 
					,[is_towed] 
					,[driver_full_name] 
					,[driver_email_address] 
					,[distance_meters] 
					,[distance_meters_offroad] 
					,[average_speed] 
					,[max_speed] 
					,[num_polls] 
					,[on_road_within_speed_limit] 
					,[on_road_over_speed_limit_band1] 
					,[on_road_over_speed_limit_band2] 
					,[on_road_over_speed_limit_band3] 
					,[on_road_over_speed_limit_band4] 
					,[on_road_over_speed_limit_band5] 
					,[offroad_within_speed_limit] 
					,[offroad_over_speed_limit_band1] 
					,[offroad_over_speed_limit_band2] 
					,[offroad_over_speed_limit_band3] 
					,[offroad_over_speed_limit_band4] 
					,[offroad_over_speed_limit_band5] 
					,[DWHBatchId] 
					,[DWHCreatedAt] 
					,[DWHModifiedOn] 
					,[DWHDMLOperation] 
					,[DWHSourceSystem] 
				)
				values
				(
					src.[dim_vehicle_key]
					,src.[dim_employee_key] 
					,src.[vehicle_trip_id] 
					,src.[vehicle_id] 
					,src.[employee_id]
					,src.[is_processed] 
					,src.[version] 
					,src.[start_timestamp] 
					,src.[start_point_latitude] 
					,src.[start_point_longitude] 
					,src.[start_address] 
					,src.[end_timestamp] 
					,src.[end_point_latitude] 
					,src.[end_point_longitude] 
					,src.[end_address] 
					,src.[is_towed] 
					,src.[driver_full_name] 
					,src.[driver_email_address] 
					,src.[distance_meters] 
					,src.[distance_meters_offroad] 
					,src.[average_speed] 
					,src.[max_speed] 
					,src.[num_polls] 
					,src.[on_road_within_speed_limit] 
					,src.[on_road_over_speed_limit_band1] 
					,src.[on_road_over_speed_limit_band2] 
					,src.[on_road_over_speed_limit_band3] 
					,src.[on_road_over_speed_limit_band4] 
					,src.[on_road_over_speed_limit_band5] 
					,src.[offroad_within_speed_limit] 
					,src.[offroad_over_speed_limit_band1] 
					,src.[offroad_over_speed_limit_band2] 
					,src.[offroad_over_speed_limit_band3] 
					,src.[offroad_over_speed_limit_band4] 
					,src.[offroad_over_speed_limit_band5] 
					,src.[DWHBatchId] 
					,src.[DWHCreatedAt] 
					,src.[DWHModifiedOn] 
					,src.[DWHDMLOperation] 
					,src.[DWHSourceSystem] 
				);
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[fact_vehicle_trip];

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

		if (@pOutputParamsAsDataset = 1)
		begin
			-- Select return parameters as a dataset
			select @pErrorRecords	as ErrorRecords,
					@pInsertRecords as InsertRecords,
					@pUpdateRecords as UpdateRecords,
					@pDeleteRecords as DeleteRecords,
					@pCompleted		as Completed,
					@targetRecords	as TargetRecords;
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
				@targetRecords	as TargetRecords;
	end;
end;