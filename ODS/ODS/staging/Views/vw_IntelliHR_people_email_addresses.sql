
create view [Staging].[vw_IntelliHR_people_email_addresses]
as 
select
	 src.[people_id] 	,src.[email] 	,src.[isPrimary] 	,src.[isPersonal] 
from [Landing].[IntelliHR_people_email_addresses] as src;