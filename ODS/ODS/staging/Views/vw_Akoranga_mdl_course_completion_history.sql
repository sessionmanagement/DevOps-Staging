
create view [Staging].[vw_Akoranga_mdl_course_completion_history]
as 
select
	 src.[id] 	,src.[course_id] 	,src.[user_id] 	,src.[time_completed] 	,src.[grade] 
from [Landing].[Akoranga_mdl_course_completion_history] as src;