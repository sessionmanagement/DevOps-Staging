
create   view [ETL].[fact_employee_pay_run_item]

as

/**********************************************************************************************************
 View		[ETL].[fact_employee_pay_run_item]
 Author		Pankaj Bhatt
 Created	2026-02-05
 Purpose	Used to build the edw.fact_employee_pay_run_item table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-02-05		Pankaj Bhatt	Initial version
--1.1        2026-06-04     Greg Nuthall	Remove unlinked payruns by changing to an inner join
**************************************************************************************************************/

select
	prr.pay_run_id as pay_run_id,
	prr.employee_code as employee_id,
	prr.pay_components_code as pay_component_code,
	prr.pay_components_name as pay_component_name,
	prr.pay_components_category_name as pay_component_category,
	prr.pay_period_start_date as pay_period_start_date,
	prr.pay_period_end_date as pay_period_end_date,
	prr.hours1 as hours_amount,
	prr.total_amount as total_amount,
	prr.pay_run_costing_division_code as division_code,
	prr.pay_run_costing_cost_centre_code as cost_centre_code,
	prr.pay_run_costing_department_code as department_code,
	prr.pay_run_costing_sub_department_code as sub_department_code,
	prr.pay_run_costing_department as department,
	prr.pay_run_costing_sub_department as sub_department,
	prr.remuneration_type as remuneration_type,
	prr.work_classes_name as work_class,
	prr.work_types_name as work_type,
	co.code as company_code
from [Datapay].[pay_run_report] prr
inner join [Datapay].[pay_runs] pr
	on prr.pay_run_id = pr.pay_run_id
	and pr.ODSIsCurrent = 1
left outer join [Datapay].[pay_groups] pg
	on pr.pay_group_id = pg.paygroup_id
left outer join [Datapay].[companies] co
	on pg.company_id = co.company_id
--where prr.pay_run_id = 2703707
--and prr.employee_code = 4861