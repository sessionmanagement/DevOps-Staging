
CREATE   PROCEDURE [edw].[kpi_referral_sp_137_all_wahiora_engaged_community_activity]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_referral_sp_137_all_wahiora_engaged_community_activity]
 Author (Developer): Manish Singh
 Author (Analyst): Timi Boddington / Greg Nuthall
 Created: 2025-05-23		
 Purpose: Calculate open and in-date goals for Wahiora engaged community activity
 User Story: 9841

 Notes: Converted from view [edw].[kpi_referral_137_all_wahiora_engaged_community_activity] to stored procedure 
        with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-05-23   Manish Singh        This view is created to calculate [edw].[kpi_referral_137_all_Whaiora_engaged_community_activity]
 1.1       2025-06-16   Timi Boddington     Reformatted programme, added in dwhdmloperation <> 'd' for dim_service join
 1.2       2025-06-18   Timi Boddington     Duplicates in service_type_grouping, made distinct, which I think it was
 1.3       2025-07-31   Thijs Bohm          Changes made to Activity filter condition to reflect definition change of 'community activity'.
 1.4       2025-08-05   Thijs Bohm          Definition of 'Community activity'change. New filter conditions applied.
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @NZDateTime DATETIME = CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')));
    DECLARE @KPI_ID INT = 137;

    -------------------------------------------------------------------------------
    -- Temp Table 1: referral_base (active referrals)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    
    SELECT 
        dim_date.calendar_date AS accepted_date,
        DATEDIFF(DAY, dim_date.calendar_date, @NZDateTime) AS days_in_service,
        '' AS kpi_snapshot_client_id,
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
    LEFT JOIN edw.dim_client_referral 
        ON vw_fact_client_referral.dim_client_referral_key = dim_client_referral.dim_client_referral_key
    LEFT JOIN edw.vw_dim_company dco 
        ON vw_fact_client_referral.dim_company_key = dco.dim_company_key
    LEFT JOIN edw.dim_service 
        ON vw_fact_client_referral.dim_service_key = dim_service.dim_service_key
    INNER JOIN edw.dim_date 
        ON vw_fact_client_referral.client_referral_accepted_date_key = dim_date.dim_date_key
    WHERE vw_fact_client_referral.DWHDMLOperation <> 'd'
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND client_referral_decline_date_key IS NULL
        AND client_referral_discharge_date_key IS NULL
        AND dim_client_referral.client_status_is_active = 'active';

    CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(client_referral_id);
    CREATE NONCLUSTERED INDEX IX_referral_base_company ON #referral_base(dim_company_key);

    -------------------------------------------------------------------------------
    -- Temp Table 2: Activities (community activities)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Activities') IS NOT NULL DROP TABLE #Activities;
    
    SELECT DISTINCT 
        CASE 
            WHEN dim_client_team.company_id = 5 THEN 'Mind and Body'
            ELSE 'EmergeAotearoa LTD'
        END AS Company,
        dim_client_team.company_id AS dim_company_key,
        dim_client_team.client_team_id,
        dim_client_team.client_team_name,
        dim_client_team.client_team_area,
        dim_client_team.client_team_function,
        dim_employee.employee_first_name,
        dim_employee.employee_last_name,
        1 AS rows,
        client_activity_id,
        client_id AS personid,
        client_referral_id AS clientreferralid,
        dim_client_referral_key,
        CAST(client_activity_start_date AS DATE) AS client_activity_date,
        FORMAT(client_activity_start_date, 'yyyy-MM') AS calendar_year_month,
        DATEDIFF(DAY, client_activity_start_date, @NZDateTime) AS days_activity_to_today,
        client_activity_start_date,
        client_activity_end_date,
        client_activity_duration,
        client_activity_whanau_involvement,
        client_parent_activity_id,
        client_activity_subject,
        client_activity_type_name,
        client_activity_classification_name,
        client_activity_breakdown_type_name,
        client_parent_activity_breakdown_type_name
    INTO #Activities
    FROM edw.fact_client_activity_breakdown
    LEFT JOIN edw.dim_client_activity_breakdown_type 
        ON fact_client_activity_breakdown.dim_client_activity_breakdown_type_key = dim_client_activity_breakdown_type.dim_client_activity_breakdown_type_key
    INNER JOIN edw.dim_employee 
        ON fact_client_activity_breakdown.dim_employee_key = dim_employee.dim_employee_key
    INNER JOIN edw.dim_client_team 
        ON fact_client_activity_breakdown.dim_client_team_key = dim_client_team.dim_client_team_key
    WHERE client_team_name IS NOT NULL
        AND fact_client_activity_breakdown.DWHDMLOperation <> 'd'
        AND dim_client_activity_breakdown_type.DWHDMLOperation <> 'd'
        AND dim_employee.DWHDMLOperation <> 'd'
        AND edw.dim_client_team.DWHDMLOperation <> 'd'
        AND client_activity_classification_name NOT IN (
            'Attempted Contact',
            'Cancelled',
            'Cancelled - rebooked',
            'Client cancelled',
            'Client cancelled on day',
            'Client DNA',
            'Did Not Attend',
            'F2F contact-unsuccessful',
            'Liaison with Professional',
            'Phone call- unsuccessful',
            'Phone call- unsuccessful, left msg',
            'Same Day Cancellation',
            'Scheduling',
            'T35 Client did not attend, no notice given',
            'T35 Did not attend',
            'DNA'
        )
        AND client_activity_breakdown_type_name IN (
            'At work',
            'School',
            'Social/Community interaction',
            'Study/course',
            'Education-English as second language',
            'Education-Work Skills Training',
            'Community engagement',
            'Education/training',
            'Family/whanau contact',
            'GP contact',
            'MH/AOD info support/advocacy',
            'No contact, client offsite',
            'Other Health Professional contact',
            'Psychologist contact',
            'Face to face with individual/family',
            'Contact with other Agency',
            'Contact with external agency',
            'Budgeting & finance',
            'Counselling',
            'Parenting Programme',
            'Other Mental Health services',
            'Other Training',
            'Employment coaching',
            'Parenting support',
            'Coaching',
            'Contact with individual/family',
            'Contact with other NGO',
            'Contact with WINZ',
            'Contact with other Health Prof',
            'Financial Literacy (Workshop 7)',
            'Financial Literacy (Workshop 8)',
            'Sign agreement, motel induction',
            'Financial Capabilities Graduation',
            'Contact with other agency, client present',
            'Counselling support',
            'Cultural support',
            'AOD',
            'Mental Health support',
            'Employment support',
            'Primary Health',
            'Contact with OT',
            'Group Travel'
        );

    CREATE CLUSTERED INDEX IX_Activities ON #Activities(clientreferralid, dim_company_key, client_activity_start_date DESC);

    -------------------------------------------------------------------------------
    -- Temp Table 3: Activites_Staged (ranked activities)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Activites_Staged') IS NOT NULL DROP TABLE #Activites_Staged;
    
    SELECT 
        ROW_NUMBER() OVER (
            PARTITION BY Company, clientreferralid 
            ORDER BY Company, clientreferralid, client_activity_start_date DESC
        ) AS Activity_order,
        Company,
        dim_company_key,
        client_team_id,
        client_team_name,
        client_team_area,
        client_team_function,
        employee_first_name,
        employee_last_name,
        rows,
        client_activity_id,
        personid,
        clientreferralid,
        dim_client_referral_key,
        client_activity_date,
        calendar_year_month,
        days_activity_to_today,
        client_activity_start_date,
        client_activity_end_date,
        client_activity_duration,
        client_activity_whanau_involvement,
        client_parent_activity_id,
        client_activity_subject,
        client_activity_type_name,
        client_activity_classification_name,
        client_activity_breakdown_type_name,
        client_parent_activity_breakdown_type_name
    INTO #Activites_Staged
    FROM #Activities;

    CREATE CLUSTERED INDEX IX_Activites_Staged ON #Activites_Staged(clientreferralid, dim_company_key, Activity_order);

    -------------------------------------------------------------------------------
    -- Temp Table 4: Referrals_Stage_2 (referrals with latest activity)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Referrals_Stage_2') IS NOT NULL DROP TABLE #Referrals_Stage_2;
    
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
        ma.client_activity_start_date,
        ma.days_activity_to_today
    INTO #Referrals_Stage_2
    FROM #referral_base rb
    LEFT JOIN (
        SELECT 
            dim_company_key,
            clientreferralid,
            CAST(client_activity_start_date AS DATE) AS client_activity_start_date,
            days_activity_to_today
        FROM #Activites_Staged
        WHERE Activity_order = 1
    ) AS ma 
        ON rb.client_referral_id = ma.clientreferralid
        AND rb.dim_company_key = ma.dim_company_key;

    CREATE CLUSTERED INDEX IX_Referrals_Stage_2 ON #Referrals_Stage_2(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: final_table
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
        CASE 
            WHEN days_activity_to_today IS NULL THEN 'No Community Activity'
            WHEN days_activity_to_today IS NOT NULL 
                THEN CONCAT('Last Community Activity ', days_activity_to_today, ' days ago')
        END AS user_friendly_score_explanation
    INTO #final_table
    FROM #Referrals_Stage_2;

    CREATE NONCLUSTERED INDEX IX_final_table_service ON #final_table(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: Selected_KPIs
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Selected_KPIs') IS NOT NULL DROP TABLE #Selected_KPIs;
    
    SELECT TOP 1 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_kpi.what_is_measured,
        dim_kpi.kpi_g_value,
        dim_kpi.kpi_a_value,
        dim_kpi.kpi_g_sign,
        dim_kpi.kpi_a_sign
    INTO #Selected_KPIs
    FROM edw.dim_kpi
    WHERE dim_kpi.dwhdmloperation <> 'D'
        AND dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    -------------------------------------------------------------------------------
    -- Temp Table 7: service_type_grouping
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
        AND dim_service.dwhdmloperation <> 'D'
    WHERE dim_kpi.dwhiscurrent = 1;

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 8: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT 
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_client_referral_key,
        ft.dim_service_key,
        ft.entity_key,
        @KPI_ID AS kpi_id,
        ft.client_referral_id,
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
        END AS kpi_status,
        @SnapshotDate AS snapshot_date
    FROM #final_table ft
    CROSS JOIN #Selected_KPIs sk
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = ft.service_id
    LEFT JOIN #ms_count mc 
        ON mc.kpi_id = sk.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);

    -- Cleanup temp tables
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    IF OBJECT_ID('tempdb..#Activities') IS NOT NULL DROP TABLE #Activities;
    IF OBJECT_ID('tempdb..#Activites_Staged') IS NOT NULL DROP TABLE #Activites_Staged;
    IF OBJECT_ID('tempdb..#Referrals_Stage_2') IS NOT NULL DROP TABLE #Referrals_Stage_2;
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    IF OBJECT_ID('tempdb..#Selected_KPIs') IS NOT NULL DROP TABLE #Selected_KPIs;
    IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;

END