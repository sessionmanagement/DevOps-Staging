CREATE   PROCEDURE [edw].[kpi_properties_sp_152_TH_MIND_turn_around_in_10_days]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_properties_sp_152_TH_MIND_turn_around_in_10_days]
 Author:    Thijs Bohm
 Modified by: Timi Boddington / Greg Nuthall
 Created:   2025-06-27
 Purpose:   Take properties with minor damage to monitor how long the turnaround time is taking
 User Story: 9852
  
 Notes: Converted from view [edw].[kpi_property_152_TH_MIND_turn_around_in_10_days] to stored procedure with temp tables and indexing
 =========================================================================================================

 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-06-27   Timi Boddington     Getting rid of duplicates. Reformatting for Manish  
 1.1       2025-11-27   Thijs Bohm          Update join to use contract_bc_service_code
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 152;

    -------------------------------------------------------------------------------
    -- Temp Table 1: Intervals (Void + Tenancy Intervals)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Intervals') IS NOT NULL DROP TABLE #Intervals;
    
    -- Void Intervals
    SELECT 
        dim_property.property_id,
        dim_property.dim_property_key,
        COALESCE(dim_property.property_contract_bc_service_code, dim_property.property_bc_service_code) AS property_bc_service_code,
        'VoidInterval' AS RecordType,
        CONVERT(DATE, CASE 
            WHEN fact_void_checklist.void_checklist_void_category_name LIKE 'NEW%'
                THEN dim_property.property_acquired_date
            ELSE CASE 
                WHEN dim_property.property_acquired_date IS NOT NULL
                    AND dim_property.property_acquired_date > COALESCE(fact_void_checklist.void_checklist_date_tenancy_terminated, fact_void_checklist.void_checklist_created_on)
                    THEN dim_property.property_acquired_date
                ELSE COALESCE(fact_void_checklist.void_checklist_date_tenancy_terminated, fact_void_checklist.void_checklist_created_on)
            END
        END) AS IntervalStartDate,
        CONVERT(DATE, COALESCE(fact_void_checklist.void_checklist_date_keys_to_tenancy_team_to_allocate, dim_property.property_confirmed_disposal_date)) AS IntervalEndDate,
        fact_void_checklist.void_checklist_void_category_name AS VoidCategoryName,
        fact_void_checklist.void_checklist_status_name AS VoidStatusName,
        fact_void_checklist.void_checklist_crba8_comments AS VoidComments,
        NULL AS TenancyName,
        CAST(NULL AS UNIQUEIDENTIFIER) AS TenancyID,
        CAST(NULL AS VARCHAR(50)) AS TenancyReference,
        CAST(NULL AS VARCHAR(50)) AS TenancyStatus,
        dim_property.property_confirmed_disposal_date,
        dim_property.property_acquired_date,
        dim_property.property_void_status,
        dim_property.property_status,
        dim_property.property_statecode,
        dim_property.property_statuscode,
        fact_void_checklist.void_checklist_id
    INTO #Intervals
    FROM [edw].[fact_void_checklist]
    INNER JOIN [edw].[dim_property] ON dim_property.property_id = fact_void_checklist.void_checklist_property_id
        AND dim_property.DWHIsCurrent = 1
        AND dim_property.DWHDMLOperation <> 'D'
    WHERE fact_void_checklist.DWHIsCurrent = 1
        AND fact_void_checklist.DWHDMLOperation <> 'D'
        AND fact_void_checklist.void_checklist_void_category_name <> 'PROV'
        AND fact_void_checklist.void_checklist_status_name <> 'Void Category Change'
    
    UNION ALL
    
    -- Tenancy Intervals
    SELECT 
        dim_property.property_id,
        dim_property.dim_property_key,
        dim_property.property_bc_service_code,
        'TenancyInterval' AS RecordType,
        CONVERT(DATE, CASE 
            WHEN dim_property.property_acquired_date IS NOT NULL
                AND dim_property.property_acquired_date > dim_property_tenancy.property_tenancy_tenancy_start_date
                THEN dim_property.property_acquired_date
            ELSE dim_property_tenancy.property_tenancy_tenancy_start_date
        END) AS IntervalStartDate,
        CONVERT(DATE, COALESCE(dim_property_tenancy.property_tenancy_vacated_date, dim_property.property_confirmed_disposal_date, @SnapshotDate)) AS IntervalEndDate,
        NULL AS VoidCategoryName,
        NULL AS VoidStatusName,
        NULL AS VoidComments,
        dim_property_tenancy.property_tenancy_tenancy_name,
        dim_property_tenancy.property_tenancy_id,
        dim_property_tenancy.property_tenancy_tenancy_reference,
        dim_property_tenancy.property_tenant_opportunity_status,
        dim_property.property_confirmed_disposal_date,
        dim_property.property_acquired_date,
        dim_property.property_void_status,
        dim_property.property_status,
        dim_property.property_statecode,
        dim_property.property_statuscode,
        CAST(NULL AS UNIQUEIDENTIFIER)
    FROM [edw].[dim_property_tenancy]
    INNER JOIN [edw].[dim_property] ON dim_property.property_id = dim_property_tenancy.property_id
        AND dim_property.DWHIsCurrent = 1
        AND dim_property.DWHDMLOperation <> 'D'
    WHERE dim_property_tenancy.DWHIsCurrent = 1
        AND dim_property_tenancy.DWHDMLOperation <> 'D'
        AND dim_property_tenancy.property_tenant_opportunity_status <> 'Cancelled';

    -- Index on property_id for ordering operations
    CREATE CLUSTERED INDEX IX_Intervals_property_id ON #Intervals(property_id, IntervalStartDate, IntervalEndDate);

    -------------------------------------------------------------------------------
    -- Temp Table 2: IntervalsOrdered (with LEAD and ROW_NUMBER)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#IntervalsOrdered') IS NOT NULL DROP TABLE #IntervalsOrdered;
    
    SELECT 
        property_id,
        dim_property_key,
        property_bc_service_code,
        RecordType,
        IntervalStartDate,
        IntervalEndDate,
        VoidCategoryName,
        VoidStatusName,
        VoidComments,
        TenancyName,
        TenancyID,
        TenancyReference,
        TenancyStatus,
        property_confirmed_disposal_date,
        property_acquired_date,
        property_void_status,
        property_status,
        property_statecode,
        property_statuscode,
        void_checklist_id,
        LEAD(IntervalStartDate) OVER (PARTITION BY property_id ORDER BY IntervalStartDate, IntervalEndDate) AS NextIntervalStartDate,
        ROW_NUMBER() OVER (PARTITION BY property_id ORDER BY IntervalStartDate DESC, IntervalEndDate DESC) AS ReverseRowNum
    INTO #IntervalsOrdered
    FROM #Intervals;

    -- Index on property_id and ReverseRowNum
    CREATE CLUSTERED INDEX IX_IntervalsOrdered ON #IntervalsOrdered(property_id, ReverseRowNum);

    -------------------------------------------------------------------------------
    -- Temp Table 3: IntervalsAdjusted (adjust end dates)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#IntervalsAdjusted') IS NOT NULL DROP TABLE #IntervalsAdjusted;
    
    SELECT 
        property_id,
        dim_property_key,
        property_bc_service_code,
        RecordType,
        IntervalStartDate,
        IntervalEndDate,
        VoidCategoryName,
        VoidStatusName,
        VoidComments,
        TenancyName,
        TenancyID,
        TenancyReference,
        TenancyStatus,
        property_confirmed_disposal_date,
        property_acquired_date,
        property_void_status,
        property_status,
        property_statecode,
        property_statuscode,
        void_checklist_id,
        NextIntervalStartDate,
        ReverseRowNum,
        CASE 
            WHEN ReverseRowNum = 1 AND RecordType = 'VoidInterval' AND IntervalEndDate IS NULL
                THEN @SnapshotDate
            ELSE IntervalEndDate
        END AS intervalEndDateFinal
    INTO #IntervalsAdjusted
    FROM #IntervalsOrdered;

    -- Index on filtering columns
    CREATE NONCLUSTERED INDEX IX_IntervalsAdjusted_Filter ON #IntervalsAdjusted(VoidCategoryName, property_status, property_statecode, ReverseRowNum);

    -------------------------------------------------------------------------------
    -- Temp Table 4: IntervalsComputed (compute intervals)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#IntervalsComputed') IS NOT NULL DROP TABLE #IntervalsComputed;
    
    SELECT 
        property_id,
        dim_property_key,
        property_bc_service_code,
        RecordType,
        IntervalStartDate,
        IntervalEndDate,
        VoidCategoryName,
        VoidStatusName,
        VoidComments,
        TenancyName,
        TenancyID,
        TenancyReference,
        TenancyStatus,
        property_confirmed_disposal_date,
        property_acquired_date,
        property_void_status,
        property_status,
        property_statecode,
        property_statuscode,
        void_checklist_id,
        NextIntervalStartDate,
        ReverseRowNum,
        intervalEndDateFinal,
        CASE 
            WHEN IntervalStartDate < intervalEndDateFinal
                THEN DATEDIFF(DAY, IntervalStartDate, intervalEndDateFinal)
            ELSE 0
        END AS DaysInterval,
        CASE 
            WHEN NextIntervalStartDate IS NOT NULL
                THEN DATEDIFF(DAY, intervalEndDateFinal, NextIntervalStartDate)
            WHEN ReverseRowNum = 1 AND RecordType = 'VoidInterval'
                THEN DATEDIFF(DAY, intervalEndDateFinal, @SnapshotDate)
            ELSE NULL
        END AS DaysBetweenIntervals
    INTO #IntervalsComputed
    FROM #IntervalsAdjusted
    WHERE VoidCategoryName IN ('MIND')
        AND property_status = 'VACANT: Un-tenantable'
        AND property_statecode = 'Active'
        AND ReverseRowNum = 1;

    -- Index on property_id for joins
    CREATE CLUSTERED INDEX IX_IntervalsComputed ON #IntervalsComputed(property_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: AllCombined
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#AllCombined') IS NOT NULL DROP TABLE #AllCombined;
    
    SELECT 
        property_id,
        property_bc_service_code,
        dim_property_key,
        RecordType,
        IntervalStartDate,
        intervalEndDateFinal AS IntervalEndDate,
        DaysInterval,
        DaysBetweenIntervals,
        VoidCategoryName,
        VoidStatusName,
        VoidComments,
        TenancyName,
        TenancyID,
        TenancyReference,
        TenancyStatus,
        property_confirmed_disposal_date,
        property_acquired_date,
        property_void_status,
        property_status,
        property_statecode,
        property_statuscode,
        void_checklist_id,
        ReverseRowNum
    INTO #AllCombined
    FROM #IntervalsComputed;

    -- Index on service code for joins
    CREATE NONCLUSTERED INDEX IX_AllCombined_service_code ON #AllCombined(property_bc_service_code);

    -------------------------------------------------------------------------------
    -- Temp Table 6: Final (join with service and company)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Final') IS NOT NULL DROP TABLE #Final;
    
    SELECT 
        ac.property_id,
        ac.dim_property_key,
        ac.property_bc_service_code,
        dim_service.service_id,
        dim_service.dim_service_key,
        vw_dim_company.dim_company_key,
        CONCAT(777, '_', ac.property_id, '_', dim_service.service_id, '_', vw_dim_company.company_id) AS entity_key,
        ac.DaysInterval AS kpi_value,
        CONCAT('Property in minor damage void status for ', ac.DaysInterval, ' days') AS user_friendly_score_explanation,
        IntervalEndDate
    INTO #Final
    FROM #AllCombined ac
    LEFT JOIN edw.dim_service ON ac.property_bc_service_code = dim_service.service_code
    LEFT JOIN edw.vw_dim_company ON dim_service.dim_company_key = vw_dim_company.dim_company_key
    WHERE dim_service.DWHIsCurrent = 1
        AND dim_service.DWHDMLOperation <> 'd';

    -- Index on service_id for filtering
    CREATE NONCLUSTERED INDEX IX_Final_service_id ON #Final(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 7: selected_kpi
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
    WHERE dim_kpi.DWHDMLOperation <> 'D'
        AND dim_kpi.DWHIsCurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID
    ORDER BY dim_kpi.dim_kpi_key DESC;

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
    LEFT JOIN edw.bridge_kpi_measure_to_service_type_group ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
    LEFT JOIN edw.dim_kpi_service_type_grouping ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
        AND dim_kpi_service_type_grouping.dwhiscurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.dwhiscurrent = 1
        AND dim_service.dwhdmloperation <> 'd'
    WHERE dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    -- Index on joins
    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 9: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM (
        SELECT 
            @KPI_ID AS kpi_id,
            service_id
        FROM #service_type_grouping
    ) ms_count_0
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT 
        sk.dim_kpi_key,
        f.dim_company_key,
        f.dim_property_key,
        f.dim_service_key,
        f.entity_key,
        @KPI_ID AS kpi_id,
        f.property_id, 
        f.service_id,
        f.kpi_value,
        f.user_friendly_score_explanation,
        CASE 
            WHEN f.kpi_value IS NULL THEN NULL
            WHEN (sk.kpi_g_sign = '>=' AND f.kpi_value >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>' AND f.kpi_value > sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND f.kpi_value <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<' AND f.kpi_value < sk.kpi_g_value)
                OR (sk.kpi_g_sign = '=' AND f.kpi_value = sk.kpi_g_value)
                THEN 3
            WHEN (sk.kpi_a_sign = '>=' AND f.kpi_value >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>' AND f.kpi_value > sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND f.kpi_value <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<' AND f.kpi_value < sk.kpi_a_value)
                OR (sk.kpi_a_sign = '=' AND f.kpi_value = sk.kpi_a_value)
                THEN 2
            ELSE 1
        END AS kpi_status,
        @SnapshotDate AS snapshot_date
    FROM #Final f
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = f.service_id
    LEFT JOIN #ms_count mc ON sk.kpi_id = mc.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);


END