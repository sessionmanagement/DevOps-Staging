
create view [Staging].[vw_Datapay_pay_slips]
as 
select
	 src.[pay_packet_id] 	,src.[employee_id] 	,src.[gross_pay_total_amount] 	,src.[deductions_total_amount] 	,src.[net_pay_total_amount] 	,src.[dc_date] 	,src.[pay_period_start_date] 	,src.[pay_period_end_date] 	,src.[pay_packet_type] 	,src.[file_path] 	,src.[company_id] 	,src.[filename] 
from [Landing].[Datapay_pay_slips] as src;