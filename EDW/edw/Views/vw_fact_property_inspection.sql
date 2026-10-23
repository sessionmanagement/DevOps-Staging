
CREATE VIEW [edw].[vw_fact_property_inspection]
AS

SELECT f.[fact_property_inspection_key]
	,f.[property_inspection_id]
	,f.[dim_property_key]
	,isnull(dp.[dim_property_key], CASE 
		WHEN f.[property_id] IS NOT NULL
			THEN - 1
		ELSE 0
		END) AS [dim_property_key_latest]
	,f.[dim_property_detail_key]
	,isnull(dpd.[dim_property_detail_key], CASE 
		WHEN f.[property_id] IS NOT NULL
			THEN - 1
		ELSE 0
		END) AS [dim_property_detail_key_latest]
	,f.[dim_property_healthy_homes_key]
	,isnull(dphh.[dim_property_healthy_homes_key], CASE 
		WHEN f.[property_id] IS NOT NULL
			THEN - 1
		ELSE 0
		END) AS [dim_property_healthy_homes_key_latest]
	,f.[dim_property_tenancy_key]
	,isnull(dpt.[dim_property_tenancy_key], CASE 
		WHEN f.[property_tenancy_id] IS NOT NULL
			THEN - 1
		ELSE 0
		END) AS [dim_property_tenancy_key_latest]
	,f.[dim_property_maintenance_key]
	,isnull(dpm.[dim_property_maintenance_key], CASE 
		WHEN f.[property_maintenance_id] IS NOT NULL
			THEN - 1
		ELSE 0
		END) AS [dim_property_maintenance_key_latest]
	,f.[property_id]
	,f.[property_tenancy_id]
	,f.[property_maintenance_id]
	,f.[property_inspection_code]
	,f.[property_inspection_name]
	,f.[property_inspection_date_key]
	,f.[property_inspection_scheduled_date_key]
	,f.[property_inspection_scheduled_time_key]
	,f.[property_inspection_completion_date_key]
	,f.[property_inspection_scheduled_end_time_key]
	,f.[property_inspection_next_routine_inspection_date_key]
	,f.[property_inspection_summary]
	,f.[property_inspection_inspected_by]
	,f.[property_inspection_category]
	,f.[property_inspection_type]
	,f.[property_inspection_maintenance_summary]
	,f.[property_inspection_state]
	,f.[property_inspection_status]
	,f.[property_inspection_tenant_present_flag]
	,f.[property_inspection_cancel_inspection_flag]
	,f.[property_inspection_ignore_plugin_validate_flag]
	,f.[property_inspection_tenant_confirmed_condition_flag]
	,f.[property_inspection_owning_business_unit_name]
	,f.[property_inspection_client]
	,f.[property_inspection_property]
	,f.[property_inspection_property_manager]
	,f.[property_inspection_tenancy_manager]
	,f.[property_inspection_tenant]
	,f.[property_inspection_owner_name]
	,f.[property_inspection_other_issue_comments]
	,f.[property_inspection_chintaro_id]
	,f.[property_inspection_comments]
	,f.[property_inspection_relative_url]
	,f.[property_inspection_suggested_improvements]
	,f.[property_inspection_created_datetime]
	,f.[property_inspection_modified_datetime]
	,f.[property_inspection_is_delete_flag]
	,f.[DWHBatchId]
	,f.[DWHCreatedAt]
	,f.[DWHModifiedOn]
	,f.[DWHDMLOperation]
	,f.[DWHSourceSystem]
FROM [edw].[fact_property_inspection] f
LEFT JOIN [edw].[dim_property] dp ON f.[property_id] = dp.[property_id]
	AND dp.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_detail] dpd ON f.[property_id] = dpd.[property_detail_id]
	AND dpd.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON f.[property_id] = dphh.[property_healthy_homes_id]
	AND dphh.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_tenancy] dpt ON f.[property_tenancy_id] = dpt.[property_tenancy_id]
	AND dpt.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_maintenance] dpm ON f.[property_maintenance_id] = dpm.[property_maintenance_id]
	AND dpm.DWHIsCurrent = 1