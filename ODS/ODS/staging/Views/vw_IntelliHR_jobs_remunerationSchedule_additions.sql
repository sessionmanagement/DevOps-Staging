
create view [Staging].[vw_IntelliHR_jobs_remunerationSchedule_additions]
as 
select
	 src.[job_id] 	,src.[name] 	,src.[type] 	,src.[value] 	,src.[currency] 
from [Landing].[IntelliHR_jobs_remunerationSchedule_additions] as src;