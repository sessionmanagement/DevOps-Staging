
create view [Staging].[vw_IntelliHR_business_entities]
as 
select
	 src.[business_entities_id] 	,src.[name] 	,src.[legalName] 	,src.[number] 	,src.[isEnabled] 
from [Landing].[IntelliHR_business_entities] as src;