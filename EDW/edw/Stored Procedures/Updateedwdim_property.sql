
CREATE procedure [edw].[Updateedwdim_property]

 /**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property]
 Author		Stefen Hasselberg
 Created	2024/01/11	
 Purpose				
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-01-11	  Stefen Hasselberg		Initial version
1.1     2024-01-18	  Stefen Hasselberrg	Change audit column prefixes to DWH	
1.2		2025-03-04	  Greg Nuthall		    Added service_code and bc service code
2.0     2026-02-26    Greg Nuthall          Simplified from 283 to 62 columns (WI 12210)
2.1     2026-03-06    Greg Nuthall          Added property_void_status column
2.2     2026-03-06    Greg Nuthall          Added back property_assigned_tenancy_manager
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
    declare @SourceSystem nvarchar(120) = 'zavanti.vw_zav_property';

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
        [property_id] uniqueidentifier null
		,
        [MergeAction] varchar(10)
    );
    begin transaction;
    begin try

	  -- Insert Default records if table is empty

		IF (
		NOT EXISTS (
			SELECT 1
    FROM [edw].[dim_property]
    WHERE dim_property_key <= 0
			)
		)
		BEGIN
        -- turn the identity insert on 
        SET IDENTITY_INSERT [edw].[dim_property] ON
        INSERT INTO [edw].[dim_property]
            (dim_property_key
            ,[property_id]
            ,[property_acquired_date]
            ,[property_bc_service_code]
            ,[property_bc_service_name]
            ,[property_city_name]
            ,[property_confirmed_disposal_date]
            ,[property_contract_bc_service]
            ,[property_contract_bc_service_code]
            ,[property_current_rent]
            ,[property_current_rent_base]
            ,[property_current_tenancy]
            ,[property_date_constructed]
            ,[property_days_available_to_let]
            ,[property_days_under_maintenence]
            ,[property_disposal_date]
            ,[property_district]
            ,[property_full_address]
            ,[property_gifted_name]
            ,[property_hud_msd_reference_number]
            ,[property_latitude]
            ,[property_legal_owner]
            ,[property_longitude]
            ,[property_name]
            ,[property_no_of_people_allowed_to_reside]
            ,[property_no_of_rooms]
            ,[property_owner_account]
            ,[property_owner_contact]
            ,[property_owner_organisation_contact_email]
            ,[property_parent_hierarchy]
            ,[property_postal_region]
            ,[property_postcode]
            ,[property_program]
            ,[property_property_manager]
            ,[property_property_manager_email]
            ,[property_property_manager_mobile_number]
            ,[property_property_ownership]
            ,[property_property_service_name]
            ,[property_property_service_code]
            ,[property_property_type]
            ,[property_provider_agreement_number]
            ,[property_reason_for_disposal]
            ,[property_reference_id]
            ,[property_relettable_date]
            ,[property_statecode]
            ,[property_status]
            ,[property_statuscode]
            ,[property_street_name]
            ,[property_street_number]
            ,[property_sub_program]
            ,[property_sub_property_type]
            ,[property_suburb]
            ,[property_target_group]
            ,[property_territory]
            ,[property_total_days_vacant]
            ,[property_total_heat_source_capacity_kw]
            ,[property_total_irrs]
            ,[property_total_irrs_base]
            ,[property_total_irrs_date]
            ,[property_total_irrs_state]
            ,[property_void_status]
            ,[property_transitional_housing_market_rent_base]
            ,[property_unit]
            ,[property_year_built]
            ,[property_zav_transitional_housing_market_rent]
            ,[synapse_link_sink_modified_on]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHDMLOperation]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem])
        VALUES
            -- N/A record (key = 0)
            (0                            -- dim_property_key
			, NULL                        -- property_id
			, NULL                        -- property_acquired_date
			, 'N/A'                       -- property_bc_service_code
			, 'N/A'                       -- property_bc_service_name
			, 'N/A'                       -- property_city_name
			, NULL                        -- property_confirmed_disposal_date
			, 'N/A'                       -- property_contract_bc_service
			, 'N/A'                       -- property_contract_bc_service_code
			, NULL                        -- property_current_rent (NUMERIC)
			, NULL                        -- property_current_rent_base (NUMERIC)
			, 'N/A'                       -- property_current_tenancy
			, NULL                        -- property_date_constructed
			, NULL                        -- property_days_available_to_let (INT)
			, NULL                        -- property_days_under_maintenence (INT)
			, NULL                        -- property_disposal_date
			, 'N/A'                       -- property_district
			, 'N/A'                       -- property_full_address
			, 'N/A'                       -- property_gifted_name
			, 'N/A'                       -- property_hud_msd_reference_number
			, NULL                        -- property_latitude (NUMERIC)
			, 'N/A'                       -- property_legal_owner
			, NULL                        -- property_longitude (NUMERIC)
			, 'N/A'                       -- property_name
			, NULL                        -- property_no_of_people_allowed_to_reside (INT)
			, 'N/A'                       -- property_no_of_rooms
			, 'N/A'                       -- property_owner_account
			, 'N/A'                       -- property_owner_contact
			, 'N/A'                       -- property_owner_organisation_contact_email
			, 'N/A'                       -- property_parent_hierarchy
			, 'N/A'                       -- property_postal_region
			, 'N/A'                       -- property_postcode
			, 'N/A'                       -- property_program
			, 'N/A'                       -- property_property_manager
			, 'N/A'                       -- property_property_manager_email
			, 'N/A'                       -- property_property_manager_mobile_number
			, 'N/A'                       -- property_property_ownership
			, 'N/A'                       -- property_property_service_name
			, 'N/A'                       -- property_property_service_code
			, 'N/A'                       -- property_type
			, 'N/A'                       -- property_provider_agreement_number
			, 'N/A'                       -- property_reason_for_disposal
			, 'N/A'                       -- property_reference_id
			, NULL                        -- property_relettable_date
			, 'N/A'                       -- property_statecode
			, 'N/A'                       -- property_status
			, 'N/A'                       -- property_statuscode
			, 'N/A'                       -- property_street_name
			, 'N/A'                       -- property_street_number
			, 'N/A'                       -- property_sub_program
			, 'N/A'                       -- property_sub_type
			, 'N/A'                       -- property_suburb
			, 'N/A'                       -- property_target_group
			, 'N/A'                       -- property_territory
			, NULL                        -- property_total_days_vacant (INT)
			, NULL                        -- property_total_heat_source_capacity_kw (NUMERIC)
			, NULL                        -- property_total_irrs (NUMERIC)
			, NULL                        -- property_total_irrs_base (NUMERIC)
			, NULL                        -- property_total_irrs_date
			, NULL                        -- property_total_irrs_state (INT)
			, 'N/A'                       -- property_void_status
			, NULL                        -- property_transitional_housing_market_rent_base (NUMERIC)
			, 'N/A'                       -- property_unit
			, 'N/A'                       -- property_year_built
			, NULL                        -- property_zav_transitional_housing_market_rent (NUMERIC)
			, NULL                        -- synapse_link_sink_modified_on
			, 0                           -- DWHBatchId
			, @SystemDefaultEffectiveFrom -- DWHEffectiveFrom
			, @SystemDefaultEffectiveTo   -- DWHEffectiveTo
			, 'I'                         -- DWHDMLOperation
			, 1                           -- DWHIsCurrent
			, 'N/A'                       -- DWHSourceSystem
			),
            -- Unknown record (key = -1)
            (-1                           -- dim_property_key
			, NULL                        -- property_id
			, NULL                        -- property_acquired_date
			, 'Unknown'                   -- property_bc_service_code
			, 'Unknown'                   -- property_bc_service_name
			, 'Unknown'                   -- property_city_name
			, NULL                        -- property_confirmed_disposal_date
			, 'Unknown'                   -- property_contract_bc_service
			, 'Unknown'                   -- property_contract_bc_service_code
			, NULL                        -- property_current_rent (NUMERIC)
			, NULL                        -- property_current_rent_base (NUMERIC)
			, 'Unknown'                   -- property_current_tenancy
			, NULL                        -- property_date_constructed
			, NULL                        -- property_days_available_to_let (INT)
			, NULL                        -- property_days_under_maintenence (INT)
			, NULL                        -- property_disposal_date
			, 'Unknown'                   -- property_district
			, 'Unknown'                   -- property_full_address
			, 'Unknown'                   -- property_gifted_name
			, 'Unknown'                   -- property_hud_msd_reference_number
			, NULL                        -- property_latitude (NUMERIC)
			, 'Unknown'                   -- property_legal_owner
			, NULL                        -- property_longitude (NUMERIC)
			, 'Unknown'                   -- property_name
			, NULL                        -- property_no_of_people_allowed_to_reside (INT)
			, 'Unknown'                   -- property_no_of_rooms
			, 'Unknown'                   -- property_owner_account
			, 'Unknown'                   -- property_owner_contact
			, 'Unknown'                   -- property_owner_organisation_contact_email
			, 'Unknown'                   -- property_parent_hierarchy
			, 'Unknown'                   -- property_postal_region
			, 'Unknown'                   -- property_postcode
			, 'Unknown'                   -- property_program
			, 'Unknown'                   -- property_property_manager
			, 'Unknown'                   -- property_property_manager_email
			, 'Unknown'                   -- property_property_manager_mobile_number
			, 'Unknown'                   -- property_property_ownership
			, 'Unknown'                   -- property_property_service_name
			, 'Unknown'                   -- property_property_service_code
			, 'Unknown'                   -- property_type
			, 'Unknown'                   -- property_provider_agreement_number
			, 'Unknown'                   -- property_reason_for_disposal
			, 'Unknown'                   -- property_reference_id
			, NULL                        -- property_relettable_date
			, 'Unknown'                   -- property_statecode
			, 'Unknown'                   -- property_status
			, 'Unknown'                   -- property_statuscode
			, 'Unknown'                   -- property_street_name
			, 'Unknown'                   -- property_street_number
			, 'Unknown'                   -- property_sub_program
			, 'Unknown'                   -- property_sub_type
			, 'Unknown'                   -- property_suburb
			, 'Unknown'                   -- property_target_group
			, 'Unknown'                   -- property_territory
			, NULL                        -- property_total_days_vacant (INT)
			, NULL                        -- property_total_heat_source_capacity_kw (NUMERIC)
			, NULL                        -- property_total_irrs (NUMERIC)
			, NULL                        -- property_total_irrs_base (NUMERIC)
			, NULL                        -- property_total_irrs_date
			, NULL                        -- property_total_irrs_state (INT)
			, 'Unknown'                   -- property_void_status
			, NULL                        -- property_transitional_housing_market_rent_base (NUMERIC)
			, 'Unknown'                   -- property_unit
			, 'Unknown'                   -- property_year_built
			, NULL                        -- property_zav_transitional_housing_market_rent (NUMERIC)
			, NULL                        -- synapse_link_sink_modified_on
			, 0                           -- DWHBatchId
			, @SystemDefaultEffectiveFrom -- DWHEffectiveFrom
			, @SystemDefaultEffectiveTo   -- DWHEffectiveTo
			, 'I'                         -- DWHDMLOperation
			, 1                           -- DWHIsCurrent
			, 'Unknown'                   -- DWHSourceSystem
			)

        -- turn the identity insert off
        SET IDENTITY_INSERT [edw].[dim_property] OFF

    end

		-- Do not run if there are no records in source
		select @stagedRecords = count(1)
    from [Staging].[ODSETLdim_property];
		if( @stagedRecords = 0 )
		begin
        select
            @targetRecords = count(1) 
				, @deletedRecords = sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
        from [edw].[dim_property];
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
    from [edw].[dim_property]) )
		begin
        -- There are no records in the target; insert all
        insert into [edw].[dim_property]
            (
            [property_id]
            ,[property_statecode]
            ,[property_statuscode]
            ,[property_acquired_date]
            ,[property_bc_service_name]
            ,[property_bc_service_code]
			,[property_assigned_tenancy_manager]
            ,[property_city_name]
            ,[property_confirmed_disposal_date]
            ,[property_contract_bc_service]
            ,[property_contract_bc_service_code]
            ,[property_current_rent]
            ,[property_current_rent_base]
            ,[property_current_tenancy]
            ,[property_date_constructed]
            ,[property_days_available_to_let]
            ,[property_days_under_maintenence]
            ,[property_disposal_date]
            ,[property_district]
            ,[property_full_address]
            ,[property_gifted_name]
            ,[property_hud_msd_reference_number]
            ,[property_latitude]
            ,[property_legal_owner]
            ,[property_longitude]
            ,[property_name]
            ,[property_no_of_people_allowed_to_reside]
            ,[property_no_of_rooms]
            ,[property_owner_account]
            ,[property_owner_contact]
            ,[property_owner_organisation_contact_email]
            ,[property_parent_hierarchy]
            ,[property_postal_region]
            ,[property_postcode]
            ,[property_program]
            ,[property_reference_id]
            ,[property_property_manager]
            ,[property_property_manager_email]
            ,[property_property_manager_mobile_number]
            ,[property_property_ownership]
            ,[property_property_service_name]
            ,[property_property_service_code]
            ,[property_property_type]
            ,[property_provider_agreement_number]
            ,[property_reason_for_disposal]
            ,[property_relettable_date]
            ,[property_status]
            ,[property_street_name]
            ,[property_street_number]
            ,[property_sub_program]
            ,[property_sub_property_type]
            ,[property_suburb]
            ,[property_target_group]
            ,[property_territory]
            ,[property_total_days_vacant]
            ,[property_total_heat_source_capacity_kw]
            ,[property_total_irrs]
            ,[property_total_irrs_base]
            ,[property_total_irrs_date]
            ,[property_total_irrs_state]
            ,[property_void_status]
            ,[property_transitional_housing_market_rent_base]
            ,[property_unit]
            ,[property_year_built]
            ,[property_zav_transitional_housing_market_rent]
            ,[synapse_link_sink_modified_on]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHDMLOperation]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            )
        select
            src.[property_id] 
				, src.[property_statecode] 
				, src.[property_statuscode] 
				, src.[property_acquired_date] 
				, src.[property_bc_service_name] 
				, src.[property_bc_service_code]
				, src.[property_assigned_tenancy_manager]
				, src.[property_city_name] 
				, src.[property_confirmed_disposal_date] 
				, src.[property_contract_bc_service]
				, src.[property_contract_bc_service_code]
				, src.[property_current_rent] 
				, src.[property_current_rent_base] 
				, src.[property_current_tenancy] 
				, src.[property_date_constructed] 
				, src.[property_days_available_to_let] 
				, src.[property_days_under_maintenence] 
				, src.[property_disposal_date] 
				, src.[property_district] 
				, src.[property_full_address] 
				, src.[property_gifted_name] 
				, src.[property_hud_msd_reference_number] 
				, src.[property_latitude] 
				, src.[property_legal_owner] 
				, src.[property_longitude] 
				, src.[property_name] 
				, src.[property_no_of_people_allowed_to_reside] 
				, src.[property_no_of_rooms] 
				, src.[property_owner_account] 
				, src.[property_owner_contact] 
				, src.[property_owner_organisation_contact_email] 
				, src.[property_parent_hierarchy] 
				, src.[property_postal_region] 
				, src.[property_postcode] 
				, src.[property_program] 
				, src.[property_reference_id] 
				, src.[property_property_manager] 
				, src.[property_property_manager_email] 
				, src.[property_property_manager_mobile_number] 
				, src.[property_property_ownership] 
				, src.[property_property_service_name] 
				, src.[property_property_service_code] 
				, src.[property_property_type] 
				, src.[property_provider_agreement_number] 
				, src.[property_reason_for_disposal] 
				, src.[property_relettable_date] 
				, src.[property_status] 
				, src.[property_street_name] 
				, src.[property_street_number] 
				, src.[property_sub_program] 
				, src.[property_sub_property_type] 
				, src.[property_suburb] 
				, src.[property_target_group] 
				, src.[property_territory] 
				, src.[property_total_days_vacant] 
				, src.[property_total_heat_source_capacity_kw] 
				, src.[property_total_irrs] 
				, src.[property_total_irrs_base] 
				, src.[property_total_irrs_date] 
				, src.[property_total_irrs_state] 
				, src.[property_void_status] 
				, src.[property_transitional_housing_market_rent_base] 
				, src.[property_unit] 
				, src.[property_year_built] 
				, src.[property_zav_transitional_housing_market_rent] 
				, src.[synapse_link_sink_modified_on] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
        from [Staging].[ODSETLdim_property] as src;
    end else begin
        -- Fetch the current high-water maximum values
        declare @synapse_link_sink_modified_on datetime2(7) = null;

        execute [edw].[GetHighwaterForedwdim_property] @synapse_link_sink_modified_on output;

        merge into [edw].[dim_property] as trg
			using 
			(
				select
            src.[property_id] 
				, src.[property_statecode] 
				, src.[property_statuscode] 
				, src.[property_acquired_date] 
				, src.[property_bc_service_name] 
				, src.[property_bc_service_code]
				, src.[property_assigned_tenancy_manager]
				, src.[property_city_name] 
				, src.[property_confirmed_disposal_date] 
				, src.[property_contract_bc_service] 
				, src.[property_contract_bc_service_code]
				, src.[property_current_rent] 
				, src.[property_current_rent_base] 
				, src.[property_current_tenancy] 
				, src.[property_date_constructed] 
				, src.[property_days_available_to_let] 
				, src.[property_days_under_maintenence] 
				, src.[property_disposal_date] 
				, src.[property_district] 
				, src.[property_full_address] 
				, src.[property_gifted_name] 
				, src.[property_hud_msd_reference_number] 
				, src.[property_latitude] 
				, src.[property_legal_owner] 
				, src.[property_longitude] 
				, src.[property_name] 
				, src.[property_no_of_people_allowed_to_reside] 
				, src.[property_no_of_rooms] 
				, src.[property_owner_account] 
				, src.[property_owner_contact] 
				, src.[property_owner_organisation_contact_email] 
				, src.[property_parent_hierarchy] 
				, src.[property_postal_region] 
				, src.[property_postcode] 
				, src.[property_program] 
				, src.[property_reference_id] 
				, src.[property_property_manager] 
				, src.[property_property_manager_email] 
				, src.[property_property_manager_mobile_number] 
				, src.[property_property_ownership] 
				, src.[property_property_service_name] 
				, src.[property_property_service_code] 
				, src.[property_property_type] 
				, src.[property_provider_agreement_number] 
				, src.[property_reason_for_disposal] 
				, src.[property_relettable_date] 
				, src.[property_status] 
				, src.[property_street_name] 
				, src.[property_street_number] 
				, src.[property_sub_program] 
				, src.[property_sub_property_type] 
				, src.[property_suburb] 
				, src.[property_target_group] 
				, src.[property_territory] 
				, src.[property_total_days_vacant] 
				, src.[property_total_heat_source_capacity_kw] 
				, src.[property_total_irrs] 
				, src.[property_total_irrs_base] 
				, src.[property_total_irrs_date] 
				, src.[property_total_irrs_state] 
				, src.[property_void_status] 
				, src.[property_transitional_housing_market_rent_base] 
				, src.[property_unit] 
				, src.[property_year_built] 
				, src.[property_zav_transitional_housing_market_rent] 
				, src.[synapse_link_sink_modified_on] 
				, @BatchID as [DWHBatchId]
				, convert(datetime,'1 January 1900') as [DWHEffectiveFrom]
				, convert(datetime,'31 December 2999 23:59:59') as [DWHEffectiveTo]
				, 'I' as [DWHDMLOperation]
				, 1 as [DWHIsCurrent]
				, @SourceSystem as [DWHSourceSystem]
        from [Staging].[ODSETLdim_property] as src
			) as src on (src.[property_id] = trg.[property_id] and trg.[DWHEffectiveTo] = @SystemDefaultEffectiveTo)			
			-- Retire existing records
			when matched and exists 
			( 
				            select src.[property_id], src.[property_statecode], src.[property_statuscode], src.[property_acquired_date], src.[property_bc_service_name], src.[property_bc_service_code], src.[property_assigned_tenancy_manager], src.[property_city_name], src.[property_confirmed_disposal_date], src.[property_contract_bc_service], src.[property_contract_bc_service_code], src.[property_current_rent], src.[property_current_rent_base], src.[property_current_tenancy], src.[property_date_constructed], src.[property_days_available_to_let], src.[property_days_under_maintenence], src.[property_disposal_date], src.[property_district], src.[property_full_address], src.[property_gifted_name], src.[property_hud_msd_reference_number], src.[property_latitude], src.[property_legal_owner], src.[property_longitude], src.[property_name], src.[property_no_of_people_allowed_to_reside], src.[property_no_of_rooms], src.[property_owner_account], src.[property_owner_contact], src.[property_owner_organisation_contact_email], src.[property_parent_hierarchy], src.[property_postal_region], src.[property_postcode], src.[property_program], src.[property_reference_id], src.[property_property_manager], src.[property_property_manager_email], src.[property_property_manager_mobile_number], src.[property_property_ownership], src.[property_property_service_name], src.[property_property_service_code], src.[property_property_type], src.[property_provider_agreement_number], src.[property_reason_for_disposal], src.[property_relettable_date], src.[property_status], src.[property_street_name], src.[property_street_number], src.[property_sub_program], src.[property_sub_property_type], src.[property_suburb], src.[property_target_group], src.[property_territory], src.[property_total_days_vacant], src.[property_total_heat_source_capacity_kw], src.[property_total_irrs], src.[property_total_irrs_base], src.[property_total_irrs_date], src.[property_total_irrs_state], src.[property_void_status], src.[property_transitional_housing_market_rent_base], src.[property_unit], src.[property_year_built], src.[property_zav_transitional_housing_market_rent], src.[synapse_link_sink_modified_on], case when trg.[DWHDMLOperation] = 'D' then 'U' else 'X' end
        except
            select trg.[property_id], trg.[property_statecode], trg.[property_statuscode], trg.[property_acquired_date], trg.[property_bc_service_name], trg.[property_bc_service_code], trg.[property_assigned_tenancy_manager], trg.[property_city_name], trg.[property_confirmed_disposal_date], trg.[property_contract_bc_service], trg.[property_contract_bc_service_code], trg.[property_current_rent], trg.[property_current_rent_base], trg.[property_current_tenancy], trg.[property_date_constructed], trg.[property_days_available_to_let], trg.[property_days_under_maintenence], trg.[property_disposal_date], trg.[property_district], trg.[property_full_address], trg.[property_gifted_name], trg.[property_hud_msd_reference_number], trg.[property_latitude], trg.[property_legal_owner], trg.[property_longitude], trg.[property_name], trg.[property_no_of_people_allowed_to_reside], trg.[property_no_of_rooms], trg.[property_owner_account], trg.[property_owner_contact], trg.[property_owner_organisation_contact_email], trg.[property_parent_hierarchy], trg.[property_postal_region], trg.[property_postcode], trg.[property_program], trg.[property_reference_id], trg.[property_property_manager], trg.[property_property_manager_email], trg.[property_property_manager_mobile_number], trg.[property_property_ownership], trg.[property_property_service_name], trg.[property_property_service_code], trg.[property_property_type], trg.[property_provider_agreement_number], trg.[property_reason_for_disposal], trg.[property_relettable_date], trg.[property_status], trg.[property_street_name], trg.[property_street_number], trg.[property_sub_program], trg.[property_sub_property_type], trg.[property_suburb], trg.[property_target_group], trg.[property_territory], trg.[property_total_days_vacant], trg.[property_total_heat_source_capacity_kw], trg.[property_total_irrs], trg.[property_total_irrs_base], trg.[property_total_irrs_date], trg.[property_total_irrs_state], trg.[property_void_status], trg.[property_transitional_housing_market_rent_base], trg.[property_unit], trg.[property_year_built], trg.[property_zav_transitional_housing_market_rent], trg.[synapse_link_sink_modified_on], 'X'
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
					 [property_id] 
					,[property_statecode] 
					,[property_statuscode] 
					,[property_acquired_date] 
					,[property_bc_service_name] 
					,[property_bc_service_code] 
					,[property_assigned_tenancy_manager]
					,[property_city_name] 
					,[property_confirmed_disposal_date] 
					,[property_contract_bc_service] 
					,[property_contract_bc_service_code]
					,[property_current_rent] 
					,[property_current_rent_base] 
					,[property_current_tenancy] 
					,[property_date_constructed] 
					,[property_days_available_to_let] 
					,[property_days_under_maintenence] 
					,[property_disposal_date] 
					,[property_district] 
					,[property_full_address] 
					,[property_gifted_name] 
					,[property_hud_msd_reference_number] 
					,[property_latitude] 
					,[property_legal_owner] 
					,[property_longitude] 
					,[property_name] 
					,[property_no_of_people_allowed_to_reside] 
					,[property_no_of_rooms] 
					,[property_owner_account] 
					,[property_owner_contact] 
					,[property_owner_organisation_contact_email] 
					,[property_parent_hierarchy] 
					,[property_postal_region] 
					,[property_postcode] 
					,[property_program] 
					,[property_reference_id] 
					,[property_property_manager] 
					,[property_property_manager_email] 
					,[property_property_manager_mobile_number] 
					,[property_property_ownership] 
					,[property_property_service_name]
					,[property_property_service_code] 
					,[property_property_type] 
					,[property_provider_agreement_number] 
					,[property_reason_for_disposal] 
					,[property_relettable_date] 
					,[property_status] 
					,[property_street_name] 
					,[property_street_number] 
					,[property_sub_program] 
					,[property_sub_property_type] 
					,[property_suburb] 
					,[property_target_group] 
					,[property_territory] 
					,[property_total_days_vacant] 
					,[property_total_heat_source_capacity_kw] 
					,[property_total_irrs] 
					,[property_total_irrs_base] 
					,[property_total_irrs_date] 
					,[property_total_irrs_state] 
					,[property_void_status] 
					,[property_transitional_housing_market_rent_base] 
					,[property_unit] 
					,[property_year_built] 
					,[property_zav_transitional_housing_market_rent] 
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
					 src.[property_id] 
					,src.[property_statecode] 
					,src.[property_statuscode] 
					,src.[property_acquired_date] 
					,src.[property_bc_service_name]
					,src.[property_bc_service_code]
					,src.[property_assigned_tenancy_manager]
					,src.[property_city_name] 
					,src.[property_confirmed_disposal_date] 
					,src.[property_contract_bc_service] 
					,src.[property_contract_bc_service_code]
					,src.[property_current_rent] 
					,src.[property_current_rent_base] 
					,src.[property_current_tenancy] 
					,src.[property_date_constructed] 
					,src.[property_days_available_to_let] 
					,src.[property_days_under_maintenence] 
					,src.[property_disposal_date] 
					,src.[property_district] 
					,src.[property_full_address] 
					,src.[property_gifted_name] 
					,src.[property_hud_msd_reference_number] 
					,src.[property_latitude] 
					,src.[property_legal_owner] 
					,src.[property_longitude] 
					,src.[property_name] 
					,src.[property_no_of_people_allowed_to_reside] 
					,src.[property_no_of_rooms] 
					,src.[property_owner_account] 
					,src.[property_owner_contact] 
					,src.[property_owner_organisation_contact_email] 
					,src.[property_parent_hierarchy] 
					,src.[property_postal_region] 
					,src.[property_postcode] 
					,src.[property_program] 
					,src.[property_reference_id] 
					,src.[property_property_manager] 
					,src.[property_property_manager_email] 
					,src.[property_property_manager_mobile_number] 
					,src.[property_property_ownership] 
					,src.[property_property_service_name]
					,src.[property_property_service_code] 
					,src.[property_property_type] 
					,src.[property_provider_agreement_number] 
					,src.[property_reason_for_disposal] 
					,src.[property_relettable_date] 
					,src.[property_status] 
					,src.[property_street_name] 
					,src.[property_street_number] 
					,src.[property_sub_program] 
					,src.[property_sub_property_type] 
					,src.[property_suburb] 
					,src.[property_target_group] 
					,src.[property_territory] 
					,src.[property_total_days_vacant] 
					,src.[property_total_heat_source_capacity_kw] 
					,src.[property_total_irrs] 
					,src.[property_total_irrs_base] 
					,src.[property_total_irrs_date] 
					,src.[property_total_irrs_state] 
					,src.[property_void_status] 
					,src.[property_transitional_housing_market_rent_base] 
					,src.[property_unit] 
					,src.[property_year_built] 
					,src.[property_zav_transitional_housing_market_rent] 
					,src.[synapse_link_sink_modified_on] 
					,src.[DWHBatchId] 
					,src.[DWHEffectiveFrom] 
					,src.[DWHEffectiveTo] 
					,src.[DWHDMLOperation] 
					,src.[DWHIsCurrent] 
					,src.[DWHSourceSystem] 
				)
			output  coalesce(src.[property_id],inserted.[property_id]), $action As [MergeAction] into #SummaryOfChanges;

        -- Insert new versions of previously updated records (Updates and Deletes)
        insert into [edw].[dim_property]
            (
            [property_id]
            ,[property_statecode]
            ,[property_statuscode]
            ,[property_acquired_date]
            ,[property_bc_service_name]
            ,[property_bc_service_code]
			,[property_assigned_tenancy_manager]
            ,[property_city_name]
            ,[property_confirmed_disposal_date]
            ,[property_contract_bc_service]
            ,[property_contract_bc_service_code]
            ,[property_current_rent]
            ,[property_current_rent_base]
            ,[property_current_tenancy]
            ,[property_date_constructed]
            ,[property_days_available_to_let]
            ,[property_days_under_maintenence]
            ,[property_disposal_date]
            ,[property_district]
            ,[property_full_address]
            ,[property_gifted_name]
            ,[property_hud_msd_reference_number]
            ,[property_latitude]
            ,[property_legal_owner]
            ,[property_longitude]
            ,[property_name]
            ,[property_no_of_people_allowed_to_reside]
            ,[property_no_of_rooms]
            ,[property_owner_account]
            ,[property_owner_contact]
            ,[property_owner_organisation_contact_email]
            ,[property_parent_hierarchy]
            ,[property_postal_region]
            ,[property_postcode]
            ,[property_program]
            ,[property_reference_id]
            ,[property_property_manager]
            ,[property_property_manager_email]
            ,[property_property_manager_mobile_number]
            ,[property_property_ownership]
            ,[property_property_service_name]
            ,[property_property_service_code]
            ,[property_property_type]
            ,[property_provider_agreement_number]
            ,[property_reason_for_disposal]
            ,[property_relettable_date]
            ,[property_status]
            ,[property_street_name]
            ,[property_street_number]
            ,[property_sub_program]
            ,[property_sub_property_type]
            ,[property_suburb]
            ,[property_target_group]
            ,[property_territory]
            ,[property_total_days_vacant]
            ,[property_total_heat_source_capacity_kw]
            ,[property_total_irrs]
            ,[property_total_irrs_base]
            ,[property_total_irrs_date]
            ,[property_total_irrs_state]
            ,[property_void_status]
            ,[property_transitional_housing_market_rent_base]
            ,[property_unit]
            ,[property_year_built]
            ,[property_zav_transitional_housing_market_rent]
            ,[synapse_link_sink_modified_on]
            ,[DWHBatchId]
            ,[DWHEffectiveFrom]
            ,[DWHEffectiveTo]
            ,[DWHIsCurrent]
            ,[DWHSourceSystem]
            ,[DWHDMLOperation]
            )
                    select
                src.[property_id] 
				, src.[property_statecode] 
				, src.[property_statuscode] 
				, src.[property_acquired_date] 
				, src.[property_bc_service_name]
				, src.[property_bc_service_code]
				, src.[property_assigned_tenancy_manager]
				, src.[property_city_name] 
				, src.[property_confirmed_disposal_date] 
				, src.[property_contract_bc_service] 
				, src.[property_contract_bc_service_code]
				, src.[property_current_rent] 
				, src.[property_current_rent_base] 
				, src.[property_current_tenancy] 
				, src.[property_date_constructed] 
				, src.[property_days_available_to_let] 
				, src.[property_days_under_maintenence] 
				, src.[property_disposal_date] 
				, src.[property_district] 
				, src.[property_full_address] 
				, src.[property_gifted_name] 
				, src.[property_hud_msd_reference_number] 
				, src.[property_latitude] 
				, src.[property_legal_owner] 
				, src.[property_longitude] 
				, src.[property_name] 
				, src.[property_no_of_people_allowed_to_reside] 
				, src.[property_no_of_rooms] 
				, src.[property_owner_account] 
				, src.[property_owner_contact] 
				, src.[property_owner_organisation_contact_email] 
				, src.[property_parent_hierarchy] 
				, src.[property_postal_region] 
				, src.[property_postcode] 
				, src.[property_program] 
				, src.[property_reference_id] 
				, src.[property_property_manager] 
				, src.[property_property_manager_email] 
				, src.[property_property_manager_mobile_number] 
				, src.[property_property_ownership] 
				, src.[property_property_service_name]
				, src.[property_property_service_code] 
				, src.[property_property_type] 
				, src.[property_provider_agreement_number] 
				, src.[property_reason_for_disposal] 
				, src.[property_relettable_date] 
				, src.[property_status] 
				, src.[property_street_name] 
				, src.[property_street_number] 
				, src.[property_sub_program] 
				, src.[property_sub_property_type] 
				, src.[property_suburb] 
				, src.[property_target_group] 
				, src.[property_territory] 
				, src.[property_total_days_vacant] 
				, src.[property_total_heat_source_capacity_kw] 
				, src.[property_total_irrs] 
				, src.[property_total_irrs_base] 
				, src.[property_total_irrs_date] 
				, src.[property_total_irrs_state] 
				, src.[property_void_status] 
				, src.[property_transitional_housing_market_rent_base] 
				, src.[property_unit] 
				, src.[property_year_built] 
				, src.[property_zav_transitional_housing_market_rent] 
				, src.[synapse_link_sink_modified_on] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, 'zavanti.vw_zav_property'
				, 'U'
            from #SummaryOfChanges as base
                inner join [Staging].[ODSETLdim_property] as src on src.[property_id] = base.[property_id]
            where base.[MergeAction] = 'UPDATE'

        union all

            select
                tbl.[property_id] 
				, tbl.[property_statecode] 
				, tbl.[property_statuscode] 
				, tbl.[property_acquired_date] 
				, tbl.[property_bc_service_name]
				, tbl.[property_bc_service_code]
				, tbl.[property_assigned_tenancy_manager]
				, tbl.[property_city_name] 
				, tbl.[property_confirmed_disposal_date] 
				, tbl.[property_contract_bc_service] 
				, tbl.[property_contract_bc_service_code]
				, tbl.[property_current_rent] 
				, tbl.[property_current_rent_base] 
				, tbl.[property_current_tenancy] 
				, tbl.[property_date_constructed] 
				, tbl.[property_days_available_to_let] 
				, tbl.[property_days_under_maintenence] 
				, tbl.[property_disposal_date] 
				, tbl.[property_district] 
				, tbl.[property_full_address] 
				, tbl.[property_gifted_name] 
				, tbl.[property_hud_msd_reference_number] 
				, tbl.[property_latitude] 
				, tbl.[property_legal_owner] 
				, tbl.[property_longitude] 
				, tbl.[property_name] 
				, tbl.[property_no_of_people_allowed_to_reside] 
				, tbl.[property_no_of_rooms] 
				, tbl.[property_owner_account] 
				, tbl.[property_owner_contact] 
				, tbl.[property_owner_organisation_contact_email] 
				, tbl.[property_parent_hierarchy] 
				, tbl.[property_postal_region] 
				, tbl.[property_postcode] 
				, tbl.[property_program] 
				, tbl.[property_reference_id] 
				, tbl.[property_property_manager] 
				, tbl.[property_property_manager_email] 
				, tbl.[property_property_manager_mobile_number] 
				, tbl.[property_property_ownership] 
				, tbl.[property_property_service_name]
				, tbl.[property_property_service_code]
				, tbl.[property_property_type] 
				, tbl.[property_provider_agreement_number] 
				, tbl.[property_reason_for_disposal] 
				, tbl.[property_relettable_date] 
				, tbl.[property_status] 
				, tbl.[property_street_name] 
				, tbl.[property_street_number] 
				, tbl.[property_sub_program] 
				, tbl.[property_sub_property_type] 
				, tbl.[property_suburb] 
				, tbl.[property_target_group] 
				, tbl.[property_territory] 
				, tbl.[property_total_days_vacant] 
				, tbl.[property_total_heat_source_capacity_kw] 
				, tbl.[property_total_irrs] 
				, tbl.[property_total_irrs_base] 
				, tbl.[property_total_irrs_date] 
				, tbl.[property_total_irrs_state] 
				, tbl.[property_void_status] 
				, tbl.[property_transitional_housing_market_rent_base] 
				, tbl.[property_unit] 
				, tbl.[property_year_built] 
				, tbl.[property_zav_transitional_housing_market_rent] 
				, tbl.[synapse_link_sink_modified_on] 
				, @BatchID
				, @SystemEffectiveFrom
				, @SystemDefaultEffectiveTo
				, 1
				, 'zavanti.vw_zav_property'
				, 'D'
            from #SummaryOfChanges as base
                inner join [edw].[dim_property] as tbl on tbl.[property_id] = base.[property_id] and tbl.[DWHEffectiveTo] = @SystemEffectiveTo
                left join [Staging].[ODSETLdim_property] as src on src.[property_id] = base.[property_id]
            where base.[MergeAction] = 'UPDATE'
                and src.[property_id] is null;
    end;

		-- Get process counts
		select
        @targetRecords = count(1) 
			, @insertedRecords = sum( case when [DWHDMLOperation] = 'I' and [DWHBatchId] = @BatchID then 1 else 0 end)
			, @updatedRecords = isnull(@updatedRecords,0) + sum( case when [DWHDMLOperation] = 'U' and [DWHBatchId] = @BatchID  then 1 else 0 end)
			, @deletedRecords =  sum( case when [DWHDMLOperation] = 'D' and [DWHBatchId] = @BatchID  then 1 else 0 end)
    from [edw].[dim_property]
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