/****** Object:  View [ETL].[dim_employee_pay_slip]    Script Date: 10/02/2026 9:26:21 am ******/
/****** Object:  View [ETL].[dim_employee_pay_slip]    Script Date: 5/02/2026 10:19:06 am ******/



CREATE          view [ETL].[dim_employee_pay_slip]

as

/**********************************************************************************************************
 View		[ETL].[dim_employee_pay_slip]
 Author		Pankaj Bhatt
 Created	2026-02-04
 Purpose	Used to build the edw.dim_employee_pay_slip table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-02-04		Pankaj Bhatt	Initial version

**************************************************************************************************************/

select
	ps.pay_packet_id as pay_packet_id,
	ps.pay_packet_type as pay_packet_type,
	ps.dc_date as pay_run_date,
	ps.pay_period_start_date as pay_period_start_date,
	ps.pay_period_end_date as pay_period_end_date,
	co.code as company_code,
	co.[name] as company_name
from [Datapay].[pay_slips] ps
left outer join [Datapay].[companies] co
on ps.company_id = co.company_id
where ps.ODSIsCurrent = 1