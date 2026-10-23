
create view [Staging].[vw_RBEAL_dlFactPersonInteraction]
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
from [Landing].[RBEAL_dlFactPersonInteraction] as src;