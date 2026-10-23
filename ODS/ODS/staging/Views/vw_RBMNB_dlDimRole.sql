
create view [Staging].[vw_RBMNB_dlDimRole]
as 
select
	 src.[RoleID] 	,src.[RoleName] 	,src.[RoleDescription] 
from [Landing].[RBMNB_dlDimRole] as src;