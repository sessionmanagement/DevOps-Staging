CREATE     VIEW [ETL].[fact_property_hazard]
AS

/**********************************************************************************************************
 View		[ETL].[fact_property_hazard]
 Author		Mike Gencic
 Created	2025-04-17	
 Purpose	Used to build the edw.fact_property_hazard

 **************************************************************************************************************
--REVISIONS:
--Version	 Date		   Author			description
---------	 ------------  ---------------	--------------------------
--1.0		 2025-04-17	   Greg Nuthall	    Initial version
--1.1        2026-02-20    Greg Nuthall     Removed codes
**************************************************************************************************************/


SELECT
    ----------------------------------------------------------------------------
    -- 1. Surrogate Key for EDW / Fact
    ----------------------------------------------------------------------------
    hz.zav_hazardsregisterid AS property_hazard_id,   -- The main PK in EDW

    -- Underlying CRM row ID
    hz.Id AS hazardsregister_row_id,

    ----------------------------------------------------------------------------
    -- 2. References to property
    ----------------------------------------------------------------------------
    hz.zav_property AS property_id,

    ----------------------------------------------------------------------------
    -- 3. Local Option Set lookups
    --    (zav_hazardstatus, zav_condition, zav_asbestosstatus, zav_classification, zav_type)
    ----------------------------------------------------------------------------
    --hz.zav_hazardstatus              AS hazard_status_code,
    hazardstatusOm.LocalizedLabel    AS hazard_status_label,

    --hz.zav_condition                 AS hazard_condition_code,
    conditionOm.LocalizedLabel       AS hazard_condition_label,

    --hz.zav_asbestosstatus            AS hazard_asbestos_status_code,
    asbestosstatusOm.LocalizedLabel  AS hazard_asbestos_status_label,

    --hz.zav_classification            AS hazard_classification_code,
    --classificationOm.LocalizedLabel  AS hazard_classification_label,

    --hz.zav_type                      AS hazard_type_code,
    --typeOm.LocalizedLabel            AS hazard_type_label,

    ----------------------------------------------------------------------------
    -- 4. Global Option Set lookups
    --    (zav_risklevel, zav_asbestosremoved, zav_location)
    ----------------------------------------------------------------------------
    --hz.zav_risklevel                 AS hazard_risklevel_code,
    risklevelGm.LocalizedLabel       AS hazard_risklevel_label,

    --hz.zav_asbestosremoved           AS hazard_asbestos_removed_code,
    asbestosremovedGm.LocalizedLabel AS hazard_asbestos_removed_label,

    --hz.zav_location                  AS hazard_location_code,  -- e.g. '100000000;100000001'

    -- Subselect to handle multi-code values in zav_location
    (
        SELECT
            STRING_AGG(
                COALESCE(gm.LocalizedLabel, 'Unknown'),
                '; '
            ) WITHIN GROUP (ORDER BY splitted.value)
        FROM STRING_SPLIT(hz.zav_location, ';') AS splitted
        CROSS APPLY (SELECT TRY_CAST(splitted.value AS BIGINT) AS code) AS c
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] gm
               ON gm.EntityName    = 'zav_hazardsregister'
              AND gm.OptionSetName = 'zav_location'
              AND gm.[Option]      = c.code
    ) AS hazard_location_label,

    ----------------------------------------------------------------------------
    -- 5. Hazard Attributes
    ----------------------------------------------------------------------------
    CAST(hz.zav_name AS VARCHAR(500))  AS hazard_name,
    CAST(hz.crba8_comments AS VARCHAR(3600)) AS hazard_comments,
    hz.zav_dateidentied               AS hazard_date_identified,
    CAST(FORMAT(CONVERT(DATE, hz.zav_dateidentied), 'yyyyMMdd') AS INT)
       AS hazard_date_identified_id,

    ----------------------------------------------------------------------------
    -- 6. Ownership & Audit Fields
    ----------------------------------------------------------------------------
    --hz.ownerid       AS hazard_owner_id,
    --hz.owneridname   AS hazard_owner_name,

    --hz.createdby     AS hazard_created_by_id,
    --hz.createdbyname AS hazard_created_by_name,
    --hz.createdon     AS hazard_created_on,

    --hz.modifiedby     AS hazard_modified_by_id,
    --hz.modifiedbyname AS hazard_modified_by_name,
    --hz.modifiedon     AS hazard_modified_on,

    ----------------------------------------------------------------------------
    -- 7. Standard "IsDelete", states, sink timestamps
    ----------------------------------------------------------------------------
    hz.statecode  AS hazard_state_code,
    hz.statuscode AS hazard_status_code_crm,  -- rename if you like
    CAST(CAST(hz.IsDelete AS BIT) AS INT) AS hazard_is_delete_flag

    --hz.SinkCreatedOn,
    --hz.SinkModifiedOn

FROM [Zavanti].[vw_zav_hazardsregister] AS hz

-- Local Option Sets => [Zavanti].[vw_OptionsetMetadata]

LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS hazardstatusOm
       ON hazardstatusOm.EntityName    = 'zav_hazardsregister'
      AND hazardstatusOm.OptionSetName = 'zav_hazardstatus'
      AND hazardstatusOm.[Option]      = hz.zav_hazardstatus

LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS conditionOm
       ON conditionOm.EntityName    = 'zav_hazardsregister'
      AND conditionOm.OptionSetName = 'zav_condition'
      AND conditionOm.[Option]      = hz.zav_condition

LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS asbestosstatusOm
       ON asbestosstatusOm.EntityName    = 'zav_hazardsregister'
      AND asbestosstatusOm.OptionSetName = 'zav_asbestosstatus'
      AND asbestosstatusOm.[Option]      = hz.zav_asbestosstatus

LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS classificationOm
       ON classificationOm.EntityName    = 'zav_hazardsregister'
      AND classificationOm.OptionSetName = 'zav_classification'
      AND classificationOm.[Option]      = hz.zav_classification

LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS typeOm
       ON typeOm.EntityName    = 'zav_hazardsregister'
      AND typeOm.OptionSetName = 'zav_type'
      AND typeOm.[Option]      = hz.zav_type

-- Global Option Sets => [Zavanti].[vw_GlobalOptionsetMetadata]

LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS risklevelGm
       ON risklevelGm.EntityName    = 'zav_hazardsregister'
      AND risklevelGm.OptionSetName = 'zav_risklevel'
      AND risklevelGm.[Option]      = hz.zav_risklevel

LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS asbestosremovedGm
       ON asbestosremovedGm.EntityName    = 'zav_hazardsregister'
      AND asbestosremovedGm.OptionSetName = 'zav_asbestosremoved'
      AND asbestosremovedGm.[Option]      = hz.zav_asbestosremoved

-- No direct join for location because it's done via sub-select with CROSS APPLY

-- Optionally filter or not:
-- WHERE hz.zav_hazardsregisterid IS NOT NULL
;