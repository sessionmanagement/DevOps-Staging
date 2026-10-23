CREATE VIEW [ETL].[fact_property_inspection]
AS
SELECT [zav_inspectionid] AS property_inspection_id
	,[zav_property] AS property_id -- dim link
	,[zav_tenant] AS property_tenancy_id -- dim link
	
	-- looks like link to [dim_property_maintenance].[dim_property_maintenance_id] but sparsely populated
	,[zav_originatingworktask] AS [property_maintenance_id] 
	
	--NEEDS a better name - what is this code for - another system?  NOT Chintaro
	,CAST([zav_inspectionid1] AS VARCHAR(20)) AS property_inspection_code 
	
	,CAST([zav_name] AS VARCHAR(200)) AS property_inspection_name
	,CAST(FORMAT(CONVERT(DATE, [zav_inspectiondate]), 'yyyyMMdd') AS INT) AS property_inspection_date_id
	,CAST(FORMAT(CONVERT(DATE, [zav_scheduleddatedateonly]), 'yyyyMMdd') AS INT) AS property_inspection_scheduled_date_id
	
	, (DATEPART(HOUR, [zav_scheduleddate] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') * 3600) 
	+ (DATEPART(MINUTE, [zav_scheduleddate] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') * 60) 
	+ DATEPART(SECOND, [zav_scheduleddate] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS property_inspection_scheduled_time_id
	
	,CAST(FORMAT(CONVERT(DATE, [zav_completiondate]), 'yyyyMMdd') AS INT) AS property_inspection_completion_date_id
	
	,(DATEPART(HOUR, [zav_scheduledinspectionend] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') * 3600) 
	+ (DATEPART(MINUTE, [zav_scheduledinspectionend] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') * 60) 
	+ DATEPART(SECOND, [zav_scheduledinspectionend] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS property_inspection_scheduled_end_time_id
	
	,CAST(FORMAT(CONVERT(DATE, [zav_nextroutineinspection]), 'yyyyMMdd') AS INT) AS property_inspection_next_routine_inspection_date_id
	,[zav_inspectionsummary] AS property_inspection_summary
	,CAST([zav_inspectedbyname] AS VARCHAR(100)) AS property_inspection_inspected_by --inspector? nahhhh
	,(
		SELECT CAST([LocalizedLabel] AS VARCHAR(40))
		FROM [Zavanti].[vw_GlobalOptionsetMetadata]
		WHERE EntityName = 'zav_inspection'
			AND OptionSetName = 'zav_inspectioncategory'
			AND [Option] = [zav_inspectioncategory]
		) AS property_inspection_category
	,(
		SELECT CAST([LocalizedLabel] AS VARCHAR(40))
		FROM [Zavanti].[vw_GlobalOptionsetMetadata]
		WHERE EntityName = 'zav_inspection'
			AND OptionSetName = 'zav_inspectiontype'
			AND [Option] = [zav_inspectiontype]
		) AS property_inspection_type
	,[zav_maintenancerequired] AS property_inspection_maintenance_summary
	,CAST(mdstate.LocalizedLabel AS VARCHAR(10)) AS property_inspection_state
	,CAST(mdstatus.LocalizedLabel AS VARCHAR(40)) AS property_inspection_status
	,CAST(CAST(zi.[crba8_istenantpresent] AS BIT) AS INT) AS property_inspection_tenant_present_flag
	,CAST(CAST(zi.[zav_cancelinspection] AS BIT) AS INT) AS property_inspection_cancel_inspection_flag

	--MUST get a better name
	,CAST(CAST(zi.[zav_ignorepluginvalidate] AS BIT) AS INT) AS property_inspection_ignore_plugin_validate_flag 
	
	,CAST(CAST(zi.[zav_tenantconfirmedcondition] AS BIT) AS INT) AS property_inspection_tenant_confirmed_condition_flag
	,CAST([owningbusinessunitname] AS VARCHAR(20)) AS property_inspection_owning_business_unit_name
	,CAST([zav_clientname] AS VARCHAR(100)) AS property_inspection_client
	,CAST([zav_propertyname] AS VARCHAR(100)) AS property_inspection_property
	,CAST([zav_propertymanageridname] AS VARCHAR(100)) AS property_inspection_property_manager
	,CAST([zav_tenancymanagername] AS VARCHAR(100)) AS property_inspection_tenancy_manager
	,CAST([zav_tenantname] AS VARCHAR(100)) AS property_inspection_tenant
	,CAST([owneridname] AS VARCHAR(100)) AS property_inspection_owner_name
	,[zav_anyotherissuespleaseexplain] AS property_inspection_other_issue_comments
	,CAST([zav_chintaroid] AS VARCHAR(10)) AS property_inspection_chintaro_id
	,[zav_comments] AS property_inspection_comments
	,CAST([zav_relativeurl] AS VARCHAR(200)) AS property_inspection_relative_url
	,[zav_suggestedimprovements] AS property_inspection_suggested_improvements
	,zi.[createdon] AS property_inspection_created_datetime
	,zi.[modifiedon] AS property_inspection_modified_datetime
	,zi.[IsDelete] AS property_inspection_is_delete_flag
FROM [Zavanti].[vw_zav_inspection] AS zi --15309 records			
LEFT JOIN [Zavanti].[vw_StateMetadata] AS mdstate 
	ON mdstate.EntityName = 'zav_inspection'
	AND mdstate.STATE = zi.[statecode] --1 New, 100000000 Work Task Partially created, 100000001 Work Task Fully created, 100000003 NTV Rescinded (inconsistent and no 100000002/4??)
LEFT JOIN [Zavanti].[vw_StatusMetadata] AS mdstatus 
	ON mdstatus.EntityName = 'zav_inspection'
	AND mdstate.STATE = mdstatus.STATE
	AND mdstatus.STATUS = zi.[statuscode] --1 New, 100000000 Work Task Partially created, 100000001 Work Task Fully created, 100000003 NTV Rescinded (inconsistent and no 100000002??)
WHERE zi.[IsDelete] IS NULL
and [zav_property] IS NOT NULL