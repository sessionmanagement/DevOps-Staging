
CREATE   PROCEDURE [edw].[kpi_properties_sp_64_3_monthly_inspection_check_complete]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_properties_sp_64_3_monthly_inspection_check_complete]
 Author:    Mike Ryan
 Modified:  Timi Boddington
 Created:   25-01-2025
 Purpose:   Calculates the KPI for properties that have had a completed inspection within the last 
            3 months (90 days). Designed to support KPI ID 64, as defined in [edw].[dim_kpi]. 
            Determines, for each property, the number of days since the last completed inspection 
            (or since acquisition if no inspection exists), and evaluates the KPI status 
            (Green/Amber/Red) based on threshold values.
 
 Notes: Converted from view [edw].[kpi_properties_64_3_monthly_inspection_check_complete]
        Optimized with temp tables and strategic indexes for improved performance
        Uses NZ timezone for date calculations
 
 User Story: 10182 and 8795
 =========================================================================================================
 REVISIONS:
 Version   Date        Author              Description
 -------   ----------  ------------------  --------------------------
 1.0       25-05-2025  Mike Ryan           Initial version
 1.1       08-07-2025  Timi Boddington     Add the new programme
 1.2       14-08-2025  Timi Boddington     Modified
 1.3       26-08-2025  Timi Boddington     Post Jacky testing. Changed date join from property_inspection_date_key 
                                           to property_inspection_completion_date_key
 1.4       13-11-2025  Timi Boddington     Added inspection category and inspection type filters
 1.5       10-12-2025  Timi Boddington     Added clause to remove Vacant: untenantable, Vacant: tenantable
 2.0       2025-12-29  Greg Nuthall        Converted to optimized stored procedure with temp tables
 2.1       2025-12-29  Greg Nuthall        Fixed NULL property_id filter in fact_property_inspection
 1.6       2025-03-03  Timi Boddington     Adding Property Condition Report - see Pae Awhina 104308 - line 153
**********************************************************************************************************/
BEGIN
    --SET NOCOUNT ON;
    --SET XACT_ABORT ON;

        ------------------------------------------------------------
        -- Get KPI metadata (cache in variables)
        ------------------------------------------------------------
        DECLARE @dim_kpi_key INT;
        DECLARE @kpi_id INT = 64;
        DECLARE @kpi_g_value DECIMAL(18,4);
        DECLARE @kpi_a_value DECIMAL(18,4);
        DECLARE @kpi_g_sign VARCHAR(10);
        DECLARE @kpi_a_sign VARCHAR(10);

        SELECT TOP 1
            @kpi_id = dk.kpi_id,
            @dim_kpi_key = dk.dim_kpi_key,
            @kpi_g_value = dk.kpi_g_value,
            @kpi_a_value = dk.kpi_a_value,
            @kpi_g_sign = dk.kpi_g_sign,
            @kpi_a_sign = dk.kpi_a_sign
        FROM edw.dim_kpi dk WITH (NOLOCK)
        WHERE dk.DWHDMLOperation <> 'D'
            AND dk.DWHIsCurrent = 1
            AND dk.kpi_id = 64
        ORDER BY dk.dim_kpi_key DESC;

        -- Cache current datetime (NZ timezone)
        DECLARE @today_nz DATETIME = CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')));
        DECLARE @today_date DATE = CAST(@today_nz AS DATE);

        ------------------------------------------------------------
        -- Temp Table 1: Service Type Grouping (KPI-to-Service mapping)
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL
            DROP TABLE #service_type_grouping;

        CREATE TABLE #service_type_grouping (
            kpi_id INT NOT NULL,
            dim_kpi_key INT NOT NULL,
            service_id INT NULL
        );

        INSERT INTO #service_type_grouping WITH (TABLOCK)
        SELECT DISTINCT
            dk.kpi_id,
            dk.dim_kpi_key,
            ds.service_id
        FROM edw.dim_kpi dk WITH (NOLOCK)
        LEFT JOIN edw.bridge_kpi_measure_to_service_type_group bm WITH (NOLOCK)
            ON dk.dim_kpi_key = bm.dim_kpi_key
        LEFT JOIN edw.dim_kpi_service_type_grouping dsg WITH (NOLOCK)
            ON bm.service_type_grouping_id = dsg.dim_kpi_service_type_grouping_key
            AND dsg.DWHIsCurrent = 1
        LEFT JOIN edw.bridge_kpi_service_type_to_grouping bs WITH (NOLOCK)
            ON bm.dim_kpi_service_type_grouping_key = bs.dim_kpi_service_type_grouping_key
        LEFT JOIN edw.dim_kpi_service_type dst WITH (NOLOCK)
            ON bs.dim_kpi_service_type_key = dst.dim_kpi_service_type_key
            AND dst.DWHIsCurrent = 1
        LEFT JOIN edw.dim_service ds WITH (NOLOCK)
            ON dst.service_type = ds.service_type_name
            AND ds.DWHIsCurrent = 1
        WHERE dk.DWHIsCurrent = 1
            AND dk.kpi_id = @kpi_id;

        -- Index for join operations
        CREATE NONCLUSTERED INDEX IX_service_grouping_join
            ON #service_type_grouping (dim_kpi_key, service_id)
            WHERE service_id IS NOT NULL;

        ------------------------------------------------------------
        -- Temp Table 2: Service Count
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL
            DROP TABLE #ms_count;

        CREATE TABLE #ms_count (
            kpi_id INT NOT NULL,
            service_count INT NOT NULL
        );

        INSERT INTO #ms_count WITH (TABLOCK)
        SELECT 
            @kpi_id AS kpi_id,
            COUNT(service_id) AS service_count
        FROM #service_type_grouping;

        ------------------------------------------------------------
        -- Temp Table 3: Latest Inspection Date by Property
        -- CRITICAL FIX: Filter out NULL property_id values
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#latest_inspection') IS NOT NULL
            DROP TABLE #latest_inspection;

        CREATE TABLE #latest_inspection (
            property_id UNIQUEIDENTIFIER NOT NULL,
            latest_property_inspection_date DATE NULL
        );

        INSERT INTO #latest_inspection WITH (TABLOCK)
        SELECT
            fpi.property_id,
            MAX(TRY_CONVERT(DATE, 
                IIF(fpi.property_inspection_completion_date_key = 0, NULL, 
                CONVERT(VARCHAR(8), fpi.property_inspection_completion_date_key)))) AS latest_property_inspection_date
        FROM [edw].[fact_property_inspection] fpi WITH (NOLOCK)
        WHERE fpi.property_id IS NOT NULL  -- CRITICAL FIX: Exclude NULL property_id
            AND fpi.DWHDMLOperation <> 'D'
            AND (fpi.property_inspection_is_delete_flag IS NULL OR fpi.property_inspection_is_delete_flag = 0)
            AND fpi.property_inspection_status = 'Completed'
            AND fpi.property_inspection_category IN ('Tenancy Routine Inspection', 'Tenancy Inspection Report',
            'Property Condition Report'
            )
            AND fpi.property_inspection_type IN (
                'Outgoing tenancy',
                'Residential condition inspection',
                'Welcome Inspection',
                'Routine tenancy',
                'Ingoing tenancy',
                'Ad-hoc Inspection',
                'Pre-vacate Inspection'
            )
        GROUP BY fpi.property_id;

        -- Index for LEFT JOIN in final query
        CREATE NONCLUSTERED INDEX IX_latest_inspection_join
            ON #latest_inspection (property_id)
            INCLUDE (latest_property_inspection_date);

        ------------------------------------------------------------
        -- Temp Table 4: Current Properties (filtered and joined)
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#dim_current_properties') IS NOT NULL
            DROP TABLE #dim_current_properties;

        CREATE TABLE #dim_current_properties (
            dim_company_key INT NULL,
            dim_service_key INT NULL,
            dim_property_key INT NOT NULL,
            property_id UNIQUEIDENTIFIER NOT NULL,
            property_sub_program NVARCHAR(200),
            property_name NVARCHAR(500),
            property_status NVARCHAR(200),
            service_name NVARCHAR(200),
            service_id INT,
            currently_tenanted_flag BIT NOT NULL
        );

        INSERT INTO #dim_current_properties WITH (TABLOCK)
        SELECT
            vds.dim_company_key,
            COALESCE(vds.dim_service_key, vds2.dim_service_key) AS dim_service_key,
            vdp.dim_property_key,
            vdp.property_id,
            vdp.property_sub_program,
            vdp.property_name,
            vdp.property_status,
            COALESCE(vds.service_name, vds2.service_name) AS service_name,
            COALESCE(vds.service_id, vds2.service_id) AS service_id,
            CASE WHEN vdp.property_current_tenancy IS NULL THEN 0 ELSE 1 END AS currently_tenanted_flag
        FROM [edw].[vw_dim_property] vdp WITH (NOLOCK)
        LEFT JOIN [edw].[vw_dim_service] vds WITH (NOLOCK)
            ON vdp.property_contract_bc_service_code = vds.service_code
            AND vds.DWHIsCurrent = 1
            AND vds.DWHDMLOperation <> 'D'
        LEFT JOIN edw.vw_dim_service vds2 WITH (NOLOCK)
            ON vdp.property_bc_service_code = vds2.service_code
            AND vds2.DWHIsCurrent = 1
            AND vds2.DWHDMLOperation <> 'D'
        WHERE vdp.DWHIsCurrent = 1
            AND vdp.DWHDMLOperation <> 'D'
            AND vdp.dim_property_key > 0
            AND vdp.property_statecode = 'Active'
            AND vdp.property_name NOT LIKE '%parent%'
            AND ISNULL(vdp.property_confirmed_disposal_date, '2099-12-31') >= @today_date
            AND ISNULL(vdp.property_acquired_date, '2099-12-31') <= @today_date
            AND vdp.property_sub_program NOT IN ('motels', 'motels (cls)')
            AND ISNULL(vdp.property_status, '') NOT IN ('vacant: un-tenantable', 'vacant: tenantable');

        -- Index for service join
        CREATE NONCLUSTERED INDEX IX_current_properties_service
            ON #dim_current_properties (service_id, dim_property_key)
            INCLUDE (dim_company_key, dim_service_key, property_id, property_sub_program, property_name, 
                     property_status, service_name, currently_tenanted_flag)
            WHERE service_id IS NOT NULL;

        -- Index for property_id join with inspections
        CREATE NONCLUSTERED INDEX IX_current_properties_property_id
            ON #dim_current_properties (property_id)
            INCLUDE (dim_property_key);

        ------------------------------------------------------------
        -- Temp Table 5: Properties with Service Type Info
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#dim_current_properties_2') IS NOT NULL
            DROP TABLE #dim_current_properties_2;

        CREATE TABLE #dim_current_properties_2 (
            dim_company_key INT NULL,
            dim_service_key INT NULL,
            dim_property_key INT NOT NULL,
            property_id UNIQUEIDENTIFIER NOT NULL,
            property_sub_program NVARCHAR(200),
            property_name NVARCHAR(500),
            service_name NVARCHAR(200),
            service_id INT,
            service_type_name NVARCHAR(200),
            currently_tenanted_flag BIT NOT NULL
        );

        INSERT INTO #dim_current_properties_2 WITH (TABLOCK)
        SELECT 
            dcp.dim_company_key,
            dcp.dim_service_key,
            dcp.dim_property_key,
            dcp.property_id,
            dcp.property_sub_program,
            dcp.property_name,
            dcp.service_name,
            dcp.service_id,
            ds.service_type_name,
            dcp.currently_tenanted_flag
        FROM #dim_current_properties dcp
        LEFT JOIN edw.dim_service ds WITH (NOLOCK)
            ON dcp.service_id = ds.service_id
            AND ds.dwhdmloperation <> 'D'
            AND ds.dwhiscurrent = 1
        WHERE dcp.dim_service_key IS NOT NULL;

        -- Index for final query joins
        CREATE NONCLUSTERED INDEX IX_current_properties_2_join
            ON #dim_current_properties_2 (property_id, dim_property_key)
            INCLUDE (dim_company_key, dim_service_key, service_id, service_name, service_type_name, currently_tenanted_flag)
            WHERE service_id IS NOT NULL;

        ------------------------------------------------------------
        -- Return final results with inspection date calculations
        ------------------------------------------------------------
        SELECT
            @dim_kpi_key AS dim_kpi_key,
            dcp2.dim_company_key,
            dcp2.dim_property_key,
            dcp2.dim_service_key,
            CONCAT('777_', dcp2.property_id, '_', dcp2.service_id, '_', dcp2.dim_company_key) AS entity_key,
            @kpi_id,
            dcp2.property_id,
            dcp2.service_id,
            
                        
            -- KPI Value: Days since last inspection (or since acquisition)
            IIF(
                DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) 
                < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz),
                DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz),
                DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)
            ) AS kpi_value,
            -- User friendly explanation
            CASE 
                WHEN DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) <= 90 
                    THEN CONCAT('Property inspected ', DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), 
                                ' days ago on ', FORMAT(li.latest_property_inspection_date, 'dd/MM/yyyy'))
                WHEN DATEDIFF(DAY, vdp.property_acquired_date, @today_nz) <= 90 
                    THEN CONCAT('Property acquired ', DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), 
                                ' days ago on ', FORMAT(vdp.property_acquired_date, 'dd/MM/yyyy'))
                WHEN li.latest_property_inspection_date IS NOT NULL 
                    THEN CONCAT('Last inspection was ', DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), 
                                ' days ago on ', FORMAT(li.latest_property_inspection_date, 'dd/MM/yyyy'))
                ELSE CONCAT('No inspection recorded. Property acquired ', FORMAT(vdp.property_acquired_date, 'dd/MM/yyyy'))
            END AS user_friendly_score_explanation,
            -- KPI Status calculation
            CASE 
                WHEN IIF(
                        DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) 
                        < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz),
                        DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz),
                        DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)
                    ) IS NULL THEN 1
                WHEN 
                    (@kpi_g_sign = '>=' AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) >= @kpi_g_value) OR
                    (@kpi_g_sign = '>'  AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) >  @kpi_g_value) OR
                    (@kpi_g_sign = '<=' AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) <= @kpi_g_value) OR
                    (@kpi_g_sign = '<'  AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) <  @kpi_g_value) OR
                    (@kpi_g_sign = '='  AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) =  @kpi_g_value)
                THEN 3
                WHEN 
                    (@kpi_a_sign = '>=' AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) >= @kpi_a_value) OR
                    (@kpi_a_sign = '>'  AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) >  @kpi_a_value) OR
                    (@kpi_a_sign = '<=' AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) <= @kpi_a_value) OR
                    (@kpi_a_sign = '<'  AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) <  @kpi_a_value) OR
                    (@kpi_a_sign = '='  AND IIF(DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz) < DATEDIFF(DAY, vdp.property_acquired_date, @today_nz), DATEDIFF(DAY, li.latest_property_inspection_date, @today_nz), DATEDIFF(DAY, vdp.property_acquired_date, @today_nz)) =  @kpi_a_value)
                THEN 2
                ELSE 1
            END AS kpi_status,
            CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE) AS snapshot_date
        FROM #dim_current_properties_2 dcp2
        INNER JOIN [edw].[vw_dim_property] vdp WITH (NOLOCK)
            ON dcp2.dim_property_key = vdp.dim_property_key
        LEFT JOIN #latest_inspection li
            ON dcp2.property_id = li.property_id
        LEFT JOIN #service_type_grouping stg
            ON stg.dim_kpi_key = @dim_kpi_key
            AND stg.service_id = dcp2.service_id
        LEFT JOIN #ms_count mc
            ON mc.kpi_id = @kpi_id
        WHERE
            -- If KPI has no mapped services => keep all
            (mc.service_count IS NULL OR mc.service_count = 0)
            OR
            -- If KPI has mapped services => keep only those that appear in service_type_grouping
            (stg.service_id IS NOT NULL);



END