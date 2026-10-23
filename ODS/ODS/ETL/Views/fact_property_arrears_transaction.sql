


CREATE view [ETL].[fact_property_arrears_transaction]
as

/*******************************************************************************
 View           [ETL].[fact_property_arrears_transaction]
 Author         Mike Gencic
 Created        2025-06-25
 Purpose        Used to build the edw.fact_property_arrears_transaction fact table

 *******************************************************************************
--REVISIONS:
--Version        Date              Author                       description
---------        ------------  ---------------  --------------------------
--1.0            2025-06-25        Mike Gencic         Initial version
********************************************************************************/

SELECT
    aat.zav_arrearsarrangementstransactionsid AS transaction_id,
    --aat.Id                                    AS row_id,  --removed for all 22508 records it is the same as transction_id
    aat.zav_arrearsarrangementid              AS property_arrears_arrangement_id,
    aat.zav_tenancy                           AS property_tenancy_id,
    opp.zav_property                          AS property_id,
    opp.zav_program                           AS property_program_id,
    opp.zav_subprogram                        AS property_subprogram_id,

    aat.zav_tenancytransactiondetail          AS transaction_detail_id,
    CAST(aat.zav_transactionnumber AS VARCHAR(100)) AS transaction_number,
    CAST(aat.zav_name AS VARCHAR(200))        AS transaction_name,
    CAST(aat.zav_description AS VARCHAR(8000)) AS transaction_description,

    aat.zav_date  AS transaction_date,
    CAST(FORMAT(CONVERT(DATE, aat.zav_date), 'yyyyMMdd') AS INT) AS transaction_date_id,

    aat.zav_arrearamount  AS arrear_amount,
    aat.zav_paid          AS paid_amount,

    ----------------------------------------------------------------------------
    -- CRM state and status
    ----------------------------------------------------------------------------
    --aat.statecode  AS state_code,
    state_mt.LocalizedLabel AS state_label,
    --aat.statuscode AS property_arrears_arrangement_transaction_status_code,
    status_mt.LocalizedLabel AS status_label,

    aat.ownerid     AS owner_id,
    aat.createdon   AS created_datetime,
    aat.modifiedon  AS modified_datetime,
    CAST(CAST(aat.IsDelete AS BIT) AS INT) AS is_delete_flag

FROM [Zavanti].[vw_zav_arrearsarrangementstransactions] AS aat
LEFT JOIN [Zavanti].[vw_opportunity] AS opp ON aat.zav_tenancy = opp.Id
LEFT JOIN [Zavanti].[vw_StateMetadata] AS state_mt
       ON state_mt.EntityName = 'zav_arrearsarrangementstransactions'
      AND state_mt.State      = aat.statecode
LEFT JOIN [Zavanti].[vw_StatusMetadata] AS status_mt
       ON status_mt.EntityName = 'zav_arrearsarrangementstransactions'
      AND status_mt.State      = aat.statecode
      AND status_mt.Status     = aat.statuscode
WHERE aat.zav_arrearsarrangementstransactionsid IS NOT NULL
;