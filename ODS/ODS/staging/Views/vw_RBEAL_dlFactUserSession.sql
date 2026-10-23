CREATE   view [staging].[vw_RBEAL_dlFactUserSession]
as 
select
	 src.[UserSessionID] 
	,src.[UserID] 
	,src.[UserSessionSignOnDate] 
	,src.[UserSessionIPAddress] 
	,src.[UserSessionBrowserName] 
	,src.[UserSessionBrowserVersion] 
	,src.[ApplicationId] 
	,src.[UserSessionUserAgent] 
	,src.[ImpersonatedByUserId] 
	,src.[UserSessionRecordbaseIdentitySignOnSession]
	
from [Landing].[RBEAL_dlFactUserSession] as src
where src.[UserSessionSignOnDate] >= dateadd(month,-3,getdate())