
create   view [ETL].[fact_void_checklist]


--View			[ETL].[fact_finance_general_ledger]
--Author		Mike Gencic
--Created		2025/02/28
--Purpose		Property void category vw_zav_voidchecklist to generate fact_void_checklist
				
--=========================================================================================================
--REVISIONS:
--Version	 Date		   Author			Description
---------	 ------------  ---------------	--------------------------
--1.0		 2025/02/28    Mike Gencic		Initial version
--1.1        2025/04/30    Greg Nuthall		Created date and status name from vw_OptionsetMetadata
--**********************************************************************************************************/

AS
SELECT
    /* Primary Key for this fact */
    vcList.Id AS void_checklist_id,

    /* Sink / Auditing */
    --vcList.SinkCreatedOn  AS void_checklist_sink_created_on,
    --vcList.SinkModifiedOn AS void_checklist_sink_modified_on,

    /* Generic state/status/CRM fields */
    --vcList.statecode                   AS void_checklist_state_code,
    --vcList.statuscode                  AS void_checklist_status_code,
    vcList.zav_voidcheckliststatus       AS void_checklist_status,
	om.LocalizedLabel					 as void_checklist_status_name,

    /* Created/Modified/Ownership references */
    --vcList.createdby                   AS void_checklist_created_by_id,
    --vcList.createdby_entitytype        AS void_checklist_created_by_entity_type,
    --vcList.createdonbehalfby           AS void_checklist_created_on_behalf_by_id,
    --vcList.createdonbehalfby_entitytype AS void_checklist_created_on_behalf_by_entity_type,
    --vcList.modifiedby                  AS void_checklist_modified_by_id,
    --vcList.modifiedby_entitytype       AS void_checklist_modified_by_entity_type,
    --vcList.modifiedonbehalfby          AS void_checklist_modified_on_behalf_by_id,
    --vcList.modifiedonbehalfby_entitytype AS void_checklist_modified_on_behalf_by_entity_type,

    --vcList.owningbusinessunit          AS void_checklist_owning_business_unit_id,
    --vcList.owningbusinessunit_entitytype AS void_checklist_owning_business_unit_entity_type,
    --vcList.owningteam                  AS void_checklist_owning_team_id,
    --vcList.owningteam_entitytype       AS void_checklist_owning_team_entity_type,
    --vcList.owninguser                  AS void_checklist_owning_user_id,
    --vcList.owninguser_entitytype       AS void_checklist_owning_user_entity_type,

    /* If cloned */
    --vcList.zav_clonedfromid            AS void_checklist_cloned_from_id,
    --vcList.zav_clonedfromid_entitytype AS void_checklist_cloned_from_entity_type,

    /* Foreign-key references (Property, Tenancy, Void Category) */
    vcList.zav_offeredproperty         AS void_checklist_offered_property_id,
    vcList.zav_offeredproperty_entitytype AS void_checklist_offered_property_entity_type,

    vcList.zav_property                AS void_checklist_property_id,
    vcList.zav_property_entitytype     AS void_checklist_property_entity_type,

    vcList.zav_vacatedtenancy          AS void_checklist_vacated_tenancy_id,
    vcList.zav_vacatedtenancy_entitytype AS void_checklist_vacated_tenancy_entity_type,

    vcList.zav_voidcategory            AS void_checklist_void_category_id,
    vcList.zav_voidcategory_entitytype AS void_checklist_void_category_entity_type,

    /* Owner references */
    vcList.ownerid                     AS void_checklist_owner_id,
    vcList.ownerid_entitytype          AS void_checklist_owner_entity_type,

    /* Misc. Comments */
    vcList.crba8_comments              AS void_checklist_crba8_comments,

    /* Name + Created/Modified metadata */
    --vcList.createdbyname               AS void_checklist_created_by_name,
    --vcList.createdbyyominame           AS void_checklist_created_by_yomi_name,
    vcList.createdon                   AS void_checklist_created_on,
    --vcList.createdonbehalfbyname       AS void_checklist_created_on_behalf_by_name,
    --vcList.createdonbehalfbyyominame   AS void_checklist_created_on_behalf_by_yomi_name,
    --vcList.importsequencenumber        AS void_checklist_import_sequence_number,
    --vcList.modifiedbyname              AS void_checklist_modified_by_name,
    --vcList.modifiedbyyominame          AS void_checklist_modified_by_yomi_name,
    --vcList.modifiedon                  AS void_checklist_modified_on,
    --vcList.modifiedonbehalfbyname      AS void_checklist_modified_on_behalf_by_name,
    --vcList.modifiedonbehalfbyyominame  AS void_checklist_modified_on_behalf_by_yomi_name,
    --vcList.overriddencreatedon         AS void_checklist_overridden_created_on,

    vcList.owneridname                 AS void_checklist_owner_id_name,
    --vcList.owneridtype                 AS void_checklist_owner_id_type,
    --vcList.owneridyominame             AS void_checklist_owner_id_yomi_name,
    --vcList.owningbusinessunitname      AS void_checklist_owning_business_unit_name,
    --vcList.timezoneruleversionnumber   AS void_checklist_time_zone_rule_version_number,
    --vcList.utcconversiontimezonecode   AS void_checklist_utc_conversion_timezone_code,
    --vcList.versionnumber               AS void_checklist_version_number,

    /* Checklist flags / booleans */
    vcList.zav_allcomplianceissuescompleted       AS void_checklist_all_compliance_issues_completed,
    vcList.zav_assessmentcompletedandscopeofworksunderst AS void_checklist_assessment_completed_and_scope_of_works_understood,
    vcList.zav_assessmentscoping                  AS void_checklist_assessment_scoping,
    vcList.zav_bondrecoveryformscompleted         AS void_checklist_bond_recovery_forms_completed,
    vcList.zav_bosmsdapprovedproperty             AS void_checklist_bos_msd_approved_property,
    vcList.zav_bosupdatedvacancylisted            AS void_checklist_bos_updated_vacancy_listed,
    vcList.zav_bosupdatedvacatedate               AS void_checklist_bos_updated_vacate_date,
    vcList.zav_carparkingprovisioned              AS void_checklist_car_parking_provisioned,
    --vcList.zav_clonedfromidname                   AS void_checklist_cloned_from_id_name,
    vcList.zav_confirmtenancyhasbeenacceptedinbos AS void_checklist_confirm_tenancy_accepted_in_bos,
    vcList.zav_damageassessment                    AS void_checklist_damage_assessment,

    /* Date columns for void turnaround process */
    vcList.zav_datebondformsignedgiventoagentowner  AS void_checklist_date_bond_form_signed_given_to_agent_owner,
    vcList.zav_dateendofholdforpropertyredevelopment AS void_checklist_date_end_of_hold_for_property_redevelopment,
    vcList.zav_datefinancenotifiedleasepropertyhandedbac AS void_checklist_date_finance_notified_lease_property_handed_back,
    vcList.zav_datefirstoffermade                     AS void_checklist_date_first_offer_made,
    vcList.zav_datehudnotifiedoftenancytribunalapplicati AS void_checklist_date_hud_notified_of_tenancy_tribunal_application,
    vcList.zav_datekeyreceivedfromtenant              AS void_checklist_date_key_received_from_tenant,
    vcList.zav_datekeysreturnedfromcontractor          AS void_checklist_date_keys_returned_from_contractor,
    vcList.zav_datekeysreturnedfromspecialistcontractor AS void_checklist_date_keys_returned_from_specialist_contractor,
    vcList.zav_datekeyssenttospecialistcontractor      AS void_checklist_date_keys_sent_to_specialist_contractor,
    vcList.zav_datekeyssurrenderedtoagentowner         AS void_checklist_date_keys_surrendered_to_agent_owner,
    vcList.zav_datekeystocontractor                    AS void_checklist_date_keys_to_contractor,
    vcList.zav_datekeystolossadjusterinsurance         AS void_checklist_date_keys_to_loss_adjuster_insurance,
    vcList.zav_datekeystopropertyteam                 AS void_checklist_date_keys_to_property_team,
    vcList.zav_datekeystotenancyteamtoallocate         AS void_checklist_date_keys_to_tenancy_team_to_allocate,
    vcList.zav_datemsdnotifiedofpendingtermination     AS void_checklist_date_msd_notified_of_pending_termination,
    vcList.zav_datenoticereceived                      AS void_checklist_date_notice_received,
    vcList.zav_dateofferconfirmedaccepted              AS void_checklist_date_offer_confirmed_accepted,
    vcList.zav_dateoffinalinspectionafterkeysreceived  AS void_checklist_date_of_final_inspection_after_keys_received,
    vcList.zav_dateofhandover                          AS void_checklist_date_of_handover,
    vcList.zav_datepossessiongranted                   AS void_checklist_date_possession_granted,
    vcList.zav_datepostworkinspectioncompleted         AS void_checklist_date_post_work_inspection_completed,
    vcList.zav_dateprevacateinspection                 AS void_checklist_date_pre_vacate_inspection,
    vcList.zav_datesecondoffermade                     AS void_checklist_date_second_offer_made,
    vcList.zav_datetamgainaccessabandonedproperty      AS void_checklist_date_tam_gained_access_abandoned_property,
    vcList.zav_datetenancyterminated                   AS void_checklist_date_tenancy_terminated,
    vcList.zav_dateworkscopecompleted                  AS void_checklist_date_work_scope_completed,

    /* Additional yes/no or completion fields */
    --vcList.zav_deepclean                         AS void_checklist_deep_clean,
    --vcList.zav_defectslistcompleted              AS void_checklist_defects_list_completed,
    --vcList.zav_defectsremediatedbyowner          AS void_checklist_defects_remediated_by_owner,
    --vcList.zav_exitfinalinspectionphotographs    AS void_checklist_exit_final_inspection_photographs,
    --vcList.zav_expectedreadytoletdate            AS void_checklist_expected_ready_to_let_date,
    --vcList.zav_finalcleancomplete                AS void_checklist_final_clean_complete,
    --vcList.zav_financeadvisedofpaymentcycleamountandbond AS void_checklist_finance_advised_of_payment_cycle_amount_and_bond,
    --vcList.zav_fulllegalcomplianceachieved       AS void_checklist_full_legal_compliance_achieved,
    --vcList.zav_fullphotographsetcreated          AS void_checklist_full_photograph_set_created,
    --vcList.zav_furnitureandequipmentprovided     AS void_checklist_furniture_and_equipment_provided,
    --vcList.zav_handbacktotenancyteam            AS void_checklist_handback_to_tenancy_team,
    --vcList.zav_handoverinspectionwithowner       AS void_checklist_handover_inspection_with_owner,
    --vcList.zav_healthyhomesdatareceivedandstatementcanbe AS void_checklist_healthy_homes_data_received_and_statement_can_be,
    --vcList.zav_healthyhomesdataupdated           AS void_checklist_healthy_homes_data_updated,
    --vcList.zav_icpnumbersrecorded                AS void_checklist_icp_numbers_recorded,
    --vcList.zav_initialsnaggingworkscompleted     AS void_checklist_initial_snagging_works_completed,
    --vcList.zav_insuranceconfirmedanddetailsupdated AS void_checklist_insurance_confirmed_and_details_updated,
    --vcList.zav_insurancedetailsconfirmedandentered AS void_checklist_insurance_details_confirmed_and_entered,
    --vcList.zav_insurancenotified                 AS void_checklist_insurance_notified,
    --vcList.zav_itprovisioningdataandcamerasifapplicable AS void_checklist_it_provisioning_data_and_cameras_if_applicable,
    --vcList.zav_keysrecovered                     AS void_checklist_keys_recovered,
    --vcList.zav_keysreturnedtoowner               AS void_checklist_keys_returned_to_owner,
    --vcList.zav_locationsloaded                   AS void_checklist_locations_loaded,
    --vcList.zav_madesafeandsecure                AS void_checklist_made_safe_and_secure,
    --vcList.zav_methamphetminechecksteppingtoprocess  AS void_checklist_methamphetamine_check_stepping_to_process,
    --vcList.zav_methanphetamineclearance          AS void_checklist_methamphetamine_clearance,

    /* Checklist Name + Additional references */
    vcList.zav_name                               AS void_checklist_name,
    --vcList.zav_occupancyagreementsprepared        AS void_checklist_occupancy_agreements_prepared,
    vcList.zav_offeredpropertyname                AS void_checklist_offered_property_name,
    --vcList.zav_ongoingdefectslistcreated          AS void_checklist_ongoing_defects_list_created,
    --vcList.zav_pcrcompleted                       AS void_checklist_pcr_completed,
    --vcList.zav_propertydeactivatedinsystem        AS void_checklist_property_deactivated_in_system,
    --vcList.zav_propertyfilecreatedandloaded       AS void_checklist_property_file_created_and_loaded,
    vcList.zav_propertyname                       AS void_checklist_property_name,
    vcList.zav_propertytoberedeveloped            AS void_checklist_property_to_be_redeveloped,
    vcList.zav_propertyunitssubmittedtobosapproved AS void_checklist_property_units_submitted_to_bos_approved,
    vcList.zav_refurbishmentcompleted             AS void_checklist_refurbishment_completed,
    vcList.zav_repairscompleted                   AS void_checklist_repairs_completed,
    vcList.zav_residentialtenancyagreementprepared AS void_checklist_residential_tenancy_agreement_prepared,
    vcList.zav_rubbishandequipmentremoved         AS void_checklist_rubbish_and_equipment_removed,
    vcList.zav_safetycheck                        AS void_checklist_safety_check,
    vcList.zav_safetycheckcompleted               AS void_checklist_safety_check_completed,
    vcList.zav_servicenamehasbeenenteredatproperty AS void_checklist_service_name_has_been_entered_at_property,
    vcList.zav_shortlistcreated                   AS void_checklist_shortlist_created,
    vcList.zav_signedleaseoragreementreceived     AS void_checklist_signed_lease_or_agreement_received,
    vcList.zav_subprogramprogramenteredatproperty AS void_checklist_subprogram_program_entered_at_property,
    vcList.zav_targetcompletiondatevacant         AS void_checklist_target_completion_date_vacant,
    vcList.zav_targetcompletiondatevoid           AS void_checklist_target_completion_date_void,
    vcList.zav_tenancyresolvedandexited           AS void_checklist_tenancy_resolved_and_exited,
    vcList.zav_tenantimprovementsscopedandagreed  AS void_checklist_tenant_improvements_scoped_and_agreed,
    vcList.zav_upcomingmaintenancejobsbooked      AS void_checklist_upcoming_maintenance_jobs_booked,
    vcList.zav_utilitiesconnectionsrecordedandsetupifapp AS void_checklist_utilities_connections_recorded_and_setup_if_applicable,
    vcList.zav_utilitiesdisconnected             AS void_checklist_utilities_disconnected,

    vcList.zav_vacatedtenancyname               AS void_checklist_vacated_tenancy_name,
    vcList.zav_voidcategoryname                 AS void_checklist_void_category_name,
    vcList.zav_voidchecklistid                  AS void_checklist_void_checklist_id,
    vcList.zav_voidcompleteddate                AS void_checklist_void_completed_date,
    vcList.zav_watermeterreadingsandnumbers     AS void_checklist_water_meter_readings_and_numbers,

    /* Deleted flag */
    CAST(CAST(vcList.IsDelete AS BIT) AS INT)    AS void_checklist_is_delete_flag

FROM [Zavanti].[vw_zav_voidchecklist] AS vcList
	left outer join (select [Option], max(o.LocalizedLabel) as LocalizedLabel
					from [Zavanti].[vw_OptionsetMetadata] o
					where o.OptionSetName = 'zav_voidcheckliststatus'
					group by o.[Option]) om 
		on vcList.zav_voidcheckliststatus = om.[Option]