
create view [Staging].[vw_EmpLive_timesheet_entry_pay_interpretation_time_categories]
as 
select
	 src.[id] 	,src.[timesheet_entry_pay_interpretation_id] 	,src.[time_category_id] 	,src.[duration] 	,src.[pay] 
from [Landing].[EmpLive_timesheet_entry_pay_interpretation_time_categories] as src;