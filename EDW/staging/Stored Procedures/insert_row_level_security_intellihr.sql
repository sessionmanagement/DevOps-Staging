

/**********************************************************************************************************
Procedure	[staging].[insert_row_level_security_intellihr]
Purpose	    Process IntelliHR Staff data to create a list of the services a staff member has access too
			base on who they report to which is used for row level security
		
Notes: Call By	SP [staging].[insert_row_level_security]

REVISIONS:
Version	 Date		   Author			    Description
-------	------------  ------------------	--------------------------
1.0		2024-03-26	  Stefen Hasselberg		Inital Creation


**********************************************************************************************************/


CREATE PROCEDURE [staging].[insert_row_level_security_intellihr]

AS 
BEGIN
	SET NOCOUNT ON;
	DECLARE @source_row_count INT
			, @staff_row_count INT
			, @heirarchy_row_count INT

		
-- insert a list of staff with them also as the Supervisor
	INSERT INTO [Staging].[row_level_security] (
			employee_number,
			employee_display_name,
			employee_email,
			job_title,
			employee_employment_status,
			manager_employee_number,
			manager_display_name,
			manager_job_title,
			manager_email,
			manager_employment_status,
			intellihr_business_unit_id,
			business_unit_name,
			intellihr_bc_code,
			intellihr_company_id,
			intellihr_company_name,
			level_hierarchy
		)
	SELECT employee_number,
		employee_display_name,
		employee_email,
		job_title,
		employee_employment_status,
		employee_number AS manager_employee_number,
		employee_display_name AS manager_display_name,
		job_title AS manager_job_title,
		employee_email AS manager_email,
		employee_employment_status AS manager_employment_status,
		intellihr_business_unit_id,
		business_unit_name,
		intellihr_bc_code,
		intellihr_company_id,
		intellihr_company_name,
		0 AS level_hierarchy
	FROM landing.row_level_security_intellihr 

	SET @staff_row_count = @@ROWCOUNT
	
	-- Create a recursive cte to build the staff hierarchy where we use the supervisor person id
	-- to go up the chain until it's null and then insert this into the staging table

		-- the staging list
	;WITH staff_cte AS (
		SELECT employee_number,
			employee_display_name,
			employee_email,
			job_title,
			employee_employment_status,
			manager_employee_number,
			manager_display_name,
			manager_job_title,
			manager_email,
			manager_employment_status,
			intellihr_business_unit_id,
			business_unit_name,
			intellihr_bc_code,
			intellihr_company_id,
			intellihr_company_name,
			1 as level_hierarchy
		FROM landing.row_level_security_intellihr
		UNION ALL
		SELECT s.[employee_number],
			s.[employee_display_name],
			s.[employee_email],
			s.[job_title],
			s.[employee_employment_status],
			m.[manager_employee_number],
			m.[manager_display_name],
			m.[manager_job_title],
			m.[manager_email],
			m.[manager_employment_status],
			s.[intellihr_business_unit_id],
			s.[business_unit_name],
			s.[intellihr_bc_code],
			s.[intellihr_company_id],
			s.[intellihr_company_name],
			s.level_hierarchy + 1 as level_hierarchy
		FROM staff_cte as s
			inner join landing.row_level_security_intellihr as m on s.manager_employee_number = m.employee_number
		WHERE m.manager_employee_number is not null
	) -- insert data from landing table into staging table

	INSERT INTO [Staging].[row_level_security] (
			employee_number,
			employee_display_name,
			employee_email,
			job_title,
			employee_employment_status,
			manager_employee_number,
			manager_display_name,
			manager_job_title,
			manager_email,
			manager_employment_status,
			intellihr_business_unit_id,
			business_unit_name,
			intellihr_bc_code,
			intellihr_company_id,
			intellihr_company_name,
			level_hierarchy
		)
		SELECT employee_number,
			employee_display_name,
			employee_email,
			job_title,
			employee_employment_status,
			manager_employee_number,
			manager_display_name,
			manager_job_title,
			manager_email,
			manager_employment_status,
			intellihr_business_unit_id,
			business_unit_name,
			intellihr_bc_code,
			intellihr_company_id,
			intellihr_company_name,
			level_hierarchy
		FROM staff_cte

		
SET @heirarchy_row_count = @@ROWCOUNT
SELECT @source_row_count =  COUNT(*) from landing.row_level_security_intellihr 



-- Select return parameters as a dataset
select	@source_row_count	as source_row_count
		, @staff_row_count as staff_row_count
		, @heirarchy_row_count as heirarchy_row_count

RETURN
END