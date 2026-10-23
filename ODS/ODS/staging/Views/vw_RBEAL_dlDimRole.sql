
create view [Staging].[vw_RBEAL_dlDimRole]
as 
select
	 src.[RoleID] 	,src.[RoleName] 	,src.[RoleDescription] 
from [Landing].[RBEAL_dlDimRole] as src;