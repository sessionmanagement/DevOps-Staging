
create view [Staging].[vw_RBMNB_dlFactAccountActivityParticipant]
as 
select
	 src.[AccountActivityParticipantID] 	,src.[AccountActivityID] 	,src.[UserID] 	,src.[AccountActivityParticipantCreatedDate] 	,src.[AccountActivityParticipantCreatedUserID] 
from [Landing].[RBMNB_dlFactAccountActivityParticipant] as src;