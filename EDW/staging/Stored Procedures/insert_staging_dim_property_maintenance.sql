CREATE PROC [staging].[insert_staging_dim_property_maintenance]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_dim_property_maintenance]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-06-26    ?				Initial version
1.1      2026-02-20    GitHub Copilot    Removed redundant columns per work item 12210

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLdim_property_maintenance]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLdim_property_maintenance] (
	 [property_maintenance_id] 
	,[property_maintenance_task_state] 
	,[property_maintenance_task_state_status] 
	,[property_maintenance_type] 
	,[property_maintenance_acknowledgment_type] 
	,[property_maintenance_contractor_status] 
	,[property_maintenance_contractor_status_datetime] 
	,[property_maintenance_damage_type] 
	,[property_maintenance_key_access_information] 
	,[property_maintenance_property_status] 
	,[property_maintenance_send_workorder_to] 
	,[property_maintenance_task_status] 
	,[property_maintenance_task_urgency] 
	,[property_maintenance_post_inspection_done_flag] 
	,[property_maintenance_tenant_consent_flag] 
	,[property_maintenance_acknowledgment_sent_to_tenant_flag] 
	,[property_maintenance_cancel_work_task_flag] 
	,[property_maintenance_completed_satisfactorily_flag] 
	,[property_maintenance_confirmed_for_payment_flag] 
	,[property_maintenance_ecd_processed_queue_flag] 
	,[property_maintenance_email_flag] 
	,[property_maintenance_exported_flag] 
	,[property_maintenance_finalised_work_task_flag] 
	,[property_maintenance_flexi_fund_flag] 
	,[property_maintenance_letter_flag] 
	,[property_maintenance_onhold_flag] 
	,[property_maintenance_phonecall_flag] 
	,[property_maintenance_tenant_damage_flag] 
	,[property_maintenance_tenant_liable_flag] 
	,[property_maintenance_tenants_charged_flag] 
	,[property_maintenance_text_message_flag] 
	,[property_maintenance_work_quote_processed_queue_flag] 
	,[property_maintenance_work_task_completion_processed_queue_flag] 
	,property_maintenance_legal_owner_primary_contact
	,property_maintenance_owner_recovery_flag
	,property_maintenance_send_email_notification_when_pfm_cancelled_flag
	,property_maintenance_support_email_flag
	,property_maintenance_suppress_tenant_email_flag
	,property_maintenance_tenants_permission_flag
	,[property_maintenance_inspection_identifier] 
	,[property_maintenance_cancellation_requested_by] 
	,[property_maintenance_client] 
	,[property_maintenance_housing_officer] 
	,[property_maintenance_zav_invoice_approved_by] 
	,[property_maintenance_key_support_contact] 
	,[property_maintenance_owning_business_unit_name] 
	,[property_maintenance_owning_user] 
	,[property_maintenance_created_datetime] 
	,[property_maintenance_modified_datetime] 
	)
SELECT
	 [property_maintenance_id] 
	,[property_maintenance_task_state] 
	,[property_maintenance_task_state_status] 
	,[property_maintenance_type] 
	,[property_maintenance_acknowledgment_type] 
	,[property_maintenance_contractor_status] 
	,[property_maintenance_contractor_status_datetime] 
	,[property_maintenance_damage_type] 
	,[property_maintenance_key_access_information] 
	,[property_maintenance_property_status] 
	,[property_maintenance_send_workorder_to] 
	,[property_maintenance_task_status] 
	,[property_maintenance_task_urgency] 
	,[property_maintenance_post_inspection_done_flag] 
	,[property_maintenance_tenant_consent_flag] 
	,[property_maintenance_acknowledgment_sent_to_tenant_flag] 
	,[property_maintenance_cancel_work_task_flag] 
	,[property_maintenance_completed_satisfactorily_flag] 
	,[property_maintenance_confirmed_for_payment_flag] 
	,[property_maintenance_ecd_processed_queue_flag] 
	,[property_maintenance_email_flag] 
	,[property_maintenance_exported_flag] 
	,[property_maintenance_finalised_work_task_flag] 
	,[property_maintenance_flexi_fund_flag] 
	,[property_maintenance_letter_flag] 
	,[property_maintenance_onhold_flag] 
	,[property_maintenance_phonecall_flag] 
	,[property_maintenance_tenant_damage_flag] 
	,[property_maintenance_tenant_liable_flag] 
	,[property_maintenance_tenants_charged_flag] 
	,[property_maintenance_text_message_flag] 
	,[property_maintenance_work_quote_processed_queue_flag] 
	,[property_maintenance_work_task_completion_processed_queue_flag] 
	,property_maintenance_legal_owner_primary_contact
	,property_maintenance_owner_recovery_flag
	,property_maintenance_send_email_notification_when_pfm_cancelled_flag
	,property_maintenance_support_email_flag
	,property_maintenance_suppress_tenant_email_flag
	,property_maintenance_tenants_permission_flag
	,[property_maintenance_inspection_identifier] 
	,[property_maintenance_cancellation_requested_by] 
	,[property_maintenance_client] 
	,[property_maintenance_housing_officer] 
	,[property_maintenance_zav_invoice_approved_by] 
	,[property_maintenance_key_support_contact] 
	,[property_maintenance_owning_business_unit_name] 
	,[property_maintenance_owning_user] 
	,[property_maintenance_created_datetime] 
	,[property_maintenance_modified_datetime] 
from [Landing].[edw_dim_property_maintenance]