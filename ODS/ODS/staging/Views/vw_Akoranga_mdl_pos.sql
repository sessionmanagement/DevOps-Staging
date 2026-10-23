
create view [Staging].[vw_Akoranga_mdl_pos]
as 
select
	 src.[id] 	,src.[id_number] 	,src.[depth_level] 	,src.[description] 	,src.[framework_id] 	,src.[full_name] 	,src.[parent_id] 	,src.[path] 	,src.[short_name] 	,src.[sort_thread] 	,src.[time_created] 	,src.[time_modified] 	,src.[time_valid_from] 	,src.[time_valid_to] 	,src.[totara_sync] 	,src.[type_id] 	,src.[user_modified] 	,src.[visible] 
from [Landing].[Akoranga_mdl_pos] as src;