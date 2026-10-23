
create view [Staging].[vw_EmpLive_static_shifts]
as 
select
	 src.[id] 	,src.[is_active] 	,src.[name] 	,src.[start_time] 	,src.[end_time] 	,src.[service_id] 
from [Landing].[EmpLive_static_shifts] as src;