
/****** Object:  View [ETL].[fact_employee_pay_slip_item]    Script Date: 10/02/2026 9:28:58 am ******/
/****** Object:  View [ETL].[fact_employee_pay_slip_item]    Script Date: 5/02/2026 10:20:17 am ******/



CREATE          view [ETL].[fact_employee_pay_slip_item]

as

/**********************************************************************************************************
 View		[ETL].[fact_employee_pay_slip_item]
 Author		Pankaj Bhatt
 Created	2026-02-05
 Purpose	Used to build the edw.fact_employee_pay_slip_item table
 
 **************************************************************************************************************
--REVISIONS:
--Version	 Date			Author			Description
---------	 ------------	---------------	--------------------------
--1.0		 2026-02-05		Pankaj Bhatt	Initial version

**************************************************************************************************************/

select
	psg.pay_packet_id as pay_packet_id,
	STUFF(psg.pay_packet_row_id, CHARINDEX('_', psg.pay_packet_row_id), 0, '_1') as pay_packet_row_id,
	e.code as employee_id,
	'gross' as item_type,
	psg.gross_amount as item_amount,
	psg.gross_name as item_type_detail,
	psg.gross_summary as item_summary,
	co.code as company_code
from [Datapay].[pay_slips_gross] psg
left outer join [Datapay].[employees] e
on psg.employee_id = e.id
and psg.company_id = e.company_id
and e.ODSIsCurrent = 1
left outer join [Datapay].[companies] co
on psg.company_id = co.company_id
where psg.ODSIsCurrent = 1
--and pay_packet_id = 19118534

UNION ALL

select
	psd.pay_packet_id as pay_packet_id,
	STUFF(psd.pay_packet_row_id, CHARINDEX('_', psd.pay_packet_row_id), 0, '_2') as pay_packet_row_id,
	e.code as employee_id,
	'deduction' as item_type,
	psd.deductions_amount as item_amount,
	psd.deductions_name as item_type_detail,
	psd.deduction_summary as item_summary,
	co.code as company_code
from [Datapay].[pay_slips_deductions] psd
left outer join [Datapay].[employees] e
on psd.employee_id = e.id
and psd.company_id = e.company_id
and e.ODSIsCurrent = 1
left outer join [Datapay].[companies] co
on psd.company_id = co.company_id
where psd.ODSIsCurrent = 1
--and pay_packet_id = 19118534

UNION ALL

select
	psn.pay_packet_id as pay_packet_id,
	STUFF(psn.pay_packet_row_id, CHARINDEX('_', psn.pay_packet_row_id), 0, '_3') as pay_packet_row_id,
	e.code as employee_id,
	'net' as item_type,
	psn.net_pay_amount as item_amount,
	psn.net_pay_name as item_type_detail,
	psn.net_pay_summary as item_summary,
	co.code as company_code
from [Datapay].[pay_slips_net] psn
left outer join [Datapay].[employees] e
on psn.employee_id = e.id
and psn.company_id = e.company_id
and e.ODSIsCurrent = 1
left outer join [Datapay].[companies] co
on psn.company_id = co.company_id
where psn.ODSIsCurrent = 1
--and pay_packet_id = 19118534