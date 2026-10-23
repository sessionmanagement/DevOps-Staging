
create view [Staging].[vw_EmpLive_roster_entries]
as 
select
	 src.[id] 	,src.[roster_shift_id] 	,src.[employee_id] 	,src.[roster_code_id] 	,src.[pay_interpretation_id] 	,src.[roster_rule_override_reason] 
from [Landing].[EmpLive_roster_entries] as src;