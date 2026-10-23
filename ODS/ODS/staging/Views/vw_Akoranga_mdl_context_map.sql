
create view [Staging].[vw_Akoranga_mdl_context_map]
as 
select
	 src.[id] 	,src.[parent_id] 	,src.[child_id] 
from [Landing].[Akoranga_mdl_context_map] as src;