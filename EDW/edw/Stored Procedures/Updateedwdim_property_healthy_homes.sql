
/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property_healthy_homes]
 Author		Stefen Hasselberg
 Created	2024/01/11	
 Purpose		
				

				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
	
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-01-11	  Stefen Hasselberg		Initial version
2.0     2024-01-18	  Stefen Hasselberrg	Change audit column prefixes to DWH	


**********************************************************************************************************/



CREATE procedure [edw].[Updateedwdim_property_healthy_homes] 
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
	declare @SourceSystem nvarchar(120) = '[Staging].[ODSETLdim_property_healthy_homes]';

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
			 [property_healthy_homes_id] uniqueidentifier null
		,[MergeAction] varchar(10)
	);
	begin transaction;
	begin try

	   -- Insert a default records if table is empty
	   	   
	IF (
		NOT EXISTS (
			SELECT 1
			FROM [edw].[dim_property_healthy_homes]
			WHERE dim_property_healthy_homes_key <= 0
			)
		)
	BEGIN
		-- turn the identity insert on 
		SET IDENTITY_INSERT [edw].[dim_property_healthy_homes] ON
		INSERT INTO [edw].[dim_property_healthy_homes]
			   ( [dim_property_healthy_homes_key]
			   ,[property_healthy_homes_id]
			   ,[property_healthy_homes_statecode]
			   ,[property_healthy_homes_statuscode]
			   ,[property_healthy_homes_if_not_what_is_the_reason]
			   ,[property_healthy_homes_reason_for_kitchen_exemption]
			   ,[property_healthy_homes_are_the_exterior_walls_insulated]
			   ,[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door]
			   ,[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside]
			   ,[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside]
			   ,[property_healthy_homes_extent_of_underfloor_insulation]
			   ,[property_healthy_homes_have_all_open_fireplaces_been_blocked]
			   ,[property_healthy_homes_healthy_homes_compliance_statement]
			   ,[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason]
			   ,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes]
			   ,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor]
			   ,[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier]
			   ,[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation]
			   ,[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen]
			   ,[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason]
			   ,[property_healthy_homes_insulation_ceiling_condition]
			   ,[property_healthy_homes_insulation_ceiling_status]
			   ,[property_healthy_homes_insulation_ceiling_type]
			   ,[property_healthy_homes_insulation_in_wall_status]
			   ,[property_healthy_homes_insulation_under_floor_status]
			   ,[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor]
			   ,[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes]
			   ,[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage]
			   ,[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps]
			   ,[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant]
			   ,[property_healthy_homes_main_heatsource]
			   ,[property_healthy_homes_reason_for_ceiling_insulation_exemption]
			   ,[property_healthy_homes_reason_for_exemption_kitchen_ventilation]
			   ,[property_healthy_homes_reason_for_exemption_bathroom_ventilation]
			   ,[property_healthy_homes_secondary_heat_source]
			   ,[property_healthy_homes_type_of_insulation_underfloor]
			   ,[property_healthy_homes_type_of_insulation_wall]
			   ,[property_healthy_homes_underfloor_insulation_condition]
			   ,[property_healthy_homes_when_was_the_extraction_fan_installed]
			   ,[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation]
			   ,[property_healthy_homes_which_habitable_rooms_have_no_door_or_window]
			   ,[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard]
			   ,[property_healthy_homes_year_insulation_was_installed_if_known]
			   ,[property_healthy_homes_year_insulation_was_installed_if_known_underfloor]
			   ,[property_healthy_homes_year_insulation_was_installed_if_known_wall]
			   ,[property_healthy_homes_a_general_exemption_applies_to_this_property_flag]
			   ,[property_healthy_homes_ceiling_insulation_meets_standard_flag]
			   ,[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home]
			   ,[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit]
			   ,[property_healthy_homes_what_is_exhaust_capacity_of_unit]
			   ,[property_healthy_homes_date_insulation_was_last_inspected]
			   ,[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected]
			   ,[property_healthy_homes_compliance_date]
			   ,[property_healthy_homes_statement_date]
			   ,[property_healthy_homes_bathroom_vent_compliance_comments]
			   ,[property_healthy_homes_ceiling_compliance_comments]
			   ,[property_healthy_homes_draught_compliance_comments]
			   ,[property_healthy_homes_external_wall_compliance_comments]
			   ,[property_healthy_homes_habitable_rooms_compliance_comments]
			   ,[property_healthy_homes_heating_compliance_comments]
			   ,[property_healthy_homes_kitchen_vent_compliance_comments]
			   ,[property_healthy_homes_moist_drain_compliance_comments]
			   ,[property_healthy_homes_underfloor_compliance_comments]
			   ,[property_healthy_homes_kitchen_extraction_unit_diameter]
			   ,[property_healthy_homes_main_heat_source_capacity_kw]
			   ,[property_healthy_homes_required_heating_capacity_for_living_area_kw]
			   ,[property_healthy_homes_r_value_of_insulation]
			   ,[property_healthy_homes_r_value_of_insulation_underfloor]
			   ,[property_healthy_homes_r_value_of_insulation_wall]
			   ,[property_healthy_homes_secondaryheatsourcecapacitykw]
			   ,[property_healthy_homes_thickness_of_insulation]
			   ,[property_healthy_homes_extraction_unit_diameter]
			   ,[property_healthy_homes_is_delete_flag]
			   ,[synapse_link_sink_modified_on]
			   ,[DWHBatchId]
			   ,[DWHEffectiveFrom]
			   ,[DWHEffectiveTo]
			   ,[DWHDMLOperation]
			   ,[DWHIsCurrent]
			   ,[DWHSourceSystem])
		 VALUES
			   (0
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
			   , NULL
			   , NULL
			   , 'N/A'
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
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
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , NULL
			   , 0                           -- DWHBatchID
			   , @SystemDefaultEffectiveFrom -- DWHEffectiveFrom
			   , @SystemDefaultEffectiveTo   -- DWHEffectiveTo
			   , 'I'                         -- DWHDMLOperation
			   , 1                           -- DWHIsCurrent
			   , 'Unknown'                   -- DWHSourceID
			  ),
			  (    -1
			   ,  NULL
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
			   ,  NULL
			   ,  NULL
			   , 'Unknown'
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   , 'Unknown'
			   , 'Unknown'
			   , 'Unknown'
			   , 'Unknown'
			   , 'Unknown'
			   , 'Unknown'
			   , 'Unknown'
			   , 'Unknown'
			   , 'Unknown'
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  NULL
			   ,  0                          -- DWHBatchID
			   , @SystemDefaultEffectiveFrom -- DWHEffectiveFrom
		   , @SystemDefaultEffectiveTo   -- DWHEffectiveTo
			   , 'I'                         -- DWHDMLOperation
			   , 1                           -- DWHIsCurrent
			   , 'Unknown'                   -- DWHSourceID
			  )

		  		-- turn the identity insert off
		SET IDENTITY_INSERT [edw].[dim_property_healthy_homes] OFF
	
	END
		
		-- Do not run if there are no records in source
		select @stagedRecords = count(1) from [Staging].[ODSETLdim_property_healthy_homes];
		if( @stagedRecords = 0 )
		begin
			select 
				 @targetRecords = count(1) 
				,@deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			from [edw].[dim_property_healthy_homes];
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

		if( not exists (select top(1) 1 from [edw].[dim_property_healthy_homes]) )
		begin
			-- There are no records in the target; insert all
			insert into [edw].[dim_property_healthy_homes]
			(
				 [property_healthy_homes_id] 
				,[property_healthy_homes_statecode] 
				,[property_healthy_homes_statuscode] 
				,[property_healthy_homes_if_not_what_is_the_reason] 
				,[property_healthy_homes_reason_for_kitchen_exemption] 
				,[property_healthy_homes_are_the_exterior_walls_insulated] 
				,[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
				,[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
				,[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
				,[property_healthy_homes_extent_of_underfloor_insulation] 
				,[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
				,[property_healthy_homes_healthy_homes_compliance_statement] 
				,[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
				,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
				,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
				,[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
				,[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
				,[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
				,[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
				,[property_healthy_homes_insulation_ceiling_condition] 
				,[property_healthy_homes_insulation_ceiling_status] 
				,[property_healthy_homes_insulation_ceiling_type] 
				,[property_healthy_homes_insulation_in_wall_status] 
				,[property_healthy_homes_insulation_under_floor_status] 
				,[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
				,[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
				,[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
				,[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
				,[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
				,[property_healthy_homes_main_heatsource] 
				,[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
				,[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
				,[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
				,[property_healthy_homes_secondary_heat_source] 
				,[property_healthy_homes_type_of_insulation_underfloor] 
				,[property_healthy_homes_type_of_insulation_wall] 
				,[property_healthy_homes_underfloor_insulation_condition] 
				,[property_healthy_homes_when_was_the_extraction_fan_installed] 
				,[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
				,[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
				,[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
				,[property_healthy_homes_year_insulation_was_installed_if_known] 
				,[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
				,[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
				,[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
				,[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
				,[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
				,[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
				,[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
				,[property_healthy_homes_date_insulation_was_last_inspected] 
				,[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
				,[property_healthy_homes_compliance_date] 
				,[property_healthy_homes_statement_date] 
				,[property_healthy_homes_bathroom_vent_compliance_comments] 
				,[property_healthy_homes_ceiling_compliance_comments] 
				,[property_healthy_homes_draught_compliance_comments] 
				,[property_healthy_homes_external_wall_compliance_comments] 
				,[property_healthy_homes_habitable_rooms_compliance_comments] 
				,[property_healthy_homes_heating_compliance_comments] 
				,[property_healthy_homes_kitchen_vent_compliance_comments] 
				,[property_healthy_homes_moist_drain_compliance_comments] 
				,[property_healthy_homes_underfloor_compliance_comments] 
				,[property_healthy_homes_kitchen_extraction_unit_diameter] 
				,[property_healthy_homes_main_heat_source_capacity_kw] 
				,[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
				,[property_healthy_homes_r_value_of_insulation] 
				,[property_healthy_homes_r_value_of_insulation_underfloor] 
				,[property_healthy_homes_r_value_of_insulation_wall] 
				,[property_healthy_homes_secondaryheatsourcecapacitykw] 
				,[property_healthy_homes_thickness_of_insulation] 
				,[property_healthy_homes_extraction_unit_diameter] 
				,[property_healthy_homes_is_delete_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId] 
				,[DWHEffectiveFrom] 
				,[DWHEffectiveTo] 
				,[DWHDMLOperation] 
				,[DWHIsCurrent] 
				,[DWHSourceSystem] 
			)
			select
				 src.[property_healthy_homes_id] 
				,src.[property_healthy_homes_statecode] 
				,src.[property_healthy_homes_statuscode] 
				,src.[property_healthy_homes_if_not_what_is_the_reason] 
				,src.[property_healthy_homes_reason_for_kitchen_exemption] 
				,src.[property_healthy_homes_are_the_exterior_walls_insulated] 
				,src.[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
				,src.[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
				,src.[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
				,src.[property_healthy_homes_extent_of_underfloor_insulation] 
				,src.[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
				,src.[property_healthy_homes_healthy_homes_compliance_statement] 
				,src.[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
				,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
				,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
				,src.[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
				,src.[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
				,src.[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
				,src.[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
				,src.[property_healthy_homes_insulation_ceiling_condition] 
				,src.[property_healthy_homes_insulation_ceiling_status] 
				,src.[property_healthy_homes_insulation_ceiling_type] 
				,src.[property_healthy_homes_insulation_in_wall_status] 
				,src.[property_healthy_homes_insulation_under_floor_status] 
				,src.[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
				,src.[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
				,src.[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
				,src.[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
				,src.[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
				,src.[property_healthy_homes_main_heatsource] 
				,src.[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
				,src.[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
				,src.[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
				,src.[property_healthy_homes_secondary_heat_source] 
				,src.[property_healthy_homes_type_of_insulation_underfloor] 
				,src.[property_healthy_homes_type_of_insulation_wall] 
				,src.[property_healthy_homes_underfloor_insulation_condition] 
				,src.[property_healthy_homes_when_was_the_extraction_fan_installed] 
				,src.[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
				,src.[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
				,src.[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
				,src.[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
				,src.[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
				,src.[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
				,src.[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
				,src.[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
				,src.[property_healthy_homes_date_insulation_was_last_inspected] 
				,src.[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
				,src.[property_healthy_homes_compliance_date] 
				,src.[property_healthy_homes_statement_date] 
				,src.[property_healthy_homes_bathroom_vent_compliance_comments] 
				,src.[property_healthy_homes_ceiling_compliance_comments] 
				,src.[property_healthy_homes_draught_compliance_comments] 
				,src.[property_healthy_homes_external_wall_compliance_comments] 
				,src.[property_healthy_homes_habitable_rooms_compliance_comments] 
				,src.[property_healthy_homes_heating_compliance_comments] 
				,src.[property_healthy_homes_kitchen_vent_compliance_comments] 
				,src.[property_healthy_homes_moist_drain_compliance_comments] 
				,src.[property_healthy_homes_underfloor_compliance_comments] 
				,src.[property_healthy_homes_kitchen_extraction_unit_diameter] 
				,src.[property_healthy_homes_main_heat_source_capacity_kw] 
				,src.[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
				,src.[property_healthy_homes_r_value_of_insulation] 
				,src.[property_healthy_homes_r_value_of_insulation_underfloor] 
				,src.[property_healthy_homes_r_value_of_insulation_wall] 
				,src.[property_healthy_homes_secondaryheatsourcecapacitykw] 
				,src.[property_healthy_homes_thickness_of_insulation] 
				,src.[property_healthy_homes_extraction_unit_diameter] 
				,src.[property_healthy_homes_is_delete_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
			from [Staging].[ODSETLdim_property_healthy_homes] as src;
		end else begin
			-- Fetch the current high-water maximum values
			declare @synapse_link_sink_modified_on datetime2(7) = null;

			execute [edw].[GetHighwaterForedwdim_property_healthy_homes] @synapse_link_sink_modified_on output;

			merge into [edw].[dim_property_healthy_homes] as trg
			using 
			(
				select
				 src.[property_healthy_homes_id] 
				,src.[property_healthy_homes_statecode] 
				,src.[property_healthy_homes_statuscode] 
				,src.[property_healthy_homes_if_not_what_is_the_reason] 
				,src.[property_healthy_homes_reason_for_kitchen_exemption] 
				,src.[property_healthy_homes_are_the_exterior_walls_insulated] 
				,src.[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
				,src.[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
				,src.[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
				,src.[property_healthy_homes_extent_of_underfloor_insulation] 
				,src.[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
				,src.[property_healthy_homes_healthy_homes_compliance_statement] 
				,src.[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
				,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
				,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
				,src.[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
				,src.[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
				,src.[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
				,src.[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
				,src.[property_healthy_homes_insulation_ceiling_condition] 
				,src.[property_healthy_homes_insulation_ceiling_status] 
				,src.[property_healthy_homes_insulation_ceiling_type] 
				,src.[property_healthy_homes_insulation_in_wall_status] 
				,src.[property_healthy_homes_insulation_under_floor_status] 
				,src.[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
				,src.[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
				,src.[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
				,src.[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
				,src.[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
				,src.[property_healthy_homes_main_heatsource] 
				,src.[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
				,src.[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
				,src.[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
				,src.[property_healthy_homes_secondary_heat_source] 
				,src.[property_healthy_homes_type_of_insulation_underfloor] 
				,src.[property_healthy_homes_type_of_insulation_wall] 
				,src.[property_healthy_homes_underfloor_insulation_condition] 
				,src.[property_healthy_homes_when_was_the_extraction_fan_installed] 
				,src.[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
				,src.[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
				,src.[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
				,src.[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
				,src.[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
				,src.[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
				,src.[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
				,src.[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
				,src.[property_healthy_homes_date_insulation_was_last_inspected] 
				,src.[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
				,src.[property_healthy_homes_compliance_date] 
				,src.[property_healthy_homes_statement_date] 
				,src.[property_healthy_homes_bathroom_vent_compliance_comments] 
				,src.[property_healthy_homes_ceiling_compliance_comments] 
				,src.[property_healthy_homes_draught_compliance_comments] 
				,src.[property_healthy_homes_external_wall_compliance_comments] 
				,src.[property_healthy_homes_habitable_rooms_compliance_comments] 
				,src.[property_healthy_homes_heating_compliance_comments] 
				,src.[property_healthy_homes_kitchen_vent_compliance_comments] 
				,src.[property_healthy_homes_moist_drain_compliance_comments] 
				,src.[property_healthy_homes_underfloor_compliance_comments] 
				,src.[property_healthy_homes_kitchen_extraction_unit_diameter] 
				,src.[property_healthy_homes_main_heat_source_capacity_kw] 
				,src.[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
				,src.[property_healthy_homes_r_value_of_insulation] 
				,src.[property_healthy_homes_r_value_of_insulation_underfloor] 
				,src.[property_healthy_homes_r_value_of_insulation_wall] 
				,src.[property_healthy_homes_secondaryheatsourcecapacitykw] 
				,src.[property_healthy_homes_thickness_of_insulation] 
				,src.[property_healthy_homes_extraction_unit_diameter] 
				,src.[property_healthy_homes_is_delete_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID as [DWHBatchId]
				,convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				,convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				,'I' as [DWHDMLOperation]
				,1 as [DWHIsCurrent]
				,@SourceSystem as [DWHSourceSystem]
				from [Staging].[ODSETLdim_property_healthy_homes] as src
			) as src on (src.[property_healthy_homes_id] = trg.[property_healthy_homes_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				select src.[property_healthy_homes_statecode], src.[property_healthy_homes_statuscode], src.[property_healthy_homes_if_not_what_is_the_reason], src.[property_healthy_homes_reason_for_kitchen_exemption], src.[property_healthy_homes_are_the_exterior_walls_insulated], src.[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door], src.[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside], src.[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside], src.[property_healthy_homes_extent_of_underfloor_insulation], src.[property_healthy_homes_have_all_open_fireplaces_been_blocked], src.[property_healthy_homes_healthy_homes_compliance_statement], src.[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason], src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes], src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor], src.[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier], src.[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation], src.[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen], src.[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason], src.[property_healthy_homes_insulation_ceiling_condition], src.[property_healthy_homes_insulation_ceiling_status], src.[property_healthy_homes_insulation_ceiling_type], src.[property_healthy_homes_insulation_in_wall_status], src.[property_healthy_homes_insulation_under_floor_status], src.[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor], src.[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes], src.[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage], src.[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps], src.[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant], src.[property_healthy_homes_main_heatsource], src.[property_healthy_homes_reason_for_ceiling_insulation_exemption], src.[property_healthy_homes_reason_for_exemption_kitchen_ventilation], src.[property_healthy_homes_reason_for_exemption_bathroom_ventilation], src.[property_healthy_homes_secondary_heat_source], src.[property_healthy_homes_type_of_insulation_underfloor], src.[property_healthy_homes_type_of_insulation_wall], src.[property_healthy_homes_underfloor_insulation_condition], src.[property_healthy_homes_when_was_the_extraction_fan_installed], src.[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation], src.[property_healthy_homes_which_habitable_rooms_have_no_door_or_window], src.[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard], src.[property_healthy_homes_year_insulation_was_installed_if_known], src.[property_healthy_homes_year_insulation_was_installed_if_known_underfloor], src.[property_healthy_homes_year_insulation_was_installed_if_known_wall], src.[property_healthy_homes_a_general_exemption_applies_to_this_property_flag], src.[property_healthy_homes_ceiling_insulation_meets_standard_flag], src.[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home], src.[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit], src.[property_healthy_homes_what_is_exhaust_capacity_of_unit], src.[property_healthy_homes_date_insulation_was_last_inspected], src.[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected], src.[property_healthy_homes_compliance_date], src.[property_healthy_homes_statement_date], src.[property_healthy_homes_bathroom_vent_compliance_comments], src.[property_healthy_homes_ceiling_compliance_comments], src.[property_healthy_homes_draught_compliance_comments], src.[property_healthy_homes_external_wall_compliance_comments], src.[property_healthy_homes_habitable_rooms_compliance_comments], src.[property_healthy_homes_heating_compliance_comments], src.[property_healthy_homes_kitchen_vent_compliance_comments], src.[property_healthy_homes_moist_drain_compliance_comments], src.[property_healthy_homes_underfloor_compliance_comments], src.[property_healthy_homes_kitchen_extraction_unit_diameter], src.[property_healthy_homes_main_heat_source_capacity_kw], src.[property_healthy_homes_required_heating_capacity_for_living_area_kw], src.[property_healthy_homes_r_value_of_insulation], src.[property_healthy_homes_r_value_of_insulation_underfloor], src.[property_healthy_homes_r_value_of_insulation_wall], src.[property_healthy_homes_secondaryheatsourcecapacitykw], src.[property_healthy_homes_thickness_of_insulation], src.[property_healthy_homes_extraction_unit_diameter], src.[property_healthy_homes_is_delete_flag], src.[synapse_link_sink_modified_on], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
				except
				select trg.[property_healthy_homes_statecode], trg.[property_healthy_homes_statuscode], trg.[property_healthy_homes_if_not_what_is_the_reason], trg.[property_healthy_homes_reason_for_kitchen_exemption], trg.[property_healthy_homes_are_the_exterior_walls_insulated], trg.[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door], trg.[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside], trg.[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside], trg.[property_healthy_homes_extent_of_underfloor_insulation], trg.[property_healthy_homes_have_all_open_fireplaces_been_blocked], trg.[property_healthy_homes_healthy_homes_compliance_statement], trg.[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason], trg.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes], trg.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor], trg.[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier], trg.[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation], trg.[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen], trg.[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason], trg.[property_healthy_homes_insulation_ceiling_condition], trg.[property_healthy_homes_insulation_ceiling_status], trg.[property_healthy_homes_insulation_ceiling_type], trg.[property_healthy_homes_insulation_in_wall_status], trg.[property_healthy_homes_insulation_under_floor_status], trg.[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor], trg.[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes], trg.[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage], trg.[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps], trg.[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant], trg.[property_healthy_homes_main_heatsource], trg.[property_healthy_homes_reason_for_ceiling_insulation_exemption], trg.[property_healthy_homes_reason_for_exemption_kitchen_ventilation], trg.[property_healthy_homes_reason_for_exemption_bathroom_ventilation], trg.[property_healthy_homes_secondary_heat_source], trg.[property_healthy_homes_type_of_insulation_underfloor], trg.[property_healthy_homes_type_of_insulation_wall], trg.[property_healthy_homes_underfloor_insulation_condition], trg.[property_healthy_homes_when_was_the_extraction_fan_installed], trg.[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation], trg.[property_healthy_homes_which_habitable_rooms_have_no_door_or_window], trg.[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard], trg.[property_healthy_homes_year_insulation_was_installed_if_known], trg.[property_healthy_homes_year_insulation_was_installed_if_known_underfloor], trg.[property_healthy_homes_year_insulation_was_installed_if_known_wall], trg.[property_healthy_homes_a_general_exemption_applies_to_this_property_flag], trg.[property_healthy_homes_ceiling_insulation_meets_standard_flag], trg.[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home], trg.[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit], trg.[property_healthy_homes_what_is_exhaust_capacity_of_unit], trg.[property_healthy_homes_date_insulation_was_last_inspected], trg.[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected], trg.[property_healthy_homes_compliance_date], trg.[property_healthy_homes_statement_date], trg.[property_healthy_homes_bathroom_vent_compliance_comments], trg.[property_healthy_homes_ceiling_compliance_comments], trg.[property_healthy_homes_draught_compliance_comments], trg.[property_healthy_homes_external_wall_compliance_comments], trg.[property_healthy_homes_habitable_rooms_compliance_comments], trg.[property_healthy_homes_heating_compliance_comments], trg.[property_healthy_homes_kitchen_vent_compliance_comments], trg.[property_healthy_homes_moist_drain_compliance_comments], trg.[property_healthy_homes_underfloor_compliance_comments], trg.[property_healthy_homes_kitchen_extraction_unit_diameter], trg.[property_healthy_homes_main_heat_source_capacity_kw], trg.[property_healthy_homes_required_heating_capacity_for_living_area_kw], trg.[property_healthy_homes_r_value_of_insulation], trg.[property_healthy_homes_r_value_of_insulation_underfloor], trg.[property_healthy_homes_r_value_of_insulation_wall], trg.[property_healthy_homes_secondaryheatsourcecapacitykw], trg.[property_healthy_homes_thickness_of_insulation], trg.[property_healthy_homes_extraction_unit_diameter], trg.[property_healthy_homes_is_delete_flag], trg.[synapse_link_sink_modified_on], 'X'
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
					 [property_healthy_homes_id] 
					,[property_healthy_homes_statecode] 
					,[property_healthy_homes_statuscode] 
					,[property_healthy_homes_if_not_what_is_the_reason] 
					,[property_healthy_homes_reason_for_kitchen_exemption] 
					,[property_healthy_homes_are_the_exterior_walls_insulated] 
					,[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
					,[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
					,[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
					,[property_healthy_homes_extent_of_underfloor_insulation] 
					,[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
					,[property_healthy_homes_healthy_homes_compliance_statement] 
					,[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
					,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
					,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
					,[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
					,[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
					,[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
					,[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
					,[property_healthy_homes_insulation_ceiling_condition] 
					,[property_healthy_homes_insulation_ceiling_status] 
					,[property_healthy_homes_insulation_ceiling_type] 
					,[property_healthy_homes_insulation_in_wall_status] 
					,[property_healthy_homes_insulation_under_floor_status] 
					,[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
					,[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
					,[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
					,[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
					,[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
					,[property_healthy_homes_main_heatsource] 
					,[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
					,[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
					,[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
					,[property_healthy_homes_secondary_heat_source] 
					,[property_healthy_homes_type_of_insulation_underfloor] 
					,[property_healthy_homes_type_of_insulation_wall] 
					,[property_healthy_homes_underfloor_insulation_condition] 
					,[property_healthy_homes_when_was_the_extraction_fan_installed] 
					,[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
					,[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
					,[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
					,[property_healthy_homes_year_insulation_was_installed_if_known] 
					,[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
					,[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
					,[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
					,[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
					,[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
					,[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
					,[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
					,[property_healthy_homes_date_insulation_was_last_inspected] 
					,[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
					,[property_healthy_homes_compliance_date] 
					,[property_healthy_homes_statement_date] 
					,[property_healthy_homes_bathroom_vent_compliance_comments] 
					,[property_healthy_homes_ceiling_compliance_comments] 
					,[property_healthy_homes_draught_compliance_comments] 
					,[property_healthy_homes_external_wall_compliance_comments] 
					,[property_healthy_homes_habitable_rooms_compliance_comments] 
					,[property_healthy_homes_heating_compliance_comments] 
					,[property_healthy_homes_kitchen_vent_compliance_comments] 
					,[property_healthy_homes_moist_drain_compliance_comments] 
					,[property_healthy_homes_underfloor_compliance_comments] 
					,[property_healthy_homes_kitchen_extraction_unit_diameter] 
					,[property_healthy_homes_main_heat_source_capacity_kw] 
					,[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
					,[property_healthy_homes_r_value_of_insulation] 
					,[property_healthy_homes_r_value_of_insulation_underfloor] 
					,[property_healthy_homes_r_value_of_insulation_wall] 
					,[property_healthy_homes_secondaryheatsourcecapacitykw] 
					,[property_healthy_homes_thickness_of_insulation] 
					,[property_healthy_homes_extraction_unit_diameter] 
					,[property_healthy_homes_is_delete_flag] 
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
					 src.[property_healthy_homes_id] 
					,src.[property_healthy_homes_statecode] 
					,src.[property_healthy_homes_statuscode] 
					,src.[property_healthy_homes_if_not_what_is_the_reason] 
					,src.[property_healthy_homes_reason_for_kitchen_exemption] 
					,src.[property_healthy_homes_are_the_exterior_walls_insulated] 
					,src.[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
					,src.[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
					,src.[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
					,src.[property_healthy_homes_extent_of_underfloor_insulation] 
					,src.[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
					,src.[property_healthy_homes_healthy_homes_compliance_statement] 
					,src.[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
					,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
					,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
					,src.[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
					,src.[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
					,src.[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
					,src.[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
					,src.[property_healthy_homes_insulation_ceiling_condition] 
					,src.[property_healthy_homes_insulation_ceiling_status] 
					,src.[property_healthy_homes_insulation_ceiling_type] 
					,src.[property_healthy_homes_insulation_in_wall_status] 
					,src.[property_healthy_homes_insulation_under_floor_status] 
					,src.[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
					,src.[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
					,src.[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
					,src.[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
					,src.[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
					,src.[property_healthy_homes_main_heatsource] 
					,src.[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
					,src.[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
					,src.[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
					,src.[property_healthy_homes_secondary_heat_source] 
					,src.[property_healthy_homes_type_of_insulation_underfloor] 
					,src.[property_healthy_homes_type_of_insulation_wall] 
					,src.[property_healthy_homes_underfloor_insulation_condition] 
					,src.[property_healthy_homes_when_was_the_extraction_fan_installed] 
					,src.[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
					,src.[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
					,src.[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
					,src.[property_healthy_homes_year_insulation_was_installed_if_known] 
					,src.[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
					,src.[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
					,src.[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
					,src.[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
					,src.[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
					,src.[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
					,src.[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
					,src.[property_healthy_homes_date_insulation_was_last_inspected] 
					,src.[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
					,src.[property_healthy_homes_compliance_date] 
					,src.[property_healthy_homes_statement_date] 
					,src.[property_healthy_homes_bathroom_vent_compliance_comments] 
					,src.[property_healthy_homes_ceiling_compliance_comments] 
					,src.[property_healthy_homes_draught_compliance_comments] 
					,src.[property_healthy_homes_external_wall_compliance_comments] 
					,src.[property_healthy_homes_habitable_rooms_compliance_comments] 
					,src.[property_healthy_homes_heating_compliance_comments] 
					,src.[property_healthy_homes_kitchen_vent_compliance_comments] 
					,src.[property_healthy_homes_moist_drain_compliance_comments] 
					,src.[property_healthy_homes_underfloor_compliance_comments] 
					,src.[property_healthy_homes_kitchen_extraction_unit_diameter] 
					,src.[property_healthy_homes_main_heat_source_capacity_kw] 
					,src.[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
					,src.[property_healthy_homes_r_value_of_insulation] 
					,src.[property_healthy_homes_r_value_of_insulation_underfloor] 
					,src.[property_healthy_homes_r_value_of_insulation_wall] 
					,src.[property_healthy_homes_secondaryheatsourcecapacitykw] 
					,src.[property_healthy_homes_thickness_of_insulation] 
					,src.[property_healthy_homes_extraction_unit_diameter] 
					,src.[property_healthy_homes_is_delete_flag] 
					,src.[synapse_link_sink_modified_on] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_healthy_homes_id],inserted.[property_healthy_homes_id]), $action As [MergeAction] into #SummaryOfChanges;
		
			-- Insert new versions of previously updated records (Updates and Deletes)
			insert into [edw].[dim_property_healthy_homes]
			(
				 [property_healthy_homes_id] 
				,[property_healthy_homes_statecode] 
				,[property_healthy_homes_statuscode] 
				,[property_healthy_homes_if_not_what_is_the_reason] 
				,[property_healthy_homes_reason_for_kitchen_exemption] 
				,[property_healthy_homes_are_the_exterior_walls_insulated] 
				,[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
				,[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
				,[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
				,[property_healthy_homes_extent_of_underfloor_insulation] 
				,[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
				,[property_healthy_homes_healthy_homes_compliance_statement] 
				,[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
				,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
				,[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
				,[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
				,[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
				,[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
				,[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
				,[property_healthy_homes_insulation_ceiling_condition] 
				,[property_healthy_homes_insulation_ceiling_status] 
				,[property_healthy_homes_insulation_ceiling_type] 
				,[property_healthy_homes_insulation_in_wall_status] 
				,[property_healthy_homes_insulation_under_floor_status] 
				,[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
				,[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
				,[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
				,[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
				,[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
				,[property_healthy_homes_main_heatsource] 
				,[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
				,[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
				,[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
				,[property_healthy_homes_secondary_heat_source] 
				,[property_healthy_homes_type_of_insulation_underfloor] 
				,[property_healthy_homes_type_of_insulation_wall] 
				,[property_healthy_homes_underfloor_insulation_condition] 
				,[property_healthy_homes_when_was_the_extraction_fan_installed] 
				,[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
				,[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
				,[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
				,[property_healthy_homes_year_insulation_was_installed_if_known] 
				,[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
				,[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
				,[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
				,[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
				,[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
				,[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
				,[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
				,[property_healthy_homes_date_insulation_was_last_inspected] 
				,[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
				,[property_healthy_homes_compliance_date] 
				,[property_healthy_homes_statement_date] 
				,[property_healthy_homes_bathroom_vent_compliance_comments] 
				,[property_healthy_homes_ceiling_compliance_comments] 
				,[property_healthy_homes_draught_compliance_comments] 
				,[property_healthy_homes_external_wall_compliance_comments] 
				,[property_healthy_homes_habitable_rooms_compliance_comments] 
				,[property_healthy_homes_heating_compliance_comments] 
				,[property_healthy_homes_kitchen_vent_compliance_comments] 
				,[property_healthy_homes_moist_drain_compliance_comments] 
				,[property_healthy_homes_underfloor_compliance_comments] 
				,[property_healthy_homes_kitchen_extraction_unit_diameter] 
				,[property_healthy_homes_main_heat_source_capacity_kw] 
				,[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
				,[property_healthy_homes_r_value_of_insulation] 
				,[property_healthy_homes_r_value_of_insulation_underfloor] 
				,[property_healthy_homes_r_value_of_insulation_wall] 
				,[property_healthy_homes_secondaryheatsourcecapacitykw] 
				,[property_healthy_homes_thickness_of_insulation] 
				,[property_healthy_homes_extraction_unit_diameter] 
				,[property_healthy_homes_is_delete_flag] 
				,[synapse_link_sink_modified_on] 
				,[DWHBatchId]
				,[DWHEffectiveFrom]
				,[DWHEffectiveTo]
				,[DWHIsCurrent]
				,[DWHSourceSystem]
				,[DWHDMLOperation]
			)
			select
				 src.[property_healthy_homes_id] 
				,src.[property_healthy_homes_statecode] 
				,src.[property_healthy_homes_statuscode] 
				,src.[property_healthy_homes_if_not_what_is_the_reason] 
				,src.[property_healthy_homes_reason_for_kitchen_exemption] 
				,src.[property_healthy_homes_are_the_exterior_walls_insulated] 
				,src.[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
				,src.[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
				,src.[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
				,src.[property_healthy_homes_extent_of_underfloor_insulation] 
				,src.[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
				,src.[property_healthy_homes_healthy_homes_compliance_statement] 
				,src.[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
				,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
				,src.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
				,src.[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
				,src.[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
				,src.[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
				,src.[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
				,src.[property_healthy_homes_insulation_ceiling_condition] 
				,src.[property_healthy_homes_insulation_ceiling_status] 
				,src.[property_healthy_homes_insulation_ceiling_type] 
				,src.[property_healthy_homes_insulation_in_wall_status] 
				,src.[property_healthy_homes_insulation_under_floor_status] 
				,src.[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
				,src.[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
				,src.[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
				,src.[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
				,src.[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
				,src.[property_healthy_homes_main_heatsource] 
				,src.[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
				,src.[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
				,src.[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
				,src.[property_healthy_homes_secondary_heat_source] 
				,src.[property_healthy_homes_type_of_insulation_underfloor] 
				,src.[property_healthy_homes_type_of_insulation_wall] 
				,src.[property_healthy_homes_underfloor_insulation_condition] 
				,src.[property_healthy_homes_when_was_the_extraction_fan_installed] 
				,src.[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
				,src.[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
				,src.[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
				,src.[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
				,src.[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
				,src.[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
				,src.[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
				,src.[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
				,src.[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
				,src.[property_healthy_homes_date_insulation_was_last_inspected] 
				,src.[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
				,src.[property_healthy_homes_compliance_date] 
				,src.[property_healthy_homes_statement_date] 
				,src.[property_healthy_homes_bathroom_vent_compliance_comments] 
				,src.[property_healthy_homes_ceiling_compliance_comments] 
				,src.[property_healthy_homes_draught_compliance_comments] 
				,src.[property_healthy_homes_external_wall_compliance_comments] 
				,src.[property_healthy_homes_habitable_rooms_compliance_comments] 
				,src.[property_healthy_homes_heating_compliance_comments] 
				,src.[property_healthy_homes_kitchen_vent_compliance_comments] 
				,src.[property_healthy_homes_moist_drain_compliance_comments] 
				,src.[property_healthy_homes_underfloor_compliance_comments] 
				,src.[property_healthy_homes_kitchen_extraction_unit_diameter] 
				,src.[property_healthy_homes_main_heat_source_capacity_kw] 
				,src.[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
				,src.[property_healthy_homes_r_value_of_insulation] 
				,src.[property_healthy_homes_r_value_of_insulation_underfloor] 
				,src.[property_healthy_homes_r_value_of_insulation_wall] 
				,src.[property_healthy_homes_secondaryheatsourcecapacitykw] 
				,src.[property_healthy_homes_thickness_of_insulation] 
				,src.[property_healthy_homes_extraction_unit_diameter] 
				,src.[property_healthy_homes_is_delete_flag] 
				,src.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_healthy_homes]'
				,'U'
			from #SummaryOfChanges as base
			inner join [Staging].[ODSETLdim_property_healthy_homes] as src on src.[property_healthy_homes_id] = base.[property_healthy_homes_id]
			where base.[MergeAction] = 'UPDATE'

			union all 

			select
				 tbl.[property_healthy_homes_id] 
				,tbl.[property_healthy_homes_statecode] 
				,tbl.[property_healthy_homes_statuscode] 
				,tbl.[property_healthy_homes_if_not_what_is_the_reason] 
				,tbl.[property_healthy_homes_reason_for_kitchen_exemption] 
				,tbl.[property_healthy_homes_are_the_exterior_walls_insulated] 
				,tbl.[property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door] 
				,tbl.[property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside] 
				,tbl.[property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside] 
				,tbl.[property_healthy_homes_extent_of_underfloor_insulation] 
				,tbl.[property_healthy_homes_have_all_open_fireplaces_been_blocked] 
				,tbl.[property_healthy_homes_healthy_homes_compliance_statement] 
				,tbl.[property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason] 
				,tbl.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes] 
				,tbl.[property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor] 
				,tbl.[property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier] 
				,tbl.[property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation] 
				,tbl.[property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen] 
				,tbl.[property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason] 
				,tbl.[property_healthy_homes_insulation_ceiling_condition] 
				,tbl.[property_healthy_homes_insulation_ceiling_status] 
				,tbl.[property_healthy_homes_insulation_ceiling_type] 
				,tbl.[property_healthy_homes_insulation_in_wall_status] 
				,tbl.[property_healthy_homes_insulation_under_floor_status] 
				,tbl.[property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor] 
				,tbl.[property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes] 
				,tbl.[property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage] 
				,tbl.[property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps] 
				,tbl.[property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant] 
				,tbl.[property_healthy_homes_main_heatsource] 
				,tbl.[property_healthy_homes_reason_for_ceiling_insulation_exemption] 
				,tbl.[property_healthy_homes_reason_for_exemption_kitchen_ventilation] 
				,tbl.[property_healthy_homes_reason_for_exemption_bathroom_ventilation] 
				,tbl.[property_healthy_homes_secondary_heat_source] 
				,tbl.[property_healthy_homes_type_of_insulation_underfloor] 
				,tbl.[property_healthy_homes_type_of_insulation_wall] 
				,tbl.[property_healthy_homes_underfloor_insulation_condition] 
				,tbl.[property_healthy_homes_when_was_the_extraction_fan_installed] 
				,tbl.[property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation] 
				,tbl.[property_healthy_homes_which_habitable_rooms_have_no_door_or_window] 
				,tbl.[property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard] 
				,tbl.[property_healthy_homes_year_insulation_was_installed_if_known] 
				,tbl.[property_healthy_homes_year_insulation_was_installed_if_known_underfloor] 
				,tbl.[property_healthy_homes_year_insulation_was_installed_if_known_wall] 
				,tbl.[property_healthy_homes_a_general_exemption_applies_to_this_property_flag] 
				,tbl.[property_healthy_homes_ceiling_insulation_meets_standard_flag] 
				,tbl.[property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home] 
				,tbl.[property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit] 
				,tbl.[property_healthy_homes_what_is_exhaust_capacity_of_unit] 
				,tbl.[property_healthy_homes_date_insulation_was_last_inspected] 
				,tbl.[property_healthy_homes_date_the_underfloor_insulation_was_last_inspected] 
				,tbl.[property_healthy_homes_compliance_date] 
				,tbl.[property_healthy_homes_statement_date] 
				,tbl.[property_healthy_homes_bathroom_vent_compliance_comments] 
				,tbl.[property_healthy_homes_ceiling_compliance_comments] 
				,tbl.[property_healthy_homes_draught_compliance_comments] 
				,tbl.[property_healthy_homes_external_wall_compliance_comments] 
				,tbl.[property_healthy_homes_habitable_rooms_compliance_comments] 
				,tbl.[property_healthy_homes_heating_compliance_comments] 
				,tbl.[property_healthy_homes_kitchen_vent_compliance_comments] 
				,tbl.[property_healthy_homes_moist_drain_compliance_comments] 
				,tbl.[property_healthy_homes_underfloor_compliance_comments] 
				,tbl.[property_healthy_homes_kitchen_extraction_unit_diameter] 
				,tbl.[property_healthy_homes_main_heat_source_capacity_kw] 
				,tbl.[property_healthy_homes_required_heating_capacity_for_living_area_kw] 
				,tbl.[property_healthy_homes_r_value_of_insulation] 
				,tbl.[property_healthy_homes_r_value_of_insulation_underfloor] 
				,tbl.[property_healthy_homes_r_value_of_insulation_wall] 
				,tbl.[property_healthy_homes_secondaryheatsourcecapacitykw] 
				,tbl.[property_healthy_homes_thickness_of_insulation] 
				,tbl.[property_healthy_homes_extraction_unit_diameter] 
				,tbl.[property_healthy_homes_is_delete_flag] 
				,tbl.[synapse_link_sink_modified_on] 
				,@BatchID
				,@SystemEffectiveFrom
				,@SystemDefaultEffectiveTo
				,1
				,'[Staging].[ODSETLdim_property_healthy_homes]'
				,'D'
			from #SummaryOfChanges as base
			inner join [edw].[dim_property_healthy_homes] as tbl on tbl.[property_healthy_homes_id] = base.[property_healthy_homes_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
			left join [Staging].[ODSETLdim_property_healthy_homes] as src on src.[property_healthy_homes_id] = base.[property_healthy_homes_id]
			where base.[MergeAction] = 'UPDATE'
			and  src.[property_healthy_homes_id] is null;
		end;

		-- Get process counts
		select 
			 @targetRecords = count(1) 
			,@insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			,@updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			,@deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
		from [edw].[dim_property_healthy_homes]
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