
create view [Staging].[vw_Akoranga_mdl_prog_courseset_course]
as 
select
	 src.[id] 	,src.[courseset_id] 	,src.[course_id] 
from [Landing].[Akoranga_mdl_prog_courseset_course] as src;