
create   procedure [edw].[update_row_level_security_kaimahi]
			
as begin

	/***************************************************************************
	NAME:     [edw].[Update_row_level_security_kaimahi]]
	PURPOSE:  Generate row level security table to be used in Power BI reports
	
	REVISIONS:
	Version	 Date		   Author			Description
	-------	 ------------  ---------------	--------------------------
	1.0		 2026-03-31    Timi Boddington	Initial version

	****************************************************************************/


	IF object_id('tempdb..#hierarchy_start') IS NOT NULL
		DROP TABLE #hierarchy_start

	IF object_id('tempdb..#hierarchy_split') IS NOT NULL
		DROP TABLE #hierarchy_split

	IF object_id('tempdb..#hierarchy_repair') IS NOT NULL
		DROP TABLE #hierarchy_repair

	IF object_id('tempdb..#cost_allocations') IS NOT NULL
		DROP TABLE #cost_allocations

	IF object_id('tempdb..#cost_allocation_employees') IS NOT NULL
		DROP TABLE #cost_allocation_employees

		--===== step 1: take dim_employee_hierarchy and split out the kaimahi's people leaders

	SELECT v.person AS reporting_person,
		t.employee_id AS employee_id
	INTO #hierarchy_split
	FROM edw.dim_employee_hierarchy t
	CROSS APPLY (
		VALUES (employee_people_leader_employee_number_level_1),
			(employee_people_leader_employee_number_level_2),
			(employee_people_leader_employee_number_level_3),
			(employee_people_leader_employee_number_level_4),
			(employee_people_leader_employee_number_level_5),
			(employee_people_leader_employee_number_level_6),
			(employee_people_leader_employee_number_level_7),
			(employee_people_leader_employee_number_level_8)
		) v(person)
	WHERE t.DWHIsCurrent = 1
		AND t.DWHDMLOperation <> 'd'

	
		--==== join in the people leader from dim_employee - or 'boss' as below
	SELECT boss.employee_id,
		boss.employee_primary_email_address,
		#hierarchy_split.employee_id AS mapping_employee_id,
		boss.employee_job_name,
		employee.employee_name,
		employee.employee_job_name AS job_name_employee,
		employee_Business_unit_name AS BU_name
	INTO #hierarchy_repair
	FROM #hierarchy_split
	--=== this is the kaimahi themselves
	INNER JOIN (
		SELECT dim_employee.employee_id,
			employee_primary_email_address,
			employee_name,
			employee_job_name
		FROM edw.dim_employee
		WHERE dim_employee.dwhiscurrent = 1
			AND dim_employee.dwhdmloperation <> 'd'
			AND employee_employment_status IN (
				'current staff',
				'exiting staff'
				)
		) AS employee
		ON #hierarchy_split.employee_id = employee.employee_id
		--==these are their bosses
	INNER JOIN (
		SELECT dim_employee.employee_id,
			employee_primary_email_address,
			employee_job_name
		FROM edw.dim_employee
		WHERE dim_employee.dwhiscurrent = 1
			AND dim_employee.dwhdmloperation <> 'd'
			AND employee_employment_status IN (
				'current staff',
				'exiting staff'
				)
		) AS boss
		ON #hierarchy_split.reporting_person = boss.employee_id
	INNER JOIN (
		SELECT dim_employee_hierarchy.employee_id,
			employee_Business_unit_name
		FROM edw.dim_employee_hierarchy
		WHERE dim_employee_hierarchy.dwhiscurrent = 1
			AND dim_employee_hierarchy.dwhdmloperation <> 'd'
		) AS Hierarchy
		ON #hierarchy_split.reporting_person = Hierarchy.employee_id
	WHERE reporting_person IS NOT NULL

	--================cost allocations -have to bring these kaimahi in
	SELECT 
		fact_employee_cost_allocation.employee_id,
		dim_employee.employee_primary_email_address,
		fact_employee_cost_allocation.intellihr_business_unit_name,
		fact_employee_cost_allocation.job_title,
		dim_employee.employee_name
	INTO #cost_allocations
	FROM edw.fact_employee_cost_allocation
	INNER JOIN edw.dim_employee
		ON fact_employee_cost_allocation.employee_id = dim_employee.employee_id
	WHERE dim_employee.DWHIsCurrent = 1
		AND dim_employee.DWHDMLOperation <> 'd'
		AND fact_employee_cost_allocation.DWHDMLOperation <> 'D'


	--- bringing in cost allocation bosses on BU
	SELECT 
		#cost_allocations.employee_id,
		#cost_allocations.employee_primary_email_address,
		#hierarchy_repair.mapping_employee_id,
		#hierarchy_repair.employee_job_name,
		#hierarchy_repair.employee_name,
		#hierarchy_repair.job_name_employee,
		#hierarchy_repair.BU_Name 
	INTO #cost_allocation_employees
	FROM #hierarchy_repair
	LEFT JOIN #cost_allocations
		ON #hierarchy_repair.BU_name = #cost_allocations.intellihr_business_unit_name
	WHERE job_title LIKE '%service manager%'
		OR job_title LIKE '%team leader%'
		OR job_title LIKE '%district manager%'

	UNION ALL
	--===bosses based on job names - for services
	SELECT testing.employee_id,
		testing.employee_primary_email_address,
		#cost_allocations.employee_id,
		#cost_allocations.job_title,
		#cost_allocations.employee_name,
		#cost_allocations.job_title,
		#cost_allocations.intellihr_business_unit_name
	FROM #cost_allocations
	INNER JOIN (
		SELECT DISTINCT employee_primary_email_address,
			employee_id,
			employee_job_name,
			BU_name
		FROM #hierarchy_repair
		WHERE employee_job_name IN (
				'group chief information officer',
				'group director governance & strategy',
				'Group Director Business Improvement'
				)
		) AS testing
		ON #cost_allocations.intellihr_business_unit_name = testing.BU_name
	WHERE intellihr_business_unit_name IN (
			'it services',
			'GD Business IMprovement',
			'governance and strategy'
			)
		AND job_title NOT LIKE '%service manager%'
		AND job_title NOT LIKE '%team leader%'
		AND job_title NOT LIKE '%district manager%'

	UNION ALL
	--==== bringing in higher types of hierarchy (not SM, TL or DM)
	SELECT testing.employee_id,
		testing.employee_primary_email_address,
		#cost_allocations.employee_id,
		#cost_allocations.job_title,
		#cost_allocations.employee_name,
		#cost_allocations.job_title,
		#cost_allocations.intellihr_business_unit_name
	FROM #cost_allocations
	INNER JOIN (
		SELECT DISTINCT employee_primary_email_address,
			employee_id,
			employee_job_name,
			BU_name
		FROM #hierarchy_repair
		WHERE employee_job_name LIKE '%service manager%'
			OR employee_job_name LIKE '%team leader%'
		) AS testing
		ON #cost_allocations.intellihr_business_unit_name = testing.BU_name
	WHERE intellihr_business_unit_name NOT IN (
			'it services',
			'GD Business IMprovement',
			'governance and strategy'
			)
		AND job_title NOT LIKE '%service manager%'
		AND job_title NOT LIKE '%team leader%'
		AND job_title NOT LIKE '%district manager%'

	--==== note: dim_employee_hierarchy only has an employee once. This is not correct.  A handful are in HF more than once.  
	--as at today - these employees are Julie Hodgson, Ellen Fisher, Morgan Bertinshaw and Praveena Singh.

	Delete from edw.row_level_security_general where RLS_Type = 'Employee';


	Insert into edw.row_level_security_general (
		RLS_Type
		,dim_employee_key 
		,employee_id
		,email
		,mapped_employee_id
		,mapped_employee_name
		,mapped_employee_job_title)


	SELECT DISTINCT
		'Employee' as RLS_Type
		,e.dim_employee_key
		,finaldata.employee_id
		,finaldata.employee_primary_email_address AS email --employee_primary_email_address
		,finaldata.mapping_employee_id AS mapped_employee_id
		,finaldata.employee_name AS mapped_employee_name
		,finaldata.job_name_employee AS mapped_employee_job_title
	FROM (
		SELECT *
		FROM #hierarchy_repair
	

		UNION ALL
	
		SELECT *
		FROM #cost_allocation_employees
		) AS finaldata 
		left outer join edw.dim_employee e on finaldata.employee_id = e.employee_id and e.DWHIsCurrent = 1

	ORDER BY finaldata.employee_primary_email_address,
		finaldata.employee_name

end