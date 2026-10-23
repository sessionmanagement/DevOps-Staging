








CREATE     VIEW [ETL].[dim_client_activity_breakdown_type]

as

SELECT 1 AS company_key
	,DABT.[ActivityBreakdownTypeID] AS client_activity_breakdown_type_id
	,DTC.TeamConfigurationName AS team_configuration_name
	,DABT.[ActivityBreakdownTypeCode] AS client_activity_breakdown_type_code
	,DABT.[ActivityBreakdownTypeName] AS client_activity_breakdown_type_name
	,DABT.[ActivityBreakdownTypeParentID] AS client_parent_activity_breakdown_type
	,AB.ActivityBreakdownTypeName AS client_parent_activity_breakdown_type_name
FROM [RBEAL].[dlDimActivityBreakdownType] DABT
LEFT JOIN RBEAL.dlDimTeamConfiguration DTC ON DABT.TeamConfigurationID = DTC.TeamConfigurationID
LEFT JOIN [RBEAL].[dlDimActivityBreakdownType] AB ON DABT.ActivityBreakdownTypeParentID = ab.ActivityBreakdownTypeID

UNION

SELECT 5 AS company_key
	,DABT.[ActivityBreakdownTypeID] AS client_activity_breakdown_type_id
	,DTC.TeamConfigurationName AS team_configuration_name
	,DABT.[ActivityBreakdownTypeCode] AS client_activity_breakdown_type_code
	,DABT.[ActivityBreakdownTypeName] AS client_activity_breakdown_type_name
	,DABT.[ActivityBreakdownTypeParentID] AS client_parent_activity_breakdown_type
	,AB.ActivityBreakdownTypeName AS client_parent_activity_breakdown_type_name
FROM [RBMNB].[dlDimActivityBreakdownType] DABT
LEFT JOIN RBMNB.dlDimTeamConfiguration DTC ON DABT.TeamConfigurationID = DTC.TeamConfigurationID
LEFT JOIN [RBMNB].[dlDimActivityBreakdownType] AB ON DABT.ActivityBreakdownTypeParentID = ab.ActivityBreakdownTypeID

