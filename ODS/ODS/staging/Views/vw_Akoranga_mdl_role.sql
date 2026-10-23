
create view [Staging].[vw_Akoranga_mdl_role]
as 
select
	 src.[id] 	,src.[name] 	,src.[short_name] 	,src.[description] 	,src.[sort_order] 	,src.[archetype_id] 
from [Landing].[Akoranga_mdl_role] as src;