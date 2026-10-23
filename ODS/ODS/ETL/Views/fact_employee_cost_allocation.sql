
CREATE   view [ETL].[fact_employee_cost_allocation]

as

/**********************************************************************************************************
 View		[ETL].[fact_employee_cost_allocation]
 Author		Pankaj Bhatt
 Created	2026-03-03
 Purpose	Used to build the edw.fact_employee_cost_allocation table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-03-03		Pankaj Bhatt	Initial version
--1.1		 2026-04-14		Pankaj Bhatt	Added distinct for defensive coding against duplicte data coming from Source/Landing
--1.2        2026-10-22     Greg Nuthall    Avoid duplicates with a cte rather than a distinct 
**************************************************************************************************************/


with cost_allocations as (
    select employee_code
         , net_home_cost_box_sub_department_code
         , net_home_cost_box_sub_department
         , home_costing_percentage
    from (
        select ca.employee_code
             , ca.net_home_cost_box_sub_department_code
             , ca.net_home_cost_box_sub_department
             , ca.home_costing_percentage
             , row_number() over (
                   partition by ca.employee_code
                              , ca.net_home_cost_box_sub_department_code
                              , ca.net_home_cost_box_sub_department
                              
                   order by ca.ODSEffectiveFrom desc, ca.home_costing_percentage  
               ) as rn
        from DataPay.cost_allocations as ca
        where ca.ODSIsCurrent = 1
    ) as x
    where x.rn = 1
)


SELECT
ca.employee_code as employee_id
, bu.business_unit_id as intellihr_business_unit_id
, bu.code as intellihr_business_unit_code
, bu.name as intellihr_business_unit_name
, ca.net_home_cost_box_sub_department_code as datapay_cost_center_code
, ca.net_home_cost_box_sub_department as datapay_cost_center_name
, ca.home_costing_percentage as cost_allocation_percentage
, p.isSupervisor as person_is_supervisor
, j.name as job_title
, j.businessEntity_id as company_id

FROM cost_allocations as ca
left join IntelliHR.business_unit as bu on (bu.code = ca.net_home_cost_box_sub_department_code or bu.name = ca.net_home_cost_box_sub_department) and bu.ODSIsCurrent = 1
inner join IntelliHR.people as p on ca.employee_code = p.employeeNumber and p.ODSIsCurrent = 1 
inner join IntelliHR.jobs as j on p.people_id = j.person_id and j.ODSIsCurrent = 1 and j.isPrimaryJob = 1

where ca.home_costing_percentage > 0
--and p.employmentStatus in ('Current Staff', 'Exiting Staff')