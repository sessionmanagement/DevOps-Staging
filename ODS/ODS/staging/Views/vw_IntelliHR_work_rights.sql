
create view [Staging].[vw_IntelliHR_work_rights]
as 
select
	 src.[work_rights_id] 	,src.[name] 	,src.[countryId] 	,src.[country] 
from [Landing].[IntelliHR_work_rights] as src;