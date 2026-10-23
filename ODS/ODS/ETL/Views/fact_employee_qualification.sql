create   VIEW [ETL].[fact_employee_qualification] 

/**********************************************************************************************************
 View		[ETL].[fact_employee_qualification]
 Author		Greg Nuthall / Greg Hubbard
 Created	2025-07-25
 Purpose	Used to build the edw.fact_employee_qualification table
			This script retrieves the most relevant job and qualification details for each person from the 
			IntelliHR schema. It uses a common table expression (CTE) to select the primary or most current 
			job for each person, then joins this with qualification and person data to produce a consolidated 
			view of employee qualifications and their associated job/business unit context. The result includes
			qualification metadata, employee identifiers, and job information for current qualification records.

 **************************************************************************************************************
--REVISIONS:
--Version	Date		  Author			Description
---------	------------  ---------------	--------------------------
--1.0		2025-07-25	  Greg Nuthall		Initial version
--1.1       2025-12-12    Greg Nuthall		Remove test employee id 500001
--1.2       2026-09-18    Malhar Badheka    Added employee qualification requirement flag logic
**************************************************************************************************************/


AS 

	with cte_job_link as (SELECT person_id, businessUnit_name, businessEntity_name, isPrimaryJob, jobStatus
		from (
			select
				j.person_id,
				j.businessUnit_name,
				j.businessEntity_name,
				j.isPrimaryJob,
				j.jobStatus,
				ROW_NUMBER() OVER (
					PARTITION BY j.person_id
					ORDER BY
						j.isPrimaryJob desc,
						case
							when j.jobStatus = 'Current Job' then 1
							when j.jobStatus = 'Future Job' then 2
							when j.jobStatus = 'Ending Job' then 3
							when j.jobStatus = 'Past Job' then 4
							else 5
						end desc
				) AS rn
			from IntelliHR.jobs j
			where j.ODSIsCurrent = 1
		) ranked
		where rn = 1
	)

	select 
	q.qualification_instance_id
	,q.expiry_date
	,q.issue_date
	,q.issuing_organisation
	,q.notes
	,q.person_employeeNumber as employee_id
	,j.businessunit_name as service_name 
	,j.businessEntity_name as company_name
	,q.person_link
	,q.status as qualification_status
	,q.qualification_library_item_id as employee_qualification_library_id
	,case
		when exists (
			select 1
			from IntelliHR.job_requirements jr
			inner join IntelliHR.jobs requirement_job
				on requirement_job.jobs_id = jr.job_id
				and requirement_job.person_id = q.person_id
				and requirement_job.ODSIsCurrent = 1
			left join IntelliHR.job_requirements_groups rg
				on rg.job_requirement_group_id = jr.jobRequriementableId
				and jr.jobRequirementableType = 'JOB_REQUIREMENT_GROUP'
				and rg.ODSIsCurrent = 1
			where jr.ODSIsCurrent = 1
			and case
				when jr.jobRequirementableType = 'JOB_REQUIREMENT_GROUP' then rg.library_item_id
				else jr.jobRequriementableId
			end = q.qualification_library_item_id
		) then 1
		else 0
	end as employee_qualification_requirement_flag
	,i.qualification_type_id as employee_qualification_type_id
	,q.qualification_library_item_link
	,q.registration_number

	from IntelliHR.qualification_instances q
	left outer join IntelliHR.people p 
		on q.person_id = p.people_id 
		and p.ODSIsCurrent = 1
	left outer join IntelliHR.qualification_library_items i 
		on q.qualification_library_item_id = i.qualification_library_items_id
		and i.ODSIsCurrent = 1
	left outer join cte_job_link j
		on p.people_id = j.person_id
	--left outer join IntelliHR.jobs j 
	--	on p.people_id = j.person_id 
	--	and j.ODSIsCurrent = 1  
	where q.ODSIsCurrent = 1
	and q.person_employeeNumber <> '5000001'