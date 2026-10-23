
create view [Staging].[vw_IntelliHR_work_classes]
as 
select
	 src.[work_classes_id] 	,src.[name] 	,src.[isEnabled] 	,src.[worktype_id] 	,src.[worktype_name] 
from [Landing].[IntelliHR_work_classes] as src;