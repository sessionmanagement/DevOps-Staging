
create view [Staging].[vw_RBMNB_dlDimIPMHAPractice]
as 
select
	 src.[IPMHAPracticeID] 	,src.[IPMHAPracticeValue] 	,src.[IPMHAPracticeText] 	,src.[IPMHAPracticeParentId] 	,src.[IPMHAPracticeIsActive] 
from [Landing].[RBMNB_dlDimIPMHAPractice] as src;
GO

