
create view [Staging].[vw_Akoranga_mdl_totara_core_certification_vis_map]
as 
select
	 src.[id] 	,src.[program_id] 	,src.[role_id] 
from [Landing].[Akoranga_mdl_totara_core_certification_vis_map] as src;