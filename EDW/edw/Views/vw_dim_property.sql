
CREATE VIEW [edw].[vw_dim_property]

AS
    
/***************************************************************************
View		 [edw].[vw_dim_property]
Author		 Glenn McLeod
Created		 2024-01-16
Purpose		 Current records view for dim_property
Notes		 Returns only current, non-deleted records

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-01-16    Glenn McLeod		Initial creation
1.1      2026-02-20    GitHub Copilot   Removed redundant columns per work item 12210
1.2      2026-09-10    Greg Nuthall     Removed PII data columns
****************************************************************************/


    SELECT dim_property_key
	, property_id
	, property_acquired_date
	, property_bc_service_code
	, property_bc_service_name
	, property_assigned_tenancy_manager
	, property_confirmed_disposal_date
	, property_contract_bc_service as property_contract_bc_service_name
	--, property_contract_bc_service
	, property_contract_bc_service_code
	, property_current_rent
	, property_current_rent_base
	, '' as property_current_tenancy
	, property_date_constructed
	, property_days_available_to_let
	, property_days_under_maintenence
	, property_disposal_date
	, property_district
	, property_full_address
	, property_gifted_name
	, property_hud_msd_reference_number
	, property_latitude
	, property_legal_owner
	, property_longitude
	, property_name
	, property_no_of_people_allowed_to_reside
	, property_no_of_rooms
	, '' as property_owner_account
	, '' as property_owner_contact
	, '' as property_owner_organisation_contact_email
	, property_parent_hierarchy
	, property_postal_region
	, property_postcode
	, property_program
	, '' as property_property_manager
	, '' as property_property_manager_email
	, '' as property_property_manager_mobile_number
	, property_property_ownership
	, property_property_type
	, property_provider_agreement_number
	, property_reason_for_disposal
	, property_reference_id
	, property_relettable_date
	, property_statecode
	, property_status
	, property_statuscode
	, property_street_name
	, property_street_number
	, property_sub_program
	, property_sub_property_type
	, property_suburb
	, property_city_name
	, property_target_group
	, property_territory
	, property_total_days_vacant
	, property_total_heat_source_capacity_kw
	, property_total_irrs
	, property_total_irrs_base
	, property_total_irrs_date
	, property_total_irrs_state
	, property_void_status
	, property_transitional_housing_market_rent_base
	, property_unit
	, property_year_built
	, property_zav_transitional_housing_market_rent
	, synapse_link_sink_modified_on
	, DWHBatchId
	, DWHEffectiveFrom
	, DWHEffectiveTo
	, DWHDMLOperation
	, DWHIsCurrent
	, DWHSourceSystem
    FROM [edw].[dim_property]


	  --SELECT
   --     dim_property_key AS [Dim Property KEY],
   --     property_id AS [Property ID],
   --     property_acquired_date AS [Acquired Date],
   --     property_bc_service_code AS [Property Service Code],
   --     property_bc_service_name AS [Property Service Name],
   --     property_confirmed_disposal_date AS [Confirmed Disposal Date],
   --     property_contract_bc_service AS [Contract Service Name],
   --     property_contract_bc_service_code AS [Contract Service Code],
   --     property_current_rent AS [Current Rent],
   --     property_current_rent_base AS [Current Rent (Base)],
   --     property_current_tenancy AS [Tenant Name],
   --     property_date_constructed AS [Date Constructed],
   --     property_days_available_to_let AS [Days Available To Let],
   --     property_days_under_maintenence AS [Days Under Maintenance],
   --     property_disposal_date AS [Disposal Date],
   --     property_district AS [Service District],
   --     property_full_address AS [Full Address],
   --     property_gifted_name AS [Gifted Name],
   --     property_hud_msd_reference_number AS [BOS/HUD Ref],
   --     property_latitude AS [Latitude],
   --     property_legal_owner AS [Legal Owner Account],
   --     property_longitude AS [Longitude],
   --     property_name AS [Property Name],
   --     property_no_of_people_allowed_to_reside AS [Maximum People Allowed To Reside],
   --     property_no_of_rooms AS [Room Number],
   --     property_owner_account AS [Owner Account Name],
   --     property_owner_contact AS [Owner Full Name],
   --     property_owner_organisation_contact_email AS [Owner Email],
   --     property_parent_hierarchy AS [Parent Property Name],
   --     property_postal_region AS [Service Region],
   --     property_postcode AS [Postal Code],
   --     property_program AS [Program],
   --     property_property_manager AS [Property Manager Name],
   --     property_property_manager_email AS [Property Manager Email],
   --     property_property_manager_mobile_number AS [Property Manager Mobile],
   --     property_property_ownership AS [Ownership Type],
   --     property_property_type AS [Property Type],
   --     property_provider_agreement_number AS [Provider Agreement Number],
   --     property_reason_for_disposal AS [Reason For Disposal],
   --     property_reference_id AS [Property Ref],
   --     property_relettable_date AS [Relettable Date],
   --     property_statecode AS [State],
   --     property_status AS [Status],
   --     property_statuscode AS [Status Code],
   --     property_street_name AS [Street Name],
   --     property_street_number AS [Street Number],
   --     property_sub_program AS [Sub Program],
   --     property_sub_property_type AS [Property Sub Type],
   --     property_suburb AS [Suburb],
   --     property_city_name AS [City],
   --     property_target_group AS [Housing Group],
   --     property_territory AS [District Name],
   --     property_total_days_vacant AS [Total Days Vacant],
   --     property_total_heat_source_capacity_kw AS [Total Heat Source Capacity (Kw)],
   --     property_total_irrs AS [Total IRRS],
   --     property_total_irrs_base AS [Total IRRS (Base)],
   --     property_total_irrs_date AS [Total IRRS (Last Updated On)],
   --     property_total_irrs_state AS [Total IRRS (State)],
   --     property_void_status AS [Void Status],
   --     property_transitional_housing_market_rent_base AS [Transitional Housing Market Rent (Base)],
   --     property_unit AS [Unit],
   --     property_year_built AS [Built Year],
   --     property_zav_transitional_housing_market_rent AS [Transitional Housing Market Rent],
   --     DWHDMLOperation AS [DWH DML Operation],
   --     DWHIsCurrent AS [DWH Is Current]
   -- FROM edw.dim_property
   -- WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'