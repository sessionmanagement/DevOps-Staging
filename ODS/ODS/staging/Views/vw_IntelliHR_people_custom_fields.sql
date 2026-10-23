
create view [Staging].[vw_IntelliHR_people_custom_fields]
as 
select
	 src.[people_id] 	,src.[definition_id] 	,src.[custom_field_name] 	,src.[definition_name] 	,src.[definition_type] 	,src.[definition_value_id] 	,src.[definition_value_label] 
from [Landing].[IntelliHR_people_custom_fields] as src;