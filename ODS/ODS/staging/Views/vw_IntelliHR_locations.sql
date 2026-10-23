
create view [Staging].[vw_IntelliHR_locations]
as 
select
	 src.[locations_id] 	,src.[parentId] 	,src.[name] 	,src.[address] 	,src.[isEnabled] 
from [Landing].[IntelliHR_locations] as src;