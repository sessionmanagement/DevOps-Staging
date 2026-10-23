
create view [Staging].[vw_RBMNB_dlFactPersonInteraction]
as 
select
	 src.[PersonInteractionId] 
	,src.[PersonId] 
	,src.[PersonInteractionTypeId] 
	,src.[PersonInteractionOccurred] 
	,src.[PersonInteractionComments] 
	,src.[PersonInteractionCommentsHtml] 
	,src.[PersonInteractionCreatedDate] 
	,src.[PersonInteractionCreatedUserID] 
from [Landing].[RBMNB_dlFactPersonInteraction] as src;