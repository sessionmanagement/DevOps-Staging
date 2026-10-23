
create view [Staging].[vw_IntelliHR_job_requirements_groups]
as 
select
	 src.[job_requirement_group_id] 	,src.[job_requirement_group_name] 	,src.[job_requirement_usage_count] 	,src.[library_item_id] 	,src.[library_item_name] 
from [Landing].[IntelliHR_job_requirements_groups] as src;
GO

