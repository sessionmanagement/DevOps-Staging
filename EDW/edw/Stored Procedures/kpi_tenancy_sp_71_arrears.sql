Create PROCEDURE [edw].[kpi_tenancy_sp_71_arrears]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_tenancy_sp_71_arrears]
 Author: Thijs Bohm / Greg Nuthall
 Created: 2025-08-07		
 Purpose: Calculate property tenancy arrears measure
 User Story: XXXX-Implement KPI for Property tenancy

 Notes: Converted from view [edw].[kpi_tenancy_71_arrears] 
        to stored procedure with temp tables and indexing.
        NOTE: This view currently has the same logic as KPI 67 (breach follow-up).
        The original comment header mentions "arrears" but the implementation checks overdue remedy notices.
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-08-07   Thijs Bohm/GN       Initial creation
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 2.1       2026-01-30   Greg Nuthall        Added distinct to grouping to avoid duplicates
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 71;

    -------------------------------------------------------------------------------
    -- Temp Table 1: CurrentNZTime
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#CurrentNZTime') IS NOT NULL DROP TABLE #CurrentNZTime;
    
    SELECT 
        CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS CurrentDateTime
    INTO #CurrentNZTime;

    -------------------------------------------------------------------------------
    -- Temp Table 2: DimCurrentTenancies
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#DimCurrentTenancies') IS NOT NULL DROP TABLE #DimCurrentTenancies;
    
    SELECT
        vs.dim_company_key,
        COALESCE(vs.dim_service_key, vs2.dim_service_key) AS dim_service_key,
        vt.dim_property_tenancy_key,
        vp.property_id,
        vt.property_tenancy_id,
        COALESCE(vs.service_name, vs2.service_name) AS service_name,
        COALESCE(vs.service_id, vs2.service_id) AS service_id
    INTO #DimCurrentTenancies
    FROM edw.vw_dim_property_tenancy vt
    INNER JOIN edw.vw_dim_property vp
        ON vt.property_id = vp.property_id
        AND vp.DWHIsCurrent = 1 
        AND vp.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service vs
        ON vp.property_contract_bc_service_code = vs.service_code
        AND vs.DWHIsCurrent = 1 
        AND vs.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service vs2
        ON vp.property_bc_service_code = vs2.service_code
        AND vs2.DWHIsCurrent = 1 
        AND vs2.DWHDMLOperation <> 'D'
    WHERE vt.DWHIsCurrent = 1
        AND vt.DWHDMLOperation <> 'D'
        AND vp.property_statecode = 'Active';

    CREATE CLUSTERED INDEX IX_DimCurrentTenancies ON #DimCurrentTenancies(property_tenancy_id);
    CREATE NONCLUSTERED INDEX IX_DimCurrentTenancies_service ON #DimCurrentTenancies(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 3: DimCurrentTenancies2
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#DimCurrentTenancies2') IS NOT NULL DROP TABLE #DimCurrentTenancies2;
    
    SELECT
        dct.dim_company_key,
        dct.dim_service_key,
        dct.dim_property_tenancy_key,
        dct.property_id,
        dct.property_tenancy_id,
        dct.service_name,
        dct.service_id,
        stg.service_type_grouping
    INTO #DimCurrentTenancies2
    FROM #DimCurrentTenancies dct
    LEFT JOIN edw.dim_service ds
        ON dct.service_id = ds.service_id
        AND ds.DWHDMLOperation <> 'D' 
        AND ds.DWHIsCurrent = 1
    LEFT JOIN edw.dim_kpi_service_type st
        ON ds.service_type_name = st.service_type
        AND st.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping stgb
        ON st.dim_kpi_service_type_key = stgb.dim_kpi_service_type_key
    LEFT JOIN edw.dim_kpi_service_type_grouping stg
        ON stgb.service_type_grouping_id = stg.service_type_grouping_id
        AND stg.DWHIsCurrent = 1
    WHERE dct.dim_service_key IS NOT NULL;

    CREATE CLUSTERED INDEX IX_DimCurrentTenancies2 ON #DimCurrentTenancies2(property_tenancy_id);
    CREATE NONCLUSTERED INDEX IX_DimCurrentTenancies2_service ON #DimCurrentTenancies2(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 4: OpenRemedyNotices
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#OpenRemedyNotices') IS NOT NULL DROP TABLE #OpenRemedyNotices;
    
    SELECT
        fprn.property_tenancy_id,
        DATEDIFF(DAY, fprn.remedy_notice_start_date, cnt.CurrentDateTime) AS days_since_start
    INTO #OpenRemedyNotices
    FROM edw.fact_property_remedy_notice fprn
    INNER JOIN edw.fact_property_tenancy_breach fptb
        ON fprn.property_tenancy_breach_id = fptb.tenancy_breach_id
        AND fptb.DWHDMLOperation <> 'D'
    INNER JOIN edw.dim_property_tenancy dpt
        ON fprn.property_tenancy_id = dpt.property_tenancy_id
        AND dpt.DWHIsCurrent = 1 
        AND dpt.DWHDMLOperation <> 'D'
    CROSS JOIN #CurrentNZTime cnt
    WHERE fprn.DWHDMLOperation <> 'D'
        AND fptb.breach_status IN ('New', '14 days notice to remedy sent');

    CREATE CLUSTERED INDEX IX_OpenRemedyNotices ON #OpenRemedyNotices(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: OverdueNoticeCount
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#OverdueNoticeCount') IS NOT NULL DROP TABLE #OverdueNoticeCount;
    
    SELECT 
        property_tenancy_id,
        COUNT(*) AS overdue_count
    INTO #OverdueNoticeCount
    FROM #OpenRemedyNotices
    WHERE days_since_start > 14
    GROUP BY property_tenancy_id;

    CREATE CLUSTERED INDEX IX_OverdueNoticeCount ON #OverdueNoticeCount(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: FinalTable
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#FinalTable') IS NOT NULL DROP TABLE #FinalTable;
    
    SELECT
        dct2.dim_company_key,
        dct2.dim_service_key,
        dct2.dim_property_tenancy_key,
        dct2.property_id,
        dct2.property_tenancy_id,
        dct2.service_name,
        dct2.service_id,
        dct2.service_type_grouping,
        COALESCE(onc.overdue_count, 0) AS overdue_count,
        CASE WHEN COALESCE(onc.overdue_count, 0) = 0 THEN 1 ELSE 0 END AS kpi_value
    INTO #FinalTable
    FROM #DimCurrentTenancies2 dct2
    LEFT JOIN #OverdueNoticeCount onc 
        ON dct2.property_tenancy_id = onc.property_tenancy_id;

    CREATE NONCLUSTERED INDEX IX_FinalTable ON #FinalTable(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 7: SelectedKPI
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#SelectedKPI') IS NOT NULL DROP TABLE #SelectedKPI;
    
    SELECT TOP 1
        dk.kpi_id,
        dk.dim_kpi_key,
        dk.what_is_measured,
        dk.kpi_g_value,
        dk.kpi_a_value,
        dk.kpi_g_sign,
        dk.kpi_a_sign
    INTO #SelectedKPI
    FROM edw.dim_kpi dk
    WHERE dk.DWHIsCurrent = 1
        AND dk.DWHDMLOperation <> 'D'
        AND dk.kpi_id = @KPI_ID;

    -------------------------------------------------------------------------------
    -- Temp Table 8: ServiceTypeGrouping
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ServiceTypeGrouping') IS NOT NULL DROP TABLE #ServiceTypeGrouping;
    
    SELECT Distinct
        dk.kpi_id,
        dk.dim_kpi_key,
        ds.service_id
    INTO #ServiceTypeGrouping
    FROM edw.dim_kpi dk
    LEFT JOIN edw.bridge_kpi_measure_to_service_type_group bkm
        ON dk.dim_kpi_key = bkm.dim_kpi_key
    LEFT JOIN edw.dim_kpi_service_type_grouping stg
        ON bkm.service_type_grouping_id = stg.dim_kpi_service_type_grouping_key
        AND stg.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping bstg
        ON bkm.dim_kpi_service_type_grouping_key = bstg.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type st
        ON bstg.dim_kpi_service_type_key = st.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service ds
        ON st.service_type = ds.service_type_name 
        AND ds.DWHIsCurrent = 1
    WHERE dk.DWHIsCurrent = 1
        AND dk.kpi_id = @KPI_ID;

    CREATE NONCLUSTERED INDEX IX_ServiceTypeGrouping ON #ServiceTypeGrouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 9: ms_count_0
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count_0') IS NOT NULL DROP TABLE #ms_count_0;
    
    SELECT 
        @KPI_ID AS kpi_id,
        service_id
    INTO #ms_count_0
    FROM #ServiceTypeGrouping;

    -------------------------------------------------------------------------------
    -- Temp Table 10: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id, 
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #ms_count_0
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------


    SELECT
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_property_tenancy_key,
        ft.dim_service_key,
        CONCAT('888', '_', ft.property_tenancy_id, '_', ft.service_id, '_', ft.dim_company_key) AS entity_key,
        @KPI_ID AS kpi_id,
        ft.property_tenancy_id,
        ft.service_id,
        ft.kpi_value,
        CASE 
            WHEN ft.overdue_count = 0 THEN 'No overdue remedy notices'
            ELSE CONCAT(ft.overdue_count, ' overdue remedy notice(s)')
        END AS user_friendly_score_explanation,
        CASE
            WHEN ft.kpi_value IS NULL THEN 1 -- Red
            WHEN (sk.kpi_g_sign = '>=' AND ft.kpi_value >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>' AND ft.kpi_value > sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND ft.kpi_value <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<' AND ft.kpi_value < sk.kpi_g_value)
                OR (sk.kpi_g_sign = '=' AND ft.kpi_value = sk.kpi_g_value)
                THEN 3 -- Green
            WHEN (sk.kpi_a_sign = '>=' AND ft.kpi_value >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>' AND ft.kpi_value > sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND ft.kpi_value <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<' AND ft.kpi_value < sk.kpi_a_value)
                OR (sk.kpi_a_sign = '=' AND ft.kpi_value = sk.kpi_a_value)
                THEN 2 -- Amber
            ELSE 1 -- Red
        END AS kpi_status,
        @SnapshotDate AS snapshot_date
    FROM #FinalTable ft
    CROSS JOIN #SelectedKPI sk
    LEFT JOIN #ServiceTypeGrouping stg 
        ON sk.dim_kpi_key = stg.dim_kpi_key 
        AND ft.service_id = stg.service_id
    LEFT JOIN #ms_count mc 
        ON mc.kpi_id = sk.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);


END