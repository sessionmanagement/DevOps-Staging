
create view [Staging].[vw_Akoranga_mdl_course_info_data]
as 
select
	 src.[id] 	,src.[field_id] 	,src.[course_id] 	,src.[data] 
from [Landing].[Akoranga_mdl_course_info_data] as src;