
create view [Staging].[vw_Outcome_priority_outcome]
as 
select
	 src.[priority_outcome_id] 	,src.[priority_outcome] 	,src.[wellbeing_domain_id] 
from [Landing].[Outcome_priority_outcome] as src;