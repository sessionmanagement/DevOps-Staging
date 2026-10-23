
create view [Staging].[vw_IntelliHR_custom_field_definition_option]
as 
select
	 src.[custom_field_definition_id] 	,src.[custom_field_definition_option_id] 	,src.[label] 
from [Landing].[IntelliHR_custom_field_definition_option] as src;