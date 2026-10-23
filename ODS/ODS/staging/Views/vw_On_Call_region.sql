
create view [Staging].[vw_On_Call_region]
as 
select
	 src.[region_id] 	,src.[region] 	,src.[region_name] 	,src.[is_active] 
from [Landing].[On_Call_region] as src;