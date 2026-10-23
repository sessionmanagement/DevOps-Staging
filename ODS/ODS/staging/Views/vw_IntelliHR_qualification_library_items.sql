
create view [Staging].[vw_IntelliHR_qualification_library_items]
as 
select
	 src.[qualification_library_items_id] 	,src.[name] 	,src.[qualification_type_id] 	,src.[qualification_type_name] 	,src.[qualification_expiry_type] 	,src.[qualification_registration_number_visibility_type] 	,src.[qualification_attachment_requirement_type] 	,src.[expiry_warning_period] 	,src.[send_expiry_warning] 	,src.[qualification_instance_usage_count] 	,src.[job_requirement_group_usage_count] 	,src.[job_requirement_usage_count] 
from [Landing].[IntelliHR_qualification_library_items] as src;