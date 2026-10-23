




--/****** Object:  View [ETL].[dim_property_maintenace_type]    Script Date: 11/12/2023 12:20:44 pm ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

CREATE  VIEW [ETL].[Testdim_property_maintenace_type]

AS

SELECT 
	--zmt.[zav_maintenancetypeid] AS property_maintenance_type_id  -- this field may become NULL if the record is deleted, so cannot be used as the Business Key
	zmt.Id AS property_maintenance_type_id
	,CAST(zmt.[zav_maintenancetypecode] AS VARCHAR(80))AS property_maintenance_type_account_code
	,CAST(zmt.[zav_name] AS VARCHAR(80)) AS property_maintenance_type
	,zmt.[zav_worktypecode] AS property_maintenance_type_code
	,CAST(sap.LocalizedLabel AS varchar(50)) AS property_maintenance_service_agreement_priority
	,CAST(pmp.property_maintenance_priority as varchar(1000)) AS property_maintenance_priority
	,CAST(CAST(zmt.[zav_ownerrecovery] AS BIT) AS INT) AS property_maintenance_owner_recovery_flag
	,CAST(CAST(zmt.[zav_serviceagreement] AS BIT) AS INT) AS property_maintenance_service_agreement_flag
	,CAST(CAST(zmt.[zav_tenantliable] AS BIT) AS INT) AS property_maintenance_tenant_liable_flag
	,CAST(zmt.[zav_accounttypename] AS VARCHAR(80))AS property_maintenance_account_type
	,CAST(CAST(zmt.[IsDelete] AS BIT) AS INT) AS property_maintenance_deleted_flag
	--,zmt.SinkModifiedOn AS synapse_link_sink_modified_on
	,CAST((zmt.SinkModifiedOn AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on
FROM [Zavanti].[vw_zav_maintenancetype] zmt
LEFT JOIN (
	-- recreate property_maintenance_priority where the codes are replaced with the lookup string values
	SELECT a.[zav_maintenancetypeid]
		,STRING_AGG(zp.LocalizedLabel, ';') WITHIN
	GROUP (
			ORDER BY a.zav_priority_indiv
			) AS property_maintenance_priority
	FROM (
		SELECT zmt.[zav_maintenancetypeid]
			,value AS zav_priority_indiv
		FROM [Zavanti].[vw_zav_maintenancetype] zmt
		CROSS APPLY STRING_SPLIT(zmt.[zav_priority], ';')
		) AS a
	LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] zp ON zp.[Option] = a.zav_priority_indiv
		AND zp.OptionSetName = 'zav_priority'
		AND zp.EntityName = 'zav_maintenancetype'
	GROUP BY a.[zav_maintenancetypeid]
	) AS pmp ON zmt.[zav_maintenancetypeid] = pmp.[zav_maintenancetypeid]
LEFT JOIN [Zavanti].[vw_OptionsetMetadata] sap ON zmt.[zav_serviceagreementpriority] = sap.[Option]
	AND sap.EntityName = 'zav_maintenancetype'
	AND sap.OptionSetName = 'zav_serviceagreementpriority'