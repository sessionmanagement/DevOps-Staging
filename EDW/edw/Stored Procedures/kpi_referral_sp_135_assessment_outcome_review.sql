CREATE   PROCEDURE [edw].[kpi_referral_sp_135_assessment_outcome_review]
AS

/**********************************************************************************************************
 Procedure: [edw].[kpi_referral_sp_135_assessment_outcome_review]
 Author (Developer): Manish Singh	
 Author (Analyst): Timi Boddington / Thijs Bohm / Greg Nuthall
 Created: 2025-06-09		
 Purpose: Calculate open and in-date outcome assessments
 User Story: 9839 

 Notes: Converted from view [edw].[kpi_referral_135_assessment_outcome_review] to stored procedure 
        with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-06-09   Manish Singh        Initial version
 1.1       2025-06-27   Timi Boddington     Remove Duplicates (dim_kpi_target_definitions was found to have duplicates)
 1.2       2025-07-30   Thijs Bohm          Filter out One-off and clinical teams
 1.4       2025-08-14   Thijs Bohm          Filter out Follow up teams
 1.5       2025-09-02   Thijs Bohm          Change Left Join to Inner Join to exclude services without a target
 2.0       2026-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 2.1       2026-04-08   Timi Boddington     More exclusions for teams. User story 13328
 2.2       2026-05-13   Timi Boddington     More Exclusions, Change in description User Story 13507
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @NZDateTime DATETIME = CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')));
    DECLARE @KPI_ID INT = 135;

    -------------------------------------------------------------------------------
    -- Temp Table 1: TeamFunctionGroups (team filtering logic)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#TeamFunctionGroups') IS NOT NULL DROP TABLE #TeamFunctionGroups;
    
    SELECT
        service_id,
        client_team_function,
        COUNT(DISTINCT client_team_name) AS team_count,
        COUNT(DISTINCT client_team_function) AS function_count
    INTO #TeamFunctionGroups
    FROM edw.vw_dim_client_team
    WHERE service_id <> '0'
    GROUP BY service_id, client_team_function;

    CREATE CLUSTERED INDEX IX_TeamFunctionGroups ON #TeamFunctionGroups(service_id, client_team_function);

    -------------------------------------------------------------------------------
    -- Temp Table 2: FilteredTeams
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#FilteredTeams') IS NOT NULL DROP TABLE #FilteredTeams;
    
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

    CREATE CLUSTERED INDEX IX_FilteredTeams ON #FilteredTeams(client_team_id);

   
    -------------------------------------------------------------------------------
    -- Temp Table 3: Teams_to_filter_OUT
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Teams_to_filter_OUT') IS NOT NULL DROP TABLE #Teams_to_filter_OUT;
    
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
    WHERE (
        client_team_id in (
         404 -- Phoenix Peer Support  --want to keep Phoenix Clinical User Story 13328
        ,408  --WDHB Mainstream - Clinical
        ,410  --Ola Lei - Clinical
        ,425  --Auckland Adult Mobile - Clinical
        ,487  --X ABE Clinical ChCh - shouldn't exist anyway
        ,509  --XXX - closed - Youth Mobile CS Chch - Clinical - shouldn't exist anyway
        ,510  --XXXC - closed - Early Intvn Psych Sppt - Clinical - shouldn't exist anyway
        ,542  --Mapusaga Clinical
        ,544  --Jansen House - Clinical
        ,546  --Nga Taumahatanga - Clinical
        ,683  --EaseUp - ADHB - One Off Support
        ,686  --EaseUp - West - One Off Support
        ,709  --EaseUp - Waikato - One Off Support
        ,742  --Kia Ora Ake - One Off Support
        ,749  --EaseUp - North - One Off Support
        ,721  --Tiakina - DBT Group - User Story 13507
        ,765  --VR - Youth Mobile CS Chch - User Story 13507

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
        );

    CREATE CLUSTERED INDEX IX_Teams_to_filter_OUT ON #Teams_to_filter_OUT(client_team_id);

   

    -------------------------------------------------------------------------------
    -- Temp Table 4: referral_base
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    
    SELECT 
        dim_date.calendar_date AS accepted_date,
        DATEDIFF(DAY, dim_date.calendar_date, @NZDateTime) AS days_in_service,
        '' AS kpi_snapshot_client_id,
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
    LEFT JOIN edw.vw_dim_client_team
        ON vw_fact_client_referral.dim_client_team_key = vw_dim_client_team.dim_client_team_key
    LEFT JOIN edw.dim_service
        ON vw_fact_client_referral.dim_service_key = dim_service.dim_service_key
    INNER JOIN edw.dim_date
        ON vw_fact_client_referral.client_referral_accepted_date_key = dim_date.dim_date_key
    LEFT JOIN edw.vw_dim_company dco
        ON vw_fact_client_referral.dim_company_key = dco.dim_company_key
    WHERE vw_fact_client_referral.DWHDMLOperation <> 'd'
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND client_referral_decline_date_key IS NULL
        AND client_referral_discharge_date_key IS NULL
        AND dim_client_referral.client_status_is_active = 'active'
      --  AND client_team_name NOT LIKE '%f/up%'  Removing this to tidy up and adding them into the exclusion list above Timi
        AND dim_client_referral.client_team_id NOT IN (SELECT client_team_id FROM #Teams_to_filter_OUT);

    CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(client_referral_id);
    CREATE NONCLUSTERED INDEX IX_referral_base_service ON #referral_base(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: outcomes (latest assessment outcomes)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#outcomes') IS NOT NULL DROP TABLE #outcomes;
    
    SELECT 
        ROW_NUMBER() OVER (PARTITION BY dim_company_key, client_referral_id ORDER BY response_created_date DESC) AS latest_key,
        dim_company_key,
        client_referral_id,
        CAST(response_created_date AS DATE) AS response_created_date,
        total_score,
        client_outcome_tool_title
    INTO #outcomes
    FROM edw.fact_client_assessment_outcome
    WHERE DWHIsCurrent = 1
        AND client_referral_id IN (SELECT client_referral_id FROM #referral_base)
        AND total_score > 0;

    CREATE CLUSTERED INDEX IX_outcomes ON #outcomes(client_referral_id, latest_key);

    -------------------------------------------------------------------------------
    -- Temp Table 6: referral_base_2 (with latest outcome)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referral_base_2') IS NOT NULL DROP TABLE #referral_base_2;
    
    SELECT 
        rb.accepted_date,
        rb.days_in_service,
        rb.kpi_snapshot_client_id,
        rb.dim_company_key,
        rb.dim_client_referral_key,
        rb.dim_client_key,
        rb.dim_service_key,
        rb.service_id,
        rb.client_referral_id,
        rb.entity_key,
        rb.client_referral_status,
        rb.client_referral_type,
        o.client_outcome_tool_title,
        o.response_created_date AS last_response_created_date
    INTO #referral_base_2
    FROM #referral_base rb
    LEFT JOIN (
        SELECT dim_company_key, client_referral_id, client_outcome_tool_title, response_created_date
        FROM #outcomes
        WHERE latest_key = 1
    ) o ON rb.client_referral_id = o.client_referral_id
        AND rb.dim_company_key = o.dim_company_key;

    CREATE CLUSTERED INDEX IX_referral_base_2 ON #referral_base_2(client_referral_id);

    -------------------------------------------------------------------------------
    -- Temp Table 7: referral_final (with days since last assessment)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referral_final') IS NOT NULL DROP TABLE #referral_final;
    
    SELECT 
        accepted_date,
        days_in_service,
        kpi_snapshot_client_id,
        dim_company_key,
        dim_client_referral_key,
        dim_client_key,
        dim_service_key,
        service_id,
        client_referral_id,
        entity_key,
        client_referral_status,
        client_referral_type,
        client_outcome_tool_title,
        last_response_created_date,
        DATEDIFF(DAY, last_response_created_date, @NZDateTime) AS days_since_last_assessment
    INTO #referral_final
    FROM #referral_base_2;

    CREATE CLUSTERED INDEX IX_referral_final ON #referral_final(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 8: final_table (filter for > 28 days in service)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    
    SELECT 
        dim_company_key,
        dim_client_referral_key,
        client_referral_id,
        entity_key,
        dim_service_key,
        service_id,
        days_since_last_assessment,
        days_in_service
    INTO #final_table
    FROM #referral_final
    WHERE days_in_service > 28;

  
    CREATE CLUSTERED INDEX IX_final_table ON #final_table(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 9: service_targets
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#service_targets') IS NOT NULL DROP TABLE #service_targets;
    
    SELECT DISTINCT 
        vw_dim_kpi_target_definitions.service_id,
        vw_dim_kpi_target_definitions.outcome_tool_review AS target_assessment
    INTO #service_targets
    FROM edw.vw_dim_kpi_target_definitions
    WHERE vw_dim_kpi_target_definitions.DWHDMLOperation <> 'D'
        AND vw_dim_kpi_target_definitions.DWHisCurrent = 1
        AND vw_dim_kpi_target_definitions.outcome_tool_review IS NOT NULL
        AND vw_dim_kpi_target_definitions.outcome_tool_review <> 0;

    CREATE CLUSTERED INDEX IX_service_targets ON #service_targets(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 10: include_target (join with service targets)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#include_target') IS NOT NULL DROP TABLE #include_target;
    
    SELECT 
        ft.dim_company_key,
        ft.dim_client_referral_key,
        ft.client_referral_id,
        ft.entity_key,
        ft.dim_service_key,
        ft.service_id,
        ft.days_since_last_assessment,
        CASE 
            WHEN ft.days_since_last_assessment IS NULL 
                THEN CONCAT('Assessment required. Referral accepted: ', ft.days_in_service, ' days ago.')
            WHEN ft.days_since_last_assessment IS NOT NULL AND st.target_assessment IS NULL
                THEN CONCAT('Assessment performed: ', ft.days_since_last_assessment, ' days ago. Target is missing ')
            ELSE CONCAT('Assessment performed: ', ft.days_since_last_assessment, ' days ago. Target: Complete every ', CAST(st.target_assessment AS INT), ' days')
        END AS user_friendly_score_explanation,
        st.target_assessment,
        CAST(st.target_assessment - ft.days_since_last_assessment AS INT) AS kpi_value
    INTO #include_target
    FROM #final_table ft
    INNER JOIN #service_targets st
        ON ft.service_id = st.service_id;

    CREATE NONCLUSTERED INDEX IX_include_target_service ON #include_target(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 11: selected_kpi
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
    WHERE dim_kpi.DWHDMLOperation <> 'D'
        AND dim_kpi.DWHIsCurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    -------------------------------------------------------------------------------
    -- Temp Table 12: service_type_grouping
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#service_type_grouping') IS NOT NULL DROP TABLE #service_type_grouping;
    
    SELECT DISTINCT 
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_service.service_id
    INTO #service_type_grouping
    FROM edw.dim_kpi
    LEFT JOIN edw.bridge_kpi_measure_to_service_type_group ON dim_kpi.dim_kpi_key = bridge_kpi_measure_to_service_type_group.dim_kpi_key
    LEFT JOIN edw.dim_kpi_service_type_grouping ON bridge_kpi_measure_to_service_type_group.service_type_grouping_id = dim_kpi_service_type_grouping.dim_kpi_service_type_grouping_key
        AND dim_kpi_service_type_grouping.dwhiscurrent = 1
    LEFT JOIN edw.bridge_kpi_service_type_to_grouping ON bridge_kpi_measure_to_service_type_group.dim_kpi_service_type_grouping_key = bridge_kpi_service_type_to_grouping.dim_kpi_service_type_grouping_key
    LEFT JOIN edw.dim_kpi_service_type ON bridge_kpi_service_type_to_grouping.dim_kpi_service_type_key = dim_kpi_service_type.dim_kpi_service_type_key
    LEFT JOIN edw.dim_service ON dim_kpi_service_type.service_type = dim_service.service_type_name
        AND dim_service.dwhiscurrent = 1
        AND dim_service.dwhdmloperation <> 'D'
    WHERE dim_kpi.dwhiscurrent = 1;

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 13: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM (
        SELECT 
            @KPI_ID AS kpi_id,
            service_id
        FROM #service_type_grouping
    ) ms_count_0
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Final SELECT - Returns same columns as view + kpi_id and snapshot_date
    -------------------------------------------------------------------------------
    SELECT 
        sk.dim_kpi_key,
        it.dim_company_key,
        it.dim_client_referral_key,
        it.dim_service_key,
        it.entity_key,
         @KPI_ID AS kpi_id,
        it.client_referral_id,
        it.service_id,
        it.kpi_value,
        it.user_friendly_score_explanation,
        CASE 
            WHEN it.kpi_value IS NULL THEN 1
            WHEN (sk.kpi_g_sign = '>=' AND it.kpi_value >= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '>' AND it.kpi_value > sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<=' AND it.kpi_value <= sk.kpi_g_value)
                OR (sk.kpi_g_sign = '<' AND it.kpi_value < sk.kpi_g_value)
                OR (sk.kpi_g_sign = '=' AND it.kpi_value = sk.kpi_g_value)
                THEN 3
            WHEN (sk.kpi_a_sign = '>=' AND it.kpi_value >= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '>' AND it.kpi_value > sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<=' AND it.kpi_value <= sk.kpi_a_value)
                OR (sk.kpi_a_sign = '<' AND it.kpi_value < sk.kpi_a_value)
                OR (sk.kpi_a_sign = '=' AND it.kpi_value = sk.kpi_a_value)
                THEN 2
            ELSE 1
        END AS kpi_status,
       
        @SnapshotDate AS snapshot_date
       
    FROM #include_target it
    CROSS JOIN #selected_kpi sk
    LEFT JOIN #service_type_grouping stg
        ON sk.dim_kpi_key = stg.dim_kpi_key
        AND it.service_id = stg.service_id
    LEFT JOIN #ms_count mc
        ON mc.kpi_id = sk.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL)

END