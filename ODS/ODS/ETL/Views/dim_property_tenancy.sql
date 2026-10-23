
CREATE     VIEW [ETL].[dim_property_tenancy]
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
--1.5        2025/08/27    Mike Gencic      Added property_tenancy_primary_tenant_recordbaseid
--1.6        2025-09-08    Greg Nuthall     Change tenancy manager name filed in response to Zaharoa change 
--1.7        2026-02-20    GitHub Copilot   Removed 93 redundant columns per work item 12210
--1.8        2026-07-27    Greg Nuthall     Added property_tenancy_primary_tenant_gender, primary_contact_ethnicity_id,
                                            property_tenancy_primary_tenant_date_of_birth (User Story 14211, Gap B)
**************************************************************************************************************/
with cte_Gender as 

(select *
from [Zavanti].[vw_GlobalOptionsetMetadata] gnd
where gnd.OptionSetName = 'zav_gender' and gnd.EntityName = 'contact')


SELECT opp.Id AS property_tenancy_id
, opp.zav_property as property_id
, CAST(opp.zav_tenancytypeidname AS VARCHAR(40)) AS property_tenancy_tenancy_type
, CAST(opp.owningbusinessunitname AS VARCHAR(20)) AS property_tenancy_owning_business_unit_name
, CAST(opp.zav_tenancyid AS VARCHAR(20)) AS property_tenancy_tenancy_identifier 
, CAST(opp.zav_hudmsdreferencenumber AS VARCHAR(20)) AS property_tenancy_tenancy_reference
, CAST(opp.name AS VARCHAR(100)) AS property_tenancy_tenancy_name
, CAST(opp.zav_propertyname AS VARCHAR(100)) AS property_tenancy_property_name
, CAST(opp.zav_householdname AS VARCHAR(100)) AS property_tenancy_household_name
, CAST(opp.customeridname AS VARCHAR(100)) AS property_tenancy_customer_name
, CAST((opp.zav_leaseagreementdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_lease_agreement_datetime
, CAST(opp.zav_tenancystartdate AS DATE)  AS property_tenancy_tenancy_start_date
, CAST((opp.zav_activatetenancydate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_activate_tenancy_datetime
, CAST(opp.zav_actualstartdate AS DATE) AS property_tenancy_actual_start_date
, CAST(opp.zav_fixedtermtenancyenddate AS DATE) AS property_tenancy_fixed_term_tenancy_end_date
, CAST(opp.zav_shorttermtenancyenddate AS DATE) AS property_tenancy_short_term_tenancy_end_date
, CAST(opp.zav_expectedvacateddate AS DATE) AS property_tenancy_expected_vacated_date
, CAST((opp.zav_signedmsdresponsibilitiesconditionsdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_signed_msd_responsibilities_conditions_datetime
, CAST((opp.zav_signedsngformsdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_signed_sng_forms_datetime
, CAST(opp.actualclosedate AS DATE) AS property_tenancy_actual_close_date
, CAST(opp.zav_bondlodged AS DATE) AS property_tenancy_bond_lodged_date
, CAST(opp.zav_bondrefundformlodged AS DATE) AS property_tenancy_bond_refund_lodged_date
, CAST((opp.zav_checkthatbodycorporresidentsdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_check_bodycorp_or_residents_datetime
, CAST(opp.zav_noticetovacatedate AS DATE) AS property_tenancy_notice_to_vacate_date
, CAST((opp.zav_providehealthanddisabilityinformationdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_health_disability_information_datetime
,CAST((opp.zav_providetenancypackdate AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_tenancy_pack_datetime
, CAST(opp.zav_refundlodged AS DATE) AS property_tenancy_refund_lodged_date
, CAST(opp.zav_paytotenancyservicesby AS DATE) AS property_tenancy_pay_tenancy_services_by_date
, opp.zav_shorttermindays AS property_tenancy_short_term_in_days
, CAST(opp.zav_bondreference AS VARCHAR(20)) AS property_tenancy_bond_reference
, CAST(opp.zav_tenancyservicebondnumber AS VARCHAR(20)) AS property_tenancy_tenancy_service_bond_number
, CAST(opp.zav_tenancyservicespropertyid AS VARCHAR(20)) AS property_tenancy_tenancy_services_property_identifier
, CAST(zav_arrearsarrangementbeenactivatedinzavanti_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_arrears_arrangement_activated-- not flag to keep consistent  with field below
, CAST(zav_arrearsarrangementbeensignedwiththeclient_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_arrears_arrangement_signed -- not flag as contains more the Y/N options
, CAST(zav_bondrefundsngclaimcompleted_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_bond_refund_sng_claim_completed --,opp.zav_bondrefundsngclaimcompleted
, CAST(zav_bondrefundsngclaimlodged_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_bond_refund_sng_claim_lodged --,opp.zav_bondrefundsngclaimlodged
, CAST(zav_exitpoint_gm.LocalizedLabel AS VARCHAR(50))  AS property_tenancy_exit_point -- ,opp.zav_exitpoint
, CAST(zav_expectedpaymentday_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_expected_payment_day --,opp.zav_expectedpaymentday
, CAST(zav_expectedpaymentfrequency_om.LocalizedLabel AS VARCHAR(20))  AS property_tenancy_expected_payment_frequency --,opp.zav_expectedpaymentfrequency
, CAST(zav_leavingreason_gm.LocalizedLabel AS VARCHAR(50)) AS property_tenancy_leaving_reason --,opp.zav_leavingreason
, CAST(zav_rentchargedday_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_rent_charged_day --,opp.zav_rentchargedday
, CAST(zav_rentpaidinadvance_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_rent_paid_in_advance --,opp.zav_rentpaidinadvance
, CAST(zav_routineinspectionfrequency_om.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_inspection_frequency --,opp.zav_routineinspectionfrequency
, CAST(zav_weeksbondisbeingaskedfor_gm.LocalizedLabel AS VARCHAR(10)) AS property_tenancy_weeks_bond_requested --,opp.zav_weeksbondisbeingaskedfor
, opp.zav_rentpayablebasicrentcraweekly as property_tenancy_weekly_rent_payable
, CAST(opp.zav_tenancymanageridname AS VARCHAR(100)) AS property_tenancy_manager_name
, CAST(opp.zav_tenancymanageremail AS VARCHAR(40)) AS property_tenancy_manager_email
, opp.new_rent AS property_tenancy_rent
, opp.new_rent_base AS property_tenancy_rent_base
, CAST(pc.new_recordbaseid AS VARCHAR(50)) AS property_tenancy_primary_tenant_recordbaseid

--, ISNULL(CASE WHEN pc.zav_primarytenant = 'True' THEN pc.zav_gender END, 100000001) AS property_tenancy_primary_tenant_gender
--, ISNULL(CASE WHEN pc.zav_primarytenant = 'True' THEN UPPER(CAST(pc.zav_ethnicity AS CHAR(36))) END, '0') AS primary_contact_ethnicity_id
, Cast(gnd.LocalizedLabel as nvarchar(50)) as  property_tenancy_primary_tenant_gender
, ISNULL(CASE WHEN pc.zav_primarytenant = 'True' THEN eth.zav_name else '' end,'') AS primary_contact_ethnicity_name

, CASE WHEN pc.zav_primarytenant = 'True' THEN CAST(pc.new_dateofbirth AS DATE) END AS property_tenancy_primary_tenant_date_of_birth
, opp.zav_numberoftenancysignatories AS property_tenancy_number_signatories
, opp.zav_secondclientname AS property_tenancy_second_client_name
, CAST(opp.zav_startingdateforrentamount AS DATE) AS property_tenancy_rent_amount_start_date
, CAST(opp.zav_vacateddate AS DATE) AS property_tenancy_vacated_date
, CAST(CAST(opp.zav_agreementtoextendthetenancyreceived as BIT) as INT) as property_tenancy_agreement_to_extend_tenancy_received_flag
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

, CAST((opp.createdon AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_created_datetime
, CAST((opp.[modifiedon] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_tenancy_modified_datetime
, CAST(CAST(opp.[IsDelete]  as BIT) as INT) AS property_tenancy_is_delete_flag
 , CAST(status_opp.LocalizedLabel AS VARCHAR(40)) AS property_tenant_opportunity_status


    FROM [Zavanti].[vw_opportunity] AS opp
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS msdyn_forecastcategory_om ON   msdyn_forecastcategory_om.EntityName = 'opportunity' AND msdyn_forecastcategory_om.OptionSetName = 'msdyn_forecastcategory' AND msdyn_forecastcategory_om.[Option] = opp.msdyn_forecastcategory
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS opportunityratingcode_om ON   opportunityratingcode_om.EntityName = 'opportunity' AND opportunityratingcode_om.OptionSetName = 'opportunityratingcode' AND opportunityratingcode_om.[Option] = opp.opportunityratingcode
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_routineinspectionfrequency_om ON   zav_routineinspectionfrequency_om.EntityName = 'opportunity' AND zav_routineinspectionfrequency_om.OptionSetName = 'zav_routineinspectionfrequency' AND zav_routineinspectionfrequency_om.[Option] = opp.zav_routineinspectionfrequency
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_tenancyappropriatelyreason_om ON   zav_tenancyappropriatelyreason_om.EntityName = 'opportunity' AND zav_tenancyappropriatelyreason_om.OptionSetName = 'zav_tenancyappropriatelyreason' AND zav_tenancyappropriatelyreason_om.[Option] = opp.zav_tenancyappropriatelyreason
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_tenancyappropriatelystatus_om ON   zav_tenancyappropriatelystatus_om.EntityName = 'opportunity' AND zav_tenancyappropriatelystatus_om.OptionSetName = 'zav_tenancyappropriatelystatus' AND zav_tenancyappropriatelystatus_om.[Option] = opp.zav_tenancyappropriatelystatus
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS zav_expectedpaymentfrequency_om ON   zav_expectedpaymentfrequency_om.EntityName = 'opportunity' AND zav_expectedpaymentfrequency_om.OptionSetName = 'zav_expectedpaymentfrequency' AND zav_expectedpaymentfrequency_om.[Option] = opp.zav_expectedpaymentfrequency
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS pricingerrorcode_gm ON  pricingerrorcode_gm.EntityName = 'opportunity' AND pricingerrorcode_gm.OptionSetName = 'pricingerrorcode' AND pricingerrorcode_gm.[Option] = opp.pricingerrorcode
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS salesstage_gm ON  salesstage_gm.EntityName = 'opportunity' AND salesstage_gm.OptionSetName = 'salesstage' AND salesstage_gm.[Option] = opp.salesstage
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS skippricecalculation_gm ON  skippricecalculation_gm.EntityName = 'opportunity' AND skippricecalculation_gm.OptionSetName = 'skippricecalculation' AND skippricecalculation_gm.[Option] = opp.skippricecalculation
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_arrearsarrangementbeenactivatedinzavanti_gm ON  zav_arrearsarrangementbeenactivatedinzavanti_gm.EntityName = 'opportunity' AND zav_arrearsarrangementbeenactivatedinzavanti_gm.OptionSetName = 'zav_arrearsarrangementbeenactivatedinzavanti' AND zav_arrearsarrangementbeenactivatedinzavanti_gm.[Option] = opp.zav_arrearsarrangementbeenactivatedinzavanti
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_arrearsarrangementbeensignedwiththeclient_gm ON  zav_arrearsarrangementbeensignedwiththeclient_gm.EntityName = 'opportunity' AND zav_arrearsarrangementbeensignedwiththeclient_gm.OptionSetName = 'zav_arrearsarrangementbeensignedwiththeclient' AND zav_arrearsarrangementbeensignedwiththeclient_gm.[Option] = opp.zav_arrearsarrangementbeensignedwiththeclient
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_bondrefundsngclaimcompleted_gm ON  zav_bondrefundsngclaimcompleted_gm.EntityName = 'opportunity' AND zav_bondrefundsngclaimcompleted_gm.OptionSetName = 'zav_bondrefundsngclaimcompleted' AND zav_bondrefundsngclaimcompleted_gm.[Option] = opp.zav_bondrefundsngclaimcompleted
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_bondrefundsngclaimlodged_gm ON  zav_bondrefundsngclaimlodged_gm.EntityName = 'opportunity' AND zav_bondrefundsngclaimlodged_gm.OptionSetName = 'zav_bondrefundsngclaimlodged' AND zav_bondrefundsngclaimlodged_gm.[Option] = opp.zav_bondrefundsngclaimlodged
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_complexityofneed_gm ON  zav_complexityofneed_gm.EntityName = 'opportunity' AND zav_complexityofneed_gm.OptionSetName = 'zav_complexityofneed' AND zav_complexityofneed_gm.[Option] = opp.zav_complexityofneed
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_exitpoint_gm ON  zav_exitpoint_gm.EntityName = 'opportunity' AND zav_exitpoint_gm.OptionSetName = 'zav_exitpoint' AND zav_exitpoint_gm.[Option] = opp.zav_exitpoint
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_expectedpaymentday_gm ON  zav_expectedpaymentday_gm.EntityName = 'opportunity' AND zav_expectedpaymentday_gm.OptionSetName = 'zav_expectedpaymentday' AND zav_expectedpaymentday_gm.[Option] = opp.zav_expectedpaymentday
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_fixedterm_gm ON  zav_fixedterm_gm.EntityName = 'opportunity' AND zav_fixedterm_gm.OptionSetName = 'zav_fixedterm' AND zav_fixedterm_gm.[Option] = opp.zav_fixedterm
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_hastenantrescindednoticetovacate_gm ON  zav_hastenantrescindednoticetovacate_gm.EntityName = 'opportunity' AND zav_hastenantrescindednoticetovacate_gm.OptionSetName = 'zav_hastenantrescindednoticetovacate' AND zav_hastenantrescindednoticetovacate_gm.[Option] = opp.zav_hastenantrescindednoticetovacate
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_hpftenancy_gm ON  zav_hpftenancy_gm.EntityName = 'opportunity' AND zav_hpftenancy_gm.OptionSetName = 'zav_hpftenancy' AND zav_hpftenancy_gm.[Option] = opp.zav_hpftenancy
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_inadvanceflag_gm ON  zav_inadvanceflag_gm.EntityName = 'opportunity' AND zav_inadvanceflag_gm.OptionSetName = 'zav_inadvanceflag' AND zav_inadvanceflag_gm.[Option] = opp.zav_inadvanceflag
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_inapphousednoofbedroomsreqd_gm ON  zav_inapphousednoofbedroomsreqd_gm.EntityName = 'opportunity' AND zav_inapphousednoofbedroomsreqd_gm.OptionSetName = 'zav_inapphousednoofbedroomsreqd' AND zav_inapphousednoofbedroomsreqd_gm.[Option] = opp.zav_inapphousednoofbedroomsreqd
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_inputrequiredfromcort_gm ON  zav_inputrequiredfromcort_gm.EntityName = 'opportunity' AND zav_inputrequiredfromcort_gm.OptionSetName = 'zav_inputrequiredfromcort' AND zav_inputrequiredfromcort_gm.[Option] = opp.zav_inputrequiredfromcort
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_leavingreason_gm ON  zav_leavingreason_gm.EntityName = 'opportunity' AND zav_leavingreason_gm.OptionSetName = 'zav_leavingreason' AND zav_leavingreason_gm.[Option] = opp.zav_leavingreason
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_maintenancefundclaimcompleted_gm ON  zav_maintenancefundclaimcompleted_gm.EntityName = 'opportunity' AND zav_maintenancefundclaimcompleted_gm.OptionSetName = 'zav_maintenancefundclaimcompleted' AND zav_maintenancefundclaimcompleted_gm.[Option] = opp.zav_maintenancefundclaimcompleted
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_maintenancefundclaimlodgedwithhud_gm ON  zav_maintenancefundclaimlodgedwithhud_gm.EntityName = 'opportunity' AND zav_maintenancefundclaimlodgedwithhud_gm.OptionSetName = 'zav_maintenancefundclaimlodgedwithhud' AND zav_maintenancefundclaimlodgedwithhud_gm.[Option] = opp.zav_maintenancefundclaimlodgedwithhud
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_rebatestatus_gm ON  zav_rebatestatus_gm.EntityName = 'opportunity' AND zav_rebatestatus_gm.OptionSetName = 'zav_rebatestatus' AND zav_rebatestatus_gm.[Option] = opp.zav_rebatestatus
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS new_applicationtype_gm ON  new_applicationtype_gm.EntityName = 'opportunity' AND new_applicationtype_gm.OptionSetName = 'new_applicationtype' AND new_applicationtype_gm.[Option] = opp.new_applicationtype
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_rentchargedday_gm ON  zav_rentchargedday_gm.EntityName = 'opportunity' AND zav_rentchargedday_gm.OptionSetName = 'zav_rentchargedday' AND zav_rentchargedday_gm.[Option] = opp.zav_rentchargedday
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_rentpaidinadvance_gm ON  zav_rentpaidinadvance_gm.EntityName = 'opportunity' AND zav_rentpaidinadvance_gm.OptionSetName = 'zav_rentpaidinadvance' AND zav_rentpaidinadvance_gm.[Option] = opp.zav_rentpaidinadvance
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_weeksbondisbeingaskedfor_gm ON  zav_weeksbondisbeingaskedfor_gm.EntityName = 'opportunity' AND zav_weeksbondisbeingaskedfor_gm.OptionSetName = 'zav_weeksbondisbeingaskedfor' AND zav_weeksbondisbeingaskedfor_gm.[Option] = opp.zav_weeksbondisbeingaskedfor
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS zav_writeoffrequired_gm ON  zav_writeoffrequired_gm.EntityName = 'opportunity' AND zav_writeoffrequired_gm.OptionSetName = 'zav_writeoffrequired' AND zav_writeoffrequired_gm.[Option] = opp.zav_writeoffrequired
        LEFT JOin [Zavanti].[vw_zav_voidcategory] vc ON vc.Id = opp.zav_voidcategory
        LEFT JOIN [Zavanti].[vw_systemuser] la ON la.id = opp.zav_leaseagreementby
        LEFT JOIN [Zavanti].[vw_contact] pc ON pc.Id = opp.parentcontactid
        LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_opp
        ON status_opp.EntityName = 'opportunity'
            AND status_opp.State = opp.statecode
            AND status_opp.Status = opp.statuscode

        left join [Zavanti].[vw_zav_ethnicity] eth on try_cast(pc.zav_ethnicity as nvarchar(40)) = try_cast(eth.zav_ethnicityid as nvarchar(40))
        left join cte_gender gnd on cast(ISNULL(CASE WHEN pc.zav_primarytenant = 'True' THEN pc.zav_gender END, 100000001) as int) = cast(gnd.[Option] as int)