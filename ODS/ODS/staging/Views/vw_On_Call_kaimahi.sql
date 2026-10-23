
create view [Staging].[vw_On_Call_kaimahi]
as 
select
	 src.[kaimahi_id] 	,src.[kaimahi_name] 	,src.[user_email] 	,src.[region_1_id] 	,src.[region_1_name] 	,src.[region_2_id] 	,src.[region_2_name] 	,src.[region_3_id] 	,src.[region_3_name] 
from [Landing].[On_Call_kaimahi] as src;