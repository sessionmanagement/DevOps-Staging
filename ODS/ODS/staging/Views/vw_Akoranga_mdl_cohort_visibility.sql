
create view [Staging].[vw_Akoranga_mdl_cohort_visibility]
as 
select
	 src.[id] 	,src.[cohort_id] 	,src.[instance_id] 	,src.[instance_type] 	,src.[time_modified] 	,src.[time_created] 	,src.[user_modified] 
from [Landing].[Akoranga_mdl_cohort_visibility] as src;