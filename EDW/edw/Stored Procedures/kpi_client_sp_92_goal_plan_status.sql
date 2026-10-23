CREATE   PROCEDURE [edw].[kpi_client_sp_92_goal_plan_status]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_client_sp_92_goal_plan_status]
 Author:    Manish Singh
 Created:   04-03-2025
 Purpose:   Calculate 'Goals exists and no expired goals' measure for KPI 92
 
 Notes: Converted from view [edw].[kpi_client_92_goal_plan_status]
        Uses temp tables with indexes for optimal performance
        Returns same result set as original view
 
 User Story: 9767-03-Implement KPI for Client Performance
 =========================================================================================================
 REVISIONS:
 Version   Date        Author              Description
 -------   ----------  ------------------  --------------------------
 1.0       04-03-2025  Manish Singh        Initial view creation
 2.0       21-03-2025  Greg Nuthall        Added service_id, changed status to 1,2,3
 3.0       2025-12-29  Greg Nuthall        Converted to stored procedure with temp tables and indexes
 3.1       2025-12-29  Greg Nuthall        Fixed BIT to INT casting for SUM operation, renamed procedure
 3.2       2026-01-28  Greg Nuthall        added where dc.row_num_by_client_per_service = 1 to avoid duplicate client / service
**********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

        ------------------------------------------------------------
        -- Temp Table 1: Selected KPI
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#selected_kpi') IS NOT NULL
            DROP TABLE #selected_kpi;

        declare @kpi_id int = 92
        DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);

        CREATE TABLE #selected_kpi (
            kpi_id INT NOT NULL,
            dim_kpi_key INT NOT NULL,
            what_is_measured NVARCHAR(500),
            kpi_g_value DECIMAL(18,4),
            kpi_a_value DECIMAL(18,4),
            kpi_g_sign VARCHAR(10),
            kpi_a_sign VARCHAR(10)
        );

        INSERT INTO #selected_kpi
        SELECT 
            TOP 1
            dk.kpi_id,
            dk.dim_kpi_key,
            dk.what_is_measured,
            dk.kpi_g_value,
            dk.kpi_a_value,
            dk.kpi_g_sign,
            dk.kpi_a_sign
        FROM edw.dim_kpi dk
        WHERE dk.DWHDMLOperation <> 'D'
            AND dk.DWHIsCurrent = 1
            AND dk.kpi_id = 92  -- KPI ID
        ORDER BY dk.dim_kpi_key DESC;

        -- Index not needed - single row table

        ------------------------------------------------------------
        -- Temp Table 2: Client Goal Dates
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#client_goal_dates') IS NOT NULL
            DROP TABLE #client_goal_dates;

        CREATE TABLE #client_goal_dates (
            dim_client_key INT NOT NULL,
            dim_client_unique_key NVARCHAR(200),
            client_id INT NOT NULL,
            dim_company_key INT NOT NULL,
            dim_service_key INT NOT NULL,
            service_id INT,
            client_personal_goal_id INT,
            due_date DATE,
            close_date DATE
        );

        INSERT INTO #client_goal_dates
        SELECT
            dc.dim_client_key,
            dc.dim_client_unique_key,
            dc.client_id,
            COALESCE(pg.dim_company_key, dc.dim_company_key) AS dim_company_key,
            dc.dim_service_key,
            s.service_id,
            pg.client_personal_goal_id,
            CASE 
                WHEN pg.client_personal_goal_due_date_key IS NOT NULL 
                THEN CONVERT(DATE, CONVERT(VARCHAR(8), pg.client_personal_goal_due_date_key), 112)
                ELSE NULL
            END AS due_date,
            CASE 
                WHEN pg.client_personal_goal_close_date_key IS NOT NULL
                THEN CONVERT(DATE, CONVERT(VARCHAR(8), pg.client_personal_goal_close_date_key), 112)
                ELSE NULL
            END AS close_date
        FROM [edw].[vw_current_clients_by_service] AS dc
        INNER JOIN edw.dim_service s ON dc.dim_service_key = s.dim_service_key
        LEFT JOIN edw.fact_client_personal_goal AS pg
            ON pg.dim_company_key = dc.dim_company_key
            AND pg.client_id = dc.client_id
            AND pg.DWHDMLOperation <> 'D'
         where dc.row_num_by_client_per_service = 1;

        -- Create indexes for join and filter operations
        CREATE NONCLUSTERED INDEX IX_client_goal_dates_client 
            ON #client_goal_dates (dim_client_key, client_id, dim_company_key, dim_service_key);

        CREATE NONCLUSTERED INDEX IX_client_goal_dates_goal 
            ON #client_goal_dates (client_personal_goal_id)
            INCLUDE (due_date, close_date);

        ------------------------------------------------------------
        -- Temp Table 3: Client Goal Status
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#client_goal_status') IS NOT NULL
            DROP TABLE #client_goal_status;

        CREATE TABLE #client_goal_status (
            dim_client_key INT NOT NULL,
            dim_client_unique_key NVARCHAR(200),
            client_id INT NOT NULL,
            dim_company_key INT NOT NULL,
            dim_service_key INT NOT NULL,
            service_id INT,
            client_personal_goal_id INT,
            is_open INT NOT NULL,              -- Changed from BIT to INT for SUM operation
            is_open_past_due INT NOT NULL      -- Changed from BIT to INT for SUM operation
        );

        INSERT INTO #client_goal_status
        SELECT
            dim_client_key,
            dim_client_unique_key,
            client_id,
            dim_company_key,
            dim_service_key,
            service_id,
            client_personal_goal_id,
            -- (A) is_open: close_date is null or >= today
            -- CAST to INT for SUM compatibility
            CASE 
                WHEN client_personal_goal_id IS NOT NULL
                    AND (close_date IS NULL OR close_date >= GETDATE())
                THEN 1
                ELSE 0
            END AS is_open,
            -- (B) is_open_past_due: is_open=1 AND due_date < today
            -- CAST to INT for SUM compatibility
            CASE 
                WHEN client_personal_goal_id IS NOT NULL
                    AND (close_date IS NULL OR close_date >= GETDATE())
                    AND due_date < GETDATE()
                    AND due_date IS NOT NULL
                THEN 1
                ELSE 0
            END AS is_open_past_due
        FROM #client_goal_dates;

        -- Create index for aggregation
        CREATE NONCLUSTERED INDEX IX_client_goal_status_aggregate 
            ON #client_goal_status (dim_client_key, client_id, dim_company_key, dim_service_key, service_id)
            INCLUDE (is_open, is_open_past_due);

        ------------------------------------------------------------
        -- Temp Table 4: Goal Aggregates
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#goal_aggregates') IS NOT NULL
            DROP TABLE #goal_aggregates;

        CREATE TABLE #goal_aggregates (
            dim_client_key INT NOT NULL,
            dim_client_unique_key NVARCHAR(200),
            client_id INT NOT NULL,
            dim_company_key INT NOT NULL,
            dim_service_key INT NOT NULL,
            service_id INT,
            open_goals INT NOT NULL,
            open_and_past_due_goals INT NOT NULL

        );

        INSERT INTO #goal_aggregates
        SELECT
            dim_client_key,
            dim_client_unique_key,
            client_id,
            dim_company_key,
            dim_service_key,
            service_id,
            SUM(is_open) AS open_goals,                      -- Now works with INT
            SUM(is_open_past_due) AS open_and_past_due_goals -- Now works with INT
        FROM #client_goal_status
        GROUP BY
            dim_client_key,
            dim_client_unique_key,
            client_id,
            service_id,
            dim_company_key,
            dim_service_key;

        -- Create index for final join
        CREATE NONCLUSTERED INDEX IX_goal_aggregates_client 
            ON #goal_aggregates (dim_client_key, client_id, dim_company_key, dim_service_key)
            INCLUDE (dim_client_unique_key, service_id, open_goals, open_and_past_due_goals);

        ------------------------------------------------------------
        -- Temp Table 5: Final Table
        ------------------------------------------------------------
        IF OBJECT_ID('tempdb..#final_table') IS NOT NULL
            DROP TABLE #final_table;

        CREATE TABLE #final_table (
            dim_client_key INT NOT NULL,
            dim_client_unique_key NVARCHAR(200),
            client_id INT NOT NULL,
            dim_company_key INT NOT NULL,
            dim_service_key INT NOT NULL,
            service_id INT,
            kpi_value DECIMAL(18,2),
            user_friendly_score_explanation NVARCHAR(500)
        );

        INSERT INTO #final_table
        SELECT
            ga.dim_client_key,
            ga.dim_client_unique_key,
            ga.client_id,
            ga.dim_company_key,
            ga.dim_service_key,
            ga.service_id,
            -- KPI Value
            CASE 
                WHEN ga.open_goals = 0 
                THEN 0         -- No active goals
                WHEN ga.open_and_past_due_goals > 0
                THEN 0.9       -- Some active goals are past due
                ELSE 1         -- All active goals are on-time
            END AS kpi_value,
            -- User Friendly Score Description
            CASE 
                WHEN ga.open_goals = 0 THEN
                    'Client has no active goals.'
                WHEN ga.open_and_past_due_goals > 0 THEN
                    CONCAT(
                        'Client has ', ga.open_goals, ' active goals, ',
                        ga.open_and_past_due_goals, ' have passed their due date.'
                    )
                ELSE
                    CONCAT(
                        'Client has ', ga.open_goals, ' active goals, none have passed their due date.'
                    )
            END AS user_friendly_score_explanation
        FROM #goal_aggregates AS ga;

        -- Create index for final cross join
        CREATE NONCLUSTERED INDEX IX_final_table_all 
            ON #final_table (dim_client_key)
            INCLUDE (dim_client_unique_key, client_id, dim_company_key, dim_service_key, service_id, kpi_value, user_friendly_score_explanation);

        ------------------------------------------------------------
        -- Final Result Set (same as original view)
        ------------------------------------------------------------
        --[dim_kpi_key],
        --[dim_company_key],
        --[dim_client_key],
        --[dim_service_key],
        --[entity_key],
        --[kpi_id],
        --[client_id],
        --[service_id],
        --[kpi_value],
        --[user_friendly_score_explanation],
        --[kpi_status],
        --[snapshot_date]
        
        
        
        SELECT
            sk.dim_kpi_key,
            ft.dim_company_key,
            ft.dim_client_key,
            ft.dim_service_key,
            CONCAT('TW', CAST(ft.dim_client_unique_key AS NVARCHAR(10))) AS entity_key,
            @kpi_id,
            ft.client_id,
            ft.service_id,
            ft.kpi_value,
            ft.user_friendly_score_explanation,
            CASE
                WHEN ft.kpi_value IS NULL THEN NULL
                WHEN 
                    (sk.kpi_g_sign = '>='  AND ft.kpi_value >= sk.kpi_g_value) OR
                    (sk.kpi_g_sign = '>'   AND ft.kpi_value >  sk.kpi_g_value) OR
                    (sk.kpi_g_sign = '<='  AND ft.kpi_value <= sk.kpi_g_value) OR
                    (sk.kpi_g_sign = '<'   AND ft.kpi_value <  sk.kpi_g_value) OR
                    (sk.kpi_g_sign = '='   AND ft.kpi_value =  sk.kpi_g_value)
                THEN 3
                WHEN 
                    (sk.kpi_a_sign = '>=' AND ft.kpi_value >= sk.kpi_a_value) OR
                    (sk.kpi_a_sign = '>'  AND ft.kpi_value >  sk.kpi_a_value) OR
                    (sk.kpi_a_sign = '<=' AND ft.kpi_value <= sk.kpi_a_value) OR
                    (sk.kpi_a_sign = '<'  AND ft.kpi_value <  sk.kpi_a_value) OR
                    (sk.kpi_a_sign = '='  AND ft.kpi_value =  sk.kpi_a_value)
                THEN 2
                ELSE 1
            END AS kpi_status,
            @SnapshotDate as snapshot_date
        FROM #final_table ft
        CROSS JOIN #selected_kpi sk;


END