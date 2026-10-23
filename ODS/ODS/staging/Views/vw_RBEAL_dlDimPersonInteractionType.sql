
create view [Staging].[vw_RBEAL_dlDimPersonInteractionType]
as 
select
	 src.[PersonInteractionTypeId] 
	,src.[PersonInteractionTypeCode] 
	,src.[PersonInteractionTypeName] 
	,src.[PersonInteractionTypeParentId] 
from [Landing].[RBEAL_dlDimPersonInteractionType] as src;