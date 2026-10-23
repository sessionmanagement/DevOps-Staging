
create view [Staging].[vw_Datapay_pay_slips_net]
as 
select
	 src.[pay_packet_row_id] 	,src.[pay_packet_id] 	,src.[employee_id] 	,src.[net_pay_amount] 	,src.[net_pay_name] 	,src.[net_pay_summary] 	,src.[file_path] 	,src.[company_id] 	,src.[filename] 
from [Landing].[Datapay_pay_slips_net] as src;