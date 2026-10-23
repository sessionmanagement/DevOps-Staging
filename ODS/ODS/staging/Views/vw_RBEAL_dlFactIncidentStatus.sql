
create view [Staging].[vw_RBEAL_dlFactIncidentStatus]
as 
select
	 src.[IncidentStatusID] 	,src.[IncidentID] 	,src.[IncidentStatusTypeID] 	,src.[IncidentStatusCreatedUserID] 	,src.[IncidentStatusCreatedDate] 	,src.[IncidentStatusRawComment] 	,src.[IncidentStatusHtmlComment] 	,src.[IncidentStatusEndDate] 
from [Landing].[RBEAL_dlFactIncidentStatus] as src;