
create view [Staging].[vw_IntelliHR_qualification_instances]
as 
select
	 src.[qualification_instance_id] 	,src.[expiry_date] 	,src.[expiry_notification_queued_at] 	,src.[issue_date] 	,src.[issuing_organisation] 	,src.[notes] 	,src.[person_id] 	,src.[person_display_name] 	,src.[person_employeeNumber] 	,src.[person_auto_increment_intellihr_id] 	,src.[person_link] 	,src.[status] 	,src.[qualification_library_item_id] 	,src.[qualification_library_item_name] 	,src.[qualification_library_item_qualification_type_id] 	,src.[qualification_library_item_qualification_type_name] 	,src.[qualification_library_item_link] 	,src.[registration_number] 
from [Landing].[IntelliHR_qualification_instances] as src;