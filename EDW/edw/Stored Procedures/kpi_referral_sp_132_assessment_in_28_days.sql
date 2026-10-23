CREATE   PROCEDURE [edw].[kpi_referral_sp_132_assessment_in_28_days]
    
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_referral_sp_132_assessment_in_28_days]
 Author (Developer): Greg Nuthall (based on pattern from KPI 134)
 Author (Analyst): Timi Boddington
 Created: 2025-12-19
 Purpose: Calculate assessments completed within 28 days of acceptance
          Replaces the view [edw].[kpi_referral_132_assessment_in_28_days]
          Inserts/Updates data into [kpi].[ds_snapshot_referral_current]
 User Story: 9838

 REVISIONS:
 Version  Date         Author             Description
 -------  ------------ -----------------  ------------------------------
 1.0      2025-12-19   Greg Nuthall       Initial stored procedure version
                                          Converted CTEs to temp tables
                                          Added remove/insert logic for kpi table
 1.1      2026-01-27   Greg Nuthall       Fixed days_in_service calculation to use GETDATE() instead of @NZtoday
                                          to match view logic exactly

 **********************************************************************************************************/
BEGIN
    SET NOCOUNT ON;

    -- Declare KPI ID constant
    DECLARE @KPI_ID INT = 132;
    DECLARE @NZtoday DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);

    ------------------------------------------------------------
    -- Drop temp tables if they exist
    ------------------------------------------------------------
    IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    IF OBJECT_ID('tempdb..#selected_kpi') IS NOT NULL DROP TABLE #selected_kpi;
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    IF OBJECT_ID('tempdb..#outcomes') IS NOT NULL DROP TABLE #outcomes;
    IF OBJECT_ID('tempdb..#referral_base_2') IS NOT NULL DROP TABLE #referral_base_2;
    IF OBJECT_ID('tempdb..#referral_final') IS NOT NULL DROP TABLE #referral_final;
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    IF OBJECT_ID('tempdb..#final_results') IS NOT NULL DROP TABLE #final_results;

    ------------------------------------------------------------
    -- 1) Service Type Grouping
    ------------------------------------------------------------
    SELECT DISTINCT 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_service.service_id
    INTO #service_type_grouping
    FROM edw.dim_kpi
    LEFT JOIN edw.bridge_kpi_measure_to_service_type_group
        ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
    LEFT JOIN edw.dim_kpi_service_type_grouping
        ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = 
           dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
        AND dim_kpi_service_type_grouping.dwhiscurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping
        ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = 
           bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type
        ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = 
           dim_kpi_service_type.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service
        ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.dwhiscurrent = 1
        AND dim_service.dwhdmloperation <> 'D'
    WHERE dim_kpi.dwhiscurrent = 1;

    ------------------------------------------------------------
    -- 2) MS Count
    ------------------------------------------------------------
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    ------------------------------------------------------------
    -- 3) Selected KPI
    ------------------------------------------------------------
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
    WHERE dim_kpi.dwhdmloperation <> 'D'
        AND dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    ------------------------------------------------------------
    -- 4) Referral Base
    -- FIXED: Use GETDATE() instead of @NZtoday to match view exactly
    ------------------------------------------------------------
    SELECT 
        dates.calendar_date AS accepted_date,
        dim_date.calendar_date AS discharge_date,
        CASE
            WHEN dim_date.calendar_date IS NOT NULL THEN
                DATEDIFF(day, dates.calendar_date, dim_date.calendar_date)
            ELSE DATEDIFF(day, dates.calendar_date, GETDATE())  -- FIXED: Changed from @NZtoday to GETDATE()
        END AS days_in_service,
        '' AS kpi_snapshot_client_id,
        vw_fact_client_referral.dim_company_key,
        vw_fact_client_referral.dim_client_referral_key,
        vw_fact_client_referral.dim_client_key,
        vw_fact_client_referral.dim_service_key,
        dim_service.service_id,
        vw_fact_client_referral.client_referral_id,
        CONCAT(999, '_', vw_fact_client_referral.client_referral_id, '_',
               vw_fact_client_referral.client_id, '_', dco.company_id) AS entity_key,
        dim_client_referral.client_referral_status,
        dim_client_referral.client_referral_type
    INTO #referral_base
    FROM edw.vw_fact_client_referral
    LEFT JOIN edw.dim_client_referral
        ON vw_fact_client_referral.dim_client_referral_key = dim_client_referral.dim_client_referral_key
    LEFT JOIN edw.dim_service
        ON vw_fact_client_referral.dim_service_key = dim_service.dim_service_key
    LEFT JOIN edw.vw_dim_client_team
        ON vw_fact_client_referral.dim_client_team_key = vw_dim_client_team.dim_client_team_key
    LEFT JOIN edw.vw_dim_company dco
        ON vw_fact_client_referral.dim_company_key = dco.dim_company_key
    INNER JOIN (
        SELECT dim_date.dim_date_key, calendar_date
        FROM edw.dim_date
        WHERE current_date_rolling_day_offset BETWEEN -28 AND -1
    ) AS dates
        ON vw_fact_client_referral.client_referral_accepted_date_key = dates.dim_date_key
    LEFT JOIN edw.dim_date
        ON vw_fact_client_referral.client_referral_discharge_date_key = dim_date.dim_date_key
    WHERE vw_fact_client_referral.dwhdmloperation <> 'd'
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND client_referral_decline_date_key IS NULL
        AND client_referral_discharge_date_key IS NULL
        AND dim_client_referral.client_status_is_active = 'active'
        AND client_referral_status = 'Accepted'
        AND client_team_name NOT LIKE '%f/up%';

    ------------------------------------------------------------
    -- 5) Outcomes
    ------------------------------------------------------------
    SELECT 
        dim_company_key,
        client_referral_id,
        CAST(response_created_date AS DATE) AS response_created_date,
        total_score,
        client_outcome_tool_title
    INTO #outcomes
    FROM edw.fact_client_assessment_outcome
    WHERE dwhiscurrent = 1
        AND client_referral_id IN (SELECT client_referral_id FROM #referral_base)
        AND total_score > 0;

    ------------------------------------------------------------
    -- 6) Referral Base 2
    ------------------------------------------------------------
    SELECT 
        referral_base.*,
        client_outcome_tool_title,
        first_response_created_date
    INTO #referral_base_2
    FROM #referral_base referral_base
    LEFT JOIN (
        SELECT 
            dim_company_key,
            client_referral_id,
            client_outcome_tool_title,
            MIN(response_created_date) AS first_response_created_date
        FROM #outcomes
        GROUP BY dim_company_key, client_referral_id, client_outcome_tool_title
    ) AS min_outcomes
        ON referral_base.client_referral_id = min_outcomes.client_referral_id
        AND referral_base.dim_company_key = min_outcomes.dim_company_key;

    ------------------------------------------------------------
    -- 7) Referral Final
    ------------------------------------------------------------
    SELECT 
        referral_base_2.*,
        DATEDIFF(day, accepted_date, first_response_created_date) AS days_diff_accept_assess
    INTO #referral_final
    FROM #referral_base_2 referral_base_2;

    ------------------------------------------------------------
    -- 8) Final Table
    ------------------------------------------------------------
    SELECT
        dim_company_key,
        dim_client_referral_key,
        client_referral_id,
        entity_key,
        dim_service_key,
        service_id,
        days_diff_accept_assess,
        days_in_service,
        CASE
            WHEN days_diff_accept_assess IS NOT NULL THEN -1
            ELSE days_in_service
        END AS kpi_value,
        CASE
            WHEN days_diff_accept_assess IS NOT NULL THEN 'Assessment exists'
            ELSE CONCAT('No assessment, accepted in service ', days_in_service, ' days ago')
        END AS user_friendly_score_explanation
    INTO #final_table
    FROM #referral_final;

    ------------------------------------------------------------
    -- 9) Calculate Final Results with KPI Status
    ------------------------------------------------------------
    SELECT 
        selected_kpi.dim_kpi_key,
        final_table.dim_company_key,
        final_table.dim_client_referral_key,
        final_table.dim_service_key,
        final_table.entity_key,
        @KPI_ID AS kpi_id,
        final_table.client_referral_id, 
        final_table.service_id,
        final_table.kpi_value,
        final_table.user_friendly_score_explanation,
        CASE
            WHEN final_table.kpi_value IS NULL THEN NULL
            WHEN (selected_kpi.kpi_g_sign = '>=' AND final_table.kpi_value >= selected_kpi.kpi_g_value)
                OR (selected_kpi.kpi_g_sign = '>' AND final_table.kpi_value > selected_kpi.kpi_g_value)
                OR (selected_kpi.kpi_g_sign = '<=' AND final_table.kpi_value <= selected_kpi.kpi_g_value)
                OR (selected_kpi.kpi_g_sign = '<' AND final_table.kpi_value < selected_kpi.kpi_g_value)
                OR (selected_kpi.kpi_g_sign = '=' AND final_table.kpi_value = selected_kpi.kpi_g_value) THEN 3
            WHEN (selected_kpi.kpi_a_sign = '>=' AND final_table.kpi_value >= selected_kpi.kpi_a_value)
                OR (selected_kpi.kpi_a_sign = '>' AND final_table.kpi_value > selected_kpi.kpi_a_value)
                OR (selected_kpi.kpi_a_sign = '<=' AND final_table.kpi_value <= selected_kpi.kpi_a_value)
                OR (selected_kpi.kpi_a_sign = '<' AND final_table.kpi_value < selected_kpi.kpi_a_value)
                OR (selected_kpi.kpi_a_sign = '=' AND final_table.kpi_value = selected_kpi.kpi_a_value) THEN 2
            ELSE 1
        END AS kpi_status,
        @NZtoday AS snapshot_date
    FROM #final_table final_table
    CROSS JOIN #selected_kpi selected_kpi
    LEFT JOIN #service_type_grouping service_type_grouping
        ON service_type_grouping.dim_kpi_key = selected_kpi.dim_kpi_key
        AND service_type_grouping.service_id = final_table.service_id
    LEFT JOIN #ms_count ms_count
        ON selected_kpi.kpi_id = ms_count.kpi_id
    WHERE (ms_count.service_count IS NULL OR ms_count.service_count = 0)
        OR (service_type_grouping.service_id IS NOT NULL);

END;