
create view [Staging].[vw_EmpLive_service_names]
as 
select
	 src.[id] 	,src.[is_active] 	,src.[reference_number] 	,src.[name] 	,src.[cost_code] 	,src.[service_id] 	,src.[address_1] 	,src.[address_2] 	,src.[suburb] 	,src.[state] 	,src.[post_code] 	,src.[country] 
from [Landing].[EmpLive_service_names] as src;