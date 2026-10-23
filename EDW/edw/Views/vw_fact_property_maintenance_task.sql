


CREATE VIEW [edw].[vw_fact_property_maintenance_task]
AS 

SELECT f.[fact_property_maintenance_task_key]
	,f.[property_maintenance_task_id]
	,f.[property_maintenance_id]
	,f.[dim_property_maintenance_key]
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
	,f.[dim_property_program_key]
	,isnull(dpp.[dim_property_program_id], CASE 
			WHEN f.[property_program_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_program_key_latest]
	,f.[dim_property_maintenace_type_key]
	,isnull(dpmt.[dim_property_maintenace_type_id], CASE 
			WHEN f.[property_maintenance_type_id] IS NOT NULL
				THEN - 1
			ELSE 0
			END) AS [dim_property_maintenace_type_key_latest]
	,f.[property_id]
	,f.[property_maintenance_type_id]
	,f.[property_program_id]
	,f.[property_subprogram_id]
	,f.[property_tenancy_id]
	,f.[property_maintenace_type_id]
	,f.[property_tenancy_type_id]
	,f.[property_maintenance_task_acknowledgment_date_key]
	,f.[property_maintenance_task_acknowledgment_end_date_key]
	,f.[property_maintenance_task_actual_completion_date_key]
	,f.[property_maintenance_task_contractor_work_completion_date_key]
	,f.[property_maintenance_task_expected_completion_date_key]
	,f.[property_maintenance_task_expected_onsite_date_key]
	,f.[property_maintenance_task_total_capped_amount_date_key]
	,f.[property_maintenance_task_web_expenses_amount_date_key]
	,f.[property_maintenance_assets_installation_date_key]
	,f.[property_maintenance_task_contractor_status_date_key]
	,f.[property_maintenance_task_icode]
	,f.[property_maintenance_task_information_code_name]
	,f.[property_maintenance_task_location_code]
	,f.[property_maintenance_task_location_name]
	,f.[property_maintenance_task_work_task_name]
	,f.[property_maintenance_task_area_seq]
	,f.[property_maintenance_task_assets_name]
	,f.[property_maintenance_contract_service_name]
	,f.[property_maintenance_task_comments]
	,f.[property_maintenance_task_information_code_detail_name]
	,f.[property_maintenance_task_maintenance_code]
	,f.[property_maintenance_task_maintenance_type_name]
	,f.[property_maintenance_task_amount]
	,f.[property_maintenance_task_created_datetime]
	,f.[property_maintenance_task_modified_datetime]
	,f.[property_maintenance_task_is_delete_flag]
	,f.[DWHBatchId]
	,f.[DWHCreatedAt]
	,f.[DWHModifiedOn]
	,f.[DWHDMLOperation]
	,f.[DWHSourceSystem]
FROM [edw].[fact_property_maintenance_task] f
LEFT JOIN [edw].[dim_property] dp ON f.[property_id] = dp.[property_id]
	AND dp.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_detail] dpd ON f.[property_id] = dpd.[property_detail_id]
	AND dpd.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_healthy_homes] dphh ON f.[property_id] = dphh.[property_healthy_homes_id]
	AND dphh.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_tenancy] dpt ON f.[property_tenancy_id] = dpt.[property_tenancy_id]
	AND dpt.DWHIsCurrent = 1
LEFT JOIN [edw].[dim_property_program] dpp ON f.[property_program_id] = dpp.[property_program_id]
	AND f.[property_subprogram_id] = dpp.[property_subprogram_id]
	AND dpp.[DWHIsCurrent] = 1
LEFT JOIN [edw].[dim_property_maintenace_type] dpmt ON f.[property_maintenance_type_id] = dpmt.[property_maintenance_type_id]
	AND dpmt.[DWHIsCurrent] = 1