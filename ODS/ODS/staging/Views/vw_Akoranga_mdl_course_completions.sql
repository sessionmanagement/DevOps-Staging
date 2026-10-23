
create view [Staging].[vw_Akoranga_mdl_course_completions]
as 
select
	 src.[id] 	,src.[user_id] 	,src.[course] 	,src.[organisation_id] 	,src.[position_id] 	,src.[time_enrolled] 	,src.[time_started] 	,src.[time_completed] 	,src.[reaggregate] 	,src.[rpl] 	,src.[rpl_grade] 	,src.[invalidate_cache] 	,src.[status] 	,src.[renewal_status] 	,src.[due_date] 
from [Landing].[Akoranga_mdl_course_completions] as src;