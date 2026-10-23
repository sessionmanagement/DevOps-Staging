CREATE   VIEW [ETL].[fact_property_void_checklist]

/**********************************************************************************************************
View			[ETL].[fact_property_void_checklist]
Author			Mike Gencic
Created			2025/02/28
Purpose			Property void category vw_zav_voidchecklist to generate fact_void_checklist
                Simplified version with reduced columns (85 → 42 columns)
                
=========================================================================================================
REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2025/02/28    Mike Gencic		Initial version
1.1      2025/04/30    Greg Nuthall	    Created date and status name from vw_OptionsetMetadata
2.0      2026/02/26    Greg Nuthall	    Reduced from 85 to 42 columns (removed 43 operational tracking fields)
                                        Work Item 12210: Property field improvements
2.1      2026-07-27    Greg Nuthall	    Added void_checklist_state_code + void_checklist_state_code_name
                                        (User Story 14211, Gap D)
**********************************************************************************************************/

AS
    SELECT
        /* Primary Key for this fact */
        vcList.Id AS void_checklist_id,

        /* Generic state/status/CRM fields */
        vcList.zav_voidcheckliststatus       AS void_checklist_status,
        om.LocalizedLabel                    AS void_checklist_status_name,

        vcList.statecode                     AS void_checklist_state_code,
        state_md.LocalizedLabel              AS void_checklist_state_code_name,

        /* Foreign-key references (Property, Tenancy, Void Category) */
        vcList.zav_offeredproperty           AS offered_property_id,
        vcList.zav_offeredproperty_entitytype AS offered_property_entity_type,

        vcList.zav_property                  AS property_id,
        vcList.zav_property_entitytype       AS property_entity_type,

        vcList.zav_vacatedtenancy            AS vacated_tenancy_id,
        vcList.zav_vacatedtenancy_entitytype AS vacated_tenancy_entity_type,

        vcList.zav_voidcategory              AS void_category_id,
        vcList.zav_voidcategory_entitytype   AS void_category_entity_type,

        /* Owner references */
        vcList.ownerid                       AS owner_id,
        vcList.ownerid_entitytype            AS owner_entity_type,

        /* Misc. Comments */
        vcList.crba8_comments                AS comments,

        /* Name + Created metadata */
        vcList.createdon                     AS created_on,
        vcList.owneridname                   AS owner_id_name,

        /* Checklist flags / booleans - RETAINED FIELDS ONLY */
        vcList.zav_assessmentscoping                  AS assessment_scoping,
        vcList.zav_bondrecoveryformscompleted         AS bond_recovery_forms_completed,

        /* Date columns for void turnaround process - KEY DATES ONLY */
        vcList.zav_datekeyreceivedfromtenant          AS date_key_received_from_tenant,
        vcList.zav_datekeystotenancyteamtoallocate    AS date_keys_to_tenancy_team_to_allocate,
        vcList.zav_dateprevacateinspection            AS date_pre_vacate_inspection,
        vcList.zav_datetenancyterminated              AS date_tenancy_terminated,

        /* Checklist Name + Additional references */
        vcList.zav_name                                AS void_checklist_name,
        vcList.zav_offeredpropertyname                 AS offered_property_name,
        vcList.zav_propertyname                        AS property_name,
        vcList.zav_propertyunitssubmittedtobosapproved AS property_units_submitted_to_bos_approved,
        vcList.zav_targetcompletiondatevacant          AS target_completion_date_vacant,
        vcList.zav_targetcompletiondatevoid            AS target_completion_date_void,
        vcList.zav_tenancyresolvedandexited            AS tenancy_resolved_and_exited,
        vcList.zav_utilitiesconnectionsrecordedandsetupifapp AS utilities_connections_recorded_and_setup_if_applicable,
        vcList.zav_utilitiesdisconnected               AS utilities_disconnected,

        vcList.zav_vacatedtenancyname                 AS vacated_tenancy_name,
        vcList.zav_voidcategoryname                   AS void_category_name,
        vcList.zav_voidchecklistid                    AS property_void_checklist_id,
        vcList.zav_voidcompleteddate                  AS void_completed_date,

        /* Deleted flag */
        CAST(CAST(vcList.IsDelete AS BIT) AS INT)    AS is_delete_flag

    FROM [Zavanti].[vw_zav_voidchecklist] AS vcList
        LEFT OUTER JOIN (
        SELECT
            [Option],
            MAX(o.LocalizedLabel) AS LocalizedLabel
        FROM [Zavanti].[vw_OptionsetMetadata] o
        WHERE o.OptionSetName = 'zav_voidcheckliststatus'
        GROUP BY o.[Option]
    ) om ON vcList.zav_voidcheckliststatus = om.[Option]
        LEFT OUTER JOIN [Zavanti].[vw_StateMetadata] AS state_md
        ON state_md.EntityName = 'zav_voidchecklist'
            AND state_md.State = vcList.statecode