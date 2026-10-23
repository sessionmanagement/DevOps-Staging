
create view [Staging].[vw_Akoranga_mdl_facetoface_signups]
as 
select
	 src.[id] 	,src.[session_id] 	,src.[user_id] 	,src.[discount_code] 	,src.[notification_type] 	,src.[archived] 	,src.[booked_by] 	,src.[job_assignment_id] 	,src.[manager_id] 
from [Landing].[Akoranga_mdl_facetoface_signups] as src;