
CREATE   PROCEDURE [edw].[kpi_kaimahi_sp_12_leave_balance_200hrs]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_kaimahi_sp_12_leave_balance_200hrs]
 Author:    Manish Singh
 Created:   16-12-2024
 Purpose:   Calculate 'Kaimahi leave balance' measure for KPI 12
 
 Notes: Converted from view [edw].[kpi_kaimahi_12_leave_balance_200hrs]
        Optimized version using minimal temp tables and strategic performance enhancements
        Returns same result set as original view
 
 User Story: 9361-03-Create Source Query View for KPI-Kaimahi_leave related
 =========================================================================================================
 REVISIONS:
 Version   Date        Author              Description
 -------   ----------  ------------------  --------------------------
 1.0       16-12-2024  Manish Singh        Initial view creation - calculate Kaimahi leave balance
 2.0       11-02-2025  Manish Singh        Added view [edw].[vw_dim_employee_kpi] in query
 3.0       12-02-2025  Mike Ryan           Removed columns derivable from dim_kpi
 4.0       21-03-2025  Greg Nuthall        Added service_id, changed status to 1,2,3
 5.0       2025-12-29  Greg Nuthall        Converted to optimized stored procedure
**********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    BEGIN TRY
        ------------------------------------------------------------
        -- Get KPI metadata once (cache in variables)
        ------------------------------------------------------------
        DECLARE @dim_kpi_key INT;
        DECLARE @kpi_g_value DECIMAL(18,4);
        DECLARE @kpi_a_value DECIMAL(18,4);
        DECLARE @kpi_g_sign VARCHAR(10);
        DECLARE @kpi_a_sign VARCHAR(10);
        declare @kpi_id int = 12

        SELECT TOP 1
            @dim_kpi_key = dk.dim_kpi_key,
            @kpi_g_value = dk.kpi_g_value,
            @kpi_a_value = dk.kpi_a_value,
            @kpi_g_sign = dk.kpi_g_sign,
            @kpi_a_sign = dk.kpi_a_sign
        FROM edw.dim_kpi dk WITH (NOLOCK)
        WHERE dk.DWHDMLOperation <> 'D'
            AND dk.DWHIsCurrent = 1
            AND dk.kpi_id = 12  -- KPI ID
        ORDER BY dk.dim_kpi_key DESC;

        ------------------------------------------------------------
        -- Cache leave_type_id constant (avoid repeated comparisons)
        ------------------------------------------------------------
        DECLARE @leave_type_annual_leave VARCHAR(50) = 'hzr623_8QIrUXJcOpKO36g';

        ------------------------------------------------------------
        -- Single temp table: Aggregate leave balance directly
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#kpi_results') IS NOT NULL
            DROP TABLE #kpi_results;

        CREATE TABLE #kpi_results (
            dim_company_key INT NOT NULL,
            employee_id INT NOT NULL,
            dim_service_key INT NOT NULL,
            service_id INT,
            dim_employee_key INT NOT NULL,
            kpi_value DECIMAL(10,1) NOT NULL,
            INDEX IX_kpi_results_clustered CLUSTERED (dim_employee_key, dim_service_key)
        );

        ------------------------------------------------------------
        -- Single INSERT with aggregation
        ------------------------------------------------------------
        INSERT INTO #kpi_results WITH (TABLOCK)
        SELECT 
            em.dim_company_key,
            fel.employee_id,
            em.dim_service_key,
            s.service_id,
            em.dim_employee_key,
            CAST(SUM(fel.employee_leave_balance_hours) AS DECIMAL(10,1)) AS kpi_value
        FROM edw.vw_current_employee em WITH (NOLOCK)
        INNER JOIN edw.vw_fact_employee_leave fel WITH (NOLOCK)
            ON em.employee_id = fel.employee_id
            AND em.dim_company_key = fel.dim_company_key
        INNER JOIN edw.dim_service s WITH (NOLOCK)
            ON em.dim_service_key = s.dim_service_key
        WHERE fel.leave_type_id = @leave_type_annual_leave  -- Annual leave only
            AND fel.DWHDMLOperation <> 'D'
            AND fel.DWHIsCurrent = 1
        GROUP BY 
            em.dim_company_key,
            fel.employee_id,
            s.service_id,
            em.dim_service_key,
            em.dim_employee_key;

        ------------------------------------------------------------
        -- Return results with KPI calculations
        ------------------------------------------------------------

        SELECT
            @dim_kpi_key AS dim_kpi_key,
            r.dim_company_key,
            r.dim_employee_key,
            r.dim_service_key,
            @kpi_id,
            r.employee_id,
            r.service_id,
            CONCAT('K', CAST(r.employee_id AS NVARCHAR(10))) AS entity_key,
            r.kpi_value,
            -- User friendly explanation
            CONCAT(
                'Annual leave balance is ', 
                CAST(r.kpi_value AS NVARCHAR(20)), 
                ' hours'
            ) AS user_friendly_score_explanation,
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
        -- Clean up on error
        IF OBJECT_ID('tempdb..#kpi_results') IS NOT NULL
            DROP TABLE #kpi_results;

        -- Re-throw the error
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();

        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH



END