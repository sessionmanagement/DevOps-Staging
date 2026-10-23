/****** Object:  View [dbo].[row_level_security_cost_allocations]    Script Date: 14/03/2024 12:27:36 pm ******/
/****** Object:  View [dbo].[row_level_security_cost_allocations]    Script Date: 14/03/2024 8:29:44 am ******/
/****** Object:  View [dbo].[row_level_security_cost_allocations]    Script Date: 14/03/2024 8:28:03 am ******/
/****** Object:  View [dbo].[row_level_security_cost_allocations]    Script Date: 14/03/2024 7:35:39 am ******/
/****** Object:  View [dbo].[row_level_security_cost_allocations]    Script Date: 13/03/2024 3:01:29 pm ******/
/****** Object:  View [dbo].[row_level_security_cost_allocations]    Script Date: 13/03/2024 10:17:40 am ******/
/****** Object:  View [dbo].[row_level_security_cost_allocations]    Script Date: 13/03/2024 8:38:56 am ******/
CREATE                 view [dbo].[row_level_security_cost_allocations]

as

-- using the DataPay cost allocation data join this onto
-- the IntelliHR People data using the employee number
-- then join onto the IntelliHR jobs using the people id and get their primary job
-- restrict the dataset by using ODSIsCurrent =1 as we only care about the current open record
-- and only limit it to only ones that have home cost percentage greater than 0
SELECT
ca.employee_code as employee_number
, p.displayName as displayName
, p.primaryEmailAddress_email as email_address
, j.name as job_title
, p.people_id as intellihr_people_id
, ca.net_home_cost_box_sub_department_code as datapay_cost_center_code
, ca.net_home_cost_box_sub_department as datapay_cost_center_name
, ca.home_costing_percentage as datapay_cost_allocation_percentage
, bu.business_unit_id as intellihr_business_unit_id
, bu.name as intellihr_business_unit_name
, bu.code as intellihr_bc_code
, p.isSupervisor as person_is_supervisor
, j.name as intellihr_job_title
, j.businessEntity_id as intellihr_company_id
, j.businessEntity_name as intellihr_company_name
, p.employmentStatus as person_employeement_status
FROM DataPay.cost_allocations as ca
left join IntelliHR.business_unit as bu on bu.code = ca.net_home_cost_box_sub_department_code and bu.ODSIsCurrent = 1
inner join IntelliHR.people as p on ca.employee_code = p.employeeNumber and P.ODSIsCurrent = 1 
inner join IntelliHR.jobs as j on p.people_id = j.person_id and J.ODSIsCurrent = 1 and J.isPrimaryJob = 1

where CA.ODSIsCurrent = 1
and ca.home_costing_percentage > 0
and P.employmentStatus in ('Current Staff', 'Exiting Staff')