CREATE   PROCEDURE [edw].[kpi_kaimahi_sp_26_last_leave_taken]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_kaimahi_sp_26_last_leave_taken]
 Author:    Manish Singh
 Created:   24-01-2025
 Purpose:   Calculate 'Time since last leave was taken (months)' measure for KPI 26
 
 Notes: Converted from view [edw].[kpi_kaimahi_26_last_leave_taken]
        Optimized version with temp tables and strategic indexes
        Returns same result set as original view
 
 User Story: 9361-03-Create Source Query View for KPI-Kaimahi_leave related
 =========================================================================================================
 REVISIONS:
 Version   Date        Author              Description
 -------   ----------  ------------------  --------------------------
 1.0       24-01-2025  Manish Singh        Initial view creation
 2.0       12-02-2025  Mike Ryan           Removed columns derivable from dim_kpi
 3.0       21-03-2025  Greg Nuthall        Added service_id, changed status to 1,2,3
 4.0       2025-12-29  Greg Nuthall        Converted to optimized stored procedure with CTEs
 4.1       2025-12-29  Greg Nuthall        Converted CTEs to temp tables with strategic indexes
**********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        -- KPI metadata variables
        DECLARE @dim_kpi_key INT;
        DECLARE @kpi_g_value DECIMAL(18,4);
        DECLARE @kpi_a_value DECIMAL(18,4);
        DECLARE @kpi_g_sign VARCHAR(10);
        DECLARE @kpi_a_sign VARCHAR(10);
        DECLARE @KPI_ID INT = 26;

        -- Get KPI metadata (single lookup)
        SELECT TOP 1
            @dim_kpi_key = dk.dim_kpi_key,
            @kpi_g_value = dk.kpi_g_value,
            @kpi_a_value = dk.kpi_a_value,
            @kpi_g_sign = dk.kpi_g_sign,
            @kpi_a_sign = dk.kpi_a_sign
        FROM edw.dim_kpi dk WITH (NOLOCK)
        WHERE dk.DWHDMLOperation <> 'D'
            AND dk.DWHIsCurrent = 1
            AND dk.kpi_id = 26
        ORDER BY dk.dim_kpi_key DESC;

        -- Cache constants
        DECLARE @today DATE = CAST(GETDATE() AS DATE);
        DECLARE @payroll_category_annual_leave NVARCHAR(100) = 'Annual leave';

        ------------------------------------------------------------
        -- Temp Table 1: Leave records (annual leave with hours taken)
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#leave_records') IS NOT NULL
            DROP TABLE #leave_records;

        CREATE TABLE #leave_records (
            employee_id INT NOT NULL,
            dim_company_key INT NOT NULL,
            employee_leave_effective_date_key INT NOT NULL
        );

        INSERT INTO #leave_records WITH (TABLOCK)
        SELECT
            fel.employee_id,
            fel.dim_company_key,
            fel.employee_leave_effective_date_key
        FROM edw.vw_fact_employee_leave fel WITH (NOLOCK)
        INNER JOIN edw.vw_dim_payroll_category dpc WITH (NOLOCK)
            ON fel.dim_payroll_category_key = dpc.dim_payroll_category_key
        WHERE dpc.payroll_category_name = @payroll_category_annual_leave
            AND fel.employee_leave_taken_hours > 0  
            AND CONVERT(DATE, CONVERT(VARCHAR(8), fel.employee_leave_effective_date_key), 112) <= @today;

        -- Index for aggregation in next step
        CREATE NONCLUSTERED INDEX IX_leave_records_agg
            ON #leave_records (employee_id, dim_company_key)
            INCLUDE (employee_leave_effective_date_key);

        ------------------------------------------------------------
        -- Temp Table 2: Last leave date per employee
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#last_leave') IS NOT NULL
            DROP TABLE #last_leave;

        CREATE TABLE #last_leave (
            employee_id INT NOT NULL,
            dim_company_key INT NOT NULL,
            last_leave_effective_date_key INT NOT NULL
        );

        INSERT INTO #last_leave WITH (TABLOCK)
        SELECT
            lr.employee_id,
            lr.dim_company_key,
            MAX(lr.employee_leave_effective_date_key) AS last_leave_effective_date_key
        FROM #leave_records lr
        GROUP BY lr.employee_id, lr.dim_company_key;

        -- Index for LEFT JOIN in final query
        CREATE NONCLUSTERED INDEX IX_last_leave_join
            ON #last_leave (employee_id, dim_company_key)
            INCLUDE (last_leave_effective_date_key);

        ------------------------------------------------------------
        -- Temp Table 3: Combined results with KPI calculation
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#kpi_results') IS NOT NULL
            DROP TABLE #kpi_results;

        CREATE TABLE #kpi_results (
            employee_id INT NOT NULL,
            service_id INT,
            dim_company_key INT NOT NULL,
            dim_service_key INT NOT NULL,
            dim_employee_key INT NOT NULL,
            kpi_value INT NOT NULL,
            INDEX IX_kpi_results_clustered CLUSTERED (dim_employee_key)
        );

        INSERT INTO #kpi_results WITH (TABLOCK)
        SELECT DISTINCT
            em.employee_id,
            s.service_id,
            em.dim_company_key,
            em.dim_service_key,
            em.dim_employee_key,
            DATEDIFF(MONTH, 
                COALESCE(
                    CONVERT(DATE, CONVERT(VARCHAR(8), ll.last_leave_effective_date_key), 112),
                    e.employee_start_date
                ),
                @today
            ) AS kpi_value
        FROM edw.vw_current_employee em WITH (NOLOCK)
        INNER JOIN edw.vw_dim_employee e WITH (NOLOCK)
            ON em.dim_employee_key = e.dim_employee_key
        INNER JOIN edw.dim_service s WITH (NOLOCK)
            ON em.dim_service_key = s.dim_service_key 
        LEFT JOIN #last_leave ll 
            ON em.employee_id = ll.employee_id
            AND em.dim_company_key = ll.dim_company_key;

           

        ------------------------------------------------------------
        -- Return final results
        ------------------------------------------------------------
        SELECT
            @dim_kpi_key AS dim_kpi_key,
            r.dim_company_key,
            r.dim_employee_key,
            r.dim_service_key,
            @KPI_ID,
            r.employee_id,
            r.service_id,
            CONCAT('K', CAST(r.employee_id AS NVARCHAR(10))) AS entity_key,
                   
            r.kpi_value,
            CONCAT(r.kpi_value, ' months since leave last taken') AS user_friendly_score_explanation,
            -- KPI Status using pre-calculated variables
            CASE
                WHEN r.kpi_value IS NULL THEN NULL
                WHEN 
                    (@kpi_g_sign = '>=' AND r.kpi_value >= @kpi_g_value) OR
                    (@kpi_g_sign = '>'  AND r.kpi_value >  @kpi_g_value) OR
                    (@kpi_g_sign = '<=' AND r.kpi_value <= @kpi_g_value) OR
                    (@kpi_g_sign = '<'  AND r.kpi_value <  @kpi_g_value) OR
                    (@kpi_g_sign = '='  AND r.kpi_value =  @kpi_g_value)
                THEN 3
                WHEN 
                    (@kpi_a_sign = '>=' AND r.kpi_value >= @kpi_a_value) OR
                    (@kpi_a_sign = '>'  AND r.kpi_value >  @kpi_a_value) OR
                    (@kpi_a_sign = '<=' AND r.kpi_value <= @kpi_a_value) OR
                    (@kpi_a_sign = '<'  AND r.kpi_value <  @kpi_a_value) OR
                    (@kpi_a_sign = '='  AND r.kpi_value =  @kpi_a_value)
                THEN 2
                ELSE 1
            END AS kpi_status,
            CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE) AS snapshot_date
        FROM #kpi_results r;

    END TRY
    BEGIN CATCH
        -- Clean up temp tables on error
        IF OBJECT_ID('tempdb..#leave_records') IS NOT NULL
            DROP TABLE #leave_records;
        IF OBJECT_ID('tempdb..#last_leave') IS NOT NULL
            DROP TABLE #last_leave;
        IF OBJECT_ID('tempdb..#kpi_results') IS NOT NULL
            DROP TABLE #kpi_results;

        -- Re-throw the error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH


END