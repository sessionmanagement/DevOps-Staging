
create view [Staging].[vw_RBEAL_dlFactAccountActivityParticipant]
as 
select
	 src.[AccountActivityParticipantID] 	,src.[AccountActivityID] 	,src.[UserID] 	,src.[AccountActivityParticipantCreatedDate] 	,src.[AccountActivityParticipantCreatedUserID] 
from [Landing].[RBEAL_dlFactAccountActivityParticipant] as src;