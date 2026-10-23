
create view [Staging].[vw_Akoranga_mdl_totara_core_course_vis_map]
as 
select
	 src.[id] 	,src.[course_id] 	,src.[role_id] 
from [Landing].[Akoranga_mdl_totara_core_course_vis_map] as src;