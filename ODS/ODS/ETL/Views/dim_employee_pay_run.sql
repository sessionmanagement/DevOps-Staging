
/****** Object:  View [ETL].[dim_employee_pay_run]    Script Date: 10/02/2026 9:23:12 am ******/
/****** Object:  View [ETL].[dim_employee_pay_run]    Script Date: 5/02/2026 10:18:45 am ******/


CREATE          view [ETL].[dim_employee_pay_run]

as

/**********************************************************************************************************
 View		[ETL].[dim_employee_pay_run]
 Author		Pankaj Bhatt
 Created	2026-02-04
 Purpose	Used to build the edw.dim_employee_pay_run table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-02-04		Pankaj Bhatt	Initial version

**************************************************************************************************************/

select
	pr.pay_run_id as pay_run_id,
	pr.run_type as pay_run_type,
	pr.status as pay_run_status,
	pr.dc_date as pay_run_date,
	pr.pay_period_start_date as pay_period_start_date,
	pr.pay_period_end_date as pay_period_end_date,
	co.code as company_code
from [Datapay].[pay_runs] pr
left outer join [Datapay].[pay_groups] pg
on pr.pay_group_id = pg.paygroup_id
left outer join [Datapay].[companies] co
on pg.company_id = co.company_id
where pr.ODSIsCurrent = 1