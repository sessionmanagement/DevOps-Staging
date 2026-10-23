
/**********************************************************************************************************
 Script: 12210_Remove_fact_property_tenancy_transaction_columns.sql
 Author: GitHub Copilot
 Created: February 19, 2026
 Purpose: Remove all redundant property columns
 **********************************************************************************************************/


/**********************************************************************************************************
 Script: 12210_Remove_fact_property_tenancy_transaction_columns.sql
 Author: GitHub Copilot
 Created: February 19, 2026
 Purpose: Remove redundant columns from fact_property_tenancy_transaction tables per work item 12210
 
 Tables affected:
 - edw.fact_property_tenancy_transaction
 - landing.edw_fact_property_tenancy_transaction
 - staging.ODSETLfact_property_tenancy_transaction
**********************************************************************************************************/

-- Drop from edw schema first
--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_transaction_payment_type_id' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
--ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_payment_type_id
--GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_payment_type' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_payment_type
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_import_comments' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_import_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_chintaro_id' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_chintaro_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_amount_base' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_amount_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_non_rent_base' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_non_rent_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_rent_base' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_rent_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total_base' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_total_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_syncd_to_bc_flag' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_syncd_to_bc_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_running_balance_sync_flag' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_running_balance_sync_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_calculation_flag' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_calculation_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_entity_mismatch_flag' AND object_id = OBJECT_ID('edw.fact_property_tenancy_transaction'))
ALTER TABLE edw.fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_entity_mismatch_flag
GO

-- Drop from landing schema
--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_transaction_payment_type_id' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
--ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_payment_type_id
--GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_payment_type' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_payment_type
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_import_comments' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_import_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_chintaro_id' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_chintaro_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_amount_base' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_amount_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_non_rent_base' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_non_rent_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_rent_base' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_rent_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total_base' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_total_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_syncd_to_bc_flag' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_syncd_to_bc_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_running_balance_sync_flag' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_running_balance_sync_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_calculation_flag' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_calculation_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_entity_mismatch_flag' AND object_id = OBJECT_ID('landing.edw_fact_property_tenancy_transaction'))
ALTER TABLE landing.edw_fact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_entity_mismatch_flag
GO

-- Drop from staging schema
--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_transaction_payment_type_id' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
--ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_payment_type_id
--GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_payment_type' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_payment_type
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_import_comments' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_import_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_chintaro_id' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_chintaro_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_amount_base' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_amount_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_non_rent_base' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_non_rent_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_rent_base' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_rent_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total_base' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_total_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_syncd_to_bc_flag' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_syncd_to_bc_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_running_balance_sync_flag' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_running_balance_sync_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_calculation_flag' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_balance_calculation_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_entity_mismatch_flag' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenancy_transaction'))
ALTER TABLE staging.ODSETLfact_property_tenancy_transaction DROP COLUMN property_tenancy_transaction_entity_mismatch_flag
GO

PRINT 'Successfully removed 13 columns from fact_property_tenancy_transaction tables'
GO

/**********************************************************************************************************
 Script: 12210_Remove_dim_property_tenancy_columns.sql
 Author: GitHub Copilot
 Created: February 24, 2026
 Purpose: Remove redundant columns from dim_property_tenancy tables per work item 12210
 
 Tables affected:
 - edw.dim_property_tenancy
 - landing.edw_dim_property_tenancy
 - staging.ODSETLdim_property_tenancy
 
 NOTE: 95 columns identified for removal - large reduction in table size
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_program_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_program_name
GO

--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_weekly_rent_payable' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
--ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_weekly_rent_payable
--GO


IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_subprogram_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_subprogram_name
GO

--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_property_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
--ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_property_name
--GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant1_mobile_phone' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_tenant1_mobile_phone
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant2_mobile_phone' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_tenant2_mobile_phone
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_accris_start_date' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_accris_start_date
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_greeting_line' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_tenancy_greeting_line
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_msdyn_forecast_category' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_msdyn_forecast_category
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_application_type' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_application_type
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_opportunity_rating_code' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_opportunity_rating_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_pricing_error_code' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_pricing_error_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_sales_stage' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_sales_stage
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_fixed_term' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_fixed_term
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant_rescinded_notice_to_vacate' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_tenant_rescinded_notice_to_vacate
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_advance' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_in_advance
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_app_housed_no_bedrooms_reqd' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_in_app_housed_no_bedrooms_reqd
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_maintenance_fund_claim_completed' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_maintenance_fund_claim_completed
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_maintenance_fund_claim_lodged_with_hud' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_maintenance_fund_claim_lodged_with_hud
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_rebate_status' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_rebate_status
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_appropriately_reason' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_tenancy_appropriately_reason
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_appropriately_status' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_tenancy_appropriately_status
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_writeoff_required' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_writeoff_required
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_lease_agreement_by_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_lease_agreement_by_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_manager_mobile' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_manager_mobile
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_void_checklist' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_void_checklist
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_void_category_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_void_category_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_description' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_description
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_transaction_balance_total
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total_base' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_transaction_balance_total_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_approved_sng_cap' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_approved_sng_cap
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_amount' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_chintaro_bond_amount' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_chintaro_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_bond_amount' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_expected_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_hand' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_in_hand
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_market_rent' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_market_rent
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_newest_rent_update' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_newest_rent_update
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_refund_required' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_refund_required
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_rent_owes_at_expected_vacate_date' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_rent_owes_at_expected_vacate_date
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_other_amenities' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_total_other_amenities
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_rent_amount' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_total_rent_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_rent_amount_base' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_total_rent_amount_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_tenant_liability_amount' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_total_tenant_liability_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_utilities_amount' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_total_utilities_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_mobile' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_mobile
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_relationship' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_relationship
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_parent_contact_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_parent_contact_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_exit_comment' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_exit_comment
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_no_bedrooms_exited_to' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_no_bedrooms_exited_to
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_risks_list' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_risks_list
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_step_name' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_step_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_timezone_rule_version_number' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_timezone_rule_version_number
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_comments' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_bond_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_chintaro_id' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_chintaro_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_comments' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_comment_to_finance' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_comment_to_finance
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_comment1' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_comment1
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_comment2' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_comment2
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_email' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_email
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_relative_url' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_relative_url
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_capture_proposal_feedback_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_capture_proposal_feedback_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_complete_final_proposal_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_complete_final_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_complete_internal_review_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_complete_internal_review_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_confirm_interest_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_confirm_interest_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_crba8_navigator_notified_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_crba8_navigator_notified_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_decision_maker_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_decision_maker_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_develop_proposal_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_develop_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_evaluate_fit_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_evaluate_fit_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_file_debrief_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_file_debrief_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_competitors_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_identify_competitors_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_customer_contacts_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_identify_customer_contacts_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_pursuit_team_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_identify_pursuit_team_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_is_revenue_system_calculated_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_is_revenue_system_calculated_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_activate_tenancy_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_activate_tenancy_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_interpretor_required_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_interpretor_required_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_partnership_arrangement_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_partnership_arrangement_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_keys_received_from_tenant_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_keys_received_from_tenant_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_potential_risk_to_staff_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_potential_risk_to_staff_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_participates_in_workflow_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_participates_in_workflow_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_present_final_proposal_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_present_final_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_present_proposal_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_present_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_pursuit_decision_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_pursuit_decision_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_resolve_feedback_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_resolve_feedback_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_send_thankyou_note_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_send_thankyou_note_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_guarantee_information_provided_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_bond_guarantee_information_provided_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_information_entered_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_bond_information_entered_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_loan_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_bond_loan_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_lodgement_complete_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_bond_lodgement_complete_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_checked_other_tenancies_with_balances_due_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_checked_other_tenancies_with_balances_due_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_check_that_body_corporresidents_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_check_that_body_corporresidents_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_consent_to_hold_personal_information_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_consent_to_hold_personal_information_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_payment_date_correct_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_expected_payment_date_correct_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_payment_day_checkbox_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_expected_payment_day_checkbox_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_familiar_with_supports_neighbours_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_familiar_with_supports_neighbours_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_first_inspection_scheduled_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_first_inspection_scheduled_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_followed_market_rent_review_in_bos_flag' AND object_id = OBJECT_ID('edw.dim_property_tenancy'))
ALTER TABLE edw.dim_property_tenancy DROP COLUMN property_tenancy_followed_market_rent_review_in_bos_flag
GO

-- Drop from landing schema
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_program_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_program_name
GO


--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_weekly_rent_payable' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
--ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_weekly_rent_payable
--GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_subprogram_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_subprogram_name
GO

--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_property_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
--ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_property_name
--GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant1_mobile_phone' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_tenant1_mobile_phone
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant2_mobile_phone' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_tenant2_mobile_phone
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_accris_start_date' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_accris_start_date
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_greeting_line' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_tenancy_greeting_line
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_msdyn_forecast_category' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_msdyn_forecast_category
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_application_type' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_application_type
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_opportunity_rating_code' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_opportunity_rating_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_pricing_error_code' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_pricing_error_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_sales_stage' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_sales_stage
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_fixed_term' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_fixed_term
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant_rescinded_notice_to_vacate' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_tenant_rescinded_notice_to_vacate
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_advance' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_in_advance
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_app_housed_no_bedrooms_reqd' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_in_app_housed_no_bedrooms_reqd
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_maintenance_fund_claim_completed' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_maintenance_fund_claim_completed
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_maintenance_fund_claim_lodged_with_hud' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_maintenance_fund_claim_lodged_with_hud
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_rebate_status' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_rebate_status
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_appropriately_reason' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_tenancy_appropriately_reason
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_appropriately_status' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_tenancy_appropriately_status
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_writeoff_required' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_writeoff_required
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_lease_agreement_by_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_lease_agreement_by_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_manager_mobile' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_manager_mobile
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_void_checklist' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_void_checklist
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_void_category_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_void_category_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_description' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_description
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_transaction_balance_total
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total_base' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_transaction_balance_total_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_approved_sng_cap' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_approved_sng_cap
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_chintaro_bond_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_chintaro_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_bond_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_expected_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_hand' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_in_hand
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_market_rent' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_market_rent
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_newest_rent_update' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_newest_rent_update
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_refund_required' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_refund_required
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_rent_owes_at_expected_vacate_date' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_rent_owes_at_expected_vacate_date
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_other_amenities' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_total_other_amenities
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_rent_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_total_rent_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_rent_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_total_rent_amount_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_tenant_liability_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_total_tenant_liability_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_utilities_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_total_utilities_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_mobile' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_mobile
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_relationship' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_relationship
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_parent_contact_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_parent_contact_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_exit_comment' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_exit_comment
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_no_bedrooms_exited_to' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_no_bedrooms_exited_to
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_risks_list' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_risks_list
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_step_name' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_step_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_timezone_rule_version_number' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_timezone_rule_version_number
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_comments' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_bond_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_chintaro_id' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_chintaro_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_comments' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_comment_to_finance' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_comment_to_finance
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_comment1' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_comment1
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_comment2' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_comment2
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_email' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_email
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_relative_url' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_relative_url
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_capture_proposal_feedback_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_capture_proposal_feedback_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_complete_final_proposal_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_complete_final_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_complete_internal_review_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_complete_internal_review_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_confirm_interest_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_confirm_interest_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_crba8_navigator_notified_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_crba8_navigator_notified_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_decision_maker_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_decision_maker_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_develop_proposal_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_develop_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_evaluate_fit_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_evaluate_fit_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_file_debrief_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_file_debrief_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_competitors_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_identify_competitors_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_customer_contacts_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_identify_customer_contacts_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_pursuit_team_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_identify_pursuit_team_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_is_revenue_system_calculated_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_is_revenue_system_calculated_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_activate_tenancy_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_activate_tenancy_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_interpretor_required_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_interpretor_required_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_partnership_arrangement_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_partnership_arrangement_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_keys_received_from_tenant_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_keys_received_from_tenant_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_potential_risk_to_staff_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_potential_risk_to_staff_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_participates_in_workflow_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_participates_in_workflow_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_present_final_proposal_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_present_final_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_present_proposal_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_present_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_pursuit_decision_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_pursuit_decision_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_resolve_feedback_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_resolve_feedback_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_send_thankyou_note_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_send_thankyou_note_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_guarantee_information_provided_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_bond_guarantee_information_provided_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_information_entered_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_bond_information_entered_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_loan_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_bond_loan_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_lodgement_complete_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_bond_lodgement_complete_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_checked_other_tenancies_with_balances_due_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_checked_other_tenancies_with_balances_due_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_check_that_body_corporresidents_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_check_that_body_corporresidents_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_consent_to_hold_personal_information_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_consent_to_hold_personal_information_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_payment_date_correct_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_expected_payment_date_correct_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_payment_day_checkbox_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_expected_payment_day_checkbox_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_familiar_with_supports_neighbours_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_familiar_with_supports_neighbours_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_first_inspection_scheduled_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_first_inspection_scheduled_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_followed_market_rent_review_in_bos_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_tenancy'))
ALTER TABLE landing.edw_dim_property_tenancy DROP COLUMN property_tenancy_followed_market_rent_review_in_bos_flag
GO

-- Drop from staging schema
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_program_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_program_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_subprogram_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_subprogram_name
GO

--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_property_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
--ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_property_name
--GO

--IF EXISTS(SELECT *
--FROM sys.columns
--WHERE name='property_tenancy_weekly_rent_payable' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
--ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_weekly_rent_payable
--GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant1_mobile_phone' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_tenant1_mobile_phone
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant2_mobile_phone' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_tenant2_mobile_phone
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_accris_start_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_accris_start_date
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_greeting_line' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_tenancy_greeting_line
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_msdyn_forecast_category' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_msdyn_forecast_category
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_application_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_application_type
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_opportunity_rating_code' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_opportunity_rating_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_pricing_error_code' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_pricing_error_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_sales_stage' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_sales_stage
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_fixed_term' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_fixed_term
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenant_rescinded_notice_to_vacate' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_tenant_rescinded_notice_to_vacate
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_advance' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_in_advance
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_app_housed_no_bedrooms_reqd' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_in_app_housed_no_bedrooms_reqd
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_maintenance_fund_claim_completed' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_maintenance_fund_claim_completed
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_maintenance_fund_claim_lodged_with_hud' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_maintenance_fund_claim_lodged_with_hud
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_rebate_status' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_rebate_status
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_appropriately_reason' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_tenancy_appropriately_reason
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_tenancy_appropriately_status' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_tenancy_appropriately_status
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_writeoff_required' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_writeoff_required
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_lease_agreement_by_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_lease_agreement_by_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_manager_mobile' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_manager_mobile
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_void_checklist' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_void_checklist
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_void_category_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_void_category_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_description' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_description
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_transaction_balance_total
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_transaction_balance_total_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_transaction_balance_total_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_approved_sng_cap' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_approved_sng_cap
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_chintaro_bond_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_chintaro_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_bond_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_expected_bond_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_in_hand' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_in_hand
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_market_rent' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_market_rent
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_newest_rent_update' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_newest_rent_update
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_refund_required' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_refund_required
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_rent_owes_at_expected_vacate_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_rent_owes_at_expected_vacate_date
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_other_amenities' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_total_other_amenities
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_rent_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_total_rent_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_rent_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_total_rent_amount_base
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_tenant_liability_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_total_tenant_liability_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_total_utilities_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_total_utilities_amount
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_mobile' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_mobile
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact1_relationship' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_emergency_contact1_relationship
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_parent_contact_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_parent_contact_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_exit_comment' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_exit_comment
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_no_bedrooms_exited_to' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_no_bedrooms_exited_to
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_risks_list' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_risks_list
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_step_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_step_name
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_timezone_rule_version_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_timezone_rule_version_number
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_comments' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_bond_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_chintaro_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_chintaro_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_comments' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_comments
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_comment_to_finance' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_comment_to_finance
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_comment1' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_comment1
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_comment2' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_comment2
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_emergency_contact_email' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_emergency_contact_email
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_relative_url' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_relative_url
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_capture_proposal_feedback_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_capture_proposal_feedback_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_complete_final_proposal_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_complete_final_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_complete_internal_review_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_complete_internal_review_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_confirm_interest_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_confirm_interest_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_crba8_navigator_notified_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_crba8_navigator_notified_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_decision_maker_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_decision_maker_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_develop_proposal_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_develop_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_evaluate_fit_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_evaluate_fit_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_file_debrief_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_file_debrief_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_competitors_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_identify_competitors_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_customer_contacts_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_identify_customer_contacts_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_identify_pursuit_team_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_identify_pursuit_team_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_is_revenue_system_calculated_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_is_revenue_system_calculated_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_activate_tenancy_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_activate_tenancy_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_interpretor_required_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_interpretor_required_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_partnership_arrangement_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_partnership_arrangement_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_keys_received_from_tenant_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_keys_received_from_tenant_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_potential_risk_to_staff_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_potential_risk_to_staff_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_participates_in_workflow_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_participates_in_workflow_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_present_final_proposal_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_present_final_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_present_proposal_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_present_proposal_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_pursuit_decision_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_pursuit_decision_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_resolve_feedback_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_resolve_feedback_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_send_thankyou_note_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_send_thankyou_note_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_guarantee_information_provided_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_bond_guarantee_information_provided_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_information_entered_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_bond_information_entered_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_loan_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_bond_loan_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_bond_lodgement_complete_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_bond_lodgement_complete_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_checked_other_tenancies_with_balances_due_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_checked_other_tenancies_with_balances_due_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_check_that_body_corporresidents_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_check_that_body_corporresidents_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_consent_to_hold_personal_information_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_consent_to_hold_personal_information_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_payment_date_correct_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_expected_payment_date_correct_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_expected_payment_day_checkbox_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_expected_payment_day_checkbox_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_familiar_with_supports_neighbours_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_familiar_with_supports_neighbours_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_first_inspection_scheduled_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_first_inspection_scheduled_flag
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenancy_followed_market_rent_review_in_bos_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_tenancy'))
ALTER TABLE staging.ODSETLdim_property_tenancy DROP COLUMN property_tenancy_followed_market_rent_review_in_bos_flag
GO

/**********************************************************************************************************
Script: 12210_Remove_dim_property_columns.sql
Purpose: Remove 213 redundant columns from dim_property table per work item 12210
Author: GitHub Copilot
Date: 2026-02-20
Notes: Removes columns from edw, landing, and staging schemas
**********************************************************************************************************/

-- Drop property_access_control_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_access_control_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_access_control_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_access_control_flag]
GO

-- Drop property_access_control_agent
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_agent' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_access_control_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_agent' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_access_control_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_agent' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_access_control_agent]
GO

-- Drop property_access_control_no_of_doors
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_no_of_doors' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_access_control_no_of_doors]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_no_of_doors' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_access_control_no_of_doors]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_no_of_doors' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_access_control_no_of_doors]
GO

-- Drop property_access_control_type
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_type' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_access_control_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_type' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_access_control_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_access_control_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_access_control_type]
GO

-- Drop property_age_of_ceiling_insulation_if_known1
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_age_of_ceiling_insulation_if_known1' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_age_of_ceiling_insulation_if_known1]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_age_of_ceiling_insulation_if_known1' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_age_of_ceiling_insulation_if_known1]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_age_of_ceiling_insulation_if_known1' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_age_of_ceiling_insulation_if_known1]
GO

-- Drop property_age_of_underfloor_insulation_if_known1
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_age_of_underfloor_insulation_if_known1' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_age_of_underfloor_insulation_if_known1]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_age_of_underfloor_insulation_if_known1' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_age_of_underfloor_insulation_if_known1]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_age_of_underfloor_insulation_if_known1' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_age_of_underfloor_insulation_if_known1]
GO

-- Drop property_agreed_rent_review_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_agreed_rent_review_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_agreed_rent_review_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_agreed_rent_review_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_agreed_rent_review_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_agreed_rent_review_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_agreed_rent_review_date]
GO

-- Drop property_any_other_details_about_the_type_or_condition_if_known
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_any_other_details_about_the_type_or_condition_if_known' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_any_other_details_about_the_type_or_condition_if_known]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_any_other_details_about_the_type_or_condition_if_known' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_any_other_details_about_the_type_or_condition_if_known]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_any_other_details_about_the_type_or_condition_if_known' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_any_other_details_about_the_type_or_condition_if_known]
GO

-- Drop property_asbestos_is_present_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_asbestos_is_present_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_asbestos_is_present_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_asbestos_is_present_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_asbestos_is_present_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_asbestos_is_present_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_asbestos_is_present_flag]
GO

-- Drop property_assessment_number
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_assessment_number' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_assessment_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_assessment_number' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_assessment_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_assessment_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_assessment_number]
GO

-- Drop property_assigned_tenancy_manager
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_assigned_tenancy_manager' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_assigned_tenancy_manager]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_assigned_tenancy_manager' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_assigned_tenancy_manager]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_assigned_tenancy_manager' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_assigned_tenancy_manager]
GO

-- Drop property_backflow_preventor_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_backflow_preventor_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_backflow_preventor_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_backflow_preventor_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_backflow_preventor_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_backflow_preventor_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_backflow_preventor_flag]
GO

-- Drop property_bedroom_keys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bedroom_keys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bedroom_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bedroom_keys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bedroom_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bedroom_keys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bedroom_keys]
GO

-- Drop property_body_corp_contact_person
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_body_corp_contact_person' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_body_corp_contact_person]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_body_corp_contact_person' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_body_corp_contact_person]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_body_corp_contact_person' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_body_corp_contact_person]
GO

-- Drop property_body_corporate_name
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_body_corporate_name' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_body_corporate_name]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_body_corporate_name' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_body_corporate_name]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_body_corporate_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_body_corporate_name]
GO

-- Drop property_bond_amount
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_amount' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bond_amount]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_amount' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bond_amount]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bond_amount]
GO

-- Drop property_bond_amount_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_amount_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bond_amount_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bond_amount_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bond_amount_base]
GO

-- Drop property_bond_comment
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_comment' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bond_comment]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_comment' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bond_comment]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_comment' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bond_comment]
GO

-- Drop property_bond_lodged
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_lodged' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bond_lodged]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_lodged' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bond_lodged]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_lodged' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bond_lodged]
GO

-- Drop property_bond_reference
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_reference' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bond_reference]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_reference' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bond_reference]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bond_reference' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bond_reference]
GO

-- Drop property_borrowed_amount_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_borrowed_amount_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_borrowed_amount_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_borrowed_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_borrowed_amount_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_borrowed_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_borrowed_amount_base]
GO

-- Drop property_building_warrant_of_fitness_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_building_warrant_of_fitness_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_building_warrant_of_fitness_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_building_warrant_of_fitness_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_building_warrant_of_fitness_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_building_warrant_of_fitness_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_building_warrant_of_fitness_date]
GO

-- Drop property_building_warrant_of_fitness_details
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_building_warrant_of_fitness_details' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_building_warrant_of_fitness_details]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_building_warrant_of_fitness_details' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_building_warrant_of_fitness_details]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_building_warrant_of_fitness_details' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_building_warrant_of_fitness_details]
GO

-- Drop property_business_phone_owner
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_business_phone_owner' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_business_phone_owner]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_business_phone_owner' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_business_phone_owner]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_business_phone_owner' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_business_phone_owner]
GO

-- Drop property_bwof_date_obtained
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bwof_date_obtained' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bwof_date_obtained]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bwof_date_obtained' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bwof_date_obtained]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bwof_date_obtained' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bwof_date_obtained]
GO

-- Drop property_bwof_exists_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bwof_exists_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_bwof_exists_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bwof_exists_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_bwof_exists_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_bwof_exists_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_bwof_exists_flag]
GO

-- Drop property_ceiling_insulation_location_coverage
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_location_coverage' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_ceiling_insulation_location_coverage]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_location_coverage' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_ceiling_insulation_location_coverage]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_location_coverage' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_ceiling_insulation_location_coverage]
GO

-- Drop property_ceiling_insulation_standard
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_standard' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_ceiling_insulation_standard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_standard' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_ceiling_insulation_standard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_standard' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_ceiling_insulation_standard]
GO

-- Drop property_ceiling_insulation_status_ifno
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_status_ifno' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_ceiling_insulation_status_ifno]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_status_ifno' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_ceiling_insulation_status_ifno]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_status_ifno' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_ceiling_insulation_status_ifno]
GO

-- Drop property_ceiling_insulation_type_other
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_type_other' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_ceiling_insulation_type_other]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_type_other' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_ceiling_insulation_type_other]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_ceiling_insulation_type_other' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_ceiling_insulation_type_other]
GO

-- Drop property_chintaro_id
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_chintaro_id' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_chintaro_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_chintaro_id' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_chintaro_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_chintaro_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_chintaro_id]
GO

-- Drop property_comments
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_comments]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_comments]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_comments]
GO

-- Drop property_comments_for_vacant_property_report
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_for_vacant_property_report' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_comments_for_vacant_property_report]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_for_vacant_property_report' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_comments_for_vacant_property_report]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_for_vacant_property_report' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_comments_for_vacant_property_report]
GO

-- Drop property_comments_general
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_general' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_comments_general]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_general' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_comments_general]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_general' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_comments_general]
GO

-- Drop property_comments_keys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_keys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_comments_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_keys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_comments_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_keys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_comments_keys]
GO

-- Drop property_comments_other
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_other' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_comments_other]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_other' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_comments_other]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_comments_other' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_comments_other]
GO

-- Drop property_compliance_schedule_applicable_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_compliance_schedule_applicable_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_compliance_schedule_applicable_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_compliance_schedule_applicable_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_compliance_schedule_applicable_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_compliance_schedule_applicable_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_compliance_schedule_applicable_flag]
GO

-- Drop property_compliance_schedule_references
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_compliance_schedule_references' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_compliance_schedule_references]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_compliance_schedule_references' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_compliance_schedule_references]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_compliance_schedule_references' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_compliance_schedule_references]
GO

-- Drop property_concatenated_address
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_concatenated_address' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_concatenated_address]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_concatenated_address' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_concatenated_address]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_concatenated_address' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_concatenated_address]
GO

-- Drop property_cost_centre
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_cost_centre' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_cost_centre]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_cost_centre' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_cost_centre]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_cost_centre' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_cost_centre]
GO

-- Drop property_country
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_country' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_country]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_country' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_country]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_country' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_country]
GO

-- Drop property_crba8_gas_meter_location
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_gas_meter_location' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_crba8_gas_meter_location]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_gas_meter_location' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_crba8_gas_meter_location]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_gas_meter_location' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_crba8_gas_meter_location]
GO

-- Drop property_crba8_number_of_levels
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_number_of_levels' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_crba8_number_of_levels]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_number_of_levels' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_crba8_number_of_levels]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_number_of_levels' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_crba8_number_of_levels]
GO

-- Drop property_crba8_property_agent
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_property_agent' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_crba8_property_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_property_agent' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_crba8_property_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_property_agent' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_crba8_property_agent]
GO

-- Drop property_crba8_property_agent_contact
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_property_agent_contact' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_crba8_property_agent_contact]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_property_agent_contact' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_crba8_property_agent_contact]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_crba8_property_agent_contact' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_crba8_property_agent_contact]
GO

-- Drop property_created_by
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_by' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_created_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_by' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_created_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_by' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_created_by]
GO

-- Drop property_created_on
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_on' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_created_on]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_on' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_created_on]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_on' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_created_on]
GO

-- Drop property_created_on_behalf_by
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_on_behalf_by' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_created_on_behalf_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_on_behalf_by' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_created_on_behalf_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_created_on_behalf_by' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_created_on_behalf_by]
GO

-- Drop property_current_iqp
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_current_iqp' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_current_iqp]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_current_iqp' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_current_iqp]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_current_iqp' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_current_iqp]
GO

-- Drop property_date_insulation_was_last_upgraded
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_last_upgraded' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_date_insulation_was_last_upgraded]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_last_upgraded' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_date_insulation_was_last_upgraded]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_last_upgraded' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_date_insulation_was_last_upgraded]
GO

-- Drop property_date_insulation_was_last_upgraded_na_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_last_upgraded_na_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_date_insulation_was_last_upgraded_na_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_last_upgraded_na_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_date_insulation_was_last_upgraded_na_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_last_upgraded_na_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_date_insulation_was_last_upgraded_na_flag]
GO

-- Drop property_date_insulation_was_professionally_assessed
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_professionally_assessed' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_date_insulation_was_professionally_assessed]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_professionally_assessed' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_date_insulation_was_professionally_assessed]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_professionally_assessed' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_date_insulation_was_professionally_assessed]
GO

-- Drop property_date_insulation_was_professionally_assessed_na_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_professionally_assessed_na_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_date_insulation_was_professionally_assessed_na_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_professionally_assessed_na_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_date_insulation_was_professionally_assessed_na_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_insulation_was_professionally_assessed_na_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_date_insulation_was_professionally_assessed_na_flag]
GO

-- Drop property_date_next_bwof_due
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_next_bwof_due' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_date_next_bwof_due]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_next_bwof_due' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_date_next_bwof_due]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_next_bwof_due' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_date_next_bwof_due]
GO

-- Drop property_date_next_bwof_due_text
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_next_bwof_due_text' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_date_next_bwof_due_text]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_next_bwof_due_text' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_date_next_bwof_due_text]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_date_next_bwof_due_text' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_date_next_bwof_due_text]
GO

-- Drop property_deaf_smoke_alarms_indicator
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_deaf_smoke_alarms_indicator' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_deaf_smoke_alarms_indicator]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_deaf_smoke_alarms_indicator' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_deaf_smoke_alarms_indicator]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_deaf_smoke_alarms_indicator' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_deaf_smoke_alarms_indicator]
GO

-- Drop property_delete_textdemo
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_delete_textdemo' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_delete_textdemo]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_delete_textdemo' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_delete_textdemo]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_delete_textdemo' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_delete_textdemo]
GO

-- Drop property_delete_urldemo
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_delete_urldemo' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_delete_urldemo]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_delete_urldemo' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_delete_urldemo]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_delete_urldemo' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_delete_urldemo]
GO

-- Drop property_do_we_have_allocation_rights_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_do_we_have_allocation_rights_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_do_we_have_allocation_rights_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_do_we_have_allocation_rights_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_do_we_have_allocation_rights_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_do_we_have_allocation_rights_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_do_we_have_allocation_rights_flag]
GO

-- Drop property_eadivision
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_eadivision' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_eadivision]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_eadivision' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_eadivision]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_eadivision' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_eadivision]
GO

-- Drop property_emergency_lighting_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_emergency_lighting_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_emergency_lighting_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_emergency_lighting_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_emergency_lighting_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_emergency_lighting_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_emergency_lighting_flag]
GO

-- Drop property_exchange_rate
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_exchange_rate' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_exchange_rate]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_exchange_rate' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_exchange_rate]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_exchange_rate' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_exchange_rate]
GO

-- Drop property_fire_alarms_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_alarms_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_fire_alarms_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_alarms_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_fire_alarms_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_alarms_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_fire_alarms_flag]
GO

-- Drop property_fire_blanket_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_blanket_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_fire_blanket_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_blanket_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_fire_blanket_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_blanket_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_fire_blanket_flag]
GO

-- Drop property_fire_evacuation
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_fire_evacuation]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_fire_evacuation]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_fire_evacuation]
GO

-- Drop property_fire_evacuation_registration_number
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation_registration_number' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_fire_evacuation_registration_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation_registration_number' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_fire_evacuation_registration_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation_registration_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_fire_evacuation_registration_number]
GO

-- Drop property_fire_evacuation_trial_frequency
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation_trial_frequency' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_fire_evacuation_trial_frequency]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation_trial_frequency' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_fire_evacuation_trial_frequency]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_evacuation_trial_frequency' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_fire_evacuation_trial_frequency]
GO

-- Drop property_fire_extinguisher_responsibility
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_extinguisher_responsibility' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_fire_extinguisher_responsibility]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_extinguisher_responsibility' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_fire_extinguisher_responsibility]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fire_extinguisher_responsibility' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_fire_extinguisher_responsibility]
GO

-- Drop property_frequency
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_frequency' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_frequency]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_frequency' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_frequency]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_frequency' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_frequency]
GO

-- Drop property_fridgekeys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fridgekeys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_fridgekeys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fridgekeys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_fridgekeys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_fridgekeys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_fridgekeys]
GO

-- Drop property_funding
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_funding' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_funding]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_funding' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_funding]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_funding' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_funding]
GO

-- Drop property_gate_code
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_gate_code' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_gate_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_gate_code' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_gate_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_gate_code' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_gate_code]
GO

-- Drop property_gate_remote
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_gate_remote' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_gate_remote]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_gate_remote' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_gate_remote]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_gate_remote' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_gate_remote]
GO

-- Drop property_habitat_property_ref
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_habitat_property_ref' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_habitat_property_ref]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_habitat_property_ref' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_habitat_property_ref]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_habitat_property_ref' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_habitat_property_ref]
GO

-- Drop property_hazard_list
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hazard_list' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_hazard_list]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hazard_list' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_hazard_list]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hazard_list' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_hazard_list]
GO

-- Drop property_hazone
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hazone' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_hazone]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hazone' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_hazone]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hazone' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_hazone]
GO

-- Drop property_head_contractor
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_head_contractor' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_head_contractor]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_head_contractor' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_head_contractor]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_head_contractor' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_head_contractor]
GO

-- Drop property_head_lease_exp_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_head_lease_exp_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_head_lease_exp_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_head_lease_exp_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_head_lease_exp_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_head_lease_exp_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_head_lease_exp_date]
GO

-- Drop property_heat_detectors_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_heat_detectors_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_heat_detectors_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_heat_detectors_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_heat_detectors_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_heat_detectors_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_heat_detectors_flag]
GO

-- Drop property_heating_type_1
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_heating_type_1' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_heating_type_1]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_heating_type_1' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_heating_type_1]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_heating_type_1' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_heating_type_1]
GO

-- Drop property_housing_first_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_housing_first_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_housing_first_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_housing_first_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_housing_first_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_housing_first_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_housing_first_flag]
GO

-- Drop property_hud_contract_number
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hud_contract_number' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_hud_contract_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hud_contract_number' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_hud_contract_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_hud_contract_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_hud_contract_number]
GO

-- Drop property_if_partial_specify_areas_not_insulated
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_if_partial_specify_areas_not_insulated' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_if_partial_specify_areas_not_insulated]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_if_partial_specify_areas_not_insulated' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_if_partial_specify_areas_not_insulated]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_if_partial_specify_areas_not_insulated' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_if_partial_specify_areas_not_insulated]
GO

-- Drop property_image_id
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_id' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_image_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_id' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_image_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_image_id]
GO

-- Drop property_image_timestamp
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_timestamp' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_image_timestamp]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_timestamp' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_image_timestamp]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_timestamp' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_image_timestamp]
GO

-- Drop property_image_url
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_url' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_image_url]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_url' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_image_url]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_image_url' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_image_url]
GO

-- Drop property_import_sequence_number
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_import_sequence_number' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_import_sequence_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_import_sequence_number' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_import_sequence_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_import_sequence_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_import_sequence_number]
GO

-- Drop property_inhand
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_inhand' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_inhand]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_inhand' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_inhand]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_inhand' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_inhand]
GO

-- Drop property_inhand_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_inhand_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_inhand_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_inhand_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_inhand_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_inhand_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_inhand_base]
GO

-- Drop property_input_taxed_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_input_taxed_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_input_taxed_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_input_taxed_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_input_taxed_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_input_taxed_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_input_taxed_flag]
GO

-- Drop property_insulation_ceiling_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_ceiling_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_insulation_ceiling_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_ceiling_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_insulation_ceiling_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_ceiling_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_insulation_ceiling_date]
GO

-- Drop property_insulation_in_wall_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_in_wall_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_insulation_in_wall_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_in_wall_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_insulation_in_wall_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_in_wall_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_insulation_in_wall_date]
GO

-- Drop property_insulation_in_wall_type
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_in_wall_type' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_insulation_in_wall_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_in_wall_type' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_insulation_in_wall_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_in_wall_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_insulation_in_wall_type]
GO

-- Drop property_insulation_is_in_at_least_a_reasonable_condition
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_is_in_at_least_a_reasonable_condition' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_insulation_is_in_at_least_a_reasonable_condition]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_is_in_at_least_a_reasonable_condition' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_insulation_is_in_at_least_a_reasonable_condition]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_is_in_at_least_a_reasonable_condition' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_insulation_is_in_at_least_a_reasonable_condition]
GO

-- Drop property_insulation_is_in_at_least_a_reasonable_underflr
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_is_in_at_least_a_reasonable_underflr' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_insulation_is_in_at_least_a_reasonable_underflr]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_is_in_at_least_a_reasonable_underflr' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_insulation_is_in_at_least_a_reasonable_underflr]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_is_in_at_least_a_reasonable_underflr' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_insulation_is_in_at_least_a_reasonable_underflr]
GO

-- Drop property_insulation_under_floor_type
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_under_floor_type' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_insulation_under_floor_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_under_floor_type' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_insulation_under_floor_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_under_floor_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_insulation_under_floor_type]
GO

-- Drop property_insulation_underflr_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_underflr_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_insulation_underflr_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_underflr_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_insulation_underflr_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_insulation_underflr_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_insulation_underflr_date]
GO

-- Drop property_intended_disposal_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_intended_disposal_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_intended_disposal_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_intended_disposal_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_intended_disposal_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_intended_disposal_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_intended_disposal_date]
GO

-- Drop property_irrs_balance
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_balance' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_irrs_balance]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_balance' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_irrs_balance]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_balance' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_irrs_balance]
GO

-- Drop property_irrs_balance_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_balance_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_irrs_balance_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_balance_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_irrs_balance_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_balance_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_irrs_balance_base]
GO

-- Drop property_irrs_charged_to
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_charged_to' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_irrs_charged_to]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_charged_to' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_irrs_charged_to]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_charged_to' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_irrs_charged_to]
GO

-- Drop property_irrs_paid_to
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_paid_to' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_irrs_paid_to]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_paid_to' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_irrs_paid_to]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_irrs_paid_to' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_irrs_paid_to]
GO

-- Drop property_is_delete_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_delete_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_is_delete_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_delete_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_is_delete_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_delete_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_is_delete_flag]
GO

-- Drop property_is_ip
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_ip' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_is_ip]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_ip' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_is_ip]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_ip' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_is_ip]
GO

-- Drop property_is_there_enough_heating_capacity_in_the_property
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_there_enough_heating_capacity_in_the_property' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_is_there_enough_heating_capacity_in_the_property]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_there_enough_heating_capacity_in_the_property' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_is_there_enough_heating_capacity_in_the_property]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_there_enough_heating_capacity_in_the_property' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_is_there_enough_heating_capacity_in_the_property]
GO

-- Drop property_is_this_tenancy_appropriately_housed_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_this_tenancy_appropriately_housed_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_is_this_tenancy_appropriately_housed_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_this_tenancy_appropriately_housed_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_is_this_tenancy_appropriately_housed_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_is_this_tenancy_appropriately_housed_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_is_this_tenancy_appropriately_housed_flag]
GO

-- Drop property_key_status
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_key_status' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_key_status]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_key_status' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_key_status]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_key_status' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_key_status]
GO

-- Drop property_kitchen_cupboard_keys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_kitchen_cupboard_keys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_kitchen_cupboard_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_kitchen_cupboard_keys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_kitchen_cupboard_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_kitchen_cupboard_keys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_kitchen_cupboard_keys]
GO

-- Drop property_land_area
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_land_area' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_land_area]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_land_area' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_land_area]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_land_area' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_land_area]
GO

-- Drop property_land_information
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_land_information' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_land_information]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_land_information' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_land_information]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_land_information' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_land_information]
GO

-- Drop property_landlord_handback
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_landlord_handback' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_landlord_handback]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_landlord_handback' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_landlord_handback]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_landlord_handback' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_landlord_handback]
GO

-- Drop property_last_valuation_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_last_valuation_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_last_valuation_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_last_valuation_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_last_valuation_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_last_valuation_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_last_valuation_base]
GO

-- Drop property_lease_end_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_lease_end_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_lease_end_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_lease_end_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_lease_end_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_lease_end_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_lease_end_date]
GO

-- Drop property_legacy_id
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_legacy_id' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_legacy_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_legacy_id' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_legacy_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_legacy_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_legacy_id]
GO

-- Drop property_letter_box_keys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_letter_box_keys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_letter_box_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_letter_box_keys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_letter_box_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_letter_box_keys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_letter_box_keys]
GO

-- Drop property_main_door_keys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_main_door_keys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_main_door_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_main_door_keys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_main_door_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_main_door_keys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_main_door_keys]
GO

-- Drop property_main_gate_keys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_main_gate_keys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_main_gate_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_main_gate_keys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_main_gate_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_main_gate_keys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_main_gate_keys]
GO

-- Drop property_maintenance_responsible
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_maintenance_responsible' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_maintenance_responsible]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_maintenance_responsible' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_maintenance_responsible]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_maintenance_responsible' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_maintenance_responsible]
GO

-- Drop property_market_rent
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_market_rent' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_market_rent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_market_rent' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_market_rent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_market_rent' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_market_rent]
GO

-- Drop property_market_rent_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_market_rent_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_market_rent_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_market_rent_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_market_rent_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_market_rent_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_market_rent_base]
GO

-- Drop property_master_key_id
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_master_key_id' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_master_key_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_master_key_id' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_master_key_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_master_key_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_master_key_id]
GO

-- Drop property_mcps_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mcps_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_mcps_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mcps_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_mcps_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mcps_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_mcps_flag]
GO

-- Drop property_mechanical_ventilation_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mechanical_ventilation_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_mechanical_ventilation_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mechanical_ventilation_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_mechanical_ventilation_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mechanical_ventilation_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_mechanical_ventilation_flag]
GO

-- Drop property_meshblock
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meshblock' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_meshblock]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meshblock' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_meshblock]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meshblock' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_meshblock]
GO

-- Drop property_meth_status
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_meth_status]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_meth_status]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_meth_status]
GO

-- Drop property_meth_status_evidence
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status_evidence' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_meth_status_evidence]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status_evidence' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_meth_status_evidence]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status_evidence' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_meth_status_evidence]
GO

-- Drop property_meth_status_on_entry
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status_on_entry' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_meth_status_on_entry]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status_on_entry' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_meth_status_on_entry]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_status_on_entry' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_meth_status_on_entry]
GO

-- Drop property_meth_test_type
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_test_type' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_meth_test_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_test_type' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_meth_test_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_meth_test_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_meth_test_type]
GO

-- Drop property_minimum_thickness_mm
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_mm' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_minimum_thickness_mm]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_mm' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_minimum_thickness_mm]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_mm' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_minimum_thickness_mm]
GO

-- Drop property_minimum_thickness_na_for_foil
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_na_for_foil' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_minimum_thickness_na_for_foil]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_na_for_foil' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_minimum_thickness_na_for_foil]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_na_for_foil' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_minimum_thickness_na_for_foil]
GO

-- Drop property_minimum_thickness_na_for_foil_mm
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_na_for_foil_mm' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_minimum_thickness_na_for_foil_mm]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_na_for_foil_mm' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_minimum_thickness_na_for_foil_mm]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_minimum_thickness_na_for_foil_mm' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_minimum_thickness_na_for_foil_mm]
GO

-- Drop property_modified_by
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_by' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_modified_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_by' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_modified_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_by' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_modified_by]
GO

-- Drop property_modified_on
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_on' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_modified_on]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_on' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_modified_on]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_on' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_modified_on]
GO

-- Drop property_modified_on_behalf_by
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_on_behalf_by' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_modified_on_behalf_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_on_behalf_by' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_modified_on_behalf_by]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_modified_on_behalf_by' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_modified_on_behalf_by]
GO

-- Drop property_monitoring_agent
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_monitoring_agent' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_monitoring_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_monitoring_agent' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_monitoring_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_monitoring_agent' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_monitoring_agent]
GO

-- Drop property_mortgaged_amount_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mortgaged_amount_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_mortgaged_amount_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mortgaged_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_mortgaged_amount_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_mortgaged_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_mortgaged_amount_base]
GO

-- Drop property_no_of_bathrooms
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_bathrooms' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_no_of_bathrooms]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_bathrooms' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_no_of_bathrooms]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_bathrooms' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_no_of_bathrooms]
GO

-- Drop property_no_of_fire_extinguishers
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_fire_extinguishers' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_no_of_fire_extinguishers]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_fire_extinguishers' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_no_of_fire_extinguishers]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_fire_extinguishers' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_no_of_fire_extinguishers]
GO

-- Drop property_no_of_rcds
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_rcds' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_no_of_rcds]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_rcds' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_no_of_rcds]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_rcds' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_no_of_rcds]
GO

-- Drop property_no_of_smoke_alarms
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_smoke_alarms' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_no_of_smoke_alarms]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_smoke_alarms' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_no_of_smoke_alarms]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_no_of_smoke_alarms' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_no_of_smoke_alarms]
GO

-- Drop property_nras_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_nras_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_nras_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_nras_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_nras_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_nras_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_nras_date]
GO

-- Drop property_nras_dwelling_id
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_nras_dwelling_id' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_nras_dwelling_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_nras_dwelling_id' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_nras_dwelling_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_nras_dwelling_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_nras_dwelling_id]
GO

-- Drop property_old_id
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_old_id' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_old_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_old_id' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_old_id]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_old_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_old_id]
GO

-- Drop property_or_minimum_thickness
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_or_minimum_thickness' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_or_minimum_thickness]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_or_minimum_thickness' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_or_minimum_thickness]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_or_minimum_thickness' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_or_minimum_thickness]
GO

-- Drop property_other_access_comments
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_other_access_comments' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_other_access_comments]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_other_access_comments' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_other_access_comments]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_other_access_comments' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_other_access_comments]
GO

-- Drop property_overall_target_target
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_overall_target_target' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_overall_target_target]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_overall_target_target' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_overall_target_target]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_overall_target_target' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_overall_target_target]
GO

-- Drop property_overridden_created_on
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_overridden_created_on' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_overridden_created_on]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_overridden_created_on' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_overridden_created_on]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_overridden_created_on' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_overridden_created_on]
GO

-- Drop property_owner
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owner' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_owner]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owner' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_owner]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owner' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_owner]
GO

-- Drop property_owning_business_unit
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_business_unit' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_owning_business_unit]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_business_unit' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_owning_business_unit]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_business_unit' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_owning_business_unit]
GO

-- Drop property_owning_team
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_team' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_owning_team]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_team' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_owning_team]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_team' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_owning_team]
GO

-- Drop property_owning_user
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_user' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_owning_user]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_user' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_owning_user]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_owning_user' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_owning_user]
GO

-- Drop property_paint_colour
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_paint_colour' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_paint_colour]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_paint_colour' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_paint_colour]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_paint_colour' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_paint_colour]
GO

-- Drop property_paint_manufacturer
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_paint_manufacturer' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_paint_manufacturer]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_paint_manufacturer' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_paint_manufacturer]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_paint_manufacturer' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_paint_manufacturer]
GO

-- Drop property_partial_specify_areas_not_insulated_underflr
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_partial_specify_areas_not_insulated_underflr' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_partial_specify_areas_not_insulated_underflr]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_partial_specify_areas_not_insulated_underflr' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_partial_specify_areas_not_insulated_underflr]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_partial_specify_areas_not_insulated_underflr' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_partial_specify_areas_not_insulated_underflr]
GO

-- Drop property_partial_specify_areas_not_insulated_wall
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_partial_specify_areas_not_insulated_wall' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_partial_specify_areas_not_insulated_wall]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_partial_specify_areas_not_insulated_wall' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_partial_specify_areas_not_insulated_wall]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_partial_specify_areas_not_insulated_wall' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_partial_specify_areas_not_insulated_wall]
GO

-- Drop property_passenger_lift_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_passenger_lift_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_passenger_lift_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_passenger_lift_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_passenger_lift_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_passenger_lift_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_passenger_lift_flag]
GO

-- Drop property_previous_contamination_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_contamination_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_previous_contamination_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_contamination_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_previous_contamination_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_contamination_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_previous_contamination_flag]
GO

-- Drop property_previous_contamination_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_contamination_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_previous_contamination_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_contamination_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_previous_contamination_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_contamination_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_previous_contamination_date]
GO

-- Drop property_previous_status
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_status' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_previous_status]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_status' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_previous_status]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_previous_status' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_previous_status]
GO

-- Drop property_primary_contractor
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_primary_contractor' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_primary_contractor]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_primary_contractor' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_primary_contractor]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_primary_contractor' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_primary_contractor]
GO

-- Drop property_property_age
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_age' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_property_age]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_age' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_property_age]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_age' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_property_age]
GO

-- Drop property_property_classification
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_classification' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_property_classification]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_classification' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_property_classification]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_classification' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_property_classification]
GO

-- Drop property_property_service_name
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_service_name' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_property_service_name]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_service_name' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_property_service_name]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_service_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_property_service_name]
GO

-- Drop property_property_service_code
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_service_code' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_property_service_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_service_code' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_property_service_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_property_service_code' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_property_service_code]
GO

-- Drop property_refund_lodged
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_refund_lodged' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_refund_lodged]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_refund_lodged' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_refund_lodged]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_refund_lodged' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_refund_lodged]
GO

-- Drop property_relative_url
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_relative_url' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_relative_url]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_relative_url' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_relative_url]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_relative_url' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_relative_url]
GO

-- Drop property_rescinded_disposal_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_rescinded_disposal_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_rescinded_disposal_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_rescinded_disposal_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_rescinded_disposal_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_rescinded_disposal_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_rescinded_disposal_date]
GO

-- Drop property_resource_consent_applicable_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_resource_consent_applicable_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_resource_consent_applicable_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_resource_consent_applicable_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_resource_consent_applicable_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_resource_consent_applicable_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_resource_consent_applicable_flag]
GO

-- Drop property_resource_consent_references
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_resource_consent_references' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_resource_consent_references]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_resource_consent_references' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_resource_consent_references]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_resource_consent_references' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_resource_consent_references]
GO

-- Drop property_responsible_for_maintenance
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_responsible_for_maintenance' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_responsible_for_maintenance]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_responsible_for_maintenance' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_responsible_for_maintenance]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_responsible_for_maintenance' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_responsible_for_maintenance]
GO

-- Drop property_rubbish_collection_agency
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_rubbish_collection_agency' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_rubbish_collection_agency]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_rubbish_collection_agency' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_rubbish_collection_agency]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_rubbish_collection_agency' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_rubbish_collection_agency]
GO

-- Drop property_security_gate
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_gate' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_security_gate]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_gate' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_security_gate]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_gate' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_security_gate]
GO

-- Drop property_security_system_agent
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_system_agent' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_security_system_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_system_agent' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_security_system_agent]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_system_agent' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_security_system_agent]
GO

-- Drop property_security_system_type
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_system_type' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_security_system_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_system_type' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_security_system_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_security_system_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_security_system_type]
GO

-- Drop property_service_agents_vendor
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_service_agents_vendor' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_service_agents_vendor]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_service_agents_vendor' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_service_agents_vendor]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_service_agents_vendor' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_service_agents_vendor]
GO

-- Drop property_smoke_detector_type
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_detector_type' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_smoke_detector_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_detector_type' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_smoke_detector_type]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_detector_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_smoke_detector_type]
GO

-- Drop property_smoke_detectors
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_detectors' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_smoke_detectors]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_detectors' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_smoke_detectors]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_detectors' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_smoke_detectors]
GO

-- Drop property_smoke_stop_doors_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_stop_doors_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_smoke_stop_doors_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_stop_doors_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_smoke_stop_doors_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_smoke_stop_doors_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_smoke_stop_doors_flag]
GO

-- Drop property_specify_reason_for_inaccessibility
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_specify_reason_for_inaccessibility' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_specify_reason_for_inaccessibility]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_specify_reason_for_inaccessibility' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_specify_reason_for_inaccessibility]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_specify_reason_for_inaccessibility' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_specify_reason_for_inaccessibility]
GO

-- Drop property_specify_reason_for_inaccessibility_underflr
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_specify_reason_for_inaccessibility_underflr' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_specify_reason_for_inaccessibility_underflr]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_specify_reason_for_inaccessibility_underflr' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_specify_reason_for_inaccessibility_underflr]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_specify_reason_for_inaccessibility_underflr' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_specify_reason_for_inaccessibility_underflr]
GO

-- Drop property_sprinklers_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_sprinklers_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_sprinklers_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_sprinklers_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_sprinklers_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_sprinklers_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_sprinklers_flag]
GO

-- Drop property_strata_company
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_strata_company' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_strata_company]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_strata_company' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_strata_company]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_strata_company' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_strata_company]
GO

-- Drop property_swipecard
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_swipecard' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_swipecard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_swipecard' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_swipecard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_swipecard' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_swipecard]
GO

-- Drop property_tenure
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenure' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_tenure]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenure' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_tenure]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_tenure' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_tenure]
GO

-- Drop property_timezone_rule_version_number
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_timezone_rule_version_number' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_timezone_rule_version_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_timezone_rule_version_number' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_timezone_rule_version_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_timezone_rule_version_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_timezone_rule_version_number]
GO

-- Drop property_transaction_currency_id_name
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_transaction_currency_id_name' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_transaction_currency_id_name]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_transaction_currency_id_name' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_transaction_currency_id_name]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_transaction_currency_id_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_transaction_currency_id_name]
GO

-- Drop property_under_insulation_bulk_insulation_valuer_value
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_under_insulation_bulk_insulation_valuer_value' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_under_insulation_bulk_insulation_valuer_value]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_under_insulation_bulk_insulation_valuer_value' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_under_insulation_bulk_insulation_valuer_value]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_under_insulation_bulk_insulation_valuer_value' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_under_insulation_bulk_insulation_valuer_value]
GO

-- Drop property_under_main_agreement_flag
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_under_main_agreement_flag' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_under_main_agreement_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_under_main_agreement_flag' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_under_main_agreement_flag]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_under_main_agreement_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_under_main_agreement_flag]
GO

-- Drop property_underfloor_insulation_standard
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_insulation_standard' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_underfloor_insulation_standard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_insulation_standard' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_underfloor_insulation_standard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_insulation_standard' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_underfloor_insulation_standard]
GO

-- Drop property_underfloor_insulation_status_ifno
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_insulation_status_ifno' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_underfloor_insulation_status_ifno]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_insulation_status_ifno' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_underfloor_insulation_status_ifno]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_insulation_status_ifno' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_underfloor_insulation_status_ifno]
GO

-- Drop property_underfloor_location_coverage
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_location_coverage' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_underfloor_location_coverage]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_location_coverage' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_underfloor_location_coverage]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_location_coverage' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_underfloor_location_coverage]
GO

-- Drop property_underfloor_other_specify
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_other_specify' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_underfloor_other_specify]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_other_specify' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_underfloor_other_specify]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_underfloor_other_specify' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_underfloor_other_specify]
GO

-- Drop property_upi
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_upi' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_upi]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_upi' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_upi]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_upi' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_upi]
GO

-- Drop property_utc_conversion_timezone_code
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utc_conversion_timezone_code' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_utc_conversion_timezone_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utc_conversion_timezone_code' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_utc_conversion_timezone_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utc_conversion_timezone_code' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_utc_conversion_timezone_code]
GO

-- Drop property_utility_room_code
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utility_room_code' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_utility_room_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utility_room_code' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_utility_room_code]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utility_room_code' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_utility_room_code]
GO

-- Drop property_utility_room_key
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utility_room_key' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_utility_room_key]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utility_room_key' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_utility_room_key]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_utility_room_key' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_utility_room_key]
GO

-- Drop property_vacant_tenantable_target
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_vacant_tenantable_target' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_vacant_tenantable_target]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_vacant_tenantable_target' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_vacant_tenantable_target]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_vacant_tenantable_target' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_vacant_tenantable_target]
GO

-- Drop property_vacant_untenantable_target
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_vacant_untenantable_target' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_vacant_untenantable_target]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_vacant_untenantable_target' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_vacant_untenantable_target]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_vacant_untenantable_target' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_vacant_untenantable_target]
GO

-- Drop property_valuation
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_valuation]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_valuation]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_valuation]
GO

-- Drop property_valuation_base
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation_base' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_valuation_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation_base' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_valuation_base]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_valuation_base]
GO

-- Drop property_valuation_roll_number
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation_roll_number' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_valuation_roll_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation_roll_number' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_valuation_roll_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_valuation_roll_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_valuation_roll_number]
GO

-- Drop property_version_number
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_version_number' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_version_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_version_number' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_version_number]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_version_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_version_number]
GO

-- Drop property_wall_insulation_location_coverage
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wall_insulation_location_coverage' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_wall_insulation_location_coverage]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wall_insulation_location_coverage' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_wall_insulation_location_coverage]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wall_insulation_location_coverage' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_wall_insulation_location_coverage]
GO

-- Drop property_wall_insulation_standard
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wall_insulation_standard' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_wall_insulation_standard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wall_insulation_standard' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_wall_insulation_standard]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wall_insulation_standard' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_wall_insulation_standard]
GO

-- Drop property_wallpaper
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wallpaper' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_wallpaper]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wallpaper' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_wallpaper]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_wallpaper' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_wallpaper]
GO

-- Drop property_warranty_expiry_date
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_warranty_expiry_date' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_warranty_expiry_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_warranty_expiry_date' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_warranty_expiry_date]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_warranty_expiry_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_warranty_expiry_date]
GO

-- Drop property_windows_keys
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_windows_keys' AND object_id = OBJECT_ID('edw.dim_property'))
ALTER TABLE edw.dim_property DROP COLUMN [property_windows_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_windows_keys' AND object_id = OBJECT_ID('landing.edw_dim_property'))
ALTER TABLE landing.edw_dim_property DROP COLUMN [property_windows_keys]
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_windows_keys' AND object_id = OBJECT_ID('staging.ODSETLdim_property'))
ALTER TABLE staging.ODSETLdim_property DROP COLUMN [property_windows_keys]
GO


/**********************************************************************************************************
 Script: 12210_Remove_fact_property_risk_columns.sql
 Author: GitHub Copilot
 Created: 26/02/2026
 Purpose: Remove 8 redundant columns from fact_property_risk tables per work item 12210
 
 Tables affected:
 - edw.fact_property_risk
 - landing.edw_fact_property_risk
 - staging.ODSETLfact_property_risk
 
 Columns to remove (8 total):
 - risk_status_code (INT)
 - property_risk_subcategory_description (VARCHAR(300))
 - property_risk_contact_with_hazardous_customers (VARCHAR(300))
 - property_risk_date_registered_key (INT)
 - property_risk_date_next_review_key (INT)
 - risk_owner_id (UNIQUEIDENTIFIER)
 - risk_created_by_id (UNIQUEIDENTIFIER)
 - risk_modified_by_id (UNIQUEIDENTIFIER)
 
 =========================================================================================================
 REVISIONS:
 Version  Date        Author            Description
 -------  ----------  ---------------   --------------------------
 1.0      2026-02-20  GitHub Copilot    Initial creation - no columns to remove
 2.0      2026-02-24  GitHub Copilot    Updated to remove 5 columns per revised comparison report
 3.0      2026-02-26  GitHub Copilot    Updated to remove 8 columns (was missing 3)
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_status_code' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN risk_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_subcategory_description' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN property_risk_subcategory_description
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_contact_with_hazardous_customers' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN property_risk_contact_with_hazardous_customers
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_date_registered_key' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN property_risk_date_registered_key
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_date_next_review_key' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN property_risk_date_next_review_key
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_owner_id' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN risk_owner_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_created_by_id' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN risk_created_by_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_modified_by_id' AND object_id = OBJECT_ID('edw.fact_property_risk'))
ALTER TABLE edw.fact_property_risk DROP COLUMN risk_modified_by_id
GO

-- Drop from landing schema
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_status_code' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN risk_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_subcategory_description' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN property_risk_subcategory_description
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_contact_with_hazardous_customers' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN property_risk_contact_with_hazardous_customers
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_date_registered_key' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN property_risk_date_registered_key
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_date_next_review_key' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN property_risk_date_next_review_key
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_owner_id' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN risk_owner_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_created_by_id' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN risk_created_by_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_modified_by_id' AND object_id = OBJECT_ID('landing.edw_fact_property_risk'))
ALTER TABLE landing.edw_fact_property_risk DROP COLUMN risk_modified_by_id
GO

-- Drop from staging schema
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_status_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN risk_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_subcategory_description' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN property_risk_subcategory_description
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_contact_with_hazardous_customers' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN property_risk_contact_with_hazardous_customers
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_date_registered_key' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN property_risk_date_registered_key
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='property_risk_date_next_review_key' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN property_risk_date_next_review_key
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_owner_id' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN risk_owner_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_created_by_id' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN risk_created_by_id
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='risk_modified_by_id' AND object_id = OBJECT_ID('staging.ODSETLfact_property_risk'))
ALTER TABLE staging.ODSETLfact_property_risk DROP COLUMN risk_modified_by_id
GO

/**********************************************************************************************************
 Script: 12210_Remove_dim_property_arrears_arrangement_columns.sql
 Author: GitHub Copilot
 Created: February 19, 2026
 Purpose: Remove redundant columns from dim_property_arrears_arrangement tables per work item 12210
 
 Tables affected:
 - edw.dim_property_arrears_arrangement
 - landing.edw_dim_property_arrears_arrangement
 - staging.ODSETLdim_property_arrears_arrangement
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT * FROM sys.columns WHERE name='breach_id' AND object_id = OBJECT_ID('edw.dim_property_arrears_arrangement'))
ALTER TABLE edw.dim_property_arrears_arrangement DROP COLUMN breach_id
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='breach' AND object_id = OBJECT_ID('edw.dim_property_arrears_arrangement'))
ALTER TABLE edw.dim_property_arrears_arrangement DROP COLUMN breach
GO

-- Drop from landing schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='breach_id' AND object_id = OBJECT_ID('landing.edw_dim_property_arrears_arrangement'))
ALTER TABLE landing.edw_dim_property_arrears_arrangement DROP COLUMN breach_id
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='breach' AND object_id = OBJECT_ID('landing.edw_dim_property_arrears_arrangement'))
ALTER TABLE landing.edw_dim_property_arrears_arrangement DROP COLUMN breach
GO

-- Drop from staging schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='breach_id' AND object_id = OBJECT_ID('staging.ODSETLdim_property_arrears_arrangement'))
ALTER TABLE staging.ODSETLdim_property_arrears_arrangement DROP COLUMN breach_id
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='breach' AND object_id = OBJECT_ID('staging.ODSETLdim_property_arrears_arrangement'))
ALTER TABLE staging.ODSETLdim_property_arrears_arrangement DROP COLUMN breach
GO

PRINT 'Successfully removed 2 columns from dim_property_arrears_arrangement tables'
GO


/**********************************************************************************************************
 Script: 12210_Remove_dim_property_detail_columns.sql
 Author: GitHub Copilot
 Created: February 19, 2026
 Purpose: Remove redundant columns from dim_property_detail tables per work item 12210
 
 Tables affected:
 - edw.dim_property_detail
 - landing.edw_dim_property_detail
 - staging.ODSETLdim_property_detail
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_window_type' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_window_type
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_landareawhole' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_landareawhole
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_mortgaged_property_flag' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_mortgaged_property_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_borrowed_amount' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_borrowed_amount
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_last_valuation' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_last_valuation
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_mortgaged_amount' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_mortgaged_amount
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_assessment_number' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_assessment_number
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_bodycorp_contact_person_name' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_bodycorp_contact_person_name
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_carpet_colour' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_carpet_colour
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_carpet_specification' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_carpet_specification
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_charged_to' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_charged_to
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_electricity_account' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_electricity_account
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_gas_meter_account' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_gas_meter_account
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_last_renovation_date' AND object_id = OBJECT_ID('edw.dim_property_detail'))
ALTER TABLE edw.dim_property_detail DROP COLUMN property_detail_last_renovation_date
GO

-- Drop from landing schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_window_type' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_window_type
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_landareawhole' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_landareawhole
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_mortgaged_property_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_mortgaged_property_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_borrowed_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_borrowed_amount
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_last_valuation' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_last_valuation
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_mortgaged_amount' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_mortgaged_amount
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_assessment_number' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_assessment_number
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_bodycorp_contact_person_name' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_bodycorp_contact_person_name
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_carpet_colour' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_carpet_colour
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_carpet_specification' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_carpet_specification
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_charged_to' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_charged_to
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_electricity_account' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_electricity_account
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_gas_meter_account' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_gas_meter_account
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_last_renovation_date' AND object_id = OBJECT_ID('landing.edw_dim_property_detail'))
ALTER TABLE landing.edw_dim_property_detail DROP COLUMN property_detail_last_renovation_date
GO

-- Drop from staging schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_window_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_window_type
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_landareawhole' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_landareawhole
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_mortgaged_property_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_mortgaged_property_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_borrowed_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_borrowed_amount
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_last_valuation' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_last_valuation
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_mortgaged_amount' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_mortgaged_amount
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_assessment_number' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_assessment_number
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_bodycorp_contact_person_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_bodycorp_contact_person_name
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_carpet_colour' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_carpet_colour
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_carpet_specification' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_carpet_specification
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_charged_to' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_charged_to
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_electricity_account' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_electricity_account
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_gas_meter_account' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_gas_meter_account
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_detail_last_renovation_date' AND object_id = OBJECT_ID('staging.ODSETLdim_property_detail'))
ALTER TABLE staging.ODSETLdim_property_detail DROP COLUMN property_detail_last_renovation_date
GO

PRINT 'Successfully removed 14 columns from dim_property_detail tables'
GO

/**********************************************************************************************************
 Script: 12210_Remove_dim_property_lease_columns.sql
 Author: GitHub Copilot
 Created: February 19, 2026
 Purpose: Remove redundant columns from dim_property_lease tables per work item 12210
 
 Tables affected:
 - edw.dim_property_lease
 - landing.edw_dim_property_lease
 - staging.ODSETLdim_property_lease
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_lease_type' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_lease_type
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_periodic_flag' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_periodic_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_owning_team' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_owning_team
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_transaction_currency' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_transaction_currency
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_crba8_landlord_annual_charge_amount_base' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_crba8_landlord_annual_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_new_landlord_lease_charge_amount_base' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_new_landlord_lease_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_bond_amount_base' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_bond_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_bond_total_base' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_bond_total_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_landlord_monthly_charge_amount_base' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_landlord_monthly_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_comments' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_comments
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_tenancy_name' AND object_id = OBJECT_ID('edw.dim_property_lease'))
ALTER TABLE edw.dim_property_lease DROP COLUMN property_lease_details_tenancy_name
GO

-- Drop from landing schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_lease_type' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_lease_type
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_periodic_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_periodic_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_owning_team' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_owning_team
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_transaction_currency' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_transaction_currency
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_crba8_landlord_annual_charge_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_crba8_landlord_annual_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_new_landlord_lease_charge_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_new_landlord_lease_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_bond_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_bond_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_bond_total_base' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_bond_total_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_landlord_monthly_charge_amount_base' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_landlord_monthly_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_comments' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_comments
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_tenancy_name' AND object_id = OBJECT_ID('landing.edw_dim_property_lease'))
ALTER TABLE landing.edw_dim_property_lease DROP COLUMN property_lease_details_tenancy_name
GO

-- Drop from staging schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_lease_type' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_lease_type
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_periodic_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_periodic_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_owning_team' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_owning_team
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_transaction_currency' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_transaction_currency
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_crba8_landlord_annual_charge_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_crba8_landlord_annual_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_new_landlord_lease_charge_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_new_landlord_lease_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_bond_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_bond_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_bond_total_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_bond_total_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_landlord_monthly_charge_amount_base' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_landlord_monthly_charge_amount_base
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_comments' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_comments
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_lease_details_tenancy_name' AND object_id = OBJECT_ID('staging.ODSETLdim_property_lease'))
ALTER TABLE staging.ODSETLdim_property_lease DROP COLUMN property_lease_details_tenancy_name
GO

PRINT 'Successfully removed 11 columns from dim_property_lease tables'
GO

/**********************************************************************************************************
 Script: 12210_Remove_dim_property_maintenance_columns.sql
 Author: GitHub Copilot
 Created: February 19, 2026
 Purpose: Remove redundant columns from dim_property_maintenance tables per work item 12210
 
 Tables affected:
 - edw.dim_property_maintenance
 - landing.edw_dim_property_maintenance
 - staging.ODSETLdim_property_maintenance
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_completed_by_contractor_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_completed_by_contractor_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_dummy_completed_but_keep_task_status_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_dummy_completed_but_keep_task_status_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_invoice_details_processed_queue_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_invoice_details_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_owner_recovery_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
--ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_owner_recovery_flag
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_request_received_sent_processed_queue_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_request_received_sent_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_send_email_notification_when_pfm_cancelled_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
--ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_send_email_notification_when_pfm_cancelled_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_support_email_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
--ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_support_email_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_suppress_tenant_email_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
--ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_suppress_tenant_email_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_tenants_permission_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
--ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_tenants_permission_flag
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_variation_processed_queue_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_variation_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_legal_owner_primary_contact' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
--ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_legal_owner_primary_contact
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_is_delete_flag' AND object_id = OBJECT_ID('edw.dim_property_maintenance'))
ALTER TABLE edw.dim_property_maintenance DROP COLUMN property_maintenance_is_delete_flag
GO

-- Drop from landing schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_completed_by_contractor_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_completed_by_contractor_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_dummy_completed_but_keep_task_status_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_dummy_completed_but_keep_task_status_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_invoice_details_processed_queue_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_invoice_details_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_owner_recovery_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
--ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_owner_recovery_flag
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_request_received_sent_processed_queue_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_request_received_sent_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_send_email_notification_when_pfm_cancelled_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
--ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_send_email_notification_when_pfm_cancelled_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_support_email_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
--ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_support_email_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_suppress_tenant_email_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
--ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_suppress_tenant_email_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_tenants_permission_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
--ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_tenants_permission_flag
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_variation_processed_queue_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_variation_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_legal_owner_primary_contact' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
--ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_legal_owner_primary_contact
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_is_delete_flag' AND object_id = OBJECT_ID('landing.edw_dim_property_maintenance'))
ALTER TABLE landing.edw_dim_property_maintenance DROP COLUMN property_maintenance_is_delete_flag
GO

-- Drop from staging schema
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_completed_by_contractor_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_completed_by_contractor_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_dummy_completed_but_keep_task_status_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_dummy_completed_but_keep_task_status_flag
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_invoice_details_processed_queue_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_invoice_details_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_owner_recovery_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
--ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_owner_recovery_flag
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_request_received_sent_processed_queue_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_request_received_sent_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_send_email_notification_when_pfm_cancelled_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
--ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_send_email_notification_when_pfm_cancelled_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_support_email_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
--ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_support_email_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_suppress_tenant_email_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
--ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_suppress_tenant_email_flag
--GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_tenants_permission_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
--ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_tenants_permission_flag
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_variation_processed_queue_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_variation_processed_queue_flag
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_legal_owner_primary_contact' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
--ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_legal_owner_primary_contact
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_maintenance_is_delete_flag' AND object_id = OBJECT_ID('staging.ODSETLdim_property_maintenance'))
ALTER TABLE staging.ODSETLdim_property_maintenance DROP COLUMN property_maintenance_is_delete_flag
GO

PRINT 'Successfully removed 12 columns from dim_property_maintenance tables'
GO


/**********************************************************************************************************
 Script: 12210_Remove_fact_property_tenant_columns.sql
 Author: GitHub Copilot
 Created: February 19, 2026
 Purpose: Remove redundant columns from fact_property_tenant tables per work item 12210
 
 Tables affected:
 - edw.fact_property_tenant
 - landing.edw_fact_property_tenant
 - staging.ODSETLfact_property_tenant
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_aka' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN property_tenant_aka
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_eatargetgroup_label' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
--ALTER TABLE edw.fact_property_tenant DROP COLUMN occupant_eatargetgroup_label
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_chintaro_id' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN property_tenant_chintaro_id
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_recordbaseid' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN property_tenant_recordbaseid
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_disability_code' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN occupant_disability_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_target_group_code' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN occupant_target_group_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_employment_code' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN occupant_employment_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_contact_type_code' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN occupant_contact_type_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_eatargetgroup_code' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
ALTER TABLE edw.fact_property_tenant DROP COLUMN occupant_eatargetgroup_code
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_is_delete_flag' AND object_id = OBJECT_ID('edw.fact_property_tenant'))
--ALTER TABLE edw.fact_property_tenant DROP COLUMN property_tenant_is_delete_flag
--GO

---- Drop from landing schema
--IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_eatargetgroup_label' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
--ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN occupant_eatargetgroup_label
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_aka' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN property_tenant_aka
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_chintaro_id' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN property_tenant_chintaro_id
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_recordbaseid' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN property_tenant_recordbaseid
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_disability_code' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN occupant_disability_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_target_group_code' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN occupant_target_group_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_employment_code' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN occupant_employment_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_contact_type_code' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN occupant_contact_type_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_eatargetgroup_code' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN occupant_eatargetgroup_code
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_is_delete_flag' AND object_id = OBJECT_ID('landing.edw_fact_property_tenant'))
--ALTER TABLE landing.edw_fact_property_tenant DROP COLUMN property_tenant_is_delete_flag
--GO

-- Drop from staging schema
--IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_eatargetgroup_label' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
--ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN occupant_eatargetgroup_label
--GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_aka' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN property_tenant_aka
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_chintaro_id' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN property_tenant_chintaro_id
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_recordbaseid' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN property_tenant_recordbaseid
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_disability_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN occupant_disability_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_target_group_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN occupant_target_group_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_employment_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN occupant_employment_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_contact_type_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN occupant_contact_type_code
GO

IF EXISTS(SELECT * FROM sys.columns WHERE name='occupant_eatargetgroup_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN occupant_eatargetgroup_code
GO

--IF EXISTS(SELECT * FROM sys.columns WHERE name='property_tenant_is_delete_flag' AND object_id = OBJECT_ID('staging.ODSETLfact_property_tenant'))
--ALTER TABLE staging.ODSETLfact_property_tenant DROP COLUMN property_tenant_is_delete_flag
--GO

PRINT 'Successfully removed 9 columns from fact_property_tenant tables'
GO

/**********************************************************************************************************
 Script: 12210_Remove_fact_property_hazard_columns.sql
 Author: GitHub Copilot
 Created: 09/03/2026
 Purpose: Remove 10 redundant columns from fact_property_hazard tables per work item 12210
 
 Tables affected:
 - edw.fact_property_hazard
 - landing.edw_fact_property_hazard
 - staging.ODSETLfact_property_hazard
 
 Columns to remove (10 total):
 - hazard_status_code (INT)
 - hazard_condition_code (INT)
 - hazard_asbestos_status_code (INT)
 - hazard_classification_code (INT)
 - hazard_classification_label (VARCHAR(30))
 - hazard_type_code (INT)
 - hazard_type_label (VARCHAR(30))
 - hazard_risklevel_code (INT)
 - hazard_asbestos_removed_code (INT)
 - hazard_location_code (VARCHAR(30))
 
 =========================================================================================================
 REVISIONS:
 Version  Date        Author            Description
 -------  ----------  ---------------   --------------------------
 1.0      2026-03-09  GitHub Copilot    Initial creation
**********************************************************************************************************/

-- Drop from edw schema first
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_status_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_condition_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_condition_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_asbestos_status_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_asbestos_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_classification_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_classification_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_classification_label' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_classification_label
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_type_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_type_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_type_label' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_type_label
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_risklevel_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_risklevel_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_asbestos_removed_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_asbestos_removed_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_location_code' AND object_id = OBJECT_ID('edw.fact_property_hazard'))
ALTER TABLE edw.fact_property_hazard DROP COLUMN hazard_location_code
GO

-- Drop from landing schema
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_status_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_condition_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_condition_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_asbestos_status_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_asbestos_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_classification_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_classification_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_classification_label' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_classification_label
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_type_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_type_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_type_label' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_type_label
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_risklevel_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_risklevel_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_asbestos_removed_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_asbestos_removed_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_location_code' AND object_id = OBJECT_ID('landing.edw_fact_property_hazard'))
ALTER TABLE landing.edw_fact_property_hazard DROP COLUMN hazard_location_code
GO

-- Drop from staging schema
IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_status_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_condition_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_condition_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_asbestos_status_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_asbestos_status_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_classification_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_classification_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_classification_label' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_classification_label
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_type_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_type_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_type_label' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_type_label
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_risklevel_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_risklevel_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_asbestos_removed_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_asbestos_removed_code
GO

IF EXISTS(SELECT *
FROM sys.columns
WHERE name='hazard_location_code' AND object_id = OBJECT_ID('staging.ODSETLfact_property_hazard'))
ALTER TABLE staging.ODSETLfact_property_hazard DROP COLUMN hazard_location_code
GO
