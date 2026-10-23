
create view [Staging].[vw_RBMNB_dlFactIncidentStatus]
as 
select
	 src.[IncidentStatusID] 	,src.[IncidentID] 	,src.[IncidentStatusTypeID] 	,src.[IncidentStatusCreatedUserID] 	,src.[IncidentStatusCreatedDate] 	,src.[IncidentStatusRawComment] 	,src.[IncidentStatusHtmlComment] 	,src.[IncidentStatusEndDate] 
from [Landing].[RBMNB_dlFactIncidentStatus] as src;