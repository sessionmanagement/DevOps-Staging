
create view [Staging].[vw_IntelliHR_recruitment_source]
as 
select
	 src.[recruitment_source_id] 	,src.[name] 	,src.[parentId] 	,src.[isEnabled] 
from [Landing].[IntelliHR_recruitment_source] as src;