
create view [Staging].[vw_Akoranga_mdl_enrol]
as 
select
	 src.[id] 	,src.[enrol] 	,src.[status] 	,src.[course_id] 	,src.[sortorder] 	,src.[name] 	,src.[enrol_period] 	,src.[enrol_start_date] 	,src.[enrol_end_date] 
from [Landing].[Akoranga_mdl_enrol] as src;