
create view [Staging].[vw_IntelliHR_work_types]
as 
select
	 src.[work_types_id] 	,src.[name] 	,src.[isEnabled] 
from [Landing].[IntelliHR_work_types] as src;