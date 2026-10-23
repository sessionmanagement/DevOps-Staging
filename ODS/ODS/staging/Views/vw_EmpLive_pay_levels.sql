
create view [Staging].[vw_EmpLive_pay_levels]
as 
select
	 src.[id] 	,src.[name] 	,src.[cost_code] 	,src.[contract_id] 
from [Landing].[EmpLive_pay_levels] as src;