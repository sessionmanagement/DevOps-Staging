
create view [Staging].[vw_RBMNB_dlFactUserRole]
as 
select
	 src.[UserRoleID] 	,src.[UserID] 	,src.[RoleID] 	,src.[UserRoleCreatedDate] 	,src.[UserRoleCreatedUserID] 
from [Landing].[RBMNB_dlFactUserRole] as src;