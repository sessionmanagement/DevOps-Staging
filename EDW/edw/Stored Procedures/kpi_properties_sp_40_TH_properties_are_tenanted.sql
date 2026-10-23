CREATE   PROCEDURE [edw].[kpi_properties_sp_40_TH_properties_are_tenanted]

AS

/**********************************************************************************************************
 Procedure: [edw].[kpi_properties_sp_40_TH_properties_are_tenanted]
 Author: Mike Ryan / Timi Boddington / Greg Nuthall
 Created: 2025-07-02		
 Purpose: Evaluates the tenancy status of properties for KPI ID 40.
          For each property, determines if it is currently tenanted, and assigns a KPI status 
          (Green/Amber/Red) based on thresholds defined in [edw].[dim_kpi].
 User Story: 10180 and 8787

 Notes: Converted from view [edw].[kpi_properties_40_TH_properties_are_tenanted] 
        to stored procedure with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-07-02   Timi Boddington     Adding the extra KPI tables in ie ms_counts etc
 1.1       2025-08-11   Timi Boddington     Getting rid of acquired in future, tidying disposals, removing Vacant Untenantable
                                            and parent properties
 1.2       2025-09-08   Timi Boddington     Putting vacant untenantable back in
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 2.1       2025-01-15   Greg Nuthall        Fixed NULL dim_company_key and temp table reference issues
 2.2       16-03-2026   Timi Boddington     Changing user friendly score explanation - also adding days difference between today and relettable date
 2.3       08-04-2026    Timi Boddington     Excluding offices and commercial buildings from the KPI

 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 40;

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
    -- Temp Table 5: dim_current_properties
    -- FIX: Use COALESCE to handle NULL dim_company_key
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_properties') IS NOT NULL DROP TABLE #dim_current_properties;
    
    SELECT
        COALESCE(vw_dim_service.dim_company_key, dim_service_2.dim_company_key, 1) AS dim_company_key,
        COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) AS dim_service_key,
        vw_dim_property.dim_property_key,
        vw_dim_property.property_id,
        COALESCE(vw_dim_service.service_name, dim_service_2.service_name) AS service_name,
        COALESCE(vw_dim_service.service_id, dim_service_2.service_id) AS service_id,
        CASE WHEN vw_dim_property.property_current_tenancy IS NULL THEN 0 ELSE 1 END AS currently_tenanted_flag,
        DATEDIFF(DAY,CAST(vw_dim_property.property_relettable_date as date),@SnapshotDate) as days_vacant  --added Timi 16-03-2026
    INTO #dim_current_properties
    FROM edw.vw_dim_property
    LEFT JOIN edw.vw_dim_service
        ON vw_dim_property.property_contract_bc_service_code = vw_dim_service.service_code
        AND vw_dim_service.DWHIsCurrent = 1
        AND vw_dim_service.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service AS dim_service_2
        ON vw_dim_property.property_bc_service_code = dim_service_2.service_code
        AND dim_service_2.DWHIsCurrent = 1
        AND dim_service_2.DWHDMLOperation <> 'D'
    WHERE vw_dim_property.DWHIsCurrent = 1
        AND vw_dim_property.DWHDMLOperation <> 'D'
        AND vw_dim_property.dim_property_key > 0
        AND vw_dim_property.property_statecode = 'Active'
        AND vw_dim_property.property_name NOT LIKE '%parent%'
        AND ISNULL(vw_dim_property.property_confirmed_disposal_date, '2099-12-31') >= GETDATE()
        AND ISNULL(vw_dim_property.property_acquired_date, '2099-12-31') <= GETDATE()
        AND ISNULL(vw_dim_property.property_status, '') NOT IN ('vacant: Un-tenantable')
        AND property_sub_program NOT IN ('Motels', 'Motels (CLS)')
        -- added 8 April 2026
        AND property_sub_program = 'Transitional Housing'
        AND property_sub_property_type not in ('Office')
        ;

    CREATE CLUSTERED INDEX IX_dim_current_properties ON #dim_current_properties(dim_property_key);
    CREATE NONCLUSTERED INDEX IX_dim_current_properties_service ON #dim_current_properties(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: dim_current_properties_2
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_properties_2') IS NOT NULL DROP TABLE #dim_current_properties_2;
    
    SELECT
        dcp.dim_company_key,
        dcp.dim_service_key,
        dcp.dim_property_key,
        dcp.property_id,
        dcp.service_name,
        dcp.service_id,
        dim_kpi_service_type_grouping.service_type_grouping,
        dcp.currently_tenanted_flag,
        dcp.days_vacant
    INTO #dim_current_properties_2
    FROM #dim_current_properties dcp
    LEFT JOIN edw.dim_service
        ON dcp.service_id = dim_service.service_id
        AND dim_service.dwhdmloperation <> 'D'
        AND dim_service.dwhiscurrent = 1
    LEFT JOIN edw.dim_kpi_service_type
        ON dim_service.service_type_name = dim_kpi_service_type.service_type
        AND dim_kpi_service_type.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON dim_kpi_service_type.dim_kpi_service_type_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key
    LEFT JOIN edw.dim_kpi_service_type_grouping
        ON bridge_kpi_service_type_to_grouping.service_type_grouping_id = dim_kpi_service_type_grouping.service_type_grouping_id
        AND dim_kpi_service_type_grouping.DWHIsCurrent = 1
    WHERE dcp.dim_service_key IS NOT NULL;

    CREATE CLUSTERED INDEX IX_dim_current_properties_2 ON #dim_current_properties_2(dim_property_key);

    -------------------------------------------------------------------------------
    -- Temp Table 7: final_table
    -- FIX: Reference #dim_current_properties_2 (temp table) not CTE name
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    
    SELECT
        CONCAT('777', '_', dcp2.property_id, '_', dcp2.service_id, '_', dcp2.dim_company_key) AS entity_key,
        dcp2.property_id,
        dcp2.dim_property_key,
        dcp2.currently_tenanted_flag AS kpi_value,
        CASE 
            WHEN dcp2.currently_tenanted_flag = 0 THEN concat('Property has been ready to tenant for ' ,isnull(days_vacant,0),' days')
            ELSE 'Property tenanted'
        END AS user_friendly_score_explanation,
        dcp2.dim_service_key,
        dcp2.service_id,
        dcp2.dim_company_key
    INTO #final_table
    FROM #dim_current_properties_2 dcp2;

    CREATE NONCLUSTERED INDEX IX_final_table ON #final_table(service_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_property_key,
        ft.dim_service_key,
        ft.entity_key,
        @KPI_ID AS kpi_id,
        ft.property_id,
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

end