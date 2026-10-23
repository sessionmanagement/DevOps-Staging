CREATE     PROCEDURE [edw].[kpi_referral_sp_88_all_whanau_are_seen_face_to_face_each_week]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_referral_sp_88_all_whanau_are_seen_face_to_face_each_week]
 Author (Developer): Manish Singh
 Author (Analyst): Timi Boddington / Greg Nuthall
 Created: 2025-05-25		
 Purpose: Calculate open referrals and whether whaiora have been seen face to face each week
 User Story: 8777 and 9843

 Notes: Converted from view [edw].[kpi_referral_88_all_whanau_are_seen_face_to_face_each_week] 
        to stored procedure with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-05-25   Manish Singh        This view is created to calculate 'Goal_plan_within_14_days' measure 
 1.1       2025-06-13   Timi Boddington     Modified conditions (added extra tables and reformated). Remember DWDDMLoperation ='d' in dim_service
 1.2       2025-06-18   Timi Boddington     Changed the join from dim_client_team from client_team_id to dim_client_team_key. Also duplicates in service_type_grouping, made distinct, which I think it was
 1.3       2025-06-24   Timi Boddington     Added some new criteria based on Jacky Li's findings
 1.4       2025-07-28   Timi Boddington     Changed getdate() in line 184 to NZ Time (Jacky Li)
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 2.1       2026-05-29   Thijs Bohm          Changes to the client_activity_classification_names to match changes in recordbase
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @NZToday DATE = CONVERT(DATE, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')));
    DECLARE @KPI_ID INT = 88;

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
    WHERE dim_kpi.dwhdmloperation <> 'D'
        AND dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

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
    -- Temp Table 5: referral_base
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    
    SELECT 
        dim_date.calendar_date AS accepted_date,
        DATEDIFF(DAY, dim_date.calendar_date, @NZToday) AS days_in_service,
        '' AS kpi_snapshot_client_id,
        vw_fact_client_referral.client_id,
        vw_fact_client_referral.dim_company_key,
        vw_fact_client_referral.dim_client_referral_key,
        vw_fact_client_referral.dim_client_key,
        vw_fact_client_referral.dim_service_key,
        vw_dim_service.service_id,
        vw_fact_client_referral.client_referral_id,
        CONCAT(999, '_', vw_fact_client_referral.client_referral_id, '_', vw_fact_client_referral.client_id, '_', vw_dim_company.company_id) AS entity_key,
        dim_client_referral.client_referral_status,
        dim_client_referral.client_referral_type
    INTO #referral_base
    FROM edw.vw_fact_client_referral
    LEFT JOIN edw.dim_client_referral 
        ON vw_fact_client_referral.dim_client_referral_key = dim_client_referral.dim_client_referral_key
    LEFT JOIN edw.vw_dim_company 
        ON vw_fact_client_referral.dim_company_key = vw_dim_company.dim_company_key
    LEFT JOIN edw.vw_dim_client_team 
        ON vw_fact_client_referral.dim_client_team_key = vw_dim_client_team.dim_client_team_key
    LEFT JOIN edw.vw_dim_service 
        ON vw_fact_client_referral.dim_service_key = vw_dim_service.dim_service_key
    INNER JOIN edw.dim_date 
        ON vw_fact_client_referral.client_referral_accepted_date_key = dim_date.dim_date_key
    WHERE vw_fact_client_referral.dwhdmloperation <> 'd'
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND client_referral_decline_date_key IS NULL
        AND client_referral_discharge_date_key IS NULL
        AND dim_client_referral.client_status_is_active = 'active'
        AND client_referral_status = 'Accepted'
        AND client_team_name NOT LIKE '%f/up%';

    CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(client_referral_id, dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 6: activities
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#activities') IS NOT NULL DROP TABLE #activities;
    
    SELECT DISTINCT 
        CASE 
            WHEN dim_client_team.company_id = 5 THEN 'Mind and Body'
            ELSE 'EmergeAotearoa LTD'
        END AS Company,
        dim_client_team.company_id AS dim_company_key,
        dim_client_team.client_team_id,
        dim_client_team.client_team_name,
        '' AS TeamArea,
        dim_client_team.client_team_function,
        dim_employee.employee_first_name,
        dim_employee.employee_last_name,
        1 AS rows,
        fact_client_activity_breakdown.client_activity_id,
        fact_client_activity_breakdown.client_id AS personid,
        fact_client_activity_breakdown.client_referral_id AS clientreferralid,
        fact_client_activity_breakdown.dim_client_referral_key,
        CAST(fact_client_activity_breakdown.client_activity_start_date AS DATE) AS client_activity_date,
        FORMAT(fact_client_activity_breakdown.client_activity_start_date, 'yyyy-MM') AS calendar_year_month,
        DATEDIFF(DAY, CAST(fact_client_activity_breakdown.client_activity_start_date AS DATE), 
                 CONVERT(DATE, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')))) AS days_activity_to_today,
        fact_client_activity_breakdown.client_activity_start_date,
        fact_client_activity_breakdown.client_activity_end_date,
        fact_client_activity_breakdown.client_activity_duration,
        fact_client_activity_breakdown.client_activity_whanau_involvement,
        fact_client_activity_breakdown.client_parent_activity_id,
        fact_client_activity_breakdown.client_activity_subject,
        fact_client_activity_breakdown.client_activity_type_name,
        fact_client_activity_breakdown.client_activity_classification_name,
        dim_client_activity_breakdown_type.client_activity_breakdown_type_name,
        dim_client_activity_breakdown_type.client_parent_activity_breakdown_type_name
    INTO #activities
    FROM edw.fact_client_activity_breakdown
    LEFT JOIN edw.dim_client_activity_breakdown_type 
        ON fact_client_activity_breakdown.dim_client_activity_breakdown_type_key = dim_client_activity_breakdown_type.dim_client_activity_breakdown_type_key
    INNER JOIN edw.dim_employee 
        ON fact_client_activity_breakdown.dim_employee_key = dim_employee.dim_employee_key
    INNER JOIN edw.dim_client_team 
        ON fact_client_activity_breakdown.dim_client_team_key = dim_client_team.dim_client_team_key
    WHERE fact_client_activity_breakdown.dwhdmloperation <> 'd'
        AND dim_client_activity_breakdown_type.dwhdmloperation <> 'd'
        AND dim_employee.dwhdmloperation <> 'd'
        AND dim_client_team.dwhdmloperation <> 'd'
        AND dim_client_team.client_team_name IS NOT NULL
        AND fact_client_activity_breakdown.client_parent_activity_id IS NULL
         AND (
    (
        fact_client_activity_breakdown.client_activity_start_date <= '2026-05-28'
        AND fact_client_activity_breakdown.client_activity_type_name IN (
             'Online Face to Face'
            ,'Face-to-face'
            ,'1:1 Support'
        )
        AND fact_client_activity_breakdown.client_activity_classification_name NOT IN (
             'Attempted Contact'
            ,'Cancelled'
            ,'Cancelled - rebooked'
            ,'Client cancelled'
            ,'Client cancelled on day'
            ,'Client DNA'
            ,'Did Not Attend'
            ,'F2F contact-unsuccessful'
            ,'Liaison with Professional'
            ,'Phone call- unsuccessful'
            ,'Phone call- unsuccessful, left msg'
            ,'Same Day Cancellation'
            ,'Scheduling'
            ,'T35 Client did not attend, no notice given'
            ,'T35 Did not attend'
        )
        AND dim_client_activity_breakdown_type.client_parent_activity_breakdown_type_name NOT IN (
            'Non contact'
        )
        AND dim_client_activity_breakdown_type.client_activity_breakdown_type_name NOT IN (
             'Client cancelled'
            ,'Contact with external agency'
            ,'Contact with landlord'
            ,'Contact with OT'
            ,'Contact with other agency'
            ,'Contact with other agency, client not present'
            ,'Contact with other Health Prof'
            ,'Contact with other health professional'
            ,'Contact with other health professional.'
        )
    )
    OR
    (
        fact_client_activity_breakdown.client_activity_start_date > '2026-05-28'
        AND fact_client_activity_breakdown.client_activity_type_name = 'Face-to-face'
        AND dim_client_activity_breakdown_type.client_activity_breakdown_type_name = N'Contact with person/whānau accessing service'
        AND fact_client_activity_breakdown.client_activity_classification_name NOT IN (
             'Attempted contact'
            ,'Client DNA'
            ,'External agency contact'
            ,'Internal contact'
            ,'Tenancy services'
        )
    )
);

    CREATE CLUSTERED INDEX IX_activities ON #activities(company, clientreferralid, client_activity_start_date DESC);

    -------------------------------------------------------------------------------
    -- Temp Table 7: activities_staged
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#activities_staged') IS NOT NULL DROP TABLE #activities_staged;
    
    SELECT 
        ROW_NUMBER() OVER (
            PARTITION BY company, clientreferralid 
            ORDER BY client_activity_start_date DESC
        ) AS Activity_order,
        *
    INTO #activities_staged
    FROM #activities;

    CREATE CLUSTERED INDEX IX_activities_staged ON #activities_staged(clientreferralid, dim_company_key, Activity_order);

    -------------------------------------------------------------------------------
    -- Temp Table 8: referrals_stage_2
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referrals_stage_2') IS NOT NULL DROP TABLE #referrals_stage_2;
    
    SELECT 
        rb.*,
        a.client_activity_start_date,
        a.days_activity_to_today
    INTO #referrals_stage_2
    FROM #referral_base rb
    LEFT JOIN (
        SELECT 
            dim_company_key,
            clientreferralid,
            client_activity_start_date,
            days_activity_to_today
        FROM #activities_staged
        WHERE Activity_order = 1
    ) a 
        ON rb.client_referral_id = a.clientreferralid
        AND rb.dim_company_key = a.dim_company_key;

    CREATE NONCLUSTERED INDEX IX_referrals_stage_2_service ON #referrals_stage_2(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 9: final_table
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    
    SELECT 
        dim_company_key,
        client_referral_id,
        client_id,
        dim_client_referral_key,
        entity_key,
        dim_service_key,
        service_id,
        days_in_service,
        days_activity_to_today AS kpi_value,
        client_referral_status,
        CASE
            WHEN days_activity_to_today IS NULL THEN 'No FTF Activity'
            ELSE CONCAT('Last FTF activity ', days_activity_to_today, ' days ago')
        END AS user_friendly_score_explanation
    INTO #final_table
    FROM #referrals_stage_2;

    CREATE NONCLUSTERED INDEX IX_final_table_service ON #final_table(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 10: final_final_table
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_final_table') IS NOT NULL DROP TABLE #final_final_table;
    
    SELECT 
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_client_referral_key,
        ft.client_referral_id,
        ft.client_referral_status,
        ft.entity_key,
        ft.dim_service_key,
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
        END AS kpi_status
    INTO #final_final_table
    FROM #final_table ft
    CROSS JOIN #selected_kpi sk;

    CREATE NONCLUSTERED INDEX IX_final_final_table ON #final_final_table(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT 
        fff.dim_kpi_key,
        fff.dim_company_key,
        fff.dim_client_referral_key,
        fff.dim_service_key,
        fff.entity_key,
        @KPI_ID AS kpi_id,
         fff.client_referral_id,
        fff.service_id,
        fff.kpi_value,
        fff.user_friendly_score_explanation,
        fff.kpi_status,
        
        @SnapshotDate AS snapshot_date
    FROM #final_final_table fff
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg 
        ON sk.dim_kpi_key = stg.dim_kpi_key
        AND fff.service_id = stg.service_id
    LEFT JOIN #ms_count mc 
        ON mc.kpi_id = sk.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);

END