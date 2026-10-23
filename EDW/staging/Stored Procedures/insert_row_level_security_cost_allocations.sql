
/**********************************************************************************************************
Procedure	[staging].[insert_row_level_security_cost_allocations]
Purpose	    Process Cost Allocation data to which is list of staff who are allocated a percentage to another 
			service in DataPay so they need to be add to the row level security
		
Notes: Call By	SP [staging].[insert_row_level_security]

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-03-26	  Stefen Hasselberg		Inital Creation


**********************************************************************************************************/



CREATE PROCEDURE [staging].[insert_row_level_security_cost_allocations]

AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @source_row_count INT
			, @staff_row_count INT
			, @manager_row_count INT

	-- as list of employees and the cost allocations person as the manager
INSERT INTO staging.row_level_security (
		[employee_number],
		[employee_display_name],
		[employee_email],
		[job_title],
		[employee_employment_status],
		[manager_employee_number],
		[manager_display_name],
		[manager_job_title],
		[manager_email],
		[manager_employment_status],
		[intellihr_business_unit_id],
		[business_unit_name],
		[intellihr_bc_code],
		[intellihr_company_id],
		[intellihr_company_name],
		[level_hierarchy]
	)
SELECT rlsi.employee_number,
	rlsi.employee_display_name,
	rlsi.employee_email,
	rlsi.job_title,
	rlsi.employee_employment_status,
	cc.employee_number as manager_employee_number,
	cc.displayName as manager_display_name,
	cc.intellihr_job_title as manager_job_title,
	cc.email_address,
	cc.person_employeement_status as manager_employment_status,
	rlsi.intellihr_business_unit_id,
	rlsi.business_unit_name,
	rlsi.intellihr_bc_code,
	rlsi.intellihr_company_id,
	rlsi.intellihr_company_name,
	20 AS [level_hierarchy]
FROM landing.row_level_security_cost_allocations as cc
	LEFT JOIN landing.row_level_security_intellihr as rlsi on rlsi.intellihr_business_unit_id = cc.intellihr_business_unit_id
WHERE cc.person_is_supervisor = 1
	AND rlsi.is_supervisor = 0 

-- Get a count of rows we have insert for cost allocations
SET @staff_row_count = @@ROWCOUNT
	
-- Insert the Cost Allocation Service Manager as themselves as the Employee for the additional services
INSERT INTO staging.row_level_security (
		[employee_number],
		[employee_display_name],
		[employee_email],
		[job_title],
		[employee_employment_status],
		[manager_employee_number],
		[manager_display_name],
		[manager_job_title],
		[manager_email],
		[manager_employment_status],
		[intellihr_business_unit_id],
		[business_unit_name],
		[intellihr_bc_code],
		[intellihr_company_id],
		[intellihr_company_name],
		[level_hierarchy]
	)
SELECT employee_number,
	displayName AS employee_display_name,
	email_address AS employee_email,
	job_title,
	person_employeement_status AS employee_employment_status,
	employee_number AS manager_employee_number,
	displayName AS manager_display_name,
	intellihr_job_title AS manager_job_title,
	email_address AS manager_email,
	person_employeement_status AS manager_employment_status,
	intellihr_business_unit_id,
	intellihr_business_unit_name,
	intellihr_bc_code,
	intellihr_company_id,
	intellihr_company_name,
	20 AS level_hierarchy
FROM landing.row_level_security_cost_allocations


-- Get a count of rows we have insert for cost allocations 
SET @manager_row_count = @@ROWCOUNT


SELECT @source_row_count =  COUNT(*) from landing.row_level_security_cost_allocations

-- Select return parameters as a dataset
select	@source_row_count	as source_row_count
		, @staff_row_count as staff_row_count
		, @manager_row_count as manager_row_count


RETURN

END