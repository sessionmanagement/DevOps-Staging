
create view [Staging].[vw_IntelliHR_people_addresses]
as 
select
	 src.[people_id] 	,src.[addressType] 	,src.[fullAddress] 	,src.[country] 	,src.[postcode] 	,src.[state] 	,src.[street] 	,src.[suburb] 	,src.[isPrimary] 
from [Landing].[IntelliHR_people_addresses] as src;