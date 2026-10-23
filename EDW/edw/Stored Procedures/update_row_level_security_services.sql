CREATE    procedure [edw].[update_row_level_security_services]
			
as begin

	/***************************************************************************
	NAME:     [edw].[update_row_level_security_services]
	PURPOSE:  Generate row level security table to be used in Power BI reports

	REVISIONS:
	Version	 Date		   Author			Description
	-------	 ------------  ---------------	--------------------------
	1.0		 2026-03-31    Timi Boddington	Initial version
	1.1		 2026-04-23    Timi Boddington	Post checking changes - fixing Lived Experience, Inclusion and Partnership, Practise Team

	****************************************************************************/

	--=====we use this table as an exclusion to work out levels 
--          #table_1_NoDirectReports

		IF OBJECT_ID('tempdb..#table_1_NoDirectReports') IS NOT NULL DROP TABLE #table_1_NoDirectReports;

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
			AND E.[DWHDMLOperation] <> 'D'
			AND E.[employee_primary_email_address] IS NOT NULL
			AND NOT EXISTS (
				SELECT 1
				FROM [edw].[dim_employee_hierarchy] AS E2
				WHERE E2.[employee_id] <> E.[employee_id]
					AND E2.[DWHIsCurrent] = 1
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
		IF OBJECT_ID('tempdb..#table_2_ServiceTable') IS NOT NULL	DROP TABLE #table_2_ServiceTable;

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
			AND is_inactive <> 1
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

		-- #table_3a_Employee_Hierarchy as
		IF OBJECT_ID('tempdb..#table_3a_Employee_Hierarchy') IS NOT NULL DROP TABLE #table_3a_Employee_Hierarchy;

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
		   dim_employee.employee_people_manager_id as bosses_employee_id,
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

		--=================================#table_3b_Employee_Hierarchy 
		--===working out the actual hierarchy using job titles - because the levels are different for Ignite, Tenancy, Property etc 


		IF OBJECT_ID('tempdb..#table_3b_Employee_Hierarchy') IS NOT NULL 	DROP TABLE #table_3b_Employee_Hierarchy;
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
						'group chief information officer'
						)
					THEN 6
				WHEN employee_job_name = 'Business Development Manager' 
					 AND employee_business_unit_name = 'GD Business Improvement' 
					 THEN 6
					WHEN employee_job_name IN (
						'mana whakahaere'
						)
					THEN 3

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
				WHEN --hierarchy_number_0 = 3
					employee_job_name IN (
						'National Housing Manager',
						'National Manager Health & Disability',
						'National Practice Manager',
						'National Tenancy Operations Manager',
						'National Property & Asset Manager'
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

		IF OBJECT_ID('tempdb..#services_part1') IS NOT NULL	DROP TABLE #services_part1

		SELECT 'Original' AS table_type,
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
		INTO #services_part1
		FROM #table_2_ServiceTable
		LEFT JOIN #table_3b_Employee_Hierarchy
			ON rtrim(#table_2_ServiceTable.service_name) = rtrim(#table_3b_Employee_Hierarchy.employee_Business_unit_name)
		WHERE #table_2_ServiceTable.dim_company_key IN (
				1,
				5
				)
	
		UNION ALL

		--====add in cost allocation
		SELECT DISTINCT 'Cost allocation' AS table_type,
			dim_employee_hierarchy_key,
			dim_employee.dim_employee_key,
			fact_employee_cost_allocation.employee_id,
			dim_employee.employee_primary_email_address,
			CASE 
				WHEN employee_primary_email_address LIKE '%mind%body%'
					THEN 'Mind and Body'
				WHEN employee_primary_email_address LIKE '%ignite%'
					THEN 'Ignite'
				ELSE 'Emerge'
				END AS Company,
			intellihr_business_unit_name,
			employee_name,
			CASE 
				WHEN job_title LIKE '%regional manager%'
					THEN 4
				WHEN job_title LIKE '%district manager%'
					THEN 5
				WHEN job_title LIKE '%service manager%'
					OR job_title LIKE '%team leader%housing%'
					THEN 6
				ELSE 7
				END AS hierarchy_number_0,
			'Current Staff' AS employment_status, -- Kaimahi will not exist in this table if they're not current
			job_title,
			--datapay_cost_center_name,
			employee_current_status,
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
			'Emerge' AS company_field,
			CASE 
				WHEN intellihr_business_unit_name LIKE 'tenancy service%'
					OR job_title LIKE '%housing trust%'
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
					OR job_title = 'tenancy manager'
					THEN 'Tenancy'
				WHEN dim_employee.employee_company_name LIKE '%ignite%'
					THEN 'Ignite'
				ELSE 'EAL' -- what EAL means is under Gemma
				END AS RLS_Tenancy_Employees,
			#table_2_ServiceTable.service_name,
			#table_2_ServiceTable.service_id,
			#table_2_ServiceTable.service_code,
			#table_2_ServiceTable.dim_service_key,
			#table_2_ServiceTable.dim_company_key,
			#table_2_ServiceTable.district_name,
			#table_2_ServiceTable.department_name,
			#table_2_ServiceTable.region_name,
			'Emerge' AS company,
			CASE 
				WHEN fact_employee_cost_allocation.intellihr_business_unit_code = 'cm awhi ora'
					AND job_title = 'service manager'
					THEN (
							SELECT DISTINCT employee_id
							FROM edw.dim_employee_hierarchy
							WHERE dwhiscurrent = 1
								AND dwhdmloperation <> 'd'
								--and employee_displayname like 'selwyn t%'
								AND employee_Business_unit_name = 'auckland south mobile district'
								AND employee_people_leader_role_name_level_6 IS NULL
								AND employee_people_leader_role_name_level_5 = 'district manager'
							)
				ELSE bosses_employee_id
				END AS bosses_employee_id
		--INTO #table_4_cost_allocations
		FROM edw.fact_employee_cost_allocation
		LEFT JOIN #table_2_ServiceTable
			ON fact_employee_cost_allocation.intellihr_business_unit_name COLLATE Latin1_General_CI_AI = #table_2_ServiceTable.service_name COLLATE Latin1_General_CI_AI
			and fact_employee_cost_allocation.DWHDMLOperation <> 'd'
		LEFT JOIN edw.dim_employee
			ON fact_employee_cost_allocation.employee_id = dim_employee.employee_id
				AND dim_employee.DWHIsCurrent = 1
				AND dim_employee.DWHDMLOperation <> 'd'
		LEFT JOIN (
			SELECT DISTINCT employee_id,
				bosses_employee_id,
				dim_employee_hierarchy_key,
				dim_employee_key
			FROM #table_3b_Employee_Hierarchy
			) AS employee_stuff
			ON fact_employee_cost_allocation.employee_id = employee_stuff.employee_id


		IF OBJECT_ID('tempdb..#properties') IS NOT NULL	DROP TABLE #properties

		SELECT dim_property.property_id,
			dim_property.property_name,
			dim_property.property_bc_service_code,
			dim_property.property_bc_service_name,
			dim_property.property_contract_bc_service,
			dim_property.property_contract_bc_service_code,
			dim_property.property_property_manager_email,
			dim_property.property_assigned_tenancy_manager,
			coalesce(dim_property_tenancy.property_tenancy_manager_email, dim_employee.employee_primary_email_address) AS property_tenancy_manager_email,
			dim_property_tenancy.property_tenancy_id
		INTO #properties
		FROM edw.dim_property
		LEFT JOIN edw.dim_property_tenancy
			ON dim_property.property_id = dim_property_tenancy.property_id
				AND dim_property_tenancy.DWHIsCurrent = 1
				AND dim_property_tenancy.DWHDMLOperation <> 'd'
				AND dim_property_tenancy.property_tenancy_vacated_date IS NULL
		LEFT JOIN edw.dim_employee
			ON dim_property.property_assigned_tenancy_manager = dim_employee.employee_name
				AND dim_employee.DWHIsCurrent = 1
				AND dim_employee.DWHDMLOperation <> 'd'
		WHERE dim_property.dwhdmloperation <> 'd'
			AND dim_property.dwhiscurrent = 1
			AND dim_property.property_name NOT LIKE '%parent%'
			AND dim_property.property_statecode = 'active'

		IF OBJECT_ID('tempdb..#service_property') IS NOT NULL 	DROP TABLE #service_property
		SELECT DISTINCT *
		INTO #service_property
		FROM #table_2_ServiceTable
		LEFT JOIN #properties
			ON #table_2_ServiceTable.service_code = property_contract_bc_service_code

		IF OBJECT_ID('tempdb..#final_property_tenancy') IS NOT NULL 	DROP TABLE #final_property_tenancy

		SELECT 'property' AS table_type,
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
			#service_property.service_name,
			#service_property.service_id,
			#service_property.service_code,
			#service_property.dim_service_key,
			#service_property.dim_company_key
			---=====hard coding  - there is no other way as district = default which is as useful as....
			,
			CASE 
				WHEN employee_id = 601556
					THEN 'HD Easeup Services'
				ELSE #service_property.district_name
				END AS district_name
			---==========================
			,
			#service_property.department_name,
			#service_property.region_name,
			#service_property.company,
			#service_property.property_name,
			#service_property.property_id,
			#service_property.property_tenancy_id,
			#table_3b_Employee_Hierarchy.bosses_employee_id
		INTO #final_property_tenancy
		FROM #service_property
		INNER JOIN #table_3b_Employee_Hierarchy
			ON #service_property.property_property_manager_email = #table_3b_Employee_Hierarchy.employee_primary_email_address

		UNION ALL

		SELECT 'Tenancy' AS table_type,
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
			#service_property.service_name,
			#service_property.service_id,
			#service_property.service_code,
			#service_property.dim_service_key,
			#service_property.dim_company_key
			---=====hard coding  - there is no other way as district = default which is as useful as....
			,
			CASE 
				WHEN employee_id = 601556
					THEN 'HD Easeup Services'
				ELSE #service_property.district_name
				END AS district_name
			---==========================
			,
			#service_property.department_name,
			#service_property.region_name,
			#service_property.company,
			#service_property.property_name,
			#service_property.property_id,
			#service_property.property_tenancy_id,
			#table_3b_Employee_Hierarchy.bosses_employee_id
		FROM #service_property
		INNER JOIN #table_3b_Employee_Hierarchy
			ON #service_property.property_tenancy_manager_email = #table_3b_Employee_Hierarchy.employee_primary_email_address

		IF OBJECT_ID('tempdb..#table_3d_employee_hierarchy_with_services_final') IS NOT NULL	DROP TABLE #table_3d_employee_hierarchy_with_services_final

		SELECT table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			NULL AS property_name,
			NULL AS property_id,
			NULL AS property_tenancy_id,
			bosses_employee_id
		INTO #table_3d_employee_hierarchy_with_services_final
		FROM #services_part1
		UNION ALL
		SELECT table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		FROM #final_property_tenancy

		--=====================================add a little fudging for everything that doesn't fit

		IF OBJECT_ID('tempdb..#assigned_mnb') IS NOT NULL	DROP TABLE #assigned_mnb
		--==Mind and Body
		SELECT 'Assigned' AS table_type,
			#services_part1.dim_employee_hierarchy_key,
			#services_part1.dim_employee_key,
			#services_part1.employee_id,
			#services_part1.employee_primary_email_address,
			#services_part1.employee_company_name,
			#services_part1.employee_Business_unit_name,
			#services_part1.employee_displayname,
			#services_part1.hierarchy_number_0,
			#services_part1.employee_employment_status,
			#services_part1.employee_job_name,
			#services_part1.employee_current_status,
			#services_part1.hierarchy_number,
			#services_part1.company_field,
			#services_part1.Tenancy_Employees,
			#table_3d_employee_hierarchy_with_services_final.service_name,
			#table_3d_employee_hierarchy_with_services_final.service_id,
			#table_3d_employee_hierarchy_with_services_final.service_code,
			#table_3d_employee_hierarchy_with_services_final.dim_service_key,
			#table_3d_employee_hierarchy_with_services_final.dim_company_key,
			#table_3d_employee_hierarchy_with_services_final.district_name,
			#table_3d_employee_hierarchy_with_services_final.department_name,
			#table_3d_employee_hierarchy_with_services_final.region_name,
			#table_3d_employee_hierarchy_with_services_final.company,
			#table_3d_employee_hierarchy_with_services_final.property_name,
			#table_3d_employee_hierarchy_with_services_final.property_id,
			#table_3d_employee_hierarchy_with_services_final.property_tenancy_id,
			#services_part1.bosses_employee_id
		INTO #assigned_mnb
		FROM #table_3d_employee_hierarchy_with_services_final
		CROSS JOIN #services_part1
		WHERE #table_3d_employee_hierarchy_with_services_final.EMPLOYEE_ID IS NULL
			AND #table_3d_employee_hierarchy_with_services_final.region_name IN (
				'HD Peer Services',
				'Mind and Body'
				)
			--and #table_3d_employee_hierarchy_with_services_final.dim_company_key = 5 -- dunno why have cafe - an old service isn't under company key 5
			AND #services_part1.employee_job_name = 'Operations Manager - Peer Services'
			AND #services_part1.employee_Business_unit_name = 'Peer Services'

		UNION ALL

		SELECT 'Assigned' AS table_type,
			#services_part1.dim_employee_hierarchy_key,
			#services_part1.dim_employee_key,
			#services_part1.employee_id,
			#services_part1.employee_primary_email_address,
			#services_part1.employee_company_name,
			#services_part1.employee_Business_unit_name,
			#services_part1.employee_displayname,
			#services_part1.hierarchy_number_0,
			#services_part1.employee_employment_status,
			#services_part1.employee_job_name,
			#services_part1.employee_current_status,
			#services_part1.hierarchy_number,
			#services_part1.company_field,
			#services_part1.Tenancy_Employees,
			#table_3d_employee_hierarchy_with_services_final.service_name,
			#table_3d_employee_hierarchy_with_services_final.service_id,
			#table_3d_employee_hierarchy_with_services_final.service_code,
			#table_3d_employee_hierarchy_with_services_final.dim_service_key,
			#table_3d_employee_hierarchy_with_services_final.dim_company_key,
			#table_3d_employee_hierarchy_with_services_final.district_name,
			#table_3d_employee_hierarchy_with_services_final.department_name,
			#table_3d_employee_hierarchy_with_services_final.region_name,
			#table_3d_employee_hierarchy_with_services_final.company,
			#table_3d_employee_hierarchy_with_services_final.property_name,
			#table_3d_employee_hierarchy_with_services_final.property_id,
			#table_3d_employee_hierarchy_with_services_final.property_tenancy_id,
			#services_part1.bosses_employee_id
		FROM #table_3d_employee_hierarchy_with_services_final
		CROSS JOIN #services_part1
		WHERE #table_3d_employee_hierarchy_with_services_final.EMPLOYEE_ID IS NULL
			AND #table_3d_employee_hierarchy_with_services_final.dim_company_key = 5
			AND #services_part1.employee_job_name = 'Operations Manager - Peer Services'
			AND #services_part1.employee_Business_unit_name = 'Peer Services'

		--==District
		IF OBJECT_ID('tempdb..#assignedh_D') IS NOT NULL	DROP TABLE #assignedH_d

		SELECT 'Assigned' AS table_type,
			#services_part1.dim_employee_hierarchy_key,
			#services_part1.dim_employee_key,
			#services_part1.employee_id,
			#services_part1.employee_primary_email_address,
			#services_part1.employee_company_name,
			#services_part1.employee_Business_unit_name,
			#services_part1.employee_displayname,
			#services_part1.hierarchy_number_0,
			#services_part1.employee_employment_status,
			#services_part1.employee_job_name,
			#services_part1.employee_current_status,
			#services_part1.hierarchy_number,
			#services_part1.company_field,
			#services_part1.Tenancy_Employees,
			#table_3d_employee_hierarchy_with_services_final.service_name,
			#table_3d_employee_hierarchy_with_services_final.service_id,
			#table_3d_employee_hierarchy_with_services_final.service_code,
			#table_3d_employee_hierarchy_with_services_final.dim_service_key,
			#table_3d_employee_hierarchy_with_services_final.dim_company_key,
			#table_3d_employee_hierarchy_with_services_final.district_name,
			#table_3d_employee_hierarchy_with_services_final.department_name,
			#table_3d_employee_hierarchy_with_services_final.region_name,
			#table_3d_employee_hierarchy_with_services_final.company,
			#table_3d_employee_hierarchy_with_services_final.property_name,
			#table_3d_employee_hierarchy_with_services_final.property_id,
			#table_3d_employee_hierarchy_with_services_final.property_tenancy_id,
			#services_part1.bosses_employee_id
		INTO #assignedH_D
		FROM #table_3d_employee_hierarchy_with_services_final
		LEFT JOIN #services_part1
			ON #table_3d_employee_hierarchy_with_services_final.district_name = #services_part1.district_name
				AND #services_part1.district_name LIKE 'hd%'
				AND #table_3d_employee_hierarchy_with_services_final.employee_displayname IS NULL
				AND #table_3d_employee_hierarchy_with_services_final.dim_company_key <> '5'
		WHERE #table_3d_employee_hierarchy_with_services_final.EMPLOYEE_ID IS NULL
			AND #table_3d_employee_hierarchy_with_services_final.dim_company_key <> 5
			AND #table_3d_employee_hierarchy_with_services_final.service_id NOT IN (
				- 1,
				- 2,
				- 3
				)
			AND #table_3d_employee_hierarchy_with_services_final.district_name LIKE 'hd%'
			--and #table_3d_employee_hierarchy_with_services_final.employee_job_name like '%manager%'
			AND #services_part1.hierarchy_number = 5

		IF OBJECT_ID('tempdb..#assigned_housing') IS NOT NULL 	DROP TABLE #assigned_housing

		SELECT 'Assigned' AS table_type,
			#services_part1.dim_employee_hierarchy_key,
			#services_part1.dim_employee_key,
			#services_part1.employee_id,
			#services_part1.employee_primary_email_address,
			#services_part1.employee_company_name,
			#services_part1.employee_Business_unit_name,
			#services_part1.employee_displayname,
			#services_part1.hierarchy_number_0,
			#services_part1.employee_employment_status,
			#services_part1.employee_job_name,
			#services_part1.employee_current_status,
			#services_part1.hierarchy_number,
			#services_part1.company_field,
			#services_part1.Tenancy_Employees,
			#table_3d_employee_hierarchy_with_services_final.service_name,
			#table_3d_employee_hierarchy_with_services_final.service_id,
			#table_3d_employee_hierarchy_with_services_final.service_code,
			#table_3d_employee_hierarchy_with_services_final.dim_service_key,
			#table_3d_employee_hierarchy_with_services_final.dim_company_key,
			#table_3d_employee_hierarchy_with_services_final.district_name,
			#table_3d_employee_hierarchy_with_services_final.department_name,
			#table_3d_employee_hierarchy_with_services_final.region_name,
			#table_3d_employee_hierarchy_with_services_final.company,
			#table_3d_employee_hierarchy_with_services_final.property_name,
			#table_3d_employee_hierarchy_with_services_final.property_id,
			#table_3d_employee_hierarchy_with_services_final.property_tenancy_id,
			#services_part1.bosses_employee_id
		INTO #assigned_housing
		FROM #table_3d_employee_hierarchy_with_services_final
		LEFT JOIN #services_part1
			ON #table_3d_employee_hierarchy_with_services_final.region_name = #services_part1.region_name
				AND (#services_part1.department_name LIKE '%housing%')
				AND (#services_part1.employee_job_name LIKE '%housing%manager%')
		WHERE #table_3d_employee_hierarchy_with_services_final.EMPLOYEE_ID IS NULL
			AND #table_3d_employee_hierarchy_with_services_final.dim_company_key <> 5
			AND #table_3d_employee_hierarchy_with_services_final.service_id NOT IN (
				- 1,
				- 2,
				- 3
				)
			AND #table_3d_employee_hierarchy_with_services_final.department_name LIKE 'housing%'
			AND #table_3d_employee_hierarchy_with_services_final.region_name LIKE 'housing%'

		IF OBJECT_ID('tempdb..#assigned_tenancy') IS NOT NULL 	DROP TABLE #assigned_tenancy

		SELECT 'Assigned' AS table_type,
			coalesce(#services_part1.dim_employee_hierarchy_key, part2.dim_employee_hierarchy_key) AS dim_employee_hierarchy_key,
			coalesce(#services_part1.dim_employee_key, part2.dim_employee_key) AS dim_employee_key,
			coalesce(#services_part1.employee_id, part2.employee_id) AS employee_id,
			coalesce(#services_part1.employee_primary_email_address, part2.employee_primary_email_address) AS employee_primary_email_address,
			coalesce(#services_part1.employee_company_name, part2.employee_company_name) AS employee_company_name,
			coalesce(#services_part1.employee_Business_unit_name, part2.employee_Business_unit_name) AS employee_Business_unit_name,
			coalesce(#services_part1.employee_displayname, part2.employee_displayname) AS employee_displayname,
			coalesce(#services_part1.hierarchy_number_0, part2.hierarchy_number_0) AS hierarchy_number_0,
			coalesce(#services_part1.employee_employment_status, part2.employee_employment_status) AS employee_employment_status,
			coalesce(#services_part1.employee_job_name, part2.employee_job_name) AS employee_job_name,
			coalesce(#services_part1.employee_current_status, part2.employee_current_status) AS employee_current_status,
			coalesce(#services_part1.hierarchy_number, part2.hierarchy_number) AS hierarchy_number,
			coalesce(#services_part1.company_field, part2.company_field) AS company_field,
			coalesce(#services_part1.Tenancy_Employees, part2.Tenancy_Employees) AS Tenancy_Employees,
			#table_3d_employee_hierarchy_with_services_final.service_name,
			#table_3d_employee_hierarchy_with_services_final.service_id,
			#table_3d_employee_hierarchy_with_services_final.service_code,
			#table_3d_employee_hierarchy_with_services_final.dim_service_key,
			#table_3d_employee_hierarchy_with_services_final.dim_company_key,
			#table_3d_employee_hierarchy_with_services_final.district_name,
			#table_3d_employee_hierarchy_with_services_final.department_name,
			#table_3d_employee_hierarchy_with_services_final.region_name,
			#table_3d_employee_hierarchy_with_services_final.company,
			#table_3d_employee_hierarchy_with_services_final.property_name,
			#table_3d_employee_hierarchy_with_services_final.property_id,
			#table_3d_employee_hierarchy_with_services_final.property_tenancy_id,
			#services_part1.bosses_employee_id
		INTO #Assigned_Tenancy
		FROM #table_3d_employee_hierarchy_with_services_final
		LEFT JOIN #services_part1
			ON #table_3d_employee_hierarchy_with_services_final.region_name = #services_part1.region_name
		--and (#services_part1.department_name like '%housing%')
		--and (#services_part1.employee_job_name like '%housing%manager%')
		LEFT JOIN (
			SELECT DISTINCT *
			FROM #services_part1
			WHERE employee_job_name LIKE '%team leader%'
			) AS part2
			ON replace(replace(#table_3d_employee_hierarchy_with_services_final.region_name, 'tenancy services - midlands', 'tenancy services - central region'), 'tennancy services - central', 'tenancy services - midlands') = replace(part2.region_name, 'tennancy services - central', 'tenancy services - central region')
		WHERE #table_3d_employee_hierarchy_with_services_final.EMPLOYEE_ID IS NULL
			AND #table_3d_employee_hierarchy_with_services_final.dim_company_key <> 5
			AND #table_3d_employee_hierarchy_with_services_final.service_id NOT IN (
				- 1,
				- 2,
				- 3
				)
			AND (#table_3d_employee_hierarchy_with_services_final.region_name LIKE 'ten%ancy%')

		IF OBJECT_ID('tempdb..#assigned_tenancy_2') IS NOT NULL	DROP TABLE #assigned_tenancy_2
		SELECT 'Assigned' AS table_type,
			#services_part1.dim_employee_hierarchy_key,
			#services_part1.dim_employee_key,
			#services_part1.employee_id,
			#services_part1.employee_primary_email_address,
			#services_part1.employee_company_name,
			#services_part1.employee_Business_unit_name,
			#services_part1.employee_displayname,
			#services_part1.hierarchy_number_0,
			#services_part1.employee_employment_status,
			#services_part1.employee_job_name,
			#services_part1.employee_current_status,
			#services_part1.hierarchy_number,
			#services_part1.company_field,
			#services_part1.Tenancy_Employees,
			#assigned_tenancy.service_name,
			#assigned_tenancy.service_id,
			#assigned_tenancy.service_code,
			#assigned_tenancy.dim_service_key,
			#assigned_tenancy.dim_company_key,
			#assigned_tenancy.district_name,
			#assigned_tenancy.department_name,
			#assigned_tenancy.region_name,
			#assigned_tenancy.company,
			#assigned_tenancy.property_name,
			#assigned_tenancy.property_id,
			#assigned_tenancy.property_tenancy_id,
			#services_part1.bosses_employee_id
		INTO #assigned_tenancy_2
		FROM #assigned_tenancy
		LEFT JOIN #services_part1
			ON rtrim(#assigned_tenancy.region_name) = rtrim(#services_part1.region_name)
				AND #services_part1.region_name LIKE '%ten%cy%service%'
				AND #services_part1.employee_job_name LIKE '%leader%'
		WHERE #assigned_tenancy.employee_displayname IS NULL

		IF OBJECT_ID('tempdb..#assigned_tenancy_final') IS NOT NULL	DROP TABLE #assigned_tenancy_final

		SELECT *
		INTO #assigned_tenancy_final
		FROM #assigned_tenancy
		WHERE employee_displayname IS NOT NULL
		UNION ALL
		SELECT *
		FROM #assigned_tenancy_2

		IF OBJECT_ID('tempdb..#leftovers') IS NOT NULL	DROP TABLE #leftovers

		SELECT 'Assigned' AS table_type,
			#services_part1.dim_employee_hierarchy_key,
			#services_part1.dim_employee_key,
			#services_part1.employee_id,
			#services_part1.employee_primary_email_address,
			#services_part1.employee_company_name,
			#services_part1.employee_Business_unit_name,
			#services_part1.employee_displayname,
			#services_part1.hierarchy_number_0,
			#services_part1.employee_employment_status,
			#services_part1.employee_job_name,
			#services_part1.employee_current_status,
			#services_part1.hierarchy_number,
			#services_part1.company_field,
			#services_part1.Tenancy_Employees,
			#table_3d_employee_hierarchy_with_services_final.service_name,
			#table_3d_employee_hierarchy_with_services_final.service_id,
			#table_3d_employee_hierarchy_with_services_final.service_code,
			#table_3d_employee_hierarchy_with_services_final.dim_service_key,
			#table_3d_employee_hierarchy_with_services_final.dim_company_key,
			#table_3d_employee_hierarchy_with_services_final.district_name,
			#table_3d_employee_hierarchy_with_services_final.department_name,
			#table_3d_employee_hierarchy_with_services_final.region_name,
			#table_3d_employee_hierarchy_with_services_final.company,
			#table_3d_employee_hierarchy_with_services_final.property_name,
			#table_3d_employee_hierarchy_with_services_final.property_id,
			#table_3d_employee_hierarchy_with_services_final.property_tenancy_id,
			#services_part1.bosses_employee_id
		INTO #leftovers
		FROM #table_3d_employee_hierarchy_with_services_final
		CROSS JOIN #services_part1
		WHERE #services_part1.employee_job_name = 'Group Chief Financial Officer'
			AND #table_3d_employee_hierarchy_with_services_final.EMPLOYEE_ID IS NULL
			AND #table_3d_employee_hierarchy_with_services_final.dim_company_key <> 5
			AND #table_3d_employee_hierarchy_with_services_final.service_id NOT IN (
				- 1,
				- 2,
				- 3
				)
			AND #table_3d_employee_hierarchy_with_services_final.region_name NOT LIKE 'ten%ancy%'
			AND #table_3d_employee_hierarchy_with_services_final.district_name NOT LIKE 'hd%'
			AND #table_3d_employee_hierarchy_with_services_final.department_name NOT LIKE 'housing%'
			AND #table_3d_employee_hierarchy_with_services_final.region_name NOT LIKE 'housing%'

		--======================bringing themall together
		IF OBJECT_ID('tempdb..#table_3c_Employee_Hierarchy_with_Services') IS NOT NULL
			DROP TABLE #table_3c_Employee_Hierarchy_with_Services;

		SELECT DISTINCT table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		INTO #table_3c_Employee_Hierarchy_with_Services
		FROM #table_3d_employee_hierarchy_with_services_final
		WHERE employee_id IS NOT NULL



		UNION ALL

		SELECT *
		FROM #assigned_mnb

		UNION ALL

		SELECT *
		FROM #leftovers

		UNION ALL

		SELECT *
		FROM #assigned_housing

		UNION ALL

		SELECT *
		FROM #assignedh_D

		UNION ALL

		SELECT *
		FROM #assigned_tenancy_final

		--============
		-- ============================#table_3d_Hierarchy_Level_1_Cross_Join_CEO 
		--making CEO level 7 because not all services have staff but CEO should see them all

		IF OBJECT_ID('tempdb..#table_3d_Hierarchy_Level_1_Cross_Join_CEO') IS NOT NULL
			DROP TABLE #table_3d_Hierarchy_Level_1_Cross_Join_CEO;

		SELECT 'Original' AS table_type,
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
			property_name,
			property_id,
			property_tenancy_id Tenancy_Employees
		INTO #table_3d_Hierarchy_Level_1_Cross_Join_CEO
		FROM #table_3c_Employee_Hierarchy_with_Services
		WHERE hierarchy_number = 1

		--============================#table_3e_Hierarchy_Level_Cross_Join_Result 
		IF OBJECT_ID('tempdb..#table_3e_Hierarchy_Level_Cross_Join_Result') IS NOT NULL	DROP TABLE #table_3e_Hierarchy_Level_Cross_Join_Result;
		SELECT
			--cross join CEO to every service 
			'Original' AS table_type,
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
			#table_3c_Employee_Hierarchy_with_Services.Tenancy_Employees, -- I want the new one
			#table_3c_Employee_Hierarchy_with_Services.service_name,
			#table_3c_Employee_Hierarchy_with_Services.service_id,
			#table_3c_Employee_Hierarchy_with_Services.service_code,
			#table_3c_Employee_Hierarchy_with_Services.dim_service_key,
			#table_3c_Employee_Hierarchy_with_Services.dim_company_key,
			#table_3c_Employee_Hierarchy_with_Services.district_name,
			#table_3c_Employee_Hierarchy_with_Services.department_name,
			#table_3c_Employee_Hierarchy_with_Services.region_name,
			#table_3c_Employee_Hierarchy_with_Services.company,
			'' AS bosses_employee_id,
			#table_3c_Employee_Hierarchy_with_Services.property_name,
			#table_3c_Employee_Hierarchy_with_Services.property_id,
			#table_3c_Employee_Hierarchy_with_Services.property_tenancy_id
		INTO #table_3e_Hierarchy_Level_Cross_Join_Result
		FROM #table_3d_Hierarchy_Level_1_Cross_Join_CEO
		CROSS JOIN #table_3c_Employee_Hierarchy_with_Services

		-- ==================================#table_3_Final_Hierarchy_with_Services as (
		IF OBJECT_ID('tempdb..#table_3_Final_Hierarchy_with_Services_1') IS NOT NULL	DROP TABLE #table_3_Final_Hierarchy_with_Services_1

		SELECT table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		INTO #table_3_Final_Hierarchy_with_Services_1
		FROM #table_3c_Employee_Hierarchy_with_Services
		UNION
		--bring CEO and all their services into the Hierarchy with services.
		SELECT table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		FROM #table_3e_Hierarchy_Level_Cross_Join_Result

		IF OBJECT_ID('tempdb..#table_3_Final_Hierarchy_with_Services') IS NOT NULL	DROP TABLE #table_3_Final_Hierarchy_with_Services;

		SELECT table_type,
			dim_employee_hierarchy_key,
			dim_employee_key,
			#table_3_Final_Hierarchy_with_Services_1.employee_id,
			employee_primary_email_address,
			employee_company_name,
			employee_Business_unit_name,
			employee_displayname,
			hierarchy_number_0,
			employee_employment_status,
			employee_job_name,
			employee_current_status,
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			employee_boss.bosses_employee_id
		INTO #table_3_Final_Hierarchy_with_Services
		FROM #table_3_Final_Hierarchy_with_Services_1
		LEFT JOIN (
			SELECT DISTINCT employee_id,
				bosses_employee_id
			FROM #table_3a_Employee_Hierarchy
			) AS employee_boss
			ON #table_3_Final_Hierarchy_with_Services_1.employee_id = employee_boss.employee_id

		-- ======================#table_5_level_1_CEO 
		IF OBJECT_ID('tempdb..#table_5_level_1_CEO') IS NOT NULL	DROP TABLE #table_5_level_1_CEO;

		SELECT
			table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		INTO #table_5_level_1_CEO
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE hierarchy_number = 1
			AND
			--this is already taken care of above, but will keep this piece of code in anyway
			employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)

		-- =======================#table_5_level_2_Exec as (
		IF OBJECT_ID('tempdb..#table_5_level_2_Exec') IS NOT NULL	DROP TABLE #table_5_level_2_Exec;
		SELECT
	
			table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		INTO #table_5_level_2_Exec
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 2

		-- ===================#table_5_level_3_National_Managers 
		IF OBJECT_ID('tempdb..#table_5_level_3_National_Managers') IS NOT NULL	DROP TABLE #table_5_level_3_National_Managers;
		SELECT
			table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		INTO #table_5_level_3_National_Managers
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 3

		-- =================================#table_5_level_4_Regional_Managers
		IF OBJECT_ID('tempdb..#table_5_level_4_Regional_Managers') IS NOT NULL	DROP TABLE #table_5_level_4_Regional_Managers;
		SELECT

			table_type,
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
			hierarchy_number,
			company_field,
			Tenancy_Employees,
			service_name,
			service_id,
			service_code,
			dim_service_key,
			dim_company_key,
			district_name,
			department_name,
			region_name,
			company,
			property_name,
			property_id,
			property_tenancy_id,
			bosses_employee_id
		INTO #table_5_level_4_Regional_Managers
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 4

		-- ======================== #table_5_level_5_District_Managers
		IF OBJECT_ID('tempdb..#table_5_level_5_District_Managers') IS NOT NULL	DROP TABLE #table_5_level_5_District_Managers;
		SELECT table_type,
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
			bosses_employee_id,
			property_id,
			property_name,
			property_tenancy_id
		INTO #table_5_level_5_District_Managers
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 5


		--===========================table_5_level_6_SMs_TL Service Managers, Team Leaders etc
		IF OBJECT_ID('tempdb..#table_5_level_6_SMs_TL') IS NOT NULL	DROP TABLE #table_5_level_6_SMs_TL;
		SELECT table_type,
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
			bosses_employee_id,
			property_id,
			property_name,
			property_tenancy_id
		INTO #table_5_level_6_SMs_TL
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 6


		--==============================#table_5_level_7_Non_Charge_Employees 
		IF OBJECT_ID('tempdb..#table_5_level_7_Non_Charge_Employees') IS NOT NULL	DROP TABLE #table_5_level_7_Non_Charge_Employees;

		SELECT table_type,
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
			Tenancy_Employees,
			property_id,
			property_name,
			property_tenancy_id
		INTO #table_5_level_7_Non_Charge_Employees
		FROM #table_3_Final_Hierarchy_with_Services
		WHERE employee_employment_status COLLATE Latin1_General_CI_AI IN (
				'Current Staff' COLLATE Latin1_General_CI_AI,
				'Exiting Staff' COLLATE Latin1_General_CI_AI
				)
			AND hierarchy_number = 7


		--=========================================================
		--==== Part 3 -- bringing everything together
		--==========================================================
		--========================table_6_level_7_and_6 connecting level 7 to level 6 ie staff to their service managers or tenancy managers
		IF OBJECT_ID('tempdb..#table_6_level_7_and_6') IS NOT NULL
			DROP TABLE #table_6_level_7_and_6;

			--step 1 take all the lower level employees
		SELECT DISTINCT #table_5_level_7_Non_Charge_Employees.table_type,
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
			#table_5_level_7_Non_Charge_Employees.bosses_employee_id,
			#table_5_level_7_Non_Charge_Employees.property_id,
			#table_5_level_7_Non_Charge_Employees.property_name,
			#table_5_level_7_Non_Charge_Employees.property_tenancy_id
		INTO #table_6_level_7_and_6
		FROM #table_5_level_7_Non_Charge_Employees --====starting with all level 7s - non charge employees

		UNION
		--======take all the SMs and TLs
		SELECT DISTINCT #table_5_level_6_SMs_TL.table_type,
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
			#table_5_level_6_SMs_TL.bosses_employee_id,
			#table_5_level_6_SMs_TL.property_id,
			#table_5_level_6_SMs_TL.property_name,
			#table_5_level_6_SMs_TL.property_tenancy_id
		FROM #table_5_level_6_SMs_TL
		UNION
		---======take the level 6 employees and join to level 7 via boss' employee_id, and take the level 7 services
		SELECT DISTINCT 'Hierarchy' AS table_type,
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
			#table_5_level_6_SMs_TL.bosses_employee_id,
			#table_5_level_7_Non_Charge_Employees.property_id,
			#table_5_level_7_Non_Charge_Employees.property_name,
			#table_5_level_7_Non_Charge_Employees.property_tenancy_id
		FROM #table_5_level_7_Non_Charge_Employees
		INNER JOIN #table_5_level_6_SMs_TL
			ON #table_5_level_7_Non_Charge_Employees.bosses_employee_id = #table_5_level_6_SMs_TL.employee_id

		--),
		--====bringing in district manager's
		--==================#table_6_level_7_and_6_and_5 
		IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5') IS NOT NULL	DROP TABLE #table_6_level_7_and_6_and_5;

			--===take the previous join
		SELECT #table_6_level_7_and_6.table_type,
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
			#table_6_level_7_and_6.bosses_employee_id,
			#table_6_level_7_and_6.property_id,
			#table_6_level_7_and_6.property_name,
			#table_6_level_7_and_6.property_tenancy_id
		INTO #table_6_level_7_and_6_and_5
		FROM #table_6_level_7_and_6

		UNION 
		--====bosses to service 
		-- take the above Kaimahi and join to their bosses - because DMs often have staff and their services which do not follow the Business Unit Hierarchy

		SELECT DISTINCT 'Hierarchy' AS table_type,
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
			#table_5_level_5_District_Managers.bosses_employee_id,
			#table_5_level_6_SMs_TL.property_id,
			#table_5_level_6_SMs_TL.property_name,
			#table_5_level_6_SMs_TL.property_tenancy_id
		FROM #table_5_level_5_District_Managers
		INNER JOIN #table_5_level_6_SMs_TL
			ON #table_5_level_6_SMs_TL.bosses_employee_id = #table_5_level_5_District_Managers.employee_id

		UNION
		--====also join district to district via Business Unit Hierarchy
		SELECT DISTINCT 'District' AS table_type,
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
			#table_5_level_5_District_Managers.bosses_employee_id,
			#table_6_level_7_and_6.property_id,
			#table_6_level_7_and_6.property_name,
			#table_6_level_7_and_6.property_tenancy_id
		FROM #table_5_level_5_District_Managers
		LEFT JOIN #table_6_level_7_and_6
			ON #table_5_level_5_District_Managers.district_name = #table_6_level_7_and_6.district_name
		WHERE #table_5_level_5_District_Managers.Tenancy_Employees = 'eal'
			AND #table_6_level_7_and_6.tenancy_employees = 'eal'
			AND #table_6_level_7_and_6.department_name <> 'owned property'
			AND #table_5_level_5_District_Managers.district_name <> 'default'
			AND #table_6_level_7_and_6.district_name <> 'default'

		UNION
		--===when the above doesn't work, we take the region join by DM's - not every service follows the same patterns, this takes care of that
		SELECT DISTINCT 'Region and Dept' AS table_type,
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
			#table_5_level_5_District_Managers.bosses_employee_id,
			#table_6_level_7_and_6.property_id,
			#table_6_level_7_and_6.property_name,
			#table_6_level_7_and_6.property_tenancy_id
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
		--===district names for tenancy
		SELECT DISTINCT #table_5_level_5_District_Managers.table_type,
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
			#table_5_level_5_District_Managers.bosses_employee_id,
			#table_6_level_7_and_6.property_id,
			#table_6_level_7_and_6.property_name,
			#table_6_level_7_and_6.property_tenancy_id
		FROM #table_5_level_5_District_Managers
		INNER JOIN #table_6_level_7_and_6
			ON #table_5_level_5_District_Managers.district_name = #table_6_level_7_and_6.district_name
		WHERE #table_5_level_5_District_Managers.Tenancy_Employees = 'tenancy'
			AND #table_6_level_7_and_6.tenancy_employees = 'tenancy'

		--=================================#table_6_level_7_and_6_and_5_and_4
		--- adding in regional managers 

		IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4') IS NOT NULL	DROP TABLE #table_6_level_7_and_6_and_5_and_4

		--===step 1 add the above
		SELECT *
		INTO #table_6_level_7_and_6_and_5_and_4
		FROM #table_6_level_7_and_6_and_5

		UNION
		--=====step 2 join by region the regional managers to the above
		--====separate non housing
		SELECT DISTINCT #table_5_level_4_Regional_Managers.table_type,
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
			#table_5_level_4_Regional_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5.property_id,
			#table_6_level_7_and_6_and_5.property_name,
			#table_6_level_7_and_6_and_5.property_tenancy_id
		FROM #table_5_level_4_Regional_Managers
		INNER JOIN #table_6_level_7_and_6_and_5
			ON #table_5_level_4_Regional_Managers.region_name = #table_6_level_7_and_6_and_5.region_name
		WHERE #table_5_level_4_Regional_Managers.Tenancy_Employees = 'eal'
			AND #table_6_level_7_and_6_and_5.tenancy_employees = 'eal'
			AND #table_6_level_7_and_6_and_5.department_name <> 'owned property'

		UNION
		--==separate tenancy
		SELECT DISTINCT #table_5_level_4_Regional_Managers.TABLE_TYPE,
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
			#table_5_level_4_Regional_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5.property_id,
			#table_6_level_7_and_6_and_5.property_name,
			#table_6_level_7_and_6_and_5.property_tenancy_id
		FROM #table_5_level_4_Regional_Managers
		INNER JOIN #table_6_level_7_and_6_and_5
			ON #table_5_level_4_Regional_Managers.region_name = #table_6_level_7_and_6_and_5.region_name
		WHERE #table_5_level_4_Regional_Managers.Tenancy_Employees = 'tenancy'
			AND #table_6_level_7_and_6_and_5.tenancy_employees = 'tenancy'

		--=====================================#table_6_level_7_and_6_and_5_and_4_and_3
		IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4_and_3') IS NOT NULL	DROP TABLE #table_6_level_7_and_6_and_5_and_4_and_3
		--- add the original 
		SELECT *
		INTO #table_6_level_7_and_6_and_5_and_4_and_3
		FROM #table_6_level_7_and_6_and_5_and_4

		UNION
		--- cross join national managers by type
		--==== Health and Disability
		SELECT DISTINCT #table_5_level_3_National_Managers.table_type,
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
			#table_5_level_3_National_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4.property_id,
			#table_6_level_7_and_6_and_5_and_4.property_name,
			#table_6_level_7_and_6_and_5_and_4.property_tenancy_id
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
		SELECT DISTINCT #table_5_level_3_National_Managers.table_type,
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
			#table_5_level_3_National_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4.property_id,
			#table_6_level_7_and_6_and_5_and_4.property_name,
			#table_6_level_7_and_6_and_5_and_4.property_tenancy_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE #table_5_level_3_National_Managers.Tenancy_Employees = 'tenancy'
			AND #table_6_level_7_and_6_and_5_and_4.tenancy_employees = 'tenancy'
			AND #table_6_level_7_and_6_and_5_and_4.department_name not like 'health%disability%'
		UNION
		--====property
		SELECT DISTINCT #table_5_level_3_National_Managers.table_type,
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
			#table_5_level_3_National_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4.property_id,
			#table_6_level_7_and_6_and_5_and_4.property_name,
			#table_6_level_7_and_6_and_5_and_4.property_tenancy_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE #table_5_level_3_National_Managers.Tenancy_Employees = 'property'
			AND #table_6_level_7_and_6_and_5_and_4.tenancy_employees = 'property'
		UNION
		--===housing 
		SELECT DISTINCT #table_5_level_3_National_Managers.table_type,
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
			#table_5_level_3_National_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4.property_id,
			#table_6_level_7_and_6_and_5_and_4.property_name,
			#table_6_level_7_and_6_and_5_and_4.property_tenancy_id
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
				) and #table_6_level_7_and_6_and_5_and_4.property_id is null
		union 
			SELECT DISTINCT #table_5_level_3_National_Managers.table_type,
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
			#table_5_level_3_National_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4.property_id,
			#table_6_level_7_and_6_and_5_and_4.property_name,
			#table_6_level_7_and_6_and_5_and_4.property_tenancy_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE 
			 #table_5_level_3_National_Managers.employee_job_name IN ('national practice manager')
        and #table_5_level_3_National_Managers.service_name = #table_6_level_7_and_6_and_5_and_4.service_name
			union 
			SELECT DISTINCT #table_5_level_3_National_Managers.table_type,
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
			#table_5_level_3_National_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4.property_id,
			#table_6_level_7_and_6_and_5_and_4.property_name,
			#table_6_level_7_and_6_and_5_and_4.property_tenancy_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE 
			 #table_5_level_3_National_Managers.employee_job_name IN ('mana whakahaere')
        and #table_5_level_3_National_Managers.service_name = #table_6_level_7_and_6_and_5_and_4.service_name
			
			union 
			SELECT DISTINCT #table_5_level_3_National_Managers.table_type,
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
			#table_5_level_3_National_Managers.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4.property_id,
			#table_6_level_7_and_6_and_5_and_4.property_name,
			#table_6_level_7_and_6_and_5_and_4.property_tenancy_id
		FROM #table_5_level_3_National_Managers
		CROSS JOIN #table_6_level_7_and_6_and_5_and_4
		WHERE 
			 #table_5_level_3_National_Managers.employee_job_name IN ('mana whakahaere')
			 and #table_5_level_3_National_Managers.employee_id = #table_6_level_7_and_6_and_5_and_4.bosses_employee_id
        
		--==================================#table_6_level_7_and_6_and_5_and_4_and_3_and_2
		--=============adding in level 2 - Execs
		IF OBJECT_ID('tempdb..#table_6_level_7_and_6_and_5_and_4_and_3_and_2') IS NOT NULL	DROP TABLE #table_6_level_7_and_6_and_5_and_4_and_3_and_2

		SELECT *
		INTO #table_6_level_7_and_6_and_5_and_4_and_3_and_2
		FROM #table_6_level_7_and_6_and_5_and_4_and_3
		UNION
		--separate out tenancy and property
		SELECT DISTINCT #table_5_level_2_Exec.table_type,
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
			#table_5_level_2_Exec.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_tenancy_id
		FROM #table_6_level_7_and_6_and_5_and_4_and_3
		CROSS JOIN #table_5_level_2_Exec
		WHERE #table_6_level_7_and_6_and_5_and_4_and_3.Tenancy_Employees IN (
				'tenancy',
				'property'
				)
			AND #table_5_level_2_Exec.Tenancy_Employees IN (
				'tenancy',
				'property'
				) --and #table_6_level_7_and_6_and_5_and_4_and_3.department_name not in ('housing services')
			--and #table_6_level_7_and_6_and_5_and_4_and_3.property_id = 'A04118F5-F895-4970-9DF8-040B09B5CDC8'

		UNION
		--===separate out ignite
		SELECT #table_5_level_2_Exec.table_type,
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
			#table_5_level_2_Exec.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_tenancy_id
		FROM #table_6_level_7_and_6_and_5_and_4_and_3
		CROSS JOIN #table_5_level_2_Exec
		WHERE #table_6_level_7_and_6_and_5_and_4_and_3.Tenancy_Employees IN ('ignite')
			AND #table_5_level_2_Exec.Tenancy_Employees IN ('ignite')
		UNION
		--separate out H&D and Peer Support - MnB
		SELECT #table_5_level_2_Exec.table_type,
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
			#table_5_level_2_Exec.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_id,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_name,
			#table_6_level_7_and_6_and_5_and_4_and_3.property_tenancy_id
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
				'peer suppport',
				'peer support services'
				)

		--=====================================#table_6_final
		--===final table - adding CEO to everything

		IF OBJECT_ID('tempdb..#table_6_part1') IS NOT NULL	DROP TABLE #table_6_part1
		--===cross join CEO
		SELECT DISTINCT #table_5_level_1_CEO.table_type,
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
			9999999 AS bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.property_id,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.property_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.property_tenancy_id
		INTO #table_6_part1
		FROM #table_6_level_7_and_6_and_5_and_4_and_3_and_2
		CROSS JOIN #table_5_level_1_CEO
		UNION
		--===add the above
		SELECT DISTINCT #table_6_level_7_and_6_and_5_and_4_and_3_and_2.table_type,
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
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.bosses_employee_id,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.property_id,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.property_name,
			#table_6_level_7_and_6_and_5_and_4_and_3_and_2.property_tenancy_id
		FROM #table_6_level_7_and_6_and_5_and_4_and_3_and_2

		--========================final Service Table 
		IF OBJECT_ID('tempdb..#table_6_part2') IS NOT NULL	DROP TABLE #table_6_part2
		--==== I'm adding in Tenancy Program and Sub Program because it may be useful for RLS depending on what you're doing
		SELECT DISTINCT dim_employee_key,
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
			#table_6_part1.property_id,
			#table_6_part1.property_name,
			#table_6_part1.property_tenancy_id,
			dim_property.property_sub_program,
			dim_property.property_program
		INTO #table_6_part2
		FROM #table_6_part1
		LEFT JOIN edw.dim_property
			ON #table_6_part1.property_id = dim_property.property_id
				AND dwhiscurrent = 1
				AND dwhdmloperation <> 'd'

		--=====================
		--====services
		IF OBJECT_ID('tempdb..#table_6_final') IS NOT NULL	DROP TABLE #table_6_final

		--===RLS for Services
		SELECT DISTINCT 'Service' AS table_type,
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
			NULL AS property_id,
			NULL AS property_name,
			NULL AS property_program,
			NULL AS property_sub_program,
			NULL AS property_tenancy_id
		INTO #table_6_final
		FROM #table_6_part2
		WHERE employee_job_name IN (
				'general manager housing trust',
				'Team Leader - Tenancy Management',
				'tenancy manager',
				'national property & asset manager',
				'senior tenancy manager',
				'General Maintenance Support',
				'facilities coordinator',
				'National Tenancy Operations Manager',
				'Regional Asset Portfolio Manager'
				)
			AND department_name NOT LIKE 'health%disability%'
			AND region_name LIKE 'ten%services%'
		UNION ALL
		SELECT DISTINCT 'Service' AS table_type,
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
			NULL AS property_id,
			NULL AS property_name,
			NULL AS property_program,
			NULL AS property_sub_program,
			NULL AS property_tenancy_id
		FROM #table_6_part2
		WHERE employee_job_name NOT IN (
				'general manager housing trust',
				'Team Leader - Tenancy Management',
				'tenancy manager',
				'national property & asset manager',
				'senior tenancy manager',
				'General Maintenance Support',
				'facilities coordinator',
				'National Tenancy Operations Manager',
				'Regional Asset Portfolio Manager'
				)

		UNION ALL
		--===RLS for properties
		SELECT DISTINCT 'Property' AS table_type,
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
			property_id,
			property_name,
			property_program,
			property_sub_program,
			NULL AS property_tenancy_id
		FROM #table_6_part2
		WHERE department_name NOT IN (
				'health and disability',
				'shared services',
				'Health and Disability Peer Services',
				'Peer Support',
				'Health and Disability Management',
				'Peer Support Services'
				)
			AND property_id IS NOT NULL
		UNION ALL
		--==RLS for tenancy
		SELECT DISTINCT 'Tenancy' AS table_type,
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
			property_id,
			property_name,
			property_program,
			property_sub_program,
			property_tenancy_id
		FROM #table_6_part2
		WHERE department_name NOT IN (
				'health and disability',
				'shared services',
				'Health and Disability Peer Services',
				'Peer Support',
				'Health and Disability Management',
				'Peer Support Services'
				)
			AND property_tenancy_id IS NOT NULL

	--====final output
	--====I've added in hierarchy list - if you don't want Kaimahi who are not SMs etc and above, filter out level 7
		
		delete from edw.row_level_security_general where RLS_Type in ('Tenancy','Service','Property')

		Insert into edw.row_level_security_general (RLS_Type,
				dim_employee_key,
				employee_id,
				email,
				dim_service_key,
				service_id,
				dim_company_key,
				dim_property_key,
				property_id,
				dim_property_tenancy_key,
				property_tenancy_id,
				employee_level_for_exclusion) 
	
	
		SELECT	table_type,
				dim_employee_key,
				employee_id,
				employee_primary_email_address,
				dim_service_key,
				service_id,
				--service_name , 
				case when company = 'Emerge' then 1
				     when company like '%Mind%Body%' then 5
					 when company like '%Ignite%' then 4
					 else 1
			    end as dim_company_key,
				p.dim_property_key,
				f.property_id,
				t.dim_property_tenancy_key,
				f.property_tenancy_id,
				CASE 
					WHEN employee_id IN (
							SELECT employee_id
							FROM #table_5_level_1_CEO
							)
						THEN 1
					WHEN employee_id IN (
							SELECT employee_id
							FROM #table_5_level_2_Exec
							)
						THEN 2
					WHEN employee_id IN (
							SELECT employee_id
							FROM #table_5_level_3_National_Managers
							)
						THEN 3
					WHEN employee_id IN (
							SELECT employee_id
							FROM #table_5_level_4_Regional_Managers
							)
						THEN 4
					WHEN employee_id IN (
							SELECT employee_id
							FROM #table_5_level_5_District_Managers
							)
						THEN 5
					WHEN employee_id IN (
							SELECT employee_id
							FROM #table_5_level_6_SMs_TL
							)
						THEN 6
					WHEN employee_id IN (
							SELECT employee_id
							FROM #table_5_level_7_Non_Charge_Employees
							)
						THEN 7
					ELSE 99 --catch all for checking.  this shouldn't exist.  If it does it needs fixing
					END AS employee_level_for_exclusion
					
			
			FROM #table_6_final f
			left outer join edw.dim_property p on f.property_id = p.property_id and p.DWHIsCurrent = 1
			left outer join edw.dim_property_tenancy t on f.property_tenancy_id = t.property_tenancy_id and t.DWHIsCurrent = 1
		
			ORDER BY table_type,
			employee_primary_email_address,
			service_name

		
End