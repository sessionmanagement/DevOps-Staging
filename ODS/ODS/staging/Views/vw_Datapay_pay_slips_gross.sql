
create view [Staging].[vw_Datapay_pay_slips_gross]
as 
select
	 src.[pay_packet_row_id] 	,src.[pay_packet_id] 	,src.[employee_id] 	,src.[gross_amount] 	,src.[gross_name] 	,src.[gross_summary] 	,src.[file_path] 	,src.[company_id] 	,src.[filename] 
from [Landing].[Datapay_pay_slips_gross] as src;