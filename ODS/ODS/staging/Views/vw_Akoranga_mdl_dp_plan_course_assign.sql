
create view [Staging].[vw_Akoranga_mdl_dp_plan_course_assign]
as 
select
	 src.[id] 	,src.[plan_id] 	,src.[course_id] 	,src.[priority] 	,src.[due_date] 	,src.[approved] 	,src.[reason_for_decision] 	,src.[completion_status] 	,src.[grade] 	,src.[manual] 
from [Landing].[Akoranga_mdl_dp_plan_course_assign] as src;