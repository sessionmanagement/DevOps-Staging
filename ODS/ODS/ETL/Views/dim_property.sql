/****** Object:  View [ETL].[dim_property]    Script Date: 24/03/2026 10:19:49 am ******/
CREATE     VIEW [ETL].[dim_property]

as

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property]
 Author		Glenn McLeod
 Created	2024-01-11	
 Purpose	Updates dim_property from staging
		
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-01-11	  Glenn McLeod			Initial version
1.1     2025-05-12    Manish Singh			Changing UTC date column to NZT
2.0     2026-02-26    Greg Nuthall			Removed 208 columns as per work item 12210 - keeping only 63 business columns
2.1     2026-03-10    Greg Nuthall			Added clause to remove properties with p.zav_propertyid is null	
2.2     2026-03-24    Greg Nuthall			Added back property_assigned_tenancy_manager
**********************************************************************************************************/

	-- Simplified CTEs for the reduced column set
	WITH
		global_options_cte
		as
		(
			SELECT
				Id
	, CAST(s.LocalizedLabel as VARCHAR(10)) as property_statecode
	, CAST(ss.LocalizedLabel as VARCHAR(10)) as property_statuscode
	, CAST(g_opt_10.LocalizedLabel as VARCHAR(50)) as property_status  
	, CAST(g_opt_79.LocalizedLabel as VARCHAR(20)) as property_property_ownership  
	, CAST(g_opt_94.LocalizedLabel as VARCHAR(50)) as property_target_group  
	, CAST(g_opt_12.LocalizedLabel as VARCHAR(10)) as property_year_built
	, CAST(g_opt_101.LocalizedLabel as VARCHAR(50)) as property_void_status

			FROM Zavanti.vw_zav_property as p
				left join Zavanti.vw_StateMetadata as s on p.statecode = s.State and s.EntityName = 'zav_property'
				left join Zavanti.vw_StatusMetadata as ss on p.statuscode = ss.[Status] and ss.EntityName = 'zav_property'
				left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_10 on p.new_propertystatus = g_opt_10.[Option] and g_opt_10.OptionSetName = 'new_propertystatus' and g_opt_10.EntityName = 'zav_property'
				left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_79 on p.zav_propertyownership = g_opt_79.[Option] and g_opt_79.OptionSetName = 'zav_propertyownership' and g_opt_79.EntityName = 'zav_property'
				left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_94 on p.zav_targetgroup = g_opt_94.[Option] and g_opt_94.OptionSetName = 'zav_targetgroup' and g_opt_94.EntityName = 'zav_property'
				left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_12 on p.new_yearbuilt = g_opt_12.[Option] and g_opt_12.OptionSetName = 'new_yearbuilt' and g_opt_12.EntityName = 'zav_property'
				left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_101 
					on p.zav_voidstatus = g_opt_101.[Option] 
					and g_opt_101.OptionSetName = 'zav_voidstatus' 
					and g_opt_101.EntityName = 'zav_property' 
		),

		-- because the methstatusevidence column contains multiple enties i had to split the data then join it to the OptionSetMetadata to get text value
		-- before joinging it back together again

		--methstatusevidence_cte as (

		--	SELECT
		--		Id
		--		, STRING_AGG(CONVERT(NVARCHAR(MAX), LocalizedLabel), ' | ') as zav_methstatusevidence
		--		FROM (
		--			SELECT
		--			Id
		--			, value
		--			, opt.LocalizedLabel
		--			FROM Zavanti.vw_zav_property
		--				CROSS APPLY STRING_SPLIT(zav_methstatusevidence, ';') as p
		--			left join Zavanti.vw_OptionsetMetadata as opt on p.value = opt.[Option] and  opt.OptionSetName = 'zav_methstatusevidence' and opt.EntityName = 'zav_property'
		--			WHERE zav_methstatusevidence is not null
		--			) as x
		--	GROUP BY Id
		--)

		--, local_options_cte as (
		--	SELECT
		--	Id 
		--	, CAST(opt_26.LocalizedLabel as VARCHAR(20)) as property_fire_evacuation  
		--	, CAST(opt_28.LocalizedLabel as VARCHAR(50)) as property_fire_extinguisher_responsibility 
		--	, CAST(opt_58.LocalizedLabel as VARCHAR(10) ) as property_key_status  
		--	, CAST(opt_63.LocalizedLabel as VARCHAR(50)) as property_meth_status  
		--	, CAST(opt_64.LocalizedLabel as VARCHAR(50)) as property_meth_status_on_entry  
		--	, CAST(opt_65.LocalizedLabel as VARCHAR(20)) as property_meth_test_type  
		--	, CAST(opt_77.LocalizedLabel as VARCHAR(50)) as property_property_classification  
		--	, CAST(opt_91.LocalizedLabel as VARCHAR(20)) as property_smoke_detector_type  
		--	from Zavanti.vw_zav_property as p
		--	left join Zavanti.vw_OptionsetMetadata as opt_26 on p.zav_fireevacuation = opt_26.[Option] and opt_26.OptionSetName = 'zav_fireevacuation' and opt_26.EntityName = 'zav_property' 
		--	left join Zavanti.vw_OptionsetMetadata as opt_28 on p.zav_fireextinguisherresponsibility = opt_28.[Option] and opt_28.OptionSetName = 'zav_fireextinguisherresponsibility' and opt_28.EntityName = 'zav_property' 
		--	left join Zavanti.vw_OptionsetMetadata as opt_58 on p.zav_keystatus = opt_58.[Option] and opt_58.OptionSetName = 'zav_keystatus' and opt_58.EntityName = 'zav_property' 
		--	left join Zavanti.vw_OptionsetMetadata as opt_77 on p.zav_propertyclassification = opt_77.[Option] and opt_77.OptionSetName = 'zav_propertyclassification' and opt_77.EntityName = 'zav_property' 
		--	left join Zavanti.vw_OptionsetMetadata as opt_91 on p.zav_smokedetectortype = opt_91.[Option] and opt_91.OptionSetName = 'zav_smokedetectortype' and opt_91.EntityName = 'zav_property' 
		--	left join Zavanti.vw_OptionsetMetadata as opt_63 on p.zav_methstatus = opt_63.[Option] and opt_63.OptionSetName = 'zav_methstatus' and opt_63.EntityName = 'zav_property' 
		--	left join Zavanti.vw_OptionsetMetadata as opt_64 on p.zav_methstatusonentry = opt_64.[Option] and opt_64.OptionSetName = 'zav_methstatusonentry' and opt_64.EntityName = 'zav_property' 
		--	left join Zavanti.vw_OptionsetMetadata as opt_65 on p.zav_methtesttype = opt_65.[Option] and opt_65.OptionSetName = 'zav_methtesttype' and opt_65.EntityName = 'zav_property' 
		--)


		property_other_cte
		as
		(
			SELECT
				p.Id as property_id
				, CAST(pc.zav_name as VARCHAR(50)) as property_city_name	
				, sn_contract.zav_name as property_contract_bc_service
				, sn_contract.zav_code as property_contract_bc_service_code	
				, CAST(o.name as VARCHAR(250)) as property_current_tenancy 
				, CAST(a_3.name as VARCHAR(250)) as property_legal_owner
				, pg.zav_name as property_program 
				, p.zav_propertybcservicenamename as  property_bc_service_name
				, sn_property.zav_code as property_bc_service_code
				, CAST(u.fullname as VARCHAR(250)) as property_assigned_tenancy_manager 
				, CAST(u_3.fullname as VARCHAR(250)) as property_property_manager
				, CAST(a_4.name as VARCHAR(250)) as property_owner_account 
				, CAST(c_2.fullname as VARCHAR(250)) as property_owner_contact 
				, p_1.zav_name as property_parent_hierarchy
				, pt.zav_name as property_property_type
				, sp.zav_name as  property_sub_program 
				, spt.zav_name as  property_sub_property_type
				, terr.name as  property_territory 
				, CAST(pr.zav_name as VARCHAR(50)) as  property_postal_region 
				, p.zav_currentrent as  property_current_rent 
				, p.zav_currentrent_base as  property_current_rent_base 
				, p.zav_acquireddate as  property_acquired_date 
				, p.zav_confirmeddisposaldate as  property_confirmed_disposal_date 
				, p.zav_dateconstructed as  property_date_constructed 
				, p.zav_disposaldate as  property_disposal_date 
				, CAST(p.zav_fulladdress as VARCHAR(250)) as  property_full_address 
				, CAST(p.zav_giftedname as VARCHAR(50)) as  property_gifted_name 
				, p.zav_hudmsdreferencenumber as  property_hud_msd_reference_number 
				, p.zav_latitude as  property_latitude 
				, p.zav_longitude as  property_longitude 
				, CAST(p.zav_name as VARCHAR(250)) as  property_name 
				, p.zav_nrasdate as  property_nras_date 
				, p.zav_nrasdwellingid as  property_nras_dwelling_id 
				, p.zav_owneremail as  property_owner_organisation_contact_email 
				, p.zav_postalcode as  property_postcode 
				, p.zav_propertymanageremail as  property_property_manager_email 
				, p.zav_propertymanagermobile as  property_property_manager_mobile_number 
				, p.zav_propertyservicename as  property_property_service_name
				, sn_property.zav_code as property_property_service_code
				, p.zav_provideragreementnumber as  property_provider_agreement_number 
				, CAST(p.zav_reasonfordisposal as VARCHAR(250)) as  property_reason_for_disposal 
				, p.zav_relettabledate as  property_relettable_date 
				, p.zav_roomnumber as  property_no_of_rooms 
				, CAST(p.zav_street1 as VARCHAR(50)) as  property_street_number 
				, CAST(p.zav_streetname as VARCHAR(100)) as  property_street_name 
				, CAST(p.zav_suburb as VARCHAR(50)) as  property_suburb 
				, CAST(p.zav_territoryname as VARCHAR(50)) as  property_district 
				, p.zav_totalheatsourcecapacitykw as  property_total_heat_source_capacity_kw 
				, p.zav_totalirrs_date as  property_total_irrs_date 
				, CAST(p.zav_unit as VARCHAR(50)) as  property_unit 
				, p.zav_transitionalhousingmarketrent as property_zav_transitional_housing_market_rent
				, p.zav_transitionalhousingmarketrent_base as property_transitional_housing_market_rent_base
				, p.new_propertyid as  property_reference_id 
				, CAST(p.zav_daysavailabletolet as INT) as property_days_available_to_let
				, CAST(p.zav_daysundermaintenence as INT) as property_days_under_maintenence
				, CAST(p.zav_numberofpeopleallowedtoreside as INT ) as property_no_of_people_allowed_to_reside
				, CAST(p.zav_totaldaysvacant as INT) as property_total_days_vacant
				, CAST(p.zav_totalirrs_state as INT) as property_total_irrs_state
				, p.zav_totalirrs as  property_total_irrs 
				, p.zav_totalirrs_base as  property_total_irrs_base 
				, p.SinkModifiedOn AS synapse_link_sink_modified_on

			FROM Zavanti.vw_zav_property as p

				left join Zavanti.vw_zav_postalcity as pc on p.zav_city = pc.Id
				left join Zavanti.vw_zav_servicename as sn_contract on p.zav_contractbcservicename = sn_contract.Id
				left join Zavanti.vw_zav_servicename as sn_property on p.zav_propertybcservicename = sn_property.id
				left join Zavanti.vw_contact as c_2 on p.zav_propertyownercontact = c_2.Id
				left join Zavanti.vw_systemuser as u_3 on p.zav_propertymanagerid = u_3.Id
				left join Zavanti.vw_opportunity as o on p.zav_currenttenancy = o.Id
				left join Zavanti.vw_zav_property as p_1 on p.zav_PropertySite = p_1.Id
				left join Zavanti.vw_zav_propertytype as pt on p.zav_propertytypeId = pt.Id
				left join Zavanti.vw_zav_subprogram as sp on p.zav_subprogram = sp.Id
				left join Zavanti.vw_zav_subpropertytype as spt on p.zav_subpropertytypeid = spt.Id
				left join Zavanti.vw_territory as terr on p.zav_territory = terr.Id
				left join Zavanti.vw_zav_postalregion as pr on p.new_postalregion = pr.Id
				left join Zavanti.vw_zav_program as pg on p.zav_program = pg.Id
				left join Zavanti.vw_account as a_3 on p.zav_legalownerid = a_3.Id
				left join Zavanti.vw_account as a_4 on p.zav_propertyowneraccount = a_4.Id
				left join Zavanti.vw_systemuser as u on p.zav_assignedtenancymanager = u.Id

			where p.zav_propertyid is not null
				
		)

	-- Final SELECT with only the 62 business columns
	SELECT
		p.property_id
	, p.property_acquired_date
	, p.property_bc_service_code
	, p.property_bc_service_name
	, p.property_city_name
	, CAST((p.property_confirmed_disposal_date AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_confirmed_disposal_date
	, p.property_contract_bc_service
	, p.property_contract_bc_service_code
	, p.property_assigned_tenancy_manager
	, p.property_current_rent
	, p.property_current_rent_base
	, p.property_current_tenancy
	, p.property_date_constructed
	, p.property_days_available_to_let
	, p.property_days_under_maintenence
	, p.property_disposal_date
	, p.property_district
	, p.property_full_address
	, p.property_gifted_name
	, p.property_hud_msd_reference_number
	, p.property_latitude
	, p.property_legal_owner
	, p.property_longitude
	, p.property_name
	, p.property_no_of_people_allowed_to_reside
	, p.property_no_of_rooms
	, p.property_owner_account
	, p.property_owner_contact
	, p.property_owner_organisation_contact_email
	, p.property_parent_hierarchy
	, p.property_postal_region
	, p.property_postcode
	, p.property_program
	, p.property_property_manager
	, p.property_property_manager_email
	, p.property_property_manager_mobile_number
	, g_opt.property_property_ownership
	, p.property_property_service_name
	, p.property_property_service_code
	, p.property_property_type
	, p.property_provider_agreement_number
	, p.property_reason_for_disposal
	, p.property_reference_id
	, p.property_relettable_date
	, g_opt.property_statecode
	, g_opt.property_status
	, g_opt.property_statuscode
	, p.property_street_name
	, p.property_street_number
	, p.property_sub_program
	, p.property_sub_property_type
	, p.property_suburb
	, g_opt.property_target_group
	, p.property_territory
	, p.property_total_days_vacant
	, p.property_total_heat_source_capacity_kw
	, p.property_total_irrs
	, p.property_total_irrs_base
	, p.property_total_irrs_date
	, p.property_total_irrs_state
	, g_opt.property_void_status
	, p.property_transitional_housing_market_rent_base
	, p.property_unit
	, g_opt.property_year_built
	, p.property_zav_transitional_housing_market_rent
	, CAST((p.synapse_link_sink_modified_on AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on

	FROM
		property_other_cte as p
		left join global_options_cte as g_opt on p.property_id = g_opt.Id
		--left join local_options_cte as opt on p.property_id = opt.Id
		-- left join methstatusevidence_cte as mse on p.property_id = mse.Id