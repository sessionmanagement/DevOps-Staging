
create view [Staging].[vw_Outcome_specific_outcome]
as 
select
	 src.[specific_outcome_id] 	,src.[specific_outcome] 	,src.[priority_outcome_id] 	,src.[wellbeing_domain_id] 	,src.[relates_to] 	,src.[relates_to_2] 	,src.[relates_to_3] 	,src.[relates_to_4] 
from [Landing].[Outcome_specific_outcome] as src;