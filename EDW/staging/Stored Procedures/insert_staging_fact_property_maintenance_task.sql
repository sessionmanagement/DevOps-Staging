

CREATE PROC [staging].[insert_staging_fact_property_maintenance_task]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_maintenance_task]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-07-02    Glenn McLeod		Initial version

****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_maintenance_task]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_maintenance_task] (
	 [property_maintenance_task_id] 
	,[property_maintenance_id] 
	,[property_id] 
	,[property_maintenance_type_id] 
	,[property_program_id] 
	,[property_subprogram_id] 
	,[property_tenancy_id] 
	,[property_tenancy_type_id] 
	,[property_maintenance_task_acknowledgment_date_id] 
	,[property_maintenance_task_acknowledgment_end_date_id] 
	,[property_maintenance_task_actual_completion_date_id] 
	,[property_maintenance_task_contractor_work_completion_date_id] 
	,[property_maintenance_task_expected_completion_date_id] 
	,[property_maintenance_task_expected_onsite_date_id] 
	,[property_maintenance_task_total_capped_amount_date_id] 
	,[property_maintenance_task_web_expenses_amount_date_id] 
	,[property_maintenance_assets_installation_date_id] 
	,[property_maintenance_task_contractor_status_date_id] 
	,[property_maintenance_task_icode] 
	,[property_maintenance_task_information_code_name] 
	,[property_maintenance_task_location_code] 
	,[property_maintenance_task_location_name] 
	,[property_maintenance_task_work_task_name] 
	,[property_maintenance_task_area_seq] 
	,[property_maintenance_task_assets_name] 
	,[property_maintenance_contract_service_name] 
	,[property_maintenance_task_comments] 
	,[property_maintenance_task_information_code_detail_name] 
	,[property_maintenance_task_maintenance_code] 
	,[property_maintenance_task_maintenance_type_name] 
	,[property_maintenance_task_amount] 
	,[property_maintenance_task_created_datetime] 
	,[property_maintenance_task_modified_datetime] 
	,[property_maintenance_task_is_delete_flag] 
	)
SELECT
	 [property_maintenance_task_id] 
	,[property_maintenance_id] 
	,[property_id] 
	,[property_maintenance_type_id] 
	,[property_program_id] 
	,[property_subprogram_id] 
	,[tenancy_id] AS property_tenancy_id
	,[property_tenancy_type_id] 
	,[property_maintenance_task_acknowledgment_date_id] 
	,[property_maintenance_task_acknowledgment_end_date_id] 
	,[property_maintenance_task_actual_completion_date_id] 
	,[property_maintenance_task_contractor_work_completion_date_id] 
	,[property_maintenance_task_expected_completion_date_id] 
	,[property_maintenance_task_expected_onsite_date_id] 
	,[property_maintenance_task_total_capped_amount_date_id] 
	,[property_maintenance_task_web_expenses_amount_date_id] 
	,[property_maintenance_assets_installation_date_id] 
	,[property_maintenance_task_contractor_status_date_id] 
	,[property_maintenance_task_icode] 
	,[property_maintenance_task_information_code_name] 
	,[property_maintenance_task_location_code] 
	,[property_maintenance_task_location_name] 
	,[property_maintenance_task_work_task_name] 
	,[property_maintenance_task_area_seq] 
	,[property_maintenance_task_assets_name] 
	,[property_maintenance_contract_service_name] 
	,[property_maintenance_task_comments] 
	,[property_maintenance_task_information_code_detail_name] 
	,[property_maintenance_task_maintenance_code] 
	,[property_maintenance_task_maintenance_type_name] 
	,[property_maintenance_task_amount] 
	,[property_maintenance_task_created_datetime] 
	,[property_maintenance_task_modified_datetime] 
	,[property_maintenance_task_is_delete_flag] 
from [Landing].[edw_fact_property_maintenance_task]