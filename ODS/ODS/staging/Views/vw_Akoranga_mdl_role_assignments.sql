
create view [Staging].[vw_Akoranga_mdl_role_assignments]
as 
select
	 src.[id] 	,src.[role_id] 	,src.[context_id] 	,src.[user_id] 	,src.[time_modified] 	,src.[modifier_id] 	,src.[component] 	,src.[item_id] 	,src.[sortorder] 
from [Landing].[Akoranga_mdl_role_assignments] as src;