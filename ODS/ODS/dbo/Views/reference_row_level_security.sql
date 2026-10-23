/****** Object:  View [dbo].[reference_row_level_security]    Script Date: 22/02/2024 2:41:50 pm ******/

CREATE               VIEW  [dbo].[reference_row_level_security] 

AS 

WITH CTE as (
-- get a dataset of staff who are supervisor and join it back onto itself so we got supervisor as employees
SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	P.people_id as supervisor_person_id,
	P.employeeNumber as supervisor_employee_number,
	P.displayName as supervisor_display_name,
	J.name as supervisor_job_title,
	P.primaryEmailAddress_email as supervisor_email,
	P.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	0 as hierarchy_level   -- this supervisor to supervisor 

	FROM IntelliHR.jobs as J
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1 and P.isSupervisor = 1
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

UNION

-- get a dataset of employees and their direct manager
SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J.supervisorPerson_id as supervisor_person_id,
	J.supervisorPerson_employeeNumber as supervisor_employee_number,
	J.supervisorPerson_displayName as supervisor_display_name,
	J.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	1 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	left join IntelliHR.people as P1 on J.supervisorPerson_id = P1.people_id and J.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

UNION

-- get a dataset of first level supervisors and their direct manager

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J1.supervisorPerson_id as supervisor_person_id,
	J1.supervisorPerson_employeeNumber as supervisor_employee_number,
	J1.supervisorPerson_displayName as supervisor_display_name,
	J1.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	2 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J1.supervisorPerson_id = P1.people_id and J1.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J1.supervisorPerson_id is not null

UNION

-- get a dataset of second level supervisors and their direct manager
SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J2.supervisorPerson_id as supervisor_person_id,
	J2.supervisorPerson_employeeNumber as supervisor_employee_number,
	J2.supervisorPerson_displayName as supervisor_display_name,
	J2.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	3 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J2.supervisorPerson_id = P1.people_id and J2.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J2.supervisorPerson_id is not null

UNION

-- get a dataset of third level supervisor and their direct manager

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J3.supervisorPerson_id as supervisor_person_id,
	J3.supervisorPerson_employeeNumber as supervisor_employee_number,
	J3.supervisorPerson_displayName as supervisor_display_name,
	J3.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	4 as hierarchy_level


	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.jobs as J3 on J2.supervisorPerson_id = J3.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J3.supervisorPerson_id = P1.people_id and J3.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J3.supervisorPerson_id is not null

UNION

-- get a dataset of fourth level managers and their direct manager

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_status,
	J4.supervisorPerson_id as supervisor_person_id,
	J4.supervisorPerson_employeeNumber as supervisor_employee_number,
	J4.supervisorPerson_displayName as supervisor_display_name,
	J4.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	5 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.jobs as J3 on J2.supervisorPerson_id = J3.person_id
	inner join IntelliHR.jobs as J4 on J3.supervisorPerson_id = J4.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J4.supervisorPerson_id = P1.people_id and J4.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J4.supervisorPerson_id is not null


UNION

-- get a dataset of fifth level managers and their direct manager

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J5.supervisorPerson_id as supervisor_person_id,
	J5.supervisorPerson_employeeNumber as supervisor_employee_number,
	J5.supervisorPerson_displayName as supervisor_display_name,
	J5.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	6 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.jobs as J3 on J2.supervisorPerson_id = J3.person_id
	inner join IntelliHR.jobs as J4 on J3.supervisorPerson_id = J4.person_id
	inner join IntelliHR.jobs as J5 on J4.supervisorPerson_id = J5.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J5.supervisorPerson_id = P1.people_id and J5.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J5.supervisorPerson_id is not null

UNION

-- get a dataset of seventh level managers and their managers

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J6.supervisorPerson_id as supervisor_person_id,
	J6.supervisorPerson_employeeNumber as supervisor_employee_number,
	J6.supervisorPerson_displayName as supervisor_display_name,
	J6.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	7 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.jobs as J3 on J2.supervisorPerson_id = J3.person_id
	inner join IntelliHR.jobs as J4 on J3.supervisorPerson_id = J4.person_id
	inner join IntelliHR.jobs as J5 on J4.supervisorPerson_id = J5.person_id
	inner join IntelliHR.jobs as J6 on J5.supervisorPerson_id = J5.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J6.supervisorPerson_id = P1.people_id and J6.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J6.supervisorPerson_id is not null


UNION

-- get a dataset of eight level managers and their direct manager

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J7.supervisorPerson_id as supervisor_person_id,
	J7.supervisorPerson_employeeNumber as supervisor_employee_number,
	J7.supervisorPerson_displayName as supervisor_display_name,
	J7.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,

	8 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.jobs as J3 on J2.supervisorPerson_id = J3.person_id
	inner join IntelliHR.jobs as J4 on J3.supervisorPerson_id = J4.person_id
	inner join IntelliHR.jobs as J5 on J4.supervisorPerson_id = J5.person_id
	inner join IntelliHR.jobs as J6 on J5.supervisorPerson_id = J5.person_id
	inner join IntelliHR.jobs as J7 on J6.supervisorPerson_id = J7.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J7.supervisorPerson_id = P1.people_id and J7.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J7.supervisorPerson_id is not null


UNION

-- get a dataset of ninth level managers and their direct manager

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	J8.supervisorPerson_id as supervisor_person_id,
	J8.supervisorPerson_employeeNumber as supervisor_employee_number,
	J8.supervisorPerson_displayName as supervisor_display_name,
	J8.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	9 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.jobs as J3 on J2.supervisorPerson_id = J3.person_id
	inner join IntelliHR.jobs as J4 on J3.supervisorPerson_id = J4.person_id
	inner join IntelliHR.jobs as J5 on J4.supervisorPerson_id = J5.person_id
	inner join IntelliHR.jobs as J6 on J5.supervisorPerson_id = J5.person_id
	inner join IntelliHR.jobs as J7 on J6.supervisorPerson_id = J7.person_id
	inner join IntelliHR.jobs as J8 on J7.supervisorPerson_id = J8.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J8.supervisorPerson_id = P1.people_id and J8.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where  J8.supervisorPerson_id is not null


UNION

-- get a dataset of tenth level managers and their direct managers

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	P.people_id,
	P.employmentStatus as employee_status,
	J9.supervisorPerson_id as supervisor_person_id,
	J9.supervisorPerson_employeeNumber as supervisor_employee_number,
	J9.supervisorPerson_displayName as supervisor_display_name,
	J9.supervisorJob_name as supervisor_job_title,
	P1.primaryEmailAddress_email as supervisor_email,
	P1.employmentStatus as supervisor_employment_status,
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	10 as hierarchy_level

	FROM IntelliHR.jobs as J
	inner join IntelliHR.jobs as J1 on J.supervisorPerson_id = J1.person_id
	inner join IntelliHR.jobs as J2 on J1.supervisorPerson_id = J2.person_id
	inner join IntelliHR.jobs as J3 on J2.supervisorPerson_id = J3.person_id
	inner join IntelliHR.jobs as J4 on J3.supervisorPerson_id = J4.person_id
	inner join IntelliHR.jobs as J5 on J4.supervisorPerson_id = J5.person_id
	inner join IntelliHR.jobs as J6 on J5.supervisorPerson_id = J5.person_id
	inner join IntelliHR.jobs as J7 on J6.supervisorPerson_id = J7.person_id
	inner join IntelliHR.jobs as J8 on J7.supervisorPerson_id = J8.person_id
	inner join IntelliHR.jobs as J9 on J8.supervisorPerson_id = J9.person_id
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1
	inner join IntelliHR.people as P1 on J9.supervisorPerson_id = P1.people_id and J9.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1

	where J9.supervisorPerson_id is not null

),
additional_access_cte as (
-- get dataset of staff who are allocated to other services from Datapay
-- and then compare this data to the above dataset so that we get a list 
-- staff who are allocated to other service but have no staff reporting to them

-- NOTE
-- the staff must be flagged as supervisors in IntelliHR
-- we must the Business Central code in the IntelliHR Business Unit which must match the Code in DataPay

SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	J.name as job_title,
	P.primaryEmailAddress_email as employee_email,
	P.people_id,
	P.employmentStatus as employee_employment_status,
	bu_cc.business_unit_id as intellihr_business_unit_id,
	cc.net_home_cost_box_sub_department_code as intellihr_bc_code	

	FROM IntelliHR.jobs as J
	inner join IntelliHR.people as P on J.person_id = P.people_id and J.ODSIsCurrent = 1 and P.ODSIsCurrent = 1 and J.isPrimaryJob = 1 and P.employmentStatus in ('current staff', 'exiting staff')
	left join IntelliHR.people as P1 on J.supervisorPerson_id = P1.people_id and J.ODSIsCurrent = 1 and P1.ODSIsCurrent = 1 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id and bu.ODSIsCurrent = 1
	inner join Datapay.cost_allocations as cc on cc.employee_code = P.employeeNumber and cc.home_costing_percentage > 0 and cc.ODSIsCurrent = 1 and bu.name <> cc.net_home_cost_box_sub_department and bu.code <> cc.net_home_cost_box_sub_department_code
	left join IntelliHR.business_unit as bu_cc on cc.net_home_cost_box_sub_department_code = bu_cc.code and bu_cc.ODSIsCurrent = 1 and cc.ODSIsCurrent = 1

	where P.isSupervisor = 1

	EXCEPT


SELECT 
        supervisor_employee_number  as employee_number
      , supervisor_display_name as  employee_display_name
      , supervisor_job_title as job_title
      , supervisor_email as employee_email
	  , supervisor_person_id as people_id
      , intellihr_business_unit_id
      , intellihr_bc_code
	  , supervisor_employment_status
  FROM CTE
  ), 
	additional_access_rls as (
  select 
	COALESCE(p.employeeNumber, aa.employee_number ) as  [employee_number]
      , COALESCE( p.displayName, aa.employee_display_name  ) as [employee_display_name]
      , COALESCE (p.primaryEmailAddress_email,aa.employee_email  ) as [employee_email]
      , COALESCE( j.name, aa.job_title   )as  [job_title]
      , COALESCE( p.people_id,aa.people_id  ) as [people_id]
	  , p.employmentStatus as employee_employment_status
      , aa.people_id as [supervisor_person_id]
      , aa.employee_number as [supervisor_employee_number]
      , aa.employee_display_name [supervisor_display_name]
      , aa.job_title as [supervisor_job_title]
      , aa.employee_email as [supervisor_email]
	  , aa.employee_employment_status as  supervisor_employment_status
      , aa.intellihr_business_unit_id as [intellihr_business_unit_id]
      , aa.intellihr_bc_code as [business_unit_name]
      , aa.intellihr_bc_code as [intellihr_bc_code]
	  , 99 as hierarchy_level
  
  from additional_access_cte as aa
  left join IntelliHR.jobs as j on j.businessUnit_id = aa.intellihr_business_unit_id and J.ODSIsCurrent = 1
  left join IntelliHR.people as p on p.people_id = j.person_id and p.ODSIsCurrent = 1
  ),

  -- add the additional Row Level Security to the rest
  row_level_security as (
	SELECT
	*
	FROM CTE

	UNION
	
	SELECT
	*
	from additional_access_rls
  
  )


  select * from row_level_security