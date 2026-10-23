

CREATE   VIEW [edw].[vw_fact_property_void_checklist]
AS
    /*********************************************************************************************************
 View		[edw].[vw_fact_property_void_checklist]
 Author		Greg Nuthall
 Created	2026-02-27
 Purpose	Simplified view for fact_property_void_checklist with reduced columns (85 → 42)
			Uses simplified column names (removed "void_checklist_" prefix from most columns)
			Uses dim_property_category_key (renamed from dim_void_category_key)
 
 Work Item: 12210 - Property field improvements
 =========================================================================================================
 
 REVISIONS:
 Version	 Date			Author			Description
 -------	 ------------	---------------	--------------------------
 1.0		 2026-02-27		Greg Nuthall	Created from vw_fact_void_checklist with reduced columns
 1.1         2026-07-27     Greg Nuthall	Added void_checklist_state_code + void_checklist_state_code_name
                                            (User Story 14211, Gap D)
*********************************************************************************************************/

    SELECT
        -- Primary Key
       [fact_property_void_checklist_key]
	
	-- Dimension Keys
	, [dim_property_key]
	, [dim_property_tenancy_key]
	, [dim_offered_property_key]
	, [dim_property_void_category_key]
	
	-- Business Columns (36)
	, [void_checklist_id]
	, [void_checklist_status]
	, [void_checklist_status_name]
	, [void_checklist_state_code]
    , [void_checklist_state_code_name]
	
	, [offered_property_id]
	, [offered_property_entity_type]
	, [property_id]
	, [property_entity_type]
	, [vacated_tenancy_id]
	, [vacated_tenancy_entity_type]
	, [void_category_id]
	, [void_category_entity_type]
	, [owner_id]
	, [owner_entity_type]
	, [comments]
	, [created_on]
	, [owner_id_name]
	, [assessment_scoping]
	, [bond_recovery_forms_completed]
	, [date_key_received_from_tenant]
	, [date_keys_to_tenancy_team_to_allocate]
	, [date_pre_vacate_inspection]
	, [date_tenancy_terminated]
	, [void_checklist_name]
	, [offered_property_name]
	, [property_name]
	, [property_units_submitted_to_bos_approved]
	, [target_completion_date_vacant]
	, [target_completion_date_void]
	, [tenancy_resolved_and_exited]
	, [utilities_connections_recorded_and_setup_if_applicable]
	, [utilities_disconnected]
	, [vacated_tenancy_name]
	, [void_category_name]
	, [property_void_checklist_id]
	, [void_completed_date]
	, [is_delete_flag]
	
	-- DWH Audit Columns (6)
	, [DWHBatchId]
	, [DWHEffectiveFrom]
	, [DWHEffectiveTo]
	, [DWHDMLOperation]
	, [DWHIsCurrent]
	, [DWHSourceSystem]

    FROM [edw].[fact_property_void_checklist]
    WHERE [DWHIsCurrent] = 1 AND [DWHDMLOperation] <> 'D';