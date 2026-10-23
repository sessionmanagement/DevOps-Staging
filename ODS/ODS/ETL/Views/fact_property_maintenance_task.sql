














CREATE VIEW [ETL].[fact_property_maintenance_task]
AS

/*
Will need to be full load as there is full outter join between [Zavanti].[vw_zav_maintenancetask] and [Zavanti].[vw_zav_maintenancedetail].
Some detail records dont have parents and some parents dont have children
BK will have to be a combination of zmtd.ID and zmt.ID, so will need to delete old record if parent or child appears
*/

SELECT 
--,COUNT(*) OVER (PARTITION BY zmt.ID) AS Multi_COUNT
--,COUNT(*) OVER (PARTITION BY zmt.ID,zpa.ID) AS Multi_COUNT_Asset
zmtd.ID AS property_maintenance_task_id  --zicd.*
,zmt.ID AS property_maintenance_id
,new_property AS property_id
--,zmty.id AS dim_property_maintenance_type_id
,zmtd.zav_maintenancetype AS property_maintenance_type_id
,zmt.[zav_program]  AS [property_program_id]
,zmt.[zav_subprogram]  AS [property_subprogram_id]
,zav_tenancy AS tenancy_id -- link to new dim_tenacy
,opp.zav_tenancytypeid AS property_tenancy_type_id
--zmt.lastonholdtime << All Null
--,zmt.new_actualstartdate << All Null
--,zmt.new_invoiceduedate << All Null
--,zmt.new_postinspectioncompleteddate << All Null
--,zmt.new_reporteddate << All Null
--,zmt.new_scheduledcompletiondate << All Null
--,zmt.new_scheduledstartdate << All Null
--,zmt.new_tenantconsentdate << All Null
--,zmt.overriddencreatedon << All Null
--,zmt.zav_acknowledgmentdateandtime AS property_maintenance_task_acknowledgment_date_time
,CAST(FORMAT(CONVERT(DATE, zmt.zav_acknowledgmentdateandtime  ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_acknowledgment_date_id
--,zmt.zav_acknowledgmentenddateandtime AS property_maintenance_task_acknowledgment_end_date_time
,CAST(FORMAT(CONVERT(DATE, zmt.zav_acknowledgmentenddateandtime), 'yyyyMMdd') AS INT)  AS property_maintenance_task_acknowledgment_end_date_id
--,zmt.zav_actualcompletiondate AS property_maintenance_task_actual_completion_date
,CAST(FORMAT(CONVERT(DATE, zmt.zav_actualcompletiondate ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_actual_completion_date_id
--,zmt.zav_contractorworkcompletiondate AS property_maintenance_task_contractor_work_completion_date
,CAST(FORMAT(CONVERT(DATE, zmt.zav_contractorworkcompletiondate ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_contractor_work_completion_date_id
--,zmt.zav_expectedcompletiondate AS property_maintenance_task_expected_completion_date
,CAST(FORMAT(CONVERT(DATE, zmt.zav_expectedcompletiondate ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_expected_completion_date_id
--,zmt.zav_expectedonsitedate AS property_maintenance_task_expected_onsite_date
,CAST(FORMAT(CONVERT(DATE, zmt.zav_expectedonsitedate ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_expected_onsite_date_id
--,zmt.zav_invoicepaiddate << All Null
--,zmt.zav_resolvebyfailuretime << All Null
--,zmt.zav_responsebyfailuretime << All Null
--,zmt.zav_tenantsconfirmationdate << All Null
--,zmt.zav_totalcappedamount_date AS property_maintenance_task_total_capped_amount_date
,CAST(FORMAT(CONVERT(DATE, zmt.zav_totalcappedamount_date ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_total_capped_amount_date_id
--,zmt.zav_webexpensesamount_date AS property_maintenance_task_web_expenses_amount_date
,CAST(FORMAT(CONVERT(DATE, zmt.zav_webexpensesamount_date ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_web_expenses_amount_date_id
--,zmtd.zav_actualcompletiondate << All Null
--,zmtd.zav_invoicedate AS property_maintenance_task_invoice_date << All Null
--,zmtd.zav_tenantconsentdate AS property_maintenance_task_tenant_consent_date << All Null
--,zpa.zav_installationdate AS property_maintenance_assets_installation_date
,CAST(FORMAT(CONVERT(DATE, zpa.zav_installationdate  ), 'yyyyMMdd') AS INT)  AS property_maintenance_assets_installation_date_id
--,zmt.zav_contractorstatusdateandtime AS property_maintenance_task_contractor_status_date_time
,CAST(FORMAT(CONVERT(DATE, zmt.zav_contractorstatusdateandtime ), 'yyyyMMdd') AS INT)  AS property_maintenance_task_contractor_status_date_id
--,CAST(state_mt.LocalizedLabel AS VARCHAR(10)) AS property_maintenance_task_detail_state -- moved to [ETL].[dim_property_maintenance]
--,CAST(status_mt.LocalizedLabel AS VARCHAR(20))  AS property_maintenance_task_detail_status -- moved to [ETL].[dim_property_maintenance]
--,su.fullname AS maintenance_task_created_by
--,zmtd.createdonbehalfbyname AS maintenance_task_created_onbehalf_by
--,zicd.zav_comments
,CAST(zicd.zav_icode AS VARCHAR(50)) AS property_maintenance_task_icode
--,zicd.zav_informationcodedetailsid
,CAST(zicd.zav_informationcodename AS VARCHAR(200)) AS property_maintenance_task_information_code_name
,CAST(zicd.zav_locationcode AS VARCHAR(10))  AS property_maintenance_task_location_code
,CAST(zicd.zav_locationnamename AS VARCHAR(50)) AS property_maintenance_task_location_name
--,zicd.zav_name
,CAST(zicd.zav_worktaskname AS VARCHAR(100)) AS property_maintenance_task_work_task_name
,zl.zav_areaseq AS property_maintenance_task_area_seq
--,zl.zav_locationid
,CAST(zpa.zav_assetsname AS VARCHAR(100)) AS property_maintenance_task_assets_name
--,zpa.zav_name
--,zmtd.new_isexported << All Null
--,zmtd.new_issynchronizedtobc << All Null
--,zmtd.new_runningimporting << All Null
--,zmtd.zav_dummycaneditaftercompleted << All Null
--,zmtd.zav_isfromimporttool << All Null
--,zmtd.zav_nextexport << All Null
--,zmtd.zav_runningallpluginswithasyncmode << All Null
--,zmtd.zav_tenantconsent << All Null
--,zmtd.zav_tenantdamage << All Null
--,zmtd.zav_tenantscharged << All Null
,CAST(zmtd.new_contractservicename AS VARCHAR(100)) AS property_maintenance_contract_service_name
,zmtd.zav_comments AS property_maintenance_task_comments
,CAST(zmtd.zav_informationcodedetailname AS VARCHAR(200)) AS property_maintenance_task_information_code_detail_name
,CAST(zmtd.zav_maintenancecode AS VARCHAR(10)) AS property_maintenance_task_maintenance_code
,CAST(zmtd.zav_maintenancetypename AS VARCHAR(50)) AS property_maintenance_task_maintenance_type_name
,zmtd.zav_amount AS property_maintenance_task_amount
--,zmtd.zav_amount_base << the same as zmtd.zav_amount
,ISNULL(zmty.createdon,zmt.createdon) AS property_maintenance_task_created_datetime
,ISNULL(zmty.modifiedon,zmt.modifiedon) AS property_maintenance_task_modified_datetime
,CAST(CAST(CASE WHEN zmtd.ID IS NOT NULL THEN zmtd.IsDelete ELSE zmt.IsDelete END as BIT) as INT) AS property_maintenance_task_is_delete_flag
--,zmt.IsDelete
FROM [Zavanti].[vw_zav_maintenancetask] zmt
FULL OUTER JOIN  [Zavanti].[vw_zav_maintenancedetail] zmtd ON zmtd.zav_maintenancetaskid = zmt.[Id]
LEFT JOIN [Zavanti].[vw_zav_maintenancetype] zmty ON zmty.id  = zmtd.zav_maintenancetype
LEFT JOIN  [Zavanti].[vw_zav_informationcodedetails] zicd ON zmtd.zav_informationcodedetail = zicd.Id
LEFT JOIN [Zavanti].[vw_zav_location] zl ON zmtd.zav_location = zl.ID
LEFT JOIN [Zavanti].[vw_zav_propertyassets] zpa ON zmtd.zav_propertyassets = zpa.ID
--LEFT JOIN [Zavanti].[vw_StateMetadata] AS state_mt ON state_mt.EntityName = 'zav_maintenancedetail' AND state_mt.state = zmtd.statecode
--LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_mt ON status_mt.EntityName = 'zav_maintenancedetail' AND status_mt.state = zmtd.statecode AND status_mt.status = zmtd.statuscode
LEFT JOIN [Zavanti].[vw_opportunity] AS opp ON zmtd.zav_tenancy  = opp.id
 WHERE zmtd.IsDelete IS NULL