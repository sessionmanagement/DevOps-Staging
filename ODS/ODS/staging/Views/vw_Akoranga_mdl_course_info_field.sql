
create view [Staging].[vw_Akoranga_mdl_course_info_field]
as 
select
	 src.[id] 	,src.[full_name] 	,src.[short_name] 	,src.[data_type] 	,src.[description] 	,src.[sort_order] 	,src.[hidden] 	,src.[locked] 	,src.[required] 	,src.[force_unique] 	,src.[default_data] 	,src.[param_1] 	,src.[param_2] 	,src.[param_3] 	,src.[param_4] 	,src.[param_5] 
from [Landing].[Akoranga_mdl_course_info_field] as src;