Create   procedure [edw].[kpi_service_sp_138_kaimahi_and_whanau_case_loads]
as 
/**********************************************************************************************************
 Procedure	[edw].[kpi_service_sp_138_kaimahi_and_whanau_case_loads]
 Author		Generated
 Created	2026-02-16
 Purpose	Stored procedure version of kpi_service_138_kaimahi_and_whanau_case_loads view
            Converts CTEs to temp tables with indexing for performance optimization
 Notes: 		Returns KPI 138 data with snapshot date
 =========================================================================================================
 REVISIONS:
 Version	 Date		   Author			Description
-------	 ------------  ---------------	--------------------------
 1.0		23-05-2025     Manish Singh		 This view is created to calculate   '[edw].[kpi_referral_138_kaimahi_and_whanau_case_loads]
 1.1		16-06-2025	   Timi Boddington	 added dwhdmloperation <> 'd' to join on dim_service by id, reformatted and tidied
 1.2        18-06-2025     Timi Boddington   Duplicates in service_type_grouping, made distinct, which I think it was originally
 1.3        14-10-2025     Timi Boddington   Changing the join from dim_service_key to service_id Line: 64
 1.4        28-10-2025     Timi Boddington   Changing the join from dim_employee_key to employee_id Line: 53
                                             also, removed the job end date and the employee_end_date as it excludes current staff line 61 and 62
 1.5        05-11-2025     Timi Boddington   Changed line 207 to include staff whose enddate is greater than today(ish)
 1.6        06-11-2025     Timi Boddington   Complete rewrite.
 1.7        12-02-2026     Timi Boddington   Remove SMs and DMs
 2.0        15-01-2025     Greg Nuthall      Converted view to stored procedure with temp tables and indexing,
                                             added kpi_id and snapshot_date columns
 2.1        23-04-2026     Timi Boddington   Changed cost allocation table to edw.fact_employee_cost_allocation
 2.2        29-04-2026     Timi Boddington   Added code so that if a person is allocated to same cost centre, I remove their fte so it isn't deducted
**********************************************************************************************************/

begin

    DECLARE @SnapshotDate DATE = CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE);
    DECLARE @KPI_ID INT = 138;

        IF OBJECT_ID('tempdb..#testing') IS NOT NULL DROP TABLE #testing;
          IF OBJECT_ID('tempdb..#actual') IS NOT NULL DROP TABLE #actual;

    -- Temp table 1: employrem
    IF OBJECT_ID('tempdb..#employrem') IS NOT NULL DROP TABLE #employrem;
    SELECT 
        fact_employee_remuneration.dim_employee_key,
        fact_employee_remuneration.dim_service_key,
        dim_employee.employee_id,
        dim_employee.employee_job_name,
        dim_service.region_name,
        fact_employee_remuneration_fte,
        dim_service.dim_company_key,
        dim_service.service_id,
        employee_start_date,
        employee_end_date,
        CASE 
            WHEN region_name IN ('HD Peer Services', 'Mind and Body')
                THEN 'Keep'
            WHEN employee_job_name LIKE '%district manager%'
                OR employee_job_name LIKE '%service manager%'
                OR employee_job_name LIKE '%operations manager%'
                THEN 'Remove'
            ELSE 'Keep'
        END AS keepers
    INTO #employrem
    FROM edw.fact_employee_remuneration
    INNER JOIN edw.dim_employee
        ON fact_employee_remuneration.fact_employee_remuneration_employee_number = dim_employee.employee_id
            AND dim_employee.DWHIsCurrent = 1
            AND dim_employee.DWHDMLOperation <> 'd'
    INNER JOIN edw.dim_service
        ON fact_employee_remuneration.fact_employee_remuneration_businessunit_id = dim_service.intellihr_service_id
            AND dim_service.DWHIsCurrent = 1
            AND dim_service.DWHDMLOperation <> 'd'
    WHERE fact_employee_remuneration.dwhiscurrent = 1
        AND fact_employee_remuneration_job_status NOT IN ('past job', 'future job')
   
        ;


    CREATE NONCLUSTERED INDEX IX_employrem_employee_id ON #employrem(employee_id) INCLUDE (keepers, service_id, fact_employee_remuneration_fte);

        -- Temp table 2: cost_alloc
        --changed order Timi - 29 April 2026. Added code to remove cost allocations from the services already in fact_rem - so we don't remove FTE from their total above
    IF OBJECT_ID('tempdb..#cost_alloc') IS NOT NULL DROP TABLE #cost_alloc;
    SELECT 
        fact_employee_cost_allocation.dim_company_key as  employee_company_id,
        dim_employee.employee_name AS employee_name,
        dim_employee.employee_id,
        dim_employee.employee_job_status AS employee_employment_status,
        'Permanent' AS employee_work_type,
        CASE 
            WHEN cost_allocation_percentage < 1 THEN 'Part Time'
            WHEN cost_allocation_percentage = 1 THEN 'Full Time'
            WHEN cost_allocation_percentage = 0 THEN 'Casual'
        END AS employee_work_class,
        dim_employee.employee_primary_email_address,
        NULL AS employee_start_date,
        NULL AS employee_end_date,
        cost_allocation_percentage AS FTE,
        dim_service.service_id,
        fact_employee_cost_allocation.job_title as intellihr_job_title,
        dim_employee.employee_job_name as job_title,
        dim_service.region_name,
        CASE 
            WHEN dim_service.region_name NOT IN ('mind and body', 'hd peer services')
                AND job_title IN (
                    'Team Leader - Housing Services',
                    'Service Manager',
                    'Service Manager - Forensics',
                    'Acting Team Leader - Housing Services',
                    'Team Leader - Emergency Housing Services',
                    'Acting Service Manager',
                    'Acting District Manager',
                    'District Manager'
                )
                THEN 'Remove'
               
            ELSE 'Keep'
        END AS SM_TL_Remove_Status
    INTO #cost_alloc
 
    FROM edw.fact_employee_cost_allocation
    LEFT JOIN edw.dim_service
        ON fact_employee_cost_allocation.dim_service_key = dim_service.dim_service_key
          --  AND dim_service.DWHIsCurrent = 1
           -- AND dim_service.dwhdmloperation <> 'd'
           
    left join edw.dim_employee on fact_employee_cost_allocation.employee_id = dim_employee.employee_id
    and dim_employee.DWHIsCurrent = 1 and dim_employee.DWHDMLOperation <> 'd'

    left join #employrem on fact_employee_cost_allocation.employee_id = #employrem.employee_id
    
    where fact_employee_cost_allocation.DWHDMLOperation <> 'd'
     and fact_employee_cost_allocation.datapay_cost_center_code <> dim_service.service_code 


    ;
    CREATE NONCLUSTERED INDEX IX_cost_alloc_employee_id ON #cost_alloc(employee_id) INCLUDE (SM_TL_Remove_Status, service_id);
    CREATE NONCLUSTERED INDEX IX_cost_alloc_status ON #cost_alloc(SM_TL_Remove_Status);

    -- Temp table 3: employees
    IF OBJECT_ID('tempdb..#employees') IS NOT NULL DROP TABLE #employees;
    SELECT 
        1 AS current_employee_flag,
        CASE 
            WHEN dim_employee.employee_company_name LIKE 'emerge%' THEN 1
            ELSE 5
        END AS employee_company_id,
        dim_employee.employee_name,
        dim_employee.employee_id,
        dim_employee.employee_employment_status,
        dim_employee.employee_work_type,
        employee_work_class,
        dim_employee.employee_primary_email_address,
        dim_employee.employee_start_date,
        dim_employee.employee_end_date
    INTO #employees
    FROM edw.dim_employee
    WHERE dim_employee.dwhiscurrent = 1
        AND dim_employee.employee_id NOT IN (0, -1)
        AND dim_employee.employee_employment_status NOT IN ('past staff', 'upcoming staff');

  

    CREATE NONCLUSTERED INDEX IX_employees_employee_id ON #employees(employee_id);

    -- Temp table 4: employees_with_fte
    IF OBJECT_ID('tempdb..#employees_with_fte') IS NOT NULL DROP TABLE #employees_with_fte;
    SELECT 
        employees.current_employee_flag,
        employees.employee_company_id,
        employees.employee_name,
        employees.employee_id,
        employees.employee_employment_status,
        employees.employee_work_type,
        employees.employee_work_class,
        employees.employee_primary_email_address,
        employees.employee_start_date,
        employees.employee_end_date,
        keepers,
        employee_job_name,
        #employrem.fact_employee_remuneration_fte,
        #employrem.service_id
    INTO #employees_with_fte
    FROM #employees employees
    LEFT JOIN #employrem
        ON employees.employee_id = #employrem.employee_id;

    CREATE NONCLUSTERED INDEX IX_employees_with_fte_employee_id ON #employees_with_fte(employee_id) INCLUDE (keepers);

    -- Temp table 5: employee_cost_total
    IF OBJECT_ID('tempdb..#employee_cost_total') IS NOT NULL DROP TABLE #employee_cost_total;
    SELECT 
        employee_company_id,
        employee_name,
        employee_id,
        employee_employment_status,
        employee_work_type,
        employee_work_class,
        employee_primary_email_address,
        employee_start_date,
        employee_end_date,
        SUM(FTE) AS total_fte
    INTO #employee_cost_total
    FROM #cost_alloc
    WHERE SM_TL_Remove_Status = 'Keep'
    GROUP BY 
        employee_company_id,
        employee_name,
        employee_id,
        employee_employment_status,
        employee_work_type,
        employee_work_class,
        employee_primary_email_address,
        employee_start_date,
        employee_end_date;

    CREATE NONCLUSTERED INDEX IX_employee_cost_total_employee_id ON #employee_cost_total(employee_id);


    -- Temp table 6: allemployees
    IF OBJECT_ID('tempdb..#allemployees') IS NOT NULL DROP TABLE #allemployees;
    SELECT 
        1 AS type,
        employees_with_fte.employee_company_id,
        employees_with_fte.employee_name,
        employees_with_fte.employee_id,
        employees_with_fte.employee_employment_status,
        employees_with_fte.employee_work_type,
        employees_with_fte.employee_work_class,
        employees_with_fte.employee_primary_email_address,
        CAST(employees_with_fte.employee_start_date AS DATE) AS startdate,
        CAST(employees_with_fte.employee_end_date AS DATE) AS enddate,
        employees_with_fte.fact_employee_remuneration_FTE AS FTE,
        employees_with_fte.service_id 
    INTO #allemployees
    FROM #employees_with_fte employees_with_fte
    WHERE employees_with_fte.employee_id NOT IN (SELECT employee_id FROM #cost_alloc)
        AND keepers = 'keep'
    
    UNION ALL
    
    SELECT 
        2 AS type,
        employees_with_fte.employee_company_id,
        employees_with_fte.employee_name,
        employees_with_fte.employee_id,
        employees_with_fte.employee_employment_status,
        employees_with_fte.employee_work_type,
        employees_with_fte.employee_work_class,
        employees_with_fte.employee_primary_email_address,
        CAST(employees_with_fte.employee_start_date AS DATE) AS startdate,
        CAST(employees_with_fte.employee_end_date AS DATE) AS enddate,
        CASE 
            WHEN employees_with_fte.fact_employee_remuneration_FTE > 0
                THEN employees_with_fte.fact_employee_remuneration_FTE - ect.total_fte
            ELSE employees_with_fte.fact_employee_remuneration_FTE
        END AS FTE,
        employees_with_fte.service_id
    FROM #employees_with_fte employees_with_fte
    INNER JOIN #employee_cost_total ect
        ON employees_with_fte.employee_id = ect.employee_id
    WHERE employees_with_fte.employee_id IN (SELECT employee_id FROM #cost_alloc)
        AND keepers = 'keep'
    
    UNION ALL

    SELECT 
        3 AS type,
        cost_alloc.employee_company_id,
        cost_alloc.employee_name,
        cost_alloc.employee_id,
        cost_alloc.employee_employment_status,
        cost_alloc.employee_work_type,
        cost_alloc.employee_work_class,
        cost_alloc.employee_primary_email_address,
        employrem.employee_start_date AS startdate,
        employrem.employee_end_date AS enddate,
        cost_alloc.FTE,
        cost_alloc.service_id AS service_code
    FROM #cost_alloc cost_alloc
    LEFT JOIN #employrem employrem
        ON cost_alloc.employee_id = employrem.employee_id
    WHERE SM_TL_Remove_Status = 'Keep';

    CREATE NONCLUSTERED INDEX IX_allemployees_service_code ON #allemployees(service_id);
    CREATE NONCLUSTERED INDEX IX_allemployees_composite ON #allemployees(employee_company_id, service_id) INCLUDE (FTE);


    -- Temp table 7: finalfinal
    IF OBJECT_ID('tempdb..#finalfinal') IS NOT NULL DROP TABLE #finalfinal;
    SELECT DISTINCT 
        allemployees.employee_company_id,
        allemployees.employee_name,
        allemployees.employee_id,
        allemployees.employee_employment_status,
        CASE 
            WHEN FTE < 1 THEN 'Part Time'
            WHEN FTE = 1 THEN 'Full Time'
            WHEN FTE IS NULL OR FTE = 0 THEN 'Casual'
        END AS employee_work_class_per_service,
        allemployees.employee_primary_email_address,
        allemployees.startdate,
        allemployees.enddate,
        ISNULL(allemployees.FTE, 0) AS FTE,
        allemployees.service_id,
        ds.service_name
    INTO #finalfinal
    FROM #allemployees allemployees
    LEFT JOIN edw.dim_service ds
        ON allemployees.service_id = ds.service_id
    WHERE ds.DWHIsCurrent = 1
        AND (allemployees.enddate IS NULL OR allemployees.enddate >= GETDATE())
        AND ds.dim_company_key = allemployees.employee_company_id;

    

    CREATE NONCLUSTERED INDEX IX_finalfinal_service_code ON #finalfinal(service_id) INCLUDE (employee_company_id, FTE);

    -- Temp table 8: number_current_referrals
    IF OBJECT_ID('tempdb..#number_current_referrals') IS NOT NULL DROP TABLE #number_current_referrals;
    SELECT 
        dim_service.service_id,
        COUNT(client_referral_id) AS number_open_referrals
    INTO #number_current_referrals
    FROM edw.vw_fact_client_referral
    LEFT JOIN edw.dim_service
        ON vw_fact_client_referral.dim_service_key = dim_service.dim_service_key
    WHERE vw_fact_client_referral.DWHDMLOperation <> 'd'
        AND client_referral_discharge_date_key IS NULL
        AND client_referral_decline_date_key IS NULL
        AND client_referral_accepted_date_key IS NOT NULL
    GROUP BY dim_service.service_id;

    CREATE NONCLUSTERED INDEX IX_number_current_referrals_service_code ON #number_current_referrals(service_id);

    -- Temp table 9: number_fte
    IF OBJECT_ID('tempdb..#number_fte') IS NOT NULL DROP TABLE #number_fte;
    SELECT 
        employee_company_id,
        service_name,
        service_id,
        SUM(fte) AS total_fte
    INTO #number_fte
    FROM #finalfinal
    GROUP BY 
        employee_company_id,
        service_name,
        service_id;

    CREATE NONCLUSTERED INDEX IX_number_fte_service_code ON #number_fte(service_id) INCLUDE (employee_company_id);

    -- Temp table 10: final_final
    IF OBJECT_ID('tempdb..#final_final') IS NOT NULL DROP TABLE #final_final;
    SELECT 
        dim_service.dim_company_key,
        dim_service.service_type_name,
        dim_service.dim_service_key,
        dim_service.service_id,
        number_fte.service_name,
      --  number_fte.service_id,
        number_fte.total_fte,
        number_current_referrals.number_open_referrals,
        CASE 
            WHEN number_fte.total_fte IS NULL OR number_fte.total_fte = 0
                THEN 0
            ELSE CAST(number_current_referrals.number_open_referrals / number_fte.total_fte AS DECIMAL(6, 1))
        END AS caseload
   INTO #final_final
    FROM #number_fte number_fte
    LEFT JOIN #number_current_referrals number_current_referrals
        ON number_fte.service_id = number_current_referrals.service_id
    LEFT JOIN edw.dim_service
        ON number_fte.service_id = dim_service.service_id
            AND dim_service.dim_company_key = number_fte.employee_company_id
            AND dim_service.DWHIsCurrent = 1
            AND dim_service.DWHDMLOperation <> 'd';



  --  CREATE NONCLUSTERED INDEX IX_final_final_service_id ON #final_final(service_id);

    -- Temp table 11: selected_kpi
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
        AND dim_kpi.kpi_id = 138;

    -- Temp table 12: Service_Targets
    IF OBJECT_ID('tempdb..#Service_Targets') IS NOT NULL DROP TABLE #Service_Targets;
    SELECT 
        vw_dim_kpi_target_definitions.service_id,
        vw_dim_kpi_target_definitions.caseload AS target_caseload
    INTO #Service_Targets
    FROM edw.vw_dim_kpi_target_definitions
    WHERE vw_dim_kpi_target_definitions.DWHDMLOperation <> 'D'
        AND vw_dim_kpi_target_definitions.DWHIsCurrent = 1
        AND vw_dim_kpi_target_definitions.caseload_target_applies = 1;

    CREATE NONCLUSTERED INDEX IX_Service_Targets_service_id ON #Service_Targets(service_id);

    -- Temp table 13: include_target
    IF OBJECT_ID('tempdb..#include_target') IS NOT NULL DROP TABLE #include_target;
    SELECT 
        final_final.dim_company_key,
        final_final.service_type_name,
        final_final.dim_service_key,
        final_final.service_id,
        final_final.service_name,
        --final_final.service_code,
        final_final.total_fte,
        number_open_referrals,
        caseload,
        target_caseload,
        CASE 
            WHEN target_caseload IS NULL OR target_caseload = 0
                THEN 0
            ELSE CAST(caseload / target_caseload AS DECIMAL(6, 1))
        END AS kpi_value
    INTO #include_target
    FROM #final_final final_final
    INNER JOIN #Service_Targets Service_Targets
        ON Service_Targets.service_id = final_final.service_id;

    CREATE NONCLUSTERED INDEX IX_include_target_service_id ON #include_target(service_id);

    -- Temp table 14: service_type_grouping
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

    CREATE NONCLUSTERED INDEX IX_service_type_grouping_kpi_service ON #service_type_grouping(dim_kpi_key, service_id);
    CREATE NONCLUSTERED INDEX IX_service_type_grouping_kpi_id ON #service_type_grouping(kpi_id);

    -- Temp table 15: ms_count
    IF OBJECT_ID('tempdb..#ms_count') IS NOT NULL DROP TABLE #ms_count;
    SELECT 
        kpi_id,
        COUNT(service_id) AS service_count
    INTO #ms_count
    FROM #service_type_grouping
    GROUP BY kpi_id;

    CREATE NONCLUSTERED INDEX IX_ms_count_kpi_id ON #ms_count(kpi_id);

    -- Final SELECT with new columns: kpi_id and snapshot_date
    SELECT 
        --138 AS kpi_id,
        --CAST(GETDATE() AT TIME ZONE 'UTC' AT TIME ZONE 'New Zealand Standard Time' AS DATE) AS snapshot_date,
        --selected_kpi.dim_kpi_key,
        --it.dim_company_key,
        --CONCAT(555, ' _', it.service_id, ' _', it.dim_company_key) AS entity_key,
        --it.dim_service_key,
       -- it.service_id,
     --   service_name,
        sk.dim_kpi_key,
        it.dim_company_key,
        it.dim_service_key,
        CONCAT(555, ' _', it.service_id, ' _', it.dim_company_key) AS entity_key,
        @KPI_ID AS kpi_id,
        it.service_id,
        --it.service_name,
        it.kpi_value,
        CASE 
            WHEN kpi_value <> 0
                THEN CONCAT(
                    CAST(kpi_value * 100 AS INT),
                    '% of caseload target reached. Active referrals: ',
                    number_open_referrals,
                    ' Active FTE: ',
                    total_fte
                )
            WHEN kpi_value IS NULL AND total_fte IS NULL
                THEN 'no active staff'
            WHEN kpi_value IS NULL AND number_open_referrals IS NULL
                THEN 'no active referrals'
            WHEN kpi_value IS NULL AND target_caseload IS NULL
                THEN 'no target set'
        END AS user_friendly_score_explanation,
        CASE 
            WHEN it.kpi_value IS NULL
                THEN 1
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
        ON stg.dim_kpi_key = sk.dim_kpi_key
            AND stg.service_id = it.service_id
    LEFT JOIN #ms_count ms
        ON sk.kpi_id = ms.kpi_id
    WHERE (ms.service_count IS NULL OR ms.service_count = 0)
        OR (stg.service_id IS NOT NULL)

end