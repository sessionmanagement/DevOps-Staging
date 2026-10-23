

/****** Object:  View [ETL].[dim_property_tenancy]    Script Date: 10/03/2025 9:44:07 am ******/



CREATE   VIEW [ETL].[Testdim_property_tenancy]
AS


/**********************************************************************************************************
 View		[ETL].[dim_property_tenancy]
 Author		Glenn McLeod
 Created	2024/06/10	
 Purpose	Used to build the edw.dim_property_tenancy table 

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
--1.0		 2024/06/10	   Glenn McLeod		Initial version
--1.1		 2025/01/23	   Greg Nuthall     Added vacated date from [vw_opportunity]
--1.2		 2025/02/12	   Greg Nuthall		A new column named property_tenant_opportunity_status is returned by dim_property_tenancy.
--1.3		 2025/03/10	   Greg Nuthall		Added property_id 
 --1.4        2025/05/12    Manish Singh		Changing UTC date column to NZT

**************************************************************************************************************/
--


SELECT  opp.Id AS property_tenancy_id
,opp.zav_property as property_id
--,opp.zav_tenancytypeid
--,opp.zav_tenancytypeid_entitytype
,CAST(opp.zav_tenancytypeidname AS VARCHAR(40)) AS property_tenancy_tenancy_type
,CAST(opp.owningbusinessunitname AS VARCHAR(20)) AS property_tenancy_owning_business_unit_name
,CAST(opp.zav_programname AS VARCHAR(20)) AS property_tenancy_program_name
,CAST(opp.zav_subprogramname AS VARCHAR(40)) AS property_tenancy_subprogram_name
,CAST(opp.zav_propertyname AS VARCHAR(100)) AS property_tenancy_property_name
,CAST(opp.zav_tenancyid AS VARCHAR(20)) AS property_tenancy_tenancy_identifier 
,CAST(opp.zav_hudmsdreferencenumber AS VARCHAR(20)) AS property_tenancy_tenancy_reference
,CAST(opp.name AS VARCHAR(100)) AS property_tenancy_tenancy_name
,CAST(opp.zav_householdname AS VARCHAR(100)) AS property_tenancy_household_name
,CAST(opp.customeridname AS VARCHAR(100)) AS property_tenancy_customer_name
,CAST(opp.new_tenant1mobilephone AS VARCHAR(20)) AS property_tenancy_tenant1_mobile_phone
,CAST(opp.new_tenant2mobilephone AS VARCHAR(20)) AS property_tenancy_tenant2_mobile_phone
--,opp.zav_leaseagreementdate AS property_tenancy_lease_agreement_datetime
,CAST((opp.zav_leaseagreementdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_lease_agreement_datetime

,CAST(opp.zav_tenancystartdate AS DATE)  AS property_tenancy_tenancy_start_date
--,opp.zav_activatetenancydate AS property_tenancy_activate_tenancy_datetime

,CAST((opp.zav_activatetenancydate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_activate_tenancy_datetime

,CAST(opp.zav_actualstartdate AS DATE) AS property_tenancy_actual_start_date
,CAST(opp.zav_fixedtermtenancyenddate AS DATE) AS property_tenancy_fixed_term_tenancy_end_date
,CAST(opp.zav_shorttermtenancyenddate AS DATE) AS property_tenancy_short_term_tenancy_end_date
,CAST(opp.zav_expectedvacateddate AS DATE) AS property_tenancy_expected_vacated_date
--,opp.zav_expexitdate-- All values the same
--,opp.zav_signedmsdresponsibilitiesconditionsdate AS property_tenancy_signed_msd_responsibilities_conditions_datetime
,CAST((opp.zav_signedmsdresponsibilitiesconditionsdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_signed_msd_responsibilities_conditions_datetime
--,opp.zav_signedsngformsdate AS property_tenancy_signed_sng_forms_datetime
,CAST((opp.zav_signedsngformsdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_signed_sng_forms_datetime
,CAST(opp.actualclosedate AS DATE) AS property_tenancy_actual_close_date
,CAST(opp.zav_accrisstartdate AS DATE) AS property_tenancy_accris_start_date
,CAST(opp.zav_bondlodged AS DATE) AS property_tenancy_bond_lodged_date
,CAST(opp.zav_bondrefundformlodged AS DATE) AS property_tenancy_bond_refund_lodged_date
--,opp.zav_checkthatbodycorporresidentsdate AS property_tenancy_check_bodycorp_or_residents_datetime
,CAST((opp.zav_checkthatbodycorporresidentsdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_check_bodycorp_or_residents_datetime

,CAST(opp.zav_noticetovacatedate AS DATE) AS property_tenancy_notice_to_vacate_date
--,opp.zav_providehealthanddisabilityinformationdate AS property_tenancy_health_disability_information_datetime

,CAST((opp.zav_providehealthanddisabilityinformationdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_health_disability_information_datetime


--,opp.zav_providetenancypackdate AS property_tenancy_tenancy_pack_datetime
,
CAST((opp.zav_providetenancypackdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_tenancy_pack_datetime

,CAST(opp.zav_refundlodged AS DATE) AS property_tenancy_refund_lodged_date
,CAST(opp.zav_paytotenancyservicesby AS DATE) AS property_tenancy_pay_tenancy_services_by_date
,opp.zav_shorttermindays AS property_tenancy_short_term_in_days
,CAST(opp.zav_bondreference AS VARCHAR(20)) AS property_tenancy_bond_reference
,CAST(opp.zav_tenancygreetingline AS VARCHAR(100)) AS property_tenancy_tenancy_greeting_line
,CAST(opp.zav_tenancyservicebondnumber AS VARCHAR(20)) AS property_tenancy_tenancy_service_bond_number
,CAST(opp.zav_tenancyservicespropertyid AS VARCHAR(20)) AS property_tenancy_tenancy_services_property_identifier
--,opp.SinkCreatedOn
--,opp.SinkModifiedOn
----,state_mt.LocalizedLabel AS maintenance_task_state
----,status_mt.LocalizedLabel AS maintenance_task_status--,opp.statuscode
--,opp.budgetstatus-- All NULL
--,opp.initialcommunication-- All NULL
,CAST(msdyn_forecastcategory_om.LocalizedLabel AS VARCHAR(20)) AS property_tenancy_msdyn_forecast_category --,opp.msdyn_forecastcategory
--,opp.msdyn_opportunitygrade-- All NULL
--,opp.msdyn_opportunityscoretrend-- All NULL
--,opp.need-- All NULL
,CAST(new_applicationtype_gm.LocalizedLabel AS VARCHAR(50)) AS property_tenancy_application_type --,opp.new_applicationtype
--,opp.new_nonerentarrearsplan-- All NULL
--,opp.new_rentarrearsplan-- All NULL
,CAST(opportunityratingcode_om.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_opportunity_rating_code --,opp.opportunityratingcode
,opp.pricingerrorcode AS property_tenancy_pricing_error_code
--,prioritycode_om.LocalizedLabel AS prioritycode --,opp.prioritycode << All values are the same
--,opp.purchaseprocess-- All NULL
--,opp.purchasetimeframe-- All NULL
,opp.salesstage AS property_tenancy_sales_stage
--,salesstagecode_om.LocalizedLabel AS salesstagecode --,opp.salesstagecode  << All values are the same
--,opp.skippricecalculation  << All values are the same
--,opp.timeline-- All NULL
,CAST(zav_arrearsarrangementbeenactivatedinzavanti_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_arrears_arrangement_activated-- not flag to keep consistent  with field below
,CAST(zav_arrearsarrangementbeensignedwiththeclient_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_arrears_arrangement_signed -- not flag as contains more the Y/N options
--,opp.zav_band-- All NULL
,CAST(zav_bondrefundsngclaimcompleted_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_bond_refund_sng_claim_completed --,opp.zav_bondrefundsngclaimcompleted
,CAST(zav_bondrefundsngclaimlodged_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_bond_refund_sng_claim_lodged --,opp.zav_bondrefundsngclaimlodged
--,opp.zav_chadefinedtenancyfailure-- All NULL
--,opp.zav_chpinitiatedtransfertype-- All NULL
--,opp.zav_complexityofneed-- All NULL
--,opp.zav_correspondenceaddressedcoappstate-- All NULL
--,opp.zav_correspondenceaddressedmainappstate-- All NULL
,CAST(zav_exitpoint_gm.LocalizedLabel AS VARCHAR(50))  AS property_tenancy_exit_point -- ,opp.zav_exitpoint
,CAST(zav_expectedpaymentday_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_expected_payment_day --,opp.zav_expectedpaymentday
,CAST(zav_expectedpaymentfrequency_om.LocalizedLabel AS VARCHAR(20))  AS property_tenancy_expected_payment_frequency --,opp.zav_expectedpaymentfrequency
,CAST(zav_fixedterm_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_fixed_term --,opp.zav_fixedterm
--,zav_frequency_gm.LocalizedLabel AS property_tenancy_frequency --,opp.zav_frequency
,CAST(zav_hastenantrescindednoticetovacate_gm.LocalizedLabel AS VARCHAR(5)) AS property_tenancy_tenant_rescinded_notice_to_vacate --,opp.zav_hastenantrescindednoticetovacate
--,opp.zav_hpftenancy-- All NULL
,CAST(zav_inadvanceflag_gm.LocalizedLabel AS VARCHAR(20)) AS property_tenancy_in_advance --,opp.zav_inadvanceflag
--,CAST(zav_inapphousednoofbedroomsreqd_gm.LocalizedLabel AS INT) AS property_tenancy_in_app_housed_no_bedrooms_reqd --,opp.zav_inapphousednoofbedroomsreqd
,CAST(zav_inapphousednoofbedroomsreqd_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_in_app_housed_no_bedrooms_reqd --,opp.zav_inapphousednoofbedroomsreqd
--,opp.zav_inputrequiredfromcort-- All NULL
--,opp.zav_jwlallocation-- All NULL
,CAST(zav_leavingreason_gm.LocalizedLabel AS VARCHAR(50)) AS property_tenancy_leaving_reason --,opp.zav_leavingreason
,CAST(zav_maintenancefundclaimcompleted_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_maintenance_fund_claim_completed --,opp.zav_maintenancefundclaimcompleted
,CAST(zav_maintenancefundclaimlodgedwithhud_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_maintenance_fund_claim_lodged_with_hud -- ,opp.zav_maintenancefundclaimlodgedwithhud
--,opp.zav_nahaevortype-- All NULL
--,opp.zav_paymenttype-- All NULL
--,opp.zav_potentialdogflag-- All NULL
--,opp.zav_prioritywaitturnaffordable-- All NULL
,CAST(zav_rebatestatus_gm.LocalizedLabel AS VARCHAR(40)) AS property_tenancy_rebate_status --,opp.zav_rebatestatus
--,zav_refundreason_gm.LocalizedLabel AS property_tenancy_refundreason --,opp.zav_refundreason-- All NULL
,CAST(zav_rentchargedday_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_rent_charged_day --,opp.zav_rentchargedday
,CAST(zav_rentpaidinadvance_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_rent_paid_in_advance --,opp.zav_rentpaidinadvance
,CAST(zav_routineinspectionfrequency_om.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_inspection_frequency --,opp.zav_routineinspectionfrequency
--,opp.zav_specialneedsgrantgenerated  -- All values the same
--,opp.zav_splitfrequency-- All NULL
--,opp.zav_sustainabilityoftenancy-- All NULL
,CAST(zav_tenancyappropriatelyreason_om.LocalizedLabel AS VARCHAR(40)) AS property_tenancy_tenancy_appropriately_reason --,opp.zav_tenancyappropriatelyreason
,CAST(zav_tenancyappropriatelystatus_om.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_tenancy_appropriately_status --,opp.zav_tenancyappropriatelystatus
--,opp.zav_tenancybondrefundformhasbeencompleted -- All values the same
--,opp.zav_tenancybondrefundformlodgedwithts -- All values the same
--,opp.zav_tenancyprogramme-- All NULL
--,opp.zav_tenancyroomstatus-- All NULL
--,opp.zav_tenancysource-- All NULL
--,opp.zav_tenancytype -- All values the same
--,opp.zav_transfertype-- All NULL
,CAST(zav_weeksbondisbeingaskedfor_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_weeks_bond_requested --,opp.zav_weeksbondisbeingaskedfor
,CAST(zav_writeoffrequired_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_writeoff_required --,opp.zav_writeoffrequired
--,opp.zav_riskstotenantsustainability-- All NULL
--,opp.zav_specialneedsofthetenant1-- All NULL
--,opp.zav_specialneedsofthetenant2-- All NULL
--,opp.accountid-- All NULL
--,opp.accountid_entitytype-- All NULL
--,opp.campaignid-- All NULL
--,opp.campaignid_entitytype-- All NULL
--,opp.contactid-- All NULL
--,opp.contactid_entitytype-- All NULL
--,opp.crba8_navigatornotifiedby
--,opp.crba8_navigatornotifiedby_entitytype
--,opp.createdby
--,opp.createdby_entitytype
--,opp.createdonbehalfby-- All NULL
--,opp.createdonbehalfby_entitytype-- All NULL
--,opp.modifiedby
--,opp.modifiedby_entitytype
--,opp.modifiedonbehalfby
--,opp.modifiedonbehalfby_entitytype
--,opp.msdyn_opportunitykpiid-- All NULL
--,opp.msdyn_opportunitykpiid_entitytype-- All NULL
--,opp.msdyn_predictivescoreid-- All NULL
--,opp.msdyn_predictivescoreid_entitytype-- All NULL
--,opp.msdyn_segmentid-- All NULL
--,opp.msdyn_segmentid_entitytype-- All NULL
--,opp.new_emergencycontactrelationship1-- All NULL
--,opp.new_emergencycontactrelationship1_entitytype-- All NULL
--,opp.new_emergencycontactrelationship1_new
--,opp.new_emergencycontactrelationship1_new_entitytype
--,opp.new_emergencycontactrelationship2-- All NULL
--,opp.new_emergencycontactrelationship2_entitytype-- All NULL
--,opp.new_emergencycontactrelationship2_new-- All NULL
--,opp.new_emergencycontactrelationship2_new_entitytype-- All NULL
--,opp.originatingleadid
--,opp.originatingleadid_entitytype
--,opp.owningbusinessunit -- All values the same
--,opp.owningbusinessunit_entitytype -- All values the same
--,opp.owningteam-- All NULL
--,opp.owningteam_entitytype-- All NULL
--,opp.owninguser AS property_tenancy_owning_user
--,opp.owninguser_entitytype
--,opp.parentaccountid-- All NULL
--,opp.parentaccountid_entitytype-- All NULL
--,opp.parentcontactid
--,opp.parentcontactid_entitytype
--,opp.pricelevelid-- All NULL
--,opp.pricelevelid_entitytype-- All NULL
--,opp.slaid-- All NULL
--,opp.slaid_entitytype-- All NULL
--,opp.slainvokedid-- All NULL
--,opp.slainvokedid_entitytype-- All NULL
--,opp.transactioncurrencyid
--,opp.transactioncurrencyid_entitytype
--,opp.zav_activatetenancyby
--,opp.zav_activatetenancyby_entitytype
--,opp.zav_bondguaranteeinformationprovidedby
--,opp.zav_bondguaranteeinformationprovidedby_entitytype
--,opp.zav_checkthatbodycorporresidentsuser
--,opp.zav_checkthatbodycorporresidentsuser_entitytype
--,opp.zav_consenttoholdpersonalinformationby
--,opp.zav_consenttoholdpersonalinformationby_entitytype
--,opp.zav_correspondenceaddressedcoappcity
--,opp.zav_correspondenceaddressedcoappcity_entitytype
--,opp.zav_correspondenceaddressedcoappregion
--,opp.zav_correspondenceaddressedcoappregion_entitytype
--,opp.zav_correspondenceaddressedmainappcity
--,opp.zav_correspondenceaddressedmainappcity_entitytype
--,opp.zav_correspondenceaddressedmainappregion
--,opp.zav_correspondenceaddressedmainappregion_entitytype
--,opp.zav_expectedpaymentdayby
--,opp.zav_expectedpaymentdayby_entitytype
--,opp.zav_followedmarketrentreviewinbosuser
--,opp.zav_followedmarketrentreviewinbosuser_entitytype
--,opp.zav_forwardingaddresscity
--,opp.zav_forwardingaddresscity_entitytype
--,opp.zav_forwardingaddressregion
--,opp.zav_forwardingaddressregion_entitytype
--,opp.zav_guidanceonrentpaymentprocessby
--,opp.zav_guidanceonrentpaymentprocessby_entitytype
--,opp.zav_household
--,opp.zav_household_entitytype
--,opp.zav_householdcompositioncorrectby
--,opp.zav_householdcompositioncorrectby_entitytype
--,opp.zav_ingoingpropertyconditionreportby
--,opp.zav_ingoingpropertyconditionreportby_entitytype
--,opp.zav_ingoingtenancyinspectionpropertyuser
--,opp.zav_ingoingtenancyinspectionpropertyuser_entitytype
--,opp.zav_insulationstatementby-- All NULL
--,opp.zav_insulationstatementby_entitytype-- All NULL
--,opp.zav_insurancestatementby-- All NULL
--,opp.zav_insurancestatementby_entitytype-- All NULL
--,opp.zav_keyshandedoveratthesigningofthetenancyby
--,opp.zav_keyshandedoveratthesigningofthetenancyby_entitytype
--,opp.zav_leaseagreementby
--,opp.zav_leaseagreementby_entitytype
,CAST(la.[fullname] AS VARCHAR(50)) AS property_tenancy_lease_agreement_by_name
--,opp.zav_offertenantredirectionforwaterpaymentuser
--,opp.zav_offertenantredirectionforwaterpaymentuser_entitytype
--,opp.zav_program
--,opp.zav_program_entitytype
--,opp.zav_property
--,opp.zav_property_entitytype
--,opp.zav_providehealthanddisabilityinformationuser
--,opp.zav_providehealthanddisabilityinformationuser_entitytype
--,opp.zav_providetenancypackby
--,opp.zav_providetenancypackby_entitytype
--,opp.zav_routineinspectionfrequencyby
--,opp.zav_routineinspectionfrequencyby_entitytype
--,opp.zav_secondclient AS property_tenancy_second_client
--,opp.zav_secondclient_entitytype
--,opp.zav_setupinspectiondateby
--,opp.zav_setupinspectiondateby_entitytype
--,opp.zav_setupofrentreviewdatesby-- All NULL
--,opp.zav_setupofrentreviewdatesby_entitytype-- All NULL
--,opp.zav_signedmsdresponsibilitiesconditionsuser
--,opp.zav_signedmsdresponsibilitiesconditionsuser_entitytype
--,opp.zav_signedsngformsuser
--,opp.zav_signedsngformsuser_entitytype
--,opp.zav_subprogram
--,opp.zav_subprogram_entitytype
--,opp.zav_supportpeopleandemergencyuser
--,opp.zav_supportpeopleandemergencyuser_entitytype
--,opp.zav_tenancyappropriatelyuser
--,opp.zav_tenancyappropriatelyuser_entitytype
--,opp.zav_tenancycontributionrenthasbeensetupuser
--,opp.zav_tenancycontributionrenthasbeensetupuser_entitytype
--,opp.zav_tenancymanager
--,opp.zav_tenancymanager_entitytype
--,opp.zav_tenancymanagerid
--,opp.zav_tenancymanagerid_entitytype
--,opp.zav_tenancymanageridname
,CAST(opp.zav_tenancymanagername AS VARCHAR(100)) AS property_tenancy_manager_name
,CAST(opp.zav_tenancymanageremail AS VARCHAR(40)) AS property_tenancy_manager_email
--,opp.zav_tenancymanageridyominame
,CAST(opp.zav_tenancymanagermobile AS VARCHAR(20)) AS property_tenancy_manager_mobile
--,opp.zav_tenancymanageryominame
--,opp.zav_tenancystartedinboswithcorrectdetailsuser
--,opp.zav_tenancystartedinboswithcorrectdetailsuser_entitytype
--,opp.zav_tenantconfirmedconditionby
--,opp.zav_tenantconfirmedconditionby_entitytype
--,opp.zav_tenantconfirmsingoinginventorylistuser
--,opp.zav_tenantconfirmsingoinginventorylistuser_entitytype
--,opp.zav_transferapplication-- All NULL
--,opp.zav_transferapplication_entitytype-- All NULL
--,opp.zav_transfertotenancy-- All NULL
--,opp.zav_transfertotenancy_entitytype-- All NULL
--,opp.zav_voidcategory
--,opp.zav_voidcategory_entitytype
,opp.zav_voidchecklist AS property_tenancy_void_checklist
--,opp.zav_voidchecklist_entitytype
,vc.zav_name AS property_tenancy_void_category_name
,CAST(vc.zav_description AS VARCHAR(50)) AS property_tenancy_description
--,opp.zav_voidproperty-- All NULL
--,opp.zav_voidproperty_entitytype-- All NULL
--,opp.ownerid
--,opp.ownerid_entitytype
--,opp.customerid
--,opp.customerid_entitytype
--,opp.actualvalue-- All values the same
--,opp.actualvalue_base-- All values the same
--,opp.budgetamount-- All values the same
--,opp.budgetamount_base-- All values the same
--,opp.discountamount-- All values the same
--,opp.discountamount_base-- All values the same
--,opp.estimatedvalue-- All values the same
--,opp.estimatedvalue_base-- All values the same
--,opp.freightamount-- All values the same
--,opp.freightamount_base-- All values the same
--,opp.new_bondbalance
--,opp.new_bondbalance_base
--,opp.new_newrent-- All NULL
--,opp.new_newrent_base-- All values the same
--,opp.new_nonrent
--,opp.new_nonrent_base
,opp.new_rent AS property_tenancy_rent
,opp.new_rent_base AS property_tenancy_rent_base
,opp.new_transactionbalancetotal AS property_tenancy_transaction_balance_total
,opp.new_transactionbalancetotal_base AS property_tenancy_transaction_balance_total_base
--,opp.totalamount-- All NULL
--,opp.totalamount_base-- All NULL
--,opp.totalamountlessfreight-- All NULL
--,opp.totalamountlessfreight_base-- All values the same
--,opp.totaldiscountamount-- All values the same
--,opp.totaldiscountamount_base-- All values the same
--,opp.totallineitemamount-- All values the same
--,opp.totallineitemamount_base-- All values the same
--,opp.totallineitemdiscountamount-- All values the same
--,opp.totallineitemdiscountamount_base-- All values the same
--,opp.totaltax-- All values the same
--,opp.totaltax_base-- All values the same
,opp.zav_approvedsngcap AS property_tenancy_approved_sng_cap
--,opp.zav_approvedsngcap_base
--,opp.zav_balancewithtenancyservices
--,opp.zav_balancewithtenancyservices_base
,opp.zav_bondamount AS property_tenancy_bond_amount
--,opp.zav_bondamount_base
,opp.zav_chintarobondamount AS property_tenancy_chintaro_bond_amount
--,opp.zav_chintarobondamount_base
,opp.zav_expectedbondamount AS property_tenancy_expected_bond_amount
--,opp.zav_expectedbondamount_base
,opp.zav_inhand AS property_tenancy_in_hand
--,opp.zav_inhand_base
,opp.zav_marketrent AS property_tenancy_market_rent
--,opp.zav_marketrent_base
,opp.zav_newestrentupdate AS property_tenancy_newest_rent_update
--,opp.zav_newestrentupdate_base
,opp.zav_refundrequired AS property_tenancy_refund_required
--,opp.zav_refundrequired_base
,opp.zav_rentowesasofexpectedvacatedate AS property_tenancy_rent_owes_at_expected_vacate_date
--,opp.zav_rentowesasofexpectedvacatedate_base
--,opp.zav_rentpayable-- All values the same
--,opp.zav_rentpayable_base-- All values the same
----,opp.zav_rentpayablebasicrentcraweekly
----,opp.zav_rentpayablebasicrentcraweekly_base
,opp.zav_totalotherandamenities AS property_tenancy_total_other_amenities
--,opp.zav_totalotherandamenities_base
,opp.zav_totalrentamount AS property_tenancy_total_rent_amount
,opp.zav_totalrentamount_base AS property_tenancy_total_rent_amount_base
,opp.zav_totaltenantliabilityamount AS property_tenancy_total_tenant_liability_amount
--,opp.zav_totaltenantliabilityamount_base
,opp.zav_totalutilitiesamount AS property_tenancy_total_utilities_amount
--,opp.zav_totalutilitiesamount_base
--,opp.zav_totalwateramount-- All values the same
--,opp.zav_totalwateramount_base -- All values the same
--,opp.accountidname-- All values the same
--,opp.accountidyominame-- All values the same
--,opp.campaignidname-- All values the same
--,opp.closeprobability-- All values the same
--,opp.contactidname-- All values the same
--,opp.contactidyominame-- All values the same
--,opp.crba8_navigatornotifiedbyname
--,opp.crba8_navigatornotifiedbyyominame
--,opp.crba8_navigatornotifiedon
--,opp.createdbyname
--,opp.createdbyyominame
--,opp.createdonbehalfbyname-- All values the same
--,opp.createdonbehalfbyyominame-- All values the same
--,opp.currentsituation-- All values the same
--,opp.customeridtype-- All NULL
--,opp.customeridyominame
--,opp.customerneed-- All NULL
--,opp.customerpainpoints-- All NULL
--,opp.description-- All NULL
--,opp.discountpercentage-- All NULL
--,opp.emailaddress-- All values the same
--,opp.estimatedclosedate-- All NULL
--,opp.exchangerate-- All NULL
--,opp.finaldecisiondate-- All NULL
--,opp.importsequencenumber-- All NULL
--,opp.lastonholdtime-- All NULL
--,opp.modifiedbyname
--,opp.modifiedbyyominame
--,opp.modifiedon
--,opp.modifiedonbehalfbyname
--,opp.modifiedonbehalfbyyominame
--,opp.msdyn_opportunitykpiidname-- All NULL
--,opp.msdyn_opportunityscore-- All NULL
--,opp.msdyn_predictivescoreidname-- All NULL
--,opp.msdyn_scorehistory-- All NULL
--,opp.msdyn_scorereasons-- All NULL
--,opp.msdyn_segmentidname-- All NULL
--,opp.msdyn_similaropportunities-- All values the same
--,opp.new_deadlineforpaymenttoba
--,opp.new_effectivenewrentstartdate-- All NULL
,CAST(opp.new_emergencycontactmobile1 AS VARCHAR(20)) AS property_tenancy_emergency_contact1_mobile
--,opp.new_emergencycontactmobile2-- All NULL
,CAST(opp.new_emergencycontactname1 AS VARCHAR(100)) AS property_tenancy_emergency_contact1_name
--,opp.new_emergencycontactname2-- All NULL
,CAST(opp.new_emergencycontactrelationship1_newname AS VARCHAR(40)) AS property_tenancy_emergency_contact1_relationship
--,opp.new_emergencycontactrelationship1name -- All NULL
--,opp.new_emergencycontactrelationship2_newname -- All NULL
--,opp.new_emergencycontactrelationship2name -- All NULL
,CAST(opp.parentcontactidname AS VARCHAR(100)) AS property_tenancy_parent_contact_name
,opp.new_exitcomment AS property_tenancy_exit_comment
----,opp.new_keysreceivedfromtenantdate
,opp.new_nobedroomsexitedto AS property_tenancy_no_bedrooms_exited_to
--,opp.new_nonrent_date
--,opp.new_nonrent_state-- All values the same
--,opp.new_rent_date
--,opp.new_rent_state-- All values the same
,CAST(opp.new_riskslist AS VARCHAR(200)) AS property_tenancy_risks_list
--,opp.new_test-- All values the same
--,opp.onholdtime-- All values the same
--,opp.opportunityid
--,opp.originatingleadidname
--,opp.originatingleadidyominame
--,opp.overriddencreatedon -- All NULL
--,opp.owneridname
--,opp.owneridtype
--,opp.owneridyominame
--,opp.parentaccountidname -- All NULL
--,opp.parentaccountidyominame-- All values the same
--,opp.parentcontactidyominame
--,opp.pricelevelidname -- All values the same
--,opp.processid
--,opp.proposedsolution -- All NULL
--,opp.qualificationcomments -- All NULL
--,opp.quotecomments -- All NULL
--,opp.schedulefollowup_prospect-- All values the same
--,opp.schedulefollowup_qualify-- All values the same
--,opp.scheduleproposalmeeting-- All values the same
--,opp.slainvokedidname-- All values the same
--,opp.slaname-- All values the same
--,opp.stageid-- All values the same
--,opp.stepid-- All values the same
,cast(opp.stepname AS VARCHAR(20)) AS property_tenancy_step_name
--,opp.teamsfollowed -- All NULL
--,opp.timespentbymeonemailandmeetings-- All values the same
,opp.timezoneruleversionnumber AS property_tenancy_timezone_rule_version_number
--,opp.transactioncurrencyidname
--,opp.traversedpath -- All NULL
--,opp.utcconversiontimezonecode-- All values the same
--,opp.versionnumber
--,opp.zav_activatetenancybyname
--,opp.zav_activatetenancybyyominame
,opp.zav_bondcomments AS property_tenancy_bond_comments
--,opp.zav_bondguaranteeinformationprovidedbyname
--,opp.zav_bondguaranteeinformationprovidedbyyominame
--,opp.zav_bondguaranteeinformationprovideddate
--,opp.zav_checkthatbodycorporresidentsusername
--,opp.zav_checkthatbodycorporresidentsuseryominame
,CAST(opp.zav_chintaroid AS VARCHAR(20)) AS property_tenancy_chintaro_id
,opp.zav_comments AS property_tenancy_comments
,opp.zav_commenttofinance AS property_tenancy_comment_to_finance
--,opp.zav_consenttoholdpersonalinformationbyname
--,opp.zav_consenttoholdpersonalinformationbyyominame
--,opp.zav_consenttoholdpersonalinformationdate
--,opp.zav_correspondenceaddressedcoappcityname
--,opp.zav_correspondenceaddressedcoapppostcode
--,opp.zav_correspondenceaddressedcoappregionname
--,opp.zav_correspondenceaddressedcoappstreet
--,opp.zav_correspondenceaddressedcoappstreetname
--,opp.zav_correspondenceaddressedcoappsuburb
--,opp.zav_correspondenceaddressedcoappunit
--,opp.zav_correspondenceaddressedmainappbuildingnam-- All NULL
--,opp.zav_correspondenceaddressedmainappcityname
--,opp.zav_correspondenceaddressedmainapppostcode
--,opp.zav_correspondenceaddressedmainappregionname
--,opp.zav_correspondenceaddressedmainappstreet
--,opp.zav_correspondenceaddressedmainappstreetname
--,opp.zav_correspondenceaddressedmainappsuburb
--,opp.zav_correspondenceaddressedmainappunit
--,opp.zav_detailsofadvicegiven-- All NULL
,CAST(opp.zav_emergencycontactcomment1 AS VARCHAR(200)) AS property_tenancy_emergency_contact_comment1
,CAST(opp.zav_emergencycontactcomment2 AS VARCHAR(200)) AS property_tenancy_emergency_contact_comment2
,CAST(opp.zav_emergencycontactemail1 AS VARCHAR(40)) AS property_tenancy_emergency_contact_email
--,opp.zav_emergencycontactemail2-- All NULL
--,opp.zav_equitypercentage-- All NULL
--,opp.zav_expectedpaymentdaybyname
--,opp.zav_expectedpaymentdaybyyominame
--,opp.zav_expectedpaymentdaydate
--,opp.zav_expexitdate-- All values the same
--,opp.zav_followedmarketrentreviewinbosdate
--,opp.zav_followedmarketrentreviewinbosusername
--,opp.zav_followedmarketrentreviewinbosuseryominame
--,opp.zav_forwardingaddresscityname
--,opp.zav_forwardingaddressregionname
--,opp.zav_forwardingaddressstreetname
--,opp.zav_forwardingaddressstreetnumber
--,opp.zav_forwardingaddresssuburb
--,opp.zav_forwardingaddressunit
--,opp.zav_forwardingaddresszippostalcode
--,opp.zav_guidanceonrentpaymentprocessbyname
--,opp.zav_guidanceonrentpaymentprocessbyyominame
--,opp.zav_guidanceonrentpaymentprocessdate
--,opp.zav_habitattenantapplicationnumber-- All values the same
--,opp.zav_householdcompositioncorrectbyname
--,opp.zav_householdcompositioncorrectbyyominame
--,opp.zav_householdcompositioncorrectdate
--,opp.zav_ingoingpropertyconditionreportbyname
--,opp.zav_ingoingpropertyconditionreportbyyominame
--,opp.zav_ingoingpropertyconditionreportdate
--,opp.zav_ingoingtenancyinspectionpropertydate
--,opp.zav_ingoingtenancyinspectionpropertyusername
--,opp.zav_ingoingtenancyinspectionpropertyuseryominame
--,opp.zav_insulationstatementbyname-- All values the same
--,opp.zav_insulationstatementbyyominame-- All values the same
--,opp.zav_insulationstatementdate-- All values the same
--,opp.zav_insurancestatementbyname-- All values the same
--,opp.zav_insurancestatementbyyominame-- All values the same
--,opp.zav_insurancestatementdate-- All values the same
--,opp.zav_keyshandedoveratthesigningofthetenancybyname
--,opp.zav_keyshandedoveratthesigningofthetenancybyyominame
--,opp.zav_keyshandedoveratthesigningofthetenancydat
--,opp.zav_kiangoratenancytype-- All values the same
--,opp.zav_lastinspection
--,opp.zav_lastrentreview
--,opp.zav_leaseagreementbyname
--,opp.zav_leaseagreementbyyominame
--,opp.zav_maintenanceclaimlodgedwithhud-- All values the same
--,opp.zav_maintenancefundclaimlodgeddate
--,opp.zav_nameofpartners-- All values the same
--,opp.zav_newestrentupdatestartdate
--,opp.zav_nextinspection
--,opp.zav_nextrentreview
--,opp.zav_noofdayscharged-- All values the same
--,opp.zav_notes-- All values the same
,opp.zav_numberoftenancysignatories AS property_tenancy_number_signatories
--,opp.zav_offertenantredirectionforwaterpaymentdate
--,opp.zav_offertenantredirectionforwaterpaymentusername
--,opp.zav_offertenantredirectionforwaterpaymentuseryominame
--,opp.zav_partnersphone-- All values the same
--,opp.zav_paymentbookid
--,opp.zav_paymentreferenceno
--,opp.zav_petage-- All values the same
--,opp.zav_petbreed-- All values the same
--,opp.zav_petname-- All values the same
--,opp.zav_petregistrationdetails-- All values the same
--,opp.zav_pettype-- All values the same
--,opp.zav_providehealthanddisabilityinformationusername
--,opp.zav_providehealthanddisabilityinformationuseryominame
--,opp.zav_providetenancypackbyname
--,opp.zav_providetenancypackbyyominame
,CAST(opp.zav_relativeurl AS VARCHAR(400)) AS property_tenancy_relative_url
--,opp.zav_rentchargedto
--,opp.zav_rentchargedtotest-- All NULL
--,opp.zav_rentchargedtotest1-- All NULL
--,opp.zav_rentchargedtotest2-- All NULL
--,opp.zav_rentpaidto
--,opp.zav_rentpaidtouserlocal
--,opp.zav_rentpaymentdays
--,opp.zav_renttobepaidat
--,opp.zav_rescinddate
--,opp.zav_routineinspectionfrequencybyname
--,opp.zav_routineinspectionfrequencybyyominame
--,opp.zav_routineinspectionfrequencydate
,opp.zav_secondclientname AS property_tenancy_second_client_name
--,opp.zav_secondclientyominame
--,opp.zav_setupinspectiondatebyname
--,opp.zav_setupinspectiondatebyyominame
--,opp.zav_setupinspectiondatedate
--,opp.zav_setupofrentreviewdatesbyname-- All values the same
--,opp.zav_setupofrentreviewdatesbyyominame-- All values the same
--,opp.zav_setupofrentreviewdatesdate-- All values the same
--,opp.zav_signedmsdresponsibilitiesconditionsusername
--,opp.zav_signedmsdresponsibilitiesconditionsuseryominame
--,opp.zav_signedsngformsusername
--,opp.zav_signedsngformsuseryominame
--,opp.zav_sngclaimlodgeddatecomments
--,opp.zav_sngclaimlodgementdate
--,opp.zav_sngclaimrelodgeddate1
--,opp.zav_sngclaimrelodgeddate1comments
--,opp.zav_sngclaimrelodgeddate2
--,opp.zav_sngclaimrelodgeddate2comments
--,opp.zav_sngclaimrelodgeddate3
--,opp.zav_sngclaimrelodgeddate3comments
--,opp.zav_sngclaimrelodgeddate4
--,opp.zav_sngclaimrelodgeddate4comments
--,opp.zav_sngclaimuploadedtomsd-- All values the same
,CAST(opp.zav_startingdateforrentamount AS DATE) AS property_tenancy_rent_amount_start_date
--,opp.zav_supportpeopleandemergedate
--,opp.zav_supportpeopleandemergencyusername
--,opp.zav_supportpeopleandemergencyuseryominame
--,opp.zav_tenancyappropriatelydate
--,opp.zav_tenancyappropriatelydescription
--,opp.zav_tenancyappropriatelyusername
--,opp.zav_tenancyappropriatelyuseryominame
--,opp.zav_tenancycontributionrenthasbeensetupdate
--,opp.zav_tenancycontributionrenthasbeensetupusername
--,opp.zav_tenancycontributionrenthasbeensetupuseryominame
--,opp.zav_tenancyreferencenumber-- All values the same
--,opp.zav_tenancystartedinboswithcorrectdetailsdate
--,opp.zav_tenancystartedinboswithcorrectdetailsusername
--,opp.zav_tenancystartedinboswithcorrectdetailsuseryominame
--,opp.zav_tenantconfirmedconditionbyname
--,opp.zav_tenantconfirmedconditionbyyominame
--,opp.zav_tenantconfirmedconditiondate
--,opp.zav_tenantconfirmsingoinginventorylistdate
--,opp.zav_tenantconfirmsingoinginventorylistusername
--,opp.zav_tenantconfirmsingoinginventorylistuseryominame
--,opp.zav_theoutcomeoftherequest-- All values the same
--,opp.zav_thereasonformakingtherequest-- All values the same
--,opp.zav_tobepaidweeks-- All values the same
--,opp.zav_totalotherandamenities_date
--,opp.zav_totalotherandamenities_state-- All values the same
--,opp.zav_totalrentamount_date
--,opp.zav_totalrentamount_state-- All values the same
--,opp.zav_totaltenantliabilityamount_date
--,opp.zav_totaltenantliabilityamount_state-- All values the same
--,opp.zav_totalutilitiesamount_date
--,opp.zav_totalutilitiesamount_state-- All values the same
--,opp.zav_totalwateramount_date
--,opp.zav_totalwateramount_state-- All values the same
--,opp.zav_transferapplicationname-- All values the same
--,opp.zav_transferlodged
--,opp.zav_transferreddate-- All values the same
--,opp.zav_transfertotenancyname-- All values the same
--,opp.zav_vacancybedrooms
,CAST(opp.zav_vacateddate AS DATE) AS property_tenancy_vacated_date
--,opp.zav_voidcategoryname
--,opp.zav_voidchecklistname
--,opp.zav_voidpropertyname-- All values the same
--,opp.zav_whennotifiedtomsd-- All values the same
--,opp.zav_wstpacparticular
--,opp.zav_watermeterreadingingoing
--,opp.zav_watermeterreadingoutgoing
--,opp.zav_financeadvisedtopayhud
--,opp.zav_financeadvisedtopayhudcomments
---------- all Flags
, CAST(CAST(opp.captureproposalfeedback as BIT) as INT) as property_tenancy_capture_proposal_feedback_flag
, CAST(CAST(opp.completefinalproposal as BIT) as INT) as property_tenancy_complete_final_proposal_flag
, CAST(CAST(opp.completeinternalreview as BIT) as INT) as property_tenancy_complete_internal_review_flag
, CAST(CAST(opp.confirminterest as BIT) as INT) as property_tenancy_confirm_interest_flag
, CAST(CAST(opp.crba8_navigatornotified as BIT) as INT) as property_tenancy_crba8_navigator_notified_flag
, CAST(CAST(opp.decisionmaker as BIT) as INT) as property_tenancy_decision_maker_flag
, CAST(CAST(opp.developproposal as BIT) as INT) as property_tenancy_develop_proposal_flag
, CAST(CAST(opp.evaluatefit as BIT) as INT) as property_tenancy_evaluate_fit_flag
, CAST(CAST(opp.filedebrief as BIT) as INT) as property_tenancy_file_debrief_flag
, CAST(CAST(opp.identifycompetitors as BIT) as INT) as property_tenancy_identify_competitors_flag
, CAST(CAST(opp.identifycustomercontacts as BIT) as INT) as property_tenancy_identify_customer_contacts_flag
, CAST(CAST(opp.identifypursuitteam as BIT) as INT) as property_tenancy_identify_pursuit_team_flag
--,opp.isprivate-- All NULL
, CAST(CAST(opp.isrevenuesystemcalculated as BIT) as INT) as property_tenancy_is_revenue_system_calculated_flag
--, CAST(CAST(opp.msdyn_gdproptout as BIT) as INT) as property_tenancy_msdyng_dproptout_flag -- All null or zero
, CAST(CAST(opp.new_activatetenancy as BIT) as INT) as property_tenancy_activate_tenancy_flag
, CAST(CAST(opp.new_interpretorrequired as BIT) as INT) as property_tenancy_interpretor_required_flag
, CAST(CAST(opp.new_isthisapartnershiparrangement as BIT) as INT) as property_tenancy_partnership_arrangement_flag
, CAST(CAST(opp.new_keysreceivedfromtenant as BIT) as INT) as property_tenancy_keys_received_from_tenant_flag
, CAST(CAST(opp.new_potentialrisktostaff as BIT) as INT) as property_tenancy_potential_risk_to_staff_flag
, CAST(CAST(opp.participatesinworkflow as BIT) as INT) as property_tenancy_participates_in_workflow_flag
, CAST(CAST(opp.presentfinalproposal as BIT) as INT) as property_tenancy_present_final_proposal_flag
, CAST(CAST(opp.presentproposal as BIT) as INT) as property_tenancy_present_proposal_flag
, CAST(CAST(opp.pursuitdecision as BIT) as INT) as property_tenancy_pursuit_decision_flag
, CAST(CAST(opp.resolvefeedback as BIT) as INT) as property_tenancy_resolve_feedback_flag
, CAST(CAST(opp.sendthankyounote as BIT) as INT) as property_tenancy_send_thankyou_note_flag
, CAST(CAST(opp.zav_agreementtoextendthetenancyreceived as BIT) as INT) as property_tenancy_agreement_to_extend_tenancy_received_flag
, CAST(CAST(opp.zav_bondguaranteeinformationprovided as BIT) as INT) as property_tenancy_bond_guarantee_information_provided_flag
, CAST(CAST(opp.zav_bondinformationentered as BIT) as INT) as property_tenancy_bond_information_entered_flag
, CAST(CAST(opp.zav_bondloan as BIT) as INT) as property_tenancy_bond_loan_flag
, CAST(CAST(opp.zav_bondlodgementcomplete as BIT) as INT) as property_tenancy_bond_lodgement_complete_flag
, CAST(CAST(opp.zav_checkedforothertenancieswithbalancesdue as BIT) as INT) as property_tenancy_checked_other_tenancies_with_balances_due_flag
, CAST(CAST(opp.zav_checkthatbodycorporresidents as BIT) as INT) as property_tenancy_check_that_body_corporresidents_flag
, CAST(CAST(opp.zav_consenttoholdpersonalinformation as BIT) as INT) as property_tenancy_consent_to_hold_personal_information_flag
--, CAST(CAST(opp.zav_contactscorrect as BIT) as INT) as property_tenancy_contacts_correct_flag << not available in dev
, CAST(CAST(opp.zav_expectedpaymentdatecorrect as BIT) as INT) as property_tenancy_expected_payment_date_correct_flag
, CAST(CAST(opp.zav_expectedpaymentdaycheckbox as BIT) as INT) as property_tenancy_expected_payment_day_checkbox_flag
, CAST(CAST(opp.zav_familiarwithsupportsneighbours as BIT) as INT) as property_tenancy_familiar_with_supports_neighbours_flag
, CAST(CAST(opp.zav_firstinspectionscheduled as BIT) as INT) as property_tenancy_first_inspection_scheduled_flag
, CAST(CAST(opp.zav_followedmarketrentreviewinbos as BIT) as INT) as property_tenancy_followed_market_rent_review_in_bos_flag
, CAST(CAST(opp.zav_guidanceonrentpaymentprocess as BIT) as INT) as property_tenancy_guidance_on_rent_payment_process_flag
, CAST(CAST(opp.zav_householdcompositioncorrect as BIT) as INT) as property_tenancy_household_composition_correct_flag
, CAST(CAST(opp.zav_householdmemberscorrect as BIT) as INT) as property_tenancy_household_members_correct_flag
, CAST(CAST(opp.zav_housingfirst as BIT) as INT) as property_tenancy_housing_first_flag
, CAST(CAST(opp.zav_ignorecreatevoidchecklist as BIT) as INT) as property_tenancy_ignore_create_void_checklist_flag
, CAST(CAST(opp.zav_ingoingpropertyconditionreport as BIT) as INT) as property_tenancy_ingoing_property_condition_report_flag
, CAST(CAST(opp.zav_ingoingtenancyinspectionpropertycondition as BIT) as INT) as property_tenancy_ingoing_tenancy_inspection_property_condition_flag
, CAST(CAST(opp.zav_insulationstatement as BIT) as INT) as property_tenancy_insulation_statement_flag
, CAST(CAST(opp.zav_insurancestatement as BIT) as INT) as property_tenancy_insurance_statement_flag
, CAST(CAST(opp.zav_invoicesforfinalchargestotenantadded as BIT) as INT) as property_tenancy_invoices_final_charges_to_tenant_added_flag
, CAST(CAST(opp.zav_isanytenantundertheageof18 as BIT) as INT) as property_tenancy_any_tenant_under_age_18_flag
, CAST(CAST(opp.zav_isthistenancyappropriatelyhoused as BIT) as INT) as property_tenancy_tenancy_appropriately_housed_flag
, CAST(CAST(opp.zav_keyshandedoveratthesigningofthetenancyagr as BIT) as INT) as property_tenancy_keys_handed_over_at_tenancy_signing_flag
, CAST(CAST(opp.zav_leaseagreement as BIT) as INT) as property_tenancy_lease_agreement_flag
, CAST(CAST(opp.zav_marketrenter as BIT) as INT) as property_tenancy_market_renter_flag
, CAST(CAST(opp.zav_msdnotifiedtostopredirection as BIT) as INT) as property_tenancy_msd_notified_to_stop_redirection_flag
, CAST(CAST(opp.zav_msdreferralletterreceived as BIT) as INT) as property_tenancy_msd_referral_letter_received_flag
, CAST(CAST(opp.zav_offboardingactivitiescompleted as BIT) as INT) as property_tenancy_offboarding_activities_completed_flag
, CAST(CAST(opp.zav_offertenantredirectionforwaterpayment as BIT) as INT) as property_tenancy_offer_tenant_redirection_water_payment_flag
, CAST(CAST(opp.zav_pcrsigned as BIT) as INT) as property_tenancy_pcr_signed_flag
, CAST(CAST(opp.zav_petauthorisationpaperworkcompleted as BIT) as INT) as property_tenancy_pet_authorisation_paperwork_completed_flag
, CAST(CAST(opp.zav_previoustenancyfinalised as BIT) as INT) as property_tenancy_previous_tenancy_finalised_flag
, CAST(CAST(opp.zav_primarysupportneedsentered as BIT) as INT) as property_tenancy_primary_support_needs_entered_flag
, CAST(CAST(opp.zav_providehealthanddisabilityinformation as BIT) as INT) as property_tenancy_health_disability_information_flag
, CAST(CAST(opp.zav_providetenancypack as BIT) as INT) as property_tenancy_tenancy_pack_flag
, CAST(CAST(opp.zav_risksentered as BIT) as INT) as property_tenancy_risks_entered_flag
, CAST(CAST(opp.zav_routineinspectionfrequencycheckbox as BIT) as INT) as property_tenancy_routine_inspection_frequency_checkbox_flag
, CAST(CAST(opp.zav_setupinspectiondatechecknextinspectiondat as BIT) as INT) as property_tenancy_check_next_inspection_date_flag
, CAST(CAST(opp.zav_setupofrentreviewdates as BIT) as INT) as property_tenancy_setup_rent_review_dates_flag
, CAST(CAST(opp.zav_signedmsdresponsibilitiesconditions as BIT) as INT) as property_tenancy_signed_msd_responsibilities_conditions_flag
, CAST(CAST(opp.zav_signedsngforms as BIT) as INT) as property_tenancy_signed_sng_forms_flag
, CAST(CAST(opp.zav_subsidy as BIT) as INT) as property_tenancy_subsidy_flag
, CAST(CAST(opp.zav_supportpeopleandemergencycontactsuptodate as BIT) as INT) as property_tenancy_support_people_emergency_contacts_uptodate_flag
, CAST(CAST(opp.zav_tenancycontributionrenthasbeensetup as BIT) as INT) as property_tenancy_contribution_rent_setup_flag
, CAST(CAST(opp.zav_tenancyinitialassessmentcompleted as BIT) as INT) as property_tenancy_initial_assessment_completed_flag
, CAST(CAST(opp.zav_tenancyprogrammecorrect as BIT) as INT) as property_tenancy_tenancy_programme_correct_flag
, CAST(CAST(opp.zav_tenancystartedinboswithallcorrectdetails as BIT) as INT) as property_tenancy_tenancy_started_bos_correct_details_flag
, CAST(CAST(opp.zav_tenantconfirmedcondition as BIT) as INT) as property_tenancy_tenant_confirmed_condition_flag
, CAST(CAST(opp.zav_tenantconfirmsingoinginventorylist as BIT) as INT) as property_tenancy_tenant_confirms_ingoing_inventory_list_flag
, CAST(CAST(opp.zav_transfer as BIT) as INT) as property_tenancy_transfer_flag
, CAST(CAST(opp.zav_understandsoohprocess as BIT) as INT) as property_tenancy_understand_sooh_process_flag
, CAST(CAST(opp.zav_vacateconfirmation as BIT) as INT) as property_tenancy_vacate_confirmation_flag
, CAST(CAST(opp.zav_washouseholdingreatestneed as BIT) as INT) as property_tenancy_household_in_greatest_need_flag
, CAST(CAST(opp.zav_wastenanthomeless as BIT) as INT) as property_tenancy_tenant_homeless_flag
, CAST(CAST(opp.zav_waterredirectionstarted as BIT) as INT) as property_tenancy_water_redirection_started_flag
, CAST(CAST(opp.zav_welcomevisitcomplete as BIT) as INT) as property_tenancy_welcome_visit_complete_flag
--,opp.createdon AS property_tenancy_created_datetime

,CAST((opp.createdon AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_created_datetime

--,opp.SinkCreatedOn
--,opp.[modifiedon]  AS property_tenancy_modified_datetime
,CAST((opp.[modifiedon] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_modified_datetime
,CAST(CAST(opp.[IsDelete]  as BIT) as INT) AS property_tenancy_is_delete_flag
 ,CAST(status_opp.LocalizedLabel AS VARCHAR(40)) AS property_tenant_opportunity_status 
  
  
  FROM [Zavanti].[vw_opportunity] AS opp
--LEFT JOIN [Zavanti].[vw_StateMetadata] AS state_mt ON state_mt.EntityName = 'zav_maintenancetask' AND state_mt.state = opp.statecode
--LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_mt ON status_mt.EntityName = 'zav_maintenancetask' AND status_mt.state = opp.statecode AND status_mt.status = opp.statuscode
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS msdyn_forecastcategory_om ON   msdyn_forecastcategory_om.EntityName = 'opportunity' AND msdyn_forecastcategory_om.OptionSetName = 'msdyn_forecastcategory' AND msdyn_forecastcategory_om.[Option] = opp.msdyn_forecastcategory
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS opportunityratingcode_om ON   opportunityratingcode_om.EntityName = 'opportunity' AND opportunityratingcode_om.OptionSetName = 'opportunityratingcode' AND opportunityratingcode_om.[Option] = opp.opportunityratingcode
--LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS prioritycode_om ON   prioritycode_om.EntityName = 'opportunity' AND prioritycode_om.OptionSetName = 'prioritycode' AND prioritycode_om.[Option] = opp.prioritycode
--LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS salesstagecode_om ON   salesstagecode_om.EntityName = 'opportunity' AND salesstagecode_om.OptionSetName = 'salesstagecode' AND salesstagecode_om.[Option] = opp.salesstagecode
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_routineinspectionfrequency_om ON   zav_routineinspectionfrequency_om.EntityName = 'opportunity' AND zav_routineinspectionfrequency_om.OptionSetName = 'zav_routineinspectionfrequency' AND zav_routineinspectionfrequency_om.[Option] = opp.zav_routineinspectionfrequency
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_tenancyappropriatelyreason_om ON   zav_tenancyappropriatelyreason_om.EntityName = 'opportunity' AND zav_tenancyappropriatelyreason_om.OptionSetName = 'zav_tenancyappropriatelyreason' AND zav_tenancyappropriatelyreason_om.[Option] = opp.zav_tenancyappropriatelyreason
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_tenancyappropriatelystatus_om ON   zav_tenancyappropriatelystatus_om.EntityName = 'opportunity' AND zav_tenancyappropriatelystatus_om.OptionSetName = 'zav_tenancyappropriatelystatus' AND zav_tenancyappropriatelystatus_om.[Option] = opp.zav_tenancyappropriatelystatus
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_expectedpaymentfrequency_om ON   zav_expectedpaymentfrequency_om.EntityName = 'opportunity' AND zav_expectedpaymentfrequency_om.OptionSetName = 'zav_expectedpaymentfrequency' AND zav_expectedpaymentfrequency_om.[Option] = opp.zav_expectedpaymentfrequency
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS pricingerrorcode_gm ON  pricingerrorcode_gm.EntityName = 'opportunity' AND  pricingerrorcode_gm.OptionSetName = 'pricingerrorcode' AND pricingerrorcode_gm.[Option] = opp.pricingerrorcode
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS salesstage_gm ON  salesstage_gm.EntityName = 'opportunity' AND  salesstage_gm.OptionSetName = 'salesstage' AND salesstage_gm.[Option] = opp.salesstage
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS skippricecalculation_gm ON  skippricecalculation_gm.EntityName = 'opportunity' AND  skippricecalculation_gm.OptionSetName = 'skippricecalculation' AND skippricecalculation_gm.[Option] = opp.skippricecalculation
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_arrearsarrangementbeenactivatedinzavanti_gm ON  zav_arrearsarrangementbeenactivatedinzavanti_gm.EntityName = 'opportunity' AND  zav_arrearsarrangementbeenactivatedinzavanti_gm.OptionSetName = 'zav_arrearsarrangementbeenactivatedinzavanti' AND zav_arrearsarrangementbeenactivatedinzavanti_gm.[Option] = opp.zav_arrearsarrangementbeenactivatedinzavanti
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_arrearsarrangementbeensignedwiththeclient_gm ON  zav_arrearsarrangementbeensignedwiththeclient_gm.EntityName = 'opportunity' AND  zav_arrearsarrangementbeensignedwiththeclient_gm.OptionSetName = 'zav_arrearsarrangementbeensignedwiththeclient' AND zav_arrearsarrangementbeensignedwiththeclient_gm.[Option] = opp.zav_arrearsarrangementbeensignedwiththeclient
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_bondrefundsngclaimcompleted_gm ON  zav_bondrefundsngclaimcompleted_gm.EntityName = 'opportunity' AND  zav_bondrefundsngclaimcompleted_gm.OptionSetName = 'zav_bondrefundsngclaimcompleted' AND zav_bondrefundsngclaimcompleted_gm.[Option] = opp.zav_bondrefundsngclaimcompleted
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_bondrefundsngclaimlodged_gm ON  zav_bondrefundsngclaimlodged_gm.EntityName = 'opportunity' AND  zav_bondrefundsngclaimlodged_gm.OptionSetName = 'zav_bondrefundsngclaimlodged' AND zav_bondrefundsngclaimlodged_gm.[Option] = opp.zav_bondrefundsngclaimlodged
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_complexityofneed_gm ON  zav_complexityofneed_gm.EntityName = 'opportunity' AND  zav_complexityofneed_gm.OptionSetName = 'zav_complexityofneed' AND zav_complexityofneed_gm.[Option] = opp.zav_complexityofneed
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_exitpoint_gm ON  zav_exitpoint_gm.EntityName = 'opportunity' AND  zav_exitpoint_gm.OptionSetName = 'zav_exitpoint' AND zav_exitpoint_gm.[Option] = opp.zav_exitpoint
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_expectedpaymentday_gm ON  zav_expectedpaymentday_gm.EntityName = 'opportunity' AND  zav_expectedpaymentday_gm.OptionSetName = 'zav_expectedpaymentday' AND zav_expectedpaymentday_gm.[Option] = opp.zav_expectedpaymentday
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_fixedterm_gm ON  zav_fixedterm_gm.EntityName = 'opportunity' AND  zav_fixedterm_gm.OptionSetName = 'zav_fixedterm' AND zav_fixedterm_gm.[Option] = opp.zav_fixedterm
--LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_frequency_gm ON  zav_frequency_gm.EntityName = 'opportunity' AND  zav_frequency_gm.OptionSetName = 'zav_frequency' AND zav_frequency_gm.[Option] = opp.zav_frequency
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_hastenantrescindednoticetovacate_gm ON  zav_hastenantrescindednoticetovacate_gm.EntityName = 'opportunity' AND  zav_hastenantrescindednoticetovacate_gm.OptionSetName = 'zav_hastenantrescindednoticetovacate' AND zav_hastenantrescindednoticetovacate_gm.[Option] = opp.zav_hastenantrescindednoticetovacate
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_hpftenancy_gm ON  zav_hpftenancy_gm.EntityName = 'opportunity' AND  zav_hpftenancy_gm.OptionSetName = 'zav_hpftenancy' AND zav_hpftenancy_gm.[Option] = opp.zav_hpftenancy
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_inadvanceflag_gm ON  zav_inadvanceflag_gm.EntityName = 'opportunity' AND  zav_inadvanceflag_gm.OptionSetName = 'zav_inadvanceflag' AND zav_inadvanceflag_gm.[Option] = opp.zav_inadvanceflag
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_inapphousednoofbedroomsreqd_gm ON  zav_inapphousednoofbedroomsreqd_gm.EntityName = 'opportunity' AND  zav_inapphousednoofbedroomsreqd_gm.OptionSetName = 'zav_inapphousednoofbedroomsreqd' AND zav_inapphousednoofbedroomsreqd_gm.[Option] = opp.zav_inapphousednoofbedroomsreqd
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_inputrequiredfromcort_gm ON  zav_inputrequiredfromcort_gm.EntityName = 'opportunity' AND  zav_inputrequiredfromcort_gm.OptionSetName = 'zav_inputrequiredfromcort' AND zav_inputrequiredfromcort_gm.[Option] = opp.zav_inputrequiredfromcort
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_leavingreason_gm ON  zav_leavingreason_gm.EntityName = 'opportunity' AND  zav_leavingreason_gm.OptionSetName = 'zav_leavingreason' AND zav_leavingreason_gm.[Option] = opp.zav_leavingreason
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_maintenancefundclaimcompleted_gm ON  zav_maintenancefundclaimcompleted_gm.EntityName = 'opportunity' AND  zav_maintenancefundclaimcompleted_gm.OptionSetName = 'zav_maintenancefundclaimcompleted' AND zav_maintenancefundclaimcompleted_gm.[Option] = opp.zav_maintenancefundclaimcompleted
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_maintenancefundclaimlodgedwithhud_gm ON  zav_maintenancefundclaimlodgedwithhud_gm.EntityName = 'opportunity' AND  zav_maintenancefundclaimlodgedwithhud_gm.OptionSetName = 'zav_maintenancefundclaimlodgedwithhud' AND zav_maintenancefundclaimlodgedwithhud_gm.[Option] = opp.zav_maintenancefundclaimlodgedwithhud
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_rebatestatus_gm ON  zav_rebatestatus_gm.EntityName = 'opportunity' AND  zav_rebatestatus_gm.OptionSetName = 'zav_rebatestatus' AND zav_rebatestatus_gm.[Option] = opp.zav_rebatestatus
--LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_refundreason_gm ON  zav_refundreason_gm.EntityName = 'opportunity' AND  zav_refundreason_gm.OptionSetName = 'zav_refundreason' AND zav_refundreason_gm.[Option] = opp.zav_refundreason
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS new_applicationtype_gm ON  new_applicationtype_gm.EntityName = 'opportunity' AND  new_applicationtype_gm.OptionSetName = 'new_applicationtype' AND new_applicationtype_gm.[Option] = opp.new_applicationtype
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_rentchargedday_gm ON  zav_rentchargedday_gm.EntityName = 'opportunity' AND  zav_rentchargedday_gm.OptionSetName = 'zav_rentchargedday' AND zav_rentchargedday_gm.[Option] = opp.zav_rentchargedday
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_rentpaidinadvance_gm ON  zav_rentpaidinadvance_gm.EntityName = 'opportunity' AND  zav_rentpaidinadvance_gm.OptionSetName = 'zav_rentpaidinadvance' AND zav_rentpaidinadvance_gm.[Option] = opp.zav_rentpaidinadvance
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_weeksbondisbeingaskedfor_gm ON  zav_weeksbondisbeingaskedfor_gm.EntityName = 'opportunity' AND  zav_weeksbondisbeingaskedfor_gm.OptionSetName = 'zav_weeksbondisbeingaskedfor' AND zav_weeksbondisbeingaskedfor_gm.[Option] = opp.zav_weeksbondisbeingaskedfor
LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_writeoffrequired_gm ON  zav_writeoffrequired_gm.EntityName = 'opportunity' AND  zav_writeoffrequired_gm.OptionSetName = 'zav_writeoffrequired' AND zav_writeoffrequired_gm.[Option] = opp.zav_writeoffrequired
LEFT JOin [Zavanti].[vw_zav_voidcategory] vc ON vc.Id = opp.zav_voidcategory
--LEFT JOIN [Zavanti].[vw_systemuser] tm ON tm.id = opp.zav_tenancymanagerid
LEFT JOIN [Zavanti].[vw_systemuser] la ON la.id = opp.zav_leaseagreementby
--left join [Zavanti].[vw_zav_leasecontract] lc ON  lc.ID = opp.parentcontactid
--WHERE opp.IsDelete IS NULL
LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_opp
     ON status_opp.EntityName = 'opportunity'
    AND status_opp.State = opp.statecode
    AND status_opp.Status = opp.statuscode