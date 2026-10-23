
create view [Staging].[vw_Akoranga_mdl_user_enrolments]
as 
select
	 src.[id] 	,src.[status] 	,src.[enrol_id] 	,src.[user_id] 	,src.[time_start] 	,src.[time_end] 	,src.[modifier_id] 	,src.[time_created] 	,src.[time_modified] 
from [Landing].[Akoranga_mdl_user_enrolments] as src;