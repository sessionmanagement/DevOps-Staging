
create view [Staging].[vw_Akoranga_mdl_context]
as 
select
	 src.[id] 	,src.[context_level] 	,src.[instance_id] 	,src.[path] 	,src.[depth] 	,src.[parent_id] 	,src.[tenant_id] 
from [Landing].[Akoranga_mdl_context] as src;