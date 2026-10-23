
create view [Staging].[vw_Akoranga_mdl_prog_courseset]
as 
select
	 src.[id] 	,src.[program_id] 	,src.[sort_order] 	,src.[competency_id] 	,src.[next_set_operator] 	,src.[completion_type] 	,src.[minimum_courses] 	,src.[course_sum_field] 	,src.[course_sum_field_total] 	,src.[time_allowed] 	,src.[recurrence_time] 	,src.[recurring_create_time] 	,src.[content_type] 	,src.[item_label] 	,src.[certif_path] 
from [Landing].[Akoranga_mdl_prog_courseset] as src;