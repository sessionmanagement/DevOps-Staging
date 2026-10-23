
create view [Staging].[vw_IntelliHR_users]
as 
select
	 src.[users_id] 	,src.[username] 	,src.[isEnabled] 	,src.[createdAt] 	,src.[updatedAt] 	,src.[person_id] 	,src.[person_displayName] 	,src.[person_employeeNumber] 	,src.[person_autoIncrementIntellihrId] 
from [Landing].[IntelliHR_users] as src;