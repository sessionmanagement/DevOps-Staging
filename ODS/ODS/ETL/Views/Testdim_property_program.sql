
-- 1.4        2025-05-12      Manish Singh    Changed UTC date columns to NZT

CREATE VIEW [ETL].[Testdim_property_program]
AS

SELECT zsp.[zav_program] AS property_program_id
	--,zsp.[zav_subprogramid] AS property_subprogram_id -- this field may become NULL if the record is deleted, so cannot be used as the Business Key
	,zsp.id AS property_subprogram_id
	,CAST(zsp.[zav_programname] AS VARCHAR(100)) AS property_program_name
	-- ,zsp.[zav_programowner] as property_program_owner_id
	,CAST(zsp.[zav_programownername] AS VARCHAR(100)) AS property_program_owner_name
	,CAST(zsp.[zav_name] AS VARCHAR(100)) AS property_subprogram_name
	,CAST(zsp.[zav_propertytransactiontypes] AS VARCHAR(1000)) AS property_subprogram_property_transaction_types
	--,[statecode] as property_subprogram_state_code
	,CAST(ss.LocalizedLabel AS VARCHAR(20)) AS property_subprogram_state
	--,[statuscode] as property_subprogram_status_code
	,CAST(sst.LocalizedLabel AS VARCHAR(20)) AS property_subprogram_status
	,CAST(CAST(zsp.[zav_ignoremarketrent] AS BIT) AS INT) AS property_market_rent_ignore_flag
	-- ,zsp.[owningbusinessunit] as property_subprogram_owning_business_unit_id
	,CAST(zsp.[owningbusinessunitname] AS VARCHAR(100)) AS property_subprogram_owning_business_unit_name
	-- ,zsp.[owningteam] as property_subprogram_owning_team_id
	,CAST(ot.name  AS VARCHAR(100)) AS property_subprogram_owning_team_name
	--,zsp.[owninguser] as property_subprogram_owning_user_id
	,CAST(ou.fullname AS VARCHAR(100)) AS property_subprogram_owning_user_name
	--,zsp.[ownerid] as property_subprogram_owner_id
	,CAST(zsp.[owneridname] AS VARCHAR(100)) AS property_subprogram_owner_name
	--,zsp.[createdby] as property_subprogram_created_by_user_id
	,CAST(zsp.[createdbyname] AS VARCHAR(100)) AS property_subprogram_created_by_user_name
	-- ,zsp.[modifiedby] as property_subprogram_modified_by_user_id
	,CAST(zsp.[modifiedbyname] AS VARCHAR(100)) AS property_subprogram_modified_by_user_name
	--,zsp.[modifiedon] AS property_subprogram_modified_on_date

	,CAST((zsp.[modifiedon] AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS property_subprogram_modified_on_date
	,zsp.[versionnumber] AS property_subprogram_version_number
	,CAST(zsp.[zav_code] AS VARCHAR(20)) AS property_subprogram_code
	,CAST(CAST(zsp.[IsDelete] AS BIT) AS INT) AS property_subprogram_deleted_flag
	--,zsp.SinkModifiedOn AS synapse_link_sink_modified_on
	,CAST((zsp.SinkModifiedOn AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on
FROM [Zavanti].[vw_zav_subprogram] zsp
LEFT JOIN [Zavanti].[vw_StateMetadata] ss ON zsp.[statecode] = ss.[State]
	AND ss.EntityName = 'zav_subprogram'
LEFT JOIN [Zavanti].[vw_StatusMetadata] sst ON zsp.[statuscode] = sst.[Status]
	AND sst.EntityName = 'zav_subprogram'
LEFT JOIN [Zavanti].[vw_team] ot ON zsp.[owningteam] = ot.id
LEFT JOIN [Zavanti].[vw_systemuser] ou ON zsp.[owninguser] = ou.id