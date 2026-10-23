
create view [Staging].[vw_RBMNB_dlDimPersonInteractionType]
as 
select
	 src.[PersonInteractionTypeId] 
	,src.[PersonInteractionTypeCode] 
	,src.[PersonInteractionTypeName] 
	,src.[PersonInteractionTypeParentId] 
from [Landing].[RBMNB_dlDimPersonInteractionType] as src;