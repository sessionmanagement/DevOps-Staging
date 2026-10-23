
create view [Staging].[vw_On_Call_call_log_kaimahi]
as 
select
	 src.[kaimahi_id] 	,src.[kaimahi_name] 	,src.[kaimahi_unique_id] 	,src.[kaimahi_email] 
from [Landing].[On_Call_call_log_kaimahi] as src;