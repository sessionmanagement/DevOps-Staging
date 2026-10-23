
create view [Staging].[vw_IntelliHR_people_phone_numbers]
as 
select
	 src.[people_id] 	,src.[number] 	,src.[fullNumber] 	,src.[isPrimary] 	,src.[isPersonal] 	,src.[phoneType] 
from [Landing].[IntelliHR_people_phone_numbers] as src;