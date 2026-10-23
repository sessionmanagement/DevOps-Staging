--[edw].[kpi_properties_sp_63_tenancy_inspections_last_12_months]
--drop procedure [edw].[kpi_properties_sp_63_tenancy_inspections_last_12_months]

CREATE   PROCEDURE [edw].[kpi_properties_sp_63_inspections]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_properties_sp_63_inspections]
 Author (Developer): Timi Boddington / Mike Gencic
 Author (Analyst): Julie Radcliffe 
 Created: 2026-06-08
 Purpose: Calculates the number of tenancy inspections performed for each property in the last 12 months.
          Supports KPI ID 63, as defined in [edw].[dim_kpi]. The procedure evaluates each property's inspection
          count, provides a user-friendly explanation, and assigns a KPI status (Green/Amber/Red) based on
          threshold values.

          Refined per User Story 13462 while retaining the PROPERTY grain:
            - Completed inspections only
            - Social Housing (SH) properties whose current tenancy has been active < 365 days are EXCLUDED
            - Transitional Housing (TH) is NOT subject to the 365-day rule (TH 'Office' sub property excluded)
            - Untenanted, untenantable, parent, future-acquired, disposed and Motels properties excluded
 User Story: 13462

 Notes: Property-grain variant of the refined KPI, derived from
        [edw].[kpi_properties_sp_63_tenancy_inspections_last_12_months]. The 365-day Social Housing rule and
        the 'currently tenanted' requirement are inherently tenancy attributes; at property grain they are
        evaluated against the property's CURRENT (most recent active) tenancy via [edw].[vw_dim_property_tenancy].
 =========================================================================================================

 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- ----------------------------------------------------------------
 1.0       2025-06-19   Mike Ryan           Initial version
 1.1       2025-07-08   Timi Boddington/MS  Modified and deployed to prod Add New programme
 1.2       2025-08-06   Timi Boddington     Allow for feedback. Removed parents, properties acquired in the future, properties
                                            with a disposal date. Added dwhiscurrent to join with dim_kpi_service_type. Removed Motels
 1.3       2025-08-26   Timi Boddington     Post Jacky Testing. Changed date join from property_inspection_date_key to property_inspection_completion_date_key
 1.4       2025-09-17   Timi Boddington     Pae Awhiina 86896. Wrong kpi_status programmed, had green instead of red.
 1.5       2025-11-13   Timi Boddington     Added property_inspection_type filter
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 1.6       2025-03-03   Timi Boddington     Adding Property Condition Report - see Pae Awhina 104308 - line 138
 3.0       2026-06-08   Mike Gencic         US 13462 refinement at property grain: completed inspections only,
                                            365-day Social Housing rule via current tenancy, currently tenanted
                                            requirement, untenantable exclusion, explicit SH/TH program whitelist,
                                            DISTINCT inspection count.
 **********************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 63;

    -------------------------------------------------------------------------------
    -- Temp Table 0: CurrentNZTime (single NZ 'today' used for all date comparisons)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#CurrentNZTime') IS NOT NULL DROP TABLE #CurrentNZTime;

    SELECT
        CAST(((GETUTCDATE() AT TIME ZONE 'UTC') AT TIME ZONE 'New Zealand Standard Time') AS DATE) AS CurrentDate
    INTO #CurrentNZTime;

    -------------------------------------------------------------------------------
    -- Temp Table 1: active_tenancy
    -- The property's current (most recent active) tenancy. Drives both the
    -- 'currently tenanted' requirement and the 365-day Social Housing rule.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#active_tenancy') IS NOT NULL DROP TABLE #active_tenancy;

    SELECT
        vw_dim_property_tenancy.property_id,
        MAX(vw_dim_property_tenancy.property_tenancy_tenancy_start_date) AS tenancy_start_date
    INTO #active_tenancy
    FROM edw.vw_dim_property_tenancy
    WHERE vw_dim_property_tenancy.DWHIsCurrent = 1
      AND vw_dim_property_tenancy.DWHDMLOperation <> 'D'
      AND vw_dim_property_tenancy.property_tenant_opportunity_status IN ('new', 'active arrears', 'active')
      AND vw_dim_property_tenancy.property_tenancy_vacate_confirmation_flag = 0
      AND vw_dim_property_tenancy.property_tenancy_actual_close_date IS NULL
    GROUP BY vw_dim_property_tenancy.property_id;

    CREATE CLUSTERED INDEX IX_active_tenancy ON #active_tenancy(property_id);

    -------------------------------------------------------------------------------
    -- Temp Table 2: dim_current_properties
    -- Qualifying, currently tenanted properties with the explicit SH/TH program
    -- and sub-program whitelist and the 365-day SH rule applied.
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_properties') IS NOT NULL DROP TABLE #dim_current_properties;

    SELECT
        vw_dim_service.dim_company_key,
        COALESCE(vw_dim_service.dim_service_key, dim_service_2.dim_service_key) AS dim_service_key,
        vw_dim_property.dim_property_key,
        vw_dim_property.property_id,
        vw_dim_property.property_program,
        vw_dim_property.property_sub_program,
        vw_dim_property.property_sub_property_type,
        COALESCE(vw_dim_service.service_name, dim_service_2.service_name) AS service_name,
        COALESCE(vw_dim_service.service_id, dim_service_2.service_id) AS service_id,
        1 AS currently_tenanted_flag
    INTO #dim_current_properties
    FROM edw.vw_dim_property
    CROSS JOIN #CurrentNZTime cnt
    INNER JOIN #active_tenancy at
        ON vw_dim_property.property_id = at.property_id
    LEFT JOIN edw.vw_dim_service
        ON vw_dim_property.property_contract_bc_service_code = vw_dim_service.service_code
        AND vw_dim_service.DWHIsCurrent = 1
        AND vw_dim_service.DWHDMLOperation <> 'D'
    LEFT JOIN edw.vw_dim_service dim_service_2
        ON vw_dim_property.property_bc_service_code = dim_service_2.service_code
        AND dim_service_2.DWHIsCurrent = 1
        AND dim_service_2.DWHDMLOperation <> 'D'
    WHERE vw_dim_property.DWHIsCurrent = 1
        AND vw_dim_property.DWHDMLOperation <> 'D'
        AND vw_dim_property.dim_property_key > 0
        AND vw_dim_property.property_statecode = 'Active'
        AND vw_dim_property.property_name NOT LIKE '%parent%'
        AND vw_dim_property.property_current_tenancy IS NOT NULL
        AND LOWER(ISNULL(vw_dim_property.property_status, '')) <> 'vacant: un-tenantable'
        AND ISNULL(vw_dim_property.property_confirmed_disposal_date, '2099-12-31') > cnt.CurrentDate
        AND ISNULL(vw_dim_property.property_acquired_date, '2099-12-31') <= cnt.CurrentDate
        AND ISNULL(vw_dim_property.property_program, '') <> 'Motels'
        AND ISNULL(vw_dim_property.property_sub_program, '') NOT IN ('Motels', 'Motels (CLS)')
        AND (
                (
                    -- Social Housing (SH): explicit whitelist + 365-day rule
                    (
                        (ISNULL(vw_dim_property.property_program, '') = 'Affordable Housing Management' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Rotorua Lakes Council')
                     OR (ISNULL(vw_dim_property.property_program, '') = 'Affordable Rental' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Affordable Rental')
                     OR (ISNULL(vw_dim_property.property_program, '') = 'Boarding' AND ISNULL(vw_dim_property.property_sub_program, '') = 'Residential Services Boarding')
                     OR (ISNULL(vw_dim_property.property_program, '') = 'IRRS' AND ISNULL(vw_dim_property.property_sub_program, '') IN (
                            'CCP (Creating Positive Pathways Spot)',
                            'Housing First (SPOT)',
                            'Social Housing (Capacity)',
                            'Social Housing (SPOT)',
                            'Social Housing TM'
                        ))
                    )
                    AND at.tenancy_start_date IS NOT NULL
                    AND DATEDIFF(DAY, at.tenancy_start_date, cnt.CurrentDate) >= 365
                )
             OR (
                    -- Transitional Housing (TH): NOT subject to the 365-day rule; exclude 'Office'
                    ISNULL(vw_dim_property.property_program, '') = 'Transitional Housing'
                AND ISNULL(vw_dim_property.property_sub_program, '') = 'Transitional Housing'
                AND ISNULL(vw_dim_property.property_sub_property_type, '') <> 'Office'
                )
        );

    CREATE CLUSTERED INDEX IX_dim_current_properties ON #dim_current_properties(property_id);
    CREATE NONCLUSTERED INDEX IX_dim_current_properties_service ON #dim_current_properties(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 3: dim_current_properties_2 (with service type grouping)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#dim_current_properties_2') IS NOT NULL DROP TABLE #dim_current_properties_2;

    SELECT
        dcp.dim_company_key,
        dcp.dim_service_key,
        dcp.dim_property_key,
        dcp.property_id,
        dcp.property_sub_program,
        dcp.service_id,
        stg.service_type_grouping,
        dcp.currently_tenanted_flag
    INTO #dim_current_properties_2
    FROM #dim_current_properties dcp
    LEFT JOIN edw.dim_service ds
        ON dcp.service_id = ds.service_id
        AND ds.DWHDMLOperation <> 'D'
        AND ds.DWHIsCurrent = 1
    LEFT JOIN edw.dim_kpi_service_type AS st
        ON ds.[service_type_name] = st.[service_type]
        AND st.DWHIsCurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping AS stgb
        ON st.dim_kpi_service_type_key = stgb.dim_kpi_service_type_key
    LEFT JOIN edw.dim_kpi_service_type_grouping AS stg
        ON stgb.service_type_grouping_id = stg.service_type_grouping_id
        AND stg.DWHIsCurrent = 1
    WHERE dcp.dim_service_key IS NOT NULL;

    CREATE CLUSTERED INDEX IX_dim_current_properties_2 ON #dim_current_properties_2(property_id);

    -------------------------------------------------------------------------------
    -- Temp Table 4: inspections (completed, qualifying, last 12 months)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#inspections') IS NOT NULL DROP TABLE #inspections;

    SELECT
        fact_property_inspection.dim_property_key,
        fact_property_inspection.property_id,
        fact_property_inspection.property_inspection_id
    INTO #inspections
    FROM edw.fact_property_inspection
    INNER JOIN edw.dim_date
        ON fact_property_inspection.property_inspection_completion_date_key = dim_date.dim_date_key
    WHERE fact_property_inspection.DWHDMLOperation <> 'D'
        AND fact_property_inspection.property_inspection_status = 'Completed'
        AND dim_date.current_date_rolling_month_offset BETWEEN -12 AND 0
        AND fact_property_inspection.property_inspection_category IN (
            'Tenancy Routine Inspection',
            'Tenancy Inspection Report',
            'Property Condition Report'
        )
        AND fact_property_inspection.property_inspection_type IN (
            'Ad-hoc Inspection',
            'Ingoing tenancy',
            'Outgoing tenancy',
            'Pre-vacate Inspection',
            'Residential condition inspection',
            'Routine tenancy',
            'Welcome Inspection'
        );

    CREATE CLUSTERED INDEX IX_inspections ON #inspections(property_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: count_inspections
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#count_inspections') IS NOT NULL DROP TABLE #count_inspections;

    SELECT
        property_id,
        CAST(COUNT(DISTINCT property_inspection_id) AS NUMERIC(8, 2)) AS kpi_value
    INTO #count_inspections
    FROM #inspections
    GROUP BY property_id;

    CREATE CLUSTERED INDEX IX_count_inspections ON #count_inspections(property_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: final_table
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;

    SELECT
        dcp2.dim_company_key,
        dcp2.dim_service_key,
        dcp2.dim_property_key,
        dcp2.property_id,
        dcp2.property_sub_program,
        dcp2.service_id,
        dcp2.service_type_grouping,
        dcp2.currently_tenanted_flag,
        ISNULL(ci.kpi_value, 0) AS kpi_value
    INTO #final_table
    FROM #dim_current_properties_2 dcp2
    LEFT JOIN #count_inspections ci
        ON dcp2.property_id = ci.property_id;

    CREATE NONCLUSTERED INDEX IX_final_table_service ON #final_table(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 7: selected_kpi
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#selected_kpi') IS NOT NULL DROP TABLE #selected_kpi;

    SELECT TOP 1
        dk.kpi_id,
        dk.dim_kpi_key,
        dk.what_is_measured,
        dk.kpi_g_value,
        dk.kpi_a_value,
        dk.kpi_g_sign,
        dk.kpi_a_sign
    INTO #selected_kpi
    FROM edw.dim_kpi dk
    WHERE dk.DWHDMLOperation <> 'D'
        AND dk.DWHIsCurrent = 1
        AND dk.kpi_id = @KPI_ID
    ORDER BY dk.dim_kpi_key DESC;

    -------------------------------------------------------------------------------
    -- Temp Table 8: service_type_grouping
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;

    SELECT
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_service.service_id
    INTO #service_type_grouping
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
        AND dim_kpi_service_type.DWHIsCurrent = 1
    LEFT JOIN edw.dim_service
        ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.DWHIsCurrent = 1
    WHERE dim_kpi.DWHIsCurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

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
    -- Final SELECT - property grain (entity_key prefix '777')
    -------------------------------------------------------------------------------
    SELECT
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_property_key,
        ft.dim_service_key,
        CONCAT('777', '_', ft.property_id, '_', ft.service_id, '_', ft.dim_company_key) AS entity_key,
        @KPI_ID AS kpi_id,
        ft.property_id,
        ft.service_id,
        ft.kpi_value,
        CASE
            WHEN ft.kpi_value IS NULL OR ft.kpi_value = 0 THEN 'No inspections performed during year'
            WHEN ft.kpi_value >= 4 THEN '4 or more inspections performed during year'
            WHEN ft.kpi_value >= 3 THEN '3 inspections performed during year'
            ELSE 'Less than 3 inspections performed during year'
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
    FROM #final_table ft
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg
        ON sk.dim_kpi_key = stg.dim_kpi_key
        AND ft.service_id = stg.service_id
    LEFT JOIN #ms_count mc
        ON mc.kpi_id = sk.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);

END