
create view [Staging].[vw_Datapay_pay_slips_deductions]
as 
select
	 src.[pay_packet_row_id] 	,src.[pay_packet_id] 	,src.[employee_id] 	,src.[deductions_amount] 	,src.[deductions_name] 	,src.[deduction_summary] 	,src.[file_path] 	,src.[company_id] 	,src.[filename] 
from [Landing].[Datapay_pay_slips_deductions] as src;