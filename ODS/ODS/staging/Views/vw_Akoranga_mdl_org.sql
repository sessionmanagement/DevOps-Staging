
create view [Staging].[vw_Akoranga_mdl_org]
as 
select
	 src.[id] 	,src.[short_name] 	,src.[description] 	,src.[id_number] 	,src.[framework_id] 	,src.[path] 	,src.[parent_id] 	,src.[visible] 	,src.[time_created] 	,src.[time_modified] 	,src.[user_modified] 	,src.[full_name] 	,src.[depth_level] 	,src.[type_id] 	,src.[sort_thread] 	,src.[totara_sync] 
from [Landing].[Akoranga_mdl_org] as src;