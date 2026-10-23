CREATE   PROCEDURE [edw].[kpi_tenancy_sp_39_signing_tenancy_agreement]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_tenancy_sp_39_signing_tenancy_agreement]
 Author: Mike Ryan / Timi Boddington / Greg Nuthall
 Created: 2025-05-22		
 Purpose: Evaluates the status of tenancy agreements for properties, supporting KPI ID 39.
          For each property, determines if a valid lease agreement or agreement to extend tenancy is in place,
          and assigns a KPI status (Green/Amber/Red) based on thresholds defined in [edw].[dim_kpi].
 User Story: 10179 and 8773

 Notes: Converted from view [edw].[kpi_tenancy_39_signing_tenancy_agreement] 
        to stored procedure with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-05-22   Mike Ryan           Initial version
 1.1       2025-07-02   Timi Boddington     Didn't have the extra KPI filter tables in it. Adding in
 1.2       2025-08-13   Timi Boddington     Changing it to Tenancy Focused not Property. Removed Motels
 1.3       2025-08-26   Timi Boddington     Added Motels (CLS) to the motel exclusions - Jacky's testing!
 1.4       2025-09-08   Timi Boddington     Removed Vacant Untenantable
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 39;

    -------------------------------------------------------------------------------
    -- Temp Table 1: selected_kpi
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
    -- Temp Table 2: service_type_grouping
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
        AND dim_service.dwhdmloperation <> 'd'
    WHERE dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = (SELECT kpi_id FROM #selected_kpi);

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 3: ms_count_0
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count_0') IS NOT NULL DROP TABLE #ms_count_0;
    
    SELECT
        (SELECT DISTINCT kpi_id FROM #selected_kpi) AS kpi_id,
        service_id
    INTO #ms_count_0
    FROM #service_type_grouping;

    -------------------------------------------------------------------------------
    -- Temp Table 4: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #ms_count_0
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Temp Table 5: dim_current_tenancies
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_tenancies') IS NOT NULL DROP TABLE #dim_current_tenancies;
    
    SELECT
        vw_dim_service.dim_company_key,
        vw_dim_property_tenancy.property_tenancy_id,
        vw_dim_property_tenancy.dim_property_tenancy_key,
        COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) AS dim_service_key,
        vw_dim_property.dim_property_key,
        vw_dim_property.property_id,
        vw_dim_property.property_sub_program,
        COALESCE(vw_dim_service.service_name, dim_service_2.service_name) AS service_name,
        COALESCE(vw_dim_service.service_id, dim_service_2.service_id) AS service_id,
        CASE WHEN vw_dim_property.property_current_tenancy IS NULL THEN 0 ELSE 1 END AS currently_tenanted_flag
    INTO #dim_current_tenancies
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
    WHERE 
        vw_dim_property_tenancy.DWHIsCurrent = 1
        AND vw_dim_property_tenancy.DWHDMLOperation <> 'D'
        AND vw_dim_property.dim_property_key > 0 
        AND vw_dim_property.property_statecode = 'Active'
        AND vw_dim_property_tenancy.property_tenant_opportunity_status IN ('new', 'active arrears', 'active')
        AND vw_dim_property.property_name NOT LIKE '%parent%'
        AND ISNULL(vw_dim_property.property_confirmed_disposal_date, '2099-12-31') >= GETDATE()
        AND ISNULL(vw_dim_property.property_acquired_date, '2099-12-31') <= GETDATE()
        AND ISNULL(vw_dim_property.property_status, '') NOT IN ('vacant: un-tenantable')
        AND ISNULL(vw_dim_property.property_sub_program, '') NOT IN ('Motels', 'Motels (CLS)');

    CREATE CLUSTERED INDEX IX_dim_current_tenancies ON #dim_current_tenancies(dim_service_key);
    CREATE NONCLUSTERED INDEX IX_dim_current_tenancies_property ON #dim_current_tenancies(dim_property_key, property_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: dim_current_tenancies_2
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_tenancies_2') IS NOT NULL DROP TABLE #dim_current_tenancies_2;
    
    SELECT
        vw_dim_service.dim_company_key,
        dct.dim_service_key,
        dct.dim_property_key,
        dct.property_id,
        dct.property_tenancy_id,
        dct.dim_property_tenancy_key,
        dct.service_id,
        dct.currently_tenanted_flag,
        dct.property_sub_program,
        dim_kpi_service_type_grouping.service_type_grouping
    INTO #dim_current_tenancies_2
    FROM #dim_current_tenancies dct
    LEFT JOIN edw.vw_dim_service
        ON dct.dim_service_key = vw_dim_service.dim_service_key
        AND vw_dim_service.dwhdmloperation <> 'D'
        AND vw_dim_service.dwhiscurrent = 1
    LEFT JOIN edw.dim_kpi_service_type
        ON vw_dim_service.service_type_name = dim_kpi_service_type.service_type
        AND dim_kpi_service_type.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON dim_kpi_service_type.dim_kpi_service_type_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key
    LEFT JOIN edw.dim_kpi_service_type_grouping
        ON bridge_kpi_service_type_to_grouping.service_type_grouping_id = dim_kpi_service_type_grouping.service_type_grouping_id
        AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
    WHERE dct.dim_service_key IS NOT NULL;

    CREATE CLUSTERED INDEX IX_dim_current_tenancies_2 ON #dim_current_tenancies_2(dim_property_key);
    CREATE NONCLUSTERED INDEX IX_dim_current_tenancies_2_service ON #dim_current_tenancies_2(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 7: final_table
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    
    SELECT
        CONCAT(
            '888', '_', dct2.property_tenancy_id, '_',
            dct2.service_id, '_', dct2.dim_company_key
        ) AS entity_key,
        dct2.dim_company_key,
        dct2.property_id,
        dct2.property_tenancy_id,
        dct2.dim_property_key,
        dct2.dim_property_tenancy_key,
        CASE
            WHEN vw_dim_property_tenancy.property_tenancy_lease_agreement_flag = 1
                OR vw_dim_property_tenancy.property_tenancy_agreement_to_extend_tenancy_received_flag = 1
                THEN 1
            ELSE 0
        END AS kpi_value,
        CASE
            WHEN vw_dim_property_tenancy.property_tenancy_lease_agreement_flag = 1
                THEN 'Housing agreement OK'
            WHEN vw_dim_property_tenancy.property_tenancy_agreement_to_extend_tenancy_received_flag = 1
                THEN 'Agreement to extend received'
            ELSE 'No agreement in place'
        END AS user_friendly_score_explanation,
        dct2.dim_service_key,
        dct2.service_id
    INTO #final_table
    FROM #dim_current_tenancies_2 dct2
    INNER JOIN edw.vw_dim_property dp
        ON dp.dim_property_key = dct2.dim_property_key
    INNER JOIN edw.vw_dim_property_tenancy
        ON dp.property_id = vw_dim_property_tenancy.property_id
    WHERE vw_dim_property_tenancy.DWHDMLOperation <> 'D'
        AND vw_dim_property_tenancy.DWHIsCurrent = 1
        AND vw_dim_property_tenancy.property_tenancy_vacate_confirmation_flag = 0
        AND vw_dim_property_tenancy.property_tenancy_actual_close_date IS NULL
        AND dct2.property_sub_program <> 'Motels';

    CREATE NONCLUSTERED INDEX IX_final_table ON #final_table(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_property_tenancy_key,
        ft.dim_service_key,
        ft.entity_key,
        @KPI_ID AS kpi_id,
        ft.property_tenancy_id,
        ft.service_id,
        ft.kpi_value,
        ft.user_friendly_score_explanation,
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
    FROM #final_table ft
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = ft.service_id
    LEFT JOIN #ms_count mc
        ON sk.kpi_id = mc.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);


END