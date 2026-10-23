
create view [Staging].[vw_IntelliHR_qualification_types]
as 
select
	 src.[qualification_type_id] 	,src.[name] 
from [Landing].[IntelliHR_qualification_types] as src;