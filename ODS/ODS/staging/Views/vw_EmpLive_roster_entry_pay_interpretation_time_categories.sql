
create view [Staging].[vw_EmpLive_roster_entry_pay_interpretation_time_categories]
as 
select
	 src.[id] 	,src.[roster_entry_pay_interpretation_id] 	,src.[time_category_id] 	,src.[duration] 	,src.[pay] 
from [Landing].[EmpLive_roster_entry_pay_interpretation_time_categories] as src;