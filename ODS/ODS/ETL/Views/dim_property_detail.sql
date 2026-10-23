
CREATE                               VIEW [ETL].[dim_property_detail]

/**********************************************************************************************************
 Procedure	[edw].[Updateedwdim_property_detail]
 Author		Stefen Hasselberg
 Created	2024-01-11	
 Purpose		Updates dim_property_detail from staging
		
 Notes: Call By	EDW Pipeline '30_Load_From_ODS'
 =========================================================================================================

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-01-11	  Manish Singh		    Initial version
1.9     2025/05/12    Manish Singh		    Changing UTC date column to NZT
2.0     2026-02-20    GitHub Copilot        Removed 14 redundant columns per work item 12210

**********************************************************************************************************/


as

    SELECT
        id as property_detail_id
 , CAST(s.LocalizedLabel as VARCHAR(10)) as property_detail_statecode
 , CAST(ss.LocalizedLabel as VARCHAR(10)) as property_detail_statuscode
 , CAST(g_opt_6.LocalizedLabel as VARCHAR(50)) as property_detail_crba8_gas_supply_type  
 , CAST(g_opt_7.LocalizedLabel as VARCHAR(10)) as property_detail_crba8_no_of_bathrooms_no_toilet  
 , CAST(g_opt_8.LocalizedLabel as VARCHAR(10)) as property_detail_crba8_no_of_bathrooms_with_toilet  
 , CAST(g_opt_13.LocalizedLabel as VARCHAR(50)) as property_detail_accessibility  
 , CAST(g_opt_15.LocalizedLabel as VARCHAR(10)) as property_detail_body_corporate_applies_indicator  
 , CAST(g_opt_18.LocalizedLabel as VARCHAR(50)) as property_detail_cladding_type  
 , CAST(g_opt_19.LocalizedLabel as VARCHAR(50)) as property_detail_construction_type  
 , CAST(g_opt_31.LocalizedLabel as VARCHAR(10)) as property_detail_garage_1  
 , CAST(g_opt_36.LocalizedLabel as VARCHAR(50)) as property_detail_hot_water_type  
 , CAST(g_opt_44.LocalizedLabel as VARCHAR(50)) as property_detail_inspection_interval  
 , CAST(g_opt_45.LocalizedLabel as VARCHAR(50)) as property_detail_inspection_type  
 , CAST(g_opt_67.LocalizedLabel as VARCHAR(10)) as property_detail_no_of_bedrooms  
 , CAST(g_opt_68.LocalizedLabel as VARCHAR(50)) as property_detail_no_of_carport  
 , CAST(g_opt_69.LocalizedLabel as VARCHAR(10)) as property_detail_no_of_double_bedrooms  
 , CAST(g_opt_70.LocalizedLabel as VARCHAR(20)) as property_detail_no_of_levels  
 , CAST(g_opt_71.LocalizedLabel as VARCHAR(10)) as property_detail_no_of_single_bedrooms  
 , CAST(g_opt_72.LocalizedLabel as VARCHAR(10)) as property_detail_no_of_toilets  
 , CAST(g_opt_73.LocalizedLabel as VARCHAR(10)) as property_detail_no_parkingspaces  
 , CAST(g_opt_74.LocalizedLabel as VARCHAR(10)) as property_detail_offstreet_parking  
 , CAST(g_opt_75.LocalizedLabel as VARCHAR(20)) as property_detail_power  
 , CAST(opt_78.LocalizedLabel as VARCHAR(50)) as property_detail_condition_rating  
 , CAST(g_opt_86.LocalizedLabel as VARCHAR(50)) as property_detail_roof_type  
 , CAST(g_opt_89.LocalizedLabel as VARCHAR(20)) as property_detail_sewerage  
 , CAST(g_opt_93.LocalizedLabel as VARCHAR(50)) as  property_detail_stove_type_new  
 , CAST(opt_95.LocalizedLabel as VARCHAR(20)) as property_detail_tv_connection  
 , CAST(g_opt_104.LocalizedLabel as VARCHAR(10)) as property_detail_water  
 , CAST(CAST(zav_walkinshower as BIT) as INT) as  property_detail_walkin_shower_flag
 , CAST(CAST(zav_wheelchairramp as BIT) as INT) as  property_detail_wheelchair_ramp_flag
 , crba8_externalgasbottlelocation as  property_detail_crba8_external_gas_bottle_location 
 , CAST(zav_accessibilitysummary as VARCHAR(3600)) as  property_detail_accessibility_summary 
 , CAST(zav_certificateoftitle as VARCHAR(50)) as  property_detail_certificate_of_title 
 , CAST(zav_districtcounciloffice as VARCHAR(200) ) as property_detail_district_council_office 
 , CAST(zav_electricitymeterlocation as VARCHAR(100))as  property_detail_electricity_meter_location 
 , CAST(zav_electricitysupplier as VARCHAR(100)) as  property_detail_electricity_supplier 
 , zav_floorarea as  property_detail_floor_area 
 , CAST(zav_gasmeterlocation as VARCHAR(50)) as  property_detail_gas_meter_location 
 , CAST(zav_gassupplier as VARCHAR(20) ) as  property_detail_gas_supplier 
 , CAST(zav_icpnumber as VARCHAR(50) ) as  property_detail_icp_number 
 , zav_lastinspection as  property_detail_last_inspection_date 
 , CAST(zav_legaldescription as VARCHAR(50)) as  property_detail_legal_description 
 , CAST(zav_locationofcircuitboard as VARCHAR(100) ) as  property_detail_location_of_circuit_board 
 , zav_nextinspection as  property_detail_next_inspection_date 
 , zav_onlinedate as  property_detail_online_date 
 , zav_pcrlastupdateddate as  property_detail_pcr_last_updated_date 
 , zav_returneddate as  property_detail_returned_date 
 , CAST(zav_tilecolour as VARCHAR(250) ) as  property_detail_tile_colour 
 , CAST(zav_tiletype as VARCHAR(250)) as  property_detail_tile_type 
 , CAST((zav_valuationdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_detail_valuation_date
 , CAST(zav_valuationnumber as VARCHAR(50)) as  property_detail_valuation_number 
 , CAST(zav_valuationrollnum as VARCHAR(50) ) as  property_detail_valuation_roll_number
 , CAST(zav_vinylcolour as VARCHAR(250))as  property_detail_vinyl_colour 
 , CAST(zav_vinylspecification as VARCHAR(250) ) as  property_detail_vinyl_specification 
 , CAST(zav_watermeterlocationtext as VARCHAR(250) ) as  property_detail_watermeter_location_text 
 , CAST(g_opt_105.LocalizedLabel as VARCHAR(50)) as property_detail_water_meter  
 , CAST(zav_watermeternumber as VARCHAR(50)  ) as  property_detail_water_meter_number 
 , zav_rubbishbinserialnumber as property_detail_rubbish_bin_serial_number
 , CAST(zav_watercomments as VARCHAR(3600) ) as   property_detail_water_comment
 , p.zav_watermeterlocationname as  property_detail_water_meter_location_name 
 , CAST(CAST(p.[IsDelete] as BIT) as INT) as property_details_is_delete_flag
 , CAST((p.SinkModifiedOn AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on


    FROM Zavanti.vw_zav_property as p
        left join Zavanti.vw_StateMetadata as s on p.statecode = s.State and s.EntityName = 'zav_property'
        left join Zavanti.vw_StatusMetadata as ss on p.statuscode = ss.[Status] and ss.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_6 on p.crba8_gassupplytype = g_opt_6.[Option] and g_opt_6.OptionSetName = 'crba8_gassupplytype' and g_opt_6.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_7 on p.crba8_noofbathroomsnotoilet = g_opt_7.[Option] and g_opt_7.OptionSetName = 'crba8_noofbathroomsnotoilet' and g_opt_7.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_8 on p.crba8_noofbathroomswithtoilet = g_opt_8.[Option] and g_opt_8.OptionSetName = 'crba8_noofbathroomswithtoilet' and g_opt_8.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_13 on p.zav_accessibility = g_opt_13.[Option] and g_opt_13.OptionSetName = 'zav_accessibility' and g_opt_13.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_15 on p.zav_bodycorporateappliesindicator = g_opt_15.[Option] and g_opt_15.OptionSetName = 'zav_bodycorporateappliesindicator' and g_opt_15.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_18 on p.zav_claddingtype = g_opt_18.[Option] and g_opt_18.OptionSetName = 'zav_claddingtype' and g_opt_18.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_19 on p.zav_constructiontype = g_opt_19.[Option] and g_opt_19.OptionSetName = 'zav_constructiontype' and g_opt_19.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_31 on p.zav_garage1 = g_opt_31.[Option] and g_opt_31.OptionSetName = 'zav_garage1' and g_opt_31.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_36 on p.zav_hotwatertype = g_opt_36.[Option] and g_opt_36.OptionSetName = 'zav_hotwatertype'and g_opt_36.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_44 on p.zav_inspectioninterval = g_opt_44.[Option] and g_opt_44.OptionSetName = 'zav_inspectioninterval' and g_opt_44.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_45 on p.zav_inspectiontype = g_opt_45.[Option] and g_opt_45.OptionSetName = 'zav_inspectiontype' and g_opt_45.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_67 on p.zav_noofbedrooms = g_opt_67.[Option] and g_opt_67.OptionSetName = 'zav_noofbedrooms' and g_opt_67.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_68 on p.zav_noofcarport = g_opt_68.[Option] and g_opt_68.OptionSetName = 'zav_noofcarport' and g_opt_68.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_69 on p.zav_noofdoublebedrooms = g_opt_69.[Option] and g_opt_69.OptionSetName = 'zav_noofdoublebedrooms' and g_opt_69.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_70 on p.zav_nooflevels = g_opt_70.[Option] and g_opt_70.OptionSetName = 'zav_nooflevels' and g_opt_70.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_71 on p.zav_noofsinglebedrooms = g_opt_71.[Option] and g_opt_71.OptionSetName = 'zav_noofsinglebedrooms' and g_opt_71.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_72 on p.zav_nooftoilets = g_opt_72.[Option] and g_opt_72.OptionSetName = 'zav_nooftoilets' and g_opt_72.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_73 on p.zav_noparkingspaces = g_opt_73.[Option] and g_opt_73.OptionSetName = 'zav_noparkingspaces' and g_opt_73.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_74 on p.zav_offstreetparking = g_opt_74.[Option] and g_opt_74.OptionSetName = 'zav_offstreetparking' and g_opt_74.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_75 on p.zav_power = g_opt_75.[Option] and g_opt_75.OptionSetName = 'zav_power' and g_opt_75.EntityName = 'zav_property'
        left join Zavanti.vw_OptionsetMetadata as opt_78 on p.zav_propertyconditionrating = opt_78.[Option] and opt_78.OptionSetName = 'zav_propertyconditionrating' and opt_78.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_86 on p.zav_rooftype = g_opt_86.[Option] and g_opt_86.OptionSetName = 'zav_rooftype' and g_opt_86.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_89 on p.zav_sewerage = g_opt_89.[Option] and g_opt_89.OptionSetName = 'zav_sewerage' and g_opt_89.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_93 on p.zav_stovetypenew = g_opt_93.[Option] and g_opt_93.OptionSetName = 'zav_stovetypenew' and g_opt_93.EntityName = 'zav_property'
        left join Zavanti.vw_OptionsetMetadata as opt_95 on p.zav_tvconnection = opt_95.[Option] and opt_95.OptionSetName = 'zav_tvconnection' and opt_95.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_104 on p.zav_water = g_opt_104.[Option] and g_opt_104.OptionSetName = 'zav_water' and g_opt_104.EntityName = 'zav_property'
        left join Zavanti.vw_GlobalOptionsetMetadata as g_opt_105 on p.zav_watermeter = g_opt_105.[Option] and g_opt_105.OptionSetName = 'zav_watermeter' and g_opt_105.EntityName = 'zav_property'