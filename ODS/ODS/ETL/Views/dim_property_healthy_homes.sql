

 --1.9        2025/05/12    Manish Singh		Changing UTC date column to NZT

CREATE                                 VIEW [ETL].[dim_property_healthy_homes]

as

SELECT
id as property_healthy_homes_id
, CAST(s.LocalizedLabel as VARCHAR(10)) as property_healthy_homes_statecode
, CAST(ss.LocalizedLabel as VARCHAR(10)) as property_healthy_homes_statuscode
, CAST(opt_9.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_if_not_what_is_the_reason  
, CAST(g_opt_11.LocalizedLabel as VARCHAR(100)) as property_healthy_homes_reason_for_kitchen_exemption  
, CAST(g_opt_14.LocalizedLabel as VARCHAR(100)) as property_healthy_homes_are_the_exterior_walls_insulated  
, CAST(g_opt_21.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_do_all_habitable_rooms_of_the_property_have_a_door  
, CAST(g_opt_22.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_does_the_bathrooms_have_an_extraction_fan_which_vents_outside  
, CAST(g_opt_23.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_does_the_kitchen_have_an_extraction_fan_which_vents_outside  
, CAST(opt_25.LocalizedLabel as VARCHAR(50))as property_healthy_homes_extent_of_underfloor_insulation  
, CAST(opt_32.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_have_all_open_fireplaces_been_blocked  
, CAST(g_opt_34.LocalizedLabel as VARCHAR(250)) as property_healthy_homes_healthy_homes_compliance_statement  
, CAST(g_opt_37.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_if_a_moisture_barrier_is_not_in_place_what_is_the_reason  
, CAST(g_opt_38.LocalizedLabel as VARCHAR(50))as property_healthy_homes_if_the_ceiling_insulation_is_exempt_from_the_healthy_homes  
, CAST(opt_39.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_if_the_ceiling_insulation_is_exempt_underfloor  
, CAST(g_opt_40.LocalizedLabel as VARCHAR(50)) as  property_healthy_homes_if_the_property_is_exempt_from_requiring_a_moisture_barrier  
, CAST(g_opt_41.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_reason_for_non_compliance_of_bathroom_ventilation
, CAST(g_opt_42.LocalizedLabel as VARCHAR(100)) as property_healthy_homes_if_the_property_is_exempt_from_the_healthy_homes_kitchen  
, CAST(g_opt_43.LocalizedLabel as VARCHAR(100)) as property_healthy_homes_if_there_is_not_enough_heating_what_is_the_reason  
, CAST(g_opt_46.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_insulation_ceiling_condition  
, CAST(g_opt_47.LocalizedLabel as VARCHAR(20))as property_healthy_homes_insulation_ceiling_status  
, CAST(g_opt_48.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_insulation_ceiling_type  
, CAST(g_opt_49.LocalizedLabel as VARCHAR(20))as property_healthy_homes_insulation_in_wall_status  
, CAST(g_opt_51.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_insulation_under_floor_status  
, CAST(g_opt_53.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_is_an_appropriate_moisture_barrier_in_place_in_the_enclosed_subfloor  
, CAST(g_opt_54.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_is_the_bathroom_ventilation_compliant_with_the_healthy_homes  
, CAST(g_opt_55.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_is_the_guttering_and_downpiping_sufficient_for_drainage  
, CAST(g_opt_56.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_is_the_property_free_of_unintentional_or_unreasonable_gaps
, CAST(g_opt_59.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_kitchen_is_the_bathroom_ventilation_compliant  
, CAST(g_opt_61.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_main_heatsource  
, CAST(g_opt_81.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_reason_for_ceiling_insulation_exemption  
, CAST(g_opt_82.LocalizedLabel as VARCHAR(100)) as property_healthy_homes_reason_for_exemption_kitchen_ventilation
, CAST(g_opt_83.LocalizedLabel as VARCHAR(100)) as property_healthy_homes_reason_for_exemption_bathroom_ventilation  
, CAST(g_opt_87.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_secondary_heat_source
, CAST(g_opt_96.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_type_of_insulation_underfloor  
, CAST(g_opt_97.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_type_of_insulation_wall  
, CAST(g_opt_98.LocalizedLabel as VARCHAR(20)) as property_healthy_homes_underfloor_insulation_condition  
, CAST(g_opt_106.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_when_was_the_extraction_fan_installed  
, CAST(g_opt_107.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_when_was_the_extraction_fan_installed_kitchen_ventilation
, CAST(g_opt_108.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_which_habitable_rooms_have_no_door_or_window  
, CAST(g_opt_109.LocalizedLabel as VARCHAR(50)) as property_healthy_homes_why_is_this_room_exempt_from_the_healthy_homes_standard  
, CAST(g_opt_111.LocalizedLabel as VARCHAR(10)) as property_healthy_homes_year_insulation_was_installed_if_known  
, CAST(g_opt_112.LocalizedLabel as VARCHAR(10)) property_healthy_homes_year_insulation_was_installed_if_known_underfloor  
, CAST(g_opt_113.LocalizedLabel as VARCHAR(10)) as property_healthy_homes_year_insulation_was_installed_if_known_wall  
, CAST(CAST(p.zav_ageneralexemptionappliestothisproperty as BIT) as INT) as  property_healthy_homes_a_general_exemption_applies_to_this_property_flag
, CAST(CAST(p.zav_ceilinginsulationmeetsstandard as BIT) as INT) as  property_healthy_homes_ceiling_insulation_meets_standard_flag
, CAST(p.zav_kitchenthepropertyisexamptfromthehh as VARCHAR(3600)) as  property_healthy_homes_kitchen_the_property_is_exempt_from_the_healthy_home
, p.new_whatisexhaustcapacityoftheextractionunit as  property_healthy_homes_what_is_exhaust_capacity_of_the_extraction_unit 
, p.new_whatisexhaustcapacityofunit as  property_healthy_homes_what_is_exhaust_capacity_of_unit 
--, p.zav_dateinsulationwaslastinspected as  property_healthy_homes_date_insulation_was_last_inspected 
 ,CAST((p.zav_dateinsulationwaslastinspected AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_healthy_homes_date_insulation_was_last_inspected
--, p.zav_datetheunderfloorinsulationwaslastinspected as  property_healthy_homes_date_the_underfloor_insulation_was_last_inspected
,CAST(( p.zav_datetheunderfloorinsulationwaslastinspected AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_healthy_homes_date_the_underfloor_insulation_was_last_inspected
--, p.zav_healthyhomescompliancedate as  property_healthy_homes_compliance_date 
,CAST((p.zav_healthyhomescompliancedate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_healthy_homes_compliance_date
--, p.zav_healthyhomesstatementdate as  property_healthy_homes_statement_date 
,CAST((p.zav_healthyhomesstatementdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_healthy_homes_statement_date
, p.zav_hhbathroomventcompliancecomments as  property_healthy_homes_bathroom_vent_compliance_comments 
, p.zav_hhceilingcompliancecomments as  property_healthy_homes_ceiling_compliance_comments 
, p.zav_hhdraughtcompliancecomments as  property_healthy_homes_draught_compliance_comments 
, p.zav_hhextwallcompliancecomments as  property_healthy_homes_external_wall_compliance_comments 
, p.zav_hhhabroomscompliancecomments as  property_healthy_homes_habitable_rooms_compliance_comments 
, p.zav_hhheatingcompliancecomments as  property_healthy_homes_heating_compliance_comments 
, p.zav_hhkitchenventcompliancecomments as  property_healthy_homes_kitchen_vent_compliance_comments 
, p.zav_hhmoistdraincompliancecomments as  property_healthy_homes_moist_drain_compliance_comments 
, p.zav_hhunderfloorcompliancecomments as  property_healthy_homes_underfloor_compliance_comments 
, p.zav_kitchenwhatisthediameteroftheextractionun as  property_healthy_homes_kitchen_extraction_unit_diameter 
, p.zav_mainheatsourcecapacitykw as  property_healthy_homes_main_heat_source_capacity_kw 
, p.zav_requiredheatingcapacityforlivingareakw as  property_healthy_homes_required_heating_capacity_for_living_area_kw 
, p.zav_rvalueofinsulationifknown as  property_healthy_homes_r_value_of_insulation 
, p.zav_rvalueofinsulationifknownunderfloor as  property_healthy_homes_r_value_of_insulation_underfloor 
, p.zav_rvalueofinsulationifknownwall as  property_healthy_homes_r_value_of_insulation_wall 
, p.zav_secondaryheatsourcecapacitykw as  property_healthy_homes_secondaryheatsourcecapacitykw 
, p.zav_thicknessofinsulationifknown as  property_healthy_homes_thickness_of_insulation 
, p.zav_whatisthediameteroftheextractionunit as  property_healthy_homes_extraction_unit_diameter 
, CAST(CAST(p.[IsDelete] as BIT) as INT) as property_healthy_homes_is_delete_flag
--, p.SinkModifiedOn AS synapse_link_sink_modified_on
,CAST((p.SinkModifiedOn AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on
FROM 
Zavanti.vw_zav_property as p
 left join Zavanti.vw_StateMetadata as s on p.statecode = s.State and s.EntityName = 'zav_property'
 left join Zavanti.vw_StatusMetadata as ss on p.statuscode = ss.[Status] and ss.EntityName = 'zav_property'
 left join Zavanti.vw_OptionsetMetadata as opt_9 on p.new_ifnotwhatisthereason = opt_9.[Option] and opt_9.OptionSetName = 'new_ifnotwhatisthereason' and opt_9.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_11 on p.new_reasonforexemption = g_opt_11.[Option] and g_opt_11.OptionSetName = 'new_reasonforexemption' and g_opt_11.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_14 on p.zav_aretheexteriorwallsinsulated = g_opt_14.[Option] and g_opt_14.OptionSetName = 'zav_aretheexteriorwallsinsulated' and g_opt_14.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_21 on p.zav_doallhabitableroomsofthepropertyhaveadoor = g_opt_21.[Option] and g_opt_21.OptionSetName = 'zav_doallhabitableroomsofthepropertyhaveadoor' and g_opt_21.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_22 on p.zav_doesthebathroomshaveanextractionfanwhich = g_opt_22.[Option] and g_opt_22.OptionSetName = 'zav_doesthebathroomshaveanextractionfanwhich' and g_opt_22.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_23 on p.zav_doesthekitchenhaveanextractionfanwhichven = g_opt_23.[Option] and g_opt_23.OptionSetName = 'zav_doesthekitchenhaveanextractionfanwhichven' and g_opt_23.EntityName = 'zav_property'
 left join Zavanti.vw_OptionsetMetadata as opt_25 on p.zav_extentofunderfloorinsulation = opt_25.[Option] and opt_25.OptionSetName = 'zav_extentofunderfloorinsulation' and opt_25.EntityName = 'zav_property'
 left join Zavanti.vw_OptionsetMetadata as opt_32 on p.zav_haveallopenfireplacesbeenblocked = opt_32.[Option] and opt_32.OptionSetName = 'zav_haveallopenfireplacesbeenblocked' and opt_32.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_34 on p.zav_healthyhomescompliancestatement = g_opt_34.[Option] and g_opt_34.OptionSetName = 'zav_healthyhomescompliancestatement' and g_opt_34.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_37 on p.zav_ifamoisturebarrierisnotinplacewhatisthe = g_opt_37.[Option] and g_opt_37.OptionSetName = 'zav_ifamoisturebarrierisnotinplacewhatisthe' and g_opt_37.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_38 on p.zav_iftheceilinginsulationisexemptfromtheheal = g_opt_38.[Option] and g_opt_38.OptionSetName = 'zav_iftheceilinginsulationisexemptfromtheheal' and g_opt_38.EntityName = 'zav_property'
 left join Zavanti.vw_OptionsetMetadata as opt_39 on p.zav_iftheceilinginsulationisexemptunderfloor = opt_39.[Option] and opt_39.OptionSetName = 'zav_iftheceilinginsulationisexemptunderfloor' and opt_39.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_40 on p.zav_ifthepropertyisexemptfromrequiringamoistu = g_opt_40.[Option] and g_opt_40.OptionSetName = 'zav_ifthepropertyisexemptfromrequiringamoistu' and g_opt_40.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_41 on p.zav_ifthepropertyisexemptfromthehealthyhomesb = g_opt_41.[Option] and g_opt_41.OptionSetName = 'zav_ifthepropertyisexemptfromthehealthyhomesb' and g_opt_41.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_42 on p.zav_ifthepropertyisexemptfromthehhkitchen = g_opt_42.[Option] and g_opt_42.OptionSetName = 'zav_ifthepropertyisexemptfromthehhkitchen' and g_opt_42.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_43 on p.zav_ifthereisnotenoughheatingwhatisthereason = g_opt_43.[Option] and g_opt_43.OptionSetName = 'zav_ifthereisnotenoughheatingwhatisthereason' and g_opt_43.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_46 on p.zav_insulationceilingcondition = g_opt_46.[Option] and g_opt_46.OptionSetName = 'zav_insulationceilingcondition' and g_opt_46.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_47 on p.zav_insulationceilingstatus = g_opt_47.[Option] and g_opt_47.OptionSetName = 'zav_insulationceilingstatus' and g_opt_47.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_48 on p.zav_insulationceilingtype = g_opt_48.[Option] and g_opt_48.OptionSetName = 'zav_insulationceilingtype' and g_opt_48.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_49 on p.zav_insulationinwallstatus = g_opt_49.[Option] and g_opt_49.OptionSetName = 'zav_insulationinwallstatus' and g_opt_49.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_51 on p.zav_insulationunderflrstatus = g_opt_51.[Option] and g_opt_51.OptionSetName = 'zav_insulationunderflrstatus' and g_opt_51.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_53 on p.zav_isanappropriatemoisturebarrierinplaceinth = g_opt_53.[Option] and g_opt_53.OptionSetName = 'zav_isanappropriatemoisturebarrierinplaceinth' and g_opt_53.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_54 on p.zav_isthebathroomventilationcompliantwiththeh = g_opt_54.[Option] and g_opt_54.OptionSetName = 'zav_isthebathroomventilationcompliantwiththeh' and g_opt_54.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_55 on p.zav_isthegutteringanddownpipingsufficientford = g_opt_55.[Option] and g_opt_55.OptionSetName = 'zav_isthegutteringanddownpipingsufficientford' and g_opt_55.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_56 on p.zav_isthepropertyfreeofunintentionalorunreaso = g_opt_56.[Option] and g_opt_56.OptionSetName = 'zav_isthepropertyfreeofunintentionalorunreaso' and g_opt_56.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_59 on p.zav_kitchenisthebathroomventilationcompliant = g_opt_59.[Option] and g_opt_59.OptionSetName = 'zav_kitchenisthebathroomventilationcompliant' and g_opt_59.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_61 on p.zav_mainheatsource = g_opt_61.[Option] and g_opt_61.OptionSetName = 'zav_mainheatsource' and g_opt_61.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_81 on p.zav_reasonforceilinginsulationexemption = g_opt_81.[Option] and g_opt_81.OptionSetName = 'zav_reasonforceilinginsulationexemption' and g_opt_81.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_82 on p.zav_reasonforexemption = g_opt_82.[Option] and g_opt_82.OptionSetName = 'zav_reasonforexemption' and g_opt_82.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_83 on p.zav_reasonforexemptionbathroomvartilation = g_opt_83.[Option] and g_opt_83.OptionSetName = 'zav_reasonforexemptionbathroomvartilation' and g_opt_83.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_87 on p.zav_secondaryheatsourcetopup = g_opt_87.[Option] and g_opt_87.OptionSetName = 'zav_secondaryheatsourcetopup' and g_opt_87.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_96 on p.zav_typeofinsulationunderfloor = g_opt_96.[Option] and g_opt_96.OptionSetName = 'zav_typeofinsulationunderfloor' and g_opt_96.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_97 on p.zav_typeofinsulationwall = g_opt_97.[Option] and g_opt_97.OptionSetName = 'zav_typeofinsulationwall' and g_opt_97.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_98 on p.zav_underfloorinsulationcondition = g_opt_98.[Option] and g_opt_98.OptionSetName = 'zav_underfloorinsulationcondition' and g_opt_98.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_106 on p.zav_whenwastheextractionfaninstalled = g_opt_106.[Option] and g_opt_106.OptionSetName = 'zav_whenwastheextractionfaninstalled' and g_opt_106.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_107 on p.zav_whenwastheextractionfaninstalledkitchenve = g_opt_107.[Option] and g_opt_107.OptionSetName = 'zav_whenwastheextractionfaninstalledkitchenve' and g_opt_107.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_108 on p.zav_whichhabitableroomshavenodoororwindow = g_opt_108.[Option] and g_opt_108.OptionSetName = 'zav_whichhabitableroomshavenodoororwindow' and g_opt_108.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_109 on p.zav_whyisthisroomexemptfromthehealthyhomessta = g_opt_109.[Option] and g_opt_109.OptionSetName = 'zav_whyisthisroomexemptfromthehealthyhomessta' and g_opt_109.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_111 on p.zav_yearinsulationwasinstalledifknown = g_opt_111.[Option] and g_opt_111.OptionSetName = 'zav_yearinsulationwasinstalledifknown' and g_opt_111.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_112 on p.zav_yearinsulationwasinstalledifknownunderflo = g_opt_112.[Option] and g_opt_112.OptionSetName = 'zav_yearinsulationwasinstalledifknownunderflo' and g_opt_112.EntityName = 'zav_property'
 left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_113 on p.zav_yearinsulationwasinstalledifknownwall = g_opt_113.[Option] and g_opt_113.OptionSetName = 'zav_yearinsulationwasinstalledifknownwall' and g_opt_113.EntityName = 'zav_property'