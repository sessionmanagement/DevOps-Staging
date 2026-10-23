
create view [Staging].[vw_IntelliHR_permission_groups]
as 
select
	 src.[permission_groups_id] 	,src.[name] 	,src.[isEnabled] 
from [Landing].[IntelliHR_permission_groups] as src;