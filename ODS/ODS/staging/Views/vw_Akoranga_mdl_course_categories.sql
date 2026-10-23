
create view [Staging].[vw_Akoranga_mdl_course_categories]
as 
select
	 src.[id] 	,src.[name] 	,src.[id_number] 	,src.[description] 	,src.[description_format] 	,src.[parent] 	,src.[sort_order] 	,src.[course_count] 	,src.[visible] 	,src.[visible_old] 	,src.[time_modified] 	,src.[depth] 	,src.[path] 	,src.[theme] 	,src.[program_count] 	,src.[certif_count] 	,src.[is_system] 
from [Landing].[Akoranga_mdl_course_categories] as src;