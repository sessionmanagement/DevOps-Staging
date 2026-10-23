
create view [Staging].[vw_IntelliHR_business_unit]
as 
select
	 src.[business_unit_id] 	,src.[identifier] 	,src.[name] 	,src.[code] 	,src.[parentId] 	,src.[notes] 	,src.[isEnabled] 
from [Landing].[IntelliHR_business_unit] as src;