
create view [Staging].[vw_IntelliHR_users_permission]
as 
select
	 src.[users_id] 	,src.[userPermissionGroups_id] 	,src.[permissionGroup_id] 	,src.[permissionGroup_name] 	,src.[permissionGroup_isEnabled] 
from [Landing].[IntelliHR_users_permission] as src;