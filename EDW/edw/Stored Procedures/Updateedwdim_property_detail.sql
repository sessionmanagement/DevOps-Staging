--drop  procedure [edw].[Updateedwdim_property_detail]
--go

CREATE procedure [edw].[Updateedwdim_property_detail]

	/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property_detail]
 Author		Stefen Hasselberg
 Created	2024-01-11	
 Purpose	Updates dim_property_detail from staging
		
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-01-11	  Stefen Hasselberg		Initial version
2.0     2024-01-18	  Stefen Hasselberg		Change audit column prefixes to DWH	
3.0		2026-02-20	  GitHub Copilot		Removed 14 redundant columns per work item 12210

**********************************************************************************************************/


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
begin

	set nocount on;
	set xact_abort on;

	-- Variables
	declare @batchID int = @pBatchID;
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_property_detail]';

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
		[property_detail_id] uniqueidentifier null
		,
		[MergeAction] varchar(10)
	);
	begin transaction;
	begin try

		-- Insert default records if the table is empty
		IF (
			NOT EXISTS (
				SELECT 1
	FROM [edw].[dim_property_detail]
	WHERE dim_property_detail_key <= 0
				)
			)
		BEGIN
		-- turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_property_detail] ON
		INSERT INTO [edw].[dim_property_detail]
			( [dim_property_detail_key]
			,[property_detail_id]
			,[property_detail_statecode]
			,[property_detail_statuscode]
			,[property_detail_crba8_gas_supply_type]
			,[property_detail_crba8_no_of_bathrooms_no_toilet]
			,[property_detail_crba8_no_of_bathrooms_with_toilet]
			,[property_detail_accessibility]
			,[property_detail_body_corporate_applies_indicator]
			,[property_detail_cladding_type]
			,[property_detail_construction_type]
			,[property_detail_garage_1]
			,[property_detail_hot_water_type]
			,[property_detail_inspection_interval]
			,[property_detail_inspection_type]
			,[property_detail_no_of_bedrooms]
			,[property_detail_no_of_carport]
			,[property_detail_no_of_double_bedrooms]
			,[property_detail_no_of_levels]
			,[property_detail_no_of_single_bedrooms]
			,[property_detail_no_of_toilets]
			,[property_detail_no_parkingspaces]
			,[property_detail_offstreet_parking]
			,[property_detail_power]
			,[property_detail_condition_rating]
			,[property_detail_roof_type]
			,[property_detail_sewerage]
			,[property_detail_stove_type_new]
			,[property_detail_tv_connection]
			,[property_detail_water]
			,[property_detail_walkin_shower_flag]
			,[property_detail_wheelchair_ramp_flag]
			,[property_detail_crba8_external_gas_bottle_location]
			,[property_detail_accessibility_summary]
			,[property_detail_certificate_of_title]
			,[property_detail_district_council_office]
			,[property_detail_electricity_meter_location]
			,[property_detail_electricity_supplier]
			,[property_detail_floor_area]
			,[property_detail_gas_meter_location]
			,[property_detail_gas_supplier]
			,[property_detail_icp_number]
			,[property_detail_last_inspection_date]
			,[property_detail_legal_description]
			,[property_detail_location_of_circuit_board]
			,[property_detail_next_inspection_date]
			,[property_detail_online_date]
			,[property_detail_pcr_last_updated_date]
			,[property_detail_returned_date]
			,[property_detail_tile_colour]
			,[property_detail_tile_type]
			,[property_detail_valuation_date]
			,[property_detail_valuation_number]
			,[property_detail_valuation_roll_number]
			,[property_detail_vinyl_colour]
			,[property_detail_vinyl_specification]
			,[property_detail_watermeter_location_text]
			,[property_detail_water_meter]
			,[property_detail_water_meter_number]
			,[property_detail_rubbish_bin_serial_number]
			,[property_detail_water_comment]
			,[property_detail_water_meter_location_name]
			,[property_details_is_delete_flag]
			,[synapse_link_sink_modified_on]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHDMLOperation]
			,[DWHIsCurrent]
			,[DWHSourceSystem])
		VALUES
			( 0
				   , NULL
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , NULL                        -- property_detail_walkin_shower_flag (INT)
				   , NULL                        -- property_detail_wheelchair_ramp_flag (INT)
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , NULL                        -- property_detail_floor_area (NUMERIC)
				   , 'N/A'
				   , 'N/A'
				   , 'N/A'
				   , NULL                        -- property_detail_last_inspection_date (DATETIME2)
				   , 'N/A'
				   , 'N/A'
			   , NULL                        -- property_detail_next_inspection_date (DATETIME2)
			   , NULL                        -- property_detail_online_date (DATETIME2)
			   , NULL                        -- property_detail_pcr_last_updated_date (DATETIME2)
			   , NULL                        -- property_detail_returned_date (DATETIME2)
			   , 'N/A'
			   , 'N/A'
			   , NULL                        -- property_detail_valuation_date (DATETIME2)
				   , 'N/A'
				  , 'N/A'
				   , NULL
				   , NULL
				   , 'N/A'
				   , NULL
				   , NULL
				   , 'N/A'			 
				   , 'N/A'
				   , NULL
				   , NULL
				   , NULL                        -- property_details_is_delete_flag
				   , 0                           -- DWHBatchID
				   , @SystemDefaultEffectiveFrom -- DWHEffectiveFrom
				   , @SystemDefaultEffectiveTo   -- DWHEffectiveTo
				   , 'I'                         -- DWHDMLOperation
				   , 1                           -- DWHIsCurrent
				   , 'Unknown'                   -- DWHSourceID
				   ),
			( -1
				   , NULL
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , NULL                        -- property_detail_walkin_shower_flag (INT)
				   , NULL                        -- property_detail_wheelchair_ramp_flag (INT)
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , NULL                        -- property_detail_floor_area (NUMERIC)
				   , 'Unknown'
				   , 'Unknown'
				   , 'Unknown'
				   , NULL                        -- property_detail_last_inspection_date (DATETIME2)
				   , 'Unknown'
				   , 'Unknown'
			   , NULL                        -- property_detail_next_inspection_date (DATETIME2)
			   , NULL                        -- property_detail_online_date (DATETIME2)
			   , NULL                        -- property_detail_pcr_last_updated_date (DATETIME2)
			   , NULL                        -- property_detail_returned_date (DATETIME2)
			   , 'Unknown'
			    , 'Unknown'
			   , NULL                        -- property_detail_valuation_date (DATETIME2)
				   , 'Unknown'
				   , 'Unknown'
		  	       , NULL
				   , NULL
				   , 'Unknown'
				   , NULL
				   , NULL
				   , 'Unknown'
				   , NULL
				   , NULL		  
				   , NULL
				   , NULL                        -- property_details_is_delete_flag
				   , 0                           -- DWHBatchID
				   , @SystemDefaultEffectiveFrom -- DWHEffectiveFrom
				   , @SystemDefaultEffectiveTo   -- DWHEffectiveTo
				   , 'I'                         -- DWHDMLOperation
				   , 1                           -- DWHIsCurrent
				   , 'Unknown'                   -- DWHSourceID
				   )

		-- turn the identity insert off
		SET IDENTITY_INSERT [edw].[dim_property_detail] OFF

	END
		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1)
	from [Staging].[ODSETLdim_property_detail];
		if( @stagedRecords = 0 )
		begin
		select
			@targetRecords = count(1) 
				, @deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_property_detail];
		-- Select success details
		select
			@pErrorRecords = 0
				, @pInsertRecords = 0
				, @pUpdateRecords = 0
				, @pDeleteRecords = 0
				, @pCompleted = 1
				, @pTargetRecords = @targetRecords;

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

		if( not exists (select top(1)
		1
	from [edw].[dim_property_detail]) )
		begin
		-- There are no records in the target; insert all
		insert into [edw].[dim_property_detail]
			(
			[property_detail_id]
			,[property_detail_statecode]
			,[property_detail_statuscode]
			,[property_detail_crba8_gas_supply_type]
			,[property_detail_crba8_no_of_bathrooms_no_toilet]
			,[property_detail_crba8_no_of_bathrooms_with_toilet]
			,[property_detail_accessibility]
			,[property_detail_body_corporate_applies_indicator]
			,[property_detail_cladding_type]
			,[property_detail_construction_type]
			,[property_detail_garage_1]
			,[property_detail_hot_water_type]
			,[property_detail_inspection_interval]
			,[property_detail_inspection_type]
			,[property_detail_no_of_bedrooms]
			,[property_detail_no_of_carport]
			,[property_detail_no_of_double_bedrooms]
			,[property_detail_no_of_levels]
			,[property_detail_no_of_single_bedrooms]
			,[property_detail_no_of_toilets]
			,[property_detail_no_parkingspaces]
			,[property_detail_offstreet_parking]
			,[property_detail_power]
			,[property_detail_condition_rating]
			,[property_detail_roof_type]
			,[property_detail_sewerage]
			,[property_detail_stove_type_new]
			,[property_detail_tv_connection]
			,[property_detail_water]
			,[property_detail_crba8_external_gas_bottle_location]
			,[property_detail_accessibility_summary]
			,[property_detail_district_council_office]
			,[property_detail_electricity_meter_location]
			,[property_detail_electricity_supplier]
			,[property_detail_floor_area]
			,[property_detail_gas_meter_location]
			,[property_detail_gas_supplier]
			,[property_detail_icp_number]
			,[property_detail_last_inspection_date]
			,[property_detail_legal_description]
			,[property_detail_location_of_circuit_board]
			,[property_detail_next_inspection_date]
			,[property_detail_online_date]
			,[property_detail_pcr_last_updated_date]
			,[property_detail_returned_date]
			,[property_detail_tile_colour]
			,[property_detail_tile_type]
			,[property_detail_vinyl_colour]
			,[property_detail_vinyl_specification]
			,[property_detail_watermeter_location_text]
			,[property_detail_water_meter]
			,[property_detail_water_meter_number]
			,[property_detail_rubbish_bin_serial_number]
			,[property_detail_water_comment]
			,[property_detail_water_meter_location_name]
			,[synapse_link_sink_modified_on]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHDMLOperation]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			)
		select
			src.[property_detail_id] 
				, src.[property_detail_statecode] 
				, src.[property_detail_statuscode] 
				, src.[property_detail_crba8_gas_supply_type] 
				, src.[property_detail_crba8_no_of_bathrooms_no_toilet] 
				, src.[property_detail_crba8_no_of_bathrooms_with_toilet] 
				, src.[property_detail_accessibility] 
				, src.[property_detail_body_corporate_applies_indicator] 
				, src.[property_detail_cladding_type] 
				, src.[property_detail_construction_type] 
				, src.[property_detail_garage_1] 
				, src.[property_detail_hot_water_type] 
				, src.[property_detail_inspection_interval] 
				, src.[property_detail_inspection_type] 
				, src.[property_detail_no_of_bedrooms] 
				, src.[property_detail_no_of_carport] 
				, src.[property_detail_no_of_double_bedrooms] 
				, src.[property_detail_no_of_levels] 
				, src.[property_detail_no_of_single_bedrooms] 
				, src.[property_detail_no_of_toilets] 
				, src.[property_detail_no_parkingspaces] 
				, src.[property_detail_offstreet_parking] 
				, src.[property_detail_power] 
				, src.[property_detail_condition_rating] 
				, src.[property_detail_roof_type] 
				, src.[property_detail_sewerage] 
				, src.[property_detail_stove_type_new] 
				, src.[property_detail_tv_connection] 
				, src.[property_detail_water] 
				, src.[property_detail_crba8_external_gas_bottle_location] 
				, src.[property_detail_accessibility_summary] 
				, src.[property_detail_district_council_office] 
				, src.[property_detail_electricity_meter_location] 
				, src.[property_detail_electricity_supplier] 
				, src.[property_detail_floor_area] 
				, src.[property_detail_gas_meter_location] 
				, src.[property_detail_gas_supplier] 
				, src.[property_detail_icp_number] 
				, src.[property_detail_last_inspection_date] 
				, src.[property_detail_legal_description] 
				, src.[property_detail_location_of_circuit_board] 
				, src.[property_detail_next_inspection_date] 
				, src.[property_detail_online_date] 
				, src.[property_detail_pcr_last_updated_date] 
				, src.[property_detail_returned_date] 
				, src.[property_detail_tile_colour] 
				, src.[property_detail_tile_type] 
				, src.[property_detail_vinyl_colour] 
				, src.[property_detail_vinyl_specification] 
				, src.[property_detail_watermeter_location_text] 
				, src.[property_detail_water_meter] 
				, src.[property_detail_water_meter_number] 
				, src.[property_detail_rubbish_bin_serial_number] 
				, src.[property_detail_water_comment] 
				, src.[property_detail_water_meter_location_name] 
				, src.[synapse_link_sink_modified_on] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLdim_property_detail] as src;
	end else begin
		-- Fetch the current high-water maximum values
		declare @synapse_link_sink_modified_on datetime2(7) = null;

		execute [edw].[GetHighwaterForedwdim_property_detail] @synapse_link_sink_modified_on output;

		merge into [edw].[dim_property_detail] as trg
			using 
			(
				select
			src.[property_detail_id] 
				, src.[property_detail_statecode] 
				, src.[property_detail_statuscode] 
				, src.[property_detail_crba8_gas_supply_type] 
				, src.[property_detail_crba8_no_of_bathrooms_no_toilet] 
				, src.[property_detail_crba8_no_of_bathrooms_with_toilet] 
				, src.[property_detail_accessibility] 
				, src.[property_detail_body_corporate_applies_indicator] 
				, src.[property_detail_cladding_type] 
				, src.[property_detail_construction_type] 
				, src.[property_detail_garage_1] 
				, src.[property_detail_hot_water_type] 
				, src.[property_detail_inspection_interval] 
				, src.[property_detail_inspection_type] 
				, src.[property_detail_no_of_bedrooms] 
				, src.[property_detail_no_of_carport] 
				, src.[property_detail_no_of_double_bedrooms] 
				, src.[property_detail_no_of_levels] 
				, src.[property_detail_no_of_single_bedrooms] 
				, src.[property_detail_no_of_toilets] 
				, src.[property_detail_no_parkingspaces] 
				, src.[property_detail_offstreet_parking] 
				, src.[property_detail_power] 
				, src.[property_detail_condition_rating] 
				, src.[property_detail_roof_type] 
				, src.[property_detail_sewerage] 
				, src.[property_detail_stove_type_new] 
				, src.[property_detail_tv_connection] 
				, src.[property_detail_water] 
				, src.[property_detail_crba8_external_gas_bottle_location] 
				, src.[property_detail_accessibility_summary] 
				, src.[property_detail_district_council_office] 
				, src.[property_detail_electricity_meter_location] 
				, src.[property_detail_electricity_supplier] 
				, src.[property_detail_floor_area] 
				, src.[property_detail_gas_meter_location] 
				, src.[property_detail_gas_supplier] 
				, src.[property_detail_icp_number] 
				, src.[property_detail_last_inspection_date] 
				, src.[property_detail_legal_description] 
				, src.[property_detail_location_of_circuit_board] 
				, src.[property_detail_next_inspection_date] 
				, src.[property_detail_online_date] 
				, src.[property_detail_pcr_last_updated_date] 
				, src.[property_detail_returned_date] 
				, src.[property_detail_tile_colour] 
				, src.[property_detail_tile_type] 
				, src.[property_detail_vinyl_colour] 
				, src.[property_detail_vinyl_specification] 
				, src.[property_detail_watermeter_location_text] 
				, src.[property_detail_water_meter] 
				, src.[property_detail_water_meter_number] 
				, src.[property_detail_rubbish_bin_serial_number] 
				, src.[property_detail_water_comment] 
				, src.[property_detail_water_meter_location_name] 
				, src.[synapse_link_sink_modified_on] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
		from [Staging].[ODSETLdim_property_detail] as src
			) as src on (src.[property_detail_id] = trg.[property_detail_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				            																																																																		select src.[property_detail_statecode], src.[property_detail_statuscode], src.[property_detail_crba8_gas_supply_type], src.[property_detail_crba8_no_of_bathrooms_no_toilet], src.[property_detail_crba8_no_of_bathrooms_with_toilet], src.[property_detail_accessibility], src.[property_detail_body_corporate_applies_indicator], src.[property_detail_cladding_type], src.[property_detail_construction_type], src.[property_detail_garage_1], src.[property_detail_hot_water_type], src.[property_detail_inspection_interval], src.[property_detail_inspection_type], src.[property_detail_no_of_bedrooms], src.[property_detail_no_of_carport], src.[property_detail_no_of_double_bedrooms], src.[property_detail_no_of_levels], src.[property_detail_no_of_single_bedrooms], src.[property_detail_no_of_toilets], src.[property_detail_no_parkingspaces], src.[property_detail_offstreet_parking], src.[property_detail_power], src.[property_detail_condition_rating], src.[property_detail_roof_type], src.[property_detail_sewerage], src.[property_detail_stove_type_new], src.[property_detail_tv_connection], src.[property_detail_water], src.[property_detail_crba8_external_gas_bottle_location], src.[property_detail_accessibility_summary], src.[property_detail_district_council_office], src.[property_detail_electricity_meter_location], src.[property_detail_electricity_supplier], src.[property_detail_floor_area], src.[property_detail_gas_meter_location], src.[property_detail_gas_supplier], src.[property_detail_icp_number], src.[property_detail_last_inspection_date], src.[property_detail_legal_description], src.[property_detail_location_of_circuit_board], src.[property_detail_next_inspection_date], src.[property_detail_online_date], src.[property_detail_pcr_last_updated_date], src.[property_detail_returned_date], src.[property_detail_tile_colour], src.[property_detail_tile_type], src.[property_detail_vinyl_colour], src.[property_detail_vinyl_specification], src.[property_detail_watermeter_location_text], src.[property_detail_water_meter], src.[property_detail_water_meter_number], src.[property_detail_rubbish_bin_serial_number], src.[property_detail_water_comment], src.[property_detail_water_meter_location_name], src.[synapse_link_sink_modified_on], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
		except
			select trg.[property_detail_statecode], trg.[property_detail_statuscode], trg.[property_detail_crba8_gas_supply_type], trg.[property_detail_crba8_no_of_bathrooms_no_toilet], trg.[property_detail_crba8_no_of_bathrooms_with_toilet], trg.[property_detail_accessibility], trg.[property_detail_body_corporate_applies_indicator], trg.[property_detail_cladding_type], trg.[property_detail_construction_type], trg.[property_detail_garage_1], trg.[property_detail_hot_water_type], trg.[property_detail_inspection_interval], trg.[property_detail_inspection_type], trg.[property_detail_no_of_bedrooms], trg.[property_detail_no_of_carport], trg.[property_detail_no_of_double_bedrooms], trg.[property_detail_no_of_levels], trg.[property_detail_no_of_single_bedrooms], trg.[property_detail_no_of_toilets], trg.[property_detail_no_parkingspaces], trg.[property_detail_offstreet_parking], trg.[property_detail_power], trg.[property_detail_condition_rating], trg.[property_detail_roof_type], trg.[property_detail_sewerage], trg.[property_detail_stove_type_new], trg.[property_detail_tv_connection], trg.[property_detail_water], trg.[property_detail_crba8_external_gas_bottle_location], trg.[property_detail_accessibility_summary], trg.[property_detail_district_council_office], trg.[property_detail_electricity_meter_location], trg.[property_detail_electricity_supplier], trg.[property_detail_floor_area], trg.[property_detail_gas_meter_location], trg.[property_detail_gas_supplier], trg.[property_detail_icp_number], trg.[property_detail_last_inspection_date], trg.[property_detail_legal_description], trg.[property_detail_location_of_circuit_board], trg.[property_detail_next_inspection_date], trg.[property_detail_online_date], trg.[property_detail_pcr_last_updated_date], trg.[property_detail_returned_date], trg.[property_detail_tile_colour], trg.[property_detail_tile_type], trg.[property_detail_vinyl_colour], trg.[property_detail_vinyl_specification], trg.[property_detail_watermeter_location_text], trg.[property_detail_water_meter], trg.[property_detail_water_meter_number], trg.[property_detail_rubbish_bin_serial_number], trg.[property_detail_water_comment], trg.[property_detail_water_meter_location_name], trg.[synapse_link_sink_modified_on], 'X'
			) then  
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Soft delete missing records
			when not matched by source 
			and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo
			and trg.[DWHDMLOperation] <> 'D'
			and trg.[synapse_link_sink_modified_on] > @synapse_link_sink_modified_on then 
				update set [DWHEffectiveTo] = @SystemEffectiveTo, [DWHIsCurrent] = 0

			-- Insert new records
			when not matched by target then 
				insert 
				(
					 [property_detail_id] 
					,[property_detail_statecode] 
					,[property_detail_statuscode] 
					,[property_detail_crba8_gas_supply_type] 
					,[property_detail_crba8_no_of_bathrooms_no_toilet] 
					,[property_detail_crba8_no_of_bathrooms_with_toilet] 
					,[property_detail_accessibility] 
					,[property_detail_body_corporate_applies_indicator] 
					,[property_detail_cladding_type] 
					,[property_detail_construction_type] 
					,[property_detail_garage_1] 
					,[property_detail_hot_water_type] 
					,[property_detail_inspection_interval] 
					,[property_detail_inspection_type] 
					,[property_detail_no_of_bedrooms] 
					,[property_detail_no_of_carport] 
					,[property_detail_no_of_double_bedrooms] 
					,[property_detail_no_of_levels] 
					,[property_detail_no_of_single_bedrooms] 
					,[property_detail_no_of_toilets] 
					,[property_detail_no_parkingspaces] 
					,[property_detail_offstreet_parking] 
					,[property_detail_power] 
					,[property_detail_condition_rating] 
					,[property_detail_roof_type] 
					,[property_detail_sewerage] 
					,[property_detail_stove_type_new] 
					,[property_detail_tv_connection] 
					,[property_detail_water] 
					,[property_detail_crba8_external_gas_bottle_location] 
					,[property_detail_accessibility_summary] 
					,[property_detail_district_council_office] 
					,[property_detail_electricity_meter_location] 
					,[property_detail_electricity_supplier] 
					,[property_detail_floor_area] 
					,[property_detail_gas_meter_location] 
					,[property_detail_gas_supplier] 
					,[property_detail_icp_number] 
					,[property_detail_last_inspection_date] 
					,[property_detail_legal_description] 
					,[property_detail_location_of_circuit_board] 
					,[property_detail_next_inspection_date] 
					,[property_detail_online_date] 
					,[property_detail_pcr_last_updated_date] 
					,[property_detail_returned_date] 
					,[property_detail_tile_colour] 
					,[property_detail_tile_type] 
					,[property_detail_vinyl_colour] 
					,[property_detail_vinyl_specification] 
					,[property_detail_watermeter_location_text] 
					,[property_detail_water_meter] 
					,[property_detail_water_meter_number] 
					,[property_detail_rubbish_bin_serial_number] 
					,[property_detail_water_comment] 
					,[property_detail_water_meter_location_name] 
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
					 src.[property_detail_id] 
					,src.[property_detail_statecode] 
					,src.[property_detail_statuscode] 
					,src.[property_detail_crba8_gas_supply_type] 
					,src.[property_detail_crba8_no_of_bathrooms_no_toilet] 
					,src.[property_detail_crba8_no_of_bathrooms_with_toilet] 
					,src.[property_detail_accessibility] 
					,src.[property_detail_body_corporate_applies_indicator] 
					,src.[property_detail_cladding_type] 
					,src.[property_detail_construction_type] 
					,src.[property_detail_garage_1] 
					,src.[property_detail_hot_water_type] 
					,src.[property_detail_inspection_interval] 
					,src.[property_detail_inspection_type] 
					,src.[property_detail_no_of_bedrooms] 
					,src.[property_detail_no_of_carport] 
					,src.[property_detail_no_of_double_bedrooms] 
					,src.[property_detail_no_of_levels] 
					,src.[property_detail_no_of_single_bedrooms] 
					,src.[property_detail_no_of_toilets] 
					,src.[property_detail_no_parkingspaces] 
					,src.[property_detail_offstreet_parking] 
					,src.[property_detail_power] 
					,src.[property_detail_condition_rating] 
					,src.[property_detail_roof_type] 
					,src.[property_detail_sewerage] 
					,src.[property_detail_stove_type_new] 
					,src.[property_detail_tv_connection] 
					,src.[property_detail_water] 
					,src.[property_detail_crba8_external_gas_bottle_location] 
					,src.[property_detail_accessibility_summary] 
					,src.[property_detail_district_council_office] 
					,src.[property_detail_electricity_meter_location] 
					,src.[property_detail_electricity_supplier] 
					,src.[property_detail_floor_area] 
					,src.[property_detail_gas_meter_location] 
					,src.[property_detail_gas_supplier] 
					,src.[property_detail_icp_number] 
					,src.[property_detail_last_inspection_date] 
					,src.[property_detail_legal_description] 
					,src.[property_detail_location_of_circuit_board] 
					,src.[property_detail_next_inspection_date] 
					,src.[property_detail_online_date] 
					,src.[property_detail_pcr_last_updated_date] 
					,src.[property_detail_returned_date] 
					,src.[property_detail_tile_colour] 
					,src.[property_detail_tile_type] 
					,src.[property_detail_vinyl_colour] 
					,src.[property_detail_vinyl_specification] 
					,src.[property_detail_watermeter_location_text] 
					,src.[property_detail_water_meter] 
					,src.[property_detail_water_meter_number] 
					,src.[property_detail_rubbish_bin_serial_number] 
					,src.[property_detail_water_comment] 
					,src.[property_detail_water_meter_location_name] 
					,src.[synapse_link_sink_modified_on] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_detail_id],inserted.[property_detail_id]), $action As [MergeAction] into #SummaryOfChanges;

		-- Insert new versions of previously updated records (Updates and Deletes)
		insert into [edw].[dim_property_detail]
			(
			[property_detail_id]
			,[property_detail_statecode]
			,[property_detail_statuscode]
			,[property_detail_crba8_gas_supply_type]
			,[property_detail_crba8_no_of_bathrooms_no_toilet]
			,[property_detail_crba8_no_of_bathrooms_with_toilet]
			,[property_detail_accessibility]
			,[property_detail_body_corporate_applies_indicator]
			,[property_detail_cladding_type]
			,[property_detail_construction_type]
			,[property_detail_garage_1]
			,[property_detail_hot_water_type]
			,[property_detail_inspection_interval]
			,[property_detail_inspection_type]
			,[property_detail_no_of_bedrooms]
			,[property_detail_no_of_carport]
			,[property_detail_no_of_double_bedrooms]
			,[property_detail_no_of_levels]
			,[property_detail_no_of_single_bedrooms]
			,[property_detail_no_of_toilets]
			,[property_detail_no_parkingspaces]
			,[property_detail_offstreet_parking]
			,[property_detail_power]
			,[property_detail_condition_rating]
			,[property_detail_roof_type]
			,[property_detail_sewerage]
			,[property_detail_stove_type_new]
			,[property_detail_tv_connection]
			,[property_detail_water]
			,[property_detail_crba8_external_gas_bottle_location]
			,[property_detail_accessibility_summary]
			,[property_detail_district_council_office]
			,[property_detail_electricity_meter_location]
			,[property_detail_electricity_supplier]
			,[property_detail_floor_area]
			,[property_detail_gas_meter_location]
			,[property_detail_gas_supplier]
			,[property_detail_icp_number]
			,[property_detail_last_inspection_date]
			,[property_detail_legal_description]
			,[property_detail_location_of_circuit_board]
			,[property_detail_next_inspection_date]
			,[property_detail_online_date]
			,[property_detail_pcr_last_updated_date]
			,[property_detail_returned_date]
			,[property_detail_tile_colour]
			,[property_detail_tile_type]
			,[property_detail_vinyl_colour]
			,[property_detail_vinyl_specification]
			,[property_detail_watermeter_location_text]
			,[property_detail_water_meter]
			,[property_detail_water_meter_number]
			,[property_detail_rubbish_bin_serial_number]
			,[property_detail_water_comment]
			,[property_detail_water_meter_location_name]
			,[synapse_link_sink_modified_on]
			,[DWHBatchId]
			,[DWHEffectiveFrom]
			,[DWHEffectiveTo]
			,[DWHIsCurrent]
			,[DWHSourceSystem]
			,[DWHDMLOperation]
			)
					select
				src.[property_detail_id] 
				, src.[property_detail_statecode] 
				, src.[property_detail_statuscode] 
				, src.[property_detail_crba8_gas_supply_type] 
				, src.[property_detail_crba8_no_of_bathrooms_no_toilet] 
				, src.[property_detail_crba8_no_of_bathrooms_with_toilet] 
				, src.[property_detail_accessibility] 
				, src.[property_detail_body_corporate_applies_indicator] 
				, src.[property_detail_cladding_type] 
				, src.[property_detail_construction_type] 
				, src.[property_detail_garage_1] 
				, src.[property_detail_hot_water_type] 
				, src.[property_detail_inspection_interval] 
				, src.[property_detail_inspection_type] 
				, src.[property_detail_no_of_bedrooms] 
				, src.[property_detail_no_of_carport] 
				, src.[property_detail_no_of_double_bedrooms] 
				, src.[property_detail_no_of_levels] 
				, src.[property_detail_no_of_single_bedrooms] 
				, src.[property_detail_no_of_toilets] 
				, src.[property_detail_no_parkingspaces] 
				, src.[property_detail_offstreet_parking] 
				, src.[property_detail_power] 
				, src.[property_detail_condition_rating] 
				, src.[property_detail_roof_type] 
				, src.[property_detail_sewerage] 
				, src.[property_detail_stove_type_new] 
				, src.[property_detail_tv_connection] 
				, src.[property_detail_water] 
				, src.[property_detail_crba8_external_gas_bottle_location] 
				, src.[property_detail_accessibility_summary] 
				, src.[property_detail_district_council_office] 
				, src.[property_detail_electricity_meter_location] 
				, src.[property_detail_electricity_supplier] 
				, src.[property_detail_floor_area] 
				, src.[property_detail_gas_meter_location] 
				, src.[property_detail_gas_supplier] 
				, src.[property_detail_icp_number] 
				, src.[property_detail_last_inspection_date] 
				, src.[property_detail_legal_description] 
				, src.[property_detail_location_of_circuit_board] 
				, src.[property_detail_next_inspection_date] 
				, src.[property_detail_online_date] 
				, src.[property_detail_pcr_last_updated_date] 
				, src.[property_detail_returned_date] 
				, src.[property_detail_tile_colour] 
				, src.[property_detail_tile_type] 
				, src.[property_detail_vinyl_colour] 
				, src.[property_detail_vinyl_specification] 
				, src.[property_detail_watermeter_location_text] 
				, src.[property_detail_water_meter] 
				, src.[property_detail_water_meter_number] 
				, src.[property_detail_rubbish_bin_serial_number] 
				, src.[property_detail_water_comment] 
				, src.[property_detail_water_meter_location_name] 
				, src.[synapse_link_sink_modified_on] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, '[Staging].[ODSETLdim_property_detail]'
				, 'U'
			from #SummaryOfChanges as base
				inner join [Staging].[ODSETLdim_property_detail] as src on src.[property_detail_id] = base.[property_detail_id]
			where base.[MergeAction] = 'UPDATE'

		union all

			select
				tbl.[property_detail_id] 
				, tbl.[property_detail_statecode] 
				, tbl.[property_detail_statuscode] 
				, tbl.[property_detail_crba8_gas_supply_type] 
				, tbl.[property_detail_crba8_no_of_bathrooms_no_toilet] 
				, tbl.[property_detail_crba8_no_of_bathrooms_with_toilet] 
				, tbl.[property_detail_accessibility] 
				, tbl.[property_detail_body_corporate_applies_indicator] 
				, tbl.[property_detail_cladding_type] 
				, tbl.[property_detail_construction_type] 
				, tbl.[property_detail_garage_1] 
				, tbl.[property_detail_hot_water_type] 
				, tbl.[property_detail_inspection_interval] 
				, tbl.[property_detail_inspection_type] 
				, tbl.[property_detail_no_of_bedrooms] 
				, tbl.[property_detail_no_of_carport] 
				, tbl.[property_detail_no_of_double_bedrooms] 
				, tbl.[property_detail_no_of_levels] 
				, tbl.[property_detail_no_of_single_bedrooms] 
				, tbl.[property_detail_no_of_toilets] 
				, tbl.[property_detail_no_parkingspaces] 
				, tbl.[property_detail_offstreet_parking] 
				, tbl.[property_detail_power] 
				, tbl.[property_detail_condition_rating] 
				, tbl.[property_detail_roof_type] 
				, tbl.[property_detail_sewerage] 
				, tbl.[property_detail_stove_type_new] 
				, tbl.[property_detail_tv_connection] 
				, tbl.[property_detail_water] 
				, tbl.[property_detail_crba8_external_gas_bottle_location] 
				, tbl.[property_detail_accessibility_summary] 
				, tbl.[property_detail_district_council_office] 
				, tbl.[property_detail_electricity_meter_location] 
				, tbl.[property_detail_electricity_supplier] 
				, tbl.[property_detail_floor_area] 
				, tbl.[property_detail_gas_meter_location] 
				, tbl.[property_detail_gas_supplier] 
				, tbl.[property_detail_icp_number] 
				, tbl.[property_detail_last_inspection_date] 
				, tbl.[property_detail_legal_description] 
				, tbl.[property_detail_location_of_circuit_board] 
				, tbl.[property_detail_next_inspection_date] 
				, tbl.[property_detail_online_date] 
				, tbl.[property_detail_pcr_last_updated_date] 
				, tbl.[property_detail_returned_date] 
				, tbl.[property_detail_tile_colour] 
				, tbl.[property_detail_tile_type] 
				, tbl.[property_detail_vinyl_colour] 
				, tbl.[property_detail_vinyl_specification] 
				, tbl.[property_detail_watermeter_location_text] 
				, tbl.[property_detail_water_meter] 
				, tbl.[property_detail_water_meter_number] 
				, tbl.[property_detail_rubbish_bin_serial_number] 
				, tbl.[property_detail_water_comment] 
				, tbl.[property_detail_water_meter_location_name] 
				, tbl.[synapse_link_sink_modified_on] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, '[Staging].[ODSETLdim_property_detail]'
				, 'D'
			from #SummaryOfChanges as base
				inner join [edw].[dim_property_detail] as tbl on tbl.[property_detail_id] = base.[property_detail_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
				left join [Staging].[ODSETLdim_property_detail] as src on src.[property_detail_id] = base.[property_detail_id]
			where base.[MergeAction] = 'UPDATE'
				and src.[property_detail_id] is null;
	end;

		-- Get process counts
		select
		@targetRecords = count(1) 
			, @insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			, @updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			, @deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
	from [edw].[dim_property_detail]
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