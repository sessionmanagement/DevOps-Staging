
create view [Staging].[vw_RBEAL_dlDimIPMHARole]
as 
select
	 src.[IPMHARoleID] 	,src.[IPMHARoleValue] 	,src.[IPMHARoleText] 	,src.[IPMHARoleParentId] 	,src.[IPMHARoleIsActive] 
from [Landing].[RBEAL_dlDimIPMHARole] as src;
GO

