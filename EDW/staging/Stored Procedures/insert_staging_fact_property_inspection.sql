
CREATE PROC [staging].[insert_staging_fact_property_inspection]

AS
/***************************************************************************
NAME:     [staging].[insert_staging_fact_property_inspection]
PURPOSE:  

NOTES:

REVISIONS:
Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
1.0		 2024-06-27    ?				Initial version
1.1      2026-01-29    Greg Nuthall		Added a clause to soft delete inspections without a property
****************************************************************************/

--  clear the staging table before loading
TRUNCATE TABLE [Staging].[ODSETLfact_property_inspection]

-- insert data from landing table into staging table
INSERT INTO [Staging].[ODSETLfact_property_inspection] (
	 [property_inspection_id] 
	,[property_id] 
	,[property_tenancy_id] 
	,[property_maintenance_id] 
	,[property_inspection_code] 
	,[property_inspection_name] 
	,[property_inspection_date_id] 
	,[property_inspection_scheduled_date_id] 
	,[property_inspection_scheduled_time_id] 
	,[property_inspection_completion_date_id] 
	,[property_inspection_scheduled_end_time_id] 
	,[property_inspection_next_routine_inspection_date_id] 
	,[property_inspection_summary] 
	,[property_inspection_inspected_by] 
	,[property_inspection_category] 
	,[property_inspection_type] 
	,[property_inspection_maintenance_summary] 
	,[property_inspection_state] 
	,[property_inspection_status] 
	,[property_inspection_tenant_present_flag] 
	,[property_inspection_cancel_inspection_flag] 
	,[property_inspection_ignore_plugin_validate_flag] 
	,[property_inspection_tenant_confirmed_condition_flag] 
	,[property_inspection_owning_business_unit_name] 
	,[property_inspection_client] 
	,[property_inspection_property] 
	,[property_inspection_property_manager] 
	,[property_inspection_tenancy_manager] 
	,[property_inspection_tenant] 
	,[property_inspection_owner_name] 
	,[property_inspection_other_issue_comments] 
	,[property_inspection_chintaro_id] 
	,[property_inspection_comments] 
	,[property_inspection_relative_url] 
	,[property_inspection_suggested_improvements] 
	,[property_inspection_created_datetime] 
	,[property_inspection_modified_datetime] 
	,[property_inspection_is_delete_flag] 
	)
SELECT
	 [property_inspection_id] 
	,[property_id] 
	,[property_tenancy_id] 
	,[property_maintenance_id] 
	,[property_inspection_code] 
	,[property_inspection_name] 
	,[property_inspection_date_id] 
	,[property_inspection_scheduled_date_id] 
	,CASE WHEN [property_inspection_scheduled_time_id] = 0 THEN 86400 ELSE [property_inspection_scheduled_time_id] END AS [property_inspection_scheduled_time_id] -- 0 does not represent a time in dim_time
	,[property_inspection_completion_date_id] 
	,CASE WHEN [property_inspection_scheduled_end_time_id] = 0 THEN 86400 ELSE [property_inspection_scheduled_end_time_id] END AS [property_inspection_scheduled_time_id] -- 0 does not represent a time in dim_time
	,[property_inspection_next_routine_inspection_date_id] 
	,[property_inspection_summary] 
	,[property_inspection_inspected_by] 
	,[property_inspection_category] 
	,[property_inspection_type] 
	,[property_inspection_maintenance_summary] 
	,[property_inspection_state] 
	,[property_inspection_status] 
	,[property_inspection_tenant_present_flag] 
	,[property_inspection_cancel_inspection_flag] 
	,[property_inspection_ignore_plugin_validate_flag] 
	,[property_inspection_tenant_confirmed_condition_flag] 
	,[property_inspection_owning_business_unit_name] 
	,[property_inspection_client] 
	,[property_inspection_property] 
	,[property_inspection_property_manager] 
	,[property_inspection_tenancy_manager] 
	,[property_inspection_tenant] 
	,[property_inspection_owner_name] 
	,[property_inspection_other_issue_comments] 
	,[property_inspection_chintaro_id] 
	,[property_inspection_comments] 
	,[property_inspection_relative_url] 
	,[property_inspection_suggested_improvements] 
	,[property_inspection_created_datetime] 
	,[property_inspection_modified_datetime] 
	,[property_inspection_is_delete_flag] 
from [Landing].[edw_fact_property_inspection]
where [property_id] IS NOT NULL