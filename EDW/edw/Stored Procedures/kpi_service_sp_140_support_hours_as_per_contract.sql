CREATE    PROCEDURE [edw].[kpi_service_sp_140_support_hours_as_per_contract]
AS
/**********************************************************************************************************
 Procedure: [edw].[kpi_service_sp_140_support_hours_as_per_contract]
 Author (Developer): Manish Singh / Thijs Bohm / Greg Nuthall
 Author (Analyst): Timi Boddington
 Created: 2025-05-23		
 Purpose: Calculate support hours as per contract
 User Story: 9841

 Notes: Converted from view [edw].[kpi_service_140_support_hours_as_per_contract] 
        to stored procedure with temp tables and indexing.
        Major definition change: All activities are included as well as groups (v1.6)
 *************************************************************************************************************
 
 REVISIONS:
 Version   Date         Author              Description
-------   ------------ ------------------- --------------------------
 1.0       2025-05-23   Manish Singh        This view is created to calculate '[edw].[kpi_service_140_KPI_support_hours_as_per_contract]
 1.1       2025-06-16   Timi Boddington     Tidy up script, add dwhdmloperation <> 'd' when joining on service_id
 1.2       2025-06-18   Timi Boddington     Changed the join from dim_client_team from client_team_id to dim_client_team_key. Also duplicates in service_type_grouping, made distinct, which I think it was
 1.3       2025-07-09   Manish Singh        Changed datatype of column total_hrs_activity from Int to decimal(6,1)
 1.4       2025-07-10   Timi Boddington     Changed activity list
 1.5       2025-07-28   Timi Boddington     Removed activity list - added in groups
 1.6       2025-08-05   Thijs Bohm          Major definition change. All activities are included as well as groups
 2.0       2025-01-15   Greg Nuthall        Converted view to stored procedure with temp tables and indexing,
                                            added kpi_id and snapshot_date columns
 1.7	   12-02-2026	Timi Boddington	    Major change, adding in groups from fact_account_activity 
                                            Also note the final user friendly score explanation is rounding where as the non stored proc isn't, so I'm adding back in the detail
 *************************************************************************************************************/

BEGIN
    SET NOCOUNT ON;

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 140;

    -------------------------------------------------------------------------------
    -- Temp Table 1: Activities_WITHOUT_groups (last 28 days, parent activities only)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Activities_WITHOUT_groups') IS NOT NULL DROP TABLE #Activities_WITHOUT_groups;
    
    SELECT 
        CASE 
            WHEN dim_client_team.company_id = 5 THEN 'Mind and Body'
            ELSE 'EmergeAotearoa LTD'
        END AS Company,
        dim_client_team.company_id AS dim_company_key,
        dim_employee.employee_first_name,
        dim_employee.employee_last_name,
        1 AS rows,
        client_activity_id,
        client_id AS personid,
        client_referral_id AS clientreferralid,
        dim_client_referral_key,
        DATEDIFF(DAY, CAST(client_activity_start_date AS DATE), CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')))) AS days_activity_to_today,
        client_activity_start_date,
        client_activity_end_date,
        client_activity_duration,
        client_parent_activity_id,
        client_activity_breakdown_type_name,
        client_parent_activity_breakdown_type_name,
        dim_service.service_id,
        dim_service.service_code,
        dim_service.service_name,
        dim_service.service_type_name
    INTO #Activities_WITHOUT_groups
    FROM edw.fact_client_activity_breakdown
    LEFT JOIN edw.dim_client_activity_breakdown_type 
        ON fact_client_activity_breakdown.dim_client_activity_breakdown_type_key = dim_client_activity_breakdown_type.dim_client_activity_breakdown_type_key
    LEFT JOIN edw.dim_service 
        ON fact_client_activity_breakdown.dim_service_key = dim_service.dim_service_key
    INNER JOIN edw.dim_employee 
        ON fact_client_activity_breakdown.dim_employee_key = dim_employee.dim_employee_key
    INNER JOIN edw.dim_client_team 
        ON fact_client_activity_breakdown.dim_client_team_key = dim_client_team.dim_client_team_key
    INNER JOIN edw.dim_date 
        ON CAST(fact_client_activity_breakdown.client_activity_start_date AS DATE) = dim_date.calendar_date
    WHERE client_team_name IS NOT NULL
        AND client_parent_activity_id IS NULL -- No groups here
        AND fact_client_activity_breakdown.DWHDMLOperation <> 'd'
        AND dim_client_activity_breakdown_type.DWHDMLOperation <> 'd'
        AND dim_employee.DWHDMLOperation <> 'd'
        AND dim_client_team.DWHDMLOperation <> 'd'
        AND dim_date.current_date_rolling_day_offset BETWEEN -28 AND 0;

    CREATE NONCLUSTERED INDEX IX_Activities_WITHOUT_groups ON #Activities_WITHOUT_groups(dim_company_key, service_id, service_code);

    -------------------------------------------------------------------------------
    -- Temp Table 2: Without_groups_Summary_Data
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Without_groups_Summary_Data') IS NOT NULL DROP TABLE #Without_groups_Summary_Data;
    
    SELECT 
        dim_company_key,
        service_id,
        service_code,
        service_name,
        service_type_name,
        SUM(client_activity_duration) / 60 AS total_hrs_activity -- Convert minutes to hours
    INTO #Without_groups_Summary_Data
    FROM #Activities_WITHOUT_groups
    GROUP BY dim_company_key, service_id, service_code, service_name, service_type_name;

    CREATE CLUSTERED INDEX IX_Without_groups_Summary ON #Without_groups_Summary_Data(dim_company_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 3: GROUPS_ACTIVITY (last 28 days, group activities - distinct by kaimahi)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#GROUPS_ACTIVITY') IS NOT NULL DROP TABLE #GROUPS_ACTIVITY;
    
    SELECT DISTINCT
        CASE 
            WHEN dim_client_team.company_id = 5 THEN 'Mind and Body'
            ELSE 'EmergeAotearoa LTD'
        END AS Company,
        dim_client_team.company_id AS dim_company_key,
        dim_employee.employee_first_name,
        dim_employee.employee_last_name,
        CAST(client_activity_start_date AS DATE) AS client_activity_date,
        DATEDIFF(DAY, CAST(client_activity_start_date AS DATE), CONVERT(DATETIME, SWITCHOFFSET(GETDATE(), DATEPART(TZOFFSET, GETDATE() AT TIME ZONE 'New Zealand Standard Time')))) AS days_activity_to_today,
        client_activity_duration,
        client_parent_activity_id,
        dim_service.service_id,
        dim_service.service_code,
        dim_service.service_name,
        dim_service.service_type_name
    INTO #GROUPS_ACTIVITY
    FROM edw.fact_client_activity_breakdown
    LEFT JOIN edw.dim_client_activity_breakdown_type 
        ON fact_client_activity_breakdown.dim_client_activity_breakdown_type_key = dim_client_activity_breakdown_type.dim_client_activity_breakdown_type_key
    LEFT JOIN edw.dim_service 
        ON fact_client_activity_breakdown.dim_service_key = dim_service.dim_service_key
    INNER JOIN edw.dim_employee 
        ON fact_client_activity_breakdown.dim_employee_key = dim_employee.dim_employee_key
    INNER JOIN edw.dim_client_team 
        ON fact_client_activity_breakdown.dim_client_team_key = dim_client_team.dim_client_team_key
    INNER JOIN edw.dim_date 
        ON CAST(fact_client_activity_breakdown.client_activity_start_date AS DATE) = dim_date.calendar_date
    WHERE client_team_name IS NOT NULL
        AND client_parent_activity_id IS NOT NULL -- Groups only filter
        AND fact_client_activity_breakdown.DWHDMLOperation <> 'd'
        AND dim_client_activity_breakdown_type.DWHDMLOperation <> 'd'
        AND dim_employee.DWHDMLOperation <> 'd'
        AND dim_client_team.DWHDMLOperation <> 'd'
        AND dim_date.current_date_rolling_day_offset BETWEEN -28 AND 0
        AND dim_service.DWHIsCurrent = 1;

    CREATE NONCLUSTERED INDEX IX_GROUPS_ACTIVITY ON #GROUPS_ACTIVITY(dim_company_key, service_id, service_code);

    -------------------------------------------------------------------------------
    -- Temp Table 4: GROUPS_Summary_Data
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#GROUPS_Summary_Data') IS NOT NULL DROP TABLE #GROUPS_Summary_Data;
    
    SELECT 
        dim_company_key,
        service_id,
        service_code,
        service_name,
        service_type_name,
        SUM(client_activity_duration) / 60.0 AS total_hrs_activity -- Convert minutes to hours
    INTO #GROUPS_Summary_Data
    FROM #GROUPS_ACTIVITY
    GROUP BY dim_company_key, service_id, service_code, service_name, service_type_name;

    CREATE CLUSTERED INDEX IX_GROUPS_Summary ON #GROUPS_Summary_Data(dim_company_key, service_id);
 -------------------------------------------------------------------------------
    -- Temp Table 4.1: Group Account Activity  (New Timi 10/3/2026)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#GROUPS_Account_Activity_Data') IS NOT NULL DROP TABLE #GROUPS_Account_Activity_Data;
    select 
fact_client_account_activity.dim_company_key,
client_team_name ,
service_latest.service_name,
service_latest.service_id,
service_LATEST.SERVICE_CODE,
service_latest.service_type_name,
service_latest.dim_service_key ,
client_account_activity_start_date, client_account_activity_end_date,
datediff(minute,client_account_activity_start_date, client_account_activity_end_date) as client_activity_duration,
client_account_activity_classification_text,
client_account_activity_type_text,
client_account_name,
client_account_activity_audience_size
into #groups_account_activity_data
from edw.fact_client_account_activity

 left join edw.dim_date on cast(fact_client_account_activity.client_account_activity_start_date as date)  = dim_date.calendar_date
 left join edw.dim_client_team on fact_client_account_activity.dim_client_team_key = dim_client_team.dim_client_team_key
 left join edw.dim_service on fact_client_account_activity.dim_service_key = dim_service.dim_service_key
 --===== get latest service key
 left join edw.dim_service as service_latest on dim_service.service_id = service_latest.service_id
 and service_latest.DWHIsCurrent = 1 and service_latest.DWHDMLOperation <> 'd'
 where fact_client_account_activity.DWHDMLOperation <> 'd'
and fact_client_account_activity.DWHIsCurrent = 1 
and dim_date.current_date_rolling_day_offset between -28 and 0 

CREATE CLUSTERED INDEX IX_Summary_Data ON #groups_account_activity_data(dim_company_key, service_id);
-------------------------------------------------------------------------------
    -- Temp Table 4.2: Group Account Activity  (New Timi 10/3/2026)
    -------------------------------------------------------------------------------
if object_id ('tempdb..#summary_group_account_activity') is not null drop table #summary_group_account_activity
SELECT dim_company_key
		,service_id
		,service_code
		,service_name
		,service_type_name
		,SUM(client_activity_duration) / 60.0 AS total_hrs_activity -- Dividing by 60 to get hours
	into #summary_group_account_activity
    FROM #groups_account_activity_data
	GROUP BY dim_company_key
		,service_id
		,service_code
		,service_name
		,service_type_name

CREATE CLUSTERED INDEX IX_Summary_Data ON #summary_group_account_activity(dim_company_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 5: Summary_Data (UNION ALL of groups and non-groups)
    -------------------------------------------------------------------------------

    IF OBJECT_ID('tempdb..#Summary_Data') IS NOT NULL DROP TABLE #Summary_Data;
    
    SELECT
        dim_company_key,
        service_id,
        service_code,
        service_name,
        service_type_name,
        SUM(total_hrs_activity) AS total_hrs_activity
    INTO #Summary_Data
    FROM (
        SELECT
            dim_company_key,
            service_id,
            service_code,
            service_name,
            service_type_name,
            total_hrs_activity
        FROM #GROUPS_Summary_Data
        
        UNION ALL
        
        SELECT
            dim_company_key,
            service_id,
            service_code,
            service_name,
            service_type_name,
            total_hrs_activity
        FROM #Without_groups_Summary_Data

        UNION ALL 
			SELECT
				dim_company_key,
			  	service_id,
				service_code,
				service_name,
				service_type_name,
				total_hrs_activity
			FROM #summary_group_account_activity

    ) AS merged
    GROUP BY dim_company_key, service_id, service_code, service_name, service_type_name;

    CREATE CLUSTERED INDEX IX_Summary_Data ON #Summary_Data(dim_company_key, service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 6: Selected_KPI
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
    WHERE dim_kpi.dwhdmloperation <> 'D'
        AND dim_kpi.dwhiscurrent = 1
        AND dim_kpi.kpi_id = @KPI_ID;

    -------------------------------------------------------------------------------
    -- Temp Table 7: Service_Targets
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Service_Targets') IS NOT NULL DROP TABLE #Service_Targets;
    
    SELECT 
        vw_dim_kpi_target_definitions.service_id,
        vw_dim_kpi_target_definitions.support_hours AS target_support_hours
    INTO #Service_Targets
    FROM edw.vw_dim_kpi_target_definitions
    WHERE vw_dim_kpi_target_definitions.DWHDMLOperation <> 'D'
        AND vw_dim_kpi_target_definitions.DWHIsCurrent = 1
        AND vw_dim_kpi_target_definitions.support_hours_applies = 1;

    CREATE CLUSTERED INDEX IX_Service_Targets ON #Service_Targets(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 8: Final_Table (with KPI calculation)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Final_Table') IS NOT NULL DROP TABLE #Final_Table;
    
    SELECT 
        sd.dim_company_key,
        sd.service_id,
        ds.dim_service_unique_key,
        CONCAT(555, '_', sd.service_id, '_', dco.dim_company_key) AS entity_key,
        ds.dim_service_key,
        sd.total_hrs_activity,
        st.target_support_hours,
        CAST(sd.total_hrs_activity / st.target_support_hours AS DECIMAL(6, 2)) AS kpi_value
    INTO #Final_Table
    FROM #Summary_Data sd
    LEFT JOIN edw.vw_dim_company dco 
        ON dco.dim_company_key = sd.dim_company_key
    LEFT JOIN edw.vw_dim_service ds 
        ON ds.service_id = sd.service_id
    INNER JOIN #Service_Targets st 
        ON st.service_id = sd.service_id
    WHERE ds.DWHIsCurrent = 1 
        AND ds.DWHDMLOperation <> 'd';

    CREATE NONCLUSTERED INDEX IX_Final_Table ON #Final_Table(service_id);

    -------------------------------------------------------------------------------
    -- Temp Table 9: service_type_grouping
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
    -- Temp Table 10: ms_count
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    -------------------------------------------------------------------------------
    -- Temp Table 11: Final_Final_Table (with KPI status)
    -------------------------------------------------------------------------------
    IF OBJECT_ID('tempdb..#Final_Final_Table') IS NOT NULL DROP TABLE #Final_Final_Table;
    
    SELECT 
        sk.dim_kpi_key,
        ft.dim_company_key,
        ft.dim_service_key,
        ft.entity_key,
        @KPI_ID AS kpi_id,
        ft.service_id,
        --ft.total_hrs_activity,
        --ft.target_support_hours,
        cast(ft.kpi_value as decimal(6,1)) as kpi_value,
        CASE 
            WHEN kpi_value IS NOT NULL THEN 
                CONCAT(CAST(ft.kpi_value * 100.0 AS int), '% of support hours target reached. Hours delivered: ', 
                       cast(total_hrs_activity as int), ' Target: ', CAST(target_support_hours AS INT))
            WHEN kpi_value IS NULL AND total_hrs_activity IS NULL THEN 'no support hours recorded'
            WHEN kpi_value IS NULL AND target_support_hours IS NULL THEN 'no target set'
        END AS user_friendly_score_explanation,
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

    
    FROM #Final_Table ft
    CROSS JOIN #Selected_KPI sk
    LEFT JOIN #service_type_grouping stg 
        ON stg.dim_kpi_key = sk.dim_kpi_key
        AND stg.service_id = ft.service_id
    LEFT JOIN #ms_count mc 
        ON sk.kpi_id = mc.kpi_id
    WHERE (mc.service_count IS NULL OR mc.service_count = 0)
        OR (stg.service_id IS NOT NULL);

END