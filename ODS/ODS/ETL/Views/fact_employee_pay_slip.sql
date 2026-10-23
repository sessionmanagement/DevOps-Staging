
/****** Object:  View [ETL].[fact_employee_pay_slip]    Script Date: 10/02/2026 9:28:07 am ******/
/****** Object:  View [ETL].[fact_employee_pay_slip]    Script Date: 5/02/2026 10:20:38 am ******/
/****** Object:  View [ETL].[fact_employee_pay_slip]    Script Date: 5/02/2026 10:19:39 am ******/


CREATE            view [ETL].[fact_employee_pay_slip]

as

/**********************************************************************************************************
 View		[ETL].[fact_employee_pay_slip]
 Author		Pankaj Bhatt
 Created	2026-02-04
 Purpose	Used to build the edw.fact_employee_pay_slip table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-02-04		Pankaj Bhatt	Initial version

**************************************************************************************************************/

select
	ps.pay_packet_id as pay_packet_id,
	e.code as employee_id,
	ps.gross_pay_total_amount as gross_total_amount,
	ps.deductions_total_amount as deduction_total_amount,
	ps.net_pay_total_amount as net_total_amount,
	ps.dc_date as pay_run_date,
	ps.pay_period_start_date as pay_period_start_date,
	ps.pay_period_end_date as pay_period_end_date,
	co.code as company_code
from [Datapay].[pay_slips] ps
left outer join [Datapay].[employees] e
on ps.employee_id = e.id
and ps.company_id = e.company_id
and e.ODSIsCurrent = 1
left outer join [Datapay].[companies] co
on ps.company_id = co.company_id
where ps.ODSIsCurrent = 1