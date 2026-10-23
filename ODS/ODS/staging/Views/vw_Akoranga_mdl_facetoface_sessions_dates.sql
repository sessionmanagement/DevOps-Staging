
create view [Staging].[vw_Akoranga_mdl_facetoface_sessions_dates]
as 
select
	 src.[id] 	,src.[session_id] 	,src.[session_timezone] 	,src.[time_start] 	,src.[time_finish] 
from [Landing].[Akoranga_mdl_facetoface_sessions_dates] as src;