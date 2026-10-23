CREATE   PROCEDURE [edw].[kpi_referral_sp_136_GP_registration]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_referral_sp_136_GP_registration]
 Author (Developer): Manish Singh
 Author (Analyst): Timi Boddington / Greg Nuthall
 Created: 2025-04-02		
 Purpose: Calculate GP Registration for Tangata Whaiora
 User Story: 9845

 Notes: Converted from view [edw].[kpi_referral_136_gp_registration] to stored procedure 
        with temp tables and indexing
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-04-02   Greg Nuthall        This view is created to calculate 'Goal_plan_after_28_days' measure 
 1.1       2025-04-10   Greg Nuthall        Modified as requested
 1.2       2025-05-01   Manish Singh        Changed to only active referrals therefore removed discharged clients
 1.3       2025-06-16   Timi Boddington     Added dim_service.dwhdmloperation <> 'd' as duplicates in dim_service where dwhiscurrent = 1
 1.4       2025-06-18   Timi Boddington     Removed duplicates in service_type_grouping, made distinct, which I think it was.
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 2.1       27-03-2026	Thijs Bohm		    Add logic to filter out One off teams
 2.2       21-04-2026   Timi Boddington     Julie wanted team ids filtered out rather than using wild cards for %one off%'
 *************************************************************************************************************/

BEGIN
SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 136;


     IF OBJECT_ID('tempdb..#Teams_to_filter_OUT') IS NOT NULL DROP TABLE #Teams_to_filter_OUT;
    
    SELECT
        dct.dim_client_team_key,
        dct.company_id,
        dct.dim_service_key,
        dct.service_id,
        dct.client_team_id,
        dct.client_team_name,
        dct.client_team_function  
    INTO #Teams_to_filter_OUT
    FROM edw.vw_dim_client_team dct
    WHERE dct.service_id <> '0'
	--AND dct.client_team_name LIKE '%one%off%'
    --changed Timi 21 April 2026
    and dct.client_team_id  in (
    742	--Kia Ora Ake - One Off Support
    ,709	--EaseUp - Waikato - One Off Support
    ,683	--EaseUp - ADHB - One Off Support
    ,686	--EaseUp - West - One Off Support
    ,749	--EaseUp - North - One Off Support
    )

    -------------------------------------------------------------------------------
    -- Temp Table 1: referral_base (active referrals)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#referral_base') IS NOT NULL DROP TABLE #referral_base;
    
    SELECT 
        dim_date.calendar_date AS accepted_date,
        vw_fact_client_referral.client_id,
        vw_fact_client_referral.dim_company_key,
        vw_fact_client_referral.dim_client_referral_key,
        vw_fact_client_referral.dim_client_key,
        vw_fact_client_referral.dim_service_key,
        vw_fact_client_referral.client_team_id,
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
    INNER JOIN edw.dim_date 
        ON vw_fact_client_referral.client_referral_accepted_date_key = dim_date.dim_date_key
    WHERE vw_fact_client_referral.DWHDMLOperation <> 'd'
        AND dim_client_referral.client_referral_type = 'inboundreferral'
        AND client_referral_decline_date_key IS NULL 
        AND client_referral_discharge_date_key IS NULL
        AND dim_client_referral.client_status_is_active = 'active'
        AND client_referral_status = 'Accepted'
        AND dim_client_referral.client_team_id NOT IN (
		SELECT client_team_id FROM #Teams_to_filter_OUT);

    CREATE CLUSTERED INDEX IX_referral_base ON #referral_base(client_id);
    CREATE NONCLUSTERED INDEX IX_referral_base_referral ON #referral_base(client_referral_id);

    -------------------------------------------------------------------------------
    -- Temp Table 2: Selected_KPI
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Selected_KPI') IS NOT NULL DROP TABLE #Selected_KPI;
    
    SELECT TOP 1  
        dim_kpi.kpi_id,
        dim_kpi.dim_kpi_key,
        dim_kpi.what_is_measured,
        dim_kpi.kpi_g_value,
        dim_kpi.kpi_a_value,
        dim_kpi.kpi_g_sign,
        dim_kpi.kpi_a_sign
    INTO #Selected_KPI
    FROM edw.dim_kpi 
    WHERE dim_kpi.DWHDMLOperation <> 'D'
        AND dim_kpi.DWHIsCurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    -------------------------------------------------------------------------------
    -- Temp Table 3: service_type_grouping
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
    WHERE dim_kpi.dwhiscurrent = 1;

    CREATE NONCLUSTERED INDEX IX_service_type_grouping ON #service_type_grouping(dim_kpi_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 4: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Temp Table 5: final_table (join with client GP registration flag)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#final_table') IS NOT NULL DROP TABLE #final_table;
    
    SELECT 
        rb.accepted_date,
        rb.client_id,
        rb.dim_company_key,
        rb.dim_client_referral_key,
        rb.dim_client_key,
        rb.dim_service_key,
        rb.client_referral_id,
        rb.entity_key,
        rb.client_referral_status,
        rb.client_referral_type,
        vw_dim_client.client_gp_registration_missing_flag,
        CASE 
            WHEN vw_dim_client.client_gp_registration_missing_flag = 0 THEN 1
            ELSE 0
        END AS kpi_value,
        dim_service.service_id,
        CASE 
            WHEN client_gp_registration_missing_flag = 1 THEN 'GP Registration is missing'
            ELSE 'GP Registration Exists'
        END AS user_friendly_score_explanation
     
    INTO #final_table
    FROM #referral_base rb
    LEFT JOIN edw.vw_dim_client 
        ON rb.client_id = vw_dim_client.client_id 
        AND vw_dim_client.DWHIsCurrent = 1 
        AND rb.dim_company_key = vw_dim_client.company_id
    LEFT JOIN edw.dim_service 
        ON rb.dim_service_key = dim_service.dim_service_key
  ;

    CREATE NONCLUSTERED INDEX IX_final_table_service ON #final_table(service_id);

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
    CROSS JOIN #Selected_KPI sk
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = ft.service_id
    LEFT JOIN #ms_count mc 
        ON mc.kpi_id = sk.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);


END