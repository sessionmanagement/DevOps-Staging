CREATE PROCEDURE [edw].[kpi_tenancy_sp_67_breaches]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_tenancy_sp_67_breaches]
 Author: Mike Gencic
 Created: 2026-04-24
 Purpose: Calculates tenancy breach status for KPI 67 using the age of the oldest qualifying breach.
 User Story: 12769

 Notes: Converted from view [edw].[kpi_tenancy_67_breaches]
        to stored procedure with temp tables and indexing.
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0      2026-04-24   Mike Gencic         Initial version
 1.1      2026-05-20   Mike Gencic         Excluded tenancies with no qualifying or open breaches per point 11
 1.2      2026-05-22   Mike Gencic         Aligned explanation text to Table 1 wording
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 67;

    -------------------------------------------------------------------------------
    -- Temp Table 1: CurrentNZTime
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#CurrentNZTime') IS NOT NULL DROP TABLE #CurrentNZTime;

    SELECT
        CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATETIME2) AS CurrentDateTime
    INTO #CurrentNZTime;

    -------------------------------------------------------------------------------
    -- Temp Table 2: SelectedKPI
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#SelectedKPI') IS NOT NULL DROP TABLE #SelectedKPI;

    SELECT TOP 1
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_kpi.what_is_measured,
        dim_kpi.kpi_g_value,
        dim_kpi.kpi_a_value,
        dim_kpi.kpi_g_sign,
        dim_kpi.kpi_a_sign
    INTO #SelectedKPI
    FROM edw.dim_kpi
    WHERE dim_kpi.DWHDMLOperation <> 'D'
      AND dim_kpi.DWHIsCurrent = 1
      AND dim_kpi.kpi_id = @KPI_ID
    ORDER BY dim_kpi.dim_kpi_key DESC;

    -------------------------------------------------------------------------------
    -- Temp Table 3: Service_type_grouping
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Service_type_grouping') IS NOT NULL DROP TABLE #Service_type_grouping;

    SELECT DISTINCT
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_service.service_id
    INTO #Service_type_grouping
    FROM edw.dim_kpi
    LEFT JOIN edw.bridge_kpi_measure_to_service_type_group
        ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
    LEFT JOIN edw.dim_kpi_service_type_grouping
        ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
        AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type
        ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service
        ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.DWHIsCurrent = 1
        AND dim_service.DWHDMLOperation <> 'D'
    WHERE dim_kpi.DWHIsCurrent = 1
      AND dim_kpi.kpi_id = (SELECT kpi_id FROM #SelectedKPI);

    CREATE NONCLUSTERED INDEX IX_Service_type_grouping ON #Service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 4: ms_count_0
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count_0') IS NOT NULL DROP TABLE #ms_count_0;

    SELECT
        (SELECT DISTINCT kpi_id FROM #SelectedKPI) AS kpi_id,
        service_id
    INTO #ms_count_0
    FROM #Service_type_grouping;

    -------------------------------------------------------------------------------
    -- Temp Table 5: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;

    SELECT
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #ms_count_0
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Temp Table 6: Dim_Current_Tenancies
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Dim_Current_Tenancies') IS NOT NULL DROP TABLE #Dim_Current_Tenancies;

    SELECT
        vw_dim_service.dim_company_key,
        vw_dim_property_tenancy.property_tenancy_id,
        vw_dim_property_tenancy.dim_property_tenancy_key,
        COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) AS dim_service_key,
        vw_dim_property.dim_property_key,
        vw_dim_property.property_id,
        vw_dim_property.property_program,
        vw_dim_property.property_sub_program,
        COALESCE(vw_dim_service.service_name, dim_service_2.service_name) AS service_name,
        COALESCE(vw_dim_service.service_id, dim_service_2.service_id) AS service_id,
        CASE WHEN vw_dim_property.property_current_tenancy IS NULL THEN 0 ELSE 1 END AS currently_tenanted_flag
    INTO #Dim_Current_Tenancies
    FROM edw.vw_dim_property_tenancy
    INNER JOIN edw.vw_dim_property
        ON vw_dim_property_tenancy.property_id = vw_dim_property.property_id
        AND vw_dim_property.DWHIsCurrent = 1
        AND vw_dim_property.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service
        ON vw_dim_property.property_contract_bc_service_code = vw_dim_service.service_code
        AND vw_dim_service.DWHIsCurrent = 1
        AND vw_dim_service.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service AS dim_service_2
        ON vw_dim_property.property_bc_service_code = dim_service_2.service_code
        AND dim_service_2.DWHIsCurrent = 1
        AND dim_service_2.DWHDMLOperation <> 'D'
    WHERE vw_dim_property_tenancy.DWHIsCurrent = 1
      AND vw_dim_property_tenancy.DWHDMLOperation <> 'D'
      AND vw_dim_property.dim_property_key > 0
      AND vw_dim_property.property_statecode = 'Active'
      AND vw_dim_property_tenancy.property_tenant_opportunity_status IN ('new', 'active arrears', 'active')
      AND vw_dim_property_tenancy.property_tenancy_vacate_confirmation_flag = 0
      AND vw_dim_property_tenancy.property_tenancy_actual_close_date IS NULL
      AND vw_dim_property.property_name NOT LIKE '%parent%'
      AND ISNULL(vw_dim_property.property_confirmed_disposal_date, '2099-12-31') >= GETDATE()
      AND ISNULL(vw_dim_property.property_acquired_date, '2099-12-31') <= GETDATE()
      AND ISNULL(vw_dim_property.property_status, '') NOT IN ('vacant: un-tenantable')
      AND vw_dim_property.property_current_tenancy IS NOT NULL
      AND (
            (ISNULL(vw_dim_property.property_program, '') = 'Affordable Housing Management' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Rotorua Lakes Council')
         OR (ISNULL(vw_dim_property.property_program, '') = 'Affordable Rental' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Affordable Rental')
         OR (ISNULL(vw_dim_property.property_program, '') = 'Boarding' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Residential Services Boarding')
         OR (ISNULL(vw_dim_property.property_program, '') = 'IRRS' AND ISNULL(vw_dim_property.property_sub_program, '') IN (
                'CPP (Spot)',
                'Housing First (SPOT)',
                'Social Housing (Capacity)',
                'Social Housing (SPOT)',
                'Social Housing TM'
            ))
      );

    CREATE CLUSTERED INDEX IX_Dim_Current_Tenancies ON #Dim_Current_Tenancies(property_tenancy_id);
    CREATE NONCLUSTERED INDEX IX_Dim_Current_Tenancies_service ON #Dim_Current_Tenancies(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 7: DimCurrentTenancies2
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#DimCurrentTenancies2') IS NOT NULL DROP TABLE #DimCurrentTenancies2;

    SELECT
        vw_dim_service.dim_company_key,
        dct.dim_service_key,
        dct.dim_property_key,
        dct.property_id,
        dct.property_tenancy_id,
        dct.dim_property_tenancy_key,
        dct.service_id,
        dct.currently_tenanted_flag,
        dct.property_program,
        dct.property_sub_program,
        dim_kpi_service_type_grouping.service_type_grouping
    INTO #DimCurrentTenancies2
    FROM #Dim_Current_Tenancies dct
    LEFT JOIN edw.vw_dim_service
        ON dct.dim_service_key = vw_dim_service.dim_service_key
        AND vw_dim_service.DWHDMLOperation <> 'D'
        AND vw_dim_service.DWHIsCurrent = 1
    LEFT JOIN edw.dim_kpi_service_type
        ON vw_dim_service.service_type_name = dim_kpi_service_type.service_type
        AND dim_kpi_service_type.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON dim_kpi_service_type.dim_kpi_service_type_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key
    LEFT JOIN edw.dim_kpi_service_type_grouping
        ON bridge_kpi_service_type_to_grouping.service_type_grouping_id = dim_kpi_service_type_grouping.service_type_grouping_id
        AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
    WHERE dct.dim_service_key IS NOT NULL;

    CREATE CLUSTERED INDEX IX_DimCurrentTenancies2 ON #DimCurrentTenancies2(property_tenancy_id);
    CREATE NONCLUSTERED INDEX IX_DimCurrentTenancies2_service ON #DimCurrentTenancies2(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 8: QualifyingBreaches
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#QualifyingBreaches') IS NOT NULL DROP TABLE #QualifyingBreaches;

    SELECT
        fptb.property_tenancy_id,
        fptb.tenancy_breach_id,
        MIN(fptb.breach_date) AS breach_date,
        DATEDIFF(DAY, MIN(fptb.breach_date), cnt.CurrentDateTime) AS days_since_breach
    INTO #QualifyingBreaches
    FROM edw.fact_property_tenancy_breach fptb
    CROSS JOIN #CurrentNZTime cnt
    WHERE fptb.DWHDMLOperation <> 'D'
      AND fptb.tenancy_breach_id IS NOT NULL
      AND fptb.property_tenancy_id IS NOT NULL
      AND fptb.breach_date IS NOT NULL
      AND fptb.breach_status IN ('New', '14 days notice to remedy sent')
    GROUP BY
        fptb.property_tenancy_id,
        fptb.tenancy_breach_id,
        cnt.CurrentDateTime;

    CREATE CLUSTERED INDEX IX_QualifyingBreaches ON #QualifyingBreaches(property_tenancy_id, breach_date);

    -------------------------------------------------------------------------------
    -- Temp Table 9: OldestQualifyingBreach
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#OldestQualifyingBreach') IS NOT NULL DROP TABLE #OldestQualifyingBreach;

    SELECT
        RankedBreaches.property_tenancy_id,
        RankedBreaches.breach_date,
        RankedBreaches.days_since_breach
    INTO #OldestQualifyingBreach
    FROM (
        SELECT
            qb.property_tenancy_id,
            qb.breach_date,
            qb.days_since_breach,
            ROW_NUMBER() OVER (
                PARTITION BY qb.property_tenancy_id
                ORDER BY qb.breach_date ASC, qb.days_since_breach DESC
            ) AS breach_rank
        FROM #QualifyingBreaches qb
    ) AS RankedBreaches
    WHERE RankedBreaches.breach_rank = 1;

    CREATE CLUSTERED INDEX IX_OldestQualifyingBreach ON #OldestQualifyingBreach(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 10: OpenBreachCount
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#OpenBreachCount') IS NOT NULL DROP TABLE #OpenBreachCount;

    SELECT
        fptb.property_tenancy_id,
        COUNT(DISTINCT fptb.tenancy_breach_id) AS open_breach_count
    INTO #OpenBreachCount
    FROM edw.fact_property_tenancy_breach fptb
    WHERE fptb.DWHDMLOperation <> 'D'
      AND fptb.tenancy_breach_id IS NOT NULL
      AND fptb.property_tenancy_id IS NOT NULL
      AND ISNULL(fptb.breach_status, '') <> 'Closed'
    GROUP BY fptb.property_tenancy_id;

    CREATE CLUSTERED INDEX IX_OpenBreachCount ON #OpenBreachCount(property_tenancy_id);

    -------------------------------------------------------------------------------
    -- Temp Table 11: FinalTable
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#FinalTable') IS NOT NULL DROP TABLE #FinalTable;

    SELECT
        dct2.dim_company_key,
        dct2.dim_service_key,
        dct2.dim_property_tenancy_key,
        dct2.property_tenancy_id,
        dct2.service_id,
        ISNULL(oqb.days_since_breach, 0) AS kpi_value,
        oqb.days_since_breach,
        ISNULL(obc.open_breach_count, 0) AS open_breach_count
    INTO #FinalTable
    FROM #DimCurrentTenancies2 dct2
    LEFT JOIN #OldestQualifyingBreach oqb
        ON dct2.property_tenancy_id = oqb.property_tenancy_id
    LEFT JOIN #OpenBreachCount obc
        ON dct2.property_tenancy_id = obc.property_tenancy_id
    WHERE oqb.property_tenancy_id IS NOT NULL
       OR ISNULL(obc.open_breach_count, 0) > 0;

    CREATE CLUSTERED INDEX IX_FinalTable ON #FinalTable(property_tenancy_id);
    CREATE NONCLUSTERED INDEX IX_FinalTable_service ON #FinalTable(service_id, dim_company_key);

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
            WHEN ft.days_since_breach IS NULL
                THEN CONCAT(
                    'Tenant has ',
                    ft.open_breach_count,
                    ' Active breach',
                    CASE WHEN ft.open_breach_count = 1 THEN '' ELSE 'es' END,
                    '.'
                )
            ELSE CONCAT(
                'Oldest ''New'' or ''Notice sent'' breach is ',
                ft.days_since_breach,
                ' day',
                CASE WHEN ft.days_since_breach = 1 THEN '' ELSE 's' END,
                ' old. Tenant has ',
                ft.open_breach_count,
                ' Active breach',
                CASE WHEN ft.open_breach_count = 1 THEN '' ELSE 'es' END,
                '.'
            )
        END AS user_friendly_score_explanation,
        CASE
            WHEN (sk.kpi_g_sign = '>=' AND ft.kpi_value >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>' AND ft.kpi_value > sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND ft.kpi_value <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<' AND ft.kpi_value < sk.kpi_g_value)
                OR (sk.kpi_g_sign = '=' AND ft.kpi_value = sk.kpi_g_value)
                THEN 3
            WHEN (sk.kpi_a_sign = '>=' AND ft.kpi_value >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>' AND ft.kpi_value > sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND ft.kpi_value <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<' AND ft.kpi_value < sk.kpi_a_value)
                OR (sk.kpi_a_sign = '=' AND ft.kpi_value = sk.kpi_a_value)
                THEN 2
            ELSE 1
        END AS kpi_status,
        @SnapshotDate AS snapshot_date
    FROM #FinalTable ft
    CROSS JOIN #SelectedKPI sk
    LEFT JOIN #Service_type_grouping stg
        ON sk.dim_kpi_key = stg.dim_kpi_key
        AND ft.service_id = stg.service_id
    LEFT JOIN #ms_count mc
        ON mc.kpi_id = sk.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
       OR (stg.service_id IS NOT NULL);

END