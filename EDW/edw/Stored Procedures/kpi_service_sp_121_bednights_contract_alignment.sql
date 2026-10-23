CREATE   PROCEDURE [edw].[kpi_service_sp_121_bednights_contract_alignment]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_service_sp_121_bednights_contract_alignment]
 Author: Manish Singh / Greg Nuthall
 Created: 2025-05-25		
 Purpose: Calculate bed nights alignment with contract
 User Story: Create Source Query View for KPI-service

 Notes: Converted from view [edw].[kpi_service_121_bednights_contract_alignment] 
        to stored procedure with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-05-25   Manish Singh        Initial version 
 2.0       2025-06-16   Timi Boddington     Tidy up formatting, adding dwhdmloperation <> 'd' to dim_service join where using service_id
 3.0       2025-06-18   Timi Boddington     Changed the join from dim_client_team from client_team_id to dim_client_team_key. Also duplicates in service_type_grouping, made distinct, which I think it was
 3.1       2025-07-30   Thijs Bohm          Change from 31 days to rolling 28 days or reporting
 4.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 121;

    -------------------------------------------------------------------------------
    -- Temp Table 1: base_dates
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#base_dates') IS NOT NULL DROP TABLE #base_dates;
    
    SELECT 
        CAST(CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time'))) AS DATE) AS today,
        CAST(DATEADD(DAY, -28, CAST(CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time'))) AS DATE)) AS DATE) AS reporting_start
    INTO #base_dates;

    -------------------------------------------------------------------------------
    -- Temp Table 2: referrals_1 (active accommodation-based referrals)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referrals_1') IS NOT NULL DROP TABLE #referrals_1;
    
    SELECT 
        vw_fact_client_referral_V2.fact_client_referral_key,
        vw_fact_client_referral_V2.fact_client_referral_unique_key,
        vw_fact_client_referral_V2.dim_client_referral_key,
        vw_fact_client_referral_V2.dim_company_key,
        vw_fact_client_referral_V2.dim_service_key,
        dim_service.service_id,
        vw_fact_client_referral_V2.dim_client_team_key,
        vw_fact_client_referral_V2.client_referral_id,
        vw_fact_client_referral_V2.client_id,
        vw_fact_client_referral_V2.client_team_id,
        dim_client_team.client_team_is_accommodation_based,
        dim_date.calendar_date AS accepted_date,
        ISNULL(discharge_date.calendar_date, bd.today) AS discharged_date,
        bd.reporting_start AS reporting_start_date
    INTO #referrals_1
    FROM edw.vw_fact_client_referral_V2
    LEFT JOIN edw.dim_client_team 
        ON vw_fact_client_referral_V2.dim_client_team_key = dim_client_team.dim_client_team_key
    LEFT JOIN edw.dim_service 
        ON vw_fact_client_referral_V2.dim_service_key = dim_service.dim_service_key
    INNER JOIN edw.dim_client_referral r 
        ON vw_fact_client_referral_V2.dim_client_referral_key = r.dim_client_referral_key
    INNER JOIN edw.dim_date 
        ON vw_fact_client_referral_V2.client_referral_accepted_date_key = dim_date.dim_date_key
    LEFT JOIN edw.dim_date discharge_date 
        ON vw_fact_client_referral_V2.client_referral_discharge_date_key = discharge_date.dim_date_key
    CROSS JOIN #base_dates bd
    WHERE vw_fact_client_referral_V2.dwhdmloperation <> 'd'
        AND client_referral_type = 'inboundreferral'
        AND dim_client_team.client_team_is_accommodation_based = 1
        AND dim_date.calendar_date <= bd.today
        AND (discharge_date.calendar_date IS NULL
            OR discharge_date.calendar_date BETWEEN bd.reporting_start AND bd.today);

    CREATE CLUSTERED INDEX IX_referrals_1 ON #referrals_1(fact_client_referral_key);
    CREATE NONCLUSTERED INDEX IX_referrals_1_service ON #referrals_1(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 3: bednights (calculate bed nights per referral)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#bednights') IS NOT NULL DROP TABLE #bednights;
    
    SELECT 
        r.fact_client_referral_key,
        r.fact_client_referral_unique_key,
        r.dim_client_referral_key,
        r.dim_company_key,
        r.dim_service_key,
        r.service_id,
        r.dim_client_team_key,
        r.client_referral_id,
        r.client_id,
        r.client_team_id,
        r.client_team_is_accommodation_based,
        r.accepted_date,
        r.discharged_date,
        r.reporting_start_date,
        bd.today AS today_date,
        CASE 
            WHEN r.accepted_date > r.reporting_start_date
                THEN DATEDIFF(DAY, r.accepted_date, r.discharged_date)
            ELSE DATEDIFF(DAY, r.reporting_start_date, r.discharged_date)
        END AS bednights
    INTO #bednights
    FROM #referrals_1 r
    CROSS JOIN #base_dates bd;

    CREATE NONCLUSTERED INDEX IX_bednights ON #bednights(dim_company_key, dim_service_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 4: summarised_bed_days
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#summarised_bed_days') IS NOT NULL DROP TABLE #summarised_bed_days;
    
    SELECT 
        bn.dim_company_key,
        bn.dim_service_key,
        bn.service_id,
        CONCAT(555, '_', bn.service_id, '_', vw_dim_company.company_id) AS entityid,
        SUM(bn.bednights) AS bed_nights
    INTO #summarised_bed_days
    FROM #bednights bn
    LEFT JOIN edw.vw_dim_company 
        ON bn.dim_company_key = vw_dim_company.dim_company_key
    GROUP BY bn.dim_company_key, bn.dim_service_key, bn.service_id, vw_dim_company.company_id;

    CREATE CLUSTERED INDEX IX_summarised_bed_days ON #summarised_bed_days(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: selected_kpi
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#selected_kpi') IS NOT NULL DROP TABLE #selected_kpi;
    
    SELECT TOP 1 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_kpi.what_is_measured,
        dim_kpi.kpi_g_value,
        dim_kpi.kpi_a_value,
        dim_kpi.kpi_g_sign,
        dim_kpi.kpi_a_sign
    INTO #selected_kpi
    FROM edw.dim_kpi
    WHERE dim_kpi.dwhdmloperation <> 'D'
        AND dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID
    ORDER BY dim_kpi.dim_kpi_key DESC;

    -------------------------------------------------------------------------------
    -- Temp Table 6: Service_Targets
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Service_Targets') IS NOT NULL DROP TABLE #Service_Targets;
    
    SELECT 
        vw_dim_kpi_target_definitions.service_id,
        vw_dim_kpi_target_definitions.bed_nights AS target_bednights
    INTO #Service_Targets
    FROM edw.vw_dim_kpi_target_definitions
    WHERE vw_dim_kpi_target_definitions.DWHDMLOperation <> 'D'
        AND vw_dim_kpi_target_definitions.DWHisCurrent = 1
        AND vw_dim_kpi_target_definitions.bed_nights_applies = 1;

    CREATE CLUSTERED INDEX IX_Service_Targets ON #Service_Targets(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 7: Include_Target (calculate KPI value)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Include_Target') IS NOT NULL DROP TABLE #Include_Target;
    
    SELECT 
        sbd.dim_company_key,
        sbd.dim_service_key,
        sbd.service_id,
        sbd.entityid,
        sbd.bed_nights,
        st.target_bednights,
        CAST(CAST(sbd.bed_nights AS FLOAT) / NULLIF(CAST(st.target_bednights AS FLOAT), 0) AS DECIMAL(3, 2)) AS kpi_value
    INTO #Include_Target
    FROM #summarised_bed_days sbd
    INNER JOIN #Service_Targets st 
        ON st.service_id = sbd.service_id;

    CREATE NONCLUSTERED INDEX IX_Include_Target ON #Include_Target(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 8: service_type_grouping
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;
    
    SELECT DISTINCT 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_service.service_id
    INTO #service_type_grouping
    FROM edw.dim_kpi
    LEFT JOIN edw.bridge_kpi_measure_to_service_type_group 
        ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
    LEFT JOIN edw.dim_kpi_service_type_grouping 
        ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
        AND dim_kpi_service_type_grouping.dwhiscurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping 
        ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type 
        ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service 
        ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.dwhiscurrent = 1
        AND dim_service.dwhdmloperation <> 'D'
    WHERE dim_kpi.dwhiscurrent = 1;

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 9: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT 
        sk.dim_kpi_key,
        it.dim_company_key,
        it.dim_service_key,
        it.entityid AS entity_key,
        @KPI_ID AS kpi_id,
        it.service_id,
        it.kpi_value,
        CONCAT(CAST(it.kpi_value * 100 AS INT), '% of bed night target delivered in past 28 days') AS user_friendly_score_explanation,
        CASE 
            WHEN it.kpi_value IS NULL THEN NULL
            WHEN (sk.kpi_g_sign = '>=' AND it.kpi_value >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>' AND it.kpi_value > sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND it.kpi_value <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<' AND it.kpi_value < sk.kpi_g_value)
                OR (sk.kpi_g_sign = '=' AND it.kpi_value = sk.kpi_g_value)
                THEN 3 -- Green
            WHEN (sk.kpi_a_sign = '>=' AND it.kpi_value >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>' AND it.kpi_value > sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND it.kpi_value <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<' AND it.kpi_value < sk.kpi_a_value)
                OR (sk.kpi_a_sign = '=' AND it.kpi_value = sk.kpi_a_value)
                THEN 2 -- Amber
            ELSE 1 -- Red
        END AS kpi_status,
        @SnapshotDate AS snapshot_date
    
    FROM #Include_Target it
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = it.service_id
    LEFT JOIN #ms_count mc 
        ON sk.kpi_id = mc.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);


END