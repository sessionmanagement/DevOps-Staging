
CREATE   PROCEDURE [edw].[update_row_level_security_recordbase]

	/***************************************************************************
	NAME:     [edw].[update_row_level_security_recordbase]
	PURPOSE:  Generate row level security table to be used in Power BI reports

	REVISIONS:
	Version	 Date		   Author			Description
	-------	 ------------  ---------------	--------------------------
	1.0		 2026-03-31    Timi Boddington	Initial version
    1.1      2026-04-23    Timi Boddington  Changes to add in national practice manager although mute point, doens't have teams

	****************************************************************************/

/*
    Optimized version of [edw].[update_row_level_security_recordbase]
    
    Performance changes:
    [OPT 1] #leader_emails pre-computation replaces 9-way OR NOT EXISTS
    [OPT 2] @auckland_dm_boss variable replaces per-row scalar correlated subquery
    [OPT 3] Clustered/covering indexes on temp tables after population
    [OPT 4] #employee_levels lookup replaces 7 IN (SELECT...) subqueries in final INSERT
    [OPT 5] ORDER BY removed from SELECT INTO and final INSERT
*/


AS
BEGIN

    IF OBJECT_ID('tempdb..#leader_emails')                              IS NOT NULL DROP TABLE #leader_emails;
    IF OBJECT_ID('tempdb..#employee_levels')                            IS NOT NULL DROP TABLE #employee_levels;
    IF OBJECT_ID('tempdb..#table_1_NoDirectReports')                    IS NOT NULL DROP TABLE #table_1_NoDirectReports;
    IF OBJECT_ID('tempdb..#table_2_ServiceTable')                       IS NOT NULL DROP TABLE #table_2_ServiceTable;
    IF OBJECT_ID('tempdb..#table_3a_Employee_Hierarchy')                IS NOT NULL DROP TABLE #table_3a_Employee_Hierarchy;
    IF OBJECT_ID('tempdb..#table_3b_Employee_Hierarchy')                IS NOT NULL DROP TABLE #table_3b_Employee_Hierarchy;
    IF OBJECT_ID('tempdb..#table_3c_Employee_Hierarchy_with_Services')  IS NOT NULL DROP TABLE #table_3c_Employee_Hierarchy_with_Services;
    IF OBJECT_ID('tempdb..#table_4_cost_allocations')                   IS NOT NULL DROP TABLE #table_4_cost_allocations;
    IF OBJECT_ID('tempdb..#table_3d_Hierarchy_Level_1_Cross_Join_CEO')  IS NOT NULL DROP TABLE #table_3d_Hierarchy_Level_1_Cross_Join_CEO;
    IF OBJECT_ID('tempdb..#table_3e_Hierarchy_Level_Cross_Join_Result') IS NOT NULL DROP TABLE #table_3e_Hierarchy_Level_Cross_Join_Result;
    IF OBJECT_ID('tempdb..#table_3_Final_Hierarchy_with_Services')      IS NOT NULL DROP TABLE #table_3_Final_Hierarchy_with_Services;
    IF OBJECT_ID('tempdb..#table_5_level_1_CEO')                        IS NOT NULL DROP TABLE #table_5_level_1_CEO;
    IF OBJECT_ID('tempdb..#table_5_level_2_Exec')                       IS NOT NULL DROP TABLE #table_5_level_2_Exec;
    IF OBJECT_ID('tempdb..#table_5_level_3_National_Managers')          IS NOT NULL DROP TABLE #table_5_level_3_National_Managers;
    IF OBJECT_ID('tempdb..#table_5_level_4_Regional_Managers')          IS NOT NULL DROP TABLE #table_5_level_4_Regional_Managers;
    IF OBJECT_ID('tempdb..#table_5_level_5_District_Managers')          IS NOT NULL DROP TABLE #table_5_level_5_District_Managers;
    IF OBJECT_ID('tempdb..#table_5_level_6_SMs_TL')                    IS NOT NULL DROP TABLE #table_5_level_6_SMs_TL;
    IF OBJECT_ID('tempdb..#table_5_level_7_Non_Charge_Employees')       IS NOT NULL DROP TABLE #table_5_level_7_Non_Charge_Employees;
    IF OBJECT_ID('tempdb..#table_6_level_7_and_6')                      IS NOT NULL DROP TABLE #table_6_level_7_and_6;
    IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5')               IS NOT NULL DROP TABLE #table_6_level_7_and_6_and_5;
    IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4')         IS NOT NULL DROP TABLE #table_6_level_7_and_6_and_5_and_4;
    IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4_and_3')   IS NOT NULL DROP TABLE #table_6_level_7_and_6_and_5_and_4_and_3;
    IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4_and_3_and_2') IS NOT NULL DROP TABLE #table_6_level_7_and_6_and_5_and_4_and_3_and_2;
    IF OBJECT_ID('tempdb..#table_6_final')                              IS NOT NULL DROP TABLE #table_6_final;
    IF OBJECT_ID('tempdb..#table_7_a_tenancy')                          IS NOT NULL DROP TABLE #table_7_a_tenancy;
    IF OBJECT_ID('tempdb..#table_7a_district')                          IS NOT NULL DROP TABLE #table_7a_district;
    IF OBJECT_ID('tempdb..#table_7_district')                           IS NOT NULL DROP TABLE #table_7_district;
    IF OBJECT_ID('tempdb..#table_7_final_district')                     IS NOT NULL DROP TABLE #table_7_final_district;
    IF OBJECT_ID('tempdb..#final_table_property')                       IS NOT NULL DROP TABLE #final_table_property;
    IF OBJECT_ID('tempdb..#finalfinal')                                 IS NOT NULL DROP TABLE #finalfinal;
    IF OBJECT_ID('tempdb..#final_record_base')                          IS NOT NULL DROP TABLE #final_record_base;
    IF OBJECT_ID('tempdb..#table_6_final_all')                          IS NOT NULL DROP TABLE #table_6_final_all;
    IF OBJECT_ID('tempdb..#tenancy_manager_table')                      IS NOT NULL DROP TABLE #tenancy_manager_table;

    -- ============================================================
    -- [OPT 1] Pre-compute all leader email addresses into a set
    -- ============================================================
    SELECT DISTINCT email_address
    INTO #leader_emails
    FROM (
        SELECT employee_people_leader_email_level_1 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_2 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_3 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_4 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_5 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_6 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_7 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_8 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
        UNION SELECT employee_people_leader_email_level_9 FROM edw.dim_employee_hierarchy WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'D'
    ) AS src (email_address)
    WHERE email_address IS NOT NULL;

    CREATE CLUSTERED INDEX ix_leader_emails ON #leader_emails (email_address);

    -- [OPT 2] Pre-compute Auckland South Mobile DM boss
    DECLARE @auckland_dm_boss INT;
    SELECT @auckland_dm_boss = employee_id
    FROM edw.dim_employee_hierarchy
    WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'd'
        AND employee_Business_unit_name = 'auckland south mobile district'
        AND employee_people_leader_role_name_level_6 IS NULL
        AND employee_people_leader_role_name_level_5 = 'district manager';

    -- [OPT 1] #table_1_NoDirectReports — LEFT JOIN replaces 9-way NOT EXISTS
    SELECT E.employee_id
    INTO #table_1_NoDirectReports
    FROM edw.dim_employee_hierarchy AS E
    INNER JOIN edw.dim_employee DE
        ON E.employee_id = DE.employee_id
            AND DE.DWHIsCurrent = 1 AND DE.DWHDMLOperation <> 'd'
            AND DE.employee_employment_status IN ('current staff', 'exiting staff')
    LEFT JOIN #leader_emails le ON E.employee_primary_email_address = le.email_address
    WHERE E.DWHIsCurrent = 1
        AND E.employee_primary_email_address IS NOT NULL
        AND le.email_address IS NULL;

    CREATE CLUSTERED INDEX ix_t1_emp ON #table_1_NoDirectReports (employee_id);

    -- #table_2_ServiceTable (unchanged logic)
    SELECT service_name, service_id, service_code, dim_service_key, dim_company_key, district_name,
        CASE
            WHEN department_name COLLATE Latin1_General_CI_AI = 'Health and Disability Services' COLLATE Latin1_General_CI_AI THEN 'Health and Disability Management'
            WHEN department_name COLLATE Latin1_General_CI_AI = 'Health and Disability' COLLATE Latin1_General_CI_AI THEN 'Health and Disability Management'
            ELSE department_name
        END AS department_name,
        region_name,
        CASE WHEN dim_company_key = 5 THEN 'Mind and Body'
             WHEN company_name COLLATE Latin1_General_CI_AI LIKE '%ignite%' COLLATE Latin1_General_CI_AI THEN 'Ignite'
             ELSE 'Emerge' END AS company,
        is_inactive
    INTO #table_2_ServiceTable
    FROM edw.dim_service
    WHERE DWHIsCurrent = 1 AND DWHDMLOperation <> 'd'
        AND service_name COLLATE Latin1_General_CI_AI NOT IN ('tauranga mobile' COLLATE Latin1_General_CI_AI)
    UNION
    SELECT 'Kia Ora Ake', '', '', '', 1, 'HD Auckland South Mobile', 'Health and Disability', 'RM Counties Manukau/Auckland', 'Emerge', 0
    UNION
    SELECT 'Tauranga Mobile', '', '', '', 1, 'HD Waikato/Lakes', 'Health and Disability', 'RM Midland', 'Emerge', 0;

    CREATE CLUSTERED INDEX ix_t2_name_co ON #table_2_ServiceTable (service_name, company);

    -- #table_3a_Employee_Hierarchy (unchanged logic)
    SELECT dim_employee_hierarchy.dim_employee_hierarchy_key, dim_employee_hierarchy.dim_employee_key,
        dim_employee_hierarchy.employee_id, dim_employee_hierarchy.employee_primary_email_address,
        dim_employee_hierarchy.employee_company_name, employee_Business_unit_name, employee_displayname,
        CASE
            WHEN NDR.employee_id IS NOT NULL THEN 6
            ELSE CASE
                WHEN employee_people_leader_business_unit_name_level_9 IS NOT NULL AND employee_people_leader_business_unit_name_level_8 IS NOT NULL
                    AND employee_people_leader_business_unit_name_level_9 COLLATE Latin1_General_CI_AI = employee_people_leader_business_unit_name_level_8 COLLATE Latin1_General_CI_AI
                    AND employee_people_leader_business_unit_name_level_8 COLLATE Latin1_General_CI_AI <> employee_people_leader_business_unit_name_level_7 COLLATE Latin1_General_CI_AI THEN 8
                WHEN employee_job_name COLLATE Latin1_General_CI_AI = 'cleaner' COLLATE Latin1_General_CI_AI THEN 8
                WHEN employee_people_leader_business_unit_name_level_9 IS NULL AND employee_people_leader_business_unit_name_level_8 IS NOT NULL THEN 8
                WHEN employee_people_leader_business_unit_name_level_8 IS NULL AND employee_people_leader_business_unit_name_level_7 IS NOT NULL THEN 7
                WHEN employee_people_leader_business_unit_name_level_7 IS NULL AND employee_people_leader_business_unit_name_level_6 IS NOT NULL THEN 6
                WHEN employee_people_leader_business_unit_name_level_6 IS NULL AND employee_people_leader_business_unit_name_level_5 IS NOT NULL THEN 5
                WHEN employee_people_leader_business_unit_name_level_5 IS NULL AND employee_people_leader_business_unit_name_level_4 IS NOT NULL THEN 4
                WHEN employee_people_leader_business_unit_name_level_4 IS NULL AND employee_people_leader_business_unit_name_level_3 IS NOT NULL THEN 3
                WHEN employee_people_leader_business_unit_name_level_3 IS NULL AND employee_people_leader_business_unit_name_level_2 IS NOT NULL THEN 2
                WHEN employee_people_leader_business_unit_name_level_2 IS NULL AND employee_people_leader_business_unit_name_level_1 IS NOT NULL THEN 1
            END
        END AS hierarchy_number_0,
        employee_employment_status, employee_job_name, employee_current_status,
        CASE
            WHEN employee_people_leader_employee_number_level_7 = dim_employee.employee_id THEN employee_people_leader_employee_number_level_6
            WHEN employee_people_leader_employee_number_level_6 = dim_employee.employee_id THEN employee_people_leader_employee_number_level_5
            WHEN employee_people_leader_employee_number_level_5 = dim_employee.employee_id THEN employee_people_leader_employee_number_level_4
            WHEN employee_people_leader_employee_number_level_4 = dim_employee.employee_id THEN employee_people_leader_employee_number_level_3
            WHEN employee_people_leader_employee_number_level_3 = dim_employee.employee_id THEN employee_people_leader_employee_number_level_2
            WHEN employee_people_leader_employee_number_level_2 = dim_employee.employee_id THEN employee_people_leader_employee_number_level_1
        END AS bosses_employee_id,
        CASE
            WHEN employee_Business_unit_name LIKE 'tenancy service%' OR employee_job_name LIKE '%housing trust%'
                OR (employee_job_name IN ('Contractor','National Tenancy Operations Manager','Strategic Advisor Housing Trust','General Manager Housing Trust','Housing Programme Manager','Community Development Manager')
                    AND employee_business_unit_name = 'national housing management') THEN 'Tenancy'
            WHEN employee_business_unit_name = 'property and asset management' OR employee_job_name = 'tenancy manager' OR employee_job_name = 'Senior Tenancy Manager' THEN 'Tenancy'
            WHEN dim_employee.employee_company_name LIKE '%ignite%' THEN 'Ignite'
            ELSE 'EAL'
        END AS Tenancy_Employees
    INTO #table_3a_Employee_Hierarchy
    FROM edw.dim_employee_hierarchy
    INNER JOIN edw.dim_employee ON dim_employee_hierarchy.employee_id = dim_employee.employee_id
    LEFT JOIN #table_1_NoDirectReports NDR ON NDR.employee_id = dim_employee_hierarchy.employee_id
    WHERE dim_employee.DWHIsCurrent = 1 AND dim_employee_hierarchy.DWHDMLOperation <> 'D' AND dim_employee_hierarchy.DWHIsCurrent = 1
        AND dim_employee_hierarchy.employee_company_name COLLATE Latin1_General_CI_AI NOT IN ('previous business entity' COLLATE Latin1_General_CI_AI)
        AND dim_employee.DWHDMLOperation <> 'D' AND dim_employee.DWHIsCurrent = 1
        AND employee_employment_status IN ('exiting staff', 'current staff')
        AND dim_employee_hierarchy.employee_primary_email_address NOT LIKE '%demo%intellihr%';

    CREATE CLUSTERED INDEX ix_t3a_emp ON #table_3a_Employee_Hierarchy (employee_id);

    -- #table_3b_Employee_Hierarchy (unchanged logic)
    SELECT *,
        CASE
            WHEN hierarchy_number_0 IN (7, 8) THEN 7
            WHEN hierarchy_number_0 = 2 AND employee_job_name IN ('General Manager Housing Trust','National Director Services','Director Ignite Aotearoa') THEN 2
            WHEN employee_job_name IN ('group chief financial officer','group chief information officer') THEN 6
            WHEN hierarchy_number_0 = 2 AND employee_job_name IN ('group director governance','group chief people officer','group director business improvement') THEN 5
            WHEN hierarchy_number_0 = 2 AND employee_job_name LIKE '%group director%' THEN 6
            WHEN hierarchy_number_0 = 2 AND employee_job_name LIKE '%Mana Whakahaere%' THEN 4
            WHEN hierarchy_number_0 = 2 THEN 7
            WHEN hierarchy_number_0 = 3 AND employee_job_name IN ('National Housing Manager','National Manager Health & Disability','National Practice Manager','National Tenancy Operations Manager') THEN 3
            WHEN hierarchy_number_0 = 3 AND employee_job_name = 'Head of Delivery' THEN 6
            WHEN hierarchy_number_0 = 3 AND employee_job_name = 'Regional Asset Portfolio Manager' THEN 6
            WHEN hierarchy_number_0 = 3 AND employee_job_name = 'Business Development Manager' AND employee_business_unit_name = 'GD Business Improvement' THEN 6
            WHEN hierarchy_number_0 = 3 THEN 7
            WHEN hierarchy_number_0 = 4 AND employee_job_name LIKE '%housing operations manager%' THEN 4
            WHEN hierarchy_number_0 = 4 AND employee_job_name LIKE '%regional manager%' THEN 4
            WHEN hierarchy_number_0 = 4 AND employee_job_name LIKE '%regional practic%' THEN 4
            WHEN hierarchy_number_0 = 4 AND employee_job_name LIKE '%Operations Manager%Peer Service%' THEN 4
            WHEN hierarchy_number_0 = 4 AND employee_job_name IN ('team leader - housing services') THEN 7
            WHEN hierarchy_number_0 = 4 AND employee_job_name LIKE 'team leader%tenancy%' THEN 6
            WHEN hierarchy_number_0 = 4 AND employee_job_name LIKE '%team leader%' THEN 5
            WHEN hierarchy_number_0 = 4 THEN 7
            WHEN hierarchy_number_0 = 5 AND employee_job_name LIKE '%district%' THEN 5
            WHEN hierarchy_number_0 = 5 AND employee_job_name = 'Manager' THEN 5
            WHEN hierarchy_number_0 = 5 AND employee_job_name = 'Pasifika Service Delivery Manager' THEN 5
            WHEN hierarchy_number_0 = 5 AND (employee_job_name LIKE '%team leader%' OR employee_job_name LIKE '%service manager%') THEN 6
            WHEN hierarchy_number_0 = 5 AND employee_job_name LIKE '%Tenancy Manager%' THEN 7
            WHEN hierarchy_number_0 = 5 THEN 7
            WHEN hierarchy_number_0 = 6 AND employee_job_name LIKE '%service manager%' THEN 6
            WHEN hierarchy_number_0 = 6 THEN 7
            ELSE hierarchy_number_0
        END AS hierarchy_number,
        CASE
            WHEN employee_primary_email_address COLLATE Latin1_General_CI_AI LIKE '%mind%body%' COLLATE Latin1_General_CI_AI THEN 'Mind and Body'
            WHEN employee_primary_email_address COLLATE Latin1_General_CI_AI LIKE '%ignite%' COLLATE Latin1_General_CI_AI THEN 'Ignite'
            ELSE 'Emerge'
        END AS company_field
    INTO #table_3b_Employee_Hierarchy
    FROM #table_3a_Employee_Hierarchy
    WHERE employee_employment_status NOT IN ('past staff', 'future staff');

    CREATE CLUSTERED INDEX ix_t3b_emp ON #table_3b_Employee_Hierarchy (employee_id);
    CREATE INDEX ix_t3b_bu ON #table_3b_Employee_Hierarchy (employee_Business_unit_name, company_field);

    -- #table_3c_Employee_Hierarchy_with_Services
    SELECT 'Original' AS table_type,
        b.dim_employee_hierarchy_key, b.dim_employee_key, b.employee_id, b.employee_primary_email_address,
        b.employee_company_name, b.employee_Business_unit_name, b.employee_displayname, b.hierarchy_number_0,
        b.employee_employment_status, b.employee_job_name, b.employee_current_status, b.hierarchy_number,
        b.company_field, b.Tenancy_Employees,
        s.service_name, s.service_id, s.service_code, s.dim_service_key, s.dim_company_key,
        CASE WHEN b.employee_id = 601556 THEN 'HD Easeup Services' ELSE s.district_name END AS district_name,
        s.department_name, s.region_name, s.company, b.bosses_employee_id
    INTO #table_3c_Employee_Hierarchy_with_Services
    FROM #table_3b_Employee_Hierarchy b
    LEFT JOIN #table_2_ServiceTable s
        ON b.employee_Business_unit_name COLLATE Latin1_General_CI_AI = s.service_name COLLATE Latin1_General_CI_AI
            AND b.company_field COLLATE Latin1_General_CI_AI = s.company COLLATE Latin1_General_CI_AI;

    CREATE CLUSTERED INDEX ix_t3c_emp ON #table_3c_Employee_Hierarchy_with_Services (employee_id);
    CREATE INDEX ix_t3c_num ON #table_3c_Employee_Hierarchy_with_Services (hierarchy_number, employee_employment_status);
    CREATE INDEX ix_t3c_boss ON #table_3c_Employee_Hierarchy_with_Services (bosses_employee_id);
    CREATE INDEX ix_t3c_dist ON #table_3c_Employee_Hierarchy_with_Services (district_name, Tenancy_Employees);
    CREATE INDEX ix_t3c_reg ON #table_3c_Employee_Hierarchy_with_Services (region_name, department_name, Tenancy_Employees);

    -- [OPT 2] #table_4_cost_allocations — scalar subquery replaced with @auckland_dm_boss
    SELECT DISTINCT 'cost allocation' AS table_type,
        employee_number, displayName, dim_employee_key, email_address, job_title,
        datapay_cost_center_name, intellihr_business_unit_name, person_is_supervisor,
        s.service_name, s.service_id, s.service_code, s.dim_service_key, s.dim_company_key,
        s.region_name, s.district_name, s.department_name,
        CASE WHEN email_address LIKE '%mind%body%' THEN 'Mind and Body'
             WHEN email_address LIKE '%ignite%' THEN 'Ignite' ELSE 'Emerge' END AS Company,
        employee_job_name,
        CASE WHEN job_title LIKE '%regional manager%' THEN 4
             WHEN job_title LIKE '%district manager%' THEN 5
             WHEN job_title LIKE '%service manager%' OR job_title LIKE '%team leader%housing%' THEN 6
             ELSE 7 END AS hierarchy_number,
        CASE
            WHEN intellihr_business_unit_name LIKE 'tenancy service%' OR intellihr_job_title LIKE '%housing trust%'
                OR (employee_job_name IN ('Contractor','National Tenancy Operations Manager','Strategic Advisor Housing Trust','General Manager Housing Trust','Housing Programme Manager','Community Development Manager')
                    AND intellihr_business_unit_name = 'national housing management') THEN 'Tenancy'
            WHEN intellihr_business_unit_name = 'property and asset management' OR intellihr_job_title = 'tenancy manager' THEN 'Tenancy'
            WHEN de.employee_company_name LIKE '%ignite%' THEN 'Ignite'
            ELSE 'EAL'
        END AS RLS_Tenancy_Employees,
        CASE WHEN ca.intellihr_bc_code = 'cm awhi ora' AND intellihr_job_title = 'service manager'
             THEN @auckland_dm_boss ELSE eb.bosses_employee_id END AS bosses_employee_id
    INTO #table_4_cost_allocations
    FROM landing.row_level_security_cost_allocations ca
    LEFT JOIN #table_2_ServiceTable s
        ON ca.intellihr_business_unit_name COLLATE Latin1_General_CI_AI = s.service_name COLLATE Latin1_General_CI_AI
    LEFT JOIN edw.dim_employee de
        ON ca.employee_number = de.employee_id AND de.DWHIsCurrent = 1 AND de.DWHDMLOperation <> 'd'
    LEFT JOIN (SELECT DISTINCT employee_id, bosses_employee_id FROM #table_3c_Employee_Hierarchy_with_Services) eb
        ON ca.employee_number = eb.employee_id;

    CREATE CLUSTERED INDEX ix_t4_emp ON #table_4_cost_allocations (employee_number);
    CREATE INDEX ix_t4_num ON #table_4_cost_allocations (hierarchy_number);

    -- #table_3d CEO cross join setup
    SELECT 'Original' AS table_type,
        dim_employee_hierarchy_key, dim_employee_key, employee_id, employee_primary_email_address,
        employee_company_name, employee_Business_unit_name, employee_displayname, hierarchy_number_0,
        employee_employment_status, employee_job_name, employee_current_status,
        7 AS hierarchy_number, -- CEO sees all services
        company_field, service_name, service_id, service_code, dim_service_key, dim_company_key,
        district_name, department_name, region_name, company, bosses_employee_id, Tenancy_Employees
    INTO #table_3d_Hierarchy_Level_1_Cross_Join_CEO
    FROM #table_3c_Employee_Hierarchy_with_Services
    WHERE hierarchy_number = 1;

    -- #table_3e CEO × all services
    SELECT 'Original' AS table_type,
        ceo.dim_employee_hierarchy_key, ceo.dim_employee_key, ceo.employee_id, ceo.employee_primary_email_address,
        ceo.employee_company_name, ceo.employee_Business_unit_name, ceo.employee_displayname, ceo.hierarchy_number_0,
        ceo.employee_employment_status, ceo.employee_job_name, ceo.employee_current_status, ceo.hierarchy_number,
        ceo.company_field, ceo.Tenancy_Employees,
        s.service_name, s.service_id, s.service_code, s.dim_service_key, s.dim_company_key,
        s.district_name, s.department_name, s.region_name, s.company, '' AS bosses_employee_id
    INTO #table_3e_Hierarchy_Level_Cross_Join_Result
    FROM #table_3d_Hierarchy_Level_1_Cross_Join_CEO ceo
    CROSS JOIN #table_2_ServiceTable s;

    -- #table_3_Final
    SELECT * INTO #table_3_Final_Hierarchy_with_Services FROM #table_3c_Employee_Hierarchy_with_Services
    UNION
    SELECT * FROM #table_3e_Hierarchy_Level_Cross_Join_Result;

    CREATE CLUSTERED INDEX ix_t3f_emp ON #table_3_Final_Hierarchy_with_Services (employee_id);
    CREATE INDEX ix_t3f_num ON #table_3_Final_Hierarchy_with_Services (hierarchy_number, employee_employment_status);
    CREATE INDEX ix_t3f_dist ON #table_3_Final_Hierarchy_with_Services (district_name, Tenancy_Employees);
    CREATE INDEX ix_t3f_reg ON #table_3_Final_Hierarchy_with_Services (region_name, department_name, Tenancy_Employees);

    -- Level bucket tables (levels 1-7)
    SELECT table_type, hierarchy_number, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company_field AS company, dim_company_key, Tenancy_Employees
    INTO #table_5_level_1_CEO
    FROM #table_3_Final_Hierarchy_with_Services
    WHERE hierarchy_number = 1
        AND employee_employment_status COLLATE Latin1_General_CI_AI IN ('Current Staff' COLLATE Latin1_General_CI_AI, 'Exiting Staff' COLLATE Latin1_General_CI_AI);
    CREATE CLUSTERED INDEX ix_t5l1 ON #table_5_level_1_CEO (employee_id);

    SELECT table_type, hierarchy_number, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company_field AS company, dim_company_key, Tenancy_Employees, bosses_employee_id
    INTO #table_5_level_2_Exec
    FROM #table_3_Final_Hierarchy_with_Services
    WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN ('Current Staff' COLLATE Latin1_General_CI_AI, 'Exiting Staff' COLLATE Latin1_General_CI_AI)
        AND hierarchy_number = 2;
    CREATE CLUSTERED INDEX ix_t5l2 ON #table_5_level_2_Exec (employee_id);
    CREATE INDEX ix_t5l2_ten ON #table_5_level_2_Exec (Tenancy_Employees);

    SELECT table_type, hierarchy_number, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company_field AS company, dim_company_key, Tenancy_Employees, bosses_employee_id
    INTO #table_5_level_3_National_Managers
    FROM #table_3_Final_Hierarchy_with_Services
    WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN ('Current Staff' COLLATE Latin1_General_CI_AI, 'Exiting Staff' COLLATE Latin1_General_CI_AI)
        AND hierarchy_number = 3;
    CREATE CLUSTERED INDEX ix_t5l3 ON #table_5_level_3_National_Managers (employee_id);
    CREATE INDEX ix_t5l3_ten ON #table_5_level_3_National_Managers (Tenancy_Employees);

    SELECT table_type, hierarchy_number, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company_field AS company, dim_company_key, Tenancy_Employees, bosses_employee_id
    INTO #table_5_level_4_Regional_Managers
    FROM #table_3_Final_Hierarchy_with_Services
    WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN ('Current Staff' COLLATE Latin1_General_CI_AI, 'Exiting Staff' COLLATE Latin1_General_CI_AI) AND hierarchy_number = 4
    UNION
    SELECT table_type, 49, dim_employee_key, employee_number, email_address, employee_job_name, service_name, dim_service_key, service_id, service_code, department_name, district_name, region_name, company, dim_company_key, RLS_Tenancy_Employees, bosses_employee_id
    FROM #table_4_cost_allocations WHERE hierarchy_number = 4;
    CREATE CLUSTERED INDEX ix_t5l4 ON #table_5_level_4_Regional_Managers (employee_id);
    CREATE INDEX ix_t5l4_reg ON #table_5_level_4_Regional_Managers (region_name, Tenancy_Employees);

    SELECT table_type, hierarchy_number, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company_field AS company, dim_company_key, Tenancy_Employees, bosses_employee_id
    INTO #table_5_level_5_District_Managers
    FROM #table_3_Final_Hierarchy_with_Services
    WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN ('Current Staff' COLLATE Latin1_General_CI_AI, 'Exiting Staff' COLLATE Latin1_General_CI_AI) AND hierarchy_number = 5
    UNION
    SELECT table_type, 59, dim_employee_key, employee_number, email_address, employee_job_name, service_name, dim_service_key, service_id, service_code, department_name, district_name, region_name, company, dim_company_key, RLS_Tenancy_Employees, bosses_employee_id
    FROM #table_4_cost_allocations WHERE hierarchy_number = 5;
    CREATE CLUSTERED INDEX ix_t5l5 ON #table_5_level_5_District_Managers (employee_id);
    CREATE INDEX ix_t5l5_dist ON #table_5_level_5_District_Managers (district_name, Tenancy_Employees);
    CREATE INDEX ix_t5l5_reg ON #table_5_level_5_District_Managers (region_name, department_name, Tenancy_Employees);

    SELECT table_type, hierarchy_number, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company_field AS company, dim_company_key, Tenancy_Employees, bosses_employee_id
    INTO #table_5_level_6_SMs_TL
    FROM #table_3_Final_Hierarchy_with_Services
    WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN ('Current Staff' COLLATE Latin1_General_CI_AI, 'Exiting Staff' COLLATE Latin1_General_CI_AI) AND hierarchy_number = 6
    UNION
    SELECT table_type, 96, dim_employee_key, employee_number, email_address, employee_job_name, service_name, dim_service_key, service_id, service_code, department_name, district_name, region_name, company, dim_company_key, RLS_Tenancy_Employees, bosses_employee_id
    FROM #table_4_cost_allocations WHERE hierarchy_number = 6;
    CREATE CLUSTERED INDEX ix_t5l6 ON #table_5_level_6_SMs_TL (employee_id);
    CREATE INDEX ix_t5l6_boss ON #table_5_level_6_SMs_TL (bosses_employee_id);

    SELECT table_type, hierarchy_number, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company_field AS company, dim_company_key, bosses_employee_id, Tenancy_Employees
    INTO #table_5_level_7_Non_Charge_Employees
    FROM #table_3_Final_Hierarchy_with_Services
    WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN ('Current Staff' COLLATE Latin1_General_CI_AI, 'Exiting Staff' COLLATE Latin1_General_CI_AI) AND hierarchy_number = 7
    UNION
    SELECT table_type, 97, dim_employee_key, employee_number, email_address, employee_job_name, service_name, dim_service_key, service_id, service_code, department_name, district_name, region_name, company, dim_company_key, '', RLS_Tenancy_Employees
    FROM #table_4_cost_allocations WHERE hierarchy_number = 7;
    CREATE CLUSTERED INDEX ix_t5l7 ON #table_5_level_7_Non_Charge_Employees (employee_id);
    CREATE INDEX ix_t5l7_boss ON #table_5_level_7_Non_Charge_Employees (bosses_employee_id);
    CREATE INDEX ix_t5l7_dist ON #table_5_level_7_Non_Charge_Employees (district_name, Tenancy_Employees);

    -- ============================================================
    -- Part 3: Cascade rollup (unchanged logic, indexes added)
    -- ============================================================

    -- #table_6_level_7_and_6
    SELECT DISTINCT t7.table_type, t7.hierarchy_number, t7.dim_employee_key, t7.employee_id,
        t7.employee_primary_email_address, t7.employee_job_name, t7.Tenancy_Employees,
        t7.service_name, t7.dim_service_key, t7.service_id, t7.service_code,
        t7.department_name, t7.district_name, t7.region_name, t7.company, t7.bosses_employee_id
    INTO #table_6_level_7_and_6
    FROM #table_5_level_7_Non_Charge_Employees t7
    UNION
    SELECT DISTINCT t6.table_type, t6.hierarchy_number, t6.dim_employee_key, t6.employee_id,
        t6.employee_primary_email_address, t6.employee_job_name, t6.Tenancy_Employees,
        t6.service_name, t6.dim_service_key, t6.service_id, t6.service_code,
        t6.department_name, t6.district_name, t6.region_name, t6.company, t6.bosses_employee_id
    FROM #table_5_level_6_SMs_TL t6
    UNION
    SELECT DISTINCT 'Hierarchy', 6, t6.dim_employee_key, t6.employee_id,
        t6.employee_primary_email_address, t6.employee_job_name, t6.Tenancy_Employees,
        t7.service_name, t7.dim_service_key, t7.service_id, t7.service_code,
        t7.department_name, t7.district_name, t7.region_name, t7.company, t6.bosses_employee_id
    FROM #table_5_level_7_Non_Charge_Employees t7
    INNER JOIN #table_5_level_6_SMs_TL t6 ON t7.bosses_employee_id = t6.employee_id;

    CREATE CLUSTERED INDEX ix_t6_76_emp ON #table_6_level_7_and_6 (employee_id);
    CREATE INDEX ix_t6_76_dist ON #table_6_level_7_and_6 (district_name, Tenancy_Employees);
    CREATE INDEX ix_t6_76_reg ON #table_6_level_7_and_6 (region_name, department_name, Tenancy_Employees);

    -- #table_6_level_7_and_6_and_5
    SELECT t.table_type, t.hierarchy_number, t.dim_employee_key, t.employee_id, t.employee_primary_email_address,
        t.employee_job_name, t.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, t.bosses_employee_id
    INTO #table_6_level_7_and_6_and_5
    FROM #table_6_level_7_and_6 t
    UNION
    SELECT DISTINCT 'Hierarchy', 6, d5.dim_employee_key, d5.employee_id, d5.employee_primary_email_address,
        d5.employee_job_name, d5.Tenancy_Employees, t6.service_name, t6.dim_service_key, t6.service_id, t6.service_code,
        t6.department_name, t6.district_name, t6.region_name, t6.company, d5.bosses_employee_id
    FROM #table_5_level_5_District_Managers d5
    INNER JOIN #table_5_level_6_SMs_TL t6 ON t6.bosses_employee_id = d5.employee_id
    UNION
    SELECT DISTINCT 'District', d5.hierarchy_number, d5.dim_employee_key, d5.employee_id, d5.employee_primary_email_address,
        d5.employee_job_name, d5.Tenancy_Employees, t76.service_name, t76.dim_service_key, t76.service_id, t76.service_code,
        t76.department_name, t76.district_name, t76.region_name, t76.company, d5.bosses_employee_id
    FROM #table_5_level_5_District_Managers d5
    LEFT JOIN #table_6_level_7_and_6 t76 ON d5.district_name = t76.district_name
    WHERE d5.Tenancy_Employees = 'eal' AND t76.Tenancy_Employees = 'eal'
        AND t76.department_name <> 'owned property' AND d5.district_name <> 'default' AND t76.district_name <> 'default'
    UNION
    SELECT DISTINCT 'Region and Dept', d5.hierarchy_number, d5.dim_employee_key, d5.employee_id, d5.employee_primary_email_address,
        d5.employee_job_name, d5.Tenancy_Employees, t76.service_name, t76.dim_service_key, t76.service_id, t76.service_code,
        t76.department_name, t76.district_name, t76.region_name, t76.company, d5.bosses_employee_id
    FROM #table_5_level_5_District_Managers d5
    LEFT JOIN #table_6_level_7_and_6 t76 ON d5.region_name = t76.region_name AND d5.department_name = t76.department_name
    WHERE d5.Tenancy_Employees = 'eal' AND t76.Tenancy_Employees = 'eal'
        AND t76.department_name <> 'owned property' AND d5.district_name = 'default' AND t76.district_name = 'default'
    UNION
    SELECT DISTINCT d5.table_type, d5.hierarchy_number, d5.dim_employee_key, d5.employee_id, d5.employee_primary_email_address,
        d5.employee_job_name, d5.Tenancy_Employees, t76.service_name, t76.dim_service_key, t76.service_id, t76.service_code,
        t76.department_name, t76.district_name, t76.region_name, t76.company, d5.bosses_employee_id
    FROM #table_5_level_5_District_Managers d5
    INNER JOIN #table_6_level_7_and_6 t76 ON d5.district_name = t76.district_name
    WHERE d5.Tenancy_Employees = 'tenancy' AND t76.Tenancy_Employees = 'tenancy';

    CREATE CLUSTERED INDEX ix_t6_765_emp ON #table_6_level_7_and_6_and_5 (employee_id);
    CREATE INDEX ix_t6_765_reg ON #table_6_level_7_and_6_and_5 (region_name, Tenancy_Employees);
    CREATE INDEX ix_t6_765_dept ON #table_6_level_7_and_6_and_5 (department_name, Tenancy_Employees);

    -- #table_6_level_7_and_6_and_5_and_4
    SELECT * INTO #table_6_level_7_and_6_and_5_and_4 FROM #table_6_level_7_and_6_and_5
    UNION
    SELECT DISTINCT r4.table_type, r4.hierarchy_number, r4.dim_employee_key, r4.employee_id, r4.employee_primary_email_address,
        r4.employee_job_name, r4.Tenancy_Employees, t765.service_name, t765.dim_service_key, t765.service_id, t765.service_code,
        t765.department_name, t765.district_name, t765.region_name, t765.company, r4.bosses_employee_id
    FROM #table_5_level_4_Regional_Managers r4
    INNER JOIN #table_6_level_7_and_6_and_5 t765 ON r4.region_name = t765.region_name
    WHERE r4.Tenancy_Employees = 'eal' AND t765.Tenancy_Employees = 'eal' AND t765.department_name <> 'owned property'
    UNION
    SELECT DISTINCT r4.table_type, r4.hierarchy_number, r4.dim_employee_key, r4.employee_id, r4.employee_primary_email_address,
        r4.employee_job_name, r4.Tenancy_Employees, t765.service_name, t765.dim_service_key, t765.service_id, t765.service_code,
        t765.department_name, t765.district_name, t765.region_name, t765.company, r4.bosses_employee_id
    FROM #table_5_level_4_Regional_Managers r4
    CROSS JOIN #table_6_level_7_and_6_and_5 t765
    WHERE r4.region_name = 'HD Peer Services' AND t765.region_name = 'Mind and Body'
    UNION
    SELECT DISTINCT r4.table_type, r4.hierarchy_number, r4.dim_employee_key, r4.employee_id, r4.employee_primary_email_address,
        r4.employee_job_name, r4.Tenancy_Employees, t765.service_name, t765.dim_service_key, t765.service_id, t765.service_code,
        t765.department_name, t765.district_name, t765.region_name, t765.company, r4.bosses_employee_id
    FROM #table_5_level_4_Regional_Managers r4
    INNER JOIN #table_6_level_7_and_6_and_5 t765 ON r4.region_name = t765.region_name
    WHERE r4.Tenancy_Employees = 'tenancy' AND t765.Tenancy_Employees = 'tenancy';

    CREATE INDEX ix_t6_7654_ten ON #table_6_level_7_and_6_and_5_and_4 (Tenancy_Employees, region_name);
    CREATE INDEX ix_t6_7654_dept ON #table_6_level_7_and_6_and_5_and_4 (department_name, Tenancy_Employees);

    -- #table_6_level_7_and_6_and_5_and_4_and_3
    SELECT * INTO #table_6_level_7_and_6_and_5_and_4_and_3 FROM #table_6_level_7_and_6_and_5_and_4
    UNION
    SELECT DISTINCT n3.table_type, n3.hierarchy_number, n3.dim_employee_key, n3.employee_id, n3.employee_primary_email_address,
        n3.employee_job_name, n3.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, n3.bosses_employee_id
    FROM #table_5_level_3_National_Managers n3
    CROSS JOIN #table_6_level_7_and_6_and_5_and_4 t
    WHERE n3.Tenancy_Employees = 'eal' AND t.Tenancy_Employees = 'eal'
        AND n3.service_name LIKE 'health and disab%'
        AND t.region_name NOT LIKE 'housing%' AND t.region_name NOT LIKE 'tenanncy%' AND t.region_name NOT LIKE 'tenancy%'
        AND t.department_name IN ('Peer Support','Peer Support Services','Health and Disability Management')
    UNION
    SELECT DISTINCT n3.table_type, n3.hierarchy_number, n3.dim_employee_key, n3.employee_id, n3.employee_primary_email_address,
        n3.employee_job_name, n3.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, n3.bosses_employee_id
    FROM #table_5_level_3_National_Managers n3
    CROSS JOIN #table_6_level_7_and_6_and_5_and_4 t
    WHERE n3.Tenancy_Employees = 'tenancy' AND t.Tenancy_Employees = 'tenancy'
    UNION
    SELECT DISTINCT n3.table_type, n3.hierarchy_number, n3.dim_employee_key, n3.employee_id, n3.employee_primary_email_address,
        n3.employee_job_name, n3.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, n3.bosses_employee_id
    FROM #table_5_level_3_National_Managers n3
    CROSS JOIN #table_6_level_7_and_6_and_5_and_4 t
    WHERE n3.Tenancy_Employees = 'eal' AND t.Tenancy_Employees = 'eal'
        AND n3.service_name LIKE '%national housing%' AND n3.employee_job_name IN ('national housing manager')
        AND t.region_name LIKE 'housing%' AND t.region_name NOT LIKE 'tenanncy%' AND t.region_name NOT LIKE 'tenancy%'
        AND t.department_name NOT IN ('Peer Support','Peer Support Services','Health and Disability Management')
    UNION
    SELECT DISTINCT n3.table_type, n3.hierarchy_number, n3.dim_employee_key, n3.employee_id, n3.employee_primary_email_address,
        n3.employee_job_name, n3.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, n3.bosses_employee_id
    FROM #table_5_level_3_National_Managers n3
    CROSS JOIN #table_6_level_7_and_6_and_5_and_4 t
    WHERE       
         n3.employee_job_name IN ('national practice manager')
        and t.service_name = n3.service_name

    CREATE INDEX ix_t6_76543_ten ON #table_6_level_7_and_6_and_5_and_4_and_3 (Tenancy_Employees, department_name);

    -- #table_6_level_7_and_6_and_5_and_4_and_3_and_2
    SELECT * INTO #table_6_level_7_and_6_and_5_and_4_and_3_and_2 FROM #table_6_level_7_and_6_and_5_and_4_and_3
    UNION
    SELECT e2.table_type, e2.hierarchy_number, e2.dim_employee_key, e2.employee_id, e2.employee_primary_email_address,
        e2.employee_job_name, e2.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, e2.bosses_employee_id
    FROM #table_6_level_7_and_6_and_5_and_4_and_3 t
    CROSS JOIN #table_5_level_2_Exec e2
    WHERE t.Tenancy_Employees IN ('tenancy','property') AND e2.Tenancy_Employees IN ('tenancy','property')
    UNION
    SELECT e2.table_type, e2.hierarchy_number, e2.dim_employee_key, e2.employee_id, e2.employee_primary_email_address,
        e2.employee_job_name, e2.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, e2.bosses_employee_id
    FROM #table_6_level_7_and_6_and_5_and_4_and_3 t
    CROSS JOIN #table_5_level_2_Exec e2
    WHERE t.Tenancy_Employees IN ('ignite') AND e2.Tenancy_Employees IN ('ignite')
    UNION
    SELECT e2.table_type, e2.hierarchy_number, e2.dim_employee_key, e2.employee_id, e2.employee_primary_email_address,
        e2.employee_job_name, e2.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, e2.bosses_employee_id
    FROM #table_6_level_7_and_6_and_5_and_4_and_3 t
    CROSS JOIN #table_5_level_2_Exec e2
    WHERE t.Tenancy_Employees NOT IN ('ignite','property','tenancy') AND e2.Tenancy_Employees NOT IN ('ignite','property','tenancy')
        AND t.department_name NOT IN ('shared services')
        AND t.department_name IN ('health and disability management','housing services','peer support','peer support services');

    -- #table_6_final (CEO + all others)
    SELECT DISTINCT l1.table_type, l1.dim_employee_key, l1.employee_id, l1.employee_primary_email_address,
        l1.employee_job_name, l1.Tenancy_Employees, t.service_name, t.dim_service_key, t.service_id, t.service_code,
        t.department_name, t.district_name, t.region_name, t.company, 9999999 AS bosses_employee_id
    INTO #table_6_final
    FROM #table_6_level_7_and_6_and_5_and_4_and_3_and_2 t
    CROSS JOIN #table_5_level_1_CEO l1
    UNION
    SELECT DISTINCT table_type, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, Tenancy_Employees, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company, bosses_employee_id
    FROM #table_6_level_7_and_6_and_5_and_4_and_3_and_2;

    CREATE CLUSTERED INDEX ix_t6f_emp ON #table_6_final (employee_id);
    CREATE INDEX ix_t6f_code ON #table_6_final (service_code);
    CREATE INDEX ix_t6f_job ON #table_6_final (employee_job_name);

    -- District manager ranking logic
    SELECT DISTINCT 'Recordbase District' AS RLS_Type, f.table_type, f.dim_employee_key, f.employee_id,
        f.employee_primary_email_address, f.employee_job_name, f.service_name, f.dim_service_key,
        f.service_id, f.service_code, f.department_name, f.district_name, f.region_name, f.company,
        f.bosses_employee_id, ct.client_team_id, ct.client_team_name
    INTO #table_7_District
    FROM #table_6_final f
    LEFT JOIN edw.dim_client_team ct
        ON f.service_code = ct.service_id AND ct.DWHDMLOperation <> 'd'
            AND ct.dim_client_team_end_date IS NULL AND ct.dim_service_Key NOT IN (0, -1, -2, -3)
    WHERE f.employee_job_name LIKE 'district man%';
    -- [OPT 5] ORDER BY removed

    SELECT ROW_NUMBER() OVER (PARTITION BY service_id, client_team_id ORDER BY service_id, client_team_id, table_type DESC) AS emp_service_ranking, *
    INTO #table_7a_district
    FROM #table_7_District;
    -- [OPT 5] ORDER BY removed

    SELECT * INTO #table_7_final_district FROM #table_7a_district WHERE emp_service_ranking = 1;
    -- [OPT 5] ORDER BY removed

    -- Final Recordbase RLS assembly
    SELECT DISTINCT 'Recordbase' AS RLS_Type, f.dim_employee_key, f.employee_id, f.employee_primary_email_address,
        f.employee_job_name, f.service_name, f.dim_service_key, f.service_id, f.service_code,
        f.department_name, f.district_name, f.region_name, f.company, f.bosses_employee_id,
        ct.client_team_id, ct.client_team_name
    INTO #table_6_final_all
    FROM #table_6_final f
    LEFT JOIN edw.dim_client_team ct
        ON f.service_code = ct.service_id AND ct.DWHDMLOperation <> 'd'
            AND ct.dim_client_team_end_date IS NULL AND ct.dim_service_Key NOT IN (0, -1, -2, -3)
    WHERE f.employee_job_name NOT LIKE 'district manager%'
    UNION
    SELECT 'Recordbase', dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company, bosses_employee_id,
        client_team_id, client_team_name
    FROM #table_7_final_district
    WHERE employee_job_name LIKE 'district man%';

    SELECT DISTINCT RLS_Type, dim_employee_key, employee_id, employee_primary_email_address,
        employee_job_name, service_name, dim_service_key, service_id, service_code,
        department_name, district_name, region_name, company, client_team_id, client_team_name
    INTO #Final_Record_Base
    FROM #table_6_final_all
    WHERE department_name IN ('health and disability management','housing services','peer support','peer support services','health and disability peer services');

    CREATE CLUSTERED INDEX ix_frb_emp ON #Final_Record_Base (employee_id); -- [OPT 4] needed for employee_levels join

    -- ============================================================
    -- [OPT 4] Pre-compute employee hierarchy levels in one pass.
    -- Replaces 7 IN (SELECT...) subqueries in the final INSERT.
    -- Priority order: level 1 wins over level 2, etc.
    -- ============================================================
    SELECT employee_id, MIN(hierarchy_level) AS hierarchy_level
    INTO #employee_levels
    FROM (
        SELECT DISTINCT employee_id, 1 AS hierarchy_level FROM #table_5_level_1_CEO
        UNION ALL
        SELECT DISTINCT employee_id, 2 FROM #table_5_level_2_Exec
        UNION ALL
        SELECT DISTINCT employee_id, 3 FROM #table_5_level_3_National_Managers
        UNION ALL
        SELECT DISTINCT employee_id, 4 FROM #table_5_level_4_Regional_Managers
        UNION ALL
        SELECT DISTINCT employee_id, 5 FROM #table_5_level_5_District_Managers
        UNION ALL
        SELECT DISTINCT employee_id, 6 FROM #table_5_level_6_SMs_TL
        UNION ALL
        SELECT DISTINCT employee_id, 7 FROM #table_5_level_7_Non_Charge_Employees
    ) AS all_levels
    GROUP BY employee_id;

    CREATE CLUSTERED INDEX ix_el_emp ON #employee_levels (employee_id);

    -- Delete + Insert
    DELETE FROM edw.row_level_security_general WHERE RLS_Type = 'Recordbase';
    DELETE FROM edw.row_level_security_general WHERE RLS_Type = 'Recordbase District';

     --[OPT 4] Single LEFT JOIN to #employee_levels replaces 7 IN (SELECT...) subqueries
     --[OPT 5] ORDER BY removed — meaningless on INSERT
    
    INSERT INTO edw.row_level_security_general (
        RLS_Type, dim_employee_key, employee_id, email, dim_service_key, service_id,
        dim_company_key, client_team_id, dim_client_team_key, employee_level_for_exclusion)
    
    SELECT
        rb.RLS_Type,
        rb.dim_employee_key,
        rb.employee_id,
        rb.employee_primary_email_address,
        rb.dim_service_key,
        rb.service_id,
        CASE
            WHEN rb.company = 'Emerge' THEN 1
            WHEN rb.company LIKE '%Mind%Body%' THEN 5
            WHEN rb.company LIKE '%Ignite%' THEN 4
            ELSE 1
        END AS dim_company_key,
        rb.client_team_id,
        ct.dim_client_team_key,
        ISNULL(el.hierarchy_level, 99) AS employee_level_for_exclusion -- 99 = unmapped, should not occur
    FROM #Final_Record_Base rb
    INNER JOIN edw.dim_client_team ct
        ON rb.client_team_id = ct.client_team_id AND rb.client_team_name = ct.client_team_name
    LEFT JOIN #employee_levels el   -- [OPT 4]
        ON rb.employee_id = el.employee_id

    

END
--GO