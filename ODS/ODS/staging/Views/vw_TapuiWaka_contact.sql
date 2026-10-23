
create view [Staging].[vw_TapuiWaka_contact]
as 
select
	 src.[contact_id] 	,src.[login_id] 	,src.[first_name] 	,src.[last_name] 	,src.[email_address] 	,src.[mobile_number_country_code] 	,src.[mobile_number] 	,src.[phone_number_country_code] 	,src.[phone_number] 	,src.[operator_pin_code] 	,src.[service_notification_type] 
from [Landing].[TapuiWaka_contact] as src;