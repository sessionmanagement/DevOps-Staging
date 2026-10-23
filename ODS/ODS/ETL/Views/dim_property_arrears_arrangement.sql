CREATE view [ETL].[dim_property_arrears_arrangement]

as

    /*******************************************************************************
 View           [ETL].[dim_property_arrears_arrangement]
 Author         Mike Gencic
 Created        2025-06-25
 Purpose        Used to build the edw.dim_property_arrears_arrangement dimension table

 *******************************************************************************
--REVISIONS:
--Version        Date              Author                       description
---------        ------------  ---------------  --------------------------
--1.0            2025-06-25        Mike Gencic         Initial version
--1.1            2026-02-20        GitHub Copilot      Removed 2 redundant columns per work item 12210
********************************************************************************/
    SELECT
        aa.zav_arrearsarrangementid    AS property_arrears_arrangement_id,
        aa.zav_tenancyid               AS property_tenancy_id,
        opp.zav_property               AS property_id,
        opp.zav_program                AS property_program_id,
        opp.zav_subprogram             AS property_subprogram_id,
        opp.zav_propertyname           AS property,
        opp.zav_programname            AS property_program,
        opp.zav_subprogramname         AS property_subprogram,

        aa.zav_tenancytransactiontype  AS tenancy_transaction_type_id,

        CAST(aa.zav_tenancyidname AS VARCHAR(200)) AS property_tenancy,
        CAST(aa.zav_tenancytransactiontypename  AS VARCHAR(200)) AS transaction_type,
        CAST(aa.zav_arrangementreferencenumber  AS VARCHAR(100)) AS arrears_arrangement_reference,
        CAST(aa.zav_name AS VARCHAR(200))       AS arrears_arrangement,

        aa.zav_priority                         AS arrears_arrangement_priority,
        arrangementtype_gm.LocalizedLabel       AS arrears_arrangement_type,

        COALESCE(frequency_gm.LocalizedLabel, frequency_om.LocalizedLabel)
        AS arrears_arrangement_frequency,

        COALESCE(calculatedbasedon_gm.LocalizedLabel, calculatedbasedon_om.LocalizedLabel)
        AS calculated_based_on,
        CAST(aa.zav_comments AS VARCHAR(8000)) AS comments,

        CAST(FORMAT(CONVERT(DATE, aa.zav_startdate), 'yyyyMMdd') AS INT) AS start_date_id,
        CAST(FORMAT(CONVERT(DATE, aa.zav_enddate), 'yyyyMMdd') AS INT) AS end_date_id,
        CAST(FORMAT(CONVERT(DATE, aa.zav_firstpaymentstartdate), 'yyyyMMdd') AS INT) AS first_payment_date_id,

        aa.zav_amount          AS amount,
        aa.zav_balanceamount   AS balance_amount,
        aa.zav_managedarrears  AS managed_arrears,
        aa.zav_unmanagedarrears AS unmanaged_arrears,
        aa.zav_totalarrears    AS total_arrears,
        aa.zav_totalbalance    AS total_balance,

        aa.owneridname   AS owner_name,
        aa.createdbyname AS created_by_name,
        aa.createdon     AS created_datetime,
        aa.modifiedbyname AS modified_by_name,
        aa.modifiedon     AS modified_datetime,

        CAST(CAST(aa.IsDelete AS BIT) AS INT) AS is_delete_flag
    , CAST((aa.SinkModifiedOn AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS synapse_link_sink_modified_on


    FROM [Zavanti].[vw_zav_arrearsarrangement] AS aa
        LEFT JOIN [Zavanti].[vw_opportunity] AS opp ON aa.zav_tenancyid = opp.Id
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS arrangementtype_gm
        ON arrangementtype_gm.EntityName    = 'zav_arrearsarrangement'
            AND arrangementtype_gm.OptionSetName = 'zav_arrangementtype'
            AND arrangementtype_gm.[Option]      = aa.zav_arrangementtype
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS frequency_gm
        ON frequency_gm.EntityName    = 'zav_arrearsarrangement'
            AND frequency_gm.OptionSetName = 'zav_frequency'
            AND frequency_gm.[Option]      = aa.zav_frequency
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS frequency_om
        ON frequency_om.EntityName    = 'zav_arrearsarrangement'
            AND frequency_om.OptionSetName = 'zav_frequency'
            AND frequency_om.[Option]      = aa.zav_frequency
        LEFT JOIN [Zavanti].[vw_GlobalOptionsetMetadata] AS calculatedbasedon_gm
        ON calculatedbasedon_gm.EntityName    = 'zav_arrearsarrangement'
            AND calculatedbasedon_gm.OptionSetName = 'zav_calculatedbasedon'
            AND calculatedbasedon_gm.[Option]      = aa.zav_calculatedbasedon
        LEFT JOIN [Zavanti].[vw_OptionsetMetadata] AS calculatedbasedon_om
        ON calculatedbasedon_om.EntityName    = 'zav_arrearsarrangement'
            AND calculatedbasedon_om.OptionSetName = 'zav_calculatedbasedon'
            AND calculatedbasedon_om.[Option]      = aa.zav_calculatedbasedon
    WHERE aa.zav_arrearsarrangementid IS NOT NULL


--and aa.zav_arrearsarrangementid <> aa.Id
--aa.modifiedby     AS modified_by_id,
--aa.createdby     AS created_by_id,
--aa.ownerid       AS owner_id,
--aa.Id                          AS row_id,
--aa.zav_arrangementtype   AS arrears_arrangement_type_code,
--aa.zav_firstpaymentstartdate   AS first_payment_date,
--aa.zav_enddate                 AS end_date,
--aa.zav_startdate               AS start_date,
--aa.zav_calculatedbasedon AS calculated_based_on_code,
--aa.zav_frequency         AS frequency_code,
--aa.Id                          AS row_id,