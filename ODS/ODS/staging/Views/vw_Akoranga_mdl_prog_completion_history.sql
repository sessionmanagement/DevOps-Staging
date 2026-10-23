
create view [Staging].[vw_Akoranga_mdl_prog_completion_history]
as 
select
	 src.[id] 	,src.[program_id] 	,src.[user_id] 	,src.[course_set_id] 	,src.[certif_status] 	,src.[time_started] 	,src.[time_due] 	,src.[time_completed] 	,src.[recurring_course_id] 	,src.[organisation_id] 	,src.[position_id] 
from [Landing].[Akoranga_mdl_prog_completion_history] as src;