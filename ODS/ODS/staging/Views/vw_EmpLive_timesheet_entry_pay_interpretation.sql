
create view [Staging].[vw_EmpLive_timesheet_entry_pay_interpretation]
as 
select
	 src.[id] 	,src.[pay_level_id] 	,src.[employment_type] 	,src.[shift] 
from [Landing].[EmpLive_timesheet_entry_pay_interpretation] as src;