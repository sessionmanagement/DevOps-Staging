
create view [Staging].[vw_IntelliHR_jobs_remunerationSchedule_additionsToTotal]
as 
select
	 src.[job_id] 	,src.[name] 	,src.[type] 	,src.[value] 	,src.[currency] 
from [Landing].[IntelliHR_jobs_remunerationSchedule_additionsToTotal] as src;