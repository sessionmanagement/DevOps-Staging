
create view [Staging].[vw_RBEAL_dlFactUserRole]
as 
select
	 src.[UserRoleID] 	,src.[UserID] 	,src.[RoleID] 	,src.[UserRoleCreatedDate] 	,src.[UserRoleCreatedUserID] 
from [Landing].[RBEAL_dlFactUserRole] as src;