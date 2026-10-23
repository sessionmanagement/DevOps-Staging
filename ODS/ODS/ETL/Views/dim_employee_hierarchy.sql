/****** Object:  View [ETL].[dim_employee_hierarchy]    Script Date: 12/08/2024 8:28:22 am ******/
/**********************************************************************************************************
 View		[ETL].[dim_employee_hierarchy]
 Author		?????
 Created	2023/08/08	
 Purpose	Used to build the edw.dim_employee_hierarchy table 

 **************************************************************************************************************
 1.0 Created
 1.1 Bug 8360 Removed the filter for just current and exiting staff, so fact_employee_renumeration records hold the person_hierarchy link
 1.2 Bug 8386 Add a filter to exclude records where the primaryEmailAddress is null in the __original_jobs CTE

**************************************************************************************************************/

CREATE     VIEW [ETL].[dim_employee_hierarchy]
AS
WITH __original_jobs
AS (
	SELECT person_id
		,person_displayname
		,jobs_id
		,primaryEmailAddress_email
		,[businessEntity_name]
		,businessunit_name
		,supervisorjob_id
		,supervisorperson_id
		,supervisorPerson_displayname
		,employmentstatus
		,person_employeenumber
		,jobs.name AS person_jobname
	FROM INTELLIHR.JOBS
	INNER JOIN intellihr.people ON jobs.person_id = people.people_id
		AND people.odsiscurrent = 1
		AND jobs.ODSIsCurrent = 1
		AND jobs.isPrimaryJob = 1
		AND primaryEmailAddress_email IS NOT NULL   
		--AND employmentStatus IN (
		--	'current staff'
		--	,'exiting staff'
		--	)
	)
-- using DenjobColumnar Column Names
SELECT __original_jobs.person_id AS StaffPerson_id_nk
	,__original_jobs.jobs_id AS StaffJobs_id_nk
	,__original_jobs.person_employeeNumber AS StaffEmployeeNumber
	,__original_jobs.primaryemailaddress_email AS StaffEmail
	,__original_jobs.[businessEntity_name] AS StaffbusinessEntity_name
	,__original_jobs.businessunit_name AS StaffBusiness_unit_name
	,__original_jobs.person_displayname AS StaffDisplayName
	,
	--=====L1 Supervisor Data
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs9.Person_Employeenumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs8.Person_Employeenumber
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs7.Person_Employeenumber
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs6.Person_Employeenumber
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs5.Person_Employeenumber
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs4.Person_Employeenumber
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs3.Person_Employeenumber
		WHEN jobs2.person_displayname IS NOT NULL
			THEN jobs2.Person_Employeenumber
		WHEN __original_jobs.person_displayname IS NOT NULL
			THEN __original_jobs.Person_Employeenumber
		END AS L1Supervisor_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs9.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs8.person_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs7.person_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs6.person_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs5.person_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs4.person_id
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs3.person_id
		WHEN jobs2.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN __original_jobs.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L1SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs9.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs8.jobs_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs7.jobs_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs6.jobs_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs5.jobs_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs4.jobs_id
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs3.jobs_id
		WHEN jobs2.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN __original_jobs.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L1SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs9.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs8.primaryemailaddress_email
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs7.primaryemailaddress_email
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs6.primaryemailaddress_email
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs5.primaryemailaddress_email
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs4.primaryemailaddress_email
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs3.primaryemailaddress_email
		WHEN jobs2.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN __original_jobs.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L1SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs9.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs8.businessunit_name
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs7.businessunit_name
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs6.businessunit_name
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs5.businessunit_name
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs4.businessunit_name
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs3.businessunit_name
		WHEN jobs2.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN __original_jobs.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L1_business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs9.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs8.person_displayname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs7.person_displayname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs6.person_displayname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs5.person_displayname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs4.person_displayname
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs3.person_displayname
		WHEN jobs2.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN __original_jobs.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L1SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs9.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs8.person_jobname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs7.person_jobname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs6.person_jobname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs5.person_jobname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs4.person_jobname
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs3.person_jobname
		WHEN jobs2.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN __original_jobs.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L1SupervisorRoleName
	,
	--Level2
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs8.person_EmployeeNumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs7.person_EmployeeNumber
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs6.person_EmployeeNumber
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs5.person_EmployeeNumber
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs4.person_EmployeeNumber
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs3.person_EmployeeNumber
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs2.person_EmployeeNumber
		WHEN jobs2.person_displayname IS NOT NULL
			THEN __original_jobs.person_EmployeeNumber
		END AS L2SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs8.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs7.person_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs6.person_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs5.person_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs4.person_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs3.person_id
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN jobs2.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L2SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs8.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs7.jobs_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs6.jobs_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs5.jobs_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs4.jobs_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs3.jobs_id
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN jobs2.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L2SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs8.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs7.primaryemailaddress_email
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs6.primaryemailaddress_email
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs5.primaryemailaddress_email
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs4.primaryemailaddress_email
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs3.primaryemailaddress_email
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN jobs2.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L2SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs8.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs7.businessunit_name
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs6.businessunit_name
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs5.businessunit_name
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs4.businessunit_name
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs3.businessunit_name
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN jobs2.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L2business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs8.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs7.person_displayname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs6.person_displayname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs5.person_displayname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs4.person_displayname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs3.person_displayname
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN jobs2.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L2SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs8.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs7.person_jobname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs6.person_jobname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs5.person_jobname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs4.person_jobname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs3.person_jobname
		WHEN jobs3.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN jobs2.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L2SupervisorRoleName
	,
	--===level3
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs7.person_EmployeeNumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs6.person_EmployeeNumber
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs5.person_EmployeeNumber
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs4.person_EmployeeNumber
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs3.person_EmployeeNumber
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs2.person_EmployeeNumber
		WHEN jobs3.person_displayname IS NOT NULL
			THEN __original_jobs.person_EmployeeNumber
		END AS L3SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs7.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs6.person_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs5.person_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs4.person_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs3.person_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN jobs3.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L3SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs7.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs6.jobs_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs5.jobs_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs4.jobs_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs3.jobs_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN jobs3.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L3SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs7.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs6.primaryemailaddress_email
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs5.primaryemailaddress_email
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs4.primaryemailaddress_email
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs3.primaryemailaddress_email
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN jobs3.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L3SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs7.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs6.businessunit_name
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs5.businessunit_name
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs4.businessunit_name
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs3.businessunit_name
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN jobs3.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L3business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs7.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs6.person_displayname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs5.person_displayname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs4.person_displayname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs3.person_displayname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN jobs3.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L3SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs7.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs6.person_jobname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs5.person_jobname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs4.person_jobname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs3.person_jobname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN jobs3.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L3SupervisorRoleName
	,
	--=====level 4
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs6.person_EmployeeNumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs5.person_EmployeeNumber
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs4.person_EmployeeNumber
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs3.person_EmployeeNumber
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs2.person_EmployeeNumber
		WHEN jobs4.person_displayname IS NOT NULL
			THEN __original_jobs.person_EmployeeNumber
		END AS L4SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs6.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs5.person_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs4.person_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs3.person_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L4SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs6.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs5.jobs_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs4.jobs_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs3.jobs_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN jobs4.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L4SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs6.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs5.primaryemailaddress_email
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs4.primaryemailaddress_email
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs3.primaryemailaddress_email
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN jobs4.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L4SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs6.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs5.businessunit_name
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs4.businessunit_name
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs3.businessunit_name
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN jobs4.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L4business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs6.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs5.person_displayname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs4.person_displayname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs3.person_displayname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L4SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs6.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs5.person_jobname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs4.person_jobname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs3.person_jobname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN jobs4.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L4SupervisorRoleName
	,
	--====level 5
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs5.person_EmployeeNumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs4.person_EmployeeNumber
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs3.person_EmployeeNumber
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs2.person_EmployeeNumber
		WHEN jobs5.person_displayname IS NOT NULL
			THEN __original_jobs.person_EmployeeNumber
		END AS L5SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs5.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs4.person_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs3.person_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L5SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs5.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs4.jobs_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs3.jobs_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN jobs5.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L5SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs5.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs4.primaryemailaddress_email
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs3.primaryemailaddress_email
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN jobs5.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L5SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs5.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs4.businessunit_name
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs3.businessunit_name
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN jobs5.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L5business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs5.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs4.person_displayname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs3.person_displayname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L5SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs5.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs4.person_jobname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs3.person_jobname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN jobs5.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L5SupervisorRoleName
	,
	--=====level 6 
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs4.Person_EmployeeNumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs3.Person_EmployeeNumber
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs2.Person_EmployeeNumber
		WHEN jobs6.person_displayname IS NOT NULL
			THEN __original_jobs.Person_EmployeeNumber
		END AS L6SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs4.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs3.person_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L6SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs4.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs3.jobs_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN jobs6.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L6SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs4.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs3.primaryemailaddress_email
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN jobs6.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L6SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs4.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs3.businessunit_name
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN jobs6.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L6business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs4.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs3.person_displayname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L6SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs4.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs3.person_jobname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN jobs6.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L6SupervisorRoleName
	,
	--=====level 7 
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs3.person_EmployeeNumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs2.person_EmployeeNumber
		WHEN jobs7.person_displayname IS NOT NULL
			THEN __original_jobs.person_EmployeeNumber
		END AS L7SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs3.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L7SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs3.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN jobs7.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L7SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs3.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN jobs7.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L7SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs3.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN jobs7.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L7business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs3.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L7SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs3.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN jobs7.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L7SupervisorRoleName
	,
	--===level 8 
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs2.person_EmployeeNumber
		WHEN jobs8.person_displayname IS NOT NULL
			THEN __original_jobs.person_EmployeeNumber
		END AS L8SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs2.person_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L8SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs2.jobs_id
		WHEN jobs8.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L8SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs2.primaryemailaddress_email
		WHEN jobs8.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L8SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs2.businessunit_name
		WHEN jobs8.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L8business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs2.person_displayname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L8SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN jobs2.person_jobname
		WHEN jobs8.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L8SupervisorRoleName
	,
	--======level 9 
	CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN __original_jobs.Person_EmployeeNumber
		END AS L9SupervisorPerson_EmployeeNumber
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN __original_jobs.person_id
		END AS L9SupervisorPerson_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN __original_jobs.jobs_id
		END AS L9SupervisorJob_id_nk
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN __original_jobs.primaryemailaddress_email
		END AS L9SupervisorEmail
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN __original_jobs.businessunit_name
		END AS L9business_unit_name
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN __original_jobs.person_displayname
		END AS L9SupervisorDisplayName
	,CASE 
		WHEN jobs9.person_displayname IS NOT NULL
			THEN __original_jobs.person_jobname
		END AS L9SupervisorRoleName
FROM __original_jobs
LEFT JOIN __original_jobs AS jobs2 ON __original_jobs.supervisorperson_id = jobs2.person_id
LEFT JOIN __original_jobs AS jobs3 ON jobs2.supervisorperson_id = jobs3.person_id
LEFT JOIN __original_jobs AS jobs4 ON jobs3.supervisorperson_id = jobs4.person_id
LEFT JOIN __original_jobs AS jobs5 ON jobs4.supervisorperson_id = jobs5.person_id
LEFT JOIN __original_jobs AS jobs6 ON jobs5.supervisorperson_id = jobs6.person_id
LEFT JOIN __original_jobs AS jobs7 ON jobs6.supervisorperson_id = jobs7.person_id
LEFT JOIN __original_jobs AS jobs8 ON jobs7.supervisorperson_id = jobs8.person_id
LEFT JOIN __original_jobs AS jobs9 ON jobs8.supervisorperson_id = jobs9.person_id


