CREATE    PROCEDURE [edw].[kpi_referral_sp_133_ftf_activity]

/**********************************************************************************************************
 KPI SP: edw.kpi_referral_sp_133_ftf_activity
 Author (Developer):  Greg Nuthall  
 Author (Analyst):    Timi Boddington / Thijs Bohm
 Created:             2025-12-19     
 Purpose:             Calculate last Face to Face activity completed with service level targets
 User Story:          9843

 REVISIONS:
 Version  Date        Author             Description
 ------   ----------  -----------------  --------------------------
 1.0      2025-12-19  Greg Nuthall       Initial stored procedure creation (optimized from view)
 1.1      2025-07-02  Timi Boddington    Changed select for dim_client_referral_service_level
 1.2      2025-07-17  Manish Singh       Added dwhdmloperationfield<>'D' condition to avoid duplicates
 1.3      2025-12-19  Greg Nuthall       Fixed column references - activity columns are on fact table
 1.4      2026-01-27  Greg Nuthall       Fixed ROW_NUMBER() ORDER BY to match view exactly
 1.5      2026-01-27  Greg Nuthall       Fixed service type grouping (LEFT JOIN), service level lookup (subquery), ms_count_0 logic
 1.6      2026-05-29  Thijs Bohm         Changes to the client_activity_classification_names to match changes in recordbase
-- *************************************************************************************************************/
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    -- Declare KPI ID constant
    DECLARE @KPI_ID INT = 133;
    DECLARE @NZtoday DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);

    -- Clean up temp tables
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    IF OBJECT_ID('tempdb..#Activities') IS NOT NULL DROP TABLE #Activities;
    IF OBJECT_ID('tempdb..#Activites_Staged') IS NOT NULL DROP TABLE #Activites_Staged;
    IF OBJECT_ID('tempdb..#Referrals_Stage_2') IS NOT NULL DROP TABLE #Referrals_Stage_2;
    IF OBJECT_ID('tempdb..#Service_Level') IS NOT NULL DROP TABLE #Service_Level;
    IF OBJECT_ID('tempdb..#Include_Target_logic') IS NOT NULL DROP TABLE #Include_Target_logic;
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    IF OBJECT_ID('tempdb..#ms_count_0') IS NOT NULL DROP TABLE #ms_count_0;
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
    WHERE dim_kpi.DWHDMLOperation <> 'D'
        AND dim_kpi.DWHIsCurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    ------------------------------------------------------------
    -- Step 2: Build service type grouping - FIXED: Use LEFT JOIN like VIEW
    ------------------------------------------------------------
    SELECT 
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
    WHERE dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = (SELECT kpi_id FROM #selected_kpi);

    ------------------------------------------------------------
    -- Step 3: Calculate ms_count - FIXED: Add ms_count_0 intermediate step like VIEW
    ------------------------------------------------------------
    SELECT 
        (SELECT DISTINCT kpi_id FROM #selected_kpi) AS kpi_id,
        service_id
    INTO #ms_count_0
    FROM #service_type_grouping;

    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #ms_count_0
    GROUP BY kpi_id;

    ------------------------------------------------------------
    -- Step 4: Build referral base - FIXED: Use LEFT JOIN like VIEW
    ------------------------------------------------------------
    SELECT 
        dim_date.calendar_date AS accepted_date,
        DATEDIFF(DAY, dim_date.calendar_date, CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')))) AS days_in_service,
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
    LEFT JOIN edw.dim_service 
        ON vw_fact_client_referral.dim_service_key = dim_service.dim_service_key
    INNER JOIN edw.dim_date 
        ON vw_fact_client_referral.client_referral_accepted_date_key = dim_date.dim_date_key
    LEFT JOIN edw.vw_dim_company dco 
        ON vw_fact_client_referral.dim_company_key = dco.dim_company_key
    WHERE vw_fact_client_referral.DWHDMLOperation <> 'd'
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND vw_fact_client_referral.client_referral_decline_date_key IS NULL
        AND vw_fact_client_referral.client_referral_discharge_date_key IS NULL
        AND dim_client_referral.client_status_is_active = 'active';

    CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(dim_client_referral_key);
    CREATE NONCLUSTERED INDEX IX_referral_base_ref ON #referral_base(client_referral_id, dim_company_key);

    ------------------------------------------------------------
    -- Step 5: Get Face to Face activities (filtered)
    ------------------------------------------------------------
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
        fcab.client_activity_id,
        fcab.client_id AS personid,
        fcab.client_referral_id AS clientreferralid,
        fcab.dim_client_referral_key,
        CAST(fcab.client_activity_start_date AS DATE) AS client_activity_date,
        FORMAT(fcab.client_activity_start_date, 'yyyy-MM') AS calendar_year_month,
        DATEDIFF(DAY, CAST(fcab.client_activity_start_date AS DATE), 
            CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')))) AS days_activity_to_today,
        fcab.client_activity_start_date,
        fcab.client_activity_end_date,
        fcab.client_activity_duration,
        fcab.client_activity_whanau_involvement,
        fcab.client_parent_activity_id,
        fcab.client_activity_subject,
        fcab.client_activity_type_name,
        fcab.client_activity_classification_name,
        dcabt.client_activity_breakdown_type_name,
        dcabt.client_parent_activity_breakdown_type_name
    INTO #Activities
    FROM edw.fact_client_activity_breakdown fcab
    LEFT JOIN edw.dim_client_activity_breakdown_type dcabt 
        ON fcab.dim_client_activity_breakdown_type_key = dcabt.dim_client_activity_breakdown_type_key
    INNER JOIN edw.dim_employee 
        ON fcab.dim_employee_key = dim_employee.dim_employee_key
    INNER JOIN edw.dim_client_team 
        ON fcab.dim_client_team_key = dim_client_team.dim_client_team_key
    WHERE dim_client_team.client_team_name IS NOT NULL
        AND fcab.client_parent_activity_id IS NULL
        AND fcab.DWHDMLOperation <> 'd'
        AND dcabt.DWHDMLOperation <> 'd'
        AND dim_employee.DWHDMLOperation <> 'd'
        AND dim_client_team.DWHDMLOperation <> 'd'
     AND (
    (
        fcab.client_activity_start_date <= '2026-05-28'
        AND fcab.client_activity_type_name IN (
             'Online Face to Face'
            ,'Face-to-face'
            ,'1:1 Support'
        )
        AND fcab.client_activity_classification_name NOT IN (
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
        AND dcabt.client_parent_activity_breakdown_type_name NOT IN (
            'Non contact'
        )
        AND dcabt.client_activity_breakdown_type_name NOT IN (
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
        fcab.client_activity_start_date > '2026-05-28'
        AND fcab.client_activity_type_name = 'Face-to-face'
        AND dcabt.client_activity_breakdown_type_name = N'Contact with person/whānau accessing service'
        AND fcab.client_activity_classification_name NOT IN (
             'Attempted contact'
            ,'Client DNA'
            ,'External agency contact'
            ,'Internal contact'
            ,'Tenancy services'
        )
    )
);

    ------------------------------------------------------------
    -- Step 6: Get latest activity per referral
    ------------------------------------------------------------
    SELECT 
        ROW_NUMBER() OVER (
            PARTITION BY Company, clientreferralid 
            ORDER BY Company, clientreferralid, client_activity_start_date DESC
        ) AS Activity_order,
        *
    INTO #Activites_Staged
    FROM #Activities;

    CREATE NONCLUSTERED INDEX IX_Activites_Staged ON #Activites_Staged(clientreferralid, dim_company_key) WHERE Activity_order = 1;

    ------------------------------------------------------------
    -- Step 7: Combine referrals with latest activity
    ------------------------------------------------------------
    SELECT 
        rb.accepted_date,
        rb.days_in_service,
        rb.dim_company_key,
        rb.dim_client_referral_key,
        rb.dim_client_key,
        rb.dim_service_key,
        rb.service_id,
        rb.client_referral_id,
        rb.entity_key,
        rb.client_referral_status,
        rb.client_referral_type,
        ast.client_activity_start_date,
        ast.days_activity_to_today
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
    ) ast 
        ON rb.client_referral_id = ast.clientreferralid
        AND rb.dim_company_key = ast.dim_company_key;

    CREATE CLUSTERED INDEX IX_Referrals_Stage_2 ON #Referrals_Stage_2(dim_client_referral_key);

    ------------------------------------------------------------
    -- Step 8: Calculate target days based on service level
    -- FIXED: Use subquery from dim_client_referral_service_level with DISTINCT like VIEW
    ------------------------------------------------------------
    SELECT 
        rs2.dim_company_key,
        rs2.client_referral_id,
        rs2.dim_client_referral_key,
        rs2.entity_key,
        rs2.dim_service_key,
        rs2.service_id,
        rs2.days_in_service,
        rs2.days_activity_to_today,
        sl.service_level_code,
        CASE 
            WHEN sl.service_level_code = 'SL1' THEN 28
            WHEN sl.service_level_code = 'SL2' THEN 14
            WHEN sl.service_level_code = 'SL3' THEN 7
            WHEN sl.service_level_code IS NULL THEN 28
        END AS target_days
    INTO #Include_Target_logic
    FROM #Referrals_Stage_2 rs2
    LEFT JOIN (
        SELECT DISTINCT 
            dim_client_referral_key,
            service_level_code
        FROM edw.dim_client_referral_service_level
        WHERE DWHIsCurrent = 1 
            AND dwhdmloperationfield <> 'D'
    ) sl 
        ON rs2.dim_client_referral_key = sl.dim_client_referral_key;

    ------------------------------------------------------------
    -- Step 9: Build final table with KPI value calculation
    ------------------------------------------------------------
    SELECT 
        itl.dim_company_key,
        itl.client_referral_id,
        itl.dim_client_referral_key,
        itl.entity_key,
        itl.dim_service_key,
        itl.service_id,
        itl.days_in_service,
        itl.days_activity_to_today,
        itl.service_level_code,
        itl.target_days,
        itl.days_activity_to_today - itl.target_days AS kpi_value,
        CASE 
            WHEN itl.days_activity_to_today IS NULL THEN 'No FTF Activity'
            WHEN itl.days_activity_to_today BETWEEN 0 AND 7 
                THEN CONCAT('FTF in last 7 days. Target: ', itl.target_days, ' days')
            WHEN itl.days_activity_to_today BETWEEN 8 AND 14 
                THEN CONCAT('FTF between 8 and 14 days ago. Target: ', itl.target_days, ' days')
            WHEN itl.days_activity_to_today BETWEEN 15 AND 28 
                THEN CONCAT('FTF between 15 and 28 days ago. Target: ', itl.target_days, ' days')
            WHEN itl.days_activity_to_today > 28 
                THEN CONCAT('FTF more than 28 days ago.Target: ', itl.target_days, ' days')
        END AS user_friendly_score_explanation
    INTO #final_table
    FROM #Include_Target_logic itl;

    ------------------------------------------------------------
    -- Step 10: Final output with KPI status
    ------------------------------------------------------------
    SELECT 
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_client_referral_key,
        ft.dim_service_key,
        ft.entity_key,
        sk.kpi_id,
        ft.client_referral_id,
        ds.service_id,
        ft.kpi_value,
        ft.user_friendly_score_explanation,
        CASE 
            WHEN ft.kpi_value IS NULL THEN 1
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
    LEFT JOIN edw.dim_service ds 
        ON ft.dim_service_key = ds.dim_service_key
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND ft.service_id = stg.service_id
    LEFT JOIN #ms_count mc 
        ON sk.kpi_id = mc.kpi_id
    WHERE ((mc.service_count IS NULL OR mc.service_count = 0) OR stg.service_id IS NOT NULL);

END