
create view [Staging].[vw_On_Call_service]
as 
select
	 src.[service_id] 	,src.[service_title] 	,src.[service_name] 	,src.[service_manager_id] 	,src.[region_id] 	,src.[author_id] 	,src.[editor_id] 	,src.[is_active] 
from [Landing].[On_Call_service] as src;