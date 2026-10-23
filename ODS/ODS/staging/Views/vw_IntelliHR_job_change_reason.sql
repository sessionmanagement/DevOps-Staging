
create view [Staging].[vw_IntelliHR_job_change_reason]
as 
select
	 src.[job_change_reason_id] 	,src.[name] 	,src.[isEnabled] 
from [Landing].[IntelliHR_job_change_reason] as src;