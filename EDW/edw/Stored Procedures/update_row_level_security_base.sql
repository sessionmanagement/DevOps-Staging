create   procedure [edw].[update_row_level_security_base]
			
as begin

	/***************************************************************************
	NAME:     [edw].[Updateedwdim_client_incident]
	PURPOSE:  Generate row level security table to be used in Power BI reports

	NOTES:

	REVISIONS:
	Version	 Date		   Author			Description
	-------	 ------------  ---------------	--------------------------
	1.0		 2026-03-31    Timi Boddington	Initial version

	****************************************************************************/

	--Remove temp tables
	IF OBJECT_ID('tempdb..#table_1_NoDirectReports') IS NOT NULL 						DROP TABLE #table_1_NoDirectReports;
	IF OBJECT_ID('tempdb..#table_2_ServiceTable') IS NOT NULL							DROP TABLE #table_2_ServiceTable;
	IF OBJECT_ID('tempdb..#table_3a_Employee_Hierarchy') IS NOT NULL					DROP TABLE #table_3a_Employee_Hierarchy;
	IF OBJECT_ID('tempdb..#table_3b_Employee_Hierarchy') IS NOT NULL					DROP TABLE #table_3b_Employee_Hierarchy;
	IF OBJECT_ID('tempdb..#table_3c_Employee_Hierarchy_with_Services') IS NOT NULL		DROP TABLE #table_3c_Employee_Hierarchy_with_Services;
	IF OBJECT_ID('tempdb..#table_4_cost_allocations') IS NOT NULL						DROP TABLE #table_4_cost_allocations;
	IF OBJECT_ID('tempdb..#table_3d_Hierarchy_Level_1_Cross_Join_CEO') IS NOT NULL		DROP TABLE #table_3d_Hierarchy_Level_1_Cross_Join_CEO;
	IF OBJECT_ID('tempdb..#table_3e_Hierarchy_Level_Cross_Join_Result') IS NOT NULL		DROP TABLE #table_3e_Hierarchy_Level_Cross_Join_Result;
	IF OBJECT_ID('tempdb..#table_3_Final_Hierarchy_with_Services') IS NOT NULL			DROP TABLE #table_3_Final_Hierarchy_with_Services;
	IF OBJECT_ID('tempdb..#table_5_level_1_CEO') IS NOT NULL							DROP TABLE #table_5_level_1_CEO;
	IF OBJECT_ID('tempdb..#table_5_level_2_Exec') IS NOT NULL							DROP TABLE #table_5_level_2_Exec;
	IF OBJECT_ID('tempdb..#table_5_level_3_National_Managers') IS NOT NULL				DROP TABLE #table_5_level_3_National_Managers;
	IF OBJECT_ID('tempdb..#table_5_level_4_Regional_Managers') IS NOT NULL				DROP TABLE #table_5_level_4_Regional_Managers;
	IF OBJECT_ID('tempdb..#table_5_level_5_District_Managers') IS NOT NULL				DROP TABLE #table_5_level_5_District_Managers;
	IF OBJECT_ID('tempdb..#table_5_level_6_SMs_TL') IS NOT NULL							DROP TABLE #table_5_level_6_SMs_TL;
	IF OBJECT_ID('tempdb..#table_5_level_7_Non_Charge_Employees') IS NOT NULL			DROP TABLE #table_5_level_7_Non_Charge_Employees;
	IF OBJECT_ID('tempdb..#table_6_level_7_and_6') IS NOT NULL							DROP TABLE #table_6_level_7_and_6;
	IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5') IS NOT NULL					DROP TABLE #table_6_level_7_and_6_and_5;
	IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4') IS NOT NULL				DROP TABLE #table_6_level_7_and_6_and_5_and_4
	IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4_and_3') IS NOT NULL		DROP TABLE #table_6_level_7_and_6_and_5_and_4_and_3
	IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4_and_3_and_2') IS NOT NULL	DROP TABLE #table_6_level_7_and_6_and_5_and_4_and_3_and_2
	IF OBJECT_ID('tempdb..#table_6_final') IS NOT NULL									DROP TABLE #table_6_final
	IF OBJECT_ID('tempdb..#table_7_a_tenancy') IS NOT NULL								DROP TABLE #table_7_a_tenancy
	IF OBJECT_ID('tempdb..#table_7a_district') IS NOT NULL								DROP TABLE #table_7a_district
	IF OBJECT_ID('tempdb..#table_7_district') IS NOT NULL								DROP TABLE #table_7_district
	IF OBJECT_ID('tempdb..#table_7_final_district') IS NOT NULL							DROP TABLE #table_7_final_district
	IF OBJECT_ID('tempdb..#final_table_property') IS NOT NULL							DROP TABLE #final_table_property
	IF OBJECT_ID('tempdb..#finalfinal') IS NOT NULL										DROP TABLE #finalfinal
	IF OBJECT_ID('tempdb..#final_record_base') IS NOT NULL								DROP TABLE #final_record_base
	IF OBJECT_ID('tempdb..#table_6_final_all') IS NOT NULL								DROP TABLE #table_6_final_all
	IF OBJECT_ID('tempdb..#tenancy_manager_table') IS NOT NULL							DROP TABLE #tenancy_manager_table

-- First, create a temp table to identify employees who do not have staff reporting to them
--=====we use this table as an exclusion to work out levels 

--=============== #table_1_NoDirectReports

		SELECT E.[employee_id]
		INTO #table_1_NoDirectReports
		FROM [edw].[dim_employee_hierarchy] AS E
		INNER JOIN edw.dim_employee DE
			ON E.employee_id = DE.employee_id
				AND de.dwhiscurrent = 1
				AND DE.DWHDMLOperation <> 'd'
				AND DE.employee_employment_status IN (
					'current staff',
					'exiting staff'
					)
		WHERE E.[DWHIsCurrent] = 1
			AND E.[employee_primary_email_address] IS NOT NULL
			AND NOT EXISTS (
				SELECT 1
				FROM [edw].[dim_employee_hierarchy] AS E2
				WHERE E2.[employee_id] <> E.[employee_id]
					AND (
						E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_1]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_2]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_3]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_4]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_5]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_6]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_7]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_8]
						OR E.[employee_primary_email_address] = E2.[employee_people_leader_email_level_9]
						)
				)

-- =============== #table_2_ServiceTable   
		SELECT service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			CASE 
				WHEN department_name COLLATE Latin1_General_CI_AI = 'Health and Disability Services' COLLATE Latin1_General_CI_AI
					THEN 'Health and Disability Management'
				WHEN department_name COLLATE Latin1_General_CI_AI = 'Health and Disability' COLLATE Latin1_General_CI_AI
					THEN 'Health and Disability Management'
				ELSE department_name
				END AS department_name,
			region_name,
			CASE 
				WHEN dim_company_key = 5
					THEN 'Mind and Body'
				WHEN company_name COLLATE Latin1_General_CI_AI LIKE '%ignite%' COLLATE Latin1_General_CI_AI
					THEN 'Ignite'
				ELSE 'Emerge'
				END AS company,
				is_inactive 
		INTO #table_2_ServiceTable
		FROM edw.dim_service
		WHERE DWHIsCurrent = 1
			AND DWHDMLOperation <> 'd'
			AND service_name COLLATE Latin1_General_CI_AI NOT IN ('tauranga mobile' COLLATE Latin1_General_CI_AI) -- Tauranga isn't missing but I want to change it below.  Easier to union than join

		--===these are missing
		UNION
		SELECT 'Kia Ora Ake' AS service_name,
			'' service_id,
			'' service_code,
			'' dim_service_key,
			1 AS dim_company_key,
			'HD Auckland South Mobile' AS district_name,
			'Health and Disability' AS department_name,
			'RM Counties Manukau/Auckland' AS region_name,
			'Emerge' AS company,
			0 AS is_inactive
		UNION
		SELECT
			--====tauranga mobile hasn't been set up properly, just taking the hierarchy from pounamu - mobile.... 
			'Tauranga Mobile' AS service_name,
			'' service_id,
			'' service_code,
			'' dim_service_key,
			1 AS dim_company_key,
			'HD Waikato/Lakes' AS district_name,
			'Health and Disability' AS department_name,
			'RM Midland' AS region_name,
			'Emerge' AS company,
			0 AS is_inactive

	
-- =============== #table_3a_Employee_Hierarchy as

		SELECT dim_employee_hierarchy.[dim_employee_hierarchy_key],
			dim_employee_hierarchy.[dim_employee_key],
			dim_employee_hierarchy.[employee_id],
			dim_employee_hierarchy.[employee_primary_email_address],
			dim_employee_hierarchy.[employee_company_name],
			[employee_Business_unit_name],
			[employee_displayname],

			CASE 
				WHEN NDR.employee_id IS NOT NULL
					THEN 6 --ie person does not have someone reporting to them
				ELSE CASE 
						WHEN employee_people_leader_business_unit_name_level_9 IS NOT NULL
							AND employee_people_leader_business_unit_name_level_8 IS NOT NULL
							AND employee_people_leader_business_unit_name_level_9 COLLATE Latin1_General_CI_AI = employee_people_leader_business_unit_name_level_8 COLLATE Latin1_General_CI_AI
							AND employee_people_leader_business_unit_name_level_8 COLLATE Latin1_General_CI_AI <> employee_people_leader_business_unit_name_level_7 COLLATE Latin1_General_CI_AI
							THEN 8
						WHEN employee_job_name COLLATE Latin1_General_CI_AI = 'cleaner' COLLATE Latin1_General_CI_AI
							THEN 8
						WHEN employee_people_leader_business_unit_name_level_9 IS NULL
							AND employee_people_leader_business_unit_name_level_8 IS NOT NULL
							THEN 8
						WHEN employee_people_leader_business_unit_name_level_8 IS NULL
							AND employee_people_leader_business_unit_name_level_7 IS NOT NULL
							THEN 7
						WHEN employee_people_leader_business_unit_name_level_7 IS NULL
							AND employee_people_leader_business_unit_name_level_6 IS NOT NULL
							THEN 6
						WHEN employee_people_leader_business_unit_name_level_6 IS NULL
							AND employee_people_leader_business_unit_name_level_5 IS NOT NULL
							THEN 5
						WHEN employee_people_leader_business_unit_name_level_5 IS NULL
							AND employee_people_leader_business_unit_name_level_4 IS NOT NULL
							THEN 4
						WHEN employee_people_leader_business_unit_name_level_4 IS NULL
							AND employee_people_leader_business_unit_name_level_3 IS NOT NULL
							THEN 3
						WHEN employee_people_leader_business_unit_name_level_3 IS NULL
							AND employee_people_leader_business_unit_name_level_2 IS NOT NULL
							THEN 2
						WHEN employee_people_leader_business_unit_name_level_2 IS NULL
							AND employee_people_leader_business_unit_name_level_1 IS NOT NULL
							THEN 1
						END
				END AS hierarchy_number_0,
			employee_employment_status,
			employee_job_name,
			employee_current_status,
			--====working out who the boss is
			CASE 
				WHEN employee_people_leader_employee_number_level_7 = dim_employee.employee_id
					THEN employee_people_leader_employee_number_level_6
				WHEN employee_people_leader_employee_number_level_6 = dim_employee.employee_id
					THEN employee_people_leader_employee_number_level_5
				WHEN employee_people_leader_employee_number_level_5 = dim_employee.employee_id
					THEN employee_people_leader_employee_number_level_4
				WHEN employee_people_leader_employee_number_level_4 = dim_employee.employee_id
					THEN employee_people_leader_employee_number_level_3
				WHEN employee_people_leader_employee_number_level_3 = dim_employee.employee_id
					THEN employee_people_leader_employee_number_level_2
				WHEN employee_people_leader_employee_number_level_2 = dim_employee.employee_id
					THEN employee_people_leader_employee_number_level_1
				END AS bosses_employee_id,
			--splitting up the types of business
			CASE 
				WHEN employee_Business_unit_name LIKE 'tenancy service%'
					OR employee_job_name LIKE '%housing trust%'
					OR (
						employee_job_name IN (
							'Contractor',
							'National Tenancy Operations Manager',
							'Strategic Advisor Housing Trust',
							'General Manager Housing Trust',
							'Housing Programme Manager',
							'Community Development Manager'
							)
						AND employee_business_unit_name = 'national housing management'
						)
					THEN 'Tenancy'
				WHEN employee_business_unit_name = 'property and asset management'
					OR employee_job_name = 'tenancy manager'
					OR employee_job_name = 'Senior Tenancy Manager'
					THEN 'Tenancy'
				WHEN dim_employee.employee_company_name LIKE '%ignite%'
					THEN 'Ignite'
				ELSE 'EAL' -- what EAL means is under Gemma
				END AS Tenancy_Employees
		INTO #table_3a_Employee_Hierarchy
		FROM [edw].[dim_employee_hierarchy]
		INNER JOIN edw.dim_employee
			ON dim_employee_hierarchy.employee_id = dim_employee.employee_id
		LEFT JOIN #table_1_NoDirectReports NDR
			ON NDR.employee_id = dim_employee_hierarchy.employee_id
		WHERE dim_employee.dwhiscurrent = 1
			AND dim_employee_hierarchy.[DWHDMLOperation] <> 'D'
			AND dim_employee_hierarchy.[DWHIsCurrent] = 1
			AND dim_employee_hierarchy.employee_company_name COLLATE Latin1_General_CI_AI NOT IN ('previous business entity' COLLATE Latin1_General_CI_AI) -- removing test data and ignite
			AND dim_employee.[DWHDMLOperation] <> 'D'
			AND dim_employee.[DWHIsCurrent] = 1
			AND employee_employment_status IN (
				'exiting staff',
				'current staff'
				)
			AND dim_employee_hierarchy.employee_primary_email_address NOT LIKE '%demo%intellihr%'
	
	
--===============#table_3b_Employee_Hierarchy 
--===working out the actual hierarchy using job titles - because the levels are different for Ignite, Tenancy, Property etc 

		SELECT *,
			CASE 
				--====workers (7)
				WHEN hierarchy_number_0 IN (
						7,
						8
						)
					THEN 7
						--===the following job titles should get access through 'additional access' spreadsheet
				WHEN hierarchy_number_0 = 2
					AND employee_job_name IN (
						'General Manager Housing Trust',
						'National Director Services',
						'Director Ignite Aotearoa'
						)
					THEN 2
				WHEN employee_job_name IN (
						'group chief financial officer',
						'mana whakahaere',
						'group chief information officer'
						)
					THEN 6
				WHEN hierarchy_number_0 = 2
					AND employee_job_name IN (
						'group director governance',
						'group chief people officer',
						'group director business improvement'
						)
					THEN 5
				WHEN hierarchy_number_0 = 2
					AND employee_job_name LIKE '%group director%'
					THEN 6
				WHEN hierarchy_number_0 = 2
					THEN 7
				WHEN hierarchy_number_0 = 3
					AND employee_job_name IN (
						'National Housing Manager',
						'National Manager Health & Disability',
						'National Practice Manager',
						'National Tenancy Operations Manager'
						)
					THEN 3
				WHEN hierarchy_number_0 = 3
					AND employee_job_name = 'Head of Delivery'
					THEN 6 --making Head of Delivery the equivalent of SM
		
				WHEN hierarchy_number_0 = 3
					AND employee_job_name = 'Regional Asset Portfolio Manager'
					THEN 6 --making Head of Delivery the equivalent of SM

				WHEN hierarchy_number_0 = 3
					THEN 7
						--===Regional Managers 
				WHEN hierarchy_number_0 = 4
					AND employee_job_name LIKE '%housing operations manager%'
					THEN 4
				WHEN hierarchy_number_0 = 4
					AND employee_job_name LIKE '%regional manager%'
					THEN 4
				WHEN hierarchy_number_0 = 4
					AND employee_job_name LIKE '%regional practic%'
					THEN 4
				WHEN hierarchy_number_0 = 4
					AND employee_job_name LIKE '%Operations Manager%Peer Service%'
					THEN 4
						--====some DM's have slipped into the 4's because housing doesn't follow the same patterns
				WHEN hierarchy_number_0 = 4
					AND employee_job_name IN ('team leader - housing services')
					THEN 7
				WHEN hierarchy_number_0 = 4
					AND employee_job_name LIKE 'team leader%tenancy%'
					THEN 6
				WHEN hierarchy_number_0 = 4
					AND employee_job_name LIKE '%team leader%'
					THEN 5
				WHEN hierarchy_number_0 = 4
					THEN 7
						--===District Managers (5)
				WHEN hierarchy_number_0 = 5
					AND employee_job_name LIKE '%district%'
					THEN 5
				WHEN hierarchy_number_0 = 5
					AND employee_job_name = 'Manager'
					THEN 5
				WHEN hierarchy_number_0 = 5
					AND employee_job_name = 'Pasifika Service Delivery Manager'
					THEN 5
				WHEN hierarchy_number_0 = 5
					AND (
						employee_job_name LIKE '%team leader%'
						OR employee_job_name LIKE '%service manager%'
						)
					THEN 6
				WHEN hierarchy_number_0 = 5
					AND employee_job_name LIKE '%Tenancy Manager%'
					THEN 7
				WHEN hierarchy_number_0 = 5
					THEN 7
						--====service managers (6)
				WHEN hierarchy_number_0 = 6
					AND employee_job_name LIKE '%service manager%'
					THEN 6
		
				WHEN hierarchy_number_0 = 6
					THEN 7
				ELSE hierarchy_number_0
				END AS hierarchy_number,
			CASE 
				WHEN employee_primary_email_address COLLATE Latin1_General_CI_AI LIKE '%mind%body%' COLLATE Latin1_General_CI_AI
					THEN 'Mind and Body'
				WHEN employee_primary_email_address COLLATE Latin1_General_CI_AI LIKE '%ignite%' COLLATE Latin1_General_CI_AI
					THEN 'Ignite'
				ELSE 'Emerge'
				END AS company_field --===the company names are inconsistent so I made up my own ones.  Again, sue me.
		INTO #table_3b_Employee_Hierarchy
		FROM #table_3a_Employee_Hierarchy
		WHERE employee_employment_status NOT IN (
				'past staff',
				'future staff'
				)

--==============#table_3c_Employee_Hierarchy_with_Services 
--====now I'm joining the hierarchy to the services

		SELECT 
			'Original' as table_type,
			#table_3b_Employee_Hierarchy.dim_employee_hierarchy_key,
			#table_3b_Employee_Hierarchy.dim_employee_key,
			#table_3b_Employee_Hierarchy.employee_id,
			#table_3b_Employee_Hierarchy.employee_primary_email_address,
			#table_3b_Employee_Hierarchy.employee_company_name,
			#table_3b_Employee_Hierarchy.employee_Business_unit_name,
			#table_3b_Employee_Hierarchy.employee_displayname,
			#table_3b_Employee_Hierarchy.hierarchy_number_0,
			#table_3b_Employee_Hierarchy.employee_employment_status,
			#table_3b_Employee_Hierarchy.employee_job_name,
			#table_3b_Employee_Hierarchy.employee_current_status,
			#table_3b_Employee_Hierarchy.hierarchy_number,
			#table_3b_Employee_Hierarchy.company_field,
			#table_3b_Employee_Hierarchy.Tenancy_Employees,
			#table_2_ServiceTable.service_name,
			#table_2_ServiceTable.service_id,
			#table_2_ServiceTable.service_code,
			#table_2_ServiceTable.dim_service_key,
			#table_2_ServiceTable.dim_company_key
			---=====hard coding  - there is no other way as district = default which is as useful as....
			,
			CASE 
				WHEN employee_id = 601556
					THEN 'HD Easeup Services'
				ELSE #table_2_ServiceTable.district_name
				END AS district_name
			---==========================
			,
			#table_2_ServiceTable.department_name,
			#table_2_ServiceTable.region_name,
			#table_2_ServiceTable.company,
			#table_3b_Employee_Hierarchy.bosses_employee_id
		INTO #table_3c_Employee_Hierarchy_with_Services
		FROM #table_3b_Employee_Hierarchy
		LEFT JOIN #table_2_ServiceTable
			ON employee_Business_unit_name COLLATE Latin1_General_CI_AI = service_name COLLATE Latin1_General_CI_AI
				AND #table_3b_Employee_Hierarchy.company_field COLLATE Latin1_General_CI_AI = #table_2_ServiceTable.company COLLATE Latin1_General_CI_AI


--=========table_4_cost_allocations 
--=========cost allocations for staff


		SELECT DISTINCT 'cost allocation' AS table_type,
			employee_number,
			displayName,
			dim_employee_key,
			email_address,
			job_title,
			datapay_cost_center_name,
			intellihr_business_unit_name,
			person_is_supervisor,
			#table_2_ServiceTable.service_name,
			#table_2_ServiceTable.service_id,
			#table_2_ServiceTable.service_code,
			#table_2_ServiceTable.dim_service_key,
			#table_2_ServiceTable.dim_company_key,
			#table_2_ServiceTable.region_name,
			#table_2_ServiceTable.district_name,
			#table_2_ServiceTable.department_name,
			CASE 
				WHEN email_address LIKE '%mind%body%'
					THEN 'Mind and Body'
				WHEN email_address LIKE '%ignite%'
					THEN 'Ignite'
				ELSE 'Emerge'
				END AS Company,
			employee_job_name,
			CASE 
				WHEN job_title LIKE '%regional manager%'
					THEN 4
				WHEN job_title LIKE '%district manager%'
					THEN 5
				WHEN job_title LIKE '%service manager%'
					OR job_title LIKE '%team leader%housing%'
					THEN 6
				ELSE 7
				END AS hierarchy_number,
			CASE 
				WHEN intellihr_business_unit_name LIKE 'tenancy service%'
					OR intellihr_job_title LIKE '%housing trust%'
					OR (
						employee_job_name IN (
							'Contractor',
							'National Tenancy Operations Manager',
							'Strategic Advisor Housing Trust',
							'General Manager Housing Trust',
							'Housing Programme Manager',
							'Community Development Manager'
							)
						AND intellihr_business_unit_name = 'national housing management'
						)
					THEN 'Tenancy'
				WHEN intellihr_business_unit_name = 'property and asset management'
					OR intellihr_job_title = 'tenancy manager'
					THEN 'Tenancy'
				WHEN dim_employee.employee_company_name LIKE '%ignite%'
					THEN 'Ignite'
				ELSE 'EAL' -- what EAL means is under Gemma
				END AS RLS_Tenancy_Employees,
				case when row_level_security_cost_allocations.intellihr_bc_code = 'cm awhi ora' and intellihr_job_title = 'service manager'
					then (select 
					distinct employee_id
					from edw.dim_employee_hierarchy 
					where dwhiscurrent = 1 and dwhdmloperation <> 'd'
					--and employee_displayname like 'selwyn t%'
					and employee_Business_unit_name = 'auckland south mobile district'
					and employee_people_leader_role_name_level_6 is null 
					and employee_people_leader_role_name_level_5 = 'district manager')
				else bosses_employee_id
				end as bosses_employee_id
		INTO #table_4_cost_allocations
		FROM [landing].[row_level_security_cost_allocations]
		LEFT JOIN #table_2_ServiceTable
			ON row_level_security_cost_allocations.intellihr_business_unit_name COLLATE Latin1_General_CI_AI = #table_2_ServiceTable.service_name COLLATE Latin1_General_CI_AI
		LEFT JOIN edw.dim_employee
			ON row_level_security_cost_allocations.employee_number = dim_employee.employee_id
				AND dim_employee.DWHIsCurrent = 1
				AND dim_employee.DWHDMLOperation <> 'd'
		left join (select distinct employee_id, bosses_employee_id from #table_3c_Employee_Hierarchy_with_Services
		) as employee_boss
			ON row_level_security_cost_allocations.employee_number =employee_boss.employee_id

-- ================#table_3d_Hierarchy_Level_1_Cross_Join_CEO 
--making CEO level 7 because not all services have staff but CEO should see them all
		SELECT 
			'Original' as table_type,
			dim_employee_hierarchy_key,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_company_name,
			employee_Business_unit_name,
			employee_displayname,
			hierarchy_number_0,
			employee_employment_status,
			employee_job_name,
			employee_current_status,
			7 AS hierarchy_number --making CEO level 7 
			,
			company_field,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			bosses_employee_id,
			Tenancy_Employees
		INTO #table_3d_Hierarchy_Level_1_Cross_Join_CEO
		FROM #table_3c_Employee_Hierarchy_with_Services
		WHERE hierarchy_number = 1

--============================#table_3e_Hierarchy_Level_Cross_Join_Result 
		SELECT
			--cross join CEO to every service 
			'Original' as table_type,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.dim_employee_hierarchy_key,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.dim_employee_key,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_id,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_primary_email_address,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_company_name,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_Business_unit_name,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_displayname,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.hierarchy_number_0,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_employment_status,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_job_name,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.employee_current_status,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.hierarchy_number,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.company_field,
			#table_3d_Hierarchy_Level_1_Cross_Join_CEO.Tenancy_Employees,
			#table_2_ServiceTable.service_name,
			#table_2_ServiceTable.service_id,
			#table_2_ServiceTable.service_code,
			#table_2_ServiceTable.dim_service_key,
			#table_2_ServiceTable.dim_company_key,
			#table_2_ServiceTable.district_name,
			#table_2_ServiceTable.department_name,
			#table_2_ServiceTable.region_name,
			#table_2_ServiceTable.company,
			'' AS bosses_employee_id

		INTO #table_3e_Hierarchy_Level_Cross_Join_Result
		FROM #table_3d_Hierarchy_Level_1_Cross_Join_CEO
		CROSS JOIN #table_2_ServiceTable

-- ==================================#table_3_Final_Hierarchy_with_Services as (
		SELECT *
		INTO #table_3_Final_Hierarchy_with_Services
		FROM #table_3c_Employee_Hierarchy_with_Services
		UNION
		--bring CEO and all their services into the Hierarchy with services.


		SELECT *
		FROM #table_3e_Hierarchy_Level_Cross_Join_Result-- ======================#table_5_level_1_CEO 
		SELECT 
			table_type,
			hierarchy_number,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company_field AS company,
			dim_company_key,
			Tenancy_Employees
		INTO #table_5_level_1_CEO
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE hierarchy_number = 1
			AND
			--this is already taken care of above, but will keep this piece of code in anyway
			employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI)

		
-- =======================#table_5_level_2_Exec as (
		SELECT 
			table_type,
			hierarchy_number,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company_field AS company,
			dim_company_key,
			Tenancy_Employees,
			bosses_employee_id
		INTO #table_5_level_2_Exec
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 2
	
-- ===================#table_5_level_3_National_Managers 
		SELECT
			table_type,
			hierarchy_number,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company_field AS company,
			dim_company_key,
			Tenancy_Employees,
			bosses_employee_id
		INTO #table_5_level_3_National_Managers
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 3

-- =================================#table_5_level_4_Regional_Managers
		SELECT 
			table_type,
			hierarchy_number,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company_field AS company,
			dim_company_key,
			Tenancy_Employees,
			bosses_employee_id
		INTO #table_5_level_4_Regional_Managers
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 4
		UNION  --cost allocation
		SELECT 
			table_type,
			49 AS hierarchy_number,
			dim_employee_key,
			employee_number AS employee_id,
			email_address AS employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company,
			dim_company_key,
			RLS_Tenancy_Employees,
			bosses_employee_id
		FROM #table_4_cost_allocations
		WHERE hierarchy_number = 4

-- ======================== #table_5_level_5_District_Managers
		SELECT 
			table_type,
			hierarchy_number,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company_field AS company,
			dim_company_key,
			Tenancy_Employees,
			bosses_employee_id
		INTO #table_5_level_5_District_Managers
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 5

		UNION  --cost allocations
		SELECT 
			table_type,
			59 AS hierarchy_number,
			dim_employee_key,
			employee_number AS employee_id,
			email_address AS employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company,
			dim_company_key,
			RLS_Tenancy_Employees,
			bosses_employee_id
		FROM #table_4_cost_allocations
		WHERE hierarchy_number = 5

--===========================table_5_level_6_SMs_TL Service Managers, Team Leaders etc
		SELECT 
			table_type,
			hierarchy_number,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company_field AS company,
			dim_company_key,
			Tenancy_Employees,
			bosses_employee_id
		INTO #table_5_level_6_SMs_TL
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 6
	
		UNION  --====cost allocations
		SELECT 
			table_type,
			96 AS hierarchy_number,
			dim_employee_key,
			employee_number AS employee_id,
			email_address AS employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company,
			dim_company_key,
			RLS_Tenancy_Employees,
			bosses_employee_id
		FROM #table_4_cost_allocations
		WHERE hierarchy_number = 6

--==============================#table_5_level_7_Non_Charge_Employees 
		SELECT 
			table_type,
			hierarchy_number,
			dim_employee_key,
			employee_id,
			employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company_field AS company,
			dim_company_key,
			bosses_employee_id,
			Tenancy_Employees
		INTO #table_5_level_7_Non_Charge_Employees
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 7
		UNION  --============cost allocation
		SELECT 
			table_type,
			97 AS hierarchy_number,
			dim_employee_key,
			employee_number AS employee_id,
			email_address AS employee_primary_email_address,
			employee_job_name,
			service_name,
			dim_service_key,
			service_id,
			service_code,
			department_name,
			district_name,
			region_name,
			company,
			dim_company_key,
			'' AS bosses_employee_id,
			RLS_Tenancy_Employees
		FROM #table_4_cost_allocations
		WHERE hierarchy_number = 7




--=========================================================
--==== Part 3 -- bringing everything together
--==========================================================


--========================table_6_level_7_and_6 connecting level 7 to level 6


		SELECT DISTINCT
			#table_5_level_7_Non_Charge_Employees.table_type,
			#table_5_level_7_Non_Charge_Employees.hierarchy_number,
			#table_5_level_7_Non_Charge_Employees.dim_employee_key,
			#table_5_level_7_Non_Charge_Employees.employee_id,
			#table_5_level_7_Non_Charge_Employees.employee_primary_email_address,
			#table_5_level_7_Non_Charge_Employees.employee_job_name,
			#table_5_level_7_Non_Charge_Employees.Tenancy_Employees,
			#table_5_level_7_Non_Charge_Employees.service_name,
			#table_5_level_7_Non_Charge_Employees.dim_service_key,
			#table_5_level_7_Non_Charge_Employees.service_id,
			#table_5_level_7_Non_Charge_Employees.service_code,
			#table_5_level_7_Non_Charge_Employees.department_name,
			#table_5_level_7_Non_Charge_Employees.district_name,
			#table_5_level_7_Non_Charge_Employees.region_name,
			#table_5_level_7_Non_Charge_Employees.company,
			#table_5_level_7_Non_Charge_Employees.bosses_employee_id
		INTO #table_6_level_7_and_6
		FROM #table_5_level_7_Non_Charge_Employees  --====starting with all level 7s - non charge employees
		UNION
		--====take all the level 6's with their services
		SELECT DISTINCT 
			#table_5_level_6_SMs_TL.table_type,
			#table_5_level_6_SMs_TL.hierarchy_number,
			#table_5_level_6_SMs_TL.dim_employee_key,
			#table_5_level_6_SMs_TL.employee_id,
			#table_5_level_6_SMs_TL.employee_primary_email_address,
			#table_5_level_6_SMs_TL.employee_job_name,
			#table_5_level_6_SMs_TL.Tenancy_Employees,
			#table_5_level_6_SMs_TL.service_name,
			#table_5_level_6_SMs_TL.dim_service_key,
			#table_5_level_6_SMs_TL.service_id,
			#table_5_level_6_SMs_TL.service_code,
			#table_5_level_6_SMs_TL.department_name,
			#table_5_level_6_SMs_TL.district_name,
			#table_5_level_6_SMs_TL.region_name,
			#table_5_level_6_SMs_TL.company,
			#table_5_level_6_SMs_TL.bosses_employee_id
		FROM #table_5_level_6_SMs_TL

		UNION
		---======take the level 6 employees and join to level 7 via boss' employee_id, and take the level 7 services
		SELECT DISTINCT 
			'Hierarchy' as table_type,
			6 AS hierarchy_number,
			#table_5_level_6_SMs_TL.dim_employee_key,
			#table_5_level_6_SMs_TL.employee_id,
			#table_5_level_6_SMs_TL.employee_primary_email_address,
			#table_5_level_6_SMs_TL.employee_job_name,
			#table_5_level_6_SMs_TL.Tenancy_Employees,
			#table_5_level_7_Non_Charge_Employees.service_name,
			#table_5_level_7_Non_Charge_Employees.dim_service_key,
			#table_5_level_7_Non_Charge_Employees.service_id,
			#table_5_level_7_Non_Charge_Employees.service_code,
			#table_5_level_7_Non_Charge_Employees.department_name,
			#table_5_level_7_Non_Charge_Employees.district_name,
			#table_5_level_7_Non_Charge_Employees.region_name,
			#table_5_level_7_Non_Charge_Employees.company,
			#table_5_level_6_SMs_TL.bosses_employee_id
		FROM #table_5_level_7_Non_Charge_Employees
		INNER JOIN #table_5_level_6_SMs_TL
			ON #table_5_level_7_Non_Charge_Employees.bosses_employee_id = #table_5_level_6_SMs_TL.employee_id

--====bringing in district manager's
--==================#table_6_level_7_and_6_and_5 

		SELECT 
			#table_6_level_7_and_6.table_type,
			hierarchy_number,
			#table_6_level_7_and_6.dim_employee_key,
			#table_6_level_7_and_6.employee_id,
			#table_6_level_7_and_6.employee_primary_email_address,
			#table_6_level_7_and_6.employee_job_name,
			#table_6_level_7_and_6.Tenancy_Employees,
			#table_6_level_7_and_6.service_name,
			#table_6_level_7_and_6.dim_service_key,
			#table_6_level_7_and_6.service_id,
			#table_6_level_7_and_6.service_code,
			#table_6_level_7_and_6.department_name,
			#table_6_level_7_and_6.district_name,
			#table_6_level_7_and_6.region_name,
			#table_6_level_7_and_6.company,
			#table_6_level_7_and_6.bosses_employee_id
			INTO #table_6_level_7_and_6_and_5
			FROM #table_6_level_7_and_6
	
			UNION  --====bosses to service
		SELECT DISTINCT 
			'Hierarchy' as table_type,
			6 AS hierarchy_number,
			#table_5_level_5_District_Managers.dim_employee_key,
			#table_5_level_5_District_Managers.employee_id,
			#table_5_level_5_District_Managers.employee_primary_email_address,
			#table_5_level_5_District_Managers.employee_job_name,
			#table_5_level_5_District_Managers.Tenancy_Employees,
			#table_5_level_6_SMs_TL.service_name,
			#table_5_level_6_SMs_TL.dim_service_key,
			#table_5_level_6_SMs_TL.service_id,
			#table_5_level_6_SMs_TL.service_code,
			#table_5_level_6_SMs_TL.department_name,
			#table_5_level_6_SMs_TL.district_name,
			#table_5_level_6_SMs_TL.region_name,
			#table_5_level_6_SMs_TL.company,
			#table_5_level_5_District_Managers.bosses_employee_id
		FROM  #table_5_level_5_District_Managers
		INNER JOIN #table_5_level_6_SMs_TL 
			ON #table_5_level_6_SMs_TL.bosses_employee_id = #table_5_level_5_District_Managers.employee_id
			--and #table_5_level_6_SMs_TL.table_type not in ('additonal access')
		union 
		SELECT DISTINCT
			'District' as table_type,
			#table_5_level_5_District_Managers.hierarchy_number,
			#table_5_level_5_District_Managers.dim_employee_key,
			#table_5_level_5_District_Managers.employee_id,
			#table_5_level_5_District_Managers.employee_primary_email_address,
			#table_5_level_5_District_Managers.employee_job_name,
			#table_5_level_5_District_Managers.Tenancy_Employees,
			#table_6_level_7_and_6.service_name,
			#table_6_level_7_and_6.dim_service_key,
			#table_6_level_7_and_6.service_id,
			#table_6_level_7_and_6.service_code,
			#table_6_level_7_and_6.department_name,
			#table_6_level_7_and_6.district_name,
			#table_6_level_7_and_6.region_name,
			#table_6_level_7_and_6.company,
			#table_5_level_5_District_Managers.bosses_employee_id
		FROM #table_5_level_5_District_Managers
		LEFT JOIN #table_6_level_7_and_6
			ON #table_5_level_5_District_Managers.district_name = #table_6_level_7_and_6.district_name
		WHERE #table_5_level_5_District_Managers.Tenancy_Employees = 'eal'
			AND #table_6_level_7_and_6.tenancy_employees = 'eal'
			AND #table_6_level_7_and_6.department_name <> 'owned property'
			AND #table_5_level_5_District_Managers.district_name <> 'default'
			AND #table_6_level_7_and_6.district_name <> 'default'

		UNION
		SELECT DISTINCT 
			'Region and Dept' as table_type,
			#table_5_level_5_District_Managers.hierarchy_number,
			#table_5_level_5_District_Managers.dim_employee_key,
			#table_5_level_5_District_Managers.employee_id,
			#table_5_level_5_District_Managers.employee_primary_email_address,
			#table_5_level_5_District_Managers.employee_job_name,
			#table_5_level_5_District_Managers.Tenancy_Employees,
			#table_6_level_7_and_6.service_name,
			#table_6_level_7_and_6.dim_service_key,
			#table_6_level_7_and_6.service_id,
			#table_6_level_7_and_6.service_code,
			#table_6_level_7_and_6.department_name,
			#table_6_level_7_and_6.district_name,
			#table_6_level_7_and_6.region_name,
			#table_6_level_7_and_6.company,
			#table_5_level_5_District_Managers.bosses_employee_id
		FROM #table_5_level_5_District_Managers
		LEFT JOIN #table_6_level_7_and_6
			ON #table_5_level_5_District_Managers.region_name = #table_6_level_7_and_6.region_name
				AND #table_5_level_5_District_Managers.department_name = #table_6_level_7_and_6.department_name
		WHERE #table_5_level_5_District_Managers.Tenancy_Employees = 'eal'
			AND #table_6_level_7_and_6.tenancy_employees = 'eal'
			AND #table_6_level_7_and_6.department_name <> 'owned property'
			AND #table_5_level_5_District_Managers.district_name = 'default'
			AND #table_6_level_7_and_6.district_name = 'default'
	
		UNION
		SELECT DISTINCT 
			#table_5_level_5_District_Managers.table_type,
			#table_5_level_5_District_Managers.hierarchy_number,
			#table_5_level_5_District_Managers.dim_employee_key,
			#table_5_level_5_District_Managers.employee_id,
			#table_5_level_5_District_Managers.employee_primary_email_address,
			#table_5_level_5_District_Managers.employee_job_name,
			#table_5_level_5_District_Managers.Tenancy_Employees,
			#table_6_level_7_and_6.service_name,
			#table_6_level_7_and_6.dim_service_key,
			#table_6_level_7_and_6.service_id,
			#table_6_level_7_and_6.service_code,
			#table_6_level_7_and_6.department_name,
			#table_6_level_7_and_6.district_name,
			#table_6_level_7_and_6.region_name,
			#table_6_level_7_and_6.company,
			#table_5_level_5_District_Managers.bosses_employee_id
		FROM #table_5_level_5_District_Managers
		INNER JOIN #table_6_level_7_and_6
			ON #table_5_level_5_District_Managers.district_name = #table_6_level_7_and_6.district_name
		WHERE #table_5_level_5_District_Managers.Tenancy_Employees = 'tenancy'
			AND #table_6_level_7_and_6.tenancy_employees = 'tenancy'

--=================================#table_6_level_7_and_6_and_5_and_4
--- adding in regional managers 
		SELECT *
		INTO #table_6_level_7_and_6_and_5_and_4
		FROM #table_6_level_7_and_6_and_5
		UNION
		SELECT DISTINCT 
			#table_5_level_4_Regional_Managers.table_type,
			#table_5_level_4_Regional_Managers.hierarchy_number,
			#table_5_level_4_Regional_Managers.dim_employee_key,
			#table_5_level_4_Regional_Managers.employee_id,
			#table_5_level_4_Regional_Managers.employee_primary_email_address,
			#table_5_level_4_Regional_Managers.employee_job_name,
			#table_5_level_4_Regional_Managers.Tenancy_Employees,
			#table_6_level_7_and_6_and_5.service_name,
			#table_6_level_7_and_6_and_5.dim_service_key,
			#table_6_level_7_and_6_and_5.service_id,
			#table_6_level_7_and_6_and_5.service_code,
			#table_6_level_7_and_6_and_5.department_name,
			#table_6_level_7_and_6_and_5.district_name,
			#table_6_level_7_and_6_and_5.region_name,
			#table_6_level_7_and_6_and_5.company,
			#table_5_level_4_Regional_Managers.bosses_employee_id
		FROM #table_5_level_4_Regional_Managers
		INNER JOIN #table_6_level_7_and_6_and_5
			ON #table_5_level_4_Regional_Managers.region_name = #table_6_level_7_and_6_and_5.region_name
		WHERE #table_5_level_4_Regional_Managers.Tenancy_Employees = 'eal'
			AND #table_6_level_7_and_6_and_5.tenancy_employees = 'eal'
			AND #table_6_level_7_and_6_and_5.department_name <> 'owned property'

		UNION
		SELECT DISTINCT 
			#table_5_level_4_Regional_Managers.table_type,
			#table_5_level_4_Regional_Managers.hierarchy_number,
			#table_5_level_4_Regional_Managers.dim_employee_key,
			#table_5_level_4_Regional_Managers.employee_id,
			#table_5_level_4_Regional_Managers.employee_primary_email_address,
			#table_5_level_4_Regional_Managers.employee_job_name,
			#table_5_level_4_Regional_Managers.Tenancy_Employees,
			#table_6_level_7_and_6_and_5.service_name,
			#table_6_level_7_and_6_and_5.dim_service_key,
			#table_6_level_7_and_6_and_5.service_id,
			#table_6_level_7_and_6_and_5.service_code,
			#table_6_level_7_and_6_and_5.department_name,
			#table_6_level_7_and_6_and_5.district_name,
			#table_6_level_7_and_6_and_5.region_name,
			#table_6_level_7_and_6_and_5.company,
			#table_5_level_4_Regional_Managers.bosses_employee_id
		FROM #table_5_level_4_Regional_Managers
		cross JOIN #table_6_level_7_and_6_and_5
	
		WHERE #table_5_level_4_Regional_Managers.region_name = 'HD Peer Services' and #table_6_level_7_and_6_and_5.region_name ='Mind and Body'


		UNION
		SELECT DISTINCT 
			#table_5_level_4_Regional_Managers.TABLE_TYPE,
			#table_5_level_4_Regional_Managers.hierarchy_number,
			#table_5_level_4_Regional_Managers.dim_employee_key,
			#table_5_level_4_Regional_Managers.employee_id,
			#table_5_level_4_Regional_Managers.employee_primary_email_address,
			#table_5_level_4_Regional_Managers.employee_job_name,
			#table_5_level_4_Regional_Managers.Tenancy_Employees,
			#table_6_level_7_and_6_and_5.service_name,
			#table_6_level_7_and_6_and_5.dim_service_key,
			#table_6_level_7_and_6_and_5.service_id,
			#table_6_level_7_and_6_and_5.service_code,
			#table_6_level_7_and_6_and_5.department_name,
			#table_6_level_7_and_6_and_5.district_name,
			#table_6_level_7_and_6_and_5.region_name,
			#table_6_level_7_and_6_and_5.company,
			#table_5_level_4_Regional_Managers.bosses_employee_id
		FROM #table_5_level_4_Regional_Managers
		INNER JOIN #table_6_level_7_and_6_and_5
			ON #table_5_level_4_Regional_Managers.region_name = #table_6_level_7_and_6_and_5.region_name
		WHERE #table_5_level_4_Regional_Managers.Tenancy_Employees = 'tenancy'
			AND #table_6_level_7_and_6_and_5.tenancy_employees = 'tenancy'

--=====================================#table_6_level_7_and_6_and_5_and_4_and_3
		SELECT *
		INTO #table_6_level_7_and_6_and_5_and_4_and_3
		FROM #table_6_level_7_and_6_and_5_and_4

		UNION
		--==== Health and Disability
		SELECT DISTINCT 
			#table_5_level_3_National_Managers.table_type,
			#table_5_level_3_National_Managers.hierarchy_number,
			#table_5_level_3_National_Managers.dim_employee_key,
			#table_5_level_3_National_Managers.employee_id,
			#table_5_level_3_National_Managers.employee_primary_email_address,
			#table_5_level_3_National_Managers.employee_job_name,
			#table_5_level_3_National_Managers.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4.service_name,
			#table_6_level_7_and_6_and_5_and_4.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4.service_id,
			#table_6_level_7_and_6_and_5_and_4.service_code,
			#table_6_level_7_and_6_and_5_and_4.department_name,
			#table_6_level_7_and_6_and_5_and_4.district_name,
			#table_6_level_7_and_6_and_5_and_4.region_name,
			#table_6_level_7_and_6_and_5_and_4.company,
			#table_5_level_3_National_Managers.bosses_employee_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE #table_5_level_3_National_Managers.Tenancy_Employees = 'eal'
			AND #table_6_level_7_and_6_and_5_and_4.tenancy_employees = 'eal'
			AND #table_5_level_3_National_Managers.service_name LIKE 'health and disab%'
			AND #table_6_level_7_and_6_and_5_and_4.region_name NOT LIKE 'housing%'
			AND #table_6_level_7_and_6_and_5_and_4.region_name NOT LIKE 'tenanncy%'
			AND #table_6_level_7_and_6_and_5_and_4.region_name NOT LIKE 'tenancy%'
			AND #table_6_level_7_and_6_and_5_and_4.department_name IN (
				'Peer Support',
				'Peer Support Services',
				'Health and Disability Management'
				)
		
		UNION
		--====tenancy
		SELECT DISTINCT 
			#table_5_level_3_National_Managers.table_type,
			#table_5_level_3_National_Managers.hierarchy_number,
			#table_5_level_3_National_Managers.dim_employee_key,
			#table_5_level_3_National_Managers.employee_id,
			#table_5_level_3_National_Managers.employee_primary_email_address,
			#table_5_level_3_National_Managers.employee_job_name,
			#table_5_level_3_National_Managers.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4.service_name,
			#table_6_level_7_and_6_and_5_and_4.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4.service_id,
			#table_6_level_7_and_6_and_5_and_4.service_code,
			#table_6_level_7_and_6_and_5_and_4.department_name,
			#table_6_level_7_and_6_and_5_and_4.district_name,
			#table_6_level_7_and_6_and_5_and_4.region_name,
			#table_6_level_7_and_6_and_5_and_4.company,
			#table_5_level_3_National_Managers.bosses_employee_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE #table_5_level_3_National_Managers.Tenancy_Employees = 'tenancy'
			AND #table_6_level_7_and_6_and_5_and_4.tenancy_employees = 'tenancy'

		UNION
		--===housing 
		SELECT DISTINCT 
			#table_5_level_3_National_Managers.table_type,
			#table_5_level_3_National_Managers.hierarchy_number,
			#table_5_level_3_National_Managers.dim_employee_key,
			#table_5_level_3_National_Managers.employee_id,
			#table_5_level_3_National_Managers.employee_primary_email_address,
			#table_5_level_3_National_Managers.employee_job_name,
			#table_5_level_3_National_Managers.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4.service_name,
			#table_6_level_7_and_6_and_5_and_4.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4.service_id,
			#table_6_level_7_and_6_and_5_and_4.service_code,
			#table_6_level_7_and_6_and_5_and_4.department_name,
			#table_6_level_7_and_6_and_5_and_4.district_name,
			#table_6_level_7_and_6_and_5_and_4.region_name,
			#table_6_level_7_and_6_and_5_and_4.company,
			#table_5_level_3_National_Managers.bosses_employee_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE #table_5_level_3_National_Managers.Tenancy_Employees = 'eal'
			AND #table_6_level_7_and_6_and_5_and_4.tenancy_employees = 'eal'
			AND #table_5_level_3_National_Managers.service_name LIKE '%national housing%'
			AND #table_5_level_3_National_Managers.employee_job_name IN ('national housing manager')
			AND #table_6_level_7_and_6_and_5_and_4.region_name LIKE 'housing%'
			AND #table_6_level_7_and_6_and_5_and_4.region_name NOT LIKE 'tenanncy%'
			AND #table_6_level_7_and_6_and_5_and_4.region_name NOT LIKE 'tenancy%'
			AND #table_6_level_7_and_6_and_5_and_4.department_name NOT IN (
				'Peer Support',
				'Peer Support Services',
				'Health and Disability Management'
				)

--==================================#table_6_level_7_and_6_and_5_and_4_and_3_and_2
--=============adding in level 2 
		
		SELECT *
		INTO #table_6_level_7_and_6_and_5_and_4_and_3_and_2
		FROM #table_6_level_7_and_6_and_5_and_4_and_3

		UNION
		--=== tenancy/property
		SELECT 
			#table_5_level_2_Exec.table_type,
			#table_5_level_2_Exec.hierarchy_number,
			#table_5_level_2_Exec.dim_employee_key,
			#table_5_level_2_Exec.employee_id,
			#table_5_level_2_Exec.employee_primary_email_address,
			#table_5_level_2_Exec.employee_job_name,
			#table_5_level_2_Exec.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_code,
			#table_6_level_7_and_6_and_5_and_4_and_3.department_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.district_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.region_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.company,
			#table_5_level_2_Exec.bosses_employee_id
			FROM #table_6_level_7_and_6_and_5_and_4_and_3
		CROSS JOIN #table_5_level_2_Exec
		WHERE #table_6_level_7_and_6_and_5_and_4_and_3.Tenancy_Employees IN (
				'tenancy',
				'property'
				)
			AND #table_5_level_2_Exec.Tenancy_Employees IN (
				'tenancy',
				'property'
				)
		UNION
		SELECT 
			#table_5_level_2_Exec.table_type,
			#table_5_level_2_Exec.hierarchy_number,
			#table_5_level_2_Exec.dim_employee_key,
			#table_5_level_2_Exec.employee_id,
			#table_5_level_2_Exec.employee_primary_email_address,
			#table_5_level_2_Exec.employee_job_name,
			#table_5_level_2_Exec.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_code,
			#table_6_level_7_and_6_and_5_and_4_and_3.department_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.district_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.region_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.company,
			#table_5_level_2_Exec.bosses_employee_id
		FROM #table_6_level_7_and_6_and_5_and_4_and_3
		CROSS JOIN #table_5_level_2_Exec
		WHERE #table_6_level_7_and_6_and_5_and_4_and_3.Tenancy_Employees IN ('ignite')
			AND #table_5_level_2_Exec.Tenancy_Employees IN ('ignite')
		UNION
		SELECT 
			#table_5_level_2_Exec.table_type,
			#table_5_level_2_Exec.hierarchy_number,
			#table_5_level_2_Exec.dim_employee_key,
			#table_5_level_2_Exec.employee_id,
			#table_5_level_2_Exec.employee_primary_email_address,
			#table_5_level_2_Exec.employee_job_name,
			#table_5_level_2_Exec.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.service_code,
			#table_6_level_7_and_6_and_5_and_4_and_3.department_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.district_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.region_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.company,
			#table_5_level_2_Exec.bosses_employee_id
		FROM #table_6_level_7_and_6_and_5_and_4_and_3
		CROSS JOIN #table_5_level_2_Exec
		WHERE #table_6_level_7_and_6_and_5_and_4_and_3.Tenancy_Employees NOT IN (
				'ignite',
				'property',
				'tenancy'
				)
			AND #table_5_level_2_Exec.Tenancy_Employees NOT IN (
				'ignite',
				'property',
				'tenancy'
				)
			AND #table_6_level_7_and_6_and_5_and_4_and_3.department_name NOT IN ('shared services')
			AND #table_6_level_7_and_6_and_5_and_4_and_3.department_name IN (
				'health and disability management',
				'housing services',
				'peer support',
				'peer support services'
				)
		
--=====================================#table_6_final
--==============CEO all
		SELECT DISTINCT 
			#table_5_level_1_CEO.table_type,
			#table_5_level_1_CEO.dim_employee_key,
			#table_5_level_1_CEO.employee_id,
			#table_5_level_1_CEO.employee_primary_email_address,
			#table_5_level_1_CEO.employee_job_name,
			#table_5_level_1_CEO.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.service_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.service_id,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.service_code,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.department_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.district_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.region_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.company,
			9999999 as bosses_employee_id
		INTO #table_6_final
		FROM #table_6_level_7_and_6_and_5_and_4_and_3_and_2
		CROSS JOIN #table_5_level_1_CEO
		UNION
		SELECT DISTINCT 
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.table_type,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.dim_employee_key,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.employee_id,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.employee_primary_email_address,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.employee_job_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.Tenancy_Employees,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.service_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.dim_service_key,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.service_id,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.service_code,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.department_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.district_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.region_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.company,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.bosses_employee_id
		FROM #table_6_level_7_and_6_and_5_and_4_and_3_and_2

		--================================#final_table_record_base
		--the reason this is here is because DMs quite often have services that aren't in their district
		--I'm using the hierarchy to determine this, and then I take the services away from the DM where BC says they belong.

		SELECT DISTINCT 'Record Base District' AS RLS_Type,
			#table_6_final.table_type,
			#table_6_final.dim_employee_key,
			#table_6_final.employee_id,
			#table_6_final.employee_primary_email_address,
			#table_6_final.employee_job_name,
			#table_6_final.service_name,
			#table_6_final.dim_service_key,
			#table_6_final.service_id,
			#table_6_final.service_code,
			#table_6_final.department_name,
			#table_6_final.district_name,
			#table_6_final.region_name,
			#table_6_final.company,
			#table_6_final.bosses_employee_id,
			dim_client_team.client_team_id,
			dim_client_team.client_team_name
		into #table_7_District
		FROM #table_6_final
		LEFT JOIN edw.dim_client_team
			ON #table_6_final.service_code = dim_client_team.service_id
			and dim_client_team.DWHDMLOperation <> 'd'
			AND dim_client_team.dim_client_team_end_date IS NULL
			AND dim_client_team.dim_service_Key NOT IN (
				0,
				- 1,
				- 2,
				- 3
				)
		where
		 employee_job_name like 'district man%' 
		order by employee_primary_email_address, service_name

		--=== adding in ranking so hierarchy is higher than District

		select 
		row_number () over (partition by  service_id, client_team_id 
		order by  service_id, client_team_id, table_type desc) as emp_service_ranking,
		*
		into #table_7a_district
		from #table_7_district 

		order by 3,4,1

		--====Removing the extras 

		select * 
		into #table_7_final_district 
		from #table_7a_district
		where emp_service_ranking = 1 
		order by employee_primary_email_address


--====================final record base RLS

		SELECT DISTINCT 
			'Record Base' AS RLS_Type,
			--#table_6_final.table_type,
			#table_6_final.dim_employee_key,
			#table_6_final.employee_id,
			#table_6_final.employee_primary_email_address,
			#table_6_final.employee_job_name,
			#table_6_final.service_name,
			#table_6_final.dim_service_key,
			#table_6_final.service_id,
			#table_6_final.service_code,
			#table_6_final.department_name,
			#table_6_final.district_name,
			#table_6_final.region_name,
			#table_6_final.company,
			#table_6_final.bosses_employee_id,
			dim_client_team.client_team_id,
			dim_client_team.client_team_name
			into #table_6_final_all
			FROM #table_6_final
		LEFT JOIN edw.dim_client_team
			ON #table_6_final.service_code = dim_client_team.service_id
			and dim_client_team.DWHDMLOperation <> 'd'
			AND dim_client_team.dim_client_team_end_date IS NULL
			AND dim_client_team.dim_service_Key NOT IN (
				0,
				- 1,
				- 2,
				- 3
				)
			where  employee_job_name not like 'district manager%'
			union 
		 select 
		 'Record Base ' AS RLS_Type,
			--#table_7_final_district.table_type,
			#table_7_final_district.dim_employee_key,
			#table_7_final_district.employee_id,
			#table_7_final_district.employee_primary_email_address,
			#table_7_final_district.employee_job_name,
			#table_7_final_district.service_name,
			#table_7_final_district.dim_service_key,
			#table_7_final_district.service_id,
			#table_7_final_district.service_code,
			#table_7_final_district.department_name,
			#table_7_final_district.district_name,
			#table_7_final_district.region_name,
			#table_7_final_district.company,
			#table_7_final_district.bosses_employee_id,
			#table_7_final_district.client_team_id,
			#table_7_final_district.client_team_name

 
		 from #table_7_final_district
		 where
		 employee_job_name like 'district man%' 


		 select 
				 distinct 
				 RLS_Type,
				dim_employee_key,
				employee_id,
				employee_primary_email_address,
				employee_job_name,
				service_name,
				dim_service_key,
				service_id,
				service_code,
				department_name,
				district_name,
				region_name,
				company,
				client_team_id,
				client_team_name 
				into #Final_Record_Base
				from #table_6_final_all
		
				where department_name in ('health and disability management','housing services','peer support','peer support services','health and disability peer services')
				 --order by service_name, client_team_name , employee_primary_email_address

		Truncate table edw.row_level_security_base

		Insert into edw.row_level_security_base (RLS_Type,
				dim_employee_key,
				employee_id,
				employee_primary_email_address,
				employee_job_name,
				service_name,
				dim_service_key,
				service_id,
				service_code,
				department_name,
				district_name,
				region_name,
				company,
				client_team_id,
				client_team_name ) 

		 select RLS_Type,
				dim_employee_key,
				employee_id,
				employee_primary_email_address,
				employee_job_name,
				[service_name],
				dim_service_key,
				service_id,
				service_code,
				department_name,
				district_name,
				region_name,
				company,
				client_team_id,
				client_team_name 
			from #Final_Record_Base
		 order by service_name, client_team_name , employee_primary_email_address


end