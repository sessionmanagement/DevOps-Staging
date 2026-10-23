CREATE   PROCEDURE [edw].[kpi_referral_sp_129_goal_plan_within_14_days]
    
/**********************************************************************************************************
 KPI SP: edw.kpi_referral_sp_129_goal_plan_within_14_days
 Author (Developer):  Greg Nuthall  
 Author (Analyst):    Timi Boddington
 Created:             2025-12-19     
 Purpose:             Calculate open and in-date goals (14 days threshold)
 User Story:          9841

 REVISIONS:
 Version  Date        Author             Description
 ------   ----------  -----------------  --------------------------
 1.0      2025-12-19  Greg Nuthall       Initial stored procedure creation (optimized from view)
 1.1      2025-05-25  Manish Singh       Original view logic for 'Goal_plan_within_14_days' measure
 1.2      2025-06-16  Timi Boddington    Reformatted, added dwhdmloperation <> 'd' to dim_service
 1.3      2025-06-18  Timi Boddington    Changed join from client_team_id to dim_client_team_key
 *************************************************************************************************************/
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    -- Declare KPI ID constant
    DECLARE @KPI_ID INT = 129;
    DECLARE @NZtoday DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);

    -- Clean up temp tables
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    IF OBJECT_ID('tempdb..#referral_goal') IS NOT NULL DROP TABLE #referral_goal;
    IF OBJECT_ID('tempdb..#referral_base_2') IS NOT NULL DROP TABLE #referral_base_2;
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    IF OBJECT_ID('tempdb..#selected_kpi') IS NOT NULL DROP TABLE #selected_kpi;
    IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;

    ------------------------------------------------------------
    -- Step 1: Materialize KPI lookup early
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
    -- Step 2: Build service type grouping early
    ------------------------------------------------------------
    SELECT DISTINCT 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_service.service_id
    INTO #service_type_grouping
    FROM edw.dim_kpi
    INNER JOIN edw.bridge_kpi_measure_to_service_type_group 
        ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
    INNER JOIN edw.dim_kpi_service_type_grouping 
        ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
        AND dim_kpi_service_type_grouping.dwhiscurrent = 1
    INNER JOIN edw.bridge_kpi_service_type_to_grouping 
        ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    INNER JOIN edw.dim_kpi_service_type 
        ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
    INNER JOIN edw.dim_service 
        ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.dwhiscurrent = 1
        AND dim_service.dwhdmloperation <> 'D'
    WHERE dim_kpi.dwhiscurrent = 1
        AND dim_service.service_id IS NOT NULL;

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(service_id, dim_kpi_key);

    ------------------------------------------------------------
    -- Step 3: Calculate ms_count
    ------------------------------------------------------------
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    ------------------------------------------------------------
    -- Step 4: Build referral base (with early filtering)
    ------------------------------------------------------------
    SELECT 
        dim_date.calendar_date AS accepted_date,
        DATEDIFF(DAY, dim_date.calendar_date, CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')))) AS days_in_service,
        vw_fact_client_referral.client_id,
        vw_fact_client_referral.dim_company_key,
        vw_fact_client_referral.dim_client_referral_key,
        vw_fact_client_referral.dim_client_key,
        vw_fact_client_referral.dim_service_key,
        dim_service.service_id,
        vw_fact_client_referral.client_referral_id,
        CONCAT(999, '_', vw_fact_client_referral.client_referral_id, '_', vw_fact_client_referral.client_id, '_', dco.company_id) AS entity_key,
        dim_client_referral.client_referral_status,
        dim_client_referral.client_referral_type
    INTO #referral_base
    FROM edw.vw_fact_client_referral
    INNER JOIN edw.dim_date 
        ON vw_fact_client_referral.client_referral_accepted_date_key = dim_date.dim_date_key
    INNER JOIN edw.dim_client_referral 
        ON vw_fact_client_referral.dim_client_referral_key = dim_client_referral.dim_client_referral_key
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND dim_client_referral.client_status_is_active = 'active'
        AND dim_client_referral.client_referral_status = 'Accepted'
    INNER JOIN edw.dim_service 
        ON vw_fact_client_referral.dim_service_key = dim_service.dim_service_key
    INNER JOIN edw.vw_dim_company dco 
        ON vw_fact_client_referral.dim_company_key = dco.dim_company_key
    LEFT JOIN edw.vw_dim_client_team 
        ON vw_fact_client_referral.dim_client_team_key = vw_dim_client_team.dim_client_team_key
    WHERE vw_fact_client_referral.dwhdmloperation <> 'd'
        AND vw_fact_client_referral.client_referral_decline_date_key IS NULL
        AND vw_fact_client_referral.client_referral_discharge_date_key IS NULL
        AND (vw_dim_client_team.client_team_name NOT LIKE '%f/up%' OR vw_dim_client_team.client_team_name IS NULL);

    CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(dim_client_referral_key);
    CREATE NONCLUSTERED INDEX IX_referral_base_ref ON #referral_base(client_referral_id, dim_company_key);

    ------------------------------------------------------------
    -- Step 5: Get referral goals (CORRECTED - filter on personal goals using dim_client_referral_key)
    ------------------------------------------------------------
    SELECT 
        fpg.dim_company_key,
        fpg.client_referral_id,
        dd.calendar_date AS review_date,
        DATEDIFF(DAY, CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time'))), dd.calendar_date) AS days_to_review,
        ROW_NUMBER() OVER (
            PARTITION BY fpg.dim_company_key, fpg.client_referral_id 
            ORDER BY dd.calendar_date DESC
        ) AS Goal_order_futureto
    INTO #referral_goal
    FROM edw.fact_client_personal_goal fpg
    INNER JOIN (
        SELECT DISTINCT 
            fact_client_referral_goal_key,
            client_referral_goal_next_review_date_key
        FROM edw.fact_client_referral_goal
    ) AS referral_goals 
        ON fpg.fact_client_referral_goal_key = referral_goals.fact_client_referral_goal_key
    INNER JOIN edw.dim_date dd
        ON referral_goals.client_referral_goal_next_review_date_key = dd.dim_date_key
    WHERE fpg.dim_client_referral_key IN (SELECT dim_client_referral_key FROM #referral_base)
        AND fpg.client_personal_goal_close_date_key IS NULL
        AND fpg.dwhdmloperation <> 'd';

    CREATE NONCLUSTERED INDEX IX_referral_goal ON #referral_goal(client_referral_id, dim_company_key) WHERE Goal_order_futureto = 1;

    ------------------------------------------------------------
    -- Step 6: Combine referral base with goals (apply 14-day filter)
    ------------------------------------------------------------
    SELECT 
        rb.accepted_date,
        rb.days_in_service,
        rb.client_id,
        rb.dim_company_key,
        rb.dim_client_referral_key,
        rb.dim_client_key,
        rb.dim_service_key,
        rb.service_id,
        rb.client_referral_id,
        rb.entity_key,
        rb.client_referral_status,
        rb.client_referral_type,
        rg.review_date,
        rg.days_to_review
    INTO #referral_base_2
    FROM #referral_base rb
    LEFT JOIN #referral_goal rg
        ON rb.client_referral_id = rg.client_referral_id
        AND rb.dim_company_key = rg.dim_company_key
        AND rg.Goal_order_futureto = 1
    WHERE rb.days_in_service >= 14;

    CREATE CLUSTERED INDEX IX_referral_base_2 ON #referral_base_2(service_id, client_referral_id);

    ------------------------------------------------------------
    -- Step 7: Build final table with ROW_NUMBER for duplicate handling
    ------------------------------------------------------------
    SELECT 
        rb2.dim_company_key,
        rb2.client_referral_id,
        rb2.client_id,
        rb2.dim_client_referral_key,
        rb2.entity_key,
        rb2.dim_service_key,
        rb2.service_id,
        rb2.days_in_service,
        rb2.days_to_review,
        rb2.days_to_review AS kpi_value,
        rb2.review_date,
        ROW_NUMBER() OVER (
            PARTITION BY rb2.client_id, rb2.dim_service_key 
            ORDER BY CASE WHEN rb2.days_to_review IS NULL THEN -9999 ELSE rb2.days_to_review END DESC
        ) AS rn,
        CASE 
            WHEN rb2.days_to_review IS NULL THEN 'Goal Required'
            WHEN rb2.days_to_review BETWEEN 1 AND 7 THEN 'Goal set, but review date within next week'
            WHEN rb2.days_to_review > 7 THEN 'Goal set and review date more than a week away'
            WHEN rb2.days_to_review <= 0 THEN CONCAT('Goal review is overdue. Due date: ', CONVERT(CHAR(10), rb2.review_date, 103))
        END AS user_friendly_score_explanation
    INTO #final_table
    FROM #referral_base_2 rb2;

    CREATE NONCLUSTERED INDEX IX_final_table ON #final_table(service_id, dim_service_key) WHERE rn = 1;

    SELECT 
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_client_referral_key,
        ft.dim_service_key,
        ft.entity_key,
        sk.kpi_id,
        ft.client_referral_id,
        ft.service_id,
        ft.kpi_value,
        ft.user_friendly_score_explanation,
        CASE 
            WHEN ft.kpi_value IS NULL OR ft.kpi_value <= 0 THEN 1
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
        CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE) AS snapshot_date
     
    FROM #final_table ft
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = ft.service_id
    LEFT JOIN #ms_count mc 
        ON sk.kpi_id = mc.kpi_id
    WHERE ft.rn = 1  -- Only take one referral per client per service
        AND ((mc.service_count IS NULL OR mc.service_count = 0) OR stg.service_id IS NOT NULL);


END