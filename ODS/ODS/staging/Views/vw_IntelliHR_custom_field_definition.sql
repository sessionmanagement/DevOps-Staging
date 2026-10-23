
create view [Staging].[vw_IntelliHR_custom_field_definition]
as 
select
	 src.[custom_field_definition_id] 	,src.[name] 	,src.[type] 	,src.[isEnabled] 	,src.[isSensitive] 	,src.[apiName] 	,src.[modelType] 	,src.[description] 
from [Landing].[IntelliHR_custom_field_definition] as src;