
create view [Staging].[vw_Akoranga_mdl_cohort_members]
as 
select
	 src.[id] 	,src.[cohort_id] 	,src.[user_id] 	,src.[time_added] 
from [Landing].[Akoranga_mdl_cohort_members] as src;