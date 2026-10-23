


CREATE    VIEW  [dbo].[row_level_security_intellihr] 

AS 
-- Get a dataset of employees and their direct manager
--Added exiting staff to the row level security
--Added missing business units with zero N/A employee

/****** Object:  View [dbo].[row_level_security_intellihr]    Script Date: 14/03/2024 7:43:53 am ******/
/****** Object:  View [dbo].[row_level_security_intellihr]    Script Date: 14/03/2024 7:25:55 am ******/
/****** Object:  View [ETL].[row_level_security_intellihr]    Script Date: 12/03/2024 12:57:55 pm ******/
/****** Object:  View [ETL].[row_level_security_intellihr]    Script Date: 12/03/2024 7:44:44 am ******/



--Use this to remove employees and just include the manager when there are more than one people in a business unit
With CTE_List_Of_Supervisor as 
	(Select j.supervisorPerson_id, bu.business_unit_id  
	from IntelliHR.business_unit bu
	inner join IntelliHR.business_unit b2 on bu.parentId = b2.business_unit_id
	inner join IntelliHR.jobs j on b2.business_unit_id = J.businessUnit_id
	where b2.ODSIsCurrent = 1
	and bu.ODSIsCurrent = 1
	and J.ODSIsCurrent = 1
	and J.isPrimaryJob = 1
	and j.jobStatus in ('Current Job', 'Future Job','Ending Job')
	group by j.supervisorPerson_id, bu.business_unit_id) 


SELECT
	P.employeeNumber as employee_number,
	P.displayName as employee_display_name,
	P.primaryEmailAddress_email as employee_email,
	J.name as job_title,
	--P.people_id,
	P.employmentStatus as employee_employment_status,
	P.isSupervisor as is_supervisor,
	J.businessEntity_name as company_name,
	--J.supervisorPerson_id as supervisor_person_id,
	J.supervisorPerson_employeeNumber as manager_employee_number,
	J.supervisorPerson_displayName as manager_display_name,
	J.supervisorJob_name as manager_job_title,
	P1.primaryEmailAddress_email as manager_email,
	P1.employmentStatus as manager_employment_status,
	
	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	J.businessEntity_id as intellihr_company_id,
	J.businessEntity_name as intellihr_company_name

	FROM IntelliHR.jobs as J
	inner join IntelliHR.people as P on J.person_id = P.people_id 
	left join IntelliHR.people as P1 on J.supervisorPerson_id = P1.people_id 
	inner join IntelliHR.business_unit as bu on J.businessUnit_id = bu.business_unit_id 

	where J.ODSIsCurrent = 1
	and J.isPrimaryJob = 1
	and P.ODSIsCurrent = 1
	and P1.ODSIsCurrent = 1 
	and bu.ODSIsCurrent = 1	
	and P.employmentStatus in ('Current Staff', 'Future Staff','Exiting Staff')


	Union all  --Add all services without employees linked to the parent business unit and the manager in that parent business unit
	

	Select 0 as employee_number,
	'N/A' as employee_display_name,
	'N/A' as employee_email,
	'N/A' as job_title,
	'' as employee_employment_status,
	p.isSupervisor,
	J.businessEntity_name as company_name,
	
	Case when p.isSupervisor = 1 then p.employeeNumber else J.supervisorPerson_employeeNumber end as manager_employee_number,
	Case when p.isSupervisor = 1 then p.displayName else J.supervisorPerson_displayName end as manager_display_name,
	Case when p.isSupervisor = 1 then j.name else J.supervisorJob_name end as manager_job_title,

	Case when p.isSupervisor = 1 then p.primaryEmailAddress_email else p2.primaryEmailAddress_email end as manager_email,
	Case when p.isSupervisor = 1 then p.employmentStatus else Replace(j.jobStatus,'Job','Staff') end as manager_employment_status,

	bu.business_unit_id as intellihr_business_unit_id,
	bu.name as business_unit_name,
	bu.code as intellihr_bc_code,
	J.businessEntity_id as intellihr_company_id,
	J.businessEntity_name as intellihr_company_name


	from IntelliHR.business_unit bu
	inner join IntelliHR.business_unit b2 on bu.parentId = b2.business_unit_id
	inner join IntelliHR.jobs j on b2.business_unit_id = J.businessUnit_id
	inner join IntelliHR.people p on J.Person_id = p.people_id
	inner join IntelliHR.people p2 on J.supervisorPerson_id = p2.people_id
	left outer join CTE_List_Of_Supervisor s on j.Person_id = s.supervisorPerson_id and bu.business_unit_id = s.business_unit_id

	where b2.ODSIsCurrent = 1
	
	and bu.business_unit_id not in (Select J.businessUnit_id FROM IntelliHR.jobs as J
									inner join IntelliHR.people as P on J.person_id = P.people_id
									where J.ODSIsCurrent = 1
									and J.isPrimaryJob = 1
									and P.ODSIsCurrent = 1
									and P.employmentStatus in ('Current Staff', 'Future Staff','Exiting Staff'))
	

	and bu.ODSIsCurrent = 1
	and J.ODSIsCurrent = 1
	and J.isPrimaryJob = 1
	and p2.ODSIsCurrent = 1
	and p2.employmentStatus in ('Current Staff', 'Future Staff','Exiting Staff')
	and p.employmentStatus in ('Current Staff', 'Future Staff','Exiting Staff')
	and p.ODSIsCurrent = 1
	and j.jobStatus in ('Current Job', 'Future Job','Exiting Job')
	and isnull(s.supervisorPerson_id,'') = ''