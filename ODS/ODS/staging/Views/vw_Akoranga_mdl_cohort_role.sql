
create view [Staging].[vw_Akoranga_mdl_cohort_role]
as 
select
	 src.[id] 	,src.[cohort_id] 	,src.[role_id] 	,src.[context_id] 	,src.[time_modified] 	,src.[time_created] 	,src.[user_modified] 
from [Landing].[Akoranga_mdl_cohort_role] as src;