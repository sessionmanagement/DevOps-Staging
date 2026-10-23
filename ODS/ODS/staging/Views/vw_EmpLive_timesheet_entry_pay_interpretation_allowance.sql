
create view [Staging].[vw_EmpLive_timesheet_entry_pay_interpretation_allowance]
as 
select
	 src.[id] 	,src.[timesheet_entry_pay_interpretation_id] 	,src.[allowance_id] 	,src.[quantity] 	,src.[actual_quantity] 	,src.[pay] 
from [Landing].[EmpLive_timesheet_entry_pay_interpretation_allowance] as src;