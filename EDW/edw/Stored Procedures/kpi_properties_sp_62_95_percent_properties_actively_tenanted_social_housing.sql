CREATE   PROCEDURE [edw].[kpi_properties_sp_62_95_percent_properties_actively_tenanted_social_housing]
AS

/**********************************************************************************************************
 Procedure: [edw].[kpi_properties_sp_62_95_percent_properties_actively_tenanted_social_housing]
 Author:    Mike Ryan
 Modified:  Timi Boddington
 Created:   30-06-2025
 Purpose:   Calculates the KPI for the percentage of properties that are actively tenanted within the
            "Social Housing" program, for KPI ID 62. Determines tenancy status of each property,
            maps properties to services, and evaluates KPI status (Green/Amber/Red) based on
            threshold values defined in the KPI metadata.
 
 Notes: Converted from view [edw].[kpi_properties_62_95_percent_properties_actively_tenanted_social_housing]
        Optimized with temp tables and strategic indexes for improved performance
        dim_company_key sourced from vw_dim_service (can be NULL if no service match)
 
 User Story: 10181 and 8791
 =========================================================================================================
 REVISIONS:
 Version   Date        Author              Description
 -------   ----------  ------------------  --------------------------
 1.0       30-06-2025  Timi Boddington     Added MS_Count table and bridge tables. Fixed Social Housing hard coding.
 1.1       06-08-2025  Timi Boddington     Removed Vacant: Untenantable, parent properties, disposal date filters
 1.2       26-08-2025  Timi Boddington     Changed occupied flag to include property_status = 'occupied', 
                                           added Motels (CLS) exclusion per bug 11134
 2.0       2025-12-29  Greg Nuthall        Converted to optimized stored procedure with temp tables
 2.2       16-03-2026  Timi Boddington     Changing user friendly score explanation - also adding days difference between today and relettable date
                                           also changed @today to NZ time instead of getdate()
 2.3       13-05-2026  Timi Boddington     Using service type was too restrictive.  Housing wanted Affordable Housing Management and Boarding added
                                            But Hapai Housing needed to be excluded.
**********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

        ------------------------------------------------------------
        -- Get KPI metadata (cache in variables)
        ------------------------------------------------------------
        DECLARE @dim_kpi_key INT;
        DECLARE @kpi_id INT = 62;
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
            AND dk.kpi_id = 62
        ORDER BY dk.dim_kpi_key DESC;

        -- Cache current date
        --DECLARE @today DATE = CAST(GETDATE() AS DATE);  -- changing this to UTC
        DECLARE @today DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);

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
            AND dsg.dwhiscurrent = 1
        LEFT JOIN edw.bridge_kpi_service_type_to_grouping bs WITH (NOLOCK)
            ON bm.dim_kpi_service_type_grouping_key = bs.dim_kpi_service_type_grouping_key
        LEFT JOIN edw.dim_kpi_service_type dst WITH (NOLOCK)
            ON bs.dim_kpi_service_type_key = dst.dim_kpi_service_type_key
        LEFT JOIN edw.dim_service ds WITH (NOLOCK)
            ON dst.service_type = ds.service_type_name
            AND ds.dwhiscurrent = 1
            AND ds.dwhdmloperation <> 'D'
        WHERE dk.dwhiscurrent = 1
            AND dk.kpi_id = @kpi_id
       --====== User Story   13206 - add in Rotorua Lakes Council - missing because it doesn't have a service type.  Manually added in here.  Timi
            union all
            select @kpi_id,
            @dim_kpi_key,
            service_id 
            from edw.dim_property 
            inner join edw.dim_service on dim_property.property_bc_service_code = dim_service.service_code
            where property_program in ( 'affordable housing management','Boarding')  -- also added boarding - additional request from  housing
            and property_sub_program not in ('Hapai Housing')
            and dim_property.DWHIsCurrent = 1 and dim_property.DWHDMLOperation <> 'd'

        -- Index for join operations
        CREATE NONCLUSTERED INDEX IX_service_grouping_join
            ON #service_type_grouping (dim_kpi_key, service_id)
            WHERE service_id IS NOT NULL;

        ------------------------------------------------------------
        -- Temp Table 2: Service Count (0 = all services, >0 = filtered)
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
        FROM #service_type_grouping
        WHERE kpi_id = @kpi_id;

        -- No index needed - single row table

        ------------------------------------------------------------
        -- Temp Table 3: Current Properties (filtered and joined)
        -- dim_company_key comes from vw_dim_service (first join only, as per original view)
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#dim_current_properties') IS NOT NULL
            DROP TABLE #dim_current_properties;

        CREATE TABLE #dim_current_properties (
            dim_company_key INT NULL,              -- Can be NULL if no service match
            dim_service_key INT NULL,              -- Can be NULL from COALESCE
            dim_property_key INT NOT NULL,
            property_id UNIQUEIDENTIFIER NOT NULL,
            property_status NVARCHAR(200),
            days_vacant INT NULL, --added Timi 16-03-2026
            service_name NVARCHAR(200),
            service_id INT,
            currently_tenanted_flag BIT NOT NULL
            ,property_sub_program nvarchar(200)
            ,property_program nvarchar(200)
        );




        INSERT INTO #dim_current_properties WITH (TABLOCK)
        SELECT 
            vds.dim_company_key,  -- From first service join only (matches original view)
            COALESCE(vds.dim_service_key, vds2.dim_service_key) AS dim_service_key,
            vdp.dim_property_key,
            vdp.property_id,
            vdp.property_status,
            DATEDIFF(DAY,CAST(vdp.property_relettable_date as date),@today) as days_vacant,  --added Timi 16-03-2026
            COALESCE(vds.service_name, vds2.service_name) AS service_name,
            COALESCE(vds.service_id, vds2.service_id) AS service_id,
            CASE WHEN vdp.property_current_tenancy IS NULL THEN 0 ELSE 1 END AS currently_tenanted_flag,
            property_sub_program,
            property_program 
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
            AND vdp.property_name NOT LIKE '%parent%'
            AND ISNULL(vdp.property_confirmed_disposal_date, '2099-12-31') >= @today
            AND ISNULL(vdp.property_acquired_date, '2099-12-31') <= @today
            AND vdp.property_statecode = 'Active'
            AND vdp.property_status NOT IN ('vacant: un-tenantable')
            AND vdp.property_sub_program NOT IN ('Motels', 'Motels (CLS)')
                      
            ;

              -- Index for service filtering join
        CREATE NONCLUSTERED INDEX IX_current_properties_service
            ON #dim_current_properties (service_id, dim_property_key)
            INCLUDE (dim_company_key, dim_service_key, property_id, property_status, service_name, currently_tenanted_flag)
            WHERE service_id IS NOT NULL;

        ------------------------------------------------------------
        -- Temp Table 4: Properties with Adjusted Tenancy Flag
        -- Business rule: property_status = 'occupied' overrides tenancy flag
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#dim_current_properties_2') IS NOT NULL
            DROP TABLE #dim_current_properties_2;

        CREATE TABLE #dim_current_properties_2 (
            dim_company_key INT NULL,
            dim_service_key INT NULL,
            dim_property_key INT NOT NULL,
            property_id UNIQUEIDENTIFIER NOT NULL,
            service_id INT,
            currently_tenanted_flag BIT NOT NULL,
            days_vacant INT NULL --added Timi 16-03-2026
            ,property_sub_program nvarchar(200)
            ,property_program nvarchar(200)
          
        );

        INSERT INTO #dim_current_properties_2 WITH (TABLOCK)
        SELECT 
            dcp.dim_company_key,
            dcp.dim_service_key,
            dcp.dim_property_key,
            dcp.property_id,
            dcp.service_id,
            -- Business rule: property_status = 'occupied' forces flag to 1
            CASE 
                WHEN dcp.property_status = 'occupied' THEN 1
                ELSE dcp.currently_tenanted_flag 
            END AS currently_tenanted_flag,
            days_vacant -- added Timi 16-03-2026,
          ,property_sub_program
          ,property_program 
          
        FROM #dim_current_properties dcp
        LEFT JOIN edw.dim_service ds WITH (NOLOCK)
            ON dcp.service_id = ds.service_id
            AND ds.dwhdmloperation <> 'D'
            AND ds.dwhiscurrent = 1
        LEFT JOIN edw.dim_kpi_service_type dkst WITH (NOLOCK)
            ON ds.service_type_name = dkst.service_type
            AND dkst.DWHIsCurrent = 1
        LEFT JOIN edw.bridge_kpi_service_type_to_grouping bsg WITH (NOLOCK)
            ON dkst.dim_kpi_service_type_key = bsg.dim_kpi_service_type_key
        LEFT JOIN edw.dim_kpi_service_type_grouping dsg WITH (NOLOCK)
            ON bsg.service_type_grouping_id = dsg.service_type_grouping_id
            AND dsg.DWHIsCurrent = 1
        WHERE dcp.dim_service_key IS NOT NULL;
             
       

        -- Index for final filtering
        CREATE NONCLUSTERED INDEX IX_current_properties_2_filter
            ON #dim_current_properties_2 (service_id, dim_property_key)
            INCLUDE (dim_company_key, dim_service_key, property_id, currently_tenanted_flag)
            WHERE service_id IS NOT NULL;

        ------------------------------------------------------------
        -- Return final results with KPI calculations and service filtering
        ------------------------------------------------------------

        if object_id ('tempdb..#finalfinal') is not null drop table #finalfinal 

        SELECT
            @dim_kpi_key AS dim_kpi_key,
            dcp2.dim_company_key,
            dcp2.dim_property_key,
            dcp2.dim_service_key,
            CONCAT('777_', dcp2.property_id, '_', dcp2.service_id, '_', dcp2.dim_company_key) AS entity_key,
            @kpi_id as kpi_id,
            dcp2.property_id,
            dcp2.service_id,
            dcp2.currently_tenanted_flag AS kpi_value,
            CASE 
                WHEN dcp2.currently_tenanted_flag = 0 THEN concat('Property has been ready to tenant for ' ,isnull(days_vacant,0),' days')
                ELSE 'Property tenanted' 
            END AS user_friendly_score_explanation,
          
            -- KPI Status calculation
            CASE 
                WHEN dcp2.currently_tenanted_flag IS NULL THEN 1
                WHEN 
                    (@kpi_g_sign = '>=' AND dcp2.currently_tenanted_flag >= @kpi_g_value) OR
                    (@kpi_g_sign = '>'  AND dcp2.currently_tenanted_flag >  @kpi_g_value) OR
                    (@kpi_g_sign = '<=' AND dcp2.currently_tenanted_flag <= @kpi_g_value) OR
                    (@kpi_g_sign = '<'  AND dcp2.currently_tenanted_flag <  @kpi_g_value) OR
                    (@kpi_g_sign = '='  AND dcp2.currently_tenanted_flag =  @kpi_g_value)
                THEN 3
                WHEN 
                    (@kpi_a_sign = '>=' AND dcp2.currently_tenanted_flag >= @kpi_a_value) OR
                    (@kpi_a_sign = '>'  AND dcp2.currently_tenanted_flag >  @kpi_a_value) OR
                    (@kpi_a_sign = '<=' AND dcp2.currently_tenanted_flag <= @kpi_a_value) OR
                    (@kpi_a_sign = '<'  AND dcp2.currently_tenanted_flag <  @kpi_a_value) OR
                    (@kpi_a_sign = '='  AND dcp2.currently_tenanted_flag =  @kpi_a_value)
                THEN 2
                ELSE 1
            END AS kpi_status,
            CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE) AS snapshot_date
        FROM #dim_current_properties_2 dcp2
        LEFT JOIN #service_type_grouping stg
            ON stg.dim_kpi_key = @dim_kpi_key
            AND stg.service_id = dcp2.service_id
        LEFT JOIN #ms_count mc
            ON mc.kpi_id = @kpi_id
        WHERE
            -- If KPI has no mapped services => service_count=0 => keep all
           ( (mc.service_count IS NULL OR mc.service_count = 0)
            OR
            -- If KPI does have mapped services => keep only those that appear in service_type_grouping
            (stg.service_id IS NOT NULL))
            OR property_program = 'Boarding';
                       
            
            --order by user_friendly_score_explanation desc
                       
END