
create view [Staging].[vw_EmpLive_roles]
as 
select
	 src.[id] 	,src.[is_active] 	,src.[name] 	,src.[cost_code] 	,src.[comments] 	,src.[contract_id] 
from [Landing].[EmpLive_roles] as src;