CREATE VIEW [Zavanti].[vw_zav_property]
AS

SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[crba8_gassupplytype]
,[crba8_noofbathroomsnotoilet]
,[crba8_noofbathroomswithtoilet]
,[new_ifnotwhatisthereason]
,[new_propertystatus]
,[new_reasonforexemption]
,[new_yearbuilt]
,[zav_accessibility]
,[zav_aretheexteriorwallsinsulated]
,[zav_bodycorporateappliesindicator]
,[zav_ceilinginsulationlocationcoverage]
,[zav_ceilinginsulationstandard]
,[zav_claddingtype]
,[zav_constructiontype]
,[zav_deafsmokealarmsindicator]
,[zav_doallhabitableroomsofthepropertyhaveadoor]
,[zav_doesthebathroomshaveanextractionfanwhich]
,[zav_doesthekitchenhaveanextractionfanwhichven]
,[zav_extentofunderfloorinsulation]
,[zav_fireevacuation]
,[zav_fireevacuationtrialfrequency]
,[zav_fireextinguisherresponsibility]
,[zav_frequency]
,[zav_funding]
,[zav_garage1]
,[zav_haveallopenfireplacesbeenblocked]
,[zav_hazone]
,[zav_healthyhomescompliancestatement]
,[zav_heatingtype1]
,[zav_hotwatertype]
,[zav_ifamoisturebarrierisnotinplacewhatisthe]
,[zav_iftheceilinginsulationisexemptfromtheheal]
,[zav_iftheceilinginsulationisexemptunderfloor]
,[zav_ifthepropertyisexemptfromrequiringamoistu]
,[zav_ifthepropertyisexemptfromthehealthyhomesb]
,[zav_ifthepropertyisexemptfromthehhkitchen]
,[zav_ifthereisnotenoughheatingwhatisthereason]
,[zav_inspectioninterval]
,[zav_inspectiontype]
,[zav_insulationceilingcondition]
,[zav_insulationceilingstatus]
,[zav_insulationceilingtype]
,[zav_insulationinwallstatus]
,[zav_insulationinwalltype]
,[zav_insulationunderflrstatus]
,[zav_insulationunderflrtype]
,[zav_isanappropriatemoisturebarrierinplaceinth]
,[zav_isthebathroomventilationcompliantwiththeh]
,[zav_isthegutteringanddownpipingsufficientford]
,[zav_isthepropertyfreeofunintentionalorunreaso]
,[zav_isthereenoughheatingcapacityintheproperty]
,[zav_keystatus]
,[zav_kitchenisthebathroomventilationcompliant]
,[zav_landlordhandback]
,[zav_mainheatsource]
,[zav_maintenanceresponsible]
,[zav_methstatus]
,[zav_methstatusonentry]
,[zav_methtesttype]
,[zav_noofbathrooms]
,[zav_noofbedrooms]
,[zav_noofcarport]
,[zav_noofdoublebedrooms]
,[zav_nooflevels]
,[zav_noofsinglebedrooms]
,[zav_nooftoilets]
,[zav_noparkingspaces]
,[zav_offstreetparking]
,[zav_power]
,[zav_previousstatus]
,[zav_propertyclassification]
,[zav_propertyconditionrating]
,[zav_propertyownership]
,[zav_propertytype]
,[zav_reasonforceilinginsulationexemption]
,[zav_reasonforexemption]
,[zav_reasonforexemptionbathroomvartilation]
,[zav_rentareaoverride]
,[zav_responsibleformaintenance]
,[zav_rooftype]
,[zav_secondaryheatsourcetopup]
,[zav_securitygate]
,[zav_sewerage]
,[zav_smokedetectors]
,[zav_smokedetectortype]
,[zav_state]
,[zav_stovetypenew]
,[zav_targetgroup]
,[zav_tvconnection]
,[zav_typeofinsulationunderfloor]
,[zav_typeofinsulationwall]
,[zav_underfloorinsulationcondition]
,[zav_underfloorinsulationstandard]
,[zav_underfloorlocationcoverage]
,[zav_voidstatus]
,[zav_wallinsulationlocationcoverage]
,[zav_wallinsulationstandard]
,[zav_water]
,[zav_watermeter]
,[zav_whenwastheextractionfaninstalled]
,[zav_whenwastheextractionfaninstalledkitchenve]
,[zav_whichhabitableroomshavenodoororwindow]
,[zav_whyisthisroomexemptfromthehealthyhomessta]
,[zav_windowtype]
,[zav_yearinsulationwasinstalledifknown]
,[zav_yearinsulationwasinstalledifknownunderflo]
,[zav_yearinsulationwasinstalledifknownwall]
,[zav_methstatusevidence]
,[new_asbestosispresent]
,[zav_accesscontrol]
,[zav_ageneralexemptionappliestothisproperty]
,[zav_backflowpreventor]
,[zav_bwofexists]
,[zav_ceilinginsulationmeetsstandard]
,[zav_compliancescheduleapplicable]
,[zav_dateinsulationwaslastupgradedna]
,[zav_dateinsulationwasprofessionallyassessedna]
,[zav_dowehaveallocationrights]
,[zav_emergencylighting]
,[zav_firealarms]
,[zav_fireblanket]
,[zav_heatdetectors]
,[zav_housingfirst]
,[zav_inputtaxed]
,[zav_isthistenancyappropriatelyhoused]
,[zav_mcps]
,[zav_mechanicalventilation]
,[zav_mortgagedproperty]
,[zav_passengerlift]
,[zav_previouscontamination]
,[zav_resourceconsentapplicable]
,[zav_smokestopdoors]
,[zav_sprinklers]
,[zav_undermainagreement]
,[zav_walkinshower]
,[zav_wheelchairramp]
,[crba8_propertyagent]
,[crba8_propertyagent_entitytype]
,[crba8_propertyagentcontact]
,[crba8_propertyagentcontact_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_postalregion]
,[new_postalregion_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_assignedtenancymanager]
,[zav_assignedtenancymanager_entitytype]
,[zav_bodycorpcontactperson]
,[zav_bodycorpcontactperson_entitytype]
,[zav_bodycorporate]
,[zav_bodycorporate_entitytype]
,[zav_city]
,[zav_city_entitytype]
,[zav_contractbcservicename]
,[zav_contractbcservicename_entitytype]
,[zav_currenttenancy]
,[zav_currenttenancy_entitytype]
,[zav_haprogram]
,[zav_haprogram_entitytype]
,[zav_headcontractor]
,[zav_headcontractor_entitytype]
,[zav_legalownerid]
,[zav_legalownerid_entitytype]
,[zav_primarycontractor]
,[zav_primarycontractor_entitytype]
,[zav_program]
,[zav_program_entitytype]
,[zav_propertybcservicename]
,[zav_propertybcservicename_entitytype]
,[zav_propertymanager]
,[zav_propertymanager_entitytype]
,[zav_propertymanagerid]
,[zav_propertymanagerid_entitytype]
,[zav_propertyowner]
,[zav_propertyowner_entitytype]
,[zav_propertyowneraccount]
,[zav_propertyowneraccount_entitytype]
,[zav_propertyownercontact]
,[zav_propertyownercontact_entitytype]
,[zav_propertysite]
,[zav_propertysite_entitytype]
,[zav_propertytypeid]
,[zav_propertytypeid_entitytype]
,[zav_rubbishcollectionagency]
,[zav_rubbishcollectionagency_entitytype]
,[zav_stratacompany]
,[zav_stratacompany_entitytype]
,[zav_subprogram]
,[zav_subprogram_entitytype]
,[zav_subpropertytypeid]
,[zav_subpropertytypeid_entitytype]
,[zav_territory]
,[zav_territory_entitytype]
,[zav_watermeterlocation]
,[zav_watermeterlocation_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_bondamount]
,[zav_bondamount_base]
,[zav_borrowedamount]
,[zav_borrowedamount_base]
,[zav_currentrent]
,[zav_currentrent_base]
,[zav_inhand]
,[zav_inhand_base]
,[zav_irrsbalance]
,[zav_irrsbalance_base]
,[zav_lastvaluation]
,[zav_lastvaluation_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_mortgagedamount]
,[zav_mortgagedamount_base]
,[zav_totalirrs]
,[zav_totalirrs_base]
,[zav_transitionalhousingmarketrent]
,[zav_transitionalhousingmarketrent_base]
,[zav_valuation]
,[zav_valuation_base]
,[crba8_externalgasbottlelocation]
,[crba8_gasmeterlocation]
,[crba8_numberoflevels]
,[crba8_propertyagentcontactname]
,[crba8_propertyagentcontactyominame]
,[crba8_propertyagentname]
,[crba8_propertyagentyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[new_country]
,[new_hazardlist]
,[new_landinformation]
,[new_leaseenddate]
,[new_overalltargettarget]
,[new_postalregionname]
,[new_propertyage]
,[new_propertyid]
,[new_vacanttenantabletarget]
,[new_vacantuntenantabletarget]
,[new_whatisexhaustcapacityoftheextractionunit]
,[new_whatisexhaustcapacityofunit]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accesscontrolagent]
,[zav_accesscontrolnoofdoors]
,[zav_accesscontroltype]
,[zav_accessdoorcode]
,[zav_accessibilitysummary]
,[zav_acquireddate]
,[zav_ageofceilinginsulationifknown1]
,[zav_ageofunderfloorinsulationifknown1]
,[zav_agreedrentreviewdate]
,[zav_anyotherdetailsaboutthetypeorconditionifk]
,[zav_assessmentnum]
,[zav_assessmentnumber]
,[zav_assignedtenancymanagername]
,[zav_assignedtenancymanageryominame]
,[zav_bedroomkeys]
,[zav_bodycorpcontactpersonname]
,[zav_bodycorpcontactpersonyominame]
,[zav_bodycorporatename]
,[zav_bodycorporateyominame]
,[zav_bondcomment]
,[zav_bondlodged]
,[zav_bondreference]
,[zav_buildingwarrantoffitnessdate]
,[zav_buildingwarrantoffitnessdetails]
,[zav_businessphoneowner]
,[zav_bwofdateobtained]
,[zav_carpetcolour]
,[zav_carpetspecification]
,[zav_ceilinginsulationstatusifno]
,[zav_ceilinginsulationtypeother]
,[zav_certificateoftitle]
,[zav_chargedto]
,[zav_chintaroid]
,[zav_cityname]
,[zav_comments]
,[zav_commentsforvacantpropertyreport]
,[zav_commentsgeneral]
,[zav_commentskeys]
,[zav_complianceschedulereferences]
,[zav_concatenatedaddress]
,[zav_confirmeddisposaldate]
,[zav_contractbcservicenamename]
,[zav_contractservicename]
,[zav_costcentre]
,[zav_currentiqp]
,[zav_currenttenancyname]
,[zav_dateconstructed]
,[zav_dateinsulationwaslastinspected]
,[zav_dateinsulationwaslastupgraded]
,[zav_dateinsulationwasprofessionallyassessed]
,[zav_datenextbwofdue]
,[zav_datenextbwofduetext]
,[zav_datetheunderfloorinsulationwaslastinspected]
,[zav_daysavailabletolet]
,[zav_daysundermaintenence]
,[zav_delete_textdemo]
,[zav_delete_urldemo]
,[zav_disposaldate]
,[zav_districtcounciloffice]
,[zav_eadivision]
,[zav_electricityaccount]
,[zav_electricitymeterlocation]
,[zav_electricitysupplier]
,[zav_fireevacuationregno]
,[zav_floorarea]
,[zav_fridgekeys]
,[zav_fulladdress]
,[zav_gasmeteraccount]
,[zav_gasmeterlocation]
,[zav_gassupplier]
,[zav_gatecode]
,[zav_gateremote]
,[zav_giftedname]
,[zav_habitatpropertyref]
,[zav_haprogramname]
,[zav_headcontractorname]
,[zav_headcontractoryominame]
,[zav_headleaseexpdate]
,[zav_healthyhomescompliancedate]
,[zav_healthyhomesstatementdate]
,[zav_hhbathroomventcompliancecomments]
,[zav_hhceilingcompliancecomments]
,[zav_hhdraughtcompliancecomments]
,[zav_hhextwallcompliancecomments]
,[zav_hhhabroomscompliancecomments]
,[zav_hhheatingcompliancecomments]
,[zav_hhkitchenventcompliancecomments]
,[zav_hhmoistdraincompliancecomments]
,[zav_hhunderfloorcompliancecomments]
,[zav_hudcontractnumber]
,[zav_hudmsdreferencenumber]
,[zav_icpnumber]
,[zav_id]
,[zav_ifpartialspecifyareasnotinsulated]
,[zav_insulationceilingdate]
,[zav_insulationinwalldate]
,[zav_insulationisinatleastareasonablecondition]
,[zav_insulationisinatleastareasonableunderflr]
,[zav_insulationunderflrdate]
,[zav_intendeddisposaldate]
,[zav_irrschargedto]
,[zav_irrspaidto]
,[zav_isip]
,[zav_kitchencupboardkeys]
,[zav_kitchenthepropertyisexamptfromthehh]
,[zav_kitchenwhatisthediameteroftheextractionun]
,[zav_landarea]
,[zav_landareawhole]
,[zav_lastinspection]
,[zav_lastrenovationdate]
,[zav_latitude]
,[zav_legacyid]
,[zav_legaldescription]
,[zav_legalowner]
,[zav_legalowneridname]
,[zav_legalowneridyominame]
,[zav_letterboxkeys]
,[zav_locationofcircuitboard]
,[zav_longitude]
,[zav_maindoorkeys]
,[zav_maingatekeys]
,[zav_mainheatsourcecapacitykw]
,[zav_masterkeyid]
,[zav_meshblock]
,[zav_minimumthicknessmm]
,[zav_minimumthicknessnaforfoil]
,[zav_minimumthicknessnaforfoilmm]
,[zav_monitoringagent]
,[zav_name]
,[zav_nextinspection]
,[zav_noearthstake]
,[zav_nooffireextinguishers]
,[zav_norcds]
,[zav_nosmokealarms]
,[zav_nrasdate]
,[zav_nrasdwellingid]
,[zav_numberofpeopleallowedtoreside]
,[zav_onlinedate]
,[zav_orminimumthickness]
,[zav_otheraccesscomments]
,[zav_owneremail]
,[zav_paintcolour]
,[zav_paintmanufacturer]
,[zav_partialspecifyareasnotinsulatedunderflr]
,[zav_partialspecifyareasnotinsulatedwall]
,[zav_pcrlastupdateddate]
,[zav_postalcode]
,[zav_previouscontaminationdate]
,[zav_primarycontractorname]
,[zav_primarycontractoryominame]
,[zav_programname]
,[zav_propertybcservicenamename]
,[zav_propertycomments]
,[zav_propertyid]
,[zav_propertyimage]
,[zav_propertyimage_timestamp]
,[zav_propertyimage_url]
,[zav_propertyimageid]
,[zav_propertymanageremail]
,[zav_propertymanageridname]
,[zav_propertymanageridyominame]
,[zav_propertymanagermobile]
,[zav_propertymanagername]
,[zav_propertymanageryominame]
,[zav_propertyowneraccountname]
,[zav_propertyowneraccountyominame]
,[zav_propertyownercontactname]
,[zav_propertyownercontactyominame]
,[zav_propertyownername]
,[zav_propertyowneryominame]
,[zav_propertyservicename]
,[zav_propertysitename]
,[zav_propertytypeidname]
,[zav_provideragreementnumber]
,[zav_reasonfordisposal]
,[zav_refundlodged]
,[zav_relativeurl]
,[zav_relettabledate]
,[zav_requiredheatingcapacityforlivingareakw]
,[zav_rescindeddisposaldate]
,[zav_resourceconsentreferences]
,[zav_returneddate]
,[zav_roomnumber]
,[zav_rubbishbinserialnumber]
,[zav_rubbishcollectionagencyname]
,[zav_rubbishcollectionagencyyominame]
,[zav_rvalueofinsulationifknown]
,[zav_rvalueofinsulationifknownunderfloor]
,[zav_rvalueofinsulationifknownwall]
,[zav_secondaryheatsourcecapacitykw]
,[zav_securitysystemagent]
,[zav_securitysystemtype]
,[zav_serviceagentsvendor]
,[zav_specifyreasonforinaccessibility]
,[zav_specifyreasonforinaccessibilityunderflr]
,[zav_stratacompanyname]
,[zav_stratacompanyyominame]
,[zav_street1]
,[zav_streetname]
,[zav_subprogramname]
,[zav_subpropertytypeidname]
,[zav_suburb]
,[zav_swipecard]
,[zav_tenure]
,[zav_territoryname]
,[zav_thicknessofinsulationifknown]
,[zav_tilecolour]
,[zav_tiletype]
,[zav_totaldaysvacant]
,[zav_totalheatsourcecapacitykw]
,[zav_totalirrs_date]
,[zav_totalirrs_state]
,[zav_underfloorinsulationstatusifno]
,[zav_underfloorotherspecify]
,[zav_underinsulationbulkinsulationvaluervalue]
,[zav_unit]
,[zav_upi]
,[zav_utilityroomcode]
,[zav_utilityroomkey]
,[zav_valuationdate]
,[zav_valuationnumber]
,[zav_valuationrollnum]
,[zav_valuationrollnumber]
,[zav_vinylcolour]
,[zav_vinylspecification]
,[zav_wallpaper]
,[zav_warrantyexpirydate]
,[zav_watercomments]
,[zav_watermeterlocationname]
,[zav_watermeterlocationtext]
,[zav_watermeternumber]
,[zav_whatisthediameteroftheextractionunit]
,[zav_windowskeys]
,[IsDelete]
FROM
(
SELECT 
[Id]
,[SinkCreatedOn]
,[SinkModifiedOn]
,[statecode]
,[statuscode]
,[crba8_gassupplytype]
,[crba8_noofbathroomsnotoilet]
,[crba8_noofbathroomswithtoilet]
,[new_ifnotwhatisthereason]
,[new_propertystatus]
,[new_reasonforexemption]
,[new_yearbuilt]
,[zav_accessibility]
,[zav_aretheexteriorwallsinsulated]
,[zav_bodycorporateappliesindicator]
,[zav_ceilinginsulationlocationcoverage]
,[zav_ceilinginsulationstandard]
,[zav_claddingtype]
,[zav_constructiontype]
,[zav_deafsmokealarmsindicator]
,[zav_doallhabitableroomsofthepropertyhaveadoor]
,[zav_doesthebathroomshaveanextractionfanwhich]
,[zav_doesthekitchenhaveanextractionfanwhichven]
,[zav_extentofunderfloorinsulation]
,[zav_fireevacuation]
,[zav_fireevacuationtrialfrequency]
,[zav_fireextinguisherresponsibility]
,[zav_frequency]
,[zav_funding]
,[zav_garage1]
,[zav_haveallopenfireplacesbeenblocked]
,[zav_hazone]
,[zav_healthyhomescompliancestatement]
,[zav_heatingtype1]
,[zav_hotwatertype]
,[zav_ifamoisturebarrierisnotinplacewhatisthe]
,[zav_iftheceilinginsulationisexemptfromtheheal]
,[zav_iftheceilinginsulationisexemptunderfloor]
,[zav_ifthepropertyisexemptfromrequiringamoistu]
,[zav_ifthepropertyisexemptfromthehealthyhomesb]
,[zav_ifthepropertyisexemptfromthehhkitchen]
,[zav_ifthereisnotenoughheatingwhatisthereason]
,[zav_inspectioninterval]
,[zav_inspectiontype]
,[zav_insulationceilingcondition]
,[zav_insulationceilingstatus]
,[zav_insulationceilingtype]
,[zav_insulationinwallstatus]
,[zav_insulationinwalltype]
,[zav_insulationunderflrstatus]
,[zav_insulationunderflrtype]
,[zav_isanappropriatemoisturebarrierinplaceinth]
,[zav_isthebathroomventilationcompliantwiththeh]
,[zav_isthegutteringanddownpipingsufficientford]
,[zav_isthepropertyfreeofunintentionalorunreaso]
,[zav_isthereenoughheatingcapacityintheproperty]
,[zav_keystatus]
,[zav_kitchenisthebathroomventilationcompliant]
,[zav_landlordhandback]
,[zav_mainheatsource]
,[zav_maintenanceresponsible]
,[zav_methstatus]
,[zav_methstatusonentry]
,[zav_methtesttype]
,[zav_noofbathrooms]
,[zav_noofbedrooms]
,[zav_noofcarport]
,[zav_noofdoublebedrooms]
,[zav_nooflevels]
,[zav_noofsinglebedrooms]
,[zav_nooftoilets]
,[zav_noparkingspaces]
,[zav_offstreetparking]
,[zav_power]
,[zav_previousstatus]
,[zav_propertyclassification]
,[zav_propertyconditionrating]
,[zav_propertyownership]
,[zav_propertytype]
,[zav_reasonforceilinginsulationexemption]
,[zav_reasonforexemption]
,[zav_reasonforexemptionbathroomvartilation]
,[zav_rentareaoverride]
,[zav_responsibleformaintenance]
,[zav_rooftype]
,[zav_secondaryheatsourcetopup]
,[zav_securitygate]
,[zav_sewerage]
,[zav_smokedetectors]
,[zav_smokedetectortype]
,[zav_state]
,[zav_stovetypenew]
,[zav_targetgroup]
,[zav_tvconnection]
,[zav_typeofinsulationunderfloor]
,[zav_typeofinsulationwall]
,[zav_underfloorinsulationcondition]
,[zav_underfloorinsulationstandard]
,[zav_underfloorlocationcoverage]
,[zav_voidstatus]
,[zav_wallinsulationlocationcoverage]
,[zav_wallinsulationstandard]
,[zav_water]
,[zav_watermeter]
,[zav_whenwastheextractionfaninstalled]
,[zav_whenwastheextractionfaninstalledkitchenve]
,[zav_whichhabitableroomshavenodoororwindow]
,[zav_whyisthisroomexemptfromthehealthyhomessta]
,[zav_windowtype]
,[zav_yearinsulationwasinstalledifknown]
,[zav_yearinsulationwasinstalledifknownunderflo]
,[zav_yearinsulationwasinstalledifknownwall]
,[zav_methstatusevidence]
,[new_asbestosispresent]
,[zav_accesscontrol]
,[zav_ageneralexemptionappliestothisproperty]
,[zav_backflowpreventor]
,[zav_bwofexists]
,[zav_ceilinginsulationmeetsstandard]
,[zav_compliancescheduleapplicable]
,[zav_dateinsulationwaslastupgradedna]
,[zav_dateinsulationwasprofessionallyassessedna]
,[zav_dowehaveallocationrights]
,[zav_emergencylighting]
,[zav_firealarms]
,[zav_fireblanket]
,[zav_heatdetectors]
,[zav_housingfirst]
,[zav_inputtaxed]
,[zav_isthistenancyappropriatelyhoused]
,[zav_mcps]
,[zav_mechanicalventilation]
,[zav_mortgagedproperty]
,[zav_passengerlift]
,[zav_previouscontamination]
,[zav_resourceconsentapplicable]
,[zav_smokestopdoors]
,[zav_sprinklers]
,[zav_undermainagreement]
,[zav_walkinshower]
,[zav_wheelchairramp]
,[crba8_propertyagent]
,[crba8_propertyagent_entitytype]
,[crba8_propertyagentcontact]
,[crba8_propertyagentcontact_entitytype]
,[createdby]
,[createdby_entitytype]
,[createdonbehalfby]
,[createdonbehalfby_entitytype]
,[modifiedby]
,[modifiedby_entitytype]
,[modifiedonbehalfby]
,[modifiedonbehalfby_entitytype]
,[new_postalregion]
,[new_postalregion_entitytype]
,[owningbusinessunit]
,[owningbusinessunit_entitytype]
,[owningteam]
,[owningteam_entitytype]
,[owninguser]
,[owninguser_entitytype]
,[transactioncurrencyid]
,[transactioncurrencyid_entitytype]
,[zav_assignedtenancymanager]
,[zav_assignedtenancymanager_entitytype]
,[zav_bodycorpcontactperson]
,[zav_bodycorpcontactperson_entitytype]
,[zav_bodycorporate]
,[zav_bodycorporate_entitytype]
,[zav_city]
,[zav_city_entitytype]
,[zav_contractbcservicename]
,[zav_contractbcservicename_entitytype]
,[zav_currenttenancy]
,[zav_currenttenancy_entitytype]
,[zav_haprogram]
,[zav_haprogram_entitytype]
,[zav_headcontractor]
,[zav_headcontractor_entitytype]
,[zav_legalownerid]
,[zav_legalownerid_entitytype]
,[zav_primarycontractor]
,[zav_primarycontractor_entitytype]
,[zav_program]
,[zav_program_entitytype]
,[zav_propertybcservicename]
,[zav_propertybcservicename_entitytype]
,[zav_propertymanager]
,[zav_propertymanager_entitytype]
,[zav_propertymanagerid]
,[zav_propertymanagerid_entitytype]
,[zav_propertyowner]
,[zav_propertyowner_entitytype]
,[zav_propertyowneraccount]
,[zav_propertyowneraccount_entitytype]
,[zav_propertyownercontact]
,[zav_propertyownercontact_entitytype]
,[zav_propertysite]
,[zav_propertysite_entitytype]
,[zav_propertytypeid]
,[zav_propertytypeid_entitytype]
,[zav_rubbishcollectionagency]
,[zav_rubbishcollectionagency_entitytype]
,[zav_stratacompany]
,[zav_stratacompany_entitytype]
,[zav_subprogram]
,[zav_subprogram_entitytype]
,[zav_subpropertytypeid]
,[zav_subpropertytypeid_entitytype]
,[zav_territory]
,[zav_territory_entitytype]
,[zav_watermeterlocation]
,[zav_watermeterlocation_entitytype]
,[ownerid]
,[ownerid_entitytype]
,[zav_bondamount]
,[zav_bondamount_base]
,[zav_borrowedamount]
,[zav_borrowedamount_base]
,[zav_currentrent]
,[zav_currentrent_base]
,[zav_inhand]
,[zav_inhand_base]
,[zav_irrsbalance]
,[zav_irrsbalance_base]
,[zav_lastvaluation]
,[zav_lastvaluation_base]
,[zav_marketrent]
,[zav_marketrent_base]
,[zav_mortgagedamount]
,[zav_mortgagedamount_base]
,[zav_totalirrs]
,[zav_totalirrs_base]
,[zav_transitionalhousingmarketrent]
,[zav_transitionalhousingmarketrent_base]
,[zav_valuation]
,[zav_valuation_base]
,[crba8_externalgasbottlelocation]
,[crba8_gasmeterlocation]
,[crba8_numberoflevels]
,[crba8_propertyagentcontactname]
,[crba8_propertyagentcontactyominame]
,[crba8_propertyagentname]
,[crba8_propertyagentyominame]
,[createdbyname]
,[createdbyyominame]
,[createdon]
,[createdonbehalfbyname]
,[createdonbehalfbyyominame]
,[exchangerate]
,[importsequencenumber]
,[modifiedbyname]
,[modifiedbyyominame]
,[modifiedon]
,[modifiedonbehalfbyname]
,[modifiedonbehalfbyyominame]
,[new_country]
,[new_hazardlist]
,[new_landinformation]
,[new_leaseenddate]
,[new_overalltargettarget]
,[new_postalregionname]
,[new_propertyage]
,[new_propertyid]
,[new_vacanttenantabletarget]
,[new_vacantuntenantabletarget]
,[new_whatisexhaustcapacityoftheextractionunit]
,[new_whatisexhaustcapacityofunit]
,[overriddencreatedon]
,[owneridname]
,[owneridtype]
,[owneridyominame]
,[owningbusinessunitname]
,[timezoneruleversionnumber]
,[transactioncurrencyidname]
,[utcconversiontimezonecode]
,[versionnumber]
,[zav_accesscontrolagent]
,[zav_accesscontrolnoofdoors]
,[zav_accesscontroltype]
,[zav_accessdoorcode]
,[zav_accessibilitysummary]
,[zav_acquireddate]
,[zav_ageofceilinginsulationifknown1]
,[zav_ageofunderfloorinsulationifknown1]
,[zav_agreedrentreviewdate]
,[zav_anyotherdetailsaboutthetypeorconditionifk]
,[zav_assessmentnum]
,[zav_assessmentnumber]
,[zav_assignedtenancymanagername]
,[zav_assignedtenancymanageryominame]
,[zav_bedroomkeys]
,[zav_bodycorpcontactpersonname]
,[zav_bodycorpcontactpersonyominame]
,[zav_bodycorporatename]
,[zav_bodycorporateyominame]
,[zav_bondcomment]
,[zav_bondlodged]
,[zav_bondreference]
,[zav_buildingwarrantoffitnessdate]
,[zav_buildingwarrantoffitnessdetails]
,[zav_businessphoneowner]
,[zav_bwofdateobtained]
,[zav_carpetcolour]
,[zav_carpetspecification]
,[zav_ceilinginsulationstatusifno]
,[zav_ceilinginsulationtypeother]
,[zav_certificateoftitle]
,[zav_chargedto]
,[zav_chintaroid]
,[zav_cityname]
,[zav_comments]
,[zav_commentsforvacantpropertyreport]
,[zav_commentsgeneral]
,[zav_commentskeys]
,[zav_complianceschedulereferences]
,[zav_concatenatedaddress]
,[zav_confirmeddisposaldate]
,[zav_contractbcservicenamename]
,[zav_contractservicename]
,[zav_costcentre]
,[zav_currentiqp]
,[zav_currenttenancyname]
,[zav_dateconstructed]
,[zav_dateinsulationwaslastinspected]
,[zav_dateinsulationwaslastupgraded]
,[zav_dateinsulationwasprofessionallyassessed]
,[zav_datenextbwofdue]
,[zav_datenextbwofduetext]
,[zav_datetheunderfloorinsulationwaslastinspected]
,[zav_daysavailabletolet]
,[zav_daysundermaintenence]
,[zav_delete_textdemo]
,[zav_delete_urldemo]
,[zav_disposaldate]
,[zav_districtcounciloffice]
,[zav_eadivision]
,[zav_electricityaccount]
,[zav_electricitymeterlocation]
,[zav_electricitysupplier]
,[zav_fireevacuationregno]
,[zav_floorarea]
,[zav_fridgekeys]
,[zav_fulladdress]
,[zav_gasmeteraccount]
,[zav_gasmeterlocation]
,[zav_gassupplier]
,[zav_gatecode]
,[zav_gateremote]
,[zav_giftedname]
,[zav_habitatpropertyref]
,[zav_haprogramname]
,[zav_headcontractorname]
,[zav_headcontractoryominame]
,[zav_headleaseexpdate]
,[zav_healthyhomescompliancedate]
,[zav_healthyhomesstatementdate]
,[zav_hhbathroomventcompliancecomments]
,[zav_hhceilingcompliancecomments]
,[zav_hhdraughtcompliancecomments]
,[zav_hhextwallcompliancecomments]
,[zav_hhhabroomscompliancecomments]
,[zav_hhheatingcompliancecomments]
,[zav_hhkitchenventcompliancecomments]
,[zav_hhmoistdraincompliancecomments]
,[zav_hhunderfloorcompliancecomments]
,[zav_hudcontractnumber]
,[zav_hudmsdreferencenumber]
,[zav_icpnumber]
,[zav_id]
,[zav_ifpartialspecifyareasnotinsulated]
,[zav_insulationceilingdate]
,[zav_insulationinwalldate]
,[zav_insulationisinatleastareasonablecondition]
,[zav_insulationisinatleastareasonableunderflr]
,[zav_insulationunderflrdate]
,[zav_intendeddisposaldate]
,[zav_irrschargedto]
,[zav_irrspaidto]
,[zav_isip]
,[zav_kitchencupboardkeys]
,[zav_kitchenthepropertyisexamptfromthehh]
,[zav_kitchenwhatisthediameteroftheextractionun]
,[zav_landarea]
,[zav_landareawhole]
,[zav_lastinspection]
,[zav_lastrenovationdate]
,[zav_latitude]
,[zav_legacyid]
,[zav_legaldescription]
,[zav_legalowner]
,[zav_legalowneridname]
,[zav_legalowneridyominame]
,[zav_letterboxkeys]
,[zav_locationofcircuitboard]
,[zav_longitude]
,[zav_maindoorkeys]
,[zav_maingatekeys]
,[zav_mainheatsourcecapacitykw]
,[zav_masterkeyid]
,[zav_meshblock]
,[zav_minimumthicknessmm]
,[zav_minimumthicknessnaforfoil]
,[zav_minimumthicknessnaforfoilmm]
,[zav_monitoringagent]
,[zav_name]
,[zav_nextinspection]
,[zav_noearthstake]
,[zav_nooffireextinguishers]
,[zav_norcds]
,[zav_nosmokealarms]
,[zav_nrasdate]
,[zav_nrasdwellingid]
,[zav_numberofpeopleallowedtoreside]
,[zav_onlinedate]
,[zav_orminimumthickness]
,[zav_otheraccesscomments]
,[zav_owneremail]
,[zav_paintcolour]
,[zav_paintmanufacturer]
,[zav_partialspecifyareasnotinsulatedunderflr]
,[zav_partialspecifyareasnotinsulatedwall]
,[zav_pcrlastupdateddate]
,[zav_postalcode]
,[zav_previouscontaminationdate]
,[zav_primarycontractorname]
,[zav_primarycontractoryominame]
,[zav_programname]
,[zav_propertybcservicenamename]
,[zav_propertycomments]
,[zav_propertyid]
,[zav_propertyimage]
,[zav_propertyimage_timestamp]
,[zav_propertyimage_url]
,[zav_propertyimageid]
,[zav_propertymanageremail]
,[zav_propertymanageridname]
,[zav_propertymanageridyominame]
,[zav_propertymanagermobile]
,[zav_propertymanagername]
,[zav_propertymanageryominame]
,[zav_propertyowneraccountname]
,[zav_propertyowneraccountyominame]
,[zav_propertyownercontactname]
,[zav_propertyownercontactyominame]
,[zav_propertyownername]
,[zav_propertyowneryominame]
,[zav_propertyservicename]
,[zav_propertysitename]
,[zav_propertytypeidname]
,[zav_provideragreementnumber]
,[zav_reasonfordisposal]
,[zav_refundlodged]
,[zav_relativeurl]
,[zav_relettabledate]
,[zav_requiredheatingcapacityforlivingareakw]
,[zav_rescindeddisposaldate]
,[zav_resourceconsentreferences]
,[zav_returneddate]
,[zav_roomnumber]
,[zav_rubbishbinserialnumber]
,[zav_rubbishcollectionagencyname]
,[zav_rubbishcollectionagencyyominame]
,[zav_rvalueofinsulationifknown]
,[zav_rvalueofinsulationifknownunderfloor]
,[zav_rvalueofinsulationifknownwall]
,[zav_secondaryheatsourcecapacitykw]
,[zav_securitysystemagent]
,[zav_securitysystemtype]
,[zav_serviceagentsvendor]
,[zav_specifyreasonforinaccessibility]
,[zav_specifyreasonforinaccessibilityunderflr]
,[zav_stratacompanyname]
,[zav_stratacompanyyominame]
,[zav_street1]
,[zav_streetname]
,[zav_subprogramname]
,[zav_subpropertytypeidname]
,[zav_suburb]
,[zav_swipecard]
,[zav_tenure]
,[zav_territoryname]
,[zav_thicknessofinsulationifknown]
,[zav_tilecolour]
,[zav_tiletype]
,[zav_totaldaysvacant]
,[zav_totalheatsourcecapacitykw]
,[zav_totalirrs_date]
,[zav_totalirrs_state]
,[zav_underfloorinsulationstatusifno]
,[zav_underfloorotherspecify]
,[zav_underinsulationbulkinsulationvaluervalue]
,[zav_unit]
,[zav_upi]
,[zav_utilityroomcode]
,[zav_utilityroomkey]
,[zav_valuationdate]
,[zav_valuationnumber]
,[zav_valuationrollnum]
,[zav_valuationrollnumber]
,[zav_vinylcolour]
,[zav_vinylspecification]
,[zav_wallpaper]
,[zav_warrantyexpirydate]
,[zav_watercomments]
,[zav_watermeterlocationname]
,[zav_watermeterlocationtext]
,[zav_watermeternumber]
,[zav_whatisthediameteroftheextractionunit]
,[zav_windowskeys]
,[IsDelete]

	,ROW_NUMBER() OVER (PARTITION BY id ORDER BY [SinkModifiedOn] DESC) AS row_num -- used to identify latest record 
FROM OPENROWSET(
   BULK 'https://stdevaussvcwaharoa01.dfs.core.windows.net/dataverse-development-unq1cbc77b3627646c9a4491204085ce/zav_property/*.csv',FORMAT = 'CSV',
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 1
) 
WITH
(
[Id] [uniqueidentifier]
,[SinkCreatedOn] [datetime2](7)
,[SinkModifiedOn] [datetime2](7)
,[statecode] [bigint]
,[statuscode] [bigint]
,[crba8_gassupplytype] [bigint]
,[crba8_noofbathroomsnotoilet] [bigint]
,[crba8_noofbathroomswithtoilet] [bigint]
,[new_ifnotwhatisthereason] [bigint]
,[new_propertystatus] [bigint]
,[new_reasonforexemption] [bigint]
,[new_yearbuilt] [bigint]
,[zav_accessibility] [bigint]
,[zav_aretheexteriorwallsinsulated] [bigint]
,[zav_bodycorporateappliesindicator] [bigint]
,[zav_ceilinginsulationlocationcoverage] [bigint]
,[zav_ceilinginsulationstandard] [bigint]
,[zav_claddingtype] [bigint]
,[zav_constructiontype] [bigint]
,[zav_deafsmokealarmsindicator] [bigint]
,[zav_doallhabitableroomsofthepropertyhaveadoor] [bigint]
,[zav_doesthebathroomshaveanextractionfanwhich] [bigint]
,[zav_doesthekitchenhaveanextractionfanwhichven] [bigint]
,[zav_extentofunderfloorinsulation] [bigint]
,[zav_fireevacuation] [bigint]
,[zav_fireevacuationtrialfrequency] [bigint]
,[zav_fireextinguisherresponsibility] [bigint]
,[zav_frequency] [bigint]
,[zav_funding] [bigint]
,[zav_garage1] [bigint]
,[zav_haveallopenfireplacesbeenblocked] [bigint]
,[zav_hazone] [bigint]
,[zav_healthyhomescompliancestatement] [bigint]
,[zav_heatingtype1] [bigint]
,[zav_hotwatertype] [bigint]
,[zav_ifamoisturebarrierisnotinplacewhatisthe] [bigint]
,[zav_iftheceilinginsulationisexemptfromtheheal] [bigint]
,[zav_iftheceilinginsulationisexemptunderfloor] [bigint]
,[zav_ifthepropertyisexemptfromrequiringamoistu] [bigint]
,[zav_ifthepropertyisexemptfromthehealthyhomesb] [bigint]
,[zav_ifthepropertyisexemptfromthehhkitchen] [bigint]
,[zav_ifthereisnotenoughheatingwhatisthereason] [bigint]
,[zav_inspectioninterval] [bigint]
,[zav_inspectiontype] [bigint]
,[zav_insulationceilingcondition] [bigint]
,[zav_insulationceilingstatus] [bigint]
,[zav_insulationceilingtype] [bigint]
,[zav_insulationinwallstatus] [bigint]
,[zav_insulationinwalltype] [bigint]
,[zav_insulationunderflrstatus] [bigint]
,[zav_insulationunderflrtype] [bigint]
,[zav_isanappropriatemoisturebarrierinplaceinth] [bigint]
,[zav_isthebathroomventilationcompliantwiththeh] [bigint]
,[zav_isthegutteringanddownpipingsufficientford] [bigint]
,[zav_isthepropertyfreeofunintentionalorunreaso] [bigint]
,[zav_isthereenoughheatingcapacityintheproperty] [bigint]
,[zav_keystatus] [bigint]
,[zav_kitchenisthebathroomventilationcompliant] [bigint]
,[zav_landlordhandback] [bigint]
,[zav_mainheatsource] [bigint]
,[zav_maintenanceresponsible] [bigint]
,[zav_methstatus] [bigint]
,[zav_methstatusonentry] [bigint]
,[zav_methtesttype] [bigint]
,[zav_noofbathrooms] [bigint]
,[zav_noofbedrooms] [bigint]
,[zav_noofcarport] [bigint]
,[zav_noofdoublebedrooms] [bigint]
,[zav_nooflevels] [bigint]
,[zav_noofsinglebedrooms] [bigint]
,[zav_nooftoilets] [bigint]
,[zav_noparkingspaces] [bigint]
,[zav_offstreetparking] [bigint]
,[zav_power] [bigint]
,[zav_previousstatus] [bigint]
,[zav_propertyclassification] [bigint]
,[zav_propertyconditionrating] [bigint]
,[zav_propertyownership] [bigint]
,[zav_propertytype] [bigint]
,[zav_reasonforceilinginsulationexemption] [bigint]
,[zav_reasonforexemption] [bigint]
,[zav_reasonforexemptionbathroomvartilation] [bigint]
,[zav_rentareaoverride] [bigint]
,[zav_responsibleformaintenance] [bigint]
,[zav_rooftype] [bigint]
,[zav_secondaryheatsourcetopup] [bigint]
,[zav_securitygate] [bigint]
,[zav_sewerage] [bigint]
,[zav_smokedetectors] [bigint]
,[zav_smokedetectortype] [bigint]
,[zav_state] [bigint]
,[zav_stovetypenew] [bigint]
,[zav_targetgroup] [bigint]
,[zav_tvconnection] [bigint]
,[zav_typeofinsulationunderfloor] [bigint]
,[zav_typeofinsulationwall] [bigint]
,[zav_underfloorinsulationcondition] [bigint]
,[zav_underfloorinsulationstandard] [bigint]
,[zav_underfloorlocationcoverage] [bigint]
,[zav_voidstatus] [bigint]
,[zav_wallinsulationlocationcoverage] [bigint]
,[zav_wallinsulationstandard] [bigint]
,[zav_water] [bigint]
,[zav_watermeter] [bigint]
,[zav_whenwastheextractionfaninstalled] [bigint]
,[zav_whenwastheextractionfaninstalledkitchenve] [bigint]
,[zav_whichhabitableroomshavenodoororwindow] [bigint]
,[zav_whyisthisroomexemptfromthehealthyhomessta] [bigint]
,[zav_windowtype] [bigint]
,[zav_yearinsulationwasinstalledifknown] [bigint]
,[zav_yearinsulationwasinstalledifknownunderflo] [bigint]
,[zav_yearinsulationwasinstalledifknownwall] [bigint]
,[zav_methstatusevidence] [varchar](8000)
,[new_asbestosispresent] [varchar](6)
,[zav_accesscontrol] [varchar](6)
,[zav_ageneralexemptionappliestothisproperty] [varchar](6)
,[zav_backflowpreventor] [varchar](6)
,[zav_bwofexists] [varchar](6)
,[zav_ceilinginsulationmeetsstandard] [varchar](6)
,[zav_compliancescheduleapplicable] [varchar](6)
,[zav_dateinsulationwaslastupgradedna] [varchar](6)
,[zav_dateinsulationwasprofessionallyassessedna] [varchar](6)
,[zav_dowehaveallocationrights] [varchar](6)
,[zav_emergencylighting] [varchar](6)
,[zav_firealarms] [varchar](6)
,[zav_fireblanket] [varchar](6)
,[zav_heatdetectors] [varchar](6)
,[zav_housingfirst] [varchar](6)
,[zav_inputtaxed] [varchar](6)
,[zav_isthistenancyappropriatelyhoused] [varchar](6)
,[zav_mcps] [varchar](6)
,[zav_mechanicalventilation] [varchar](6)
,[zav_mortgagedproperty] [varchar](6)
,[zav_passengerlift] [varchar](6)
,[zav_previouscontamination] [varchar](6)
,[zav_resourceconsentapplicable] [varchar](6)
,[zav_smokestopdoors] [varchar](6)
,[zav_sprinklers] [varchar](6)
,[zav_undermainagreement] [varchar](6)
,[zav_walkinshower] [varchar](6)
,[zav_wheelchairramp] [varchar](6)
,[crba8_propertyagent] [uniqueidentifier]
,[crba8_propertyagent_entitytype] [varchar](256)
,[crba8_propertyagentcontact] [uniqueidentifier]
,[crba8_propertyagentcontact_entitytype] [varchar](256)
,[createdby] [uniqueidentifier]
,[createdby_entitytype] [varchar](256)
,[createdonbehalfby] [uniqueidentifier]
,[createdonbehalfby_entitytype] [varchar](256)
,[modifiedby] [uniqueidentifier]
,[modifiedby_entitytype] [varchar](256)
,[modifiedonbehalfby] [uniqueidentifier]
,[modifiedonbehalfby_entitytype] [varchar](256)
,[new_postalregion] [uniqueidentifier]
,[new_postalregion_entitytype] [varchar](256)
,[owningbusinessunit] [uniqueidentifier]
,[owningbusinessunit_entitytype] [varchar](256)
,[owningteam] [uniqueidentifier]
,[owningteam_entitytype] [varchar](256)
,[owninguser] [uniqueidentifier]
,[owninguser_entitytype] [varchar](256)
,[transactioncurrencyid] [uniqueidentifier]
,[transactioncurrencyid_entitytype] [varchar](256)
,[zav_assignedtenancymanager] [uniqueidentifier]
,[zav_assignedtenancymanager_entitytype] [varchar](256)
,[zav_bodycorpcontactperson] [uniqueidentifier]
,[zav_bodycorpcontactperson_entitytype] [varchar](256)
,[zav_bodycorporate] [uniqueidentifier]
,[zav_bodycorporate_entitytype] [varchar](256)
,[zav_city] [uniqueidentifier]
,[zav_city_entitytype] [varchar](256)
,[zav_contractbcservicename] [uniqueidentifier]
,[zav_contractbcservicename_entitytype] [varchar](256)
,[zav_currenttenancy] [uniqueidentifier]
,[zav_currenttenancy_entitytype] [varchar](256)
,[zav_haprogram] [uniqueidentifier]
,[zav_haprogram_entitytype] [varchar](256)
,[zav_headcontractor] [uniqueidentifier]
,[zav_headcontractor_entitytype] [varchar](256)
,[zav_legalownerid] [uniqueidentifier]
,[zav_legalownerid_entitytype] [varchar](256)
,[zav_primarycontractor] [uniqueidentifier]
,[zav_primarycontractor_entitytype] [varchar](256)
,[zav_program] [uniqueidentifier]
,[zav_program_entitytype] [varchar](256)
,[zav_propertybcservicename] [uniqueidentifier]
,[zav_propertybcservicename_entitytype] [varchar](256)
,[zav_propertymanager] [uniqueidentifier]
,[zav_propertymanager_entitytype] [varchar](256)
,[zav_propertymanagerid] [uniqueidentifier]
,[zav_propertymanagerid_entitytype] [varchar](256)
,[zav_propertyowner] [uniqueidentifier]
,[zav_propertyowner_entitytype] [varchar](256)
,[zav_propertyowneraccount] [uniqueidentifier]
,[zav_propertyowneraccount_entitytype] [varchar](256)
,[zav_propertyownercontact] [uniqueidentifier]
,[zav_propertyownercontact_entitytype] [varchar](256)
,[zav_propertysite] [uniqueidentifier]
,[zav_propertysite_entitytype] [varchar](256)
,[zav_propertytypeid] [uniqueidentifier]
,[zav_propertytypeid_entitytype] [varchar](256)
,[zav_rubbishcollectionagency] [uniqueidentifier]
,[zav_rubbishcollectionagency_entitytype] [varchar](256)
,[zav_stratacompany] [uniqueidentifier]
,[zav_stratacompany_entitytype] [varchar](256)
,[zav_subprogram] [uniqueidentifier]
,[zav_subprogram_entitytype] [varchar](256)
,[zav_subpropertytypeid] [uniqueidentifier]
,[zav_subpropertytypeid_entitytype] [varchar](256)
,[zav_territory] [uniqueidentifier]
,[zav_territory_entitytype] [varchar](256)
,[zav_watermeterlocation] [uniqueidentifier]
,[zav_watermeterlocation_entitytype] [varchar](256)
,[ownerid] [uniqueidentifier]
,[ownerid_entitytype] [varchar](256)
,[zav_bondamount] [decimal](38,4)
,[zav_bondamount_base] [decimal](38,4)
,[zav_borrowedamount] [decimal](38,4)
,[zav_borrowedamount_base] [decimal](38,4)
,[zav_currentrent] [decimal](38,4)
,[zav_currentrent_base] [decimal](38,4)
,[zav_inhand] [decimal](38,4)
,[zav_inhand_base] [decimal](38,4)
,[zav_irrsbalance] [decimal](38,4)
,[zav_irrsbalance_base] [decimal](38,4)
,[zav_lastvaluation] [decimal](38,4)
,[zav_lastvaluation_base] [decimal](38,4)
,[zav_marketrent] [decimal](38,4)
,[zav_marketrent_base] [decimal](38,4)
,[zav_mortgagedamount] [decimal](38,4)
,[zav_mortgagedamount_base] [decimal](38,4)
,[zav_totalirrs] [decimal](38,2)
,[zav_totalirrs_base] [decimal](38,2)
,[zav_transitionalhousingmarketrent] [decimal](38,2)
,[zav_transitionalhousingmarketrent_base] [decimal](38,2)
,[zav_valuation] [decimal](38,4)
,[zav_valuation_base] [decimal](38,4)
,[crba8_externalgasbottlelocation] [varchar](400)
,[crba8_gasmeterlocation] [varchar](400)
,[crba8_numberoflevels] [bigint]
,[crba8_propertyagentcontactname] [varchar](640)
,[crba8_propertyagentcontactyominame] [varchar](1800)
,[crba8_propertyagentname] [varchar](640)
,[crba8_propertyagentyominame] [varchar](640)
,[createdbyname] [varchar](1026)
,[createdbyyominame] [varchar](1026)
,[createdon] [datetimeoffset](7)
,[createdonbehalfbyname] [varchar](1026)
,[createdonbehalfbyyominame] [varchar](1026)
,[exchangerate] [decimal](38,10)
,[importsequencenumber] [bigint]
,[modifiedbyname] [varchar](1026)
,[modifiedbyyominame] [varchar](1026)
,[modifiedon] [datetime2](7)
,[modifiedonbehalfbyname] [varchar](1026)
,[modifiedonbehalfbyyominame] [varchar](1026)
,[new_country] [varchar](400)
,[new_hazardlist] [varchar](max)
,[new_landinformation] [varchar](max)
,[new_leaseenddate] [datetime2](7)
,[new_overalltargettarget] [bigint]
,[new_postalregionname] [varchar](400)
,[new_propertyage] [varchar](400)
,[new_propertyid] [varchar](400)
,[new_vacanttenantabletarget] [bigint]
,[new_vacantuntenantabletarget] [bigint]
,[new_whatisexhaustcapacityoftheextractionunit] [float]
,[new_whatisexhaustcapacityofunit] [float]
,[overriddencreatedon] [datetime2](7)
,[owneridname] [varchar](640)
,[owneridtype] [varchar](8000)
,[owneridyominame] [varchar](640)
,[owningbusinessunitname] [varchar](640)
,[timezoneruleversionnumber] [bigint]
,[transactioncurrencyidname] [varchar](400)
,[utcconversiontimezonecode] [bigint]
,[versionnumber] [bigint]
,[zav_accesscontrolagent] [varchar](400)
,[zav_accesscontrolnoofdoors] [bigint]
,[zav_accesscontroltype] [varchar](400)
,[zav_accessdoorcode] [varchar](400)
,[zav_accessibilitysummary] [varchar](max)
,[zav_acquireddate] [datetime2](7)
,[zav_ageofceilinginsulationifknown1] [varchar](400)
,[zav_ageofunderfloorinsulationifknown1] [varchar](400)
,[zav_agreedrentreviewdate] [datetime2](7)
,[zav_anyotherdetailsaboutthetypeorconditionifk] [varchar](max)
,[zav_assessmentnum] [varchar](80)
,[zav_assessmentnumber] [bigint]
,[zav_assignedtenancymanagername] [varchar](1026)
,[zav_assignedtenancymanageryominame] [varchar](1026)
,[zav_bedroomkeys] [varchar](400)
,[zav_bodycorpcontactpersonname] [varchar](640)
,[zav_bodycorpcontactpersonyominame] [varchar](1800)
,[zav_bodycorporatename] [varchar](640)
,[zav_bodycorporateyominame] [varchar](640)
,[zav_bondcomment] [varchar](max)
,[zav_bondlodged] [datetime2](7)
,[zav_bondreference] [varchar](400)
,[zav_buildingwarrantoffitnessdate] [datetime2](7)
,[zav_buildingwarrantoffitnessdetails] [varchar](max)
,[zav_businessphoneowner] [varchar](400)
,[zav_bwofdateobtained] [datetime2](7)
,[zav_carpetcolour] [varchar](400)
,[zav_carpetspecification] [varchar](800)
,[zav_ceilinginsulationstatusifno] [varchar](max)
,[zav_ceilinginsulationtypeother] [varchar](400)
,[zav_certificateoftitle] [varchar](1020)
,[zav_chargedto] [datetime2](7)
,[zav_chintaroid] [varchar](400)
,[zav_cityname] [varchar](400)
,[zav_comments] [varchar](max)
,[zav_commentsforvacantpropertyreport] [varchar](4000)
,[zav_commentsgeneral] [varchar](3600)
,[zav_commentskeys] [varchar](400)
,[zav_complianceschedulereferences] [varchar](4000)
,[zav_concatenatedaddress] [varchar](max)
,[zav_confirmeddisposaldate] [datetime2](7)
,[zav_contractbcservicenamename] [varchar](200)
,[zav_contractservicename] [varchar](400)
,[zav_costcentre] [varchar](400)
,[zav_currentiqp] [varchar](1200)
,[zav_currenttenancyname] [varchar](1200)
,[zav_dateconstructed] [datetime2](7)
,[zav_dateinsulationwaslastinspected] [datetime2](7)
,[zav_dateinsulationwaslastupgraded] [datetime2](7)
,[zav_dateinsulationwasprofessionallyassessed] [datetime2](7)
,[zav_datenextbwofdue] [datetime2](7)
,[zav_datenextbwofduetext] [varchar](200)
,[zav_datetheunderfloorinsulationwaslastinspected] [datetime2](7)
,[zav_daysavailabletolet] [bigint]
,[zav_daysundermaintenence] [bigint]
,[zav_delete_textdemo] [varchar](400)
,[zav_delete_urldemo] [varchar](8000)
,[zav_disposaldate] [datetime2](7)
,[zav_districtcounciloffice] [varchar](400)
,[zav_eadivision] [varchar](400)
,[zav_electricityaccount] [varchar](400)
,[zav_electricitymeterlocation] [varchar](400)
,[zav_electricitysupplier] [varchar](400)
,[zav_fireevacuationregno] [varchar](120)
,[zav_floorarea] [decimal](38,0)
,[zav_fridgekeys] [varchar](400)
,[zav_fulladdress] [varchar](1200)
,[zav_gasmeteraccount] [varchar](400)
,[zav_gasmeterlocation] [varchar](400)
,[zav_gassupplier] [varchar](400)
,[zav_gatecode] [varchar](400)
,[zav_gateremote] [varchar](400)
,[zav_giftedname] [varchar](400)
,[zav_habitatpropertyref] [varchar](400)
,[zav_haprogramname] [varchar](400)
,[zav_headcontractorname] [varchar](640)
,[zav_headcontractoryominame] [varchar](640)
,[zav_headleaseexpdate] [datetime2](7)
,[zav_healthyhomescompliancedate] [datetime2](7)
,[zav_healthyhomesstatementdate] [datetime2](7)
,[zav_hhbathroomventcompliancecomments] [varchar](3600)
,[zav_hhceilingcompliancecomments] [varchar](3600)
,[zav_hhdraughtcompliancecomments] [varchar](3600)
,[zav_hhextwallcompliancecomments] [varchar](3600)
,[zav_hhhabroomscompliancecomments] [varchar](3600)
,[zav_hhheatingcompliancecomments] [varchar](3600)
,[zav_hhkitchenventcompliancecomments] [varchar](3600)
,[zav_hhmoistdraincompliancecomments] [varchar](3600)
,[zav_hhunderfloorcompliancecomments] [varchar](3600)
,[zav_hudcontractnumber] [varchar](400)
,[zav_hudmsdreferencenumber] [varchar](400)
,[zav_icpnumber] [varchar](400)
,[zav_id] [bigint]
,[zav_ifpartialspecifyareasnotinsulated] [varchar](400)
,[zav_insulationceilingdate] [datetime2](7)
,[zav_insulationinwalldate] [datetime2](7)
,[zav_insulationisinatleastareasonablecondition] [varchar](400)
,[zav_insulationisinatleastareasonableunderflr] [varchar](400)
,[zav_insulationunderflrdate] [datetime2](7)
,[zav_intendeddisposaldate] [datetime2](7)
,[zav_irrschargedto] [datetime2](7)
,[zav_irrspaidto] [datetime2](7)
,[zav_isip] [varchar](400)
,[zav_kitchencupboardkeys] [varchar](400)
,[zav_kitchenthepropertyisexamptfromthehh] [varchar](max)
,[zav_kitchenwhatisthediameteroftheextractionun] [float]
,[zav_landarea] [decimal](38,2)
,[zav_landareawhole] [bigint]
,[zav_lastinspection] [datetime2](7)
,[zav_lastrenovationdate] [datetime2](7)
,[zav_latitude] [decimal](38,10)
,[zav_legacyid] [varchar](400)
,[zav_legaldescription] [varchar](1020)
,[zav_legalowner] [varchar](400)
,[zav_legalowneridname] [varchar](640)
,[zav_legalowneridyominame] [varchar](640)
,[zav_letterboxkeys] [varchar](400)
,[zav_locationofcircuitboard] [varchar](400)
,[zav_longitude] [decimal](38,10)
,[zav_maindoorkeys] [varchar](400)
,[zav_maingatekeys] [varchar](400)
,[zav_mainheatsourcecapacitykw] [decimal](38,2)
,[zav_masterkeyid] [varchar](400)
,[zav_meshblock] [varchar](600)
,[zav_minimumthicknessmm] [varchar](400)
,[zav_minimumthicknessnaforfoil] [decimal](38,2)
,[zav_minimumthicknessnaforfoilmm] [varchar](400)
,[zav_monitoringagent] [varchar](400)
,[zav_name] [varchar](400)
,[zav_nextinspection] [datetime2](7)
,[zav_noearthstake] [bigint]
,[zav_nooffireextinguishers] [bigint]
,[zav_norcds] [bigint]
,[zav_nosmokealarms] [bigint]
,[zav_nrasdate] [datetime2](7)
,[zav_nrasdwellingid] [varchar](400)
,[zav_numberofpeopleallowedtoreside] [bigint]
,[zav_onlinedate] [datetime2](7)
,[zav_orminimumthickness] [decimal](38,2)
,[zav_otheraccesscomments] [varchar](max)
,[zav_owneremail] [varchar](400)
,[zav_paintcolour] [varchar](400)
,[zav_paintmanufacturer] [varchar](400)
,[zav_partialspecifyareasnotinsulatedunderflr] [varchar](400)
,[zav_partialspecifyareasnotinsulatedwall] [varchar](400)
,[zav_pcrlastupdateddate] [datetime2](7)
,[zav_postalcode] [varchar](16)
,[zav_previouscontaminationdate] [datetime2](7)
,[zav_primarycontractorname] [varchar](640)
,[zav_primarycontractoryominame] [varchar](640)
,[zav_programname] [varchar](400)
,[zav_propertybcservicenamename] [varchar](200)
,[zav_propertycomments] [varchar](max)
,[zav_propertyid] [uniqueidentifier]
,[zav_propertyimage] [varchar](8000)
,[zav_propertyimage_timestamp] [bigint]
,[zav_propertyimage_url] [varchar](800)
,[zav_propertyimageid] [uniqueidentifier]
,[zav_propertymanageremail] [varchar](400)
,[zav_propertymanageridname] [varchar](1026)
,[zav_propertymanageridyominame] [varchar](1026)
,[zav_propertymanagermobile] [varchar](400)
,[zav_propertymanagername] [varchar](640)
,[zav_propertymanageryominame] [varchar](1800)
,[zav_propertyowneraccountname] [varchar](640)
,[zav_propertyowneraccountyominame] [varchar](640)
,[zav_propertyownercontactname] [varchar](640)
,[zav_propertyownercontactyominame] [varchar](1800)
,[zav_propertyownername] [varchar](640)
,[zav_propertyowneryominame] [varchar](640)
,[zav_propertyservicename] [varchar](400)
,[zav_propertysitename] [varchar](400)
,[zav_propertytypeidname] [varchar](400)
,[zav_provideragreementnumber] [varchar](400)
,[zav_reasonfordisposal] [varchar](1200)
,[zav_refundlodged] [datetime2](7)
,[zav_relativeurl] [varchar](3600)
,[zav_relettabledate] [datetime2](7)
,[zav_requiredheatingcapacityforlivingareakw] [decimal](38,2)
,[zav_rescindeddisposaldate] [datetime2](7)
,[zav_resourceconsentreferences] [varchar](4000)
,[zav_returneddate] [datetime2](7)
,[zav_roomnumber] [varchar](24)
,[zav_rubbishbinserialnumber] [varchar](120)
,[zav_rubbishcollectionagencyname] [varchar](640)
,[zav_rubbishcollectionagencyyominame] [varchar](640)
,[zav_rvalueofinsulationifknown] [decimal](38,2)
,[zav_rvalueofinsulationifknownunderfloor] [decimal](38,2)
,[zav_rvalueofinsulationifknownwall] [decimal](38,2)
,[zav_secondaryheatsourcecapacitykw] [decimal](38,2)
,[zav_securitysystemagent] [varchar](400)
,[zav_securitysystemtype] [varchar](400)
,[zav_serviceagentsvendor] [varchar](800)
,[zav_specifyreasonforinaccessibility] [varchar](400)
,[zav_specifyreasonforinaccessibilityunderflr] [varchar](400)
,[zav_stratacompanyname] [varchar](640)
,[zav_stratacompanyyominame] [varchar](640)
,[zav_street1] [varchar](960)
,[zav_streetname] [varchar](960)
,[zav_subprogramname] [varchar](400)
,[zav_subpropertytypeidname] [varchar](400)
,[zav_suburb] [varchar](800)
,[zav_swipecard] [varchar](400)
,[zav_tenure] [varchar](400)
,[zav_territoryname] [varchar](800)
,[zav_thicknessofinsulationifknown] [decimal](38,2)
,[zav_tilecolour] [varchar](400)
,[zav_tiletype] [varchar](400)
,[zav_totaldaysvacant] [bigint]
,[zav_totalheatsourcecapacitykw] [decimal](38,2)
,[zav_totalirrs_date] [datetime2](7)
,[zav_totalirrs_state] [bigint]
,[zav_underfloorinsulationstatusifno] [varchar](max)
,[zav_underfloorotherspecify] [varchar](400)
,[zav_underinsulationbulkinsulationvaluervalue] [varchar](400)
,[zav_unit] [varchar](960)
,[zav_upi] [varchar](400)
,[zav_utilityroomcode] [varchar](400)
,[zav_utilityroomkey] [varchar](400)
,[zav_valuationdate] [datetime2](7)
,[zav_valuationnumber] [varchar](200)
,[zav_valuationrollnum] [varchar](40)
,[zav_valuationrollnumber] [bigint]
,[zav_vinylcolour] [varchar](400)
,[zav_vinylspecification] [varchar](800)
,[zav_wallpaper] [varchar](800)
,[zav_warrantyexpirydate] [datetime2](7)
,[zav_watercomments] [varchar](max)
,[zav_watermeterlocationname] [varchar](400)
,[zav_watermeterlocationtext] [varchar](400)
,[zav_watermeternumber] [varchar](400)
,[zav_whatisthediameteroftheextractionunit] [float]
,[zav_windowskeys] [varchar](400)
,[IsDelete] [varchar](6)
)
AS d
)
AS [data]
WHERE row_num = 1 -- return only latest record