
--1.9        2025/05/12    Manish Singh		Changing UTC date column to NZT

CREATE   VIEW [ETL].[Testdim_property]

as 

-- Group all the global options columns from vw_zav_property into one CTE
WITH global_options_cte as (
	SELECT
		Id
	, CAST(s.LocalizedLabel as VARCHAR(10)) as property_statecode
	, CAST(ss.LocalizedLabel as VARCHAR(10)) as property_statuscode
	, CAST(g_opt_10.LocalizedLabel as VARCHAR(50) ) as property_status  
	, CAST(g_opt_12.LocalizedLabel as VARCHAR(10)) as property_year_built  
	, CAST(g_opt_16.LocalizedLabel as VARCHAR(150)) as property_ceiling_insulation_location_coverage  
	, CAST(g_opt_17.LocalizedLabel as VARCHAR(20)) as property_ceiling_insulation_standard  
	, CAST(g_opt_20.LocalizedLabel as VARCHAR(10)) as property_deaf_smoke_alarms_indicator  
	-- , g_opt_24.LocalizedLabel as property_ea_target_group  
	, CAST(g_opt_27.LocalizedLabel as VARCHAR(20)) as property_fire_evacuation_trial_frequency  
	, CAST(g_opt_29.LocalizedLabel as VARCHAR(20))as property_frequency  
	, CAST(g_opt_30.LocalizedLabel as VARCHAR(20)) as property_funding  
	, CAST(g_opt_33.LocalizedLabel as VARCHAR(250)) as property_hazone  
	, CAST(g_opt_35.LocalizedLabel as VARCHAR(50)) as property_heating_type_1   
	, CAST(g_opt_50.LocalizedLabel as VARCHAR(50)) as property_insulation_in_wall_type  
	, CAST(g_opt_52.LocalizedLabel as VARCHAR(50))as property_insulation_under_floor_type  
	, CAST(g_opt_57.LocalizedLabel as VARCHAR(10)) as property_is_there_enough_heating_capacity_in_the_property  
	, CAST(g_opt_60.LocalizedLabel as VARCHAR(10)) as property_landlord_handback  
	, CAST(g_opt_62.LocalizedLabel as VARCHAR(50)) as property_maintenance_responsible  	
	, CAST(g_opt_66.LocalizedLabel as VARCHAR(10)) as property_no_of_bathrooms  
	, CAST(g_opt_76.LocalizedLabel as VARCHAR(50)) as property_previous_status  	
	, CAST(g_opt_79.LocalizedLabel as VARCHAR(20)) as property_property_ownership  
	--, CAST(g_opt_84.LocalizedLabel as VARCHAR(5)) as property_rent_area_override  -- List Australia States
	, CAST(g_opt_85.LocalizedLabel as VARCHAR(20) ) as property_responsible_for_maintenance  
	, CAST(g_opt_88.LocalizedLabel as VARCHAR(20) ) as property_security_gate  
	, CAST(g_opt_90.LocalizedLabel as VARCHAR(50)) as property_smoke_detectors  	
	--, g_opt_92.LocalizedLabel as property_state  -- List Australia States
	, CAST(g_opt_94.LocalizedLabel as VARCHAR(50)) as property_target_group  
	, CAST(g_opt_99.LocalizedLabel as VARCHAR(20)) as property_underfloor_insulation_standard  
	, CAST(g_opt_100.LocalizedLabel as VARCHAR(250)) as property_underfloor_location_coverage  
	, CAST(g_opt_101.LocalizedLabel as VARCHAR(50)) as property_void_status  
	, CAST(g_opt_102.LocalizedLabel as VARCHAR(100)) as property_wall_insulation_location_coverage  
	, CAST(g_opt_103.LocalizedLabel as VARCHAR(20)) as property_wall_insulation_standard  

	, p.SinkModifiedOn AS synapse_link_sink_modified_on

	FROM Zavanti.vw_zav_property as p 
	 left join Zavanti.vw_StateMetadata as s on p.statecode = s.State and s.EntityName = 'zav_property'
	 left join Zavanti.vw_StatusMetadata as ss on p.statuscode = ss.[Status] and ss.EntityName = 'zav_property'
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_10 on p.new_propertystatus = g_opt_10.[Option] and g_opt_10.OptionSetName = 'new_propertystatus' and g_opt_10.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_12 on p.new_yearbuilt = g_opt_12.[Option] and g_opt_12.OptionSetName = 'new_yearbuilt' and g_opt_12.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_16 on p.zav_ceilinginsulationlocationcoverage = g_opt_16.[Option] and g_opt_16.OptionSetName = 'zav_ceilinginsulationlocationcoverage' and g_opt_16.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_17 on p.zav_ceilinginsulationstandard = g_opt_17.[Option] and g_opt_17.OptionSetName = 'zav_ceilinginsulationstandard' and g_opt_17.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_20 on p.zav_deafsmokealarmsindicator = g_opt_20.[Option] and g_opt_20.OptionSetName = 'zav_deafsmokealarmsindicator' and g_opt_20.EntityName = 'zav_property' 
	 -- left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_24 on p.zav_eatargetgroup = g_opt_24.[Option] and g_opt_24.OptionSetName = 'zav_eatargetgroup' and g_opt_24.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_27 on p.zav_fireevacuationtrialfrequency = g_opt_27.[Option] and g_opt_27.OptionSetName = 'zav_fireevacuationtrialfrequency' and g_opt_27.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_29 on p.zav_frequency = g_opt_29.[Option] and g_opt_29.OptionSetName = 'zav_frequency' and g_opt_29.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_30 on p.zav_funding = g_opt_30.[Option] and g_opt_30.OptionSetName = 'zav_funding' and g_opt_30.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_33 on p.zav_hazone = g_opt_33.[Option] and g_opt_33.OptionSetName = 'zav_hazone' and g_opt_33.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_35 on p.zav_heatingtype1 = g_opt_35.[Option] and g_opt_35.OptionSetName = 'zav_heatingtype1' and g_opt_35.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_50 on p.zav_insulationinwalltype = g_opt_50.[Option] and g_opt_50.OptionSetName = 'zav_insulationinwalltype' and g_opt_50.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_52 on p.zav_insulationunderflrtype = g_opt_52.[Option] and g_opt_52.OptionSetName = 'zav_insulationunderflrtype' and g_opt_52.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_57 on p.zav_isthereenoughheatingcapacityintheproperty = g_opt_57.[Option] and g_opt_57.OptionSetName = 'zav_isthereenoughheatingcapacityintheproperty' and g_opt_57.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_60 on p.zav_landlordhandback = g_opt_60.[Option] and g_opt_60.OptionSetName = 'zav_landlordhandback' and g_opt_60.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_62 on p.zav_maintenanceresponsible = g_opt_62.[Option] and g_opt_62.OptionSetName = 'zav_maintenanceresponsible' and g_opt_62.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_66 on p.zav_noofbathrooms = g_opt_66.[Option] and g_opt_66.OptionSetName = 'zav_noofbathrooms' and g_opt_66.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_76 on p.zav_previousstatus = g_opt_76.[Option] and g_opt_76.OptionSetName = 'zav_previousstatus' and g_opt_76.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_79 on p.zav_propertyownership = g_opt_79.[Option] and g_opt_79.OptionSetName = 'zav_propertyownership' and g_opt_79.EntityName = 'zav_property' 
	 --left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_84 on p.zav_rentareaoverride = g_opt_84.[Option] and g_opt_84.OptionSetName = 'zav_rentareaoverride' and g_opt_84.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_85 on p.zav_responsibleformaintenance = g_opt_85.[Option] and g_opt_85.OptionSetName = 'zav_responsibleformaintenance' and g_opt_85.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_88 on p.zav_securitygate = g_opt_88.[Option] and g_opt_88.OptionSetName = 'zav_securitygate' and g_opt_88.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_90 on p.zav_smokedetectors = g_opt_90.[Option] and g_opt_90.OptionSetName = 'zav_smokedetectors' and g_opt_90.EntityName = 'zav_property' 
	 -- left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_92 on p.zav_state = g_opt_92.[Option] and g_opt_92.OptionSetName = 'zav_state' and g_opt_92.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_94 on p.zav_targetgroup = g_opt_94.[Option] and g_opt_94.OptionSetName = 'zav_targetgroup' and g_opt_94.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_99 on p.zav_underfloorinsulationstandard = g_opt_99.[Option] and g_opt_99.OptionSetName = 'zav_underfloorinsulationstandard' and g_opt_99.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_100 on p.zav_underfloorlocationcoverage = g_opt_100.[Option] and g_opt_100.OptionSetName = 'zav_underfloorlocationcoverage' and g_opt_100.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_101 on p.zav_voidstatus = g_opt_101.[Option] and g_opt_101.OptionSetName = 'zav_voidstatus' and g_opt_101.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_102 on p.zav_wallinsulationlocationcoverage = g_opt_102.[Option] and g_opt_102.OptionSetName = 'zav_wallinsulationlocationcoverage' and g_opt_102.EntityName = 'zav_property' 
	 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_103 on p.zav_wallinsulationstandard = g_opt_103.[Option] and g_opt_103.OptionSetName = 'zav_wallinsulationstandard' and g_opt_103.EntityName = 'zav_property' 
	 

),
-- because the methstatusevidence column contains multiple enties i had to split the data then join it to the OptionSetMetadata to get text value
-- before joinging it back together again
methstatusevidence_cte as (

	SELECT
		Id
		, STRING_AGG(CONVERT(NVARCHAR(MAX), LocalizedLabel), ' | ') as zav_methstatusevidence
		FROM (
			SELECT
			Id
			, value
			, opt.LocalizedLabel
			FROM Zavanti.vw_zav_property
				CROSS APPLY STRING_SPLIT(zav_methstatusevidence, ';') as p
			left join Zavanti.vw_OptionsetMetadata as opt on p.value = opt.[Option] and  opt.OptionSetName = 'zav_methstatusevidence' and opt.EntityName = 'zav_property'
			WHERE zav_methstatusevidence is not null
			) as x
	GROUP BY Id
)
-- Group all the local Options into one CTE
, local_options_cte as (
	SELECT
	Id 
	, CAST(opt_26.LocalizedLabel as VARCHAR(20)) as property_fire_evacuation  
	, CAST(opt_28.LocalizedLabel as VARCHAR(50)) as property_fire_extinguisher_responsibility 
	, CAST(opt_58.LocalizedLabel as VARCHAR(10) ) as property_key_status  
	, CAST(opt_63.LocalizedLabel as VARCHAR(50)) as property_meth_status  
	, CAST(opt_64.LocalizedLabel as VARCHAR(50)) as property_meth_status_on_entry  
	, CAST(opt_65.LocalizedLabel as VARCHAR(20)) as property_meth_test_type  
	, CAST(opt_77.LocalizedLabel as VARCHAR(50)) as property_property_classification  
	, CAST(opt_91.LocalizedLabel as VARCHAR(20)) as property_smoke_detector_type  
	from Zavanti.vw_zav_property as p
	left join Zavanti.vw_OptionsetMetadata as opt_26 on p.zav_fireevacuation = opt_26.[Option] and opt_26.OptionSetName = 'zav_fireevacuation' and opt_26.EntityName = 'zav_property' 
	left join Zavanti.vw_OptionsetMetadata as opt_28 on p.zav_fireextinguisherresponsibility = opt_28.[Option] and opt_28.OptionSetName = 'zav_fireextinguisherresponsibility' and opt_28.EntityName = 'zav_property' 
	left join Zavanti.vw_OptionsetMetadata as opt_58 on p.zav_keystatus = opt_58.[Option] and opt_58.OptionSetName = 'zav_keystatus' and opt_58.EntityName = 'zav_property' 
	left join Zavanti.vw_OptionsetMetadata as opt_77 on p.zav_propertyclassification = opt_77.[Option] and opt_77.OptionSetName = 'zav_propertyclassification' and opt_77.EntityName = 'zav_property' 
	left join Zavanti.vw_OptionsetMetadata as opt_91 on p.zav_smokedetectortype = opt_91.[Option] and opt_91.OptionSetName = 'zav_smokedetectortype' and opt_91.EntityName = 'zav_property' 
	left join Zavanti.vw_OptionsetMetadata as opt_63 on p.zav_methstatus = opt_63.[Option] and opt_63.OptionSetName = 'zav_methstatus' and opt_63.EntityName = 'zav_property' 
	left join Zavanti.vw_OptionsetMetadata as opt_64 on p.zav_methstatusonentry = opt_64.[Option] and opt_64.OptionSetName = 'zav_methstatusonentry' and opt_64.EntityName = 'zav_property' 
	left join Zavanti.vw_OptionsetMetadata as opt_65 on p.zav_methtesttype = opt_65.[Option] and opt_65.OptionSetName = 'zav_methtesttype' and opt_65.EntityName = 'zav_property' 
), 
property_other_cte as (
	SELECT
	p.Id as property_id
	, CAST(CAST(p.new_asbestosispresent as BIT) as INT) as  property_asbestos_is_present_flag
	, CAST(CAST(p.zav_accesscontrol as BIT) as INT) as  property_access_control_flag
	, CAST(CAST(p.zav_backflowpreventor as BIT) as INT) as  property_backflow_preventor_flag
	, CAST(CAST(p.zav_bwofexists as BIT) as INT) as  property_bwof_exists_flag
	, CAST(CAST(p.zav_compliancescheduleapplicable as BIT) as INT) as  property_compliance_schedule_applicable_flag
	, CAST(CAST(p.zav_dateinsulationwaslastupgradedna as BIT) as INT) as  property_date_insulation_was_last_upgraded_na_flag
	, CAST(CAST(p.zav_dateinsulationwasprofessionallyassessedna as BIT) as INT) as  property_date_insulation_was_professionally_assessed_na_flag
	, CAST(CAST(p.zav_dowehaveallocationrights as BIT) as INT) as  property_do_we_have_allocation_rights_flag
	, CAST(CAST(p.zav_emergencylighting as BIT) as INT) as  property_emergency_lighting_flag
	, CAST(CAST(p.zav_firealarms  as BIT) as INT) as  property_fire_alarms_flag
	, CAST(CAST(p.zav_fireblanket as BIT) as INT) as  property_fire_blanket_flag
	, CAST(CAST(p.zav_heatdetectors as BIT) as INT) as  property_heat_detectors_flag
	, CAST(CAST(p.zav_housingfirst as BIT) as INT) as  property_housing_first_flag
	, CAST(CAST(p.zav_inputtaxed as BIT) as INT) as  property_input_taxed_flag
	, CAST(CAST(p.zav_isthistenancyappropriatelyhoused as BIT) as INT) as  property_is_this_tenancy_appropriately_housed_flag
	, CAST(CAST(p.zav_mcps as BIT) as INT) as  property_mcps_flag
	, CAST(CAST(p.zav_mechanicalventilation as BIT) as INT) as  property_mechanical_ventilation_flag
	, CAST(CAST(p.zav_passengerlift as BIT) AS INT) as  property_passenger_lift_flag
	, CAST(CAST(p.zav_previouscontamination as BIT) AS INT) as  property_previous_contamination_flag
	, CAST(CAST(p.zav_resourceconsentapplicable AS BIT) AS INT) as  property_resource_consent_applicable_flag
	, CAST(CAST(p.zav_smokestopdoors as BIT) AS INT) as  property_smoke_stop_doors_flag
	, CAST(CAST(p.zav_sprinklers as BIT) as INT) as  property_sprinklers_flag
	, CAST(CAST(p.zav_undermainagreement as BIT) as INT) as  property_under_main_agreement_flag
	, CAST(a_1.name as VARCHAR(250)) as property_crba8_property_agent 
	--, p.crba8_propertyagent as property_crba8_property_agent 
	--, p.crba8_propertyagent_entitytype as  property_crba8_property_agent_entitytype 
	, CAST(c_1.fullname as VARCHAR(250))as  property_crba8_property_agent_contact
	--, p.crba8_propertyagentcontact as  property_crba8_property_agent_contact 
	--, p.crba8_propertyagentcontact_entitytype as  property_crba8_property_agent_contact_entitytype
	--, p.crba8_propertyagentcontactname as  property_crba8_property_agent_contact_name 
	--, p.crba8_propertyagentcontactyominame as  property_crba8_property_agent_contact_yomi_nam
	, CAST(u_1.fullname as VARCHAR(250)) as property_created_by 
	--, p.createdby as  property_created_by 
	--, p.createdby_entitytype as  property_createdby_entitytype 
	--, p.createdbyname as  property_created_by_name 
	--, p.createdbyyominame as  property_created_by_yomi_name 
	, CAST(u_2.fullname as VARCHAR(250) ) as property_created_on_behalf_by
	--, p.createdonbehalfby as  property_created_on_behalf_by 
	--, p.createdonbehalfby_entitytype as  property_created_on_behalf_by_entitytype 
	--, p.createdonbehalfbyname as  property_created_on_behalf_by_name 
	--, p.createdonbehalfbyyominame as  property_created_on_behalf_by_yomi_name 
	, CAST(u_5.fullname as VARCHAR(250)) as property_modified_by 
	--, p.modifiedby as  property_modified_by 
	--, p.modifiedby_entitytype as  property_modifiedby_entitytype 
	--, p.modifiedbyname as  property_modified_by_name 
	--, p.modifiedbyyominame as  property_modified_by_yomi_name 
	, CAST(u_6.fullname as VARCHAR(250)) as property_modified_on_behalf_by
	--, p.modifiedonbehalfby as  property_modified_on_behalf_by 
	--, p.modifiedonbehalfby_entitytype as  property_modified_on_behalf_by_entitytype 
	--, p.modifiedonbehalfbyname as  property_modified_on_behalf_by_name 
	--, p.modifiedonbehalfbyyominame as  property_modified_on_behalf_by_yomi_name 
	, CAST(pr.zav_name as VARCHAR(50)) as  property_postal_region 
	--, p.new_postalregion as  property_postal_region 
	--, p.new_postalregionname as  property_postal_region_name 
	--, p.new_postalregion_entitytype as  property_postalregion_entitytype 
	, bu.name as property_owning_business_unit 
	--, p.owningbusinessunitname as  property_owning_business_unit_name 
	--, p.owningbusinessunit as  property_owning_business_unit 
	--, p.owningbusinessunit_entitytype as  property_owning_businessunit_entitytype 
	, t.name as property_owning_team 
	--, p.owningteam as  property_owning_team 
	--, p.owningteam_entitytype as  property_owning_team_entitytype 
	, CAST(u_7.fullname as VARCHAR(250)) as property_owning_user 
	--, p.owninguser as  property_owning_user 
	--, p.owninguser_entitytype as  property_owning_user_entitytype 
	--, p.transactioncurrencyid as  property_transaction_currency_id 
	, p.transactioncurrencyidname as  property_transaction_currency_id_name 
	--, p.transactioncurrencyid_entitytype as  property_transaction_currencyid_entitytype 
	, CAST(u.fullname as VARCHAR(250)) as property_assigned_tenancy_manager 
	-- , p.zav_assignedtenancymanager as  property_assigned_tenancy_manager 
	-- , p.zav_assignedtenancymanager_entitytype as  property_assigned_tenancy_manager_entitytype 
	, CAST(c.fullname as VARCHAR(250))as property_body_corp_contact_person
	-- , p.zav_bodycorpcontactperson_entitytype as  property_body_corp_contact_person_entitytype 
	-- , p.zav_bodycorporate as  property_body_corporate 
	-- , p.zav_bodycorporate_entitytype as  property_body_corporate_entitytype 
	--, p.zav_city as  property_city 
	--, p.zav_city_entitytype as  property_city_entitytype 
	-- , p.zav_cityname as  property_city_name zav_legal
	, CAST(pc.zav_name as VARCHAR(50)) as property_city_name	
	, sn_contract.zav_name as property_contract_bc_service
	, sn_contract.zav_code as property_contract_bc_service_code	
	--, p.zav_contractbcservicename as  property_contract_bc_service_id
	--, p.zav_contractbcservicename_entitytype as  property_contract_bc_service_name_entitytype 
	, CAST(o.name as VARCHAR(250)) as property_current_tenancy 
	--, p.zav_currenttenancy as  property_current_tenancy 
	--, p.zav_currenttenancy_entitytype as  property_current_tenancy_entitytype 
	--, p.zav_currenttenancyname as  property_current_tenancy_name 
	--, p.zav_haprogramname as  property_ha_program_name 
	--, p.zav_haprogram as  property_ha_program 
	--, p.zav_haprogram_entitytype as  property_ha_program_entitytype 
	, CAST(a_2.name as VARCHAR(250)) as property_head_contractor 
	--, p.zav_headcontractor as  property_head_contractor 
	--, p.zav_headcontractor_entitytype as  property_head_contractor_entitytype 
	--, p.zav_headcontractorname as  property_head_contractor_name 
	--, p.zav_headcontractoryominame as  property_head_contractor_yomi_name 
	--, p.zav_legalowner as  property_legal_owner -- Obsolete field
	, CAST(a_3.name as VARCHAR(250)) as property_legal_owner
	--, p.zav_legalownerid as  property_legal_ownerid 
	--, p.zav_legalownerid_entitytype as  property_legal_ownerid_entitytype 
	--, p.zav_legalowneridname as  property_legal_owner_organisation_name 
	--, p.zav_legalowneridyominame as  property_legal_ownerid_yomi_name 
	, CAST(a_7.name as VARCHAR(250)) as property_primary_contractor 
	--, p.zav_primarycontractorname as  property_primary_contractor_name 
	--, p.zav_primarycontractoryominame as  property_primary_contractor_yomi_name 
	--, p.zav_primarycontractor as  property_primary_contractor 
	--, p.zav_primarycontractor_entitytype as  property_primary_contractor_entitytype 
	, pg.zav_name as property_program 
	--, p.zav_program as  property_program 
	--, p.zav_programname as  property_program_name 
	--, p.zav_program_entitytype as  property_program_entitytype 
	, p.zav_propertybcservicenamename as  property_bc_service_name
	, sn_property.zav_code as property_bc_service_code
	--, p.zav_propertybcservicename as  property_property_bc_service_name 
	--, p.zav_propertybcservicename_entitytype as  property_property_bc_service_name_entitytype 
	--, p.zav_propertymanager as  property_property_manager 
	--, p.zav_propertymanager_entitytype as  property_property_manager_entitytype 
	, CAST(u_3.fullname as VARCHAR(250)) as property_property_manager
	--, p.zav_propertymanagerid as  property_property_manager_id 
	--, p.zav_propertymanagerid_entitytype as  property_property_manager_id_entitytype 
	--, p.zav_propertyowner as  property_property_owner  -- Field is marked to be deleted
	--, p.zav_propertyowner_entitytype as  property_property_owner_entitytype 
	--, p.zav_propertyownername as  property_owner_name 
	--, p.zav_propertyowneryominame as  property_property_owner_yomi_name 
	, CAST(a_4.name as VARCHAR(250)) as property_owner_account 
	--, p.zav_propertyowneraccount as  property_property_owner_account 
	--, p.zav_propertyowneraccount_entitytype as  property_property_owner_account_entitytype 
	--, p.zav_propertyowneraccountname as  property_owner_account_name 
	--, p.zav_propertyowneraccountyominame as  property_property_owner_account_yomi_name 
	, CAST(c_2.fullname as VARCHAR(250)) as property_owner_contact 
	--, p.zav_propertyownercontact as  property_property_owner_contact 
	--, p.zav_propertyownercontact_entitytype as  property_property_owner_contact_entitytype 
	--, p.zav_propertyownercontactname as  property_owner_contact_name 
	--, p.zav_propertyownercontactyominame as  property_owner_contact_yomi_name 
	, p_1.zav_name as property_parent_hierarchy
	--, p.zav_propertysite as  property_property_site 
	--, p.zav_propertysite_entitytype as  property_property_site_entitytype 
	-- , p.zav_propertysitename as  property_site_name 
	, pt.zav_name as property_property_type
	--, p.zav_propertytypeid as  property_property_type_id 
	--, p.zav_propertytypeid_entitytype as  property_property_typeid_entitytype 
	--, p.zav_propertytypeidname as  property_type 
	, CAST(a_5.name as VARCHAR(250)) as property_rubbish_collection_agency
	--, p.zav_rubbishcollectionagencyname as  property_rubbish_collection_agency_name 
	--, p.zav_rubbishcollectionagencyyominame as  property_rubbish_collection_agency_yomi_name 
	--, p.zav_rubbishcollectionagency_entitytype as  property_rubbish_collection_agency_entitytype 
	, CAST(a_6.name as VARCHAR(250)) as  property_strata_company 
	--, p.zav_stratacompany as  property_strata_company 
	--, p.zav_stratacompanyname as  property_strata_company_name 
	--, p.zav_stratacompanyyominame as  property_strata_company_yomi_name 
	--, p.zav_stratacompany_entitytype as  property_strata_company_entitytype 
	, sp.zav_name as  property_sub_program 
	--, p.zav_subprogramname as  property_sub_program 
	--, p.zav_subprogram as  property_sub_program_id 
	--, p.zav_subprogram_entitytype as  property_subprogram_entitytype 
	, spt.zav_name as  property_sub_property_type
	--, p.zav_subpropertytypeidname as  property_sub_property_type 
	--, p.zav_subpropertytypeid as  property_sub_property_type_id 
	--, p.zav_subpropertytypeid_entitytype as  property_subproperty_typeid_entitytype 
	, terr.name as  property_territory 
	--, p.zav_territory as  property_territory 
	--, p.zav_territory_entitytype as  property_territory_entitytype 
	--, p.zav_watermeterlocation_entitytype as  property_water_meter_location_entitytype -- no longer used deprecated
	, CAST(u_4.fullname as VARCHAR(250)) as  property_owner
	--, p.ownerid as  property_owner_id 
	--, p.ownerid_entitytype as  property_ownerid_entitytype 
	--, p.owneridname as  property_owner_id_name 
	--, p.owneridtype as  property_ownerid_type 
	--, p.owneridyominame as  property_owner_id_yomi_name 
	, p.zav_bondamount as  property_bond_amount 
	, p.zav_bondamount_base as  property_bond_amount_base 
	, p.zav_borrowedamount_base as  property_borrowed_amount_base 
	, p.zav_currentrent as  property_current_rent 
	, p.zav_currentrent_base as  property_current_rent_base 
	, p.zav_inhand as  property_inhand 
	, p.zav_inhand_base as  property_inhand_base 
	, p.zav_irrsbalance as  property_irrs_balance 
	, p.zav_irrsbalance_base as  property_irrs_balance_base 
	, p.zav_lastvaluation_base as  property_last_valuation_base 
	, p.zav_marketrent as  property_market_rent 
	, p.zav_marketrent_base as  property_market_rent_base 
	, p.zav_mortgagedamount_base as  property_mortgaged_amount_base 
	, p.zav_totalirrs as  property_total_irrs 
	, p.zav_totalirrs_base as  property_total_irrs_base 
	, p.zav_valuation as  property_valuation 
	, p.zav_valuation_base as  property_valuation_base 
	, p.crba8_gasmeterlocation as  property_crba8_gas_meter_location 
	, p.createdon as  property_created_on 
	, p.exchangerate as  property_exchange_rate 
	, p.modifiedon as  property_modified_on 
	, CAST(p.new_country as VARCHAR(50)) as  property_country 
	, CAST(p.new_hazardlist as VARCHAR(250)) as  property_hazard_list 
	, CAST(p.new_landinformation as VARCHAR(3600)) as  property_land_information 
	, p.new_leaseenddate as  property_lease_end_date 
	, p.new_propertyage as  property_property_age 
	, p.new_propertyid as  property_reference_id 
	, p.overriddencreatedon as  property_overridden_created_on 
	, p.zav_accesscontrolagent as  property_access_control_agent 
	, p.zav_accesscontroltype as  property_access_control_type 
	, p.zav_acquireddate as  property_acquired_date 
	, CAST(p.zav_ageofceilinginsulationifknown1 as VARCHAR(50)) as  property_age_of_ceiling_insulation_if_known1 
	, CAST(p.zav_ageofunderfloorinsulationifknown1 as VARCHAR(50)) as  property_age_of_underfloor_insulation_if_known1 
	, p.zav_agreedrentreviewdate as  property_agreed_rent_review_date 
	, CAST(p.zav_anyotherdetailsaboutthetypeorconditionifk as VARCHAR(3600)) as  property_any_other_details_about_the_type_or_condition_if_known 
	-- , p.zav_assignedtenancymanagername as  property_assigned_tenancy_manager_Id
	-- , p.zav_assignedtenancymanageryominame as  property_assigned_tenancy_manager_yomi_name 
	, p.zav_bedroomkeys as  property_bedroom_keys 
	-- , p.zav_bodycorpcontactpersonyominame as  property_body_corp_contact_person_yomi_name 
	, CAST(a.name as VARCHAR(250)) as property_body_corporate_name
	--, p.zav_bodycorporatename as  property_body_corporate_name 
	--, p.zav_bodycorporateyominame as  property_body_corporate_yomi_name 
	, CAST(p.zav_bondcomment as VARCHAR(3600)) as  property_bond_comment 
	, p.zav_bondlodged as  property_bond_lodged 
	, p.zav_bondreference as  property_bond_reference 
	, p.zav_buildingwarrantoffitnessdate as  property_building_warrant_of_fitness_date 
	, CAST(p.zav_buildingwarrantoffitnessdetails as VARCHAR(3600)) as  property_building_warrant_of_fitness_details 
	, CAST(p.zav_businessphoneowner as VARCHAR(20)) as  property_business_phone_owner 
	, p.zav_bwofdateobtained as  property_bwof_date_obtained 
	, CAST(p.zav_ceilinginsulationstatusifno as VARCHAR(3600)) as  property_ceiling_insulation_status_ifno 
	, p.zav_ceilinginsulationtypeother as  property_ceiling_insulation_type_other 
	, CAST(p.zav_chintaroid as VARCHAR(20)) as  property_chintaro_id 
	, CAST(p.zav_comments as VARCHAR(3600) ) as  property_comments 
	, CAST(p.zav_commentsforvacantpropertyreport as VARCHAR(3600)) as  property_comments_for_vacant_property_report 
	, p.zav_commentsgeneral as  property_comments_general 
	, p.zav_commentskeys as  property_comments_keys 
	, CAST(p.zav_complianceschedulereferences as VARCHAR(10)) as  property_compliance_schedule_references 
	, CAST(p.zav_concatenatedaddress as VARCHAR(3600)) as  property_concatenated_address 
	, p.zav_confirmeddisposaldate as  property_confirmed_disposal_date 
	--, p.zav_contractservicename as  property_contract_service_name  -- not used superceed by zav_contractBCServicename
	, CAST(p.zav_costcentre as VARCHAR(50)) as  property_cost_centre 
	, CAST(p.zav_currentiqp as VARCHAR(20))as  property_current_iqp 
	, p.zav_dateconstructed as  property_date_constructed 
	, p.zav_dateinsulationwaslastupgraded as  property_date_insulation_was_last_upgraded 
	, p.zav_dateinsulationwasprofessionallyassessed as  property_date_insulation_was_professionally_assessed 
	, p.zav_datenextbwofdue as  property_date_next_bwof_due 
	, p.zav_datenextbwofduetext as  property_date_next_bwof_due_text 
	, p.zav_delete_textdemo as  property_delete_textdemo 
	, CAST(p.zav_delete_urldemo as VARCHAR(3600)) as  property_delete_urldemo 
	, p.zav_disposaldate as  property_disposal_date 
	, p.zav_eadivision as  property_eadivision 
	, p.zav_fireevacuationregno as  property_fire_evacuation_registration_number 
	, p.zav_fridgekeys as  property_fridgekeys 
	, CAST(p.zav_fulladdress as VARCHAR(250)) as  property_full_address 
	, CAST(p.zav_gatecode as VARCHAR(20)) as  property_gate_code 
	, CAST(p.zav_gateremote as VARCHAR(10)) as  property_gate_remote 
	, CAST(p.zav_giftedname as VARCHAR(50)) as  property_gifted_name 
	, p.zav_habitatpropertyref as  property_habitat_property_ref 
	, p.zav_headleaseexpdate as  property_head_lease_exp_date 
	, p.zav_hudcontractnumber as  property_hud_contract_number 
	, p.zav_hudmsdreferencenumber as  property_hud_msd_reference_number 
	, p.zav_ifpartialspecifyareasnotinsulated as  property_if_partial_specify_areas_not_insulated 
	, p.zav_insulationceilingdate as  property_insulation_ceiling_date 
	, p.zav_insulationinwalldate as  property_insulation_in_wall_date 
	, p.zav_insulationisinatleastareasonablecondition as  property_insulation_is_in_at_least_a_reasonable_condition 
	, p.zav_insulationisinatleastareasonableunderflr as  property_insulation_is_in_at_least_a_reasonable_underflr 
	, p.zav_insulationunderflrdate as  property_insulation_underflr_date 
	, p.zav_intendeddisposaldate as  property_intended_disposal_date 
	, p.zav_irrschargedto as  property_irrs_charged_to 
	, p.zav_irrspaidto as  property_irrs_paid_to 
	, p.zav_isip as  property_is_ip 
	, p.zav_kitchencupboardkeys as  property_kitchen_cupboard_keys 
	, p.zav_landarea as  property_land_area 
	, p.zav_latitude as  property_latitude 
	, CAST(p.zav_legacyid as VARCHAR(100)) as  property_legacy_id 
	, CAST(p.zav_letterboxkeys as VARCHAR(10)) as  property_letter_box_keys 
	, p.zav_longitude as  property_longitude 
	, CAST(p.zav_maindoorkeys as VARCHAR(50)) as  property_main_door_keys 
	, CAST(p.zav_maingatekeys as VARCHAR(10)) as  property_main_gate_keys 
	, CAST(p.zav_masterkeyid as VARCHAR(100)) as  property_master_key_id 
	, p.zav_meshblock as  property_meshblock 
	, p.zav_minimumthicknessmm as  property_minimum_thickness_mm 
	, p.zav_minimumthicknessnaforfoil as  property_minimum_thickness_na_for_foil 
	, p.zav_minimumthicknessnaforfoilmm as  property_minimum_thickness_na_for_foil_mm 
	, p.zav_monitoringagent as  property_monitoring_agent 
	, CAST(p.zav_name as VARCHAR(250)) as  property_name 
	, p.zav_nrasdate as  property_nras_date 
	, p.zav_nrasdwellingid as  property_nras_dwelling_id 
	, p.zav_orminimumthickness as  property_or_minimum_thickness 
	, CAST(p.zav_otheraccesscomments as VARCHAR(250)) as  property_other_access_comments 
	, p.zav_owneremail as  property_owner_organisation_contact_email 
	, p.zav_paintcolour as  property_paint_colour 
	, p.zav_paintmanufacturer as  property_paint_manufacturer 
	, p.zav_partialspecifyareasnotinsulatedunderflr as  property_partial_specify_areas_not_insulated_underflr 
	, p.zav_partialspecifyareasnotinsulatedwall as  property_partial_specify_areas_not_insulated_wall 
	, p.zav_postalcode as  property_postcode 
	, p.zav_previouscontaminationdate as  property_previous_contamination_date 
	, CAST(p.zav_propertycomments as VARCHAR(3600)) as  property_comments_other 
	, p.zav_propertyid as  property_old_id 
	--, p.zav_propertyimage as  property_image 
	, p.zav_propertyimage_url as  property_image_url 
	, p.zav_propertyimageid as  property_image_id 
	, p.zav_propertymanageremail as  property_property_manager_email 
	--, p.zav_propertymanageridname as  property_manager_id
	--, p.zav_propertymanageridyominame as  property_manager_id_yomi_name 
	, p.zav_propertymanagermobile as  property_property_manager_mobile_number 
	--, p.zav_propertymanagername as  property_manager_name -- Field is Obsolete
	--, p.zav_propertymanageryominame as  property_manager_yomi_name  -- Field is Obsolete
	, p.zav_propertyservicename as  property_property_service_name
	, sn_property.zav_code as property_property_service_code
	, p.zav_provideragreementnumber as  property_provider_agreement_number 
	, CAST(p.zav_reasonfordisposal as VARCHAR(250)) as  property_reason_for_disposal 
	, p.zav_refundlodged as  property_refund_lodged 
	, CAST(p.zav_relativeurl as VARCHAR(250)) as  property_relative_url 
	, p.zav_relettabledate as  property_relettable_date 
	, p.zav_rescindeddisposaldate as  property_rescinded_disposal_date 
	, CAST(p.zav_resourceconsentreferences as VARCHAR(3600)) as  property_resource_consent_references 
	, p.zav_roomnumber as  property_no_of_rooms 
	, p.zav_securitysystemagent as  property_security_system_agent 
	, p.zav_securitysystemtype as  property_security_system_type 
	, CAST(p.zav_serviceagentsvendor as VARCHAR(50)) as  property_service_agents_vendor 
	, p.zav_specifyreasonforinaccessibility as  property_specify_reason_for_inaccessibility 
	, p.zav_specifyreasonforinaccessibilityunderflr as  property_specify_reason_for_inaccessibility_underflr 
	, CAST(p.zav_street1 as VARCHAR(50)) as  property_street_number 
	, CAST(p.zav_streetname as VARCHAR(100)) as  property_street_name 
	, CAST(p.zav_suburb as VARCHAR(50)) as  property_suburb 
	, CAST(p.zav_swipecard as VARCHAR(10)) as  property_swipecard 
	, p.zav_tenure as  property_tenure 
	, CAST(p.zav_territoryname as VARCHAR(50)) as  property_district 
	, p.zav_totalheatsourcecapacitykw as  property_total_heat_source_capacity_kw 
	, p.zav_totalirrs_date as  property_total_irrs_date 
	, CAST(p.zav_underfloorinsulationstatusifno as VARCHAR(10)) as  property_underfloor_insulation_status_ifno 
	, p.zav_underfloorotherspecify as  property_underfloor_other_specify 
	, p.zav_underinsulationbulkinsulationvaluervalue as  property_under_insulation_bulk_insulation_valuer_value 
	, CAST(p.zav_unit as VARCHAR(50)) as  property_unit 
	, p.zav_upi as  property_upi 
	, p.zav_utilityroomcode as  property_utility_room_code 
	, p.zav_utilityroomkey as  property_utility_room_key 
	, p.zav_wallpaper as  property_wallpaper 
	, p.zav_warrantyexpirydate as  property_warranty_expiry_date 
	, p.zav_windowskeys as  property_windows_keys 
	, p.zav_transitionalhousingmarketrent as property_zav_transitional_housing_market_rent
	, p.zav_transitionalhousingmarketrent_base as property_transitional_housing_market_rent_base
	, CAST(p.crba8_numberoflevels as INT) as property_crba8_number_of_levels
	, CAST(p.importsequencenumber as INT) as property_import_sequence_number
	, CAST(p.new_overalltargettarget as INT) as property_overall_target_target
	, p.new_vacanttenantabletarget as property_vacant_tenantable_target
	, p.new_vacantuntenantabletarget as property_vacant_untenantable_target
	, CAST(p.timezoneruleversionnumber as INT) as property_timezone_rule_version_number
	, CAST(p.utcconversiontimezonecode as INT) as property_utc_conversion_timezone_code
	, p.versionnumber as property_version_number
	, CAST(p.zav_accesscontrolnoofdoors as INT) as property_access_control_no_of_doors
	, CAST(p.zav_assessmentnumber as INT) as property_assessment_number
	, CAST(p.zav_daysavailabletolet as INT) as property_days_available_to_let
	, CAST(p.zav_daysundermaintenence as INT) as property_days_under_maintenence
	--  p.zav_noearthstake as property_no_earth_stake  -- Not being used at the moment
	, CAST(p.zav_nooffireextinguishers as INT) as property_no_of_fire_extinguishers
	, CAST(p.zav_norcds as INT ) as property_no_of_rcds
	, CAST(p.zav_nosmokealarms as INT) as property_no_of_smoke_alarms
	, CAST(p.zav_numberofpeopleallowedtoreside as INT ) as property_no_of_people_allowed_to_reside
	, p.zav_propertyimage_timestamp as property_image_timestamp
	, CAST(p.zav_totaldaysvacant as INT) as property_total_days_vacant
	, CAST(p.zav_totalirrs_state as INT) as property_total_irrs_state
	, p.zav_valuationrollnumber as property_valuation_roll_number
	, CAST(CAST(p.[IsDelete] as BIT) as INT) as property_is_delete_flag
	, p.SinkModifiedOn AS synapse_link_sink_modified_on

	FROM Zavanti.vw_zav_property as p
	left join Zavanti.vw_account as a on p.zav_bodycorporate = a.Id
	left join Zavanti.vw_account as a_1 on p.crba8_propertyagent = a_1.Id
	left join Zavanti.vw_account as a_2 on p.zav_headcontractor = a_2.Id
	left join Zavanti.vw_account as a_3 on p.zav_legalownerid = a_3.Id
	left join Zavanti.vw_account as a_4 on p.zav_propertyowneraccount = a_4.Id
	left join Zavanti.vw_account as a_5 on p.zav_RubbishCollectionAgency = a_5.Id
	left join Zavanti.vw_account as a_6 on p.zav_stratacompany = a_6.Id
	left join Zavanti.vw_account as a_7 on p.zav_primarycontractor = a_7.Id

	left join Zavanti.vw_zav_postalcity as pc on p.zav_city = pc.Id
	left join Zavanti.vw_zav_servicename as sn_contract on p.zav_contractbcservicename = sn_contract.Id
	left join Zavanti.vw_zav_servicename as sn_property on p.zav_propertybcservicename = sn_property.id
	--left join Zavanti.vw_zav_servicename as sn_2 on p.zav_propertyservicename = sn_2.id
	--left join Zavanti.vw_zav_servicename as sn_2 on p.zav_propertyservicename = sn_2.zav_code

	left join Zavanti.vw_contact as c on p.zav_bodycorpcontactperson = c.Id
	left join Zavanti.vw_contact as c_1 on p.crba8_propertyagentcontact = c_1.Id
	left join Zavanti.vw_contact as c_2 on p.zav_propertyownercontact = c_2.Id
	
	left join Zavanti.vw_systemuser as u on p.zav_assignedtenancymanager = u.Id
	left join Zavanti.vw_systemuser as u_1 on p.createdby = u_1.Id
	left join Zavanti.vw_systemuser as u_2 on p.createdonbehalfby = u_2.Id
	left join Zavanti.vw_systemuser as u_3 on p.zav_propertymanagerid = u_3.Id
	left join Zavanti.vw_systemuser as u_4 on p.ownerid = u_4.Id
	left join Zavanti.vw_systemuser as u_5 on p.modifiedby = u_5.Id
	left join Zavanti.vw_systemuser as u_6 on p.modifiedonbehalfby = u_6.Id
	left join Zavanti.vw_systemuser as u_7 on p.owninguser = u_7.Id

	left join Zavanti.vw_opportunity as o on p.zav_currenttenancy = o.Id
	left join Zavanti.vw_zav_property as p_1 on p.zav_PropertySite = p_1.Id
	left join Zavanti.vw_zav_propertytype as pt on p.zav_propertytypeId = pt.Id
	left join Zavanti.vw_zav_subprogram as sp on p.zav_subprogram = sp.Id
	left join Zavanti.vw_zav_subpropertytype as spt on p.zav_subpropertytypeid = spt.Id
	left join Zavanti.vw_territory as terr on p.zav_territory = terr.Id
	left join Zavanti.vw_zav_postalregion as pr on p.new_postalregion = pr.Id
	left join Zavanti.vw_businessunit as bu on p.owningbusinessunit = bu.Id
	left join Zavanti.vw_team as t on p.owningteam = t.Id
	left join Zavanti.vw_zav_program as pg on p.zav_program = pg.Id
)



SELECT
	 p.property_id
	, g_opt.property_statecode
	, g_opt.property_statuscode
	, p.property_access_control_flag
	, p.property_access_control_agent
	, p.property_access_control_no_of_doors
	, p.property_access_control_type
	, p.property_acquired_date
	, p.property_age_of_ceiling_insulation_if_known1
	, p.property_age_of_underfloor_insulation_if_known1
	, p.property_agreed_rent_review_date
	, p.property_any_other_details_about_the_type_or_condition_if_known
	, p.property_asbestos_is_present_flag
	, p.property_assessment_number
	, p.property_assigned_tenancy_manager
	, p.property_backflow_preventor_flag
	, p.property_bc_service_name
	, p.property_bc_service_code
	, p.property_bedroom_keys
	, p.property_body_corp_contact_person
	, p.property_body_corporate_name
	, p.property_bond_amount
	, p.property_bond_amount_base
	, p.property_bond_comment
	, p.property_bond_lodged
	, p.property_bond_reference
	, p.property_borrowed_amount_base
	, p.property_building_warrant_of_fitness_date
	, p.property_building_warrant_of_fitness_details
	, p.property_business_phone_owner
	, p.property_bwof_date_obtained
	, p.property_bwof_exists_flag
	, g_opt.property_ceiling_insulation_location_coverage
	, g_opt.property_ceiling_insulation_standard
	, p.property_ceiling_insulation_status_ifno
	, p.property_ceiling_insulation_type_other
	, p.property_chintaro_id
	, p.property_city_name
	, p.property_comments
	, p.property_comments_for_vacant_property_report
	, p.property_comments_general
	, p.property_comments_keys
	, p.property_comments_other
	, p.property_compliance_schedule_applicable_flag
	, p.property_compliance_schedule_references
	, p.property_concatenated_address
	--, p.property_confirmed_disposal_date
	 ,CAST((p.property_confirmed_disposal_date AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_confirmed_disposal_date
	, p.property_contract_bc_service
	, p.property_contract_bc_service_code
	, p.property_cost_centre
	, p.property_country
	, p.property_crba8_gas_meter_location
	, p.property_crba8_number_of_levels
	, p.property_crba8_property_agent
	, p.property_crba8_property_agent_contact
	, p.property_created_by
	--, p.property_created_on
	 ,CAST((p.property_created_on AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_created_on
	, p.property_created_on_behalf_by
	, p.property_current_iqp
	, p.property_current_rent
	, p.property_current_rent_base
	, p.property_current_tenancy
	, p.property_date_constructed
	, p.property_date_insulation_was_last_upgraded
	, p.property_date_insulation_was_last_upgraded_na_flag
	, p.property_date_insulation_was_professionally_assessed
	, p.property_date_insulation_was_professionally_assessed_na_flag
	, p.property_date_next_bwof_due
	, p.property_date_next_bwof_due_text
	, p.property_days_available_to_let
	, p.property_days_under_maintenence
	, g_opt.property_deaf_smoke_alarms_indicator
	, p.property_delete_textdemo
	, p.property_delete_urldemo
	, p.property_disposal_date
	, p.property_district
	, p.property_do_we_have_allocation_rights_flag
	, p.property_eadivision
	, p.property_emergency_lighting_flag
	, p.property_exchange_rate
	, p.property_fire_alarms_flag
	, p.property_fire_blanket_flag
	, opt.property_fire_evacuation
	, p.property_fire_evacuation_registration_number
	, g_opt.property_fire_evacuation_trial_frequency
	, opt.property_fire_extinguisher_responsibility
	, g_opt.property_frequency
	, p.property_fridgekeys
	, p.property_full_address
	, g_opt.property_funding
	, p.property_gate_code
	, p.property_gate_remote
	, p.property_gifted_name
	, p.property_habitat_property_ref
	, p.property_hazard_list
	, g_opt.property_hazone
	, p.property_head_contractor
	, p.property_head_lease_exp_date
	, p.property_heat_detectors_flag
	, g_opt.property_heating_type_1
	, p.property_housing_first_flag
	, p.property_hud_contract_number
	, p.property_hud_msd_reference_number
	, p.property_if_partial_specify_areas_not_insulated
	--, p.property_image
	, p.property_image_id
	, p.property_image_timestamp
	, p.property_image_url
	, p.property_import_sequence_number
	, p.property_inhand
	, p.property_inhand_base
	, p.property_input_taxed_flag
	, p.property_insulation_ceiling_date
	, p.property_insulation_in_wall_date
	, g_opt.property_insulation_in_wall_type
	, p.property_insulation_is_in_at_least_a_reasonable_condition
	, p.property_insulation_is_in_at_least_a_reasonable_underflr
	, g_opt.property_insulation_under_floor_type
	, p.property_insulation_underflr_date
	, p.property_intended_disposal_date
	, p.property_irrs_balance
	, p.property_irrs_balance_base
	, p.property_irrs_charged_to
	, p.property_irrs_paid_to
	, p.property_is_delete_flag
	, p.property_is_ip
	, g_opt.property_is_there_enough_heating_capacity_in_the_property
	, p.property_is_this_tenancy_appropriately_housed_flag
	, opt.property_key_status
	, p.property_kitchen_cupboard_keys
	, p.property_land_area
	, p.property_land_information
	, g_opt.property_landlord_handback
	, p.property_last_valuation_base
	, p.property_latitude
	, p.property_lease_end_date
	, p.property_legacy_id
	, p.property_legal_owner
	, p.property_letter_box_keys
	, p.property_longitude
	, p.property_main_door_keys
	, p.property_main_gate_keys
	, g_opt.property_maintenance_responsible
	, p.property_market_rent
	, p.property_market_rent_base
	, p.property_master_key_id
	, p.property_mcps_flag
	, p.property_mechanical_ventilation_flag
	, p.property_meshblock
	, opt.property_meth_status
	, CAST(mse.zav_methstatusevidence as VARCHAR(250)  )as property_meth_status_evidence
	, opt.property_meth_status_on_entry
	, opt.property_meth_test_type
	, p.property_minimum_thickness_mm
	, p.property_minimum_thickness_na_for_foil
	, p.property_minimum_thickness_na_for_foil_mm
	, p.property_modified_by
	--, p.property_modified_on
	,CAST((p.property_modified_on AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_modified_on
	, p.property_modified_on_behalf_by
	, p.property_monitoring_agent
	, p.property_mortgaged_amount_base
	, p.property_name
	--, p.property_no_earth_stake
	, g_opt.property_no_of_bathrooms
	, p.property_no_of_fire_extinguishers
	, p.property_no_of_people_allowed_to_reside
	, p.property_no_of_rcds
	, p.property_no_of_rooms
	, p.property_no_of_smoke_alarms
	, p.property_nras_date
	, p.property_nras_dwelling_id
	, p.property_old_id
	, p.property_or_minimum_thickness
	, p.property_other_access_comments
	, p.property_overall_target_target
	, p.property_overridden_created_on
	, p.property_owner
	, p.property_owner_account
	, p.property_owner_contact
	--, p.property_owner_name
	--, p.property_property_owner_yomi_name
	, p.property_owner_organisation_contact_email
	, p.property_owning_business_unit
	, p.property_owning_team
	, p.property_owning_user
	, p.property_paint_colour
	, p.property_paint_manufacturer
	, p.property_parent_hierarchy
	, p.property_partial_specify_areas_not_insulated_underflr
	, p.property_partial_specify_areas_not_insulated_wall
	, p.property_passenger_lift_flag
	, p.property_postal_region
	, p.property_postcode
	, p.property_previous_contamination_flag
	, p.property_previous_contamination_date
	, g_opt.property_previous_status
	, p.property_primary_contractor
	, p.property_program
	, p.property_property_age
	, opt.property_property_classification
	, p.property_reference_id
	, p.property_property_manager
	, p.property_property_manager_email
	, p.property_property_manager_mobile_number
	, g_opt.property_property_ownership
	, p.property_property_service_name
	, p.property_property_service_code
	, p.property_property_type
	, p.property_provider_agreement_number
	, p.property_reason_for_disposal
	, p.property_refund_lodged
	, p.property_relative_url
	, p.property_relettable_date
	--, g_opt.property_rent_area_override
	, p.property_rescinded_disposal_date
	, p.property_resource_consent_applicable_flag
	, p.property_resource_consent_references
	, g_opt.property_responsible_for_maintenance
	, p.property_rubbish_collection_agency
	, g_opt.property_security_gate
	, p.property_security_system_agent
	, p.property_security_system_type
	, p.property_service_agents_vendor
	, opt.property_smoke_detector_type
	, g_opt.property_smoke_detectors
	, p.property_smoke_stop_doors_flag
	, p.property_specify_reason_for_inaccessibility
	, p.property_specify_reason_for_inaccessibility_underflr
	, p.property_sprinklers_flag
	-- , g_opt.property_state
	, g_opt.property_status
	, p.property_strata_company
	, p.property_street_name
	, p.property_street_number
	, p.property_sub_program
	, p.property_sub_property_type
	, p.property_suburb
	, p.property_swipecard
	, g_opt.property_target_group
	, p.property_tenure
	, p.property_territory
	, p.property_timezone_rule_version_number
	, p.property_total_days_vacant
	, p.property_total_heat_source_capacity_kw
	, p.property_total_irrs
	, p.property_total_irrs_base
	, p.property_total_irrs_date
	, p.property_total_irrs_state
	, p.property_transaction_currency_id_name
	, p.property_transitional_housing_market_rent_base
	, p.property_under_insulation_bulk_insulation_valuer_value
	, p.property_under_main_agreement_flag
	, g_opt.property_underfloor_insulation_standard
	, p.property_underfloor_insulation_status_ifno
	, g_opt.property_underfloor_location_coverage
	, p.property_underfloor_other_specify
	, p.property_unit
	, p.property_upi
	, p.property_utc_conversion_timezone_code
	, p.property_utility_room_code
	, p.property_utility_room_key
	, p.property_vacant_tenantable_target
	, p.property_vacant_untenantable_target
	, p.property_valuation
	, p.property_valuation_base
	, p.property_valuation_roll_number
	, p.property_version_number
	, g_opt.property_void_status
	, g_opt.property_wall_insulation_location_coverage
	, g_opt.property_wall_insulation_standard
	, p.property_wallpaper
	, p.property_warranty_expiry_date
	, p.property_windows_keys
	, g_opt.property_year_built
	, p.property_zav_transitional_housing_market_rent
	--, p.synapse_link_sink_modified_on
	 ,CAST((p.synapse_link_sink_modified_on AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on


FROM
 property_other_cte as p
 left join global_options_cte as g_opt on p.property_id = Id
 left join local_options_cte as opt on p.property_id = opt.Id
 left join methstatusevidence_cte as mse on p.property_id = mse.Id