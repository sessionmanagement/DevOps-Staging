CREATE   procedure [edw].[kpi_referral_sp_134_goal_plan_after_28_days]


/**********************************************************************************************************
 KPI SP: edw.kpi_referral_sp_134_goal_plan_after_28_days
 Author (Developer):  Greg Nuthall  
 Author (Analyst) : Timi Boddington
 Created :  02-04-2025     
 Purpose  : calculate assessments completed in 28 days of acceptance

 REVISIONS:
 Version  Date        Author             Description
-----   ----------    -----------------  --------------------------
 1.0    02-04-2025    Greg Nuthall       This view is created to calculate Goal_plan_after_28_days measure 
 1.1    10-04-2025    Greg Nuthall       Modified as requested
 1.2    01-05-2025    Manish Singh       Changed to only active referrals therefore removed discharged clients
 1.3    16-06-2025    Timi Boddington    added dim_service.dwhdmloperation <> 'd' as duplicates in dim_service where dwhiscurrent = 1
 1.4    18-06-2025    Timi Boddington    Changed the join from dim_client_team from client_team_id to dim_client_team_key.  
                                         Also duplicates in service_type_grouping, made distinct, which I think it was
 1.5    30-07-2025    Thijs Bohm         Filter out One-off and clinical teams
 1.6    22-09-2025	  Timi Boddington    Changed >= 28 days to > 28 Days
 1.7    27-11-2025	  Thijs Bohm		 Add Target definitions 'goal planning applies' filter
 1.8    19-12-2025    Greg Nuthall       Changed to a store procedure with optimisation
 1.9    03-03-2026	  Timi Boddington	 Changed the logic in the filtered teams to exclude community (clinical).  User story 13328
                                         I've added follow up teams to the list
 *************************************************************************************************************/

as

    -- Declare KPI ID constant
    DECLARE @KPI_ID INT = 134;
    DECLARE @NZtoday DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);

-- Clean up temp tables
IF OBJECT_ID('tempdb..#TeamFunctionGroups') IS NOT NULL DROP TABLE #TeamFunctionGroups;
IF OBJECT_ID('tempdb..#FilteredTeams') IS NOT NULL DROP TABLE #FilteredTeams;
IF OBJECT_ID('tempdb..#Teams_to_filter_OUT') IS NOT NULL DROP TABLE #Teams_to_filter_OUT;
IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
IF OBJECT_ID('tempdb..#referral_goal_1') IS NOT NULL DROP TABLE #referral_goal_1;
IF OBJECT_ID('tempdb..#referral_goal') IS NOT NULL DROP TABLE #referral_goal;
IF OBJECT_ID('tempdb..#referral_base_2') IS NOT NULL DROP TABLE #referral_base_2;
IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
IF OBJECT_ID('tempdb..#selected_kpi') IS NOT NULL DROP TABLE #selected_kpi;
IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;

-- Step 1: Materialize KPI lookup early (used in final filter)
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
        AND dim_kpi.kpi_id = 134;

-- Step 2: Build service type grouping early
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

-- Step 3: Calculate ms_count
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

-- Step 4: Team filtering (optimized aggregation)
    SELECT
        service_id,
        client_team_function,
        COUNT(DISTINCT client_team_name) AS team_count,
        COUNT(DISTINCT client_team_function) AS function_count
    INTO #TeamFunctionGroups
    FROM edw.vw_dim_client_team
    WHERE service_id <> '0'
    GROUP BY service_id, client_team_function;

CREATE NONCLUSTERED INDEX IX_TeamFunctionGroups ON #TeamFunctionGroups(service_id, client_team_function);

-- Step 5: Filtered teams
    SELECT
        dct.dim_client_team_key,
        dct.company_id,
        dct.dim_service_key,
        dct.service_id,
        dct.client_team_id,
        dct.client_team_name,
        dct.client_team_function,
        tfg.team_count,
        tfg.function_count
    INTO #FilteredTeams
    FROM edw.vw_dim_client_team dct
    INNER JOIN #TeamFunctionGroups tfg
        ON dct.service_id = tfg.service_id
        AND dct.client_team_function = tfg.client_team_function
    WHERE dct.service_id <> '0';

CREATE NONCLUSTERED INDEX IX_FilteredTeams ON #FilteredTeams(client_team_id, client_team_name);

-- Step 6: Teams to filter out
    SELECT
        dim_client_team_key,
        company_id,
        dim_service_key,
        service_id,
        client_team_id,
        client_team_name,
        client_team_function
    INTO #Teams_to_filter_OUT
    FROM #FilteredTeams
    WHERE 
    --    client_team_name LIKE '%one off%'
    --    OR (function_count = 1 AND team_count > 1 AND client_team_name LIKE '%clinical%' AND client_team_name NOT LIKE '%non-clinical%')
    --    OR function_count > 1
    --    OR client_team_function not in ('community (clinical)')
    --    ;
    --added:
          client_team_id  in (
          404  --Phoenix Peer Support
         ,408  --WDHB Mainstream - Clinical
         ,410  --Ola Lei - Clinical
         ,425  --Auckland Adult Mobile - Clinical
         ,487  --X ABE Clinical ChCh
         ,509  --XXX - closed - Youth Mobile CS Chch - Clinical
         ,510  --XXXC - closed - Early Intvn Psych Sppt - Clinical
         ,544  --Jansen House - Clinical
         ,542  --Mapusaga Clinical
         ,546  --Nga Taumahatanga - Clinical
         ,683  --EaseUp - ADHB - One Off Support
         ,686  --EaseUp - West - One Off Support
         ,709  --EaseUp - Waikato - One Off Support
         ,742  --Kia Ora Ake - One Off Support
         ,749  --EaseUp - North - One Off Support
         --follow up teams:
        ,499	--XXX - closed - ABE Follow up TeamFunction: Community
        ,549	--TH Hse Napier F/up TeamFunction: TH Follow Up
        ,565	--XXX - closed - TH Motels Hastings_F/Up TeamFunction: TH Follow Up
        ,740	--EH Standalones Hamilton F/up TeamFunction: TH Follow Up
        ,741	--EH Christchurch F/up TeamFunction: TH Follow Up
        ,743	--EH Motels F/Up TeamFunction: TH Follow Up
        ,744	--TH Rotorua F/up TeamFunction: TH Follow Up
        ,753	--EH Dunedin F/up TeamFunction: TH Follow Up
        ,754	--EH Invercargill F/up TeamFunction: TH Follow Up
        ,618	--TH Motels Hamilton F/Up TeamFunction: TH Follow Up
        ,532	--TH Standalones Porirua F/up TeamFunction: TH Follow Up
        ,563	--TH Standalones Akld F/up TeamFunction: TH Follow Up
        ,551	--TH Hub Swanson F/up TeamFunction: TH Follow Up
        ,538	--TH Standalones Hutt Valley F/up TeamFunction: TH Follow Up
        ,676	--XXX CLOSED_CPP: Tenancy only TeamFunction: CPP Follow Up
        ,692	--XXX - closed - TH Motels Chch F/up TeamFunction: TH Follow Up
        ,661	--TH Standalones Invercargill F/up TeamFunction: TH Follow Up
        ,540	--TH Standalones Christchurch F/up TeamFunction: TH Follow Up
        ,714	--TH Standalones Hamilton F/Up TeamFunction: TH Follow Up
        ,553	--TH Standalones Whangarei F/up TeamFunction: TH Follow Up
        ,620	--TH Hub Tara Rd F/up TeamFunction: TH Follow Up
        ,582	--XXX - closed - TH Standalones Hastings_F/up TeamFunction: TH Follow Up
        ,662	--TH Standalones Dunedin F/up TeamFunction: TH Follow Up
        ,633	--TH Hubs Hamilton F/up TeamFunction: TH Follow Up
        ,564	--TH Motels Napier F/Up TeamFunction: TH Follow Up
        ,717	--TH Webb St F/up TeamFunction: TH Follow Up
        ,621	--Transition Support Service TeamFunction: TH Follow Up
        ,530	--TH Hub Manurewa F/up TeamFunction: TH Follow Up
        ,679	--TH Standalones Wellington F/up TeamFunction: TH Follow Up
        ,724	--TH Motels Hutt Valley F/up TeamFunction: TH Follow Up
        ,725	--EH Motels Wellington F/up TeamFunction: TH Follow Up
        ,733	--TH Motels Akld West F/Up TeamFunction: TH Follow Up
        ,736	--XXX - closed - TH Motels Tauranga F/up TeamFunction: TH Follow Up
        ,738	--TH Standalones Tauranga F/up TeamFunction: TH Follow Up
        ,758	--TH Riverbank F/up TeamFunction: TH Follow Up
        ,759	--TH Barber Grove F/up TeamFunction: TH Follow Up
        ,760	--TH Spinnaker F/up TeamFunction: TH Follow Up
        ,731	--EH Motels Masterton F/up TeamFunction: TH Follow Up
        ,571	--TH Standalones Masterton F/up TeamFunction: TH Follow Up
        ,703	--TH Chapel Rd Hub F/Up TeamFunction: TH Follow Up
        ,720	--TH Motels Akld South F/Up TeamFunction: TH Follow Up

         )

CREATE NONCLUSTERED INDEX IX_Teams_to_filter_OUT ON #Teams_to_filter_OUT(client_team_id);

-- Step 7: Build referral base (with early filtering and better joins)
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
        --I'm taking out the below and adding the follow up teams to the exclusion list above
        --AND (vw_dim_client_team.client_team_name NOT LIKE '%f/up%' OR vw_dim_client_team.client_team_name IS NULL)
        AND NOT EXISTS (
            SELECT 1 
            FROM #Teams_to_filter_OUT t 
            WHERE dim_client_referral.client_team_id = t.client_team_id
        );

CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(client_referral_id, dim_company_key);
CREATE NONCLUSTERED INDEX IX_referral_base_dim ON #referral_base(dim_client_referral_key);

-- Step 8: Get referral goals (CORRECTED - filter on personal goals first)
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
WHERE fpg.dim_client_referral_key IN (SELECT dim_client_referral_key FROM #referral_base)  -- ✅ Filter on personal goals
    AND fpg.client_personal_goal_close_date_key IS NULL
    AND fpg.dwhdmloperation <> 'd';

---- Step 8: Get referral goals (optimized with better join strategy)
--    SELECT 
--        fact_client_personal_goal.dim_company_key,
--        referral_goals.client_referral_id,
--        dim_date.calendar_date AS review_date,
--        DATEDIFF(DAY, CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time'))), dim_date.calendar_date) AS days_to_review,
--        ROW_NUMBER() OVER (
--            PARTITION BY fact_client_personal_goal.dim_company_key, referral_goals.client_referral_id 
--            ORDER BY dim_date.calendar_date DESC
--        ) AS Goal_order_futureto
--    INTO #referral_goal
--    FROM edw.fact_client_personal_goal
--    INNER JOIN (
--            SELECT DISTINCT 
--                client_referral_id,
--                fact_client_referral_goal_key,
--                client_referral_goal_next_review_date_key
--            FROM edw.fact_client_referral_goal
            
			
--            --WHERE client_referral_id IN (SELECT client_referral_id FROM #referral_base)
--        ) AS referral_goals 
--        ON fact_client_personal_goal.fact_client_referral_goal_key = referral_goals.fact_client_referral_goal_key
--    INNER JOIN edw.dim_date 
--        ON referral_goals.client_referral_goal_next_review_date_key = dim_date.dim_date_key
--    where dim_client_referral_key IN (SELECT dim_client_referral_key FROM #referral_base)
--    and fact_client_personal_goal.client_personal_goal_close_date_key IS NULL
--        AND fact_client_personal_goal.dwhdmloperation <> 'd';

CREATE NONCLUSTERED INDEX IX_referral_goal ON #referral_goal(client_referral_id, dim_company_key) WHERE Goal_order_futureto = 1;

-- Step 9: Combine referral base with goals (apply 28-day filter)
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
    WHERE rb.days_in_service > 28;

CREATE CLUSTERED INDEX IX_referral_base_2 ON #referral_base_2(service_id, client_referral_id);

-- Step 10: Build final table with target filter
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
        CASE 
            WHEN rb2.days_to_review IS NULL THEN 'Goal Required'
            WHEN rb2.days_to_review BETWEEN 1 AND 7 THEN 'Goal set, but review date within next week'
            WHEN rb2.days_to_review > 7 THEN 'Goal set and review date more than a week away'
            WHEN rb2.days_to_review <= 0 THEN 'Goal review is overdue'
        END AS user_friendly_score_explanation
    INTO #final_table
    FROM #referral_base_2 rb2
    WHERE EXISTS (
        SELECT 1
        FROM edw.vw_dim_kpi_target_definitions t
        WHERE t.service_id = rb2.service_id
            AND t.DWHDMLOperation <> 'D'
            AND t.DWHisCurrent = 1
            AND t.goal_planning_applies = 1
    );

CREATE NONCLUSTERED INDEX IX_final_table ON #final_table(service_id, dim_service_key);


-- Step 11: Final output with KPI status
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
        cast(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' as date) AS snapshot_date

    FROM #final_table ft
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = ft.service_id
    LEFT JOIN #ms_count mc 
        ON sk.kpi_id = mc.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR stg.service_id IS NOT NULL;