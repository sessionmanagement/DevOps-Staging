
create view [Staging].[vw_RBEAL_dlDimIPMHAPractice]
as 
select
	 src.[IPMHAPracticeID] 	,src.[IPMHAPracticeValue] 	,src.[IPMHAPracticeText] 	,src.[IPMHAPracticeParentId] 	,src.[IPMHAPracticeIsActive] 
from [Landing].[RBEAL_dlDimIPMHAPractice] as src;
GO

