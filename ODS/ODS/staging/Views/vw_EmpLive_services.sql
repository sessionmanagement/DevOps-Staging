
create view [Staging].[vw_EmpLive_services]
as 
select
	 src.[id] 	,src.[reference_number] 	,src.[name] 	,src.[cost_code] 	,src.[entity_id] 	,src.[state] 	,src.[country] 
from [Landing].[EmpLive_services] as src;