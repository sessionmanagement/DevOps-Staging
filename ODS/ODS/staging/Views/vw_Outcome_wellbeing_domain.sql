
create view [Staging].[vw_Outcome_wellbeing_domain]
as 
select
	 src.[wellbeing_domain_id] 	,src.[wellbeing_domain] 
from [Landing].[Outcome_wellbeing_domain] as src;